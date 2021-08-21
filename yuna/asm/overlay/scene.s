
;==============================================================================
; required defines
;==============================================================================

;.ifndef ovlBatStr_fullStringPrint_offset
;  .fail
;.endif

;==============================================================================
; various overwrites and patches
;==============================================================================

;=============================
; sprite clear subtitle exclusion
;=============================

.bank 0 slot 0
.orga clearAndSendSpriteTable+($755D-$755D)
.section "sprite clear subtitle exclusion 1" SIZE 13 overwrite
  clearAndSendSubtitleExclusionOverwrite:
    jsr ovlScene_jumpTable_setUpStdBanks
    jmp spriteClearAndSendExcludeSubtitles
  
  clearOnlySubtitleExclusionOverwrite:
    jsr ovlScene_jumpTable_setUpStdBanks
    jmp spriteClearExcludeSubtitles
.ends

.bank 0 slot 0
.section "sprite clear subtitle exclusion 2" free

  spriteClearExcludeSubtitles:
    bsr doSpecialSpriteClear
    @done:
    jmp ovlScene_jumpTable_restoreOldBanks
  
  spriteClearAndSendExcludeSubtitles:
    bsr doSpecialSpriteClear
    
    lda subtitleDisplayOn.w
    bne +
      ; if subs are off, do the normal BIOS SAT->SATB call.
      ; if subs are on, we know they'll be constantly
      ; refreshing the SATB in the VSYNC handler, so we
      ; can just wait for that to happen.
      jsr $E09F
    +:
    
    ; make up work
    stz spriteTableClearMakeup1.w
    stz spriteTableClearMakeup2.w
    
    bra spriteClearExcludeSubtitles@done
  
  doSpecialSpriteClear:
    ; if subs are off, just do the normal BIOS clear
    lda subtitleDisplayOn.w
    bne +
    @doStandardClear:
      jmp $E0A2
    +:
    
    inc triggerNonSubtitleSpriteClear.w
    rts
  
  triggerNonSubtitleSpriteClear:
    .db $00
.ends

;=============================
; high-priority sprite object offset logic
;=============================

.bank 0 slot 0
.orga genHighPrioritySpriteObj+($4D86-$4D74)
.section "fix high-priority sprite obj generation 1" SIZE 9 overwrite
  jsr ovlScene_jumpTable_setUpStdBanks
  jsr setUpHighPrioritySpriteGen
  jmp genHighPrioritySpriteObj+($4D92-$4D74)
.ends

.bank 0 slot 0
.section "fix high-priority sprite obj generation 2" free
  ; TODO
  lowPrioritySpriteObjGenerationOffset:
    .db $00
    
  ; any high-priority sprite objects the game generates will be offset
  ; from their normal position in the SAT by this many attribute entries
  highPrioritySpriteObjGenerationOffset:
    .db $00
    
  setUpHighPrioritySpriteGen:
    ; set up VRAM write
    lda highPrioritySpriteObjGenerationOffset.w
    ; the normal target is the start of the SAT at $7F00;
    ; we want to offset this address by (4*spriteOffset)
    asl
    asl
    sta @vramWriteAddrLoCmd+1.w
    
    st0 #$00
    @vramWriteAddrLoCmd:
    st1 #$00
    st2 #$7F
    st0 #$02
    
    ; set up sprite cap
    lda #$20
    ; subtract off the offset count
    sec
    sbc highPrioritySpriteObjGenerationOffset.w
    sta $003B
    
    jmp ovlScene_jumpTable_restoreOldBanks
.ends

;=============================
; auto-busy skip
;=============================
  
.ifdef enable_sceneAutoBusySkip
  .bank 0 slot 0
  .orga genHighPrioritySpriteObj+($4E0F-$4D74)
  .section "auto busy skip high priority 1" SIZE 9 overwrite
    jsr ovlScene_jumpTable_setUpStdBanks
    jsr doHighPriorityObjAutoBusySkipCheck
    jmp genHighPrioritySpriteObj+($4E23-$4D74)
  .ends
  
  .bank 0 slot 0
  .section "auto busy skip high priority 2" free
    doHighPriorityObjAutoBusySkipCheck:
      ; flag draw for this frame
      inc highPrioritySpriteObjDrawnThisFrame.w
      
      ; make up work
      st0 #$13
      st1 #$00
      st2 #$7F
      ; srcaddr += 8
      lda genHighPrioritySpriteObj+($4D9A-$4D74).w
      clc 
      adc #$08
      sta genHighPrioritySpriteObj+($4D9A-$4D74).w
      bcc +
        inc genHighPrioritySpriteObj+($4D9B-$4D74).w
      +:
      
      jmp ovlScene_jumpTable_restoreOldBanks
  .ends
  
  .bank 0 slot 0
  .orga genLowPrioritySpriteObj+($4D48-$4CA3)
  .section "auto busy skip low priority 1" SIZE 9 overwrite
    jsr ovlScene_jumpTable_setUpStdBanks
    jsr doLowPriorityObjAutoBusySkipCheck
    jmp genLowPrioritySpriteObj+($4D5C-$4CA3)
  .ends
  
  .bank 0 slot 0
  .section "auto busy skip low priority 2" free
    doLowPriorityObjAutoBusySkipCheck:
      ; flag draw for this frame
      inc lowPrioritySpriteObjDrawnThisFrame.w
      
      ; make up work
      st0 #$13
      st1 #$00
      st2 #$7F
      ; srcaddr += 8
      lda genLowPrioritySpriteObj+($4CD3-$4CA3).w
      clc 
      adc #$08
      sta genLowPrioritySpriteObj+($4CD3-$4CA3).w
      bcc +
        inc genLowPrioritySpriteObj+($4CD4-$4CA3).w
      +:
      
      jmp ovlScene_jumpTable_restoreOldBanks
  .ends
.endif

;=============================
; adpcm playback sync
;=============================

;.bank 0 slot 0
;.section "adpcm sync 1" free
;  adpcmSyncCounter:
;    .db $00
;.ends

; this routine does not exist in scene 1C,
; so we must account for that possibility
.ifdef playAdpcm

  .bank 0 slot 0
  .orga playAdpcm+($6BA9-$6BA9)
  .section "adpcm sync 2" SIZE 9 overwrite
    jsr ovlScene_jumpTable_setUpStdBanks
    jsr incrementAdpcmSyncCounter
    jmp playAdpcm+($6BB7-$6BA9)
  .ends

  .bank 0 slot 0
  .section "adpcm sync 3" free
    incrementAdpcmSyncCounter:
      jsr incrementAdpcmSyncCounter_sub
      
      ; make up work
      lda $00FA
      bne +
      ; if
;        stz playAdpcm+($6C72-$6BA9).w
        stz playAdpcmMakeup1.w
        bra ++
      ; else
      +:
        lda #$40
;        sta playAdpcm+($6C72-$6BA9).w
        sta playAdpcmMakeup1.w
      ++:
;      rts
      jmp ovlScene_jumpTable_restoreOldBanks
    
    
    incrementAdpcmSyncCounter_sub:
      ; TODO: would a $F5 reset/set work better here than CPU interrupt disable?
      sei
        nop
        lda syncFrameCounter+0.w
        sta syncFrameCounterAtLastAdpcmSync+0.w
        lda syncFrameCounter+1.w
        sta syncFrameCounterAtLastAdpcmSync+1.w
      
        ; we actually want this value plus one, since we know that
        ; syncFrameCounter will be incremented at the next sync period
        ; and that incremented value is what the scripts check against
        inc syncFrameCounterAtLastAdpcmSync+0.w
        bne +
          inc syncFrameCounterAtLastAdpcmSync+1.w
        +:
        
        inc adpcmSyncCounter.w
      cli
      rts
  .ends

  .ifdef incAdpcmCounterOnPlayAdpcmAlt
    .bank 0 slot 0
    .orga playAdpcmAlt+($6C63-$6C63)
    .section "adpcm sync alt 1" SIZE 9 overwrite
      jsr ovlScene_jumpTable_setUpStdBanks
      jsr incrementAdpcmSyncCounter_altAdpcm
      jmp playAdpcmAlt+($6C71-$6C63)
    .ends
    
    .bank 0 slot 0
    .section "adpcm sync alt 3" free
      incrementAdpcmSyncCounter_altAdpcm:
        jsr incrementAdpcmSyncCounter_sub
        
        ; make up work
        lda $00FA
        bne +
        ; if
          stz playAdpcmAlt+($6C84-$6C63).w
          bra ++
        ; else
        +:
          lda #$40
          sta playAdpcmAlt+($6C84-$6C63).w
        ++:
        jmp ovlScene_jumpTable_restoreOldBanks
    .ends
  .endif

.else
  .ifdef use_playAdpcmSpecial

