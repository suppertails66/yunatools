
;==============================================================================
; scene 12: gina awakening
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene12.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene12_ovlScene.inc"
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

.define timeOffset 29/60

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
    
;    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $20
    
    ;=====
    ; gina reveal
    ;=====
    
    ; "yuna, i've been waiting"
    .incbin "include/scene12/string190000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0526
    
    cut_waitForFrameMinSec 0 21.972+timeOffset
    cut_swapAndShowBuf
    
    ; just for posterity, i'd like to note that the one-frame glitch
    ; briefly visible at this point is in the original game.
    ; not everything is my fault!
    
    ; "how do you do"
    .incbin "include/scene12/string190001.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 26.573+timeOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $0A5C
    cut_waitForFrameMinSec 0 44.028+timeOffset+(3/60)
    cut_swapAndShowBuf
    
    ; "a pleasure to meet you"
    .incbin "include/scene12/string190002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 47.396+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "hm? so you're one of"
    .incbin "include/scene12/string190003.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 48.576+timeOffset
      cut_subsOff
    
    SYNC_adpcmTime 4 $0D9B
    
    cut_waitForFrameMinSec 0 58.008+timeOffset
    cut_swapAndShowBuf
    
    ; "that's right"
    .incbin "include/scene12/string190004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 1.817+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh..."
    .incbin "include/scene12/string190005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 2.656+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey hey, you don't"
    .incbin "include/scene12/string190006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 3.580+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i can't say that i"
    .incbin "include/scene12/string190007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 6.679+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "at any rate, yuna"
    .incbin "include/scene12/string190008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 8.354+timeOffset
      cut_subsOff
    
    SYNC_adpcmTime 5 $1051
    
    cut_waitForFrameMinSec 1 9.869+timeOffset
    cut_swapAndShowBuf
    
    ; "another one of your"
    .incbin "include/scene12/string190009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 12.933+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "come on, let's"
    .incbin "include/scene12/string190010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 17.261+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "right"
    .incbin "include/scene12/string190011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 19.391+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 20.391+timeOffset
    cut_subsOff
    
/*    ;=====
    ; narration
    ;=====
    
    SYNC_adpcmTime 1 $0079
    
    ; "the cardia star system"
    .incbin "include/scene4/string50000.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 2.669
    cut_swapAndShowBuf
    
    ; "instead, it's"
    .incbin "include/scene4/string50001.bin"
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





