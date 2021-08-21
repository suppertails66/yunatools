
;==============================================================================
; required defines
;==============================================================================

;==============================================================================
; various overwrites and patches
;==============================================================================

;=============================
; sync var
;=============================

;.bank 0 slot 0
;.orga playAdpcm+($6BA9-$6BA9)
;.section "var sync 2" SIZE 9 overwrite
;  jsr ovlScene_jumpTable_setUpStdBanks
;  jsr incrementAdpcmSyncCounter
;  jmp playAdpcm+($6BB7-$6BA9)
;.ends

.bank 0 slot 0
.section "var sync 3" free
  incrementSyncVarCounterAndBgOff:
    bsr incrementSyncVarCounter
    ; make up work
    jmp EX_BGOFF
    
  incrementSyncVarCounterAndSprClr:
    bsr incrementSyncVarCounter
    ; make up work
    jmp clearAndSendSubtitleExclusionOverwrite
  
  incrementSyncVarCounter:
    sei
      nop
      inc syncVar.w
      
      lda syncFrameCounter+0.w
      sta syncFrameCounterAtLastVarSync+0.w
      lda syncFrameCounter+1.w
      sta syncFrameCounterAtLastVarSync+1.w
    
      ; we actually want this value plus one, since we know that
      ; syncFrameCounter will be incremented at the next sync period
      ; and that incremented value is what the scripts check against
      inc syncFrameCounterAtLastVarSync+0.w
      bne +
        inc syncFrameCounterAtLastVarSync+1.w
      +:
    cli
    rts
.ends

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

; looool, someone forgot about interruuuuupts!
/*.bank 0 slot 0
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
    
;    inc noSubtitleSatbThisFrame.w
;    jsr $E09F
    
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
    
    lda currentSubtitleSpriteAttributeQueueSize.w
    beq @doStandardClear
    
    ; blank everything EXCEPT the subtitle sprites from the SAT
    ; set size of the area to blank
    lsr
    pha
      eor #$FF
      ina
      sta @clearSizeCmd+1.w
    pla
    
    ; set write address
    st0 #$00
    ; note: this will never carry, so we don't bother with the high byte.
    ; and on further reflection, the low byte of satVramAddr is zero anyway,
    ; so why bother with the addition at all?
;    clc
;    adc #<satVramAddr
;    st1 #<satVramAddr
    sta $0002.w
    st2 #>satVramAddr
    
    @clearSizeCmd:
    ldx #$00
    jmp doVramClear
    
;    @done:
;    rts
  
  noSubtitleSatbThisFrame:
    .db $00
.ends */

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
    
;    inc noSubtitleSatbThisFrame.w
;    jsr $E09F
    
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
    
/*    lda currentSubtitleSpriteAttributeQueueSize.w
    beq @doStandardClear
    
    ; blank everything EXCEPT the subtitle sprites from the SAT
    ; set size of the area to blank
    lsr
    pha
      eor #$FF
      ina
      sta @clearSizeCmd+1.w
    pla
    
    ; set write address
    st0 #$00
    ; note: this will never carry, so we don't bother with the high byte.
    ; and on further reflection, the low byte of satVramAddr is zero anyway,
    ; so why bother with the addition at all?
;    clc
;    adc #<satVramAddr
;    st1 #<satVramAddr
    sta $0002.w
    st2 #>satVramAddr
    
    @clearSizeCmd:
    ldx #$00
    jmp doVramClear */
  
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
; adpcm playback sync
;=============================

;.bank 0 slot 0
;.section "adpcm sync 1" free
;  adpcmSyncCounter:
;    .db $00
;.ends

; this routine does not exist in scene 1C,
; so we must account for that possibility
/*.ifdef playAdpcm

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
      inc adpcmSyncCounter.w
      
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
      
      ; make up work
      lda $00FA
      bne +
      ; if
        stz playAdpcm+($6C72-$6BA9).w
        bra ++
      ; else
      +:
        lda #$40
        sta playAdpcm+($6C72-$6BA9).w
      ++:
      rts
  .ends

.endif */


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

;.block "new stuff"
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
;  adpcmSyncCounter:
;    .db $00
  ; the value of syncFrameCounter the last time that
  ; adpcmSyncCounter was incremented
;  syncFrameCounterAtLastAdpcmSync:
;    .dw $0000
  syncVar:
    .db $00
  syncFrameCounterAtLastVarSync:
    .dw $0000
  
  oldPaletteTransferFlag:
    .db $00
  