/*    .bank 0 slot 0
    .orga playAdpcmSpecial+($649A-$649A)
    .section "adpcm sync 2" SIZE 9 overwrite
      jsr ovlScene_jumpTable_setUpStdBanks
      jsr incrementAdpcmSyncCounter
      ; AD_PLAY
      jmp $E03C
    .ends */

    .bank 0 slot 0
    .orga playAdpcmSpecial+($64A0-$649A)
    .section "adpcm sync 2" SIZE 3 overwrite
      jmp incrementAdpcmSyncCounter
    .ends

    .bank 0 slot 0
    .section "adpcm sync 3" free
      incrementAdpcmSyncCounter:
        ; TODO: would a $F5 reset/set work better here than CPU interrupt disable?
        sei
          nop
          lda syncFrameCounter+0.w
          sta syncFrameCounterAtLastAdpcmSync+0.w
          lda syncFrameCounter+1.w
          sta syncFrameCounterAtLastAdpcmSync+1.w
        
          ; we actually want this value plus one, since we know that
          ; syncFrameCounter will be incremented at the next sync period
          ; and that incremented value is what the scripts check against
          inc syncFrameCounterAtLastAdpcmSync+0.w
          bne +
            inc syncFrameCounterAtLastAdpcmSync+1.w
          +:
          
          inc adpcmSyncCounter.w
        cli
        
        ; make up work
;        lda #$0E
;        sta $FF
;        stz $FE
;        jmp ovlScene_jumpTable_restoreOldBanks
        jmp $E03C
    .ends

  .endif
.endif

.ifdef setUpSpritesRaw
  .bank 0 slot 0
  .orga setUpSpritesRaw+($6C8E-$6B72)
  .section "setUpSpritesRaw fix 1" SIZE 9 overwrite
    jsr ovlScene_jumpTable_setUpStdBanks
    jsr doSetUpSpritesRawFix
    jmp setUpSpritesRaw+($6C98-$6B72)
  .ends
  
  .bank 0 slot 0
  .section "setUpSpritesRaw fix 2" free
    doSetUpSpritesRawFix:
      lda highPrioritySpriteObjGenerationOffset.w
      asl
      asl
      sta setUpSpritesRaw+($6C99-$6B72).w
      
      ; make up work
      lda $29
      sta setUpSpritesRaw+($6CA6-$6B72).w
      lda $2A
      sta setUpSpritesRaw+($6CA7-$6B72).w
      jmp ovlScene_jumpTable_restoreOldBanks
  .ends
.endif

;==============================================================================
; the main event!
;==============================================================================

.define newZpFreeReg $29
.define newZpScriptReg $2B

;=============================
; 
;=============================

/*.bank 0 slot 0
.orga ovlBatStr_simpleStringPrint_offset+$13
.section "batstr overlay: simple string 8-bit codepoints 1" overwrite
;  inc $00BE
;  bne +
;    inc $00BF
;  +:
  jmp ovlBatStr_simpleStringPrint_offset+$19
.ends */

.bank 0 slot 0
.orga syncVector+($5284-$527F)
.section "sync handler injection 1" overwrite
  ; ensure the banks containing our code are loaded
  jsr ovlScene_jumpTable_setUpStdBanks
  ; run the new code
  jmp newSyncLogic
.ends

.bank 0 slot 0
.section "new sync handler logic 2" free
  ; frame counter, incremented every vsync.
  ; used to time script events
  syncFrameCounter:
    .dw $00
  ; DEBUG: same as above, but never gets reset.
  ; used to check timing
  globalSyncFrameCounter:
    .dw $00
  ; incremented every time an ADPCM clip is triggered.
  ; used to sync up timing
  adpcmSyncCounter:
    .db $00
  ; the value of syncFrameCounter the last time that
  ; adpcmSyncCounter was incremented
  syncFrameCounterAtLastAdpcmSync:
    .dw $0000
  
  oldPaletteTransferFlag:
    .db $00
  
  .ifdef enable_sceneAutoBusySkip
    lowPrioritySpriteObjDrawnThisFrame:
      .db $00
    highPrioritySpriteObjDrawnThisFrame:
      .db $00
    skipLowPriorityObjDrawFrames:
      .db $00
    skipHighPriorityObjDrawFrames:
      .db $00
  .endif
  
  ; these are written every frame,
  ; starting at color index 1 of the target palette.
  ; colors 1 and 3 are the font color,
  ; color 2 is the drop shadow color
  paletteOverrideColors:
;    .dw defaultSubColor
;    .dw defaultSubShadowColor
;    .dw defaultSubColor
    ; if bit 1 is set, color is font.
    ; otherwise, it's shadow
    .dw defaultSubColor
    .rept 7
      .dw defaultSubShadowColor
      .dw defaultSubColor
    .endr
    
    ; font = light blue
;    .dw $01C7
    ; shadow = black
;    .dw $0000
    ; font
;    .dw $01C7
  paletteOverrideColorsEnd:
  
  maxScriptActionsPerIteration:
    .db default_maxScriptActionsPerIteration
  maxSpriteAttrTransfersPerIteration:
    .db default_maxSpriteAttrTransfersPerIteration
  maxSpriteGrpTransfersPerIteration:
    .db default_maxSpriteGrpTransfersPerIteration
  subtitleSpriteForcingOn:
    .db $FF
  
  newSyncLogic:
    ; increment frame counter
    inc syncFrameCounter+0.w
    bne +
      inc syncFrameCounter+1.w
    +:
    ; DEBUG
    inc globalSyncFrameCounter+0.w
    bne +
      inc globalSyncFrameCounter+1.w
    +:
    
    ; we happen to know that at this point,
    ; X will equal the old state of the paletteTransferRequest flag.
    ; if a palette transfer occurred, we do NOT want to run our
    ; additional logic (as it reduces the available time beyond what
    ; may be safe), so we save it for future reference
;    txa
    ; these trigger some sort of palette effects that similarly
    ; consume time
    ; (TODO: these may or may not require additional attention depending
    ; on what they actually do)
;    ora $63
;    ora $66
;    sta oldPaletteTransferFlag.w
    ; well, i guess we're throwing caution to the winds...
    
    ; make up work
    jsr syncMakeup1
    jsr syncMakeup2
    
    ; check if asynchronous subtitle clear has occurred
    lda queuedSubsOffIsOn.w
    beq +
      lda queuedSubsOffTime+0.w
      sec
      sbc syncFrameCounter.w
      lda queuedSubsOffTime+1.w
      sbc syncFrameCounter+1.w
      bcs ++
        ; turn subtitles off
        jsr turnSubsOff
        stz queuedSubsOffIsOn.w
      ++:
    +:
    
    ; display subs if on
    lda subtitleDisplayOn.w
    beq +
      ;=====
      ; write subtitle sprite attributes to start of SAT
      ;=====
      
      ; set write address
      st0 #$00
      st1 #<satVramAddr
      st2 #>satVramAddr
      
      ; start write
      st0 #$02
      
      lda currentSubtitleSpriteAttributeQueuePtr+0.w
      sta @transferToSatCmd+1.w
      lda currentSubtitleSpriteAttributeQueuePtr+1.w
      sta @transferToSatCmd+2.w
      
      lda currentSubtitleSpriteAttributeQueueSize.w
      sta @transferToSatCmd+5.w
      
      ; TODO: possible optimization: write the queue pointer here directly
      ; if it's never needed elsewhere
      @transferToSatCmd:
      tia $0000,$0002,$0000
      
      ; TODO: is this necessary?
      ; the real problem with flickering, etc. may simply be
      ; the sprites getting turned off (and then immediately on
      ; again by us)
      ; if non-subtitle sprite table clear requested, handle that
      lda triggerNonSubtitleSpriteClear.w
      beq ++
        ; blank everything EXCEPT the subtitle sprites from the SAT.
        ; the address is already primed (we just wrote all the
        ; subtitle sprites, and we're clearing out everything else
        ; to the end of the SAT)
        
        ; set size of the area to blank
        lda currentSubtitleSpriteAttributeQueueSize.w
        lsr
        eor #$FF
        ina
        sta @clearFromSatCmd+5.w
        
        ; we split this up into two transfers because zeroPlanes
        ; is only 256 bytes long.
        ; the total amount to clear is guaranteed to be >= 256
        ; (we assume a max of 31 subtitle sprites),
        ; so it works out fine
        tia zeroPlanes,$0002,$0100
        @clearFromSatCmd:
        tia zeroPlanes,$0002,$0000
        
        ; clear trigger flag
        stz triggerNonSubtitleSpriteClear.w
      ++:
      
      ; initiate sat->satb dma
      st0 #$13
      st1 #<satVramAddr
      st2 #>satVramAddr
      
      ; force sprite display on
      lda subtitleSpriteForcingOn.w
      beq ++
        smb6 $F3
      ++:
      
      ;=====
      ; override palette for subtitles
      ;=====
      
      ; set override palette
      ; dstaddr
  ;    lda #$81
      lda currentSubtitlePaletteIndex.w
      ; bit 7 of index set = disabled
      bmi ++
        ; could optimize this by precomputing the shift,
        ; but i don't think it'll come to that
        asl
        asl
        asl
        asl
        ; target from color 1
        ora #$01
        sta vce_ctaLo.w
        ; target sprite palettes
        lda #$01
        sta vce_ctaHi.w
        ; copy colors to vce
        tia paletteOverrideColors,vce_ctwLo,(paletteOverrideColorsEnd-paletteOverrideColors)
      ++:
    +:
    
/*    lda #$FF
    sta vce_ctwLo.w
    sta vce_ctwHi.w
    cla
    sta vce_ctwLo.w
    sta vce_ctwHi.w
    lda #$FF
    sta vce_ctwLo.w
    sta vce_ctwHi.w */
    
