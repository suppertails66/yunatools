
;==============================================================================
; scene 11: marina awakening
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene11.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene11_ovlScene.inc"
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
    ; pond glow
    ;=====
    
    ; "yuna, look at that"
    .incbin "include/scene11/string180000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $007A
    
    cut_waitForFrameMinSec 0 2.716-0.066
    cut_swapAndShowBuf
    
    ; "yaaay"
    .incbin "include/scene11/string180001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 5.558-0.066
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you really think"
    .incbin "include/scene11/string180002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 8.444
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "there could be one"
    .incbin "include/scene11/string180003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.610
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i don't think so"
    .incbin "include/scene11/string180004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 12.242
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay okay"
    .incbin "include/scene11/string180005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 13.268
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "who cares"
    .incbin "include/scene11/string180006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.245
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ah, you're ducking"
    .incbin "include/scene11/string180007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.985
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, don't you"
    .incbin "include/scene11/string180008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 18.500
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?"
    .incbin "include/scene11/string180009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 21.148
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i do"
    .incbin "include/scene11/string180010.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 22.148
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 22.945
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it feels like"
    .incbin "include/scene11/string180011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 24.321
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so, what does that"
    .incbin "include/scene11/string180012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 27.050
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "...you get it, right"
    .incbin "include/scene11/string180013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 28.796
    cut_subsOff
    cut_swapAndShowBuf
    
    ; NOTE: there's some emulator issue here that causes the sound
    ; to screw up and go out of sync, so I'm pretty much just guessing
    ; at the timing on these lines
    
    ; "umm...uhh..."
    .incbin "include/scene11/string180014.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.391
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no fair suddenly changing"
    .incbin "include/scene11/string180015.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 34.681
;    cut_waitForFrameMinSec 0 34.681-2.500
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; flash
    ;=====
    
    ; "ah! it's bright"
    .incbin "include/scene11/string180016.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 37.646
;      cut_waitForFrameMinSec 0 37.646-2.500
      cut_subsOff
    
    SYNC_adpcmTime 2 $09C4
    
;    cut_waitForFrameMinSec 0 42.296
    cut_waitForFrameMinSec 0 43.284
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, open your eyes"
    .incbin "include/scene11/string180017.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 44.121
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you need to see this"
    .incbin "include/scene11/string180018.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 46.002
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but it's so bright"
    .incbin "include/scene11/string180019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 47.092
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "huh?"
    .incbin "include/scene11/string180020.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 48.658+0.300
      cut_subsOff
    
    SYNC_adpcmTime 3 $0CB9
    
    cut_waitForFrameMinSec 0 54.453
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; deliberately wait until these subs are done to render next text
    ; (otherwise, we get flicker)
;    cut_waitForFrameMinSec 0 55.453
;    cut_subsOff
    
    ;=====
    ; marina introduction
    ;=====
    
    ; "how do you do"
    .incbin "include/scene11/string180021.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 55.212
      cut_waitForFrameMinSec 0 55.453
      cut_subsOff
    
    SYNC_adpcmTime 5 $11F3
    
    cut_waitForFrameMinSec 1 17.230
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's been a while"
    .incbin "include/scene11/string180022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 18.791
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you're yuna"
    .incbin "include/scene11/string180023.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 21.896
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm marina"
    .incbin "include/scene11/string180024.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 1 24.064
;      cut_subsOff
    
    cut_waitForFrameMinSec 1 25.473
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's nice to meet you"
    .incbin "include/scene11/string180025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 26.933
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna introduction
    ;=====
    
    ; "oh, thank you"
    .incbin "include/scene11/string180026.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 27.663+0.300
      cut_subsOff
    
    SYNC_adpcmTime 6 $14ED
    
    cut_waitForFrameMinSec 1 29.932
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i, uh..."
    .incbin "include/scene11/string180027.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 34.801
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wait, what do i"
    .incbin "include/scene11/string180028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 36.755
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "umm..."
    .incbin "include/scene11/string180029.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 39.473
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you're very pink"
    .incbin "include/scene11/string180030.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 1 40.551
;      cut_subsOff
    
    cut_waitForFrameMinSec 1 42.135
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "ignore her, marina"
    .incbin "include/scene11/string180031.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 43.067+0.300
      cut_subsOff
    
    SYNC_adpcmTime 7 $183E
    
    cut_waitForFrameMinSec 1 44.061
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "c'mon, you're embarrassing"
    .incbin "include/scene11/string180033.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 47.284
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "somehow, i feel like"
    .incbin "include/scene11/string180034.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 49.575
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "marina, we want"
    .incbin "include/scene11/string180035.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 52.001
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'll do anything i can"
    .incbin "include/scene11/string180036.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 55.157
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "in the undersea temple"
    .incbin "include/scene11/string180037.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 56.982
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "is the former savior"
/*    .incbin "include/scene11/string180052.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 0.115
    cut_subsOff
    cut_swapAndShowBuf */
    
    ; "i'm certain that she'll"
    .incbin "include/scene11/string180038.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 2.721
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "gotcha"
    .incbin "include/scene11/string180039.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 6.219
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "umm..."
    .incbin "include/scene11/string180040.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 10.392
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i don't know if i follow"
    .incbin "include/scene11/string180041.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 11.622
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "what's 'amazing'"
    .incbin "include/scene11/string180042.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 14.002+0.300
      cut_subsOff
    
    SYNC_adpcmTime 8 $1FCA
    
    cut_waitForFrameMinSec 2 16.209
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "in other words"
    .incbin "include/scene11/string180043.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 19.848
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, no no no"
    .incbin "include/scene11/string180044.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 22.325
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this is all"
    .incbin "include/scene11/string180045.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 25.655
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "for pete's sake"
    .incbin "include/scene11/string180046.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 26.862
      cut_subsOff
    
    SYNC_adpcmTime 9 $2276
    
    cut_waitForFrameMinSec 2 27.598
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "come on, now"
    .incbin "include/scene11/string180047.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 30.259
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well, shall we"
    .incbin "include/scene11/string180048.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 31.865
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "agreed"
    .incbin "include/scene11/string180049.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 34.291
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "in any case"
    .incbin "include/scene11/string180050.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 35.437
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "right!"
    .incbin "include/scene11/string180051.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 37.194
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 2 37.885
    cut_waitForFrameMinSec 2 38.194
    cut_subsOff
    
    ; "a pleasure to meet you"
/*    .incbin "include/scene12/string190002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 47.396
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "hm? so you're one of"
    .incbin "include/scene12/string190003.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 48.576
      cut_subsOff
    
    SYNC_adpcmTime 4 $0D9B
    
    cut_waitForFrameMinSec 0 58.008
    cut_swapAndShowBuf
    
    ; "that's right"
    .incbin "include/scene12/string190004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 1.817
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh..."
    .incbin "include/scene12/string190005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 2.656
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey hey, you don't"
    .incbin "include/scene12/string190006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 3.580
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i can't say that i"
    .incbin "include/scene12/string190007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 6.679
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "at any rate, yuna"
    .incbin "include/scene12/string190008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 8.354
      cut_subsOff
    
    SYNC_adpcmTime 5 $1051
    
    cut_waitForFrameMinSec 1 9.869
    cut_swapAndShowBuf
    
    ; "another one of your"
    .incbin "include/scene12/string190009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 12.933
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "come on, let's"
    .incbin "include/scene12/string190010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 17.261
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "right"
    .incbin "include/scene12/string190011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 19.391
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 20.391
    cut_subsOff */
    
    cut_terminator
.ends





