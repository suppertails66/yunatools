
;==============================================================================
; postbat 04: shiori
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat04.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat04_ovlScene.inc"
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
    
    cut_waitForFrame $0040
    
    .incbin "include/postbat4/string450001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $008D
    
    cut_waitForFrameMinSec 0 2.35
    cut_swapAndShowBuf
    
    .incbin "include/postbat4/string450002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 7.191
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat4/string450003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 9.566
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 12.966+0.15
    cut_subsOff
    
/*    .incbin "include/postbat1/string420003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $01EC
    cut_subsOff
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
      cut_subsOff
    
    cut_waitForFrameMinSec 0 23.448
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420007.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 27.411
      cut_subsOff
    
    cut_waitForFrameMinSec 0 30.755
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 31.784
    cut_subsOff */
    
    cut_terminator
.ends
