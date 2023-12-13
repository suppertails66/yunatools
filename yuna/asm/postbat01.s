
;==============================================================================
; postbat 01: rock princess
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat01.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat01_ovlScene.inc"
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
    
    .incbin "include/postbat1/string420002.bin"
;    cut_prepAndSendGrp $01BC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $00E4
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420003.bin"
    SCENE_prepAndSendGrpAuto
    
      SYNC_adpcmTime 2 $01EC
      cut_subsOff
    
    cut_waitForFrameMinSec 0 9.657
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420004.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 11.692-0.683
      cut_subsOff
    
    cut_waitForFrameMinSec 0 15.918-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 17.210-0.683
      cut_subsOff
    
    cut_waitForFrameMinSec 0 19.157-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420006.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 21.103
;      cut_waitForFrameMinSec 0 22.183
      cut_subsOff
    
    cut_waitForFrameMinSec 0 23.448
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420007.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 27.411
      cut_waitForFrameMinSec 0 28.498
      cut_subsOff
    
    cut_waitForFrameMinSec 0 30.755
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 31.784+0.600
    cut_subsOff
    
    cut_terminator
.ends
