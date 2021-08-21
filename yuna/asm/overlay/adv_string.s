
;==============================================================================
; required defines
;==============================================================================

;.ifndef ovlBatStr_fullStringPrint_offset
;  .fail
;.endif

;==============================================================================
; 
;==============================================================================

;==============================================================================
; string handling
;==============================================================================

;================================
; simple strings:
; advance only 1 byte per codepoint
;================================

.bank 0 slot 0
.orga printSimpleString+($6D1C-$6D0D)
.section "simple string: 1b codepoints 1" overwrite
  .ifdef useDteDictionary
    jsr doDteCheck
  .endif
  jmp printSimpleString+($6D26-$6D0D)
.ends

.ifdef useDteDictionary
  .bank 0 slot 0
  .section "text compression 2" free
    dteOn:
      .db $00

    doDteCheck:
      ; at this point, the $B3 src pointer has already been incremented
      ; (because this is more convenient for handling control characters),
      ; so if we detect that this is the start of a DTE character,
      ; we have to decrement it
      
      cmp #code_dteBase
      bcc @done
        sec
        sbc #code_dteBase
        asl
        tax
      
        ; if DTE already on, load second char and turn off
        lda dteOn.w
        bne @secondChar
        @firstChar:
          ; mark DTE as on
          inc dteOn.w
          ; get target char
          lda dteDictionary.w,X
          sta $F9
          ; decrement srcptr so we see this character again next iteration
          lda stringSrcPtr
          bne +
            dec stringSrcPtr+1
          +:
          dec stringSrcPtr
          bra @done
        @secondChar:
          ; mark DTE as off
          stz dteOn.w
          ; target second char
          inx
          ; get target char
          lda dteDictionary.w,X
          sta $F9
      @done:
      rts
  .ends
.endif

;==============================================================================
; fix unindexed block lookups
;==============================================================================

;================================
; do sub-lookup for standard strings
;================================

.bank 0 slot 0
.section "standard string new block lookup 1" free
  doNewStandardStringLookup:
    ; check for jump code
    lda (stringSrcPtr)
    cmp #code_jump
    bne @done
    
      ; fetch first two bytes, which are pointer to new target string,
      ; and replace srcptr
      phy
        ldy #$01
        ; low byte
        lda (stringSrcPtr),Y
        pha
          ; high byte
          iny
          lda (stringSrcPtr),Y
          sta stringSrcPtr+1
        pla
        sta stringSrcPtr
      ply
    
    @done:
    ; make up work
    jmp printSimpleString
.ends

;================================
; proper dynamic file number insertion
;================================

; note that the target strings must not be compressed, obviously

; hardcoded offset within the target string that we need to replace
; the placeholder digit with to produce the desired number string
; (we are expecting "file 1")
.define fileNumOffsetWithinString 5

.ifdef fileNumInsert0
  .bank 0 slot 0
  .orga fileNumInsert0
  .section "write new file number correctly load 1" overwrite
    ; convert file number to digit
    adc #digitBaseOffset+1
    ; write to the file number string
    sta system_string15+fileNumOffsetWithinString.w
  .ends
.endif

.ifdef fileNumInsert1
  .bank 0 slot 0
  .orga fileNumInsert1
  .section "write new file number correctly save 1" overwrite
    ; convert file number to digit
    adc #digitBaseOffset+1
    ; write to the file number string
    sta system_string16+fileNumOffsetWithinString.w
  .ends
.endif




