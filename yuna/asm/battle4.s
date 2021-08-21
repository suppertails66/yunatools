
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

.background "battle4_B20A.bin"

;.unbackground $1660 $17FF
;.unbackground $4EE0 $4FFF

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/battle4_strings_overwrite.inc"
.bank 0 slot 0
.section "battle4 static strings free 1" free
  .include "include/battle4_strings.inc"
.ends

.include "include/battle4_enemy_strings_overwrite.inc"
.bank 0 slot 0
.section "battle4 static strings free 2" free
  .include "include/battle4_enemy_strings.inc"
.ends

.include "include/battle4_ally_strings_overwrite.inc"
.bank 0 slot 0
.section "battle4 static strings free 3" free
  .include "include/battle4_ally_strings.inc"
.ends

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

.define ovlText_fontLoadType fontLoadType_normal
.include "include/battle4_ovlText.inc"
.include "overlay/text.s"

.include "include/battle4_ovlBattle.inc"
; NOTE: strings are not compressed; this should never be referenced
.define ovlBatStr_dteTable_offset $FFFF
.include "overlay/battle_string.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;===================================
; 
;===================================