;    lda oldPaletteTransferFlag.w
;    bne @done
    .ifdef enable_sceneAutoBusySkip
      lda skipLowPriorityObjDrawFrames.w
      beq +
        lda lowPrioritySpriteObjDrawnThisFrame.w
        bne @done
      +:
      lda skipHighPriorityObjDrawFrames.w
      beq +
        lda highPrioritySpriteObjDrawnThisFrame.w
        bne @done
      +:
    .endif
    
      lda newZpFreeReg
      pha
      lda newZpFreeReg+1
      pha
        
        ;=====
        ; if attribute transfer active
        ;=====
        
        lda subtitleAttributeTransferOn.w
        beq +
          lda maxSpriteAttrTransfersPerIteration.w
          sta remainingScriptActions.w
          -:
            jsr doNextSpriteAttrTransfer
            dec remainingScriptActions.w
            bne -
  ;        jsr doNextSpriteAttrTransfer
          jmp @actionsDone
        +:
        
        ;=====
        ; if graphics transfer active
        ;=====
        
        lda subtitleGraphicsTransferOn.w
        beq +
          lda maxSpriteGrpTransfersPerIteration.w
          
          ; the outlining algorithm is costly.
          ; if a palette transfer occurred on the same frame,
          ; only send one pattern to try to ensure we
          ; don't induce lag.
          ldx oldPaletteTransferFlag.w
          beq ++
            lda #1
          ++:
          
          sta remainingScriptActions.w
          -:
            jsr doNextSpriteGrpTransfer
            dec remainingScriptActions.w
            bne -
          jmp @actionsDone
        +:
        
        ;=====
        ; run script
        ;=====
        
        lda newZpScriptReg
        pha
        lda newZpScriptReg+1
        pha
          lda subtitleScriptPtr.w
          sta newZpScriptReg
          lda subtitleScriptPtr+1.w
          sta newZpScriptReg+1
          
          lda maxScriptActionsPerIteration.w
          sta remainingScriptActions.w
          -:
            jsr runScript
            dec remainingScriptActions.w
            bne -
          
          lda newZpScriptReg
          sta subtitleScriptPtr.w
          lda newZpScriptReg+1
          sta subtitleScriptPtr+1.w
        pla
        sta newZpScriptReg+1
        pla
        sta newZpScriptReg
        
      @actionsDone:
      pla
      sta newZpFreeReg+1
      pla
      sta newZpFreeReg
    @done:
    
    .ifdef enable_sceneAutoBusySkip
      stz lowPrioritySpriteObjDrawnThisFrame.w
      stz highPrioritySpriteObjDrawnThisFrame.w
    .endif
    
    ; restore old banks
    jmp ovlScene_jumpTable_restoreOldBanks
  
  remainingScriptActions:
    .db $00
  
  doNextSpriteAttrTransfer:
    lda subtitleAttributeTransferCurrentStatePtr+0.w
    sta newZpFreeReg+0
    lda subtitleAttributeTransferCurrentStatePtr+1.w
    sta newZpFreeReg+1
    
    ; $FF in the line num indicates init needed
    lda subtitleAttributeTransferLineNum.w
    bmi @startNextLine
    ldy #SubtitleCompBufferLineState.patternTransfersLeft
    lda (newZpFreeReg),Y
    bne @lineNotDone
      ; advance to next line
      lda subtitleAttributeTransferLineNum.w
    @startNextLine:
      ina
      cmp activeLineCount.w
      bne @notAllDone
        ; everything is done: turn transfer flag off
        stz subtitleAttributeTransferOn.w
        
        ; reset queue fields for graphics transfer
        jsr resetAllStateQueueFields
        
        ; prep drop shadow buffer for use
        tai blockClearWord,dropShadowBufferB,(dropShadowBufferBEnd-dropShadowBufferB)
        tai blockClearWord,charShiftBufferB,(charShiftBufferBEnd-charShiftBufferB)
        
        ; prevent further transfers
        lda #$01
        sta remainingScriptActions.w
        rts
      @notAllDone:
      sta subtitleAttributeTransferLineNum.w
      ; advance to next state
      lda newZpFreeReg+0
      clc
      adc #_sizeof_SubtitleCompBufferLineState
      sta subtitleAttributeTransferCurrentStatePtr+0.w
      sta newZpFreeReg+0
      cla
      adc newZpFreeReg+1
      sta subtitleAttributeTransferCurrentStatePtr+1.w
      sta newZpFreeReg+1
      
      ; set up base x-pos from line width
      ldy #SubtitleCompBufferLineState.pixelW
      lda (newZpFreeReg),Y
      ; centering offset = (256 - width) / 2
      eor #$FF
      ina
      lsr
      sta subtitleDisplayQueueCurrentX.w
      
      ; move to next y-pos
      lda subtitleDisplayQueueCurrentY.w
      clc
      adc #spritePatternH
      sta subtitleDisplayQueueCurrentY.w
      
      ; round dstptr up to the next even pattern number
      ; (so we can make use of double-width sprites)
      lda subtitleAttributeTransferVramPutPos+0.w
      and #$01
      beq +
;        clc
;        adc subtitleAttributeTransferVramPutPos+0.w
;        sta subtitleAttributeTransferVramPutPos+0.w
;        cla
;        adc subtitleAttributeTransferVramPutPos+1.w
;        sta subtitleAttributeTransferVramPutPos+1.w
        inc subtitleAttributeTransferVramPutPos+0.w
        bne +
          inc subtitleAttributeTransferVramPutPos+1.w
      +:
    @lineNotDone:
    
    ; determine output sprite width
    ldy #SubtitleCompBufferLineState.patternTransfersLeft
    lda (newZpFreeReg),Y
    cmp #$01
    beq +
      lda #$02
    +:
    sta @spriteWidth.w
    tax
      ; update patternTransfersLeft
      lda (newZpFreeReg),Y
      sec
      sbc @spriteWidth.w
      sta (newZpFreeReg),Y
    ; restore number of patterns being transferred
    txa
    ; update currentPtr to next position
    ; multiply pattern count by size of plane (32)
    asl
    asl
    asl
    asl
    pha
      asl
      ; add to currentPtr
      ldy #SubtitleCompBufferLineState.currentPtr
      clc
      adc (newZpFreeReg),Y
      sta (newZpFreeReg),Y
      iny
      cla
      adc (newZpFreeReg),Y
      sta (newZpFreeReg),Y
      
      ; set up x-pos
      lda subtitleDisplayQueueCurrentX.w
      sta @xSetCmd+1.w
    pla
    ; add (patternCount*16) to x-pos
    clc
    adc subtitleDisplayQueueCurrentX.w
    sta subtitleDisplayQueueCurrentX.w
    
    ; set up attribute dstptr and advance attribute putpos
    lda subtitleDisplayBackQueuePutPos+0.w
    sta newZpFreeReg+0
    clc
    adc #<_sizeof_SpriteAttribute
    sta subtitleDisplayBackQueuePutPos+0.w
    lda subtitleDisplayBackQueuePutPos+1.w
    sta newZpFreeReg+1
    adc #>_sizeof_SpriteAttribute
    sta subtitleDisplayBackQueuePutPos+1.w
    
    cly
    
    ; Y
    lda subtitleDisplayQueueCurrentY.w
    clc
    adc #spriteAttrBaseY
    sta (newZpFreeReg),Y
    iny
    cla
    adc #$00
    sta (newZpFreeReg),Y
    iny
    
    ; X
    ; self-modifying
    @xSetCmd:
    lda #$00
    clc
    ; offset 1 pixel to the left because after generating the outline,
    ; the subtitles will take up 2 more pixels on the right
    adc #spriteAttrBaseX-1
    sta (newZpFreeReg),Y
    iny
    cla
    adc #$00
    sta (newZpFreeReg),Y
    iny
    
    ; pattern
    lda subtitleAttributeTransferVramPutPos+0.w
    asl
    sta (newZpFreeReg),Y
    iny
    lda subtitleAttributeTransferVramPutPos+1.w
    rol
    sta (newZpFreeReg),Y
    iny
    
    ; flags
    ; low byte
    ; apply palette
    ; (note: top bit set = high priority)
;    lda #$88
    lda #$80
    ora currentSubtitlePaletteIndex.w
    sta (newZpFreeReg),Y
    iny
    ; high byte
    ldx #$01
    lda @spriteWidth.w
    cmp #$01
    bne +
      ldx #$00
    +:
    txa
    sta (newZpFreeReg),Y
;    iny
    
    ; increment size of back queue
    lda subtitleDisplayQueueParity.w
    tax
    inc subtitleDisplayQueueSizeArray.w,X
    
    ; advance putpos to next pattern
    lda @spriteWidth.w
    clc
    adc subtitleAttributeTransferVramPutPos+0.w
    sta subtitleAttributeTransferVramPutPos+0.w
    cla
    adc subtitleAttributeTransferVramPutPos+1.w
    sta subtitleAttributeTransferVramPutPos+1.w
    
    rts
    
    @spriteWidth:
    .db $00
  
  doNextSpriteGrpTransfer:
    lda subtitleGraphicsTransferCurrentStatePtr+0.w
    sta newZpFreeReg+0
    lda subtitleGraphicsTransferCurrentStatePtr+1.w
    sta newZpFreeReg+1
    
    ; $FF in the line num indicates init needed
    lda subtitleGraphicsTransferLineNum.w
    bmi @startNextLine
    ldy #SubtitleCompBufferLineState.patternTransfersLeft
    lda (newZpFreeReg),Y
    bne @lineNotDone
      ; advance to next line
      lda subtitleGraphicsTransferLineNum.w
    @startNextLine:
      ina
      cmp activeLineCount.w
      bne @notAllDone
        ; everything is done: turn transfer flag off
        stz subtitleGraphicsTransferOn.w
        
        ; reset queue fields for graphics transfer
