
;==============================================================================
; required defines
;==============================================================================

/*.ifndef ovlText_addTo29_offset
  .fail
.endif

.ifndef ovlText_multTo29_offset
  .fail
.endif

.ifndef ovlText_printChar_offset
  .fail
.endif */

.ifndef ovlText_fontLoadType
  .fail
.else
  .ifeq ovlText_fontLoadType fontLoadType_normal
    
  .else
    .ifeq ovlText_fontLoadType fontLoadType_preload
      .ifndef ovlText_font
        .fail
      .endif
      
      .ifndef ovlText_fontWidthTable
        .fail
      .endif
    .else
      .fail
    .endif
  .endif
.endif

.ifndef ovlText_printChar_offset
  .fail
.endif

.ifndef ovlText_calcVramTilemapPos_offset
  .fail
.endif

.ifndef ovlText_tilemapLineW_offset
  .fail
.endif

.ifndef ovlText_multTo29_offset
  .fail
.endif

.ifndef ovlText_addTo29_offset
  .fail
.endif

.ifndef ovlText_add2BTo29_offset
  .fail
.endif

.ifndef ovlText_textBaseX_offset
  .fail
.endif

.ifndef ovlText_vramReadBackBufferTop_offset
  .fail
.endif

.ifndef ovlText_vramReadBackBufferBottom_offset
  .fail
.endif

.ifndef ovlText_charOutputPatternBufferBase_offset
  .fail
.endif

.ifndef ovlText_charOutputPatternBufferUL_offset
  .fail
.endif

.ifndef ovlText_charOutputPatternBufferLL_offset
  .fail
.endif

.ifndef ovlText_charOutputPatternBufferUR_offset
  .fail
.endif

.ifndef ovlText_charOutputPatternBufferLR_offset
  .fail
.endif

.ifndef ovlText_unkA7_offset
  .fail
.endif

.ifndef ovlText_unkA9_offset
  .fail
.endif

.ifndef ovlText_unkAA_offset
  .fail
.endif

.ifndef ovlText_unkAD_offset
  .fail
.endif

.ifndef ovlText_unkAE_offset
  .fail
.endif

.ifndef ovlText_unkC0_offset
  .fail
.endif

.ifndef ovlText_unkC1_offset
  .fail
.endif

.ifndef ovlText_defaultBuffer_offset
  .fail
.endif

;==============================================================================
; 
;==============================================================================

/*.include "out/include/cutscenes.inc"

.bank $0 slot 5
.org $0006
.section "use new cutscene data 1" overwrite
  .db intro_dataSectorNumLo
  .db intro_dataSectorNumMid
  .db intro_dataSectorNumHi
  .dw intro_dataSectorSize
.ends */

; include font if not using preload strategy
.ifeq ovlText_fontLoadType fontLoadType_normal
;  .bank 1 slot 1
  .bank 0 slot 0
  .section "text overlay font" free
    .ifdef ovlText_useNarrowFont
      ovlText_font:
        .incbin "out/font/font_narrow.bin"
      ovlText_fontWidthTable:
        .incbin "out/font/fontwidth_narrow.bin"
    .else
      ovlText_font:
        .ifdef ovlText_useLimitedFont
          .incbin "out/font/font_limited.bin"
        .else
          .incbin "out/font/font.bin"
        .endif
      ovlText_fontWidthTable:
        .ifdef ovlText_useLimitedFont
          .incbin "out/font/fontwidth_limited.bin"
        .else
          .incbin "out/font/fontwidth.bin"
        .endif
    .endif
  .ends
.endif

.bank 0 slot 0
.section "text overlay free 1" free
  ;==========================
  ; variables
  ;==========================
  
  ; current printing x-offset in pixels
  ; (we have to track this ourself because the game only
  ; tracks it in terms of number of monospace characters)
  charX:
    .db $FF
  charXHi:
    .db $FF
  ; expected x/y values for the next call to printChar.
  ; if the actual parameters don't match, we assume the
  ; printing position has changed and reset the internal
  ; position data accordingly
  nextOldCharX:
    .db $FF
  nextOldCharY:
    .db $FF
  
;  nextCharX:
;    .db $00
  ; width of the upcoming character
  nextCharW:
    .db $00
  
  ; nonzero if transfer covers two patterns' worth in width, not just one
  nextTransferIsDoubleWidth:
    .db $00
  nextTransferIsPatternChange:
    .db $00
  
  ; new buffers to contain pattern data read back from VRAM.
  ; we have to read back four patterns instead of the original game's two.
  newReadBackBuffer:
    newReadBackBufferUL:
      .ds bytesPerPattern,$00
    newReadBackBufferLL:
      .ds bytesPerPattern,$00
    newReadBackBufferUR:
      .ds bytesPerPattern,$00
    newReadBackBufferLR:
      .ds bytesPerPattern,$00
