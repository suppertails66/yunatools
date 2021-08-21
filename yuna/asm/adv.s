
;.include "sys/pce_arch.s"
;.include "base/macros.s"

.include "include/global.inc"

/*.memorymap
   defaultslot     0
   ; ROM area
   slotsize        $2000
   slot            0       $0000
   slot            1       $2000
   slot            2       $4000
   slot            3       $6000
   slot            4       $8000
   slot            5       $A000
   slot            6       $C000
   slot            7       $E000
.endme */

; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $8000
   slot            0       $4000
.endme

;.rombankmap
;  bankstotal $2
;  
;  banksize $6000
;  banks $1
;  banksize $2000
;  banks $1
;.endro

.rombankmap
  bankstotal $1
  
  banksize $8000
  banks $1
.endro

.emptyfill $FF

.background "adv_87EA.bin"

.unbackground $4F80 $5FFF
.unbackground $6000 $7FFF

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/system_adv_strings_overwrite.inc"

.bank 0 slot 0
.section "system_adv static strings free" free
  .include "include/system_adv_strings.inc"
.ends

.bank 0 slot 0
.section "text compression 1" free
  dteDictionary:
    .incbin "out/script/script_dictionary.bin"
.ends
.define useDteDictionary 1

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

;.define freeDataBank 3
;.define freeDataSlot 4

;.define ovl_addTo29_offset $80B6
;.define ovl_multTo29_offset $80F1
;.define ovlText_printChar_offset $6950
.define ovlText_fontLoadType fontLoadType_normal
.include "include/adv_ovlText.inc"
.include "overlay/text.s"

.include "include/adv_ovlAdvString.inc"
.include "overlay/adv_string.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;==============================================================================
; DEBUG
;==============================================================================

;================================
; DEBUG: button 1 can skip lines
;================================

/*.bank 0 slot 0
.orga $6E06
.section "button 1 line skip 1" overwrite
  ; check joytrg instead of joy
  lda $2228
;  lda $222D

;  and #$02
  and #$03
.ends */

;================================
; DEBUG: always do fast printing
;================================

/*.bank 0 slot 0
.orga $6E09
.section "always fast-forward text 1" overwrite
  lda #$FF
.ends */

;================================
; DEBUG: when waiting on a button press,
; do not wait for all buttons to become
; unpressed first.
; instead, simply wait until the specified
; button(s) are triggered.
;================================

.bank 0 slot 0
.orga $88D1
.section "button 1 line skip 2" overwrite
  ; don't wait for all buttons to become unpressed
  nop
  nop
  nop
.ends

.bank 0 slot 0
.orga $88DC
.section "button 1 line skip 3" overwrite
  ; oh, the game actually double-reads the controller.
  ; EX_JOYSNS is called in the vblank handler, but then
  ; again manually here.
  ; no wonder checking joytrg didn't work.
  ; well, that makes things easier!
  
  ; don't call EX_JOYSNS
  nop
  nop
  nop
  
;  jsr newButtonTriggerLogic
  
  ; check joytrg 1
  lda $222D
.ends

/*.bank 0 slot 0
.section "button 1 line skip 4" free
  newButtonTriggerLogic:
    ; get buttons currently pressed
    lda $2228.w
    ; xor against buttons pressed last frame
    ; (any buttons held last frame and this one become zero)
    eor $2232.w
    ; AND with buttons currently pressed
    ; (any buttons held last frame, but not this one, become zero)
    and $2228.w
    rts
.ends */

;==============================================================================
; misc
;==============================================================================

;================================
; allow voiced lines to be skipped
;================================

/*.bank 0 slot 0
.orga $80AE
.section "skippable voiced lines 1" overwrite
  ; call unused ADPCM stop routine instead of ADPCM wait routine.
  ; the routines are directly adjacent and it's pretty obvious they
  ; were using the stop routine during development, then changed
  ; it to the wait routine for the final version so the game
  ; would take longer, because screw the players, right?
;  jsr $5649
  jsr $563B
.ends*/

