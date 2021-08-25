
;==============================================================================
; scene 05: arrival at mariana
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene05.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene05_ovlScene.inc"
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
  ; script resources
/*  scene00PatchGrp:
    .incbin "out/grp/scene00_patch.bin" FSIZE scene00PatchGrpSize
    .define scene00PatchGrpPartSize (scene00PatchGrpSize/4)
    .define scene00PatchGrp_part1 scene00PatchGrp+(scene00PatchGrpPartSize*0)
    .define scene00PatchGrp_part2 scene00PatchGrp+(scene00PatchGrpPartSize*1)
    .define scene00PatchGrp_part3 scene00PatchGrp+(scene00PatchGrpPartSize*2)
    .define scene00PatchGrp_part4 scene00PatchGrp+(scene00PatchGrpPartSize*3)
  scene00PatchMap:
    .incbin "out/maps/scene00_patch.bin" FSIZE scene00PatchMapSize
  scene00UnpatchMap:
;    .define scene00UnpatchMapSize $100
    .incbin "rsrc_raw/grp/scene00_unpatch_map.bin" FSIZE scene00UnpatchMapSize */
  
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
    
    ; "planet mariana"
    .incbin "include/scene5/string60000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 2.692
    cut_swapAndShowBuf
    
    ; "mariana of the"
    .incbin "include/scene5/string60001.bin"
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
    
;    cut_waitForFrameMinSec 0 37.221
    cut_waitForFrameMinSec 0 38.056
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
    cut_subsOff
    
    ; "instead, it's"
/*    .incbin "include/scene4/string50001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 5.830
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "however, the"
    .incbin "include/scene4/string50002.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 10.881
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now, development"
    .incbin "include/scene4/string50003.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 15.495
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the human cultural"
    .incbin "include/scene4/string50004.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 18.839
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "serves as a"
    .incbin "include/scene4/string50005.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 22.612
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ship
    ;=====
    
    ; "it seems we've"
    .incbin "include/scene4/string50006.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 25.368
      cut_subsOff
    
    cut_waitForFrameMinSec 0 28.830
    cut_swapAndShowBuf
    
    ; "ah, is that ri..."
    .incbin "include/scene4/string50007.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 30.673
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what's wrong"
    .incbin "include/scene4/string50008.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 32.436
      cut_subsOff
    
    cut_waitForFrameMinSec 0 33.842
    cut_swapAndShowBuf
    
    ; "the warp was"
    .incbin "include/scene4/string50009.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 36.868
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "they say that"
    .incbin "include/scene4/string50010.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 39.815
      cut_subsOff
    
    cut_waitForFrameMinSec 0 41.228
    cut_swapAndShowBuf
    
    ; "you don't say"
    .incbin "include/scene4/string50011.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 43.611
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "then again"
    .incbin "include/scene4/string50012.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 46.844
      cut_subsOff
    
    cut_waitForFrameMinSec 0 48.154
    cut_swapAndShowBuf
  
    cut_waitForFrameMinSec 0 50.187
    cut_subsOff */
    
    cut_terminator
.ends