;  noSubtitleSatbThisFrame:
;    .db $00
  
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
    txa
    ; these trigger some sort of palette effects that similarly
    ; consume time
    ; (TODO: these may or may not require additional attention depending
    ; on what they actually do)
    ora $63
    ora $66
;    sta oldPaletteTransferFlag.w
    ; well, i guess we're throwing caution to the winds...
    
    ; make up work
    jsr syncMakeup1
    jsr syncMakeup2
    
;    lda noSubtitleSatbThisFrame.w
;    beq ++
;      rts
;    ++:
    
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
      
      ; ...unless they've been overridden for this frame
;      lda noSubtitleSatbThisFrame.w
;;      stz noSubtitleSatbThisFrame.w
;      bne +

;      lda noSubtitleSatbThisFrame.w
;;      stz noSubtitleSatbThisFrame.w
;      beq ++
;        rts
;      ++:
      
      ; if auto vreg protect is on, assume we cannot touch mawr
      ; if flag is set, and do not attempt to force sprites
      ; (afaict the only time this ever happens is the credits,
      ; because text printing does not protect its mawr sets)
      .ifdef enableSceneAutoVregProtect
        bbr6 $F5,+
      .endif
      
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
        tax
        jsr doVramClear
        
        ; clear trigger flag
        stz triggerNonSubtitleSpriteClear.w
      ++:
      
      ; initiate sat->satb dma
      st0 #$13
      st1 #<satVramAddr
      st2 #>satVramAddr
      
      ; force sprite display on
      smb6 $F3
;      lda $F3
;      ora #$40
;      st0 #$05
;      sta $0002.w
    
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
      lda newZpFreeReg
      pha
      lda newZpFreeReg+1
      pha
      lda newZpScriptReg
      pha
      lda newZpScriptReg+1
      pha
        
        ;=====
        ; if attribute transfer active
        ;=====
        
/*        lda subtitleAttributeTransferOn.w
        beq +
          lda #maxSpriteAttrTransfersPerIteration
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
          lda #maxSpriteGrpTransfersPerIteration
          
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
        +: */
        
        stz @didGrpTransfer.w
        
        lda spriteGrpGenAndTransferNeeded.w
        beq +
          ; cannot touch mawr if autoprotect on and flagged
          .ifdef enableSceneAutoVregProtect
            bbr6 $F5,@actionsDone
          .endif
        
          jsr doSpriteGrpGenAndTransfer
          inc @didGrpTransfer.w
          ; allow attribute generation after a graphics transfer
          ; TODO: safe?
          ; also, in practice, i'm pretty sure attribute generation
          ; will never be triggered without a preceding graphics
          ; transfer, so this could probably be simplified somehow
;          bra @actionsDone
        +:
        
        lda spriteAttrGenAndTransferNeeded.w
        beq +
          ; cannot touch mawr if autoprotect on and flagged
          .ifdef enableSceneAutoVregProtect
            bbr6 $F5,@actionsDone
          .endif
          
          jsr doSpriteAttrGenAndTransfer
          bra @actionsDone
        +:
        
        ; do not evaluate script if we did a graphics transfer
        lda @didGrpTransfer.w
        bne @actionsDone
        
        ;=====
        ; run script
        ;=====
        
        lda subtitleScriptPtr.w
        sta newZpScriptReg
        lda subtitleScriptPtr+1.w
        sta newZpScriptReg+1
        
;        lda #maxScriptActionsPerIteration
;        sta remainingScriptActions.w
;        -:
          jsr runScript
;          dec remainingScriptActions.w
;          bne -
        
        lda newZpScriptReg
        sta subtitleScriptPtr.w
        lda newZpScriptReg+1
        sta subtitleScriptPtr+1.w
        
      @actionsDone:
      pla
      sta newZpScriptReg+1
      pla
      sta newZpScriptReg
      pla
      sta newZpFreeReg+1
      pla
      sta newZpFreeReg
    @done:
    ; restore old banks
    jmp ovlScene_jumpTable_restoreOldBanks
    
    @didGrpTransfer:
      .db $00
    
;  remainingScriptActions:
;    .db $00
  
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
      jmp (subtitleOpJumpTable,X)
    
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
;    .dw sceneOp_resetCompBuffers_handler
    .dw sceneOp_subsOffNoClear_handler
    ; 04
;    .dw sceneOp_prepAndSendGrp_handler
    .dw sceneOp_subsOnNoClear_handler
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
    .dw sceneOp_startNewString_handler
    ; 0C
