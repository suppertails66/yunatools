
;==============================================================================
; postbat 03: mai in corridor
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat03.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat03_ovlScene.inc"
.undefine playAdpcm
.define use_playAdpcmSpecial
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free
  
  ; lol, i set everything up for this only to discover that it in fact has
  ; no voiceovers
  subtitleScriptData:
    cut_terminator
.ends
