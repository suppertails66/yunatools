
;==============================================================================
; scene 0C: asteroid explosion + aftermath
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene0C.bin"

.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene0C_ovlScene.inc"
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

.bank 0 slot 0
.orga $4057
.section "elner flight fix 1" overwrite
  ; starting line of lower-screen sprite crop
  ; (we want this to be below the subtitle display area)
  lda #$AF+$30
.ends

;==============================================================================
; script
;==============================================================================

.define subOffset 0

.bank 0 slot 0
.section "script 1" free
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    cut_waitForFrame $40
    
    ;=====
    ; yuna + lia conversation
    ;=====
    
    ; "lia, are you okay"
    .incbin "include/sceneC/string130000.bin"
    cut_prepAndSendGrp $01DC+16
    
    SYNC_adpcmTime 1 $0084
    
;    cut_waitForFrameMinSec 0 2.883+subOffset
    cut_waitForFrameMinSec 0 4.401+subOffset
    cut_swapAndShowBuf
    
    ; "hey, you're not hurt"
    .incbin "include/sceneC/string130001.bin"
    cut_prepAndSendGrp $01BC+16
      
;      cut_waitForFrameMinSec 0 6.959+0.300+subOffset
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 8.185+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna?"
    .incbin "include/sceneC/string130002.bin"
    cut_prepAndSendGrp $01DC+16
    
;      cut_waitForFrameMinSec 0 13.558+subOffset
      cut_waitForFrameMinSec 0 12.821+0.300+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 14.755+subOffset
    cut_swapAndShowBuf
    
    ; "don't worry"
    .incbin "include/sceneC/string130003.bin"
    cut_prepAndSendGrp $01BC+16
    
    SYNC_adpcmTime 2 $03B6
    
    cut_waitForFrameMinSec 0 16.509+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "looks like i've"
    .incbin "include/sceneC/string130004.bin"
    cut_prepAndSendGrp $0090
    
      cut_waitForFrameMinSec 0 20.602+subOffset
      cut_subsOff
    
    ; turn off sprite enable forcing -- sprites are already on
    ; when we need them to be, and we have to preserve sprite cropping
    ; for the part where elner flies in
;    cut_writeMem subtitleSpriteForcingOn $00
    ; clear "sprites on" flag, which was previously forced on
    ; by the subtitles, to allow animation of elner flying in
    ; to be correctly cropped
    cut_andOr $20F3 $BF $00
    
    cut_waitForFrameMinSec 0 22.346+subOffset
    cut_swapAndShowBuf
    
;    cut_writeMem subtitleSpriteForcingOn $FF
    
    ; "no, no"
    .incbin "include/sceneC/string130005.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 24.744+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but i'm a"
    .incbin "include/sceneC/string130006.bin"
    cut_prepAndSendGrp $0090
    
    cut_waitForFrameMinSec 0 28.552+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's fine, it's fine"
    .incbin "include/sceneC/string130007.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 32.141+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "after all, you've been"
    .incbin "include/sceneC/string130008.bin"
    cut_prepAndSendGrp $0090
    
    cut_waitForFrameMinSec 0 33.965+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's fine, it's fine"
    .incbin "include/sceneC/string130009.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 38.870+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "after all, you've been"
    .incbin "include/sceneC/string130010.bin"
    cut_prepAndSendGrp $0090
    
      cut_waitForFrameMinSec 0 42.848+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 44.094+subOffset
    cut_swapAndShowBuf
    
    ; "we're friends"
    .incbin "include/sceneC/string130011.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 50.614+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i don't think we"
    .incbin "include/sceneC/string130012.bin"
    cut_prepAndSendGrp $0090
    
    cut_waitForFrameMinSec 0 52.498+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "friends"
    .incbin "include/sceneC/string130013.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 54.442+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 55.629+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_andOr $20F3 $BF $00
    
    cut_waitForFrameMinSec 0 56.735-0.100+subOffset
    cut_subsOff
    
    ;=====
    ; dark queen transmission
    ;=====
    
    ; "lia, enough"
    .incbin "include/sceneC/string130014.bin"
    cut_prepAndSendGrp $01BC
    
    SYNC_adpcmTime 3 $0D4F
    
    cut_waitForFrameMinSec 0 57.323+subOffset
    cut_swapAndShowBuf
    
    ; "return to me"
    .incbin "include/sceneC/string130015.bin"
    cut_prepAndSendGrp $01CC
    
    cut_waitForFrameMinSec 1 0.324+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia disappears
    ;=====
    
    ; "huh? lia, what's wrong"
    .incbin "include/sceneC/string130016.bin"
    cut_prepAndSendGrp $01DC+16
    
      cut_waitForFrameMinSec 1 2.179+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 4 $0F4D
    
    cut_waitForFrameMinSec 1 5.668+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna"
    .incbin "include/sceneC/string130017.bin"
    cut_prepAndSendGrp $01DC+28
    
    cut_waitForFrameMinSec 1 8.888+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 9.626+subOffset
    cut_subsOff
    
    ;=====
    ; earthquake
    ;=====
    
    ; wait until the earthquake scene gets going to send new stuff