;    .dw sceneOp_writePalette_handler
    .dw sceneOp_waitForSyncVar_handler
    ; 0D
;    .dw sceneOp_writeVram_handler
    .dw $0000
    ; 0E
;    .dw sceneOp_waitForAdpcm_handler
    .dw sceneOp_jump_handler
    ; 0F
    .dw sceneOp_queueSubsOff_hander
  
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
;    lda #$01
;    sta remainingScriptActions.w
    rts
  
  sceneOp_br_handler:
;    jsr finishCurrentSubtitleBufferLine
    
    ; if we have a pending (nonempty) sprite, send it first
    lda @finalSendTriggered.w
    bne @done
      ; if line is empty, skip normal send
      lda activeSubtitleXPos.w
      beq @done
      
      ; increment nonempty line count for corresponding group
      lda activeSubtitleLineNum.w
      lsr
      tax
      inc groupNonemptyLineCountArray.w,X
    
      ; as a special case: if the final x-size of the line is divisible
      ; by 16, we need to add one extra, empty sprite for the rightmost
      ; column of the outline to go in
      lda activeSubtitleXPos.w
      and #$0F
      bne ++
        ; this can only be 0 or 1 at this point.
        ; if 1, the left half has already been sent
        ; and the comp buffer is empty.
  ;      lda nextSpriteAttrWidth.w
  ;      bne +
  ;        inc nextSpriteAttrWidth.w
  ;      +:

        ; since the x-size is at a sprite boundary,
        ; the comp buffer is guaranteed to be empty at this point,
        ; so we can just send it again.
        ; the leftover contents of the drop shadow buffer will be
        ; added in when the (empty) graphic is transferred.
        ; we are essentially pretending we printed a one-pixel space
        ; and now need to send it
        inc activeSubtitleXPos.w
      ++:
      
      ; do not advance the script pointer; we will return here
      ; once the transfer completes
      jsr sendNextSpriteBufferAndForceAttributeSend
      inc @finalSendTriggered.w
;      lda #$01
;      sta remainingScriptActions.w
      rts
    +:
    
    @done:
    
    stz @finalSendTriggered.w
    
    ; finish the line
    jsr endCurrentLineComp
    
    lda #$01
    jmp addToScriptPtr
    
    @finalSendTriggered:
    .db $00
  
;  sceneOp_resetCompBuffers_handler:
;    jsr resetSubtitleCompBuffers
;    
;    lda #$01
;    jmp addToScriptPtr
  
/*  sceneOp_prepAndSendGrp_handler:
    lda subtitleDisplayQueueParity.w
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
    jmp addToScriptPtr */
  
  sceneOp_subsOffNoClear_handler:
    stz subtitleDisplayOn.w
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_subsOnNoClear_handler:
    lda #$FF
    sta subtitleDisplayOn.w
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_swapAndShowBuf_handler:
/*    lda subtitleDisplayQueueParity.w
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
    sta subtitleDisplayQueueParity.w */
    jsr endCurrentSubComp
    lda #$FF
    sta subtitleDisplayOn.w
    
    ; reset composition buffers for next string
;    jsr resetSubtitleCompBuffers
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_subsOff_handler:
    jsr turnSubsOff
    
    ; prevent further evaluation of script
;    lda #$01
;    sta remainingScriptActions.w
    
    lda #$01
    jmp addToScriptPtr
  
  sceneOp_finishCurrentLine_handler:
;    jsr finishCurrentSubtitleBufferLine
    ; TODO: good enough?
    jmp sceneOp_br_handler
;    lda #$01
;    jmp addToScriptPtr
  
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
  
  sceneOp_startNewString_handler:
    jsr resetStateForNewString
  
    iny
    lda (newZpScriptReg),Y
    sta nextSpriteAttrVramBase+0.w
    iny
    lda (newZpScriptReg),Y
    sta nextSpriteAttrVramBase+1.w
    
    lda #$03
    jmp addToScriptPtr
  
  sceneOp_waitForSyncVar_handler:
    iny
    lda (newZpScriptReg),Y
    cmp syncVar.w
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
      sbc syncFrameCounterAtLastVarSync+0.w
      sta syncFrameCounter+0.w
      
      lda syncFrameCounter+1.w
      sbc syncFrameCounterAtLastVarSync+1.w
      sta syncFrameCounter+1.w
      
      ; prevent further evaluation of script
      ; (to ensure that the next script action begins at
      ; a frame boundary, for better synchronization)