;        jsr resetAllStateQueueFields
        
        ; prevent further transfers
        lda #$01
        sta remainingScriptActions.w
        rts
      @notAllDone:
      sta subtitleGraphicsTransferLineNum.w
      ; advance to next state
      lda newZpFreeReg+0
      clc
      adc #_sizeof_SubtitleCompBufferLineState
      sta subtitleGraphicsTransferCurrentStatePtr+0.w
      sta newZpFreeReg+0
      cla
      adc newZpFreeReg+1
      sta subtitleGraphicsTransferCurrentStatePtr+1.w
      sta newZpFreeReg+1
      
      ; set up base x-pos from line width
      ldy #SubtitleCompBufferLineState.pixelW
      lda (newZpFreeReg),Y
      ; centering offset = (256 - width) / 2
      eor #$FF
      ina
      lsr
      sta subtitleDisplayQueueCurrentX.w
      
      ; move to next y-pos
      lda subtitleDisplayQueueCurrentY.w
      clc
      adc #spritePatternH
      sta subtitleDisplayQueueCurrentY.w
      
      ; round dstptr up to the next even pattern number
      ; (so we can make use of double-width sprites)
      lda subtitleGraphicsTransferVramPutPos+0.w
      and #$01
      beq +
        inc subtitleGraphicsTransferVramPutPos+0.w
        bne +
          inc subtitleGraphicsTransferVramPutPos+1.w
      +:
    @lineNotDone:
  
    ;=====
    ; do vram write
    ;=====
    
    lda subtitleGraphicsTransferVramPutPos+0.w
    sta @vramDstLowerCmd+1.w
    lda subtitleGraphicsTransferVramPutPos+1.w
    ; multiply tilenum by 64 to get vram address
    .rept 6
      asl @vramDstLowerCmd+1.w
      rol
    .endr
    sta @vramDstUpperCmd+1.w
    
    inc subtitleGraphicsTransferVramPutPos+0.w
    bne +
      inc subtitleGraphicsTransferVramPutPos+1.w
    +:
    
    ; set vram dst
    st0 #$00
    @vramDstLowerCmd:
    ; self-modifying
    st1 #$00
    @vramDstUpperCmd:
    ; self-modifying
    st2 #$00
    
    ; start write
    st0 #$02
    
    ; do pattern conversion
;    ldx @spriteWidth.w
;    -:
      ; set src and advance to next pattern
      ldy #SubtitleCompBufferLineState.currentPtr
      lda (newZpFreeReg),Y
      sta @spritePlaneTransferCmd+1.w
      clc
      adc #<bytesPerSpritePatternPlane
      sta (newZpFreeReg),Y
      iny
      lda (newZpFreeReg),Y
      sta @spritePlaneTransferCmd+2.w
      adc #>bytesPerSpritePatternPlane
      sta (newZpFreeReg),Y
      
      ; no shadow
;      @spritePlaneTransferCmd:
;      tia $0000,$0002,bytesPerSpritePatternPlane
;      ; fill remaining planes with zero
;      tia zeroPlanes,$0002,bytesPerSpritePatternPlane*3
      
      ; generate drop shadow on row directly beneath sprite.
      ; simple, efficient, doesn't look good enough
/*      ldx #$02
      -:
        @spritePlaneTransferCmd:
        tia $0000,$0002,bytesPerSpritePatternPlane
        tia zeroPlanes,$0002,2
        dex
        bne -
      tia zeroPlanes,$0002,(bytesPerSpritePatternPlane*2)-2 */
      
/*      clx 
      -:
        @spritePlaneTransferCmd:
        lda $0000.w,X
        sta dropShadowBufferA.w,X
        inx
        cpx #bytesPerSpritePatternPlane
        bne - */
      
;      @spritePlaneTransferCmd:
;      tii $0000,dropShadowBufferA,bytesPerSpritePatternPlane
;      
;      ; copy first plane
;      tia dropShadowBufferA,$0002,bytesPerSpritePatternPlane
      
      ; shadow one pixel down and to the right
/*      ; right-shift (only lines that actually contain content)
      ldx #(numSubtitleFontCharTopPaddingLines*2)
      -:
        lda dropShadowBufferA+1.w,X
        lsr
;        ora dropShadowBufferA+1.w,X
        ora dropShadowBufferB+1.w,X
        sta dropShadowBufferA+1.w,X
        
        ror dropShadowBufferA+0.w,X
        cla
        ror
        sta dropShadowBufferB+1.w,X
        
        inx
        inx
        cpx #(bytesPerSpritePatternPlane-(numSubtitleFontCharBottomPaddingLines*2))
        bne - */
      
      ; shadow down and down-right
/*      ; right-shift (only lines that actually contain content)
      ldx #(numSubtitleFontCharTopPaddingLines*2)
      -:
        lda dropShadowBufferA+1.w,X
        lsr
        ora dropShadowBufferA+1.w,X
        ora dropShadowBufferB+1.w,X
        sta dropShadowBufferA+1.w,X
        
        lda dropShadowBufferA+0.w,X
        ror
        ora dropShadowBufferA+0.w,X
        sta dropShadowBufferA+0.w,X
        cla
        ror
        sta dropShadowBufferB+1.w,X
        
        inx
        inx
        cpx #(bytesPerSpritePatternPlane-(numSubtitleFontCharBottomPaddingLines*2))
        bne - */
      
      ; shadow down, right, and down-right
      ; right-shift (only lines that actually contain content)
/*      ldx #(numSubtitleFontCharTopPaddingLines*2)
      -:
        lda dropShadowBufferA+1.w,X
        lsr
        ora dropShadowBufferA+1.w,X
        ora dropShadowBufferB+1.w,X
        sta dropShadowBufferA+1.w,X
        ora dropShadowBufferA-1.w,X
        sta dropShadowBufferA-1.w,X
        
        lda dropShadowBufferA+0.w,X
        ror
        ora dropShadowBufferA+0.w,X
        sta dropShadowBufferA+0.w,X
        ora dropShadowBufferA-2.w,X
        sta dropShadowBufferA-2.w,X
        cla
        ror
        sta dropShadowBufferB+1.w,X
;        sta dropShadowBufferB-1.w,X
        
        inx
        inx
        cpx #(bytesPerSpritePatternPlane-(numSubtitleFontCharBottomPaddingLines*2))
        bne - */
      
/*      @spritePlaneTransferCmd:
      tii $0000,dropShadowBufferA,bytesPerSpritePatternPlane
      
      ; copy first plane
      tia dropShadowBufferA,$0002,bytesPerSpritePatternPlane
      
      ; D-DR-R with unrolled loop
      .rept linesPerRawSceneFontChar INDEX count
        lda dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        lsr
        ora dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferA-1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA-1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        
        lda dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ror
        ora dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferA-2+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA-2+((numSubtitleFontCharTopPaddingLines+count)*2).w
        cla
        ror
        sta dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
      .endr */
      
      ; JUST OUTLINE EVERYTHING BECAUSE I WILL NEVER BE SATISFIED OTHERWISE
      
      @spritePlaneTransferCmd:
      tii $0000,charShiftBufferA,bytesPerSpritePatternPlane
      tii charShiftBufferA,dropShadowBufferA,bytesPerSpritePatternPlane
      
      .rept linesPerRawSceneFontChar INDEX count
        lda charShiftBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        lsr
        ora charShiftBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta charShiftBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        
        lda charShiftBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ror
        sta charShiftBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        
        cla
        ror
        sta charShiftBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
      .endr
      
      ; copy first plane
      tia charShiftBufferA,$0002,bytesPerSpritePatternPlane
      
      .rept linesPerRawSceneFontChar INDEX count
        lda charShiftBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        lsr
;        ora charShiftBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
;        sta charShiftBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
;        ora dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        
        lda charShiftBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ror
;        sta charShiftBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ora dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferA+0+((numSubtitleFontCharTopPaddingLines+count)*2).w
        
        lda dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        ror
;        sta charShiftBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
        sta dropShadowBufferB+1+((numSubtitleFontCharTopPaddingLines+count)*2).w
      .endr
      
      ; copy remaining planes
;      tia dropShadowBufferA-2,$0002,(bytesPerSpritePatternPlane*3)
      tia dropShadowBufferA-2,$0002,bytesPerSpritePatternPlane
      tia dropShadowBufferA+0,$0002,bytesPerSpritePatternPlane
      tia dropShadowBufferA+2,$0002,bytesPerSpritePatternPlane
      
;      dex
;      bne -
  
    ;=====
    ; update fields
    ;=====
    
    ; decrement patterns remaining counter
    ldy #SubtitleCompBufferLineState.patternTransfersLeft
    lda (newZpFreeReg),Y
    dea
    sta (newZpFreeReg),Y
    
    ; advance currentPtr to next pattern