.ends
.section "text overlay free 2" free
  
  ;==========================
  ; reset print variables
  ; $FC = new oldCharX
  ; $FD = new oldCharY
  ;==========================
  
  doPrintCharReinitCheck:
;    .ifndef ovlText_omitSpecialDstMode
;      stz charReinitOccurred.w
;    .endif
    
    ; x-pos
    lda $FC
    cmp nextOldCharX.w
    bne @doReinit
    ; y-pos
    lda $FD
    cmp nextOldCharY.w
    beq @reinitChecksDone
    @doReinit:
      bra resetPrintPos
    @reinitChecksDone:
    rts
  resetPrintPos:
    ; reset old x/y
    lda $FC
    sta nextOldCharX.w
    
    ; reset pixel x-pos to new (oldCharX * 8) * 1.5
    ; i.e. multiply by 12
    
/*    ; multiply by 4
    asl
    asl
    sta charX.w
    ; now 8
    asl
    ; add *8 to *4 to get *12
    clc
    adc charX.w
    sta charX.w */
    
    ; multiply by 12
    ldx #12
    jsr ovlText_multTo29_offset
    ; store result
    lda $29
    sta charX.w
    lda $2A
    sta charXHi.w
    
    lda $FD
    sta nextOldCharY.w
    
    .ifndef ovlText_omitSpecialDstMode
;      inc charReinitOccurred.w
      ; responsibility for resetting charReinitOccurred has been moved
      ; to the code that checks it, so we can no longer assume
      ; incrementing is safe (though in practice, issues are unlikely)
      lda #$01
      sta charReinitOccurred.w
    .endif
    
    rts
.ends
.section "text overlay free 3" free
  
  ;==========================
  ; $FA = dst buffer
  ; $29 = src pointer
  ;==========================
  
  incFA:
    inc $FA
    bne +
      inc $FB
    +:
    rts
  
  copyRawFontCharTo1bppBuffer:
    ; clear first line
    cla
    sta ($FA)
    bsr incFA
    sta ($FA)
    bsr incFA
    
    cly
    -:
      ; fetch byte
      lda ($29),Y
      ; write to dst
      sta ($FA)
      
      ; increment dst
      bsr incFA
      
      ; right half of 16px area is empty, so blank it in the buffer
      cla
      sta ($FA)
      
      ; increment dst
      bsr incFA
      
      ; loop
      iny
      cpy #bytesPerRawFontChar
      bne -
    
    ; remaining lines in buffer are blank
    cly
    cla
    -:
      ; blank 2 bytes = 1 line
      sta ($FA),Y
      iny
      sta ($FA),Y
      iny
      
      ; loop
      cpy #(fullFontCharH-rawFontCharH-1)*2
      bne -
    
    rts
/*    lda (fullFontCharH-rawFontCharH-1)*2
  ; !!! drop through !!!
  ; A = count*2
  blankOut1bppBufferLines:
    sta @copyCounter+1.w
    
    cly
    cla
    -:
      ; blank 2 bytes = 1 line
      sta ($FA),Y
      iny
      sta ($FA),Y
      iny
      
      ; loop
      @copyCounter:
      cpy #(fullFontCharH-rawFontCharH)*2
      bne -
    rts */
.ends
.section "text overlay free 4" free
  
  ;==========================
  ; bitshifts the 1bpp char buffer
  ; for the current pattern,
  ; and applies appropriate masking
  ; to the readback buffers
  ;
  ; $25 = 1bpp buffer pointer
  ;==========================
  
  readBackBufferMask:
    .db $00
    .db $00
  
  shiftAndMaskInputCharBuffers:
    ; reset mask
    lda #$FF
    sta readBackBufferMask.w
    stz readBackBufferMask+1.w
    
    ;=====
    ; do bit shifts if needed
    ;=====
    
    ; compute offset within target pattern
    lda charX.w
    and #$07
    beq +
      ; save bit count for later
      sta $2B
      
      tax
      @bitLoop:
        ; shift the mask
        lsr readBackBufferMask.w
        ror readBackBufferMask+1.w
        dex
        bne @bitLoop
        
      ; shift the 1bpp buffer
      cly
      -:
        lda ($25),Y
        sta $2A
        iny
        lda ($25),Y
        
        ldx $2B
        @bitLoop2:
          lsr $2A
          ror
          dex
          bne @bitLoop2
        sta ($25),Y
        dey
          lda $2A
          sta ($25),Y
        iny
        
        ; loop
        iny
        cpy #fullFontCharH*2
        bne -
    +:
    
    ;=====
    ; mask the readback buffer
    ;=====
    
    lda #<newReadBackBufferUL
    sta $29
    lda #>newReadBackBufferUL
    sta $2A
    
    lda readBackBufferMask.w
    eor #$FF
    jsr maskCharBufferSet_firstHalf
    
    lda readBackBufferMask+1.w
    eor #$FF
    jmp maskCharBufferSet_secondHalf