;      lda #$01
;      sta remainingScriptActions.w
      
      tya
      ina
      jmp addToScriptPtr
    @notDone:
    ; prevent further evaluation of script
;    lda #$01
;    sta remainingScriptActions.w
    rts
    
/*  sceneOp_writePalette_handler:
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
    jmp addToScriptPtr */
  
/*  ; note: it is the caller's responsibility
  ; not to transfer too much at a time
  sceneOp_writeVram_handler:
    ; src
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
    
    ; prevent further evaluation of script
    lda #$01
    sta remainingScriptActions.w
    
    ; add base size to script ptr
    lda #$07
    jmp addToScriptPtr */
  
/*  sceneOp_waitForAdpcm_handler:
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
    rts */
  
  sceneOp_jump_handler:
    iny
    lda (newZpScriptReg),Y
    pha
      iny
      lda (newZpScriptReg),Y
      sta newZpScriptReg+1
    pla
    sta newZpScriptReg+0
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
  
  addToScriptPtr:
    clc
    adc newZpScriptReg
    sta newZpScriptReg
    cla
    adc newZpScriptReg+1
    sta newZpScriptReg+1
    rts
  
  ; A = raw codepoint
  printSubtitleChar:
    ; clear char comp buffer
;    jsr clearSubtitleCharCompBuffer
    tai blockClearWord,subtitleCharCompBuffer,(subtitleCharCompBufferEnd-subtitleCharCompBuffer)
    
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
      clx
      ; bitshift optimization
      lda activeSubtitleXPos.w
      pha
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
          cpx #(bytesPerSceneFontChar*3)
          bcc -
      pla
      
      ; NOTE: original, mostly-unoptimized routine
      and #$07
      beq @noRightShift
      cmp #$05
      bcc @doRightShift
      @doLeftShift:
        eor #$FF
        ina
        and #$03
        ; shift only the lines that are not empty
        clx
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
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
          bcc --
        bra @noRightShift
      @doRightShift:
;        clx
        ; shift only the lines that are not empty
        clx
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
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
          bcc --
      
      ; NOTE: for future reference, here is the original shift routine
      ; before the more space-intensive loop unrolling was applied...
      ; apply right-shift to data
/*;      lda activeSubtitleXPos.w
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
        clx
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
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
          bcc --
        bra @noRightShift
      @rightShiftLeftTwo:
        and #$07
        beq @noRightShift
        ; shift only the lines that are not empty
        clx
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
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
          bcc --
        bra @noRightShift
      @leftShiftLeftTwo:
        and #$07
        beq @noRightShift
        eor #$FF
        ina
        and #$03
        ; shift only the lines that are not empty
        clx
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
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
          bcc --
        bra @noRightShift
      @rightShiftRightTwo:
        and #$07
        beq @noRightShift
        ; shift only the lines that are not empty
        clx
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
          cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
          bcc -- */
      
      ; with max optimization
/*      ; apply right-shift to data
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
          rightShiftRightTwoLoop */
      
      @noRightShift:
      
      ; merge with current pattern
      lda #<subtitleCompBuffer
      sta newZpFreeReg+0
      lda #>subtitleCompBuffer
      sta newZpFreeReg+1
      
      clx
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
        cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
        bcc -
    
    ; restore character index
    pla
    
    ; get char width and add to x-pos
    tax
    ; save currentX/16
    lda activeSubtitleXPos.w
    pha
      and #$F0
      sta @spanCheck+1.w
    pla
    clc
    adc ovlScene_fontWidthTable.w,X
    sta activeSubtitleXPos.w
    ; check currentX/16 against newX/16
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
;      jsr advanceActiveSubtitleCompBufferPtrToNextPattern
      
;      sta spriteGrpGenAndTransferNeeded
      jsr sendNextSpriteBuffer
    @noSpan:
    
    rts
    
;  clearSubtitleCharCompBuffer:
;    tai blockClearWord,subtitleCharCompBuffer,subtitleCharCompBufferSize
;    rts
  
  turnSubsOff:
    stz subtitleDisplayOn.w
    
    ; blank out the subtitles sprites from the sat
    lda currentSubtitleSpriteAttributeQueueSize.w
    beq @done
      ; set size of the area to blank
;      sta @transferToSatCmd+5.w
      lsr
;      sta @clearSizeCmd+1.w
      tax
      
      ; set write address
      st0 #$00
      st1 #<satVramAddr
      st2 #>satVramAddr
      
      ; start write