/*    ldy #SubtitleCompBufferLineState.currentPtr
    lda (newZpFreeReg),Y
    clc
    adc #bytesPerSpritePatternPlane
    sta (newZpFreeReg),Y
    iny
    cla
    adc (newZpFreeReg),Y
    sta (newZpFreeReg),Y */
    
    rts
    
  
  ; pre-padding to allow for single transfer of last 3 planes
  dropShadowBufferAPrePad:
    .dw $0000
  dropShadowBufferA:
    .ds bytesPerSpritePatternPlane,$00
  dropShadowBufferAEnd:
  ; speed up transfer of null planes
  zeroPlanes:
;    .ds bytesPerSpritePatternPlane*3,$00
;    .ds bytesPerSpritePatternPlane*2,$00
    ; actually, this is useful for clearing out VRAM,
    ; so let's just make it a full 256 bytes
    .ds 256,$00
  
  dropShadowBufferB:
    .ds bytesPerSpritePatternPlane,$00
  dropShadowBufferBEnd:
  
  charShiftBufferA:
    .ds bytesPerSpritePatternPlane,$00
  charShiftBufferAEnd:
  charShiftBufferB:
    .ds bytesPerSpritePatternPlane,$00
  charShiftBufferBEnd:
  
  runScript:
    cly
    
    lda (newZpScriptReg),Y
    cmp #sceneFontCharsBase
    bcc @isOpcode
    
    @isLiteral:
      jsr printSubtitleChar
      lda #$01
      jmp addToScriptPtr
    @isOpcode:
      cmp #sceneOp_terminator
      beq @done
    
      @doGenericSceneOp:
      asl
      tax
/*      lda subtitleOpJumpTable+0.w,X
      sta @sceneOpJumpCmd+1.w
      lda subtitleOpJumpTable+1.w,X
      sta @sceneOpJumpCmd+2.w
      @sceneOpJumpCmd:
      jmp $0000 */
      ; lol i forgot this addressing mode existed for jmp
      jmp (subtitleOpJumpTable,X)
      
;      cmp #sceneOp_waitForFrame
;      bne @doGenericSceneOp
      
      ;=====
      ; wait until target framenum
      ;=====
      
/*      iny
      lda (newZpScriptReg),Y
      cmp syncFrameCounter.w
      bne @endCurrentIteration
      iny
      lda (newZpScriptReg),Y
      cmp syncFrameCounter+1.w */
    
    @done:
    rts
  
  subtitleOpJumpTable:
    ; 00 = terminator (special-cased)
    .dw $0000
    ; 01 = sceneOp_waitForFrame
    .dw sceneOp_waitForFrame_handler
    ; 02 = sceneOp_br
    .dw sceneOp_br_handler
    ; 03 = sceneOp_resetCompBuffers
    .dw sceneOp_resetCompBuffers_handler
    ; 04
    .dw sceneOp_prepAndSendGrp_handler
    ; 05
    .dw sceneOp_swapAndShowBuf_handler
    ; 06
    .dw sceneOp_subsOff_handler
    ; 07
    .dw sceneOp_finishCurrentLine_handler
    ; 08
    .dw sceneOp_setPalette_handler
    ; 09
    .dw sceneOp_setHighPrioritySprObjOffset_handler
    ; 0A
    .dw sceneOp_setLowPrioritySprObjOffset_handler
    ; 0B
;    .dw sceneOp_resetSyncTimer_handler
;    .dw sceneOp_subtractFromSyncTimer_handler
    .dw sceneOp_resetSyncTimerFromAdpcm_handler
    ; 0C
    .dw sceneOp_writePalette_handler
    ; 0D
    .dw sceneOp_writeVram_handler
    ; 0E
    .dw sceneOp_waitForAdpcm_handler
    ; 0F
    .dw sceneOp_queueSubsOff_hander
    ; 10
    .dw sceneOp_writeMem_hander
    ; 11
    .dw sceneOp_andOr_hander
  
  sceneOp_waitForFrame_handler:
    iny
    lda (newZpScriptReg),Y
    sec
    sbc syncFrameCounter.w
    iny
    lda (newZpScriptReg),Y
    sbc syncFrameCounter+1.w
    bcs @endCurrentIteration
      tya
      ina
      jmp addToScriptPtr
    @endCurrentIteration:
    lda #$01
    sta remainingScriptActions.w
    rts
  
  sceneOp_br_handler:
    jsr finishCurrentSubtitleBufferLine
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_resetCompBuffers_handler:
    jsr resetSubtitleCompBuffers
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_prepAndSendGrp_handler:
    ; reset sprite attribute putpos
/*    lda #<activeSubtitleSpriteAttributeQueue
    sta activeSubtitleSpriteAttributeQueuePutPos+0.w
    lda #>activeSubtitleSpriteAttributeQueue
    sta activeSubtitleSpriteAttributeQueuePutPos+1.w
    ; reset queue size
    stz activeSubtitleSpriteAttributeQueueSize.w */
    
    lda subtitleDisplayQueueParity.w
;    ina
;    and #$01
;    sta subtitleDisplayQueueParity.w
    ; reset back queue's size
    pha
      tax
      stz subtitleDisplayQueueSizeArray.w,X
    pla
    ; reset write pos for back queue
    asl
    tax
    lda subtitleDisplayQueuePointerArray+0.w,X
    sta subtitleDisplayBackQueuePutPos+0.w
    lda subtitleDisplayQueuePointerArray+1.w,X
    sta subtitleDisplayBackQueuePutPos+1.w
;    stz subtitleDisplayBackQueuePutPos.w
    
    ; set up procedural graphics transfer
    ; initialize these fields to one before the actual
    ; target value so that they'll get initialized properly
    lda #<(subtitleStates-_sizeof_SubtitleCompBufferLineState)
    sta subtitleAttributeTransferCurrentStatePtr+0.w
    sta subtitleGraphicsTransferCurrentStatePtr+0.w
    lda #>(subtitleStates-_sizeof_SubtitleCompBufferLineState)
    sta subtitleAttributeTransferCurrentStatePtr+1.w
    sta subtitleGraphicsTransferCurrentStatePtr+1.w
;    sta subtitleAttributeTransferEndLineNum.w
    
    ; initialize y-position
    ; multiply line count by 8, then subtract from base Y
    ; to center around target y-offset
    lda activeLineCount.w
    asl
    asl
    asl
    sec
    sbc subtitleBaseY.w
    eor #$FF
    ina
    ; subtract 16 because that will be added during line initialization
    sec
    sbc #spritePatternH
    sta subtitleDisplayQueueCurrentY.w
    
;    stz subtitleAttributeTransferLineNum.w
    lda #$FF
    sta subtitleAttributeTransferLineNum.w
    sta subtitleGraphicsTransferLineNum.w
    ; get dst tile num from op args
;    lda #$DC
    iny
    lda (newZpScriptReg),Y
    sta subtitleAttributeTransferVramPutPos+0.w
    sta subtitleGraphicsTransferVramPutPos+0.w
;    lda #$01
    iny
    lda (newZpScriptReg),Y
    sta subtitleAttributeTransferVramPutPos+1.w
    sta subtitleGraphicsTransferVramPutPos+1.w
    
    ; left-shift graphics transfer addr to vram address
;    .rept 6
;      asl subtitleGraphicsTransferVramPutPos+0.w
;      rol subtitleGraphicsTransferVramPutPos+1.w
;    .endr
    
    inc subtitleAttributeTransferOn.w
    inc subtitleGraphicsTransferOn.w
    
    ; prevent further evaluation of script until transfer completes
    lda #$01
    sta remainingScriptActions.w
    
    lda #$03
    jmp addToScriptPtr
  
  sceneOp_swapAndShowBuf_handler:
    lda subtitleDisplayQueueParity.w
    pha
      tax
      lda subtitleDisplayQueueSizeArray.w,X
      ; *8 to get size in bytes
      ; (we assume there will never be more than 31 sprites)
      asl
      asl
      asl
      sta currentSubtitleSpriteAttributeQueueSize.w
      
      txa
      asl
      tax
      
      lda subtitleDisplayQueuePointerArray+0.w,X
      sta currentSubtitleSpriteAttributeQueuePtr+0.w
      lda subtitleDisplayQueuePointerArray+1.w,X
      sta currentSubtitleSpriteAttributeQueuePtr+1.w
    pla
    ina
    and #$01
    sta subtitleDisplayQueueParity.w
    ; will be 01 or 02; all that matters is that it's nonzero
    ina
    sta subtitleDisplayOn.w
    
    ; reset composition buffers for next string
    jsr resetSubtitleCompBuffers
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_subsOff_handler:
    jsr turnSubsOff
    
    ; prevent further evaluation of script
    lda #$01
    sta remainingScriptActions.w
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_finishCurrentLine_handler:
    jsr finishCurrentSubtitleBufferLine
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_setPalette_handler:
    iny
    lda (newZpScriptReg),Y
    sta currentSubtitlePaletteIndex.w
    
    lda #$02
    jmp addToScriptPtr
  
  sceneOp_setHighPrioritySprObjOffset_handler:
    iny
    lda (newZpScriptReg),Y
    sta highPrioritySpriteObjGenerationOffset.w
    
    lda #$02
    jmp addToScriptPtr
    
  sceneOp_setLowPrioritySprObjOffset_handler:
    iny
    lda (newZpScriptReg),Y
    sta lowPrioritySpriteObjGenerationOffset.w
    
    lda #$02
    jmp addToScriptPtr
  
;  sceneOp_resetSyncTimer_handler:
;    cla
;    sta syncFrameCounter+0.w
;    sta syncFrameCounter+1.w
;    
;    ina
;    jmp addToScriptPtr
  
