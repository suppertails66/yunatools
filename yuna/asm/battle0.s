
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
   
   slotsize        $A000
   slot            0       $4000
.endme

.rombankmap
  bankstotal $1
  
  banksize $A000
  banks $1
.endro

.emptyfill $FF

.background "battle0_B1BA.bin"

; FIXME: safe?
.unbackground $1648 $17FF
.unbackground $4ED8 $4FFF
;.unbackground $1660 $17FF
;.unbackground $4EE0 $4FFF

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/battle0_strings_overwrite.inc"

.bank 0 slot 0
.section "battle0 static strings free" free
  .include "include/battle0_strings.inc"
.ends

; these are new and do not get an overwrite
.bank 0 slot 0
.section "battle0 static strings free 2" free
  .include "include/battle0_new_strings.inc"
.ends

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

;.define freeDataBank 3
;.define freeDataSlot 4

.define ovlText_font $3C00
.define ovlText_fontWidthTable ovlText_font+(limitedFontMaxChars*bytesPerRawFontChar)

.define ovlText_fontLoadType fontLoadType_preload
.define ovlText_omitSpecialDstMode 1
.include "include/battle0_ovlText.inc"
.include "overlay/text.s"

/*.define ovlBatStr_fullStringPrint_offset $5355
.define ovlBatStr_simpleStringPrint_offset $7E19
;.define ovlBatStr_scriptPtr_offset $BE
.define ovlBatStr_waitVblank_offset $7121
.define ovlBatStr_numToSjis3Digit_offset $5300
.define ovlBatStr_numConvBuffer_offset $2681
.define ovlBatStr_drawHud1_offset $51E5*/
.include "include/battle0_ovlBattle.inc"
.define ovlBatStr_dteTable_offset $3B40
.include "overlay/battle_string.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;===================================
; load font data with yuna stat block
;===================================

.bank 0 slot 0
.orga $5400
.section "battle0 load font 1" overwrite
  ; copy full sector instead of only part of it.
  ; the font data has already been appended to the target location.
;  tii $C000,$3800,$0100
  tii $C000,$3800,$0800
.ends

;===================================
; fix "yuna defeated [name]" message
;===================================

.bank 0 slot 0
.orga $41C8+2
.section "battle0 victory fix 1" overwrite
  .dw battle0_new_string0
.ends



