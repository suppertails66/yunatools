
;==============================================================================
; scene 06: arrival at luries
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene06.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene06_ovlScene.inc"
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
    ; narration
    ;=====
    
    ; "planet loureezus"
    .incbin "include/scene6/string70000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $009F
    
    cut_waitForFrameMinSec 0 2.700
    cut_swapAndShowBuf
    
    ; "planet loureezus of the"
    .incbin "include/scene6/string70001.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 4.753-0.100-(3/60)
      cut_subsOff
    
    cut_waitForFrameMinSec 0 5.555
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "since the planet's"
    .incbin "include/scene6/string70002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 11.047
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "there is little"
    .incbin "include/scene6/string70003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 14.221
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the environment there"
    .incbin "include/scene6/string70004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 16.016
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "almost the entire"
    .incbin "include/scene6/string70005.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 18.862
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 20.025
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "and it is abundant"
    .incbin "include/scene6/string70006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 25.987
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "biologists predict"
    .incbin "include/scene6/string70007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 28.758
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "highly intelligent creatures"
    .incbin "include/scene6/string70008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 31.712
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 35.954
    cut_subsOff
    
    ;=====
    ; ship
    ;=====
    
    ; "amazing... it's a green"
    .incbin "include/scene6/string70009.bin"
    SCENE_prepAndSendGrpAuto
    
;    SYNC_adpcmTime 2 $0891
    SYNC_adpcmTime 3 $0942
    
;    cut_waitForFrameMinSec 0 39.514
    cut_waitForFrameMinSec 0 40.420
    cut_swapAndShowBuf
    
    ; "indeed"
    .incbin "include/scene6/string70010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 44.196
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's so beautiful"
    .incbin "include/scene6/string70011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 45.787
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "how fascinating"
    .incbin "include/scene6/string70013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 48.035
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 50.478+0.300
    cut_subsOff
    
    ; "this is getting old"
    .incbin "include/scene6/string70015.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 52.746
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 54.155+0.300
    cut_subsOff
    
    cut_terminator
.ends