;  sceneOp_subtractFromSyncTimer_handler:
;    lda syncFrameCounter+0.w
;    iny
;    sec
;    sbc (newZpScriptReg),Y
;    sta syncFrameCounter+0.w
;    
;    lda syncFrameCounter+1.w
;    iny
;    sbc (newZpScriptReg),Y
;    sta syncFrameCounter+1.w
;    
;    lda #$03
;    jmp addToScriptPtr
  
  ; TODO: not used, replace
  sceneOp_resetSyncTimerFromAdpcm_handler:
    
    ; subtract sync time of last adpcm trigger
    ; from current actual sync time.
    ; reset sync timer to that value
    ; (to account for any possible delay due to
    ; e.g. extra time spent rendering text before the
    ; sync command could be handled)
    
    lda syncFrameCounter+0.w
    sec
    sbc syncFrameCounterAtLastAdpcmSync+0.w
    sta syncFrameCounter+0.w
    
    lda syncFrameCounter+1.w
    sbc syncFrameCounterAtLastAdpcmSync+1.w
    sta syncFrameCounter+1.w
    
    lda #$01
    jmp addToScriptPtr
    
    
    
  
  sceneOp_writePalette_handler:
    ; src
    lda newZpScriptReg+0
    clc
    adc #$05
    sta @transferCmd.w+1
    cla
    adc newZpScriptReg+1
    sta @transferCmd.w+2
    
    ; size
    iny
    lda (newZpScriptReg),Y
    sta @transferCmd+5.w
    iny
    lda (newZpScriptReg),Y
    sta @transferCmd+6.w
    
    ; dst
    iny
    lda (newZpScriptReg),Y
;    sta @addrCmdLo+1.w
    sta vce_ctaLo.w
    iny
    lda (newZpScriptReg),Y
;    sta @addrCmdHi+1.w
    sta vce_ctaHi.w
    
;      @addrCmdLo:
;      lda #$00
;      sta vce_ctaLo.w
;      @addrCmdHi:
;      lda #$00
;      sta vce_ctaHi.w
      ; copy colors to vce
      @transferCmd:
      tia $0000,vce_ctwLo,$0000
    
    ; add size to script ptr
    lda newZpScriptReg+0
    clc
    adc @transferCmd+5.w
    sta newZpScriptReg+0
    lda newZpScriptReg+1
    adc @transferCmd+6.w
    sta newZpScriptReg+1
    
    ; prevent further evaluation of script
    lda #$01
    sta remainingScriptActions.w
    
    ; add base size to script ptr
    lda #$05
    jmp addToScriptPtr
  
  ; note: it is the caller's responsibility
  ; not to transfer too much at a time
  sceneOp_writeVram_handler:
    ; src
;    lda newZpScriptReg+0
;    clc
;    adc #$05
;    sta @transferCmd.w+1
;    cla
;    adc newZpScriptReg+1
;    sta @transferCmd.w+2
    iny
    lda (newZpScriptReg),Y
    sta @transferCmd+1.w
    iny
    lda (newZpScriptReg),Y
    sta @transferCmd+2.w
    
    ; size
    iny
    lda (newZpScriptReg),Y
    sta @transferCmd+5.w
    iny
    lda (newZpScriptReg),Y
    sta @transferCmd+6.w
    
    ; dst
    iny
    lda (newZpScriptReg),Y
    sta @addrCmdLo+1.w
    iny
    lda (newZpScriptReg),Y
    sta @addrCmdHi+1.w
      
      st0 #$00
      @addrCmdLo:
      st1 #$00
      @addrCmdHi:
      st2 #$00
      st0 #$02
      
      @transferCmd:
      tia $0000,$0002,$0000
    
    ; add size to script ptr
;    lda newZpScriptReg+0
;    clc
;    adc @transferCmd+5.w
;    sta newZpScriptReg+0
;    lda newZpScriptReg+1
;    adc @transferCmd+6.w
;    sta newZpScriptReg+1
    
    ; prevent further evaluation of script
    lda #$01
    sta remainingScriptActions.w
    
    ; add base size to script ptr
    lda #$07
    jmp addToScriptPtr
  
  sceneOp_waitForAdpcm_handler:
    iny
    lda (newZpScriptReg),Y
    cmp adpcmSyncCounter.w
    beq @done
    bcs @notDone
    @done:
      ; subtract actual trigger time of last adpcm event
      ; from current time.
      ; this accounts for any possible time overrun
      ; (e.g. if a line was still being rendered at the time
      ; the waitForAdpcm event was supposed to occur, causing
      ; it to trigger late)
      lda syncFrameCounter+0.w
      sec
      sbc syncFrameCounterAtLastAdpcmSync+0.w
      sta syncFrameCounter+0.w
      
      lda syncFrameCounter+1.w
      sbc syncFrameCounterAtLastAdpcmSync+1.w
      sta syncFrameCounter+1.w
      
      ; prevent further evaluation of script
      ; (to ensure that the next script action begins at
      ; a frame boundary, for better synchronization)
      lda #$01
      sta remainingScriptActions.w
      
      tya
      ina
      jmp addToScriptPtr
    @notDone:
    ; prevent further evaluation of script
    lda #$01
    sta remainingScriptActions.w
    rts
  
  sceneOp_queueSubsOff_hander:
    iny
    lda (newZpScriptReg),Y
    sta queuedSubsOffTime+0.w
    iny
    lda (newZpScriptReg),Y
    sta queuedSubsOffTime+1.w
    
    tya
    ina
    sta queuedSubsOffIsOn.w
    jmp addToScriptPtr
  
  sceneOp_writeMem_hander:
    iny
    lda (newZpScriptReg),Y
    sta @dstOp+1.w
    iny
    lda (newZpScriptReg),Y
    sta @dstOp+2.w
    iny
    lda (newZpScriptReg),Y
    sta @valueOp+1.w
    
    @valueOp:
    lda #$00
    @dstOp:
    sta $0000.w
    
    tya
    ina
    jmp addToScriptPtr
  
  sceneOp_andOr_hander:
    iny
    lda (newZpScriptReg),Y
    sta @dstOp+1.w
    sta @srcOp+1.w
    iny
    lda (newZpScriptReg),Y
    sta @dstOp+2.w
    sta @srcOp+2.w
    iny
    lda (newZpScriptReg),Y
    sta @andOp+1.w
    iny
    lda (newZpScriptReg),Y
    sta @orOp+1.w
    
    @srcOp:
    lda $0000.w
    @andOp:
    and #$00
    @orOp:
    ora #$00
    @dstOp:
    sta $0000.w
    
    tya
    ina
    jmp addToScriptPtr
  
  addToScriptPtr:
    clc
    adc newZpScriptReg
    sta newZpScriptReg
    cla
    adc newZpScriptReg+1
    sta newZpScriptReg+1
    rts
  
/*  getNextScriptByte:
    @getCmd:
    lda subtitleScriptData.w
    rts
  
  incScript:
    @getCmd:
    inc getNextScriptByte@getCmd+1.w
    bne +
      inc getNextScriptByte@getCmd+2.w
    +:
    rts */
  
  ; newZpFreeReg = state buffer pointer
  ; X = line number
;  prepBufferedLineForDisplay:
;    ; TODO
;    rts
  
  ; A = raw codepoint
  printSubtitleChar:
    ; clear char comp buffer
;    pha
      jsr clearSubtitleCharCompBuffer
;    pla
    
    ; convert from raw codepoint to font index
    sec
    sbc #sceneFontCharsBase
    
    pha
      ; look up pointer to target char
      asl
      tax
      lda ovlScene_fontLut+0.w,X
      sta newZpFreeReg+0
      lda ovlScene_fontLut+1.w,X
      sta newZpFreeReg+1
      
      ; copy bitmap to buffer
      ; x starts at (targetLine * 3),
      ; because we want a blank line at the top
      ; to allow for potential outline effects there
      ldx #bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines
      ; bitshift optimization
      lda activeSubtitleXPos.w
      and #$0F
      cmp #$05
      bcc +
        inx
      +:
      cmp #$0D
      bcc +
        inx
      +:
      cly
      -:
        lda (newZpFreeReg),Y
        sta subtitleCharCompBuffer.w,X
        iny
        inx
        inx
        inx
        cpx #(bytesPerSceneFontChar*3)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        bcc -
      
      ; NOTE: for future reference, here is the original shift routine
      ; before the more space-intensive loop unrolling was applied...