;    cut_waitForFrameMinSec 1 21.000+subOffset
    ; this is the adpcm trigger for the earthquake sound effect,
    ; whose timestamp i didn't write down since it wasn't a voice clip...
    SYNC_adpcmTime 5 $0
    
    ; "hey! what should we do"
    .incbin "include/sceneC/string130018.bin"
    cut_prepAndSendGrp $01BC
    
    SYNC_adpcmTime 6 $13B5
    
    cut_waitForFrameMinSec 1 24.600+subOffset
    cut_swapAndShowBuf
    
    ; "i don't know, but"
    .incbin "include/sceneC/string130019.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 27.680+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 29.973+subOffset
    cut_subsOff
    
    ;=====
    ; yuna wakes up
    ;=====
    
    ; we seem to be accumulating error somehow or another...
    .redefine subOffset -0.100
    
    ; some wordless vocalizations whose timestamp i didn't write down
    SYNC_adpcmTime 9 $0
    
    ; "thank goodness"
    .incbin "include/sceneC/string130020.bin"
;    cut_prepAndSendGrp $01BC
    ; we can use the autosend macro for most of the rest of this scene.
    ; only the pan up the robots near the end uses sprites beyond $1BC.
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime $A $18AE
    
    cut_waitForFrameMinSec 1 45.924+subOffset
    cut_swapAndShowBuf
    
    ; "you had us worried"
    .incbin "include/sceneC/string130021.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 49.124+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what a troublemaker"
    .incbin "include/sceneC/string130022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 50.530+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "guys"
    .incbin "include/sceneC/string130023.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 52.175+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $B $1A4F
    
    cut_waitForFrameMinSec 1 54.607+subOffset
    cut_swapAndShowBuf
    
    ; "hm? where's elner"
    .incbin "include/sceneC/string130024.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 55.415+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $C $1C41
    
    .redefine subOffset -0.200
    
    cut_waitForFrameMinSec 2 1.356+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "elner isn't here"
    .incbin "include/sceneC/string130025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 4.188+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?"
    .incbin "include/sceneC/string130026.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 5.872+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "then, where...?"
    .incbin "include/sceneC/string130027.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 2 55.415+subOffset
;      cut_subsOff
    
    cut_waitForFrameMinSec 2 7.886+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "elner...isn't coming"
    .incbin "include/sceneC/string130028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 9.910+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no...!"
    .incbin "include/sceneC/string130029.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime $D $1F2D
    
    cut_waitForFrameMinSec 2 13.359+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey...don't lie"
    .incbin "include/sceneC/string130030.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 14.366+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $E $202B
    
    cut_waitForFrameMinSec 2 18.055+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "see, the asteroid"
    .incbin "include/sceneC/string130031.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 21.504+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "then...elner is..."
    .incbin "include/sceneC/string130032.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 30.905+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey...what are we"
    .incbin "include/sceneC/string130033.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 33.707+0.300+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 2 35.481+subOffset
    cut_swapAndShowBuf
    
    ; "without elner"
    .incbin "include/sceneC/string130034.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 40.466+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "we should keep fighting"
    .incbin "include/sceneC/string130035.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 43.975+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $F $2679
    
    cut_waitForFrameMinSec 2 44.952+subOffset
    cut_swapAndShowBuf
    
    ; "but with elner gone"
    .incbin "include/sceneC/string130036.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 48.730+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "even yuna won't be able"
    .incbin "include/sceneC/string130037.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 53.346+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "we can't win"