.ends
.section "text overlay free 5" free
  
  ;==========================
  ; applies masking (computed from
  ; a previous call to shiftAndMaskInputCharBuffers)
  ; to the output char buffers,
  ; then merges them with the readback buffers
  ;==========================
  
;  maskAndMergeOutputCharBuffers:
;    
;    rts
    
  ; A = mask
  maskCharBufferSet_firstHalf:
    cly
    -:
      pha
        and ($29),Y
        sta ($29),Y
      pla
      
      iny
      cpy #bytesPerPattern*2
      bne -
    rts
    
  ; A = mask
  maskCharBufferSet_secondHalf:
    -:
      pha
        and ($29),Y
        sta ($29),Y
      pla
      
      iny
      cpy #bytesPerPattern*4
      bne -
      
    rts
.ends
.ifndef ovlText_omitSpecialDstMode
  .section "text overlay free 6" free
    charReinitOccurred:
      .db $00
    
    doSpecialDstModeTransfer:
      ; go to next pattern if reinit occurred (i.e. linebreak)
      ldx charReinitOccurred.w
      beq +
        jsr incrementPredefinedTransferPatternDst
        stz charReinitOccurred.w
      +:
      
      lda ovlText_unkC0_offset
      ldx ovlText_unkC1_offset
      sta $002B
      stx $002C
      sta $0025
      stx $0026
      
      ; set vram write mode
      jsr $E0AE
      
      ; halve transfer size if sending only one pattern in width
      lda #$80
      ldx nextTransferIsDoubleWidth.w
      bne +
        lsr
      +:
      sta @tileTransferCmd2+5.w
      
      @tileTransferCmd2:
      tia ovlText_charOutputPatternBufferBase_offset,$0002,$0080
      ; dstaddr += 0x40
    /*      lda #$40
      sta $0029
      lda #$00
      sta $002A
      jsr ovlText_add2BTo29_offset
      lda $0029
      sta ovlText_unkC0_offset
      lda $002A
      sta ovlText_unkC1_offset */
      
      ; dstaddr += 0x20 IF we are moving to a new pattern;
      ; otherwise, leave at original value so we write back
      ; to this same target next time (instead of generating
      ; a new tile based on the old contents, wasting space)
      @tileUpdateLoop:
        ldx nextTransferIsPatternChange.w
        beq +
          jsr incrementPredefinedTransferPatternDst
          ; increment by whatever number of patterns is needed
          ; (since e.g. the ellipsis character is 9 pixels,
          ; it may be necessary to advance by more than one pattern)
          dec nextTransferIsPatternChange.w
          bra @tileUpdateLoop
        +:
      
      rts
  .ends
.endif

.bank 0 slot 0
.orga ovlText_printChar_offset
.section "text overlay 1" SIZE $3BB overwrite
;.section "text overlay 1" SIZE $3B6 overwrite
  ; printChar
  ;
  ; $F8-F9 = character codepoint (little-endian)
  ; $FA-FB = dst buffer for bitmapped char data.
  ;          if zero, a default value is used.
  ; $FC = x-pos (in characters)
  ; $FD = y-pos (in tiles, screen-absolute)
  ; $FE = color
  ; $FF = if 0, use $C0 as base VRAM address for dst?
  ;       if 1, ???
  ;       else, do not transfer anything to VRAM
  ;             (updating param buffer only?)
  
  printChar:
    ;=====
    ; reinitialize if printing position has changed
    ;=====
    
    jsr doPrintCharReinitCheck
    
    ; increment nextX to expected value for next call of this routine
    inc nextOldCharX.w
    
    ;=====
    ; set up
    ;=====
    
    ; $17 = param $FF: output type value
    lda $00FF
    sta $0017
    
    lda $00FA
    ora $00FB
    bne +
    ; if $FA-FB zero
      ; use default buffer
      lda #<ovlText_defaultBuffer_offset
      sta $00FA
      lda #>ovlText_defaultBuffer_offset
      sta $00FB
    +:
    
    ;=====
    ; compute the VRAM address of the target position
    ; for this character in the tilemap
    ;=====
    
    ; $18 = flag: nonzero if this is an odd-numbered character
/*    stz $0018
    lda $00FC
    lsr 
    bcc +
      inc $0018
    +:
    clc 
    adc $00FC
    ; $19 = (charX * 1.5)
    sta $0019
    adc ovlText_textBaseX_offset
    ldx $00FD
    stx $001A */
    
