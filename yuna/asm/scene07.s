
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

;================================
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================
  
  ; "FIRST" album scroll
;  fixDspOffWithSprClrAndSync $4398

;================================
; elner flight crop fix
;================================

;.bank 0 slot 0
;.orga $408B
;.section "fix 1" overwrite
;  ; disable sprites but not bg
;  jsr $E093
;.ends

/*.bank 0 slot 0
.orga $4434
.section "elner flight fix 1" overwrite
  ; no lower sprite crop
  nop
  nop
  nop
.ends*/

/*.bank 0 slot 0
.orga $4428
.section "elner flight fix 1" overwrite
  ; starting line of lower-screen sprite crop
  ; (we want this to be below the subtitle display area)
  lda #$AF+$30
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
    ; ship
    ;=====
    
    ; "that scared me"
    .incbin "include/scene7/string80001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $0463
    
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
    
    SYNC_adpcmTime 5 $0B59
    
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
    
    ; "what is it"
/*    .incbin "include/sceneF/string160001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.809
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well..."
    .incbin "include/sceneF/string160002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 13.749
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you can relax"
    .incbin "include/sceneF/string160003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 17.879
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so long as she"
    .incbin "include/sceneF/string160004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 23.173
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 1
    ;=====
    
    ; "thank goodness"
    .incbin "include/sceneF/string160005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 27.125
      cut_subsOff
    
    SYNC_adpcmTime 2 $069F
    
    cut_waitForFrameMinSec 0 28.926
    cut_swapAndShowBuf
    
    ; "i was all worried"
    .incbin "include/sceneF/string160006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.898
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna"
    .incbin "include/sceneF/string160007.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 33.396
      cut_subsOff
    
    cut_waitForFrameMinSec 0 35.194
    cut_swapAndShowBuf
    
    ; "yuna, can you hear me"
    .incbin "include/sceneF/string160008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 36.931
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh? that's ryudia's"
    .incbin "include/sceneF/string160009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 40.118
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "am i hearing things"
    .incbin "include/sceneF/string160010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 42.727
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, i am speaking"
    .incbin "include/sceneF/string160011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 44.486
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ryudia was once a savior of"
    .incbin "include/sceneF/string160012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 48.522
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh! right, so"
    .incbin "include/sceneF/string160013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 53.307
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thank goodness"
    .incbin "include/sceneF/string160014.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 57.377
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia pan
    ;=====
    
    ; "i thank you"
    .incbin "include/sceneF/string160015.bin"
    SCENE_prepAndSendGrpAuto
    
  ;    cut_waitForFrameMinSec 0 58.193
      cut_waitForFrameMinSec 0 58.193
      cut_subsOff
    
    SYNC_adpcmTime 3 $0DD1
    
    cut_waitForFrameMinSec 0 59.603
    cut_swapAndShowBuf
    
    ; "what are you saying"
    .incbin "include/sceneF/string160016.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 2.229
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "like some old"
    .incbin "include/sceneF/string160017.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 5.390
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia closeup 1
    ;=====
    
    ; "such a spirited"
    .incbin "include/sceneF/string160018.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 6.419
      cut_subsOff
    
    SYNC_adpcmTime 4 $1012
    
    cut_waitForFrameMinSec 1 9.223
    cut_swapAndShowBuf
    
    ; "she's not 'spirited'"
    .incbin "include/sceneF/string160019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 12.291
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what was that"
    .incbin "include/sceneF/string160020.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 15.452
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, there's something i"
    .incbin "include/sceneF/string160021.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 16.761
      cut_subsOff
    
    SYNC_adpcmTime 5 $1240
    
    cut_waitForFrameMinSec 1 18.494
    cut_swapAndShowBuf
    
    ; "huh?"
    .incbin "include/sceneF/string160022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 22.114
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "are you still mad"
    .incbin "include/sceneF/string160023.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 23.550
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that's not it"
    .incbin "include/sceneF/string160024.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 27.085
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "as things stand"
    .incbin "include/sceneF/string160025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 29.278
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 2
    ;=====
    
    ; "what!? i knew it"
    .incbin "include/sceneF/string160026.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 33.170
      cut_subsOff
    
    SYNC_adpcmTime 6 $164C
    
    cut_waitForFrameMinSec 1 35.736
    cut_swapAndShowBuf
    
    ; "what's with the"
    .incbin "include/sceneF/string160027.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 38.702
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, the power of darkness"
    .incbin "include/sceneF/string160028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 41.702
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you probably won't even"
    .incbin "include/sceneF/string160029.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 47.047
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh!? oh no"
    .incbin "include/sceneF/string160030.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 49.851
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i mean, i took time off"
    .incbin "include/sceneF/string160031.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 52.485
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia closeup 2
    ;=====
    
    ; "yuna, in a corner of"
    .incbin "include/sceneF/string160032.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 58.017
      cut_subsOff
    
    SYNC_adpcmTime 7 $1BC2
    
    cut_waitForFrameMinSec 1 59.037
    cut_swapAndShowBuf
    
    ; "while i wasn't able"
    .incbin "include/sceneF/string160033.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 3.796
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it seems a clue to"
    .incbin "include/sceneF/string160034.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 6.736
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but in order to"
    .incbin "include/sceneF/string160035.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 12.820
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so where can i"
    .incbin "include/sceneF/string160036.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 16.347
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "all i know is that"
    .incbin "include/sceneF/string160037.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 20.230
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so if i have that"
    .incbin "include/sceneF/string160038.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 24.556
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "as to that...i don't know"
    .incbin "include/sceneF/string160039.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 30.385
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia front
    ;=====
    
    ; "i could not do it"
    .incbin "include/sceneF/string160040.bin"
    SCENE_prepAndSendGrpAuto

    ; turn down processing speed.
    ; we can't overshoot vblank with our subtitle processing here
    ; because it will prevent the game from evaluating scanline interrupts
    ; for the next frame, which normally just gets eaten up as a "lag" frame
    ; (i think -- i hope!!) but in this case interferes very visibly with
    ; the background, which is being cropped via line interrupts.
    ; we need to slow down here or it will flicker as the subtitles
    ; are being generated.
    ; this is the first point in the entire game where this has actually
    ; caused visible issues.
    ; if it turns out that these vblank overshoots work fine in the emulator
    ; but explode on real hardware, i will be very VERY upset.
    cut_writeMem maxScriptActionsPerIteration 1
    cut_writeMem maxSpriteAttrTransfersPerIteration 1
    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
      cut_waitForFrameMinSec 2 32.824
      cut_subsOff
    
    SYNC_adpcmTime 8 $23DC
    
    cut_waitForFrameMinSec 2 33.589
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but...you, yuna"
    .incbin "include/sceneF/string160041.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 35.977
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "if it's you, yuna"
    .incbin "include/sceneF/string160042.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 37.863
      cut_subsOff
    
    cut_waitForFrameMinSec 2 39.571
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 3
    ;=====
    
    ; "no way..."
    .incbin "include/sceneF/string160043.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 45.239
      cut_subsOff
    
    SYNC_adpcmTime 9 $2721
    
    cut_waitForFrameMinSec 2 47.568
    cut_swapAndShowBuf
    
    ; restore normal processing speed
    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
    cut_writeMem maxSpriteAttrTransfersPerIteration default_maxSpriteAttrTransfersPerIteration
    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration
    
    ; "all this stuff you say"
    .incbin "include/sceneF/string160044.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 49.284
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what are you saying!?"
    .incbin "include/sceneF/string160045.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 53.644
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you can do it, yuna"
    .incbin "include/sceneF/string160046.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 57.349
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no, but really"
    .incbin "include/sceneF/string160047.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 3.629
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, don't be"
    .incbin "include/sceneF/string160048.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 5.430
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ahh! ryudia, wait"
    .incbin "include/sceneF/string160049.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 8.982
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, please"
    .incbin "include/sceneF/string160050.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 11.982
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 4
    ;=====
    
    ; "she goes and says"
    .incbin "include/sceneF/string160051.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 16.061
      cut_subsOff
    
    SYNC_adpcmTime 10 $2E11
    
    cut_waitForFrameMinSec 3 17.123
    cut_swapAndShowBuf
    
    ; "when i think about"
    .incbin "include/sceneF/string160052.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 20.318
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i just feel so"
    .incbin "include/sceneF/string160053.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 25.442
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, you won't repeat"
    .incbin "include/sceneF/string160054.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 28.026
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so it'll all be fine"
    .incbin "include/sceneF/string160055.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 31.493
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but still..."
    .incbin "include/sceneF/string160056.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 33.124
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 5
    ;=====
    
    ; "erina, can you tell us"
    .incbin "include/sceneF/string160057.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 35.113
      cut_subsOff
    
    SYNC_adpcmTime 11 $3279
    
    cut_waitForFrameMinSec 3 35.903
    cut_swapAndShowBuf
    
    ; "wha? uh...hey"
    .incbin "include/sceneF/string160058.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 40.586
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "mmm...i think this"
    .incbin "include/sceneF/string160059.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 44.299
      cut_subsOff
    
    SYNC_adpcmTime 12 $34B3
    
    cut_waitForFrameMinSec 3 45.387
    cut_swapAndShowBuf
    
    ; "we're aligned with the"
    .incbin "include/sceneF/string160060.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 49.738
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "let's go, yuna"
    .incbin "include/sceneF/string160061.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 54.360
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm not feeling this"
    .incbin "include/sceneF/string160062.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 55.729
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay!"
    .incbin "include/sceneF/string160063.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 58.737
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 3 59.578
    cut_subsOff */
    
    cut_terminator
.ends





