
;==============================================================================
; scene 0F: leaving mariana after temple + message from ryudia
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

;.redefine maxScriptActionsPerIteration 1
;.redefine maxSpriteAttrTransfersPerIteration 1
;.redefine maxSpriteGrpTransfersPerIteration 1

.background "scene0F.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene0F_ovlScene.inc"
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
    
;    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $20
    
    ;=====
    ; cockpit 1
    ;=====
    
    ; "hey, elner"
    .incbin "include/sceneF/string160000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $01D3
    
    cut_waitForFrameMinSec 0 8.466
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what is it"
    .incbin "include/sceneF/string160001.bin"
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
    
      cut_waitForFrameMinSec 0 33.396+0.300
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
    
;    cut_waitForFrameMinSec 3 8.982
    cut_waitForFrameMinSec 3 9.925
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
    
      cut_waitForFrameMinSec 3 44.299+0.300
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
    
    cut_waitForFrameMinSec 3 59.578+0.300
    cut_subsOff
    
    ; "feel what"
/*    .incbin "include/scene10/string170001.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 5.187-0.100
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the sensation that"
    .incbin "include/scene10/string170002.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 6.276
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well,i dunno"
    .incbin "include/scene10/string170003.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 8.381
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "my body doesn't seem to"
    .incbin "include/scene10/string170004.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 10.282
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 0 13.589
    cut_waitForFrameMinSec 0 13.517
    cut_subsOff
    
    SYNC_adpcmTime 2 $038E
    
;    cut_writeVram panGrp_part1 $5E00+((panGrpPartSize*0)/2) panGrpPartSize
;    cut_writeVram panGrp_part2 $5E00+((panGrpPartSize*1)/2) panGrpPartSize
;    cut_writeVram panGrp_part3 $5E00+((panGrpPartSize*2)/2) panGrpPartSize
;    cut_writeVram panGrp_part4 $5E00+((panGrpPartSize*3)/2) panGrpPartSize
    
;    cut_waitForFrame $3F6
;    cut_waitForFrameMinSec 0 15.859
;    cut_swapAndShowBuf
    
    cut_writePalette $0070 panPalSize
      .incbin "out/pal/scene10_pan_line.pal" FSIZE panPalSize
    
    ; "ah"
    cut_waitForFrameMinSec 0 15.859
    cut_writeVram panMap170005 panTilemapDst panMap170005Size
    
    ; blank out the subtitles for a frame when switching lines
    ; to match the style of the regular sprite subtitles
    cut_waitForFrameMinSec 0 16.629-0.040
    cut_writeVram panMapBlank panTilemapDst panMapBlankSize
    ; "have you realized it"
    cut_waitForFrameMinSec 0 16.629
    cut_writeVram panMap170006 panTilemapDst panMap170006Size
    
;    ; "have you realized it"
;    .incbin "include/scene10/string170006.bin"
;;    SCENE_prepAndSendGrpAuto
;    cut_prepAndSendGrp $01DC
;    
;    cut_waitForFrameMinSec 0 16.629
;    cut_subsOff
;    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 0 17.780
;    cut_subsOff
    
    cut_waitForFrameMinSec 0 17.780
    cut_writeVram panMapBlank panTilemapDst panMapBlankSize
    ; "yeah, i think i understand"
    cut_waitForFrameMinSec 0 18.704
    cut_writeVram panMap170007 panTilemapDst panMap170007Size
    
    cut_waitForFrameMinSec 0 22.946-0.040
    cut_writeVram panMapBlank panTilemapDst panMapBlankSize
    ; "it's a... a"
    cut_waitForFrameMinSec 0 22.946
    cut_writeVram panMap170008 panTilemapDst panMap170008Size
    
    cut_waitForFrameMinSec 0 29.777-0.040
    cut_writeVram panMapBlank panTilemapDst panMapBlankSize
    ; "it's the same as when"
    cut_waitForFrameMinSec 0 29.777
    cut_writeVram panMap170009 panTilemapDst panMap170009Size
    
    cut_waitForFrameMinSec 0 33.988-0.040
    cut_writeVram panMapBlank panTilemapDst panMapBlankSize
    ; "yuna, one of your other"
    cut_waitForFrameMinSec 0 33.988
    cut_writeVram panMap170010 panTilemapDst panMap170010Size
    
    cut_waitForFrameMinSec 0 37.706
    cut_writeVram panMapBlank panTilemapDst panMapBlankSize
    
    ;=====
    ; erina appearance
    ;=====
    
    cut_waitForFrameMinSec 0 45.000
    
    ; "just like i thought"
    .incbin "include/scene10/string170011.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 4 $12EE
    
;    cut_waitForFrameMinSec 1 21.051
    cut_waitForFrameMinSec 1 22.253-0.100
    cut_swapAndShowBuf
    
    ; "erina"
    .incbin "include/scene10/string170012.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 1 23.444-0.200
      cut_subsOff
    
    SYNC_adpcmTime 5 $1592
    
    cut_waitForFrameMinSec 1 32.267
    cut_swapAndShowBuf
    
    ;=====
    ; erina meets elner
    ;=====
    
    ; NOTE: ~1BC area for subs is not available during this scene
    
    ; "thank goodness, erina"
    .incbin "include/scene10/string170013.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DE
    
      cut_waitForFrameMinSec 1 33.459-0.200
      cut_subsOff
      
      ; set sprite cropping scanline start num to original value
;      cut_writeMem $2047 $AF
    
    SYNC_adpcmTime 6 $170A
    
    cut_waitForFrameMinSec 1 39.026-0.100
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 1 41.984
;    cut_subsOff
    
    ; "now the light is complete"
    .incbin "include/scene10/string170014.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01ED
    
    cut_waitForFrameMinSec 1 42.477
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 1 44.018
;    cut_subsOff
    
    ; "oh, really?"
    .incbin "include/scene10/string170015.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DE
    
    cut_waitForFrameMinSec 1 44.398
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 46.637-0.200
    cut_subsOff
    
    ; "now then..."
    .incbin "include/scene10/string170016.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DE
    
;    cut_waitForFrameMinSec 1 47.140
    cut_waitForFrameMinSec 1 46.700
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 51.372
    cut_subsOff
    
    ;=====
    ; yuna introduction
    ;=====
    
    ; "oh, how do you do"
    .incbin "include/scene10/string170017.bin"
    cut_prepAndSendGrp $01DE
    
    SYNC_adpcmTime 7 $1A20
    
    cut_waitForFrameMinSec 1 52.173-0.100
    cut_swapAndShowBuf
    
    ; "i can be a bit"
    .incbin "include/scene10/string170018.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 55.511
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; erina introduction
    ;=====
    
    ; "come on"
    .incbin "include/scene10/string170019.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 1 58.511
      cut_subsOff
    
    SYNC_adpcmTime 8 $1CAB
    
    cut_waitForFrameMinSec 2 3.050
    cut_swapAndShowBuf
    
    ; "you don't go around"
    .incbin "include/scene10/string170020.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 7.056
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, erina may be able"
    .incbin "include/scene10/string170021.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 9.665
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "man, elner, you"
    .incbin "include/scene10/string170022.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 15.376
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you're a funny"
    .incbin "include/scene10/string170023.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 2 18.499
      cut_subsOff
    
    cut_waitForFrameMinSec 2 19.474
    cut_swapAndShowBuf
    
    ; "but still, i'm"
    .incbin "include/scene10/string170024.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 2 21.066
      cut_waitForFrameMinSec 2 20.964
      cut_subsOff
    
    SYNC_adpcmTime 9 $2111
    
    cut_waitForFrameMinSec 2 21.652-0.200
    cut_swapAndShowBuf
    
    ; "i agree"
    .incbin "include/scene10/string170025.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 26.346
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 2 27.168
;    cut_waitForFrameMinSec 2 27.346
    cut_waitForFrameMinSec 2 27.168
    cut_subsOff */
    
    cut_terminator
.ends





