
;==============================================================================
; postbat 0A: android
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat0A.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat0A_ovlScene.inc"
.undefine playAdpcm
.define use_playAdpcmSpecial
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================
  
  ; "FIRST" album scroll
;  fixDspOffWithSprClrAndSync $4398

;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ;=====
    ; scene
    ;=====
    
    cut_waitForFrame $0030
    
    .incbin "include/postbatA/string510001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $007E
    
    cut_waitForFrameMinSec 0 2.100
    cut_swapAndShowBuf
    
    .incbin "include/postbatA/string510002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0143
    
    cut_waitForFrameMinSec 0 5.374
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbatA/string510003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $01B2
    
    cut_waitForFrameMinSec 0 7.230
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 10.259
    cut_subsOff
    
    cut_terminator
.ends