/*    .incbin "include/sceneC/string130038.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 56.367+subOffset
    cut_subsOff
    cut_swapAndShowBuf */
    
    ; "we're not talking"
    .incbin "include/sceneC/string130039.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 57.753+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey, are you"
    .incbin "include/sceneC/string130040.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 2.438+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's not that"
    .incbin "include/sceneC/string130041.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 4.492+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $10 $2B3C
    
    cut_waitForFrameMinSec 3 5.967+subOffset
    cut_swapAndShowBuf
    
    ; "that's right"
    .incbin "include/sceneC/string130042.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 11.082+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "as the one with"
    .incbin "include/sceneC/string130043.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 13.105+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna resolves
    ;=====
    
    ; "alright, let's go"
    .incbin "include/sceneC/string130044.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 17.233+0.300+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 3 19.007+subOffset
    cut_swapAndShowBuf
    
    ; "go where"
    .incbin "include/sceneC/string130045.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 22.287+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, c'mon, now"
    .incbin "include/sceneC/string130046.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 23.384+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; robots doubt
    ;=====
    
    ; "yuna, you really shouldn't"
    .incbin "include/sceneC/string130047.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 26.768+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $11 $30BE
    
    cut_waitForFrameMinSec 3 28.787+subOffset
    cut_swapAndShowBuf
    
    ; "what are we supposed to do"
    .incbin "include/sceneC/string130048.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 32.745+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "with elner gone"
    .incbin "include/sceneC/string130049.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 34.794+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but sitting around's not"
    .incbin "include/sceneC/string130050.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 37.794+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $12 $3338
    
    cut_waitForFrameMinSec 3 39.320+subOffset
    cut_swapAndShowBuf
    
    ; "if we keep on like this"
    .incbin "include/sceneC/string130051.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 43.372+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; robots believe
    ;=====
    
    ; "she's just full of"
    .incbin "include/sceneC/string130052.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 46.562+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $13 $3549
    
    cut_waitForFrameMinSec 3 48.925+subOffset
    cut_swapAndShowBuf
    
    ; "after all this"
    .incbin "include/sceneC/string130053.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 51.412+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "alright, i give"
    .incbin "include/sceneC/string130054.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 56.073+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yup yup yup"
    .incbin "include/sceneC/string130055.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 58.984+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "right. elner would want"
    .incbin "include/sceneC/string130056.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 4 3.530+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; arle... i mean, yuna thanks everyone while crying tears of happiness
    ;=====
    
    ; "thanks, everyone"
    .incbin "include/sceneC/string130057.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 4 7.752+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $14 $3B1C
    
    cut_waitForFrameMinSec 4 12.702+subOffset
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 4 15.179+0.300+subOffset
    cut_subsOff
    
    ;=====
    ; robots final
    ;=====
    
    ; "but yuna"
    .incbin "include/sceneC/string130058.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime $15 $3C95
    
    cut_waitForFrameMinSec 4 19.371+subOffset
    cut_swapAndShowBuf
    
    ; "y'know, i think we're"
    .incbin "include/sceneC/string130059.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 4 25.921+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "let's go, yuna"
    .incbin "include/sceneC/string130060.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 4 30.088+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay"
    .incbin "include/sceneC/string130061.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 4 32.870+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $16 $3FF8
    
    cut_waitForFrameMinSec 4 33.358+subOffset
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 4 34.358+subOffset
    cut_subsOff
    
    ; clear "sprites on" flag, which was previously forced on
    ; by the subtitles, to allow animation of elner flying in
    ; to be correctly cropped
;    cut_andOr $20F3 $BF $00
    
    ; re-enable sprite forcing
;    cut_writeMem subtitleSpriteForcingOn $FF
    
    ; game needs almost all of vram for the laser sequence,
    ; so idle here until it's done...
    
;    cut_waitForFrameMinSec 0 20.000+subOffset
    
    cut_terminator
.ends