/*      ; apply right-shift to data
      lda activeSubtitleXPos.w
      and #$0F
      beq @noRightShift
      cmp #$05
      bcc @rightShiftLeftTwo
      cmp #$09
      bcc @leftShiftLeftTwo
      cmp #$0D
      bcc @rightShiftRightTwo
      @leftShiftRightTwo:
        eor #$FF
        ina
        and #$03
        ; shift only the lines that are not empty
        ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        --:
        tay
          -:
            asl subtitleCharCompBuffer+2.w,X
            rol subtitleCharCompBuffer+1.w,X
            dey
            bne -
          inx
          inx
          inx
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
          bcc --
        bra @noRightShift
      @rightShiftLeftTwo:
        and #$07
        beq @noRightShift
        ; shift only the lines that are not empty
        ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        --:
        tay
          -:
            lsr subtitleCharCompBuffer+0.w,X
            ror subtitleCharCompBuffer+1.w,X
            dey
            bne -
          inx
          inx
          inx
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
          bcc --
        bra @noRightShift
      @leftShiftLeftTwo:
        and #$07
        beq @noRightShift
        eor #$FF
        ina
        and #$03
        ; shift only the lines that are not empty
        ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        --:
        tay
          -:
            asl subtitleCharCompBuffer+1.w,X
            rol subtitleCharCompBuffer+0.w,X
            dey
            bne -
          inx
          inx
          inx
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
          bcc --
        bra @noRightShift
      @rightShiftRightTwo:
        and #$07
        beq @noRightShift
        ; shift only the lines that are not empty
        ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        --:
        tay
          -:
            lsr subtitleCharCompBuffer+1.w,X
            ror subtitleCharCompBuffer+2.w,X
            dey
            bne -
          inx
          inx
          inx
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
          bcc -- */
      
      ; apply right-shift to data
      lda activeSubtitleXPos.w
      and #$0F
      bne +
        jmp @noRightShift
      +:
      cmp #$05
      bcs +
        jmp @rightShiftLeftTwo
      +:
      cmp #$09
      bcs +
        jmp @leftShiftLeftTwo
      +:
      cmp #$0D
      bcs +
        jmp @rightShiftRightTwo
      +:
      @leftShiftRightTwo:
        eor #$FF
        ina
        and #$03
        dea
        bne +
          jmp @leftShiftRightTwo_shift1
        +:
        dea
        bne +
          jmp @leftShiftRightTwo_shift2
        +:
        @leftShiftRightTwo_shift3:
          leftShiftRightTwoLoop
        @leftShiftRightTwo_shift2:
          leftShiftRightTwoLoop
        @leftShiftRightTwo_shift1:
          leftShiftRightTwoLoop
        jmp @noRightShift
      @rightShiftLeftTwo:
        and #$07
        bne +
          jmp @noRightShift
        +:
        dea
        bne +
          jmp @rightShiftLeftTwo_shift1
        +:
        dea
        bne +
          jmp @rightShiftLeftTwo_shift2
        +:
        dea
        bne +
          jmp @rightShiftLeftTwo_shift3
        +:
        ; shift only the lines that are not empty
        @rightShiftLeftTwo_shift4:
          rightShiftLeftTwoLoop
        @rightShiftLeftTwo_shift3:
          rightShiftLeftTwoLoop
        @rightShiftLeftTwo_shift2:
          rightShiftLeftTwoLoop
        @rightShiftLeftTwo_shift1:
          rightShiftLeftTwoLoop
        jmp @noRightShift
      @leftShiftLeftTwo:
        and #$07
        bne +
          jmp @noRightShift
        +:
        eor #$FF
        ina
        and #$03
        
        dea
        bne +
          jmp @leftShiftLeftTwo_shift1
        +:
        dea
        bne +
          jmp @leftShiftLeftTwo_shift2
        +:
        @leftShiftLeftTwo_shift3:
          leftShiftLeftTwoLoop
        @leftShiftLeftTwo_shift2:
          leftShiftLeftTwoLoop
        @leftShiftLeftTwo_shift1:
          leftShiftLeftTwoLoop
        jmp @noRightShift
      @rightShiftRightTwo:
        and #$07
        bne +
          jmp @noRightShift
        +:
        dea
        bne +
          jmp @rightShiftRightTwo_shift1
        +:
        dea
        bne +
          jmp @rightShiftRightTwo_shift2
        +:
        dea
        bne +
          jmp @rightShiftRightTwo_shift3
        +:
        ; shift only the lines that are not empty
        @rightShiftRightTwoo_shift4:
          rightShiftRightTwoLoop
        @rightShiftRightTwo_shift3:
          rightShiftRightTwoLoop
        @rightShiftRightTwo_shift2:
          rightShiftRightTwoLoop
        @rightShiftRightTwo_shift1:
          rightShiftRightTwoLoop
      
/*      and #$07
      beq @noRightShift
      cmp #$05
      bcc @doRightShift
      @doLeftShift:
        eor #$FF
        ina
        and #$03
        ; shift only the lines that are not empty
        ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        --:
        tay
          -:
            asl subtitleCharCompBuffer+2.w,X
            rol subtitleCharCompBuffer+1.w,X
            rol subtitleCharCompBuffer+0.w,X
            
            dey
            bne -
          inx
          inx
          inx
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
          bcc --
        bra @noRightShift
      @doRightShift:
;        clx
        ; shift only the lines that are not empty
        ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        --:
        tay
          -:
            lsr subtitleCharCompBuffer+0.w,X
            ror subtitleCharCompBuffer+1.w,X
            ror subtitleCharCompBuffer+2.w,X
            
            dey
            bne -
          inx
          inx
          inx
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
          bcc -- */
      
      @noRightShift:
      
      ; merge with current pattern
      lda activeSubtitleCompBufferPtr+0.w
      sta newZpFreeReg+0
      lda activeSubtitleCompBufferPtr+1.w
      sta newZpFreeReg+1
      
;      clx
      ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
;      cly
      ldy #(numSubtitleFontCharTopPaddingLines*2)
      -:
        ; get left pattern
        lda (newZpFreeReg),Y
        ; OR with char buffer
        ; (note that the endianness is swapped here
        ; to match the output sprite format)
        ora subtitleCharCompBuffer+1.w,X
        ; write back
        sta (newZpFreeReg),Y
        iny
        
        ; repeat for right pattern
        lda (newZpFreeReg),Y
        ora subtitleCharCompBuffer+0.w,X
        sta (newZpFreeReg),Y
        iny
        
        inx
        inx
        inx
;        cpy #spritePatternH*2
        cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        bcc -
    
    ; restore character index
    pla
    
    ; get char width and add to x-pos
    tax
    ; save currentX/16
    lda activeSubtitleXPos.w
    pha
;      lsr
;      lsr
;      lsr
;      lsr
      and #$F0
      sta @spanCheck+1.w
    pla
    clc
    adc ovlScene_fontWidthTable.w,X
    sta activeSubtitleXPos.w
    ; check currentX/16 against newX/16
;    lsr
;    lsr
;    lsr
;    lsr
    and #$F0
    ; self-modifying
    @spanCheck:
    cmp #$00
    ; if currentX/16 != newX/16, transfer spans two patterns
    ; (or goes exactly to end of current one)
    beq @noSpan
      
      ; note that there is an extra pattern at the end of the buffer
      ; to account for the rare possibility that every single available
      ; pattern is filled to capacity, and this routine attempts to
      ; initialize the "next" pattern (which nominally shouldn't exist)
      
      ; advance to next pattern
      jsr advanceActiveSubtitleCompBufferPtrToNextPattern
      ; copy right side of char comp buffer to left side of new buffer
;      clx
      ldx #(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
;      cly
      ; targeting NEXT pattern after the initial one
      ; and we are swapping the endianness, so target is +1
      ldy #bytesPerSpritePatternPlane+1+(numSubtitleFontCharTopPaddingLines*2)
      -:
        lda subtitleCharCompBuffer+2.w,X
        sta (newZpFreeReg),Y
        
        iny
        iny
        inx
        inx
        inx
;        cpx #spritePatternH*bytesPerSubtitleCharCompBufferLine
        cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)
        bcc -
    @noSpan:
    
    rts
  
  ; used to clear out memory blocks with TAI
  blockClearWord:
    .dw $0000
    
  clearSubtitleCharCompBuffer:
    tai blockClearWord,subtitleCharCompBuffer,subtitleCharCompBufferSize
    rts
  
  resetAllStateQueueFields:
    lda #<subtitleStates
    sta newZpFreeReg+0
    lda #>subtitleStates
    sta newZpFreeReg+1
    ldx activeLineCount.w
    -:
      jsr resetSubtitleStateQueueFields
      
      ; advance to next state
      lda newZpFreeReg+0
      clc
      adc #_sizeof_SubtitleCompBufferLineState
      sta newZpFreeReg+0
      cla
      adc newZpFreeReg+1
      sta newZpFreeReg+1
      
      dex
      bne -
    
    rts
  
  ; newZpFreeReg = pointer to state
  resetSubtitleStateQueueFields:
    ; copy numPatterns to patternTransfersLeft
    ldy #SubtitleCompBufferLineState.numPatterns
    lda (newZpFreeReg),Y
    iny
    sta (newZpFreeReg),Y
    
    ; copy startPtr to currentPtr
    ldy #SubtitleCompBufferLineState.startPtr
    lda (newZpFreeReg),Y
    pha
      iny
      lda (newZpFreeReg),Y
      ldy #SubtitleCompBufferLineState.currentPtr+1
      sta (newZpFreeReg),Y
    pla
    dey
    sta (newZpFreeReg),Y
    rts
  
  resetSubtitleCompBuffers:
    ; clear all existing buffer content
    tai blockClearWord,bufferResetArea,endOfBufferResetArea-bufferResetArea
    
    ; reset current buffer pointer, and first state's buffer pointer,
    ; to start of buffer
    lda #<subtitleCompBuffers
    sta activeSubtitleCompBufferPtr+0.w
    sta subtitleStates+SubtitleCompBufferLineState.startPtr+0.w
    lda #>subtitleCompBuffers
    sta activeSubtitleCompBufferPtr+1.w
    sta subtitleStates+SubtitleCompBufferLineState.startPtr+1.w
    
    ; reset active state pointer to first state
    lda #<subtitleStates
    sta activeSubtitleStatePtr+0.w
    lda #>subtitleStates
    sta activeSubtitleStatePtr+1.w
    
    rts
  
  advanceActiveSubtitleCompBufferPtrToNextPattern:
    lda activeSubtitleCompBufferPtr+0.w
    clc
    adc #bytesPerSpritePatternPlane
    sta activeSubtitleCompBufferPtr+0.w
    sta @clearCmd+3.w
    cla
    adc activeSubtitleCompBufferPtr+1.w
    sta activeSubtitleCompBufferPtr+1.w
    sta @clearCmd+4.w
    
    ; clear next pattern
    ; self-modifying
    @clearCmd:
    tai blockClearWord,$0000,bytesPerSpritePatternPlane
    
    rts
  
  finishCurrentSubtitleBufferLine:
    ; copy pointer to zp reg for access
    lda activeSubtitleStatePtr+0.w
    sta newZpFreeReg+0
    lda activeSubtitleStatePtr+1.w
    sta newZpFreeReg+1
    
    ; set final width
    lda activeSubtitleXPos.w
    ldy #SubtitleCompBufferLineState.pixelW
    sta (newZpFreeReg),Y
    pha
      ; set numPatterns
      iny
      ; (pixelX - 1)/16 yields the correct number.
      ; HOWEVER: due to a subsequent change in the font shadow generator,
      ; we now need a two-pixel margin on the right edge.
      ; a one-pixel margin is guaranteed by the font itself
      ; (every character has a pixel of space on the right).
      ; but we need a second one here to allow space for the rightmost
      ; pixel column of the outline.
      ; due to fortuitous laziness in the pattern initialization code,
      ; a pixelX that is divisible by 16 results in an otherwise-extraneous
      ; pattern getting allocated for the string, so all we have to do
      ; to get our extra pixel (+pattern) is not do a decrement here.
      ; simple, right?
