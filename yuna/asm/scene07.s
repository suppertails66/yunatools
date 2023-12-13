
;==============================================================================
; scene 07: balmood intro
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene07.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene07_ovlScene.inc"
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
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
;    cut_waitForFrame $20
    cut_waitForFrame $40
    
    ;=====
    ; ship
    ;=====
    
    ; "that scared me"
    .incbin "include/scene7/string80001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $0489
    
    cut_waitForFrameMinSec 0 20.638-0.100
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, i want you to"
    .incbin "include/scene7/string80002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 22.104
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "elner, your voice is scaring me"
    .incbin "include/scene7/string80003.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 26.119-0.330
      cut_subsOff
    
    cut_waitForFrameMinSec 0 27.591-0.330
    cut_swapAndShowBuf
    
    ; "did you enter the"
    .incbin "include/scene7/string80004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.732-0.330
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?"
    .incbin "include/scene7/string80005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 34.642-0.330-0.050
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "isn't this good enough"
    .incbin "include/scene7/string80006.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 35.307-0.330
;      cut_subsOff
    
;    cut_waitForFrameMinSec 0 36.158-0.330
    cut_waitForFrameMinSec 0 36.174
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "even though"
    .incbin "include/scene7/string80007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 40.112-0.330
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yay, yay"
    .incbin "include/scene7/string80008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 43.973-0.330
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; planet intro
    ;=====
    
    ; "the giant planet balmood"
    .incbin "include/scene7/string80009.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 47.411-0.330
      cut_subsOff
    
    SYNC_adpcmTime 5 $0B7F
    
    cut_waitForFrameMinSec 0 49.448-0.330
    cut_swapAndShowBuf
    
    ; "one that failed to"
    .incbin "include/scene7/string80010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 53.732
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this not-so-unusual"
    .incbin "include/scene7/string80011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 57.455
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "because it contained abundant"
    .incbin "include/scene7/string80012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 2.431
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "at present, it"
    .incbin "include/scene7/string80013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 7.439
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 12.492
    cut_subsOff
    
    cut_terminator
.ends