/*    ; get current pixelX
    lda charX.w
    ; divide by 8
    lsr
    lsr
    lsr */
    
    ; divide pixelX by 8
    
    ; the destination x-tile needs to be wrapped according to the nametable width
    ; afaik, this is normally 0x20, and sometimes 0x40 in battles --
    ; see rock princess's chain attack for an example of the latter
    ; (game draws text to the off-screen area, then changes the scroll position
    ; so the message appears "instantly")
    lda ovlText_tilemapLineW_offset.w
    dea
    sta @tileAndCmd+1.w
    
    ; we use ONLY the lowest bit of charXHi
    ; (the game does not target pixel positions higher than 0x200)
    lda charXHi.w
    lsr
    lda charX.w
    ror
    lsr
    lsr
    
    ; add base x-tile offset
    clc
    adc ovlText_textBaseX_offset
    ; target tile is "allowed" to exceed the width of the screen (0x20)
    ; during e.g. battle scenes, sort of.
    ; other logic takes care of getting everything in the right place;
    ; we just need to make sure the actual target value wraps around
    ; at 0x20.
;    cmp #$20
;    bcc +
;      and #$1F
      @tileAndCmd:
;      and #$3F
      and #$00
;    +:
    ; save x-tile to $19
    sta $19
    
    ; get target y-tile
    ldx $FD
    ; save y-tile to $1A
    stx $1A
    
    ; $29 = VRAM address of upper-left pattern of target tile
    jsr ovlText_calcVramTilemapPos_offset
    ; save to $27 for future use
    lda $0029
    sta $0027
    lda $002A
    sta $0028
    
    ;=====
    ; look up target character
    ;=====
    
    ; $25 = dst buffer address
    lda $00FA
    sta $0025
    lda $00FB
    sta $0026
    
    ; set dst for custom character transfer
;    sta @heartTransferCmd+3.w
;    sta @heartTransferCmd+4.w
    ; if character is 819A = star, use custom heart glyph
/*    lda $00F8
    cmp #$9A
    bne @getBiosChar
      lda $00F9
      cmp #$81
      bne @getBiosChar
        @heartTransferCmd:
        ; self-modified to target buffer
        tii heartChar1bpp,$0000,$0020
        bra @rawCharRead
    ; else
    @getBiosChar: */
      ; get character from BIOS
;      lda #$01
;      sta $00FF
;      jsr $E060
    
    ; get target character codepoint
    lda $F9
    ; DEBUG: use hardcoded codepoint
;    lda #fontBaseOffset+$0C
    
    ; subtract base codepoint to get raw font index
    sec
    sbc #fontBaseOffset
    
    ; look up character width
    pha
      tax
      lda ovlText_fontWidthTable.w,X
      ; if character width is zero, do nothing
      bne +
        pla
        rts
      +:
      sta nextCharW.w
      
      ; determine if doing double transfer
      ; (character spans two patterns in width)
      
      ; default to non-double transfer
      stz nextTransferIsDoubleWidth.w
      
/*      ; add current x to new char's width
      clc
      adc charX.w
;      sta nextCharX.w
      ; subtract 1
      dea
      ; divide by 8 to get tile target for end of transfer
      lsr
      lsr
      lsr */
      
      ; determine if this transfer will move us up to or into a new pattern
      ; (calculations involving charXHi skipped due to limited use)
      .ifndef ovlText_omitSpecialDstMode
        stz nextTransferIsPatternChange.w
          pha
            clc
            adc charX.w
            ; divide by 8 to get tile target for end of transfer
            lsr
            lsr
            lsr
            
            clc
            adc ovlText_textBaseX_offset
/*            cmp $19
            beq @notPatternChange
              inc nextTransferIsPatternChange.w
            @notPatternChange:*/
            sec
            sbc $19.b
            sta nextTransferIsPatternChange.w
          pla
      .endif
      
      ; subtract 1
      dea
      ; add current x to new char's width
      clc
      adc charX.w
      pha
        ; ONLY lowest bit of charXHi is used
        ; and there should never be a carry-out from the previous addition,
        ; so this is safe as-is
        lda charXHi.w
        lsr
      pla
      ; divide by 8 to get tile target for end of transfer
      ror
      lsr
      lsr
      
      ; add base tile offset
      clc
      adc ovlText_textBaseX_offset
      ; if the same as target starting tile, only one transfer is needed
      cmp $19
      beq @notDouble
        inc nextTransferIsDoubleWidth.w
      @notDouble:
    pla
    
    ; bytes per 1bpp character in font
    ldx #bytesPerRawFontChar
  
    ; multiply
    jsr ovlText_multTo29_offset
    
    ; add font base offset to result
    lda #<ovlText_font
    sta $2B
    lda #>ovlText_font
    sta $2C
    jsr ovlText_add2BTo29_offset
    
    ; result == pointer to target character's raw font data
    ; copy to dst buffer
    jsr copyRawFontCharTo1bppBuffer
    
    ; $2B = target color