;      st0 #$02
;      @transferToSatCmd:
;      tia zeroPlanes,$0002,$0000
      
      st0 #$02
      @clearSizeCmd:
;      ldx #$00
      jsr doVramClear
      
      ; initiate sat->satb dma
      st0 #$13
      st1 #<satVramAddr
      st2 #>satVramAddr
    @done:
    rts
  
  doVramClear:
    ; start write
;    cla
    -:
;      sta $0002.w
;      sta $0003.w
      st1 #$00
      st2 #$00
      dex
      bne -
    rts
    
  resetLineClearArea:
    tai blockClearWord,newLineClearAreaStart,newLineClearAreaEnd-newLineClearAreaStart
    rts
  
  resetStateForNewString:
    ; clear the clear area
;    tai blockClearWord,newLineClearAreaStart,newLineClearAreaEnd-newLineClearAreaStart
    jsr resetLineClearArea
    
    ; reset line count
/*    stz activeSubtitleLineNum.w
    ; reset total sprite count
    stz currentSubSpriteCount.w
    stz group1NonemptyLineCount.w
    stz group2NonemptyLineCount.w */
    tai blockClearWord,newStringClearAreaStart,newStringClearAreaEnd-newStringClearAreaStart
    
    ; reset attribute queue pointer
    lda subtitleDisplayQueueParity.w
    asl
    tax
    lda subtitleDisplayQueuePointerArray+0.w,X
    sta currentLineSpriteAttrStartPtr+0.w
    lda subtitleDisplayQueuePointerArray+1.w,X
    sta currentLineSpriteAttrStartPtr+1.w
    
    rts
    
  sendNextSpriteBufferAndForceAttributeSend:
;    lda #$FF
;    sta spriteAttrGenAndTransferNeeded.w
    ; should be safe
    inc spriteAttrGenAndTransferNeeded.w
    ; !!!!! drop through !!!!!
  sendNextSpriteBuffer:
    ; schedule graphics transfer
;    lda #$01
;    sta spriteGrpGenAndTransferNeeded.w
    inc spriteGrpGenAndTransferNeeded.w
    
    ; if adding this pattern makes the sprite 2 patterns wide,
    ; schedule an attribute transfer too
/*    lda nextSpriteAttrWidth.w
    ; assume a nonzero value is 1
    beq +
      sta spriteGrpGenAndTransferNeeded.w
      ; reset width to zero
      lda #$FF
    +:
    ina
    sta nextSpriteAttrWidth.w */
    
    rts
  
  doSpriteGrpGenAndTransfer:
    ; convert the active composition buffer to a sprite and send it
    ; to the next vram position
  
    ;=====
    ; do vram write
    ;=====
    
    lda nextSpriteAttrVramBase+0.w
    ; add in the current sprite width to the base position
    ; (i.e. offset position by 1 if this is the second pattern)
    clc
    adc nextSpriteAttrWidth.w
    sta @vramDstLowerCmd+1.w
    lda nextSpriteAttrVramBase+1.w
    adc #$00
    ; multiply tilenum by 64 to get vram address
    .rept 6
      asl @vramDstLowerCmd+1.w
      rol
    .endr
    sta @vramDstUpperCmd+1.w
    
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
      
    @spritePlaneTransferCmd:
    tii subtitleCompBuffer,charShiftBufferA,bytesPerSpritePatternPlane
    tii charShiftBufferA,dropShadowBufferA,bytesPerSpritePatternPlane
    
    ; do first right shift
    ldx #(numSubtitleFontCharTopPaddingLines*2)
    -:
      lda charShiftBufferA+1.w,X
      lsr
      ora charShiftBufferB+1.w,X
      sta charShiftBufferA+1.w,X
      ora dropShadowBufferA+1.w,X
      ora dropShadowBufferB+1.w,X
      sta dropShadowBufferA+1.w,X
      
      lda charShiftBufferA+0.w,X
      ror
      sta charShiftBufferA+0.w,X
      ora dropShadowBufferA+0.w,X
      sta dropShadowBufferA+0.w,X
      
      cla
      ror
      sta charShiftBufferB+1.w,X
      sta dropShadowBufferB+1.w,X
      
      inx
      inx
      cpx #(bytesPerSpritePatternPlane-(numSubtitleFontCharBottomPaddingLines*2))
      bne -
    
    ; copy first plane
    tia charShiftBufferA,$0002,bytesPerSpritePatternPlane
    
    ; do second right shift
    ldx #(numSubtitleFontCharTopPaddingLines*2)
    -:
      lda charShiftBufferA+1.w,X
      lsr
      ora dropShadowBufferA+1.w,X
      sta dropShadowBufferA+1.w,X
      
      lda charShiftBufferA+0.w,X
      ror
      ora dropShadowBufferA+0.w,X
      sta dropShadowBufferA+0.w,X
      
      lda dropShadowBufferB+1.w,X
      ror
      sta dropShadowBufferB+1.w,X
      
      inx
      inx
      cpx #(bytesPerSpritePatternPlane-(numSubtitleFontCharBottomPaddingLines*2))
      bne -
      
      ; copy remaining planes
      tia dropShadowBufferA-2,$0002,bytesPerSpritePatternPlane
      tia dropShadowBufferA+0,$0002,bytesPerSpritePatternPlane
      ; note that this transfer is safe because dropShadowBufferA is
      ; immediately followed by dropShadowBufferB, whose first two
      ; bytes will always be zero (they're part of the top-row
      ; padding)
      tia dropShadowBufferA+2,$0002,bytesPerSpritePatternPlane
  
    ;=====
    ; update fields
    ;=====
    
    ; copy any overflow from the character composition process
    ; to the left side of the comp buffer, and clear the right side
    clx
