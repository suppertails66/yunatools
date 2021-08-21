
;==============================================================================
; bootloader 4 - load
;==============================================================================

;.include "include/bootloader_common.inc"

; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $800
   slot            0       $3800
.endme

.rombankmap
  bankstotal $1
  
  banksize $800
  banks $1
.endro

.emptyfill $FF

.background "bootloader4_A97E.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

;.include "overlay/bootloader.s"

.define ovlBoot_newCodeBase $3885

;==============================================================================
; other modifications specific to this executable
;==============================================================================

.bank 0 slot 0
.orga ovlBoot_newCodeBase
.section "font 1" SIZE $77B overwrite
/*  ovlText_fontWidthTable:
    .incbin "out/font/fontwidth.bin"
  ovlText_font:
    .incbin "out/font/font.bin"*/
  ovlText_fontWidthTable:
    .incbin "out/font/fontwidth_limited.bin"
  ovlText_font:
    .incbin "out/font/font_limited.bin"
.ends
.