;      dea
      lsr
      lsr
      lsr
      lsr
      ina
      sta (newZpFreeReg),Y
      ; set patternTransfersLeft
/*      iny
      sta (newZpFreeReg),Y
      
      ; copy startPtr to currentPtr
      ldy #SubtitleCompBufferLineState.startPtr
      lda (newZpFreeReg),Y
      pha
        iny
        lda (newZpFreeReg),Y
        ldy #SubtitleCompBufferLineState.currentPtr+1
        sta (newZpFreeReg),Y
      pla
      dey
      sta (newZpFreeReg),Y */
      jsr resetSubtitleStateQueueFields
    pla
    
    ; round up to next plane start in composition buffer
;    ldy #SubtitleCompBufferLineState.pixelW
;    lda (newZpFreeReg),Y
    ; if at a 16-pixel boundary, no advance needed
    and #$0F
    beq +:
      jsr advanceActiveSubtitleCompBufferPtrToNextPattern
    +:
    
    ; advance active state to next
    lda newZpFreeReg+0
    clc
    adc #<_sizeof_SubtitleCompBufferLineState
    sta newZpFreeReg+0
    sta activeSubtitleStatePtr+0.w
;    lda newZpFreeReg+1
;    adc #>_sizeof_SubtitleCompBufferLineState
    cla
    adc newZpFreeReg+1
    sta newZpFreeReg+1
    sta activeSubtitleStatePtr+1.w
    
;    ; set new state's startPtr to plane start
;;    ldy #SubtitleCompBufferLineState.startPtr
;    cly
;    lda activeSubtitleCompBufferPtr+0.w
;    pha
;      sta (newZpFreeReg),Y
;      iny
;      lda activeSubtitleCompBufferPtr+1.w
;      sta (newZpFreeReg),Y
;      ; copy to currentPtr
;      ldy #SubtitleCompBufferLineState.currentPtr+1
;      sta (newZpFreeReg),Y
;    pla
;    dey
;    sta (newZpFreeReg),Y
    
    ; set new state's start to plane start
;    ldy #SubtitleCompBufferLineState.startPtr
    cly
    lda activeSubtitleCompBufferPtr+0.w
    sta (newZpFreeReg),Y
    iny
    lda activeSubtitleCompBufferPtr+1.w
    sta (newZpFreeReg),Y
    ; clear size so we can use this as a sentinel indicating end of list
    ; (if it is in fact at the end)
;    iny
;    cla
;    sta (newZpFreeReg),Y
    
    ; copy new active state pointer back from zp reg
;    lda newZpFreeReg+0
;    sta activeSubtitleStatePtr+0.w
;    lda newZpFreeReg+1
;    sta activeSubtitleStatePtr+1.w
    
    ; reset x-pos
    stz activeSubtitleXPos.w
    
    ; increment count of active lines
    inc activeLineCount.w
    
    rts
  
  turnSubsOff:
    stz subtitleDisplayOn.w
    
    ; blank out the subtitles sprites from the sat
    lda currentSubtitleSpriteAttributeQueueSize.w
    beq @done
      ; set size of the area to blank
;      asl
;      asl
;      asl
      sta @transferToSatCmd+5.w
      
      ; set write address
      st0 #$00
      st1 #<satVramAddr
      st2 #>satVramAddr
      
      ; start write
      st0 #$02
      
      @transferToSatCmd:
      tia zeroPlanes,$0002,$0000
      
      ; initiate sat->satb dma
      st0 #$13
      st1 #<satVramAddr
      st2 #>satVramAddr
    @done:
    rts
.ends

;=============================
; memory
;=============================

.bank 0 slot 0
.section "memory 1" free
  ; everything in here is cleared to zero by a buffer reset
  bufferResetArea:
    subtitleCharCompBuffer:
      .ds subtitleCharCompBufferSize,$00
    
    activeSubtitleXPos:
      .db $00
    
    activeLineCount:
      .db $00
    
    subtitleStates:
      ; this needs to be +1 due to "overflow"
      ; in finishCurrentSubtitleBufferLine
      .ds (numSubtitleCompBufferLines+1)*_sizeof_SubtitleCompBufferLineState,$00
    
    subtitleCompBuffers:
      ; only the first composition buffer is cleared in the reset.
      ; the rest are cleared procedurally during the composition process
      .ds bytesPerSpritePatternPlane,$00
  endOfBufferResetArea:
    ; this SHOULD use one less pattern than the computed amount
    ; to account for the extra pattern in the reset area above...
    ; but since we don't have special handling for the case where
    ; the very last pattern is fully filled and the "next" pattern after
    ; it need to get initialized, we need an extra pattern for possible
    ; "overflow" anyway
;      .ds (numSubtitleCompBufferLines*bytesPerSubtitleCompLineBuffer-bytesPerSpritePatternPlane),$00
      .ds (numSubtitleCompBufferLines*bytesPerSubtitleCompLineBuffer),$00
  
  activeSubtitleCompBufferPtr:
    .dw subtitleCompBuffers
  activeSubtitleStatePtr:
    .dw subtitleStates
  
  currentSubtitlePaletteIndex:
    .db $FF
  
  subtitleAttributeTransferOn:
    .db $00
  subtitleAttributeTransferCurrentStatePtr:
    .dw $0000
;  subtitleAttributeTransferEndLineNum:
;    .db $00
  subtitleAttributeTransferVramPutPos:
    .dw $0000
  subtitleAttributeTransferLineNum:
    .db $00
  
  subtitleGraphicsTransferOn:
    .db $00
  subtitleGraphicsTransferCurrentStatePtr:
    .dw $0000
  subtitleGraphicsTransferVramPutPos:
    .dw $0000
  subtitleGraphicsTransferLineNum:
    .db $00
  
  
  subtitleDisplayOn:
    .db $00
  ; 0 = queue A is back (write), queue B is front (display)
  ; 1 = queue B is back, queue A is front
  subtitleDisplayQueueParity:
    .db $00
  subtitleDisplayQueuePointerArray:
    .dw subtitleSpriteAttributeQueueA
    .dw subtitleSpriteAttributeQueueB
  subtitleDisplayQueueSizeArray:
    .db $00
    .db $00
  subtitleDisplayBackQueuePutPos:
    .dw $0000
;  subtitleDisplayBackQueuePutPos:
;    .db $00
  subtitleDisplayQueueCurrentX:
    .db $00
  subtitleDisplayQueueCurrentY:
    .db $00
  
  subtitleSpriteAttributeQueueA:
    .ds _sizeof_SpriteAttribute*maxNumSubtitleSprites,$00
  subtitleSpriteAttributeQueueB:
    .ds _sizeof_SpriteAttribute*maxNumSubtitleSprites,$00
  
  currentSubtitleSpriteAttributeQueuePtr:
    .dw $0000
  currentSubtitleSpriteAttributeQueueSize:
    .db $00
  
  subtitleScriptPtr:
    .dw subtitleScriptData
  
  queuedSubsOffTime:
    .dw $0000
  queuedSubsOffIsOn:
    .db $00
  
;  subtitleSpriteClearNeeded:
;    .db $00
  
  ; reset to this at start of new subtitle
;  fontSpriteBaseVramTarget:
;    .dw $0000
  ; next converted font sprite goes here
;  fontSpriteNextVramTarget:
;    .dw $0000
  
;  subtitleBaseX:
;    .db 128
  subtitleBaseY:
    .db 208
.ends
