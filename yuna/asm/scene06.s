
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

;================================
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================
  
  ; "FIRST" album scroll
;  fixDspOffWithSprClrAndSync $4398

;================================
; no sprite letterboxing on lower part of scene
;================================

/*.bank 0 slot 0
.orga $4113
.section "sprite letterbox fix 1" overwrite
  nop
  nop
  nop
.ends */

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
    
    cut_waitForFrame $20
    
    ;=====
    ; narration
    ;=====
    
    SYNC_adpcmTime 1 $0079
    
    ; "planet loureezus"
    .incbin "include/scene6/string70000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
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
    
    SYNC_adpcmTime 3 $091C
    
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
    
    ; "mariana of the"
/*    .incbin "include/scene5/string60001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 4.757-0.100
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the climate there"
    .incbin "include/scene5/string60002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.946
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "and its paltry"
    .incbin "include/scene5/string60003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 13.166
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now, it has become"
    .incbin "include/scene5/string60004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.874
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "though it lacks"
    .incbin "include/scene5/string60005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 19.355
      cut_subsOff
    
    cut_waitForFrameMinSec 0 20.688
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "recent research"
    .incbin "include/scene5/string60006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 24.698
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "and possessed"
    .incbin "include/scene5/string60007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.886
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ha"
    .incbin "include/scene5/string60008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 33.985
      cut_subsOff
    
    ;=====
    ; ship
    ;=====
    
    SYNC_adpcmTime 3 $0892
    
    cut_waitForFrameMinSec 0 37.221
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wooow"
    .incbin "include/scene5/string60009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 39.897
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but the earth"
    .incbin "include/scene5/string60010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 42.149
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i really don't see"
    .incbin "include/scene5/string60011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 45.044
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "c'mon elner"
    .incbin "include/scene5/string60012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 48.338
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the ocean is just"
    .incbin "include/scene5/string60013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 50.607
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 53.168
    cut_subsOff */
    
    cut_terminator
.ends





