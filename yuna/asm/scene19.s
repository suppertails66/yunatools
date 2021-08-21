
;==============================================================================
; scene 19: swimsuit contest results
; uniquely, this scene has text but no voiceovers
;==============================================================================

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

;===================================
; common include
;===================================

;.include "include/scene_mini_common.inc"

;.unbackground $3E5F+$40 $9FFF

.background "scene19.bin"

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/scene19_strings_overwrite.inc"

.bank 0 slot 0
.section "scene19 static strings free" free
  .include "include/scene19_strings.inc"
.ends

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
;.include "include/scene19_ovlScene.inc"
;.include "overlay/scene_mini.s"

.include "include/scene19_ovlAdvString.inc"
.include "overlay/adv_string.s"

.define ovlText_fontLoadType fontLoadType_normal
.include "include/scene19_ovlText.inc"
.include "overlay/text.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; 
;================================