;    lda $00FE
;    sta $002B
    lda $00FE
    pha
    
      ;=====
      ; read back top row base tile ID from tilemap in VRAM
      ;=====
      
      ; XA = tilemap address
      lda $0027
      sta $29
      ldx $0028
      stx $2A
      ; set vram read mode
      jsr $E0AB
      lda $0002.w
      sta $00F8
      lda $0003.w
      
      sta $F9
      
      lda $0002.w
      pha
      lda $0003.w
      pha
        lda $F9
      
        ;=====
        ; read back top row pattern data from VRAM
        ;=====
        
        ; multiply by 16 to get VRAM address of target tile
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        tax 
        lda $00F8
        ; set vram read mode
        jsr $E0AB
        ; read back 1 pattern of data from VRAM
        tai $0002,newReadBackBufferUL,$0020
      
      ;=====
      ; read back top-right row pattern data from VRAM
      ;=====
      
      pla
      sta $F9
      pla
      sta $F8
      
      ; don't read second tile if transfer does not span two patterns
      lda nextTransferIsDoubleWidth.w
      beq +
        lda $F9
        ; multiply by 16 to get VRAM address of target tile
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        tax 
        lda $00F8
        ; set vram read mode
        jsr $E0AB
        ; read back 1 pattern of data from VRAM
        tai $0002,newReadBackBufferUR,$0020
      +:
      
      ;=====
      ; add size of one line in tilemap to target address
      ;=====
      
      ldx #$29
      clc 
      set 
      adc ovlText_tilemapLineW_offset.w
      inx 
      set 
      adc #$00
      
      ;=====
      ; repeat readback procedure for bottom row
      ;=====
      
      lda $0029
      ldx $002A
      ; set vram read mode
      jsr $E0AB
      lda $0002.w
      sta $00F8
      lda $0003.w
      sta $F9
      
      lda $0002.w
      pha
      lda $0003.w
      pha
        lda $F9
        
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        tax 
        lda $00F8
        ; set vram read mode
        jsr $E0AB
        ; read back 1 pattern of data from VRAM
        tai $0002,newReadBackBufferLL,$0020
      
      ;=====
      ; and bottom-right pattern
      ;=====
      
      pla
      sta $F9
      pla
      sta $F8
      
      ; don't read second tile if transfer does not span two patterns
      lda nextTransferIsDoubleWidth.w
      beq +
        lda $F9
        
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        asl $00F8
        rol 
        tax 
        lda $00F8
        ; set vram read mode
        jsr $E0AB
        ; read back 1 pattern of data from VRAM
        tai $0002,newReadBackBufferLR,$0020
      +:
    
      ;=====
      ; process the 1bpp character data
      ;=====
      
      jsr shiftAndMaskInputCharBuffers
    
    ; restore target color
    pla
    sta $2B
    
    ;=====
    ; convert 1bpp source patterns to 4bpp output format
    ;=====
    
    ; $F8 = 1bpp buffer's address
    lda $0025
    sta $00F8
    lda $0026
    sta $00F9
    lda #<ovlText_charOutputPatternBufferUL_offset
    sta $00FA
    lda #>ovlText_charOutputPatternBufferUL_offset
    sta $00FB
    ; color
    lda $002B
    sta $00FC
    jsr convert1bppQuarterTo4bpp
    ; target bottom-left part of src data
    lda $0025
    clc 
    adc #$10
    sta $00F8
    lda $0026
    adc #$00
    sta $00F9
    lda #<ovlText_charOutputPatternBufferLL_offset
    sta $00FA
    lda #>ovlText_charOutputPatternBufferLL_offset
    sta $00FB
    jsr convert1bppQuarterTo4bpp
/*    lda $0018
    beq +
    ; if an odd-numbered character
      ; combine left half of readback buffer with right half of char data
      lda #<ovlText_charOutputPatternBufferUL_offset
      sta $00F8
      lda #>ovlText_charOutputPatternBufferUL_offset
      sta $00F9
      lda #<ovlText_vramReadBackBufferTop_offset
      sta $00FA
      lda #>ovlText_vramReadBackBufferTop_offset
      sta $00FB
      jsr mergeLeftToRight
      lda #<ovlText_charOutputPatternBufferLL_offset
      sta $00F8
      lda #>ovlText_charOutputPatternBufferLL_offset
      sta $00F9
      lda #<ovlText_vramReadBackBufferBottom_offset
      sta $00FA
      lda #>ovlText_vramReadBackBufferBottom_offset
      sta $00FB
      jsr mergeLeftToRight
    +: */
    ; $F8 = pointer to right half of data for 1bpp buffer (i.e. buffer + 1)
    lda $0025
    sta $00F8
    lda $0026
    sta $00F9
    inc $00F8
    bne +
      inc $00F9
    +:
    lda #<ovlText_charOutputPatternBufferUR_offset
    sta $00FA
    lda #>ovlText_charOutputPatternBufferUR_offset
    sta $00FB
    jsr convert1bppQuarterTo4bpp