; oops, that's not good enough -- the game uses the same waitForAdpcm
; script command to wait for voice clips as it does for sound effects.
; this meant that replacing the above wait with a stop caused sound
; effects to not trigger.
; instead, we'll add code to stop the adpcm when the confirmation
; button press occurs after each dialogue box.

.bank 0 slot 0
.orga $6DE1
.section "skippable voiced lines 1" overwrite
  jmp doNewDlogEnd
.ends

.bank 0 slot 0
.section "skippable voiced lines 2" free
  doNewDlogEnd:
    ; stop adpcm
    jsr $563B
    
    ; reset adpcm controller
;    jsr $E030
;    cla
;    jsr $E02D
    
    ; make up work
    stz $F8
    stz $F9
    rts
.ends

.bank 0 slot 0
.orga $5653
.section "skippable voiced lines 3" overwrite
  ; the game originally checks if the X return code of AD_STAT
  ; is 1 ("stop playback") before continuing.
  ; i believe this is overzealous -- it absolutely *requires*
  ; that the audio in question play out in full.
  ; stopping it with AD_STOP will not cause it to become 1 --
  ; it will continue to read 00 or 04. indeed, it seems nothing
  ; will convince the bios that playback has ended short
  ; of letting a whole clip play back (or maybe loading a new one?),
  ; which is exactly what we're trying to avoid.
  ; so i've just removed this check entirely.
  nop
  nop
  nop
  nop
.ends

;==============================================================================
; string handling
;==============================================================================

;================================
; simple strings:
; advance only 1 byte per codepoint
;================================

/*.bank 0 slot 0
.orga $6D1C
.section "simple string: 1b codepoints 1" overwrite
;  jmp $6D26
  jsr doDteCheck
  jmp $6D26
.ends */

;================================
; full strings:
; advance only 1 byte per codepoint
;================================

.bank 0 slot 0
.orga $6E75
.section "full string: 1b codepoints 1" overwrite
;  jmp $6E7D
  jsr doDteCheck
  jmp $6E7F
.ends

;================================
; full strings:
; no auto linewrap
;================================

.bank 0 slot 0
.orga $6E9E
.section "full string: no auto-linewrap 1" overwrite
  nop
  nop
  nop
  nop
.ends

;================================
; full strings:
; allow double linebreaks
;================================

.bank 0 slot 0
.orga $6EA9
.section "full string: allow double linebreaks 1" overwrite
  nop
  nop
  nop
.ends

;==============================================================================
; text compression
;==============================================================================

/*.bank 0 slot 0
.section "text compression 1" free
  dteDictionary:
    .incbin "out/script/script_dictionary.bin"
  
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
.ends */

;==============================================================================
; double standard printing speed
;==============================================================================

.bank 0 slot 0
.orga $6E15
.section "set default printing speed 1" overwrite
;  lda #$04
  lda #$02
.ends

;==============================================================================
; fix conditional statement lookups
;==============================================================================

; NOTE: only adv does this.
; boot/load/title omit it, despite sharing other string-related code

;================================
; do sub-lookup for condition strings
;================================

; TODO: this can probably be removed, and the conditional strings
; simply left in at their old positions unmodified.
; for the moment, left in for testing.

.bank 0 slot 0
.orga $6861
.section "condition string block lookup 1" overwrite
  jsr doNewConditionStringLookup
.ends

.bank 0 slot 0
.section "condition string block lookup 2" free
  doNewConditionStringLookup:
    ; page in text block
    jsr $602A
    
    ; check for replacement sentinel
    lda ($27)
    cmp #code_jump
    bne @done
    
      ; fetch first two bytes, which are pointer to new target string,
      ; and replace srcptr
      ldy #$01
      ; low byte
      lda ($27),Y
      pha
        ; high byte
        iny
        lda ($27),Y
        sta $28
      pla
      sta $27
    
    @done:
    ; make up work
    rts
