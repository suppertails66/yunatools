
;==============================================================================
; postbat 0D: lia beats yuna
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat0D.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat0D_ovlScene.inc"
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
    
    cut_waitForFrame $0030
    
    .incbin "include/postbatD/string540001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0084
    
    cut_waitForFrameMinSec 0 2.200
    cut_swapAndShowBuf
    
    .incbin "include/postbatD/string540002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 4.843
    cut_subsOff
    cut_swapAndShowBuf
    
;    .incbin "include/postbatD/string540003.bin"
;    SCENE_prepAndSendGrpAuto
    .incbin "include/postbatD/string540004.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 7.100
      cut_subsOff
    
    SYNC_adpcmTime 2 $01BC
    
    cut_waitForFrameMinSec 0 10.503
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 0 14.840
    cut_waitForFrameMinSec 0 14.910
    cut_subsOff
    
    cut_terminator
.ends