/*    lda $0018
    bne +
    ; if an even-numbered character
      ; combine right half of readback buffer with left half of char data
      lda #<ovlText_charOutputPatternBufferUR_offset
      sta $00F8
      lda #>ovlText_charOutputPatternBufferUR_offset
      sta $00F9
      lda #<ovlText_vramReadBackBufferTop_offset
      sta $00FA
      lda #>ovlText_vramReadBackBufferTop_offset
      sta $00FB
      jsr mergeRightToLeft
    +: */
    ; target bottom-right part of 1bpp data
    lda $0025
    clc 
    adc #$11
    sta $00F8
    lda $0026
    adc #$00
    sta $00F9
    lda #<ovlText_charOutputPatternBufferLR_offset
    sta $00FA
    lda #>ovlText_charOutputPatternBufferLR_offset
    sta $00FB
    jsr convert1bppQuarterTo4bpp
/*    lda $0018
    bne +
    ; if an even-numbered character
      lda #<ovlText_charOutputPatternBufferLR_offset
      sta $00F8
      lda #>ovlText_charOutputPatternBufferLR_offset
      sta $00F9
      lda #<ovlText_vramReadBackBufferBottom_offset
      sta $00FA
      lda #>ovlText_vramReadBackBufferBottom_offset
      sta $00FB
      jsr mergeRightToLeft
    +: */
  
    ;=====
    ; process the 4bpp character data
    ;=====
    
;    jsr maskAndMergeOutputCharBuffers
    ; apply masking
    lda #<ovlText_charOutputPatternBufferBase_offset
    sta $29
    lda #>ovlText_charOutputPatternBufferBase_offset
    sta $2A
    lda readBackBufferMask.w
    jsr maskCharBufferSet_firstHalf
    lda readBackBufferMask+1.w
    jsr maskCharBufferSet_secondHalf
    
    ; merge with readback buffers
    clx
    -:
      lda newReadBackBuffer.w,X
      ora ovlText_charOutputPatternBufferBase_offset.w,X
      sta ovlText_charOutputPatternBufferBase_offset.w,X
      
      inx
      cpx #bytesPerPattern*4
      bne -
    
    ;=====
    ; send tile data and update tilemap
    ;=====
    
    lda $0017
    beq ++
    ; if param $FF nonzero
      dea 
      beq +
      ; if param $FF is greater than 1
        jmp @done
      +:
      
      ; if 1
      ; TODO: does this need to be changed?
      
      lda $001A
      sec 
      sbc ovlText_unkA7_offset
      sta $00F8
      stz $00F9
      lda ovlText_unkA9_offset
      sta $00FA
      lda ovlText_unkAA_offset
      sta $00FB
      ; MA_MUL16U
      jsr $E0C3
      ; $29 = (charX * 1.5) * 0x20
      lda $0019
      ldx #$20
      jsr ovlText_multTo29_offset
      ; FIXME: didn't we overwrite this with the color earlier?
      ; no longer x?
      lda $00FC
      sta $002B
      lda $00FD
      sta $002C
      jsr ovlText_add2BTo29_offset
      lda ovlText_unkAD_offset
      sta $002B
      lda ovlText_unkAE_offset
      sta $002C
      jsr ovlText_add2BTo29_offset
      lda $0029
      ldx $002A
      sta $0025
      stx $0026
      ; set vram write mode
      jsr $E0AE
      
      ; halve transfer size if sending only one pattern in width
      lda #$80
      ldx nextTransferIsDoubleWidth.w
      bne +
        lsr
      +:
      sta @tileTransferCmd1+5.w
      
      @tileTransferCmd1:
      tia ovlText_charOutputPatternBufferBase_offset,$0002,$0080
      bra +++
    ++:
    ; else
      .ifndef ovlText_omitSpecialDstMode
        jsr doSpecialDstModeTransfer
      .else
        ; use original, vram-wasting version of this routine
        ; (i had to add this complicated conditional assembly due to
        ; extremely tight space in battle0.
        ; and the space optimization is necessary for scene1C = credits.
        ; ugh.)
        
        ; use predefined address as dst
        lda ovlText_unkC0_offset
        ldx ovlText_unkC1_offset
        sta $002B
        stx $002C
        sta $0025
        stx $0026
        ; set vram write mode
        jsr $E0AE
        
        ; halve transfer size if sending only one pattern in width
        lda #$80
        ldx nextTransferIsDoubleWidth.w
        bne +
          lsr
        +:
        sta @tileTransferCmd2+5.w
        
        @tileTransferCmd2:
        tia ovlText_charOutputPatternBufferBase_offset,$0002,$0080
        ; dstaddr += 0x40
        ; 0x20 should work fine, but breaks due to poor interaction
        ; with the null character prints that we added for displaying
        ; HP values.
        ; 0x40 wastes VRAM but works fine, so we'll just stick with that.
        lda #$40
        sta $0029
        lda #$00
        sta $002A
        jsr ovlText_add2BTo29_offset
        lda $0029
        sta ovlText_unkC0_offset
        lda $002A
        sta ovlText_unkC1_offset
      .endif
    +++:
    ; get the VRAM address the tile data was written to
    lda $0026
    ; convert to tile ID:
    ; right shift 4
    lsr 
    ror $0025
    lsr 
    ror $0025
    lsr 
    ror $0025
    lsr 
    ror $0025
    ; palette = 0xF
    .ifdef text_overrideStdPalette
      ora #(text_overridePaletteNum<<4)
    .else
      ora #$F0
    .endif
    ; save back to $25-$26
    sta $0026
    ; also copy to $17-$18
    sta $0018
    lda $0025
    sta $0017
    ; copy saved target tilemap address from $27 to $29
    lda $0027
    sta $0029
    lda $0028
    sta $002A
    jsr updateNewCharTilemap
    ; repeat for bottom row
    lda ovlText_tilemapLineW_offset.w
    jsr ovlText_addTo29_offset
    lda $0017
    sta $0025
    lda $0018
    sta $0026
    inc $0025
    bne +
      inc $0026
    +:
    jsr updateNewCharTilemap
    
    @done:
    
    ;=====
    ; update charX
    ;=====
    
    lda nextCharW.w
    clc
    adc charX.w
    sta charX.w
    ; apparently the expected behavior??
