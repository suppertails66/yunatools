
;==============================================================================
; required defines
;==============================================================================

.ifndef ovlBatStr_fullStringPrint_offset
  .fail
.endif

.ifndef ovlBatStr_simpleStringPrint_offset
  .fail
.endif

;.ifndef ovlBatStr_scriptPtr_offset
;  .fail
;.endif

.ifndef ovlBatStr_waitVblank_offset
  .fail
.endif

.ifndef ovlBatStr_dteTable_offset
  .fail
.endif

.ifndef ovlBatStr_numToSjis3Digit_offset
  .fail
.endif

.ifndef ovlBatStr_numConvBuffer_offset
  .fail
.endif

.ifndef ovlBatStr_drawHud1_offset
  .fail
.endif

;==============================================================================
; 
;==============================================================================

.define ovlBatStr_scriptPtr_offset $BE

;.bank 0 slot 0
;.section "battle string overlay free" free
;  
;.ends

;=============================
; simple string print:
; 8-bit codepoints
;=============================

.bank 0 slot 0
.orga ovlBatStr_simpleStringPrint_offset+$13
.section "batstr overlay: simple string 8-bit codepoints 1" overwrite
;  inc $00BE
;  bne +
;    inc $00BF
;  +:
  jmp ovlBatStr_simpleStringPrint_offset+$19
.ends

;=============================
; full string print:
; 8-bit codepoints
;=============================

.bank 0 slot 0
.orga ovlBatStr_fullStringPrint_offset+$16
.section "batstr overlay: full string 8-bit codepoints 1" overwrite
;  inc $00BE
;  bne +
;    inc $00BF
;  +:
  jmp ovlBatStr_fullStringPrint_offset+$1C
.ends

;=============================
; simple string print:
; do pointer redirect whenever starting a string
;=============================

.bank 0 slot 0
.orga ovlBatStr_simpleStringPrint_offset+$0
.section "batstr overlay: simple string redirect 1" overwrite
  jsr ovlBatStr_simpleStringRedirect
.ends

;=============================
; full string print:
; do pointer redirect whenever starting a string
;=============================

.bank 0 slot 0
.orga ovlBatStr_fullStringPrint_offset+$0
.section "batstr overlay: full string redirect 1" overwrite
  jsr ovlBatStr_fullStringRedirect
  nop
.ends

.bank 0 slot 0
.section "batstr overlay: full string redirect 2" free
  ovlBatStr_simpleStringRedirect:
    bsr ovlBatStr_doStringPointerRedirect
    ; make up work
    @done:
  ovlBatStr_printSimpleStringNoRedirect:
    jmp ovlBatStr_waitVblank_offset
    
  ovlBatStr_fullStringRedirect:
    bsr ovlBatStr_doStringPointerRedirect
    ; make up work
    @done:
  ovlBatStr_printFullStringNoRedirect:
    lda $1B
    sta $1F
    rts
  
  ovlBatStr_doStringPointerRedirect:
    ; fetch byte
    lda (ovlBatStr_scriptPtr_offset)
    cmp #code_jump
    bne @done
      phy
        ; fetch byte
        ldy #$01
        lda (ovlBatStr_scriptPtr_offset),Y
        pha
          ; fetch byte
          iny
          lda (ovlBatStr_scriptPtr_offset),Y
          ; write to scriptptr
          sta ovlBatStr_scriptPtr_offset+1
        pla
        
        sta ovlBatStr_scriptPtr_offset
      ply
    
    @done:
    rts
.ends

;=============================
; full string print:
; replace auto linebreak with manual linebreak check
;=============================

.bank 0 slot 0
.orga ovlBatStr_fullStringPrint_offset+$3C
.section "batstr overlay: auto linebreak to manual 1" overwrite
  jmp ovlBatStr_doManualLinebreakCheck
.ends

.bank 0 slot 0
.section "batstr overlay: auto linebreak to manual 2" free
  ovlBatStr_doManualLinebreakCheck:
    ; get previously fetched byte
    lda $F9
    
    ; if the linebreak character, do that logic
    cmp #code_linebreak
    beq +
      ; branch to normal print
      lda $1E
      ina
      jmp ovlBatStr_fullStringPrint_offset+$4C
    +:
    
    ; reset X?
    lda $1F
    sta $1B
    ; y += 2
    inc $1C
    inc $1C
    ; ???
    cla
    sta $1E
    
    ; branch to next-char handler loop
    jmp ovlBatStr_fullStringPrint_offset+$6
.ends

;=============================
; full string print:
; disable ???
;=============================

.bank 0 slot 0
.orga ovlBatStr_fullStringPrint_offset+$31
.section "batstr overlay: no auto-something 1" overwrite
  jmp ovlBatStr_fullStringPrint_offset+$3A
.ends

;=============================
; do DTE checks
;=============================

.bank 0 slot 0
.orga ovlBatStr_fullStringPrint_offset+$C
.section "batstr overlay: full string DTE 1" overwrite
  jsr ovlBatStr_doDteCheck
  ; skip second char read
  jmp ovlBatStr_fullStringPrint_offset+$1C
