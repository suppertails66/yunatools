
;==============================================================================
; postbat 0E: kaede
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat0F.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat0F_ovlScene.inc"
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
    
    cut_waitForFrame $0040
    
    .incbin "include/postbatF/string560000.bin"
;    cut_prepAndSendGrp $01BC
    SCENE_prepAndSendGrpAuto
    
;    cut_waitForAdpcm 1
    SYNC_adpcmTime 1 $0084
    cut_swapAndShowBuf
    
    .incbin "include/postbatF/string560002.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $01B2
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbatF/string560003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $0309
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbatF/string560004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 17.063
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbatF/string560005.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $04EE
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 26.125
    cut_subsOff
    
    cut_terminator
.ends