;    cmp #$F8
;    bcc +
;      sec
;      sbc #$F8
;    +:
    ; i don't think the game actually prints "across" the 256-pixel boundary
    ; (in battles, it sometimes prints to the off-screen part of the nametable),
    ; so this may be unneeded
    bcc +
      inc charXHi.w
    +:
    
    rts 

  .ifndef ovlText_omitSpecialDstMode
    incrementPredefinedTransferPatternDst:
      ; use predefined address as dst
      lda ovlText_unkC0_offset
      ldx ovlText_unkC1_offset
      sta $002B
      stx $002C
      
      lda #$20
      sta $0029
      lda #$00
      sta $002A
      jsr ovlText_add2BTo29_offset
      lda $0029
      sta ovlText_unkC0_offset
      lda $002A
      sta ovlText_unkC1_offset
      rts
  .endif
    
  ; tilemap update
  ;
  ; $25-$26 = base tile ID
  ; $29-$2A = address of base target tile in tilemap

  updateNewCharTilemap:
    lda ovlText_tilemapLineW_offset.w
    cmp #$20
    bne ++
    ; if line width == 0x20
      lda $0029
      and #$1F
      cmp #$1F
      beq @alt
      @something:
      ; if low byte of address & 0x1F != 0x1F
      ; (i.e. the first and second transfers do NOT straddle a tilemap line boundary)
        ; set up VRAM write
        lda $0029
        ldx $002A
        jsr $E0AE
        ; write
        lda $0025
        sta $0002.w
        lda $0026
        sta $0003.w
      
        ; done if not doing double transfer
        lda nextTransferIsDoubleWidth.w
        bne +
          rts
        +:
        
        ; tileID += 2
        inc $0025
        bne +
          inc $0026
        +:
        inc $0025
        bne +
          inc $0026
        +:
        
        ; write
        lda $0025
        sta $0002.w
        lda $0026
        sta $0003.w
        
        rts
      @alt:
        ; set up VRAM write
        lda $0029
        ldx $002A
        jsr $E0AE
        
        ; write
        lda $0025
        sta $0002.w
        lda $0026
        sta $0003.w
      
        ; done if not doing double transfer
        lda nextTransferIsDoubleWidth.w
        bne +
          rts
        +:
        
        ; tileID += 2
        inc $0025
        bne +
          inc $0026
        +:
        inc $0025
        bne +
          inc $0026
        +:
        
        ; reset VRAM dst, ANDing low byte with 0xE0
        lda $0029
        and #$E0
        ldx $002A
        jsr $E0AE
        
        lda $0025
        sta $0002.w
        lda $0026
        sta $0003.w
        rts 
    ++:
    ; if line width != 0x20
    ; if low byte of target address & 0x3F != 0x3F, do normal logic
    lda $0029
    and #$3F
    cmp #$3F
    bne @something
    ; if line width != 0x20, and low 6 bits of target address are set
    ; set up VRAM write
      lda $0029
      ldx $002A
      jsr $E0AE
      
      ; write
      lda $0025
      sta $0002.w
      lda $0026
      sta $0003.w
    
      ; done if not doing double transfer
      lda nextTransferIsDoubleWidth.w
      bne +
        rts
      +:
      
      ; tileID += 2
      inc $0025
      bne +
        inc $0026
      +:
      inc $0025
      bne +
        inc $0026
      +:
      
      ; reset VRAM dst, ANDing low byte with 0xC0
      lda $0029
      and #$C0
      ldx $002A
      jsr $E0AE
      
      ; write
      lda $0025
      sta $0002.w
      lda $0026
      sta $0003.w
      rts 

  ; converts one quarter of a 16x16 1bpp character to a 4bpp pattern
  ;
  ; $F8 = src
  ;       should be in the same format provided by the BIOS:
  ;       1bpp, representing a 16x16 pixel area.
  ;       each pair of bytes represents one line (left + right)
  ; $FA = dst
  ; $FC = target palette index for output?

  ; set dst for clear loop
  convert1bppQuarterTo4bpp:
    lda $00FA
    sta @bufClearCmd+1.w
    lda $00FB
    sta @bufClearCmd+2.w
    clx 
    ; clear dst buffer
    -:
    ; loop
      @bufClearCmd:
      stz $0000.w,X
      inx 
      cpx #$20
      bne -
    cly 
    ldx #$10
    lda #$08
    sta $00FD
    ; loop
    -:
      ; fetch byte from $F8
      lda ($00F8)
      ; $F8 += 2
      inc $00F8
      bne +
        inc $00F9
      +:
      inc $00F8
      bne +
        inc $00F9
      +:
      ; target low bitplanes (+0x0)
      pha 
        tst #$01,$FC
        beq +
        ; if
          lda #$FF
          bra ++
        +:
        ; else
          eor #$FF
        ++:
        sta ($00FA),Y
      pla 
      iny 
      tst #$02,$FC
      beq +
        sta ($00FA),Y
      +:
      iny 
      ; target high bitplanes (+0x10)
      sxy 
        tst #$04,$FC
        beq +
          sta ($00FA),Y
        +:
        iny 
        tst #$08,$FC
        beq +
          sta ($00FA),Y
        +:
        iny 
      sxy 
      dec $00FD
      bne -
    rts

  ; pattern merge:
  ; merge right half of $FA with left half of $F8
  ;
  ; $F8 = dst
  ; $FA = src
  