.ends

.bank 0 slot 0
.orga ovlBatStr_simpleStringPrint_offset+$9
.section "batstr overlay: simple string DTE 1" overwrite
  jsr ovlBatStr_doDteCheck
  ; skip second char read
  jmp ovlBatStr_simpleStringPrint_offset+$19
.ends

.bank 0 slot 0
.section "batstr overlay: string DTE 1" free
  ovlBatStr_dteOn:
    .db $00
  
  ovlBatStr_doDteCheck:
    cmp #code_dteBase
    bcc @notDte
      sec
      sbc #code_dteBase
      asl
      tax
      
      ; if DTE already on, load second char and turn off
      lda ovlBatStr_dteOn.w
      bne @secondChar
      @firstChar:
        ; mark DTE as on
        inc ovlBatStr_dteOn.w
        ; get target char
        lda ovlBatStr_dteTable_offset.w,X
        sta $F9
        ; skip incrementing srcptr
        bra @done
      @secondChar:
        ; mark DTE as off
        stz ovlBatStr_dteOn.w
        ; target second char
        inx
        ; get target char
        lda ovlBatStr_dteTable_offset.w,X
        sta $F9
        ; !!! drop through !!!
    @notDte:
    ; make up work: increment srcptr
    inc $BE
    bne +
      inc $BF
    +:
    @done:
    rts
.ends

;==============================================================================
; update digit conversion routines for new encoding
;==============================================================================

;==================================
; $29 = src value
; result goes to buffer
;==================================

.bank 0 slot 0
.orga ovlBatStr_numToSjis3Digit_offset+$0
.section "batstr overlay: new digit conversion routine 1" SIZE $55 overwrite
  ovlBatStr_newNumToSjis3Digit:
    ;=====
    ; convert to digits
    ;=====
    
    ; number of digits to convert
    lda #$03
    sta $001F
    ; loop
    -:
      lda $0029
      sta $00F8
      lda $002A
      sta $00F9
      lda #$0A
      sta $00FA
      stz $00FB
      ; MA_DIV16S
      jsr $E0C9
      ; result
      lda $00FC
      sta $0029
      lda $00FD
      sta $002A
      ; target next digit's position in buffer
      lda $001F
  ;    asl 
      dea 
      tay 
      ; get remainder
      lda $00FE
      ; add codepoint 824F to convert to SJIS digit
  /*    clc 
      adc #$4F
      sta ovlBatStr_numConvBuffer_offset.w,Y
      dey 
      lda #$82
      sta ovlBatStr_numConvBuffer_offset.w,Y */
      clc
      adc #digitBaseOffset
      sta ovlBatStr_numConvBuffer_offset.w,Y
      dec $001F
      bne -
    
    ;=====
    ; convert leading zeroes to spaces
    ;=====
    
    cly 
    ldx #$02
    ; convert initial zeroes to spaces
    ; loop
    -:
      lda ovlBatStr_numConvBuffer_offset.w,Y
      cmp #digitZeroOffset
      bne @done
        ; replace with space
;        lda #digitSpaceOffset
        ; better yet, a null character so that this won't generate an awkward
        ; space when used in dialogue
        lda #nullCharOffset
        sta ovlBatStr_numConvBuffer_offset.w,Y
        iny 
        dex 
        bne -
    @done:
    rts 
  
.ends

;==================================
; draw MP values from correct position in buffer
; (original game indexes into the digit buffer;
; due to the different codepoint size, this has
; to be adjusted)
;==================================

.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+$75
.section "batstr overlay: drawHud fix 1" overwrite
  lda #<ovlBatStr_numConvBuffer_offset
.ends

.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+$79
.section "batstr overlay: drawHud fix 2" overwrite
  lda #>ovlBatStr_numConvBuffer_offset
.ends

.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+$101
.section "batstr overlay: drawHud fix 3" overwrite
  lda #<ovlBatStr_numConvBuffer_offset
.ends

.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+$105
.section "batstr overlay: drawHud fix 4" overwrite
  lda #>ovlBatStr_numConvBuffer_offset
.ends

;==================================
; also adjust MP position rightward
;==================================

.define ovlBatStr_mpRightNudge 1

/*.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+($5222-$51E5)
.section "batstr overlay: drawHud mp nudge 1" overwrite
  lda #$0D+ovlBatStr_mpRightNudge
.ends */

.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+($5262-$51E5)
.section "batstr overlay: drawHud mp nudge 2" overwrite
  lda #$12+ovlBatStr_mpRightNudge
.ends

/*.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+($52AE-$51E5)
.section "batstr overlay: drawHud mp nudge 3" overwrite
  lda #$01+ovlBatStr_mpRightNudge
.ends */

.bank 0 slot 0
.orga ovlBatStr_drawHud1_offset+($52EE-$51E5)
.section "batstr overlay: drawHud mp nudge 4" overwrite
  lda #$06+ovlBatStr_mpRightNudge
.ends