;    cly
    ldy #(numSubtitleFontCharTopPaddingLines*2)
    lda #<subtitleCompBuffer
    sta newZpFreeReg+0
    lda #>subtitleCompBuffer
    sta newZpFreeReg+1
    -:
      ; note that we are swapping the endianness here
      
      ; clear right side of buffer
      cla
      sta (newZpFreeReg),Y
      iny
      lda subtitleCharCompBuffer+2.w,X
      sta (newZpFreeReg),Y
      iny
      
      inx
      inx
      inx
      cpx #(linesPerRawSceneFontChar*bytesPerSubtitleCharCompBufferLine)
      bcc -
    
    ; increment sprite width.
    ; if adding this pattern makes the sprite 2 patterns wide,
    ; schedule an attribute transfer
    lda nextSpriteAttrWidth.w
    ; assume a nonzero value is 1
    beq +
      sta spriteAttrGenAndTransferNeeded.w
    +:
    ina
    sta nextSpriteAttrWidth.w
    
    ; clear call flag
    stz spriteGrpGenAndTransferNeeded.w
    rts
  
  doSpriteAttrGenAndTransfer:
    ; get pointer to current attribute putpos
    lda currentLineSpriteCount.w
    asl
    asl
    asl
    clc
    adc currentLineSpriteAttrStartPtr+0.w
    sta newZpFreeReg+0
    cla
    adc currentLineSpriteAttrStartPtr+1.w
    sta newZpFreeReg+1
    
    ; set up fields
    ; Y (placeholder)
    lda activeSubtitleLineNum.w
    asl
    asl
    asl
    asl
    clc
    adc #spriteAttrBaseY
    sta (newZpFreeReg)
    ldy #$01
    cla
    adc #$00
    sta (newZpFreeReg),Y
    
    ; X (placeholder)
    iny
    lda currentLineSpriteCount.w
    ; *32 because everything should be double-width
    ; (except the last sprite, where it doesn't matter)
    asl
    asl
    asl
    asl
    asl
    clc
    ; offset 1 pixel to the left because after generating the outline,
    ; the subtitles will take up 2 more pixels on the right
    adc #spriteAttrBaseX-1
    sta (newZpFreeReg),Y
    iny
    cla
    adc #$00
    sta (newZpFreeReg),Y
    
    ; pattern
    iny
    lda nextSpriteAttrVramBase+0.w
    asl
    sta (newZpFreeReg),Y
    iny
    lda nextSpriteAttrVramBase+1.w
    rol
    sta (newZpFreeReg),Y
    
    ; flags
    ; low byte
    ; apply palette
    ; (note: top bit set = high priority)
    iny
    lda #$80
    ora currentSubtitlePaletteIndex.w
    sta (newZpFreeReg),Y
    iny
    ; high byte
    lda nextSpriteAttrWidth.w
    dea
    sta (newZpFreeReg),Y
    
    ; vram dstpos += 2
    ; (regardless of actual sprite width, because we need the start
    ; positions to be even in order to take advantage of double-width
    ; sprites)
/*    ldx #$02
    -:
      inc nextSpriteAttrVramBase+0.w
      bne +
        inc nextSpriteAttrVramBase+1.w
      +:
      dex
      bne - */
    lda #$02
    clc
    adc nextSpriteAttrVramBase+0.w
    sta nextSpriteAttrVramBase+0.w
    bcc +
      inc nextSpriteAttrVramBase+1.w
    +:
    
    ; reset sprite width
    stz nextSpriteAttrWidth.w
    
    ; increment line sprite count
    inc currentLineSpriteCount.w
    ; increment total sprite count
    inc currentSubSpriteCount.w
    
    ; clear call flag
    stz spriteAttrGenAndTransferNeeded.w
    rts
  
  ; this is called after the final transfer for the line has already
  ; been performed
  endCurrentLineComp:
    ;=====
    ; apply centering x-offset to current line's attributes
    ;=====
    
    ; centering offset = (256 - width) / 2
    lda activeSubtitleXPos.w
    eor #$FF
    ina
    lsr
    sta @xCenterOffset.w
    
    lda currentLineSpriteAttrStartPtr+0.w
    sta newZpFreeReg+0
    lda currentLineSpriteAttrStartPtr+1.w
    sta newZpFreeReg+1
    
    ldx currentLineSpriteCount.w
    ldy #02
    -:
      lda (newZpFreeReg),Y
      clc
      adc @xCenterOffset.w
      sta (newZpFreeReg),Y
      
      iny
      cla
      adc (newZpFreeReg),Y
      sta (newZpFreeReg),Y
      
      
      tya
      clc
      adc #$07
      tay
      
      dex
      bne -
    
    ;=====
    ; update and reset fields as needed
    ;=====
    
    ; update line attribute queue pointer
    lda currentLineSpriteCount.w
    asl
    asl
    asl
    clc
    adc currentLineSpriteAttrStartPtr+0.w
    sta currentLineSpriteAttrStartPtr+0.w
;    cla
;    adc currentLineSpriteAttrStartPtr+1.w
;    sta currentLineSpriteAttrStartPtr+1.w
    bcc +
      inc currentLineSpriteAttrStartPtr+1.w
    +:
    
    ; reset fields that need to be reset
    jsr resetLineClearArea
    inc activeSubtitleLineNum.w
    
    rts
    
    @xCenterOffset:
      .db $00
  
  endCurrentSubComp:
    ;=====
    ; update and reset fields as needed
    ;=====
    
    ; set the attribute display start pointer
    lda subtitleDisplayQueueParity.w
    pha
      asl
      tax
      lda subtitleDisplayQueuePointerArray+0.w,X
      sta currentSubtitleSpriteAttributeQueuePtr+0.w
      sta newZpFreeReg+0
      lda subtitleDisplayQueuePointerArray+1.w,X
      sta currentSubtitleSpriteAttributeQueuePtr+1.w
      sta newZpFreeReg+1
      
      ; set the attribute queue size
      lda currentSubSpriteCount.w
      asl
      asl
      asl
      sta currentSubtitleSpriteAttributeQueueSize.w
    pla
    ; swap display parity
    ina
    and #$01
    sta subtitleDisplayQueueParity.w
    
    ;=====
    ; apply base y-offset
    ;=====
    
    ; multiply line count by 8, then subtract from base Y
    ; to center around target y-offset
;    lda activeSubtitleLineNum.w
    clx
    -:
      lda groupNonemptyLineCountArray.w,X
      asl
      asl
      asl
      sec
      sbc subtitleBaseY.w
      eor #$FF
      ina
      sta @yCenterOffsetArray.w,X
      
      inx
      cpx #$02
      bne -
    
    ; HACK: shift group 2's lines to the top of the screen
    ; (we know the y-offset is 208, even though it's not
    ; actually defined as a constant, and we want it to
    ; instead be centered around 32)
    sec
    sbc #$B8
    sta @yCenterOffsetGroup2.w
    
    ; add this to the y-offset of everything in the queue
;    lda currentLineSpriteAttrStartPtr+0.w
;    sta newZpFreeReg+0
;    lda currentLineSpriteAttrStartPtr+1.w
;    sta newZpFreeReg+1
    
;    ldx currentSubSpriteCount.w
    ldx currentSubSpriteCount.w
    cly
    -:
      lda (newZpFreeReg),Y
      
      ; HACK: detect if group 1 (y >= $40) or group 2 (y >= $60)
      cmp #(spriteAttrBaseY+(spritePatternH*2))
      bcc +
        ; HACK: subtract off the extra offset, because the 8-bit range
        ; isn't enough to do this right
        sec
        sbc #$20
        sta (newZpFreeReg),Y
        
        lda @yCenterOffsetGroup2.w
        bra ++
      +:
        lda @yCenterOffsetGroup1.w
      ++:
      
      clc
      adc (newZpFreeReg),Y
      sta (newZpFreeReg),Y
      
      iny
      cla
      adc (newZpFreeReg),Y
      sta (newZpFreeReg),Y
      
      tya
      clc
      adc #$07
      tay
      
      dex
      bne -
    
    rts
    
    @yCenterOffsetArray:
    @yCenterOffsetGroup1:
      .db $00
    @yCenterOffsetGroup2:
      .db $00
;    @count:
;      .db $00
  
.ends

;=============================
; memory
;=============================

.bank 0 slot 0
.section "memory 1" free
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
;  subtitleDisplayBackQueuePutPos:
;    .dw $0000
;  subtitleDisplayBackQueuePutPos:
;    .db $00
;  subtitleDisplayQueueCurrentX:
;    .db $00
  
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
  ; shifting up 2 pixels to avoid what would otherwise be a visible
  ; sprite limit error in the scene with elner flying in front of
  ; a glowing yuna ("anata no mono yo dreaming girl").
  ; (it's actually still there, but only briefly and mostly concealed
  ; by the text)
  ; the padding amount has been adjusted to compensate, so everything
  ; remains in the same relative position
  subtitleBaseY:
    .db 208-2
  
  currentSubtitlePaletteIndex:
    .db $FF
  
  ; these fields need to be reset to zero at the start of a new string
  newLineClearAreaStart:
    ; these fields additionally need to be reset to zero
    ; at the start of a new line
;    newLineClearAreaStart:
      subtitleCharCompBuffer:
        .ds subtitleCharCompBufferSize,$00
      subtitleCharCompBufferEnd:
      
      subtitleCompBuffer:
        ; only the first composition buffer is cleared in the reset.
        ; the rest are cleared procedurally during the composition process
        .ds bytesPerSpritePatternPlane,$00
      subtitleCompBufferEnd:
    
      ; pre-padding to allow for single transfer of last 3 planes
      ; also used to clear out memory blocks with TAI
      dropShadowBufferAPrePad:
      blockClearWord:
        .dw $0000
      dropShadowBufferA:
        .ds bytesPerSpritePatternPlane,$00
      dropShadowBufferAEnd:
      
      dropShadowBufferB:
        .ds bytesPerSpritePatternPlane,$00
      dropShadowBufferBEnd:
      
      charShiftBufferA:
        .ds bytesPerSpritePatternPlane,$00
      charShiftBufferAEnd:
      charShiftBufferB:
        .ds bytesPerSpritePatternPlane,$00
      charShiftBufferBEnd:
      
      activeSubtitleXPos:
        .db $00
;    newLineClearAreaEnd:
      
    ; size in sprites of the next sprite attribute to be generated
    ; (1 or 2, or 0 before the first sprite is completed)
    nextSpriteAttrWidth:
      .db $00
    
    ; number of sprites from currentLineSpriteAttrStartPtr to attribute
    ; generator queue end
    currentLineSpriteCount:
      .db $00
    
    spriteGrpGenAndTransferNeeded:
      .db $00
    
    spriteAttrGenAndTransferNeeded:
      .db $00
  newLineClearAreaEnd:
  
  newStringClearAreaStart:
    activeSubtitleLineNum:
      .db $00
    currentSubSpriteCount:
      .db $00
    ; hack to get two groups of subtitles
    groupNonemptyLineCountArray:
      group1NonemptyLineCount:
        .db $00
      group2NonemptyLineCount:
        .db $00
/*    groupAttributeStartArray:
      .dw $0000
      .dw $0000
    groupAttributeSizeArray:
      .db $00
      .db $00 */
  newStringClearAreaEnd:
  
  
  ; tile ID of next sprite's base position in VRAM
  ; (add nextSpriteAttrWidth to get target for next graphics write)
  nextSpriteAttrVramBase:
    .dw $00
  
  ; pointer to start of current line's sprite attributes in the
  ; sprite attribute queue.
  ; when the end of the line is reached, we have to apply an
  ; x-offset from here to the end of the queue to center the sprites.
  currentLineSpriteAttrStartPtr:
    .dw $0000
.ends
;.endb