/*  mergeRightToLeft:
    cly 
    ; loop
    -:
      ; fetch from src
      lda ($00FA),Y
      ; remove left half
      and #$0F
      sta $0029
      ; fetch from dst
      lda ($00F8),Y
      ; remove right half
      and #$F0
      ; combine with other pattern
      ora $0029
      ; write to dst
      sta ($00F8),Y
      iny 
      cpy #$20
      bne -
    rts 

  ; pattern merge:
  ; merge left half of $FA with right half of $F8
  ;
  ; $F8 = dst
  ; $FA = src
  
  mergeLeftToRight:
    cly 
    ; loop
    -:
      ; fetch from src
      lda ($00FA),Y
      ; remove right half
      and #$F0
      sta $0029
      ; fetch from dst
      lda ($00F8),Y
      ; remove left half
      and #$0F
      ; combine with other pattern
      ora $0029
      ; write to dst
      sta ($00F8),Y
      iny 
      cpy #$20
      bne -
    rts 

  ; right-shift a 16x16 1bpp character buffer by 4 pixels.
  ; the rightmost four pixels are lost (assumed empty)
  ;
  ; $25 = src/dst

  rightShift1bppBuffer4Px:
    ; self-modify aaaall the dstaddresses used below
    lda $0025
    sta @cmd0+1.w
    sta @cmd1+1.w
    sta @cmd2+1.w
    sta @cmd3+1.w
    lda $0026
    sta @cmd0+2.w
    sta @cmd1+2.w
    sta @cmd2+2.w
    sta @cmd3+2.w
    clx 
    cly 
    ; loop
    -:
      @cmd0:
      lda $0000.w,X
      sta $002C
      inx 
      @cmd1:
      lda $0000.w,X
      inx 
      ; right-shift 4 bits
      lsr $002C
      ror 
      lsr $002C
      ror 
      lsr $002C
      ror 
      lsr $002C
      ror 
      ; save left byte
      pha 
        lda $002C
        @cmd2:
        sta $0000.w,Y
        iny 
      pla 
      ; save right byte
      @cmd3:
      sta $0000.w,Y
      iny 
      cpx #$20
      bne -
    rts */

  ; SJIS has no heart character, so they made their own and here it is.
  ; touching.

/*  heartChar1bpp:
    .db $00,$00
    .db $71,$C0
    .db $FB,$E0
    .db $FF,$E0
    .db $FF,$E0
    .db $7F,$C0
    .db $7F,$C0
    .db $3F,$80
    .db $1F,$00
    .db $0E,$00
    .db $04,$00
    .db $00,$00
    .db $00,$00
    .db $00,$00
    .db $00,$00
    .db $00,$00 */
.ends

;==============================================================================
; fix title cutscene viewer bug
;==============================================================================

/*.unbackground $17F0 $17FF

.bank $0 slot 5
.org $01C0
.section "cutscene viewer fix 1" overwrite
  jsr cutsceneViewerFix
.ends

.bank $0 slot 5
.section "cutscene viewer fix 2" free
  cutsceneViewerFix:
    ; load correct slot2 bank for execution
    lda $2701
    tam #$04
    
    ; make up work
    lda $A023
    rts
.ends */
