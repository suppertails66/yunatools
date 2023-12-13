
;==============================================================================
; scene 09: dark nebula intro
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene09.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene09_ovlScene.inc"
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;==============================================================================
; script
;==============================================================================

.define subOffset 0.683-0.025

.bank 0 slot 0
.section "script 1" free
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $20
    
    ;=====
    ; narration
    ;=====
    
    ; "the dark nebula"
    .incbin "include/scene9/string100000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $009F
    
    cut_waitForFrameMinSec 0 2.016+subOffset
    cut_swapAndShowBuf
    
    ; "although it is called"
    .incbin "include/scene9/string100001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 3.981+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "there, a space"
    .incbin "include/scene9/string100002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 8.255+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this dark space"
    .incbin "include/scene9/string100003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 14.149+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no one can perceive"
    .incbin "include/scene9/string100004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 18.501+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 21.750+subOffset
    cut_subsOff
    
    cut_terminator
.ends