.ends

;==============================================================================
; fix unindexed block lookups
;==============================================================================

;================================
; do sub-lookup for standard strings
;================================

; FIXME: this probably needs to be turned into an overlay.
;        loadgame/title appear to all have the same stuff.

/*.bank 0 slot 0
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
.ends */

/*.bank 0 slot 0
.orga $569E
.section "standard string new block lookup 2" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $5744
.section "standard string new block lookup 3" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $5766
.section "standard string new block lookup 4" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $57A2
.section "standard string new block lookup 5" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $57F4
.section "standard string new block lookup 6" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $5897
.section "standard string new block lookup 7" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $58B9
.section "standard string new block lookup 8" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $77D4
.section "standard string new block lookup 9" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $786D
.section "standard string new block lookup 10" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $7991
.section "standard string new block lookup 11" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $79B7
.section "standard string new block lookup 12" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $7A8F
.section "standard string new block lookup 13" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $7AAA
.section "standard string new block lookup 14" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $7AE0
.section "standard string new block lookup 15" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $7AFB
.section "standard string new block lookup 16" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $87ED
.section "standard string new block lookup 17" overwrite
  jsr doNewStandardStringLookup
.ends

.bank 0 slot 0
.orga $880F
.section "standard string new block lookup 18" overwrite
  jsr doNewStandardStringLookup
.ends */

;================================
; proper dynamic file number insertion
;================================

; FIXME: make overlay

; note that the target strings must not be compressed, obviously

/*.define fileNumOffsetWithinString 5

.bank 0 slot 0
.orga $7852
.section "write new file number correctly load 1" overwrite
  ; convert file number to digit
  adc #digitBaseOffset+1
  ; write to the file number string
  sta systemAdv_string15+fileNumOffsetWithinString.w
.ends

.bank 0 slot 0
.orga $7976
.section "write new file number correctly save 1" overwrite
  ; convert file number to digit
  adc #digitBaseOffset+1
  ; write to the file number string
  sta systemAdv_string16+fileNumOffsetWithinString.w
.ends */


;==============================================================================
; load new intro cutscene AC card data
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

;==============================================================================
; update digit conversion routine for new encoding
;==============================================================================

; this is needed for exactly one (1) thing in the entire game:
; the digit display on the debug menu's picture viewer.

;==================================
; $29 = src value
; result goes to buffer
;==================================

;.define numConvBufferOffset $275A

.bank 0 slot 0
.orga $8884
.section "new digit conversion routine 1" SIZE $3F overwrite
/*  lda #$03
  sta $001F
  lda $2761.w
  sta $0029
  lda $2762.w
  sta $002A
  ; loop
  -:
    lda $0029
    sta $00F8
    lda $002A
    sta $00F9
    lda #$0A
    sta $00FA
    stz $00FB
    ; divide + remainder
    jsr $E0C9
    lda $00FC
    sta $0029
    lda $00FD
    sta $002A
    lda $001F
    asl 
    dec 
    tay 
    ; get result digit
    lda $00FE
    ; add to base SJIS digit to get output value
    clc 
    adc #$4F
    sta $275A.w,Y
    dey 
    lda #$82
    sta $275A.w,Y
    dec $001F
    bne -
  rts */
  
  lda #$03
  sta $001F
  
  lda $2761.w
  sta $0029
  lda $2762.w
  sta $002A
  ; loop
  -:
    lda $0029
    sta $00F8
    lda $002A
    sta $00F9
    lda #$0A
    sta $00FA
    stz $00FB
    ; divide + remainder
    jsr $E0C9
    lda $00FC
    sta $0029
    lda $00FD
    sta $002A
    
    lda $001F
;    asl 
    dea 
    tay 
    ; get result digit
    lda $00FE
    ; add to digit base to get output value
    clc 
    adc #digitBaseOffset
    sta $275A.w,Y
    dec $001F
    bne -
  ; write terminator
  stz $275A+3.w
  rts 
.ends
