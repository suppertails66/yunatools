
;.include "sys/pce_arch.s"
;.include "base/macros.s"

.include "include/global.inc"

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

.background "load_42.bin"

; what the hell is all this random crap filling up the file?
; this is the most minimal fucking loading screen you could make!!
.unbackground $4300 $44E0
.unbackground $4520 $47FF
;.unbackground $69A0 $6AC0
;.unbackground $6B20 $6FFF

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/system_load_strings_overwrite.inc"

.bank 0 slot 0
.section "system_load static strings free" free
  .include "include/system_load_strings.inc"
.ends

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; see bootloader4
.define ovlBoot_newCodeBase $3885

.define ovlText_fontLoadType fontLoadType_preload
.define ovlText_fontWidthTable ovlBoot_newCodeBase+0
.define ovlText_font ovlText_fontWidthTable+limitedFontMaxChars

;.define ovlText_fontLoadType fontLoadType_normal
.include "include/load_ovlText.inc"
.include "overlay/text.s"

.include "include/load_ovlAdvString.inc"
.include "overlay/adv_string.s"

;==============================================================================
; 
;==============================================================================
