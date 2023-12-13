
;==============================================================================
; scene 16: lia death
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene16.bin"

.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene16_ovlScene.inc"
.define enable_sceneAutoBusySkip 1
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

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
    ; lia death 1
    ;=====
    
    ; "lia"
    .incbin "include/scene16/string230000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $00A9
    
    cut_waitForFrameMinSec 0 2.868+subOffset
    cut_swapAndShowBuf
    
    ; "yuna"
    .incbin "include/scene16/string230001.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 3.688+0.683+subOffset
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 4.961+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no one can beat her"
    .incbin "include/scene16/string230002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 6.725+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "because i `1am darkness"
    .incbin "include/scene16/string230003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.982+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'll never be able"
    .incbin "include/scene16/string230004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 14.981+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "then you shouldn't have"
    .incbin "include/scene16/string230005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 17.500+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but since she's the one"
    .incbin "include/scene16/string230006.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 20.505+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 21.869+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i despise her"
    .incbin "include/scene16/string230007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 28.144+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 1
    ;=====

;    .redefine subOffset -0.050
    
    ; "um..."
    .incbin "include/scene16/string230008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 30.039+0.800+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 2 $078C
    
    cut_waitForFrameMinSec 0 32.219+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "lia, i have your"
    .incbin "include/scene16/string230010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 36.199+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "could it be that"
    .incbin "include/scene16/string230011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 41.252+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you gave them to me"
    .incbin "include/scene16/string230012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 44.879+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia closeup
    ;=====
    
    ; "that was because"
    .incbin "include/scene16/string230013.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 47.056+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $0B3B
    
    cut_waitForFrameMinSec 0 49.431+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i hated the idea of"
    .incbin "include/scene16/string230014.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 51.323+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna..."
    .incbin "include/scene16/string230015.bin"
    SCENE_prepAndSendGrpAuto
     
      cut_waitForFrameMinSec 0 58.866+0.500+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 1 1.679+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "beat her"
    .incbin "include/scene16/string230016.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 3.649+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i beg you"
    .incbin "include/scene16/string230017.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 5.505+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "a true fraulein is"
    .incbin "include/scene16/string230018.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 8.034+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "show her"
    .incbin "include/scene16/string230019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 12.827+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "please"
    .incbin "include/scene16/string230020.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 14.275+0.400+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 1 16.444+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "lia"
;    .incbin "include/scene16/string230021.bin"
;    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 17.134+1.000+subOffset
      cut_subsOff
    
    ;=====
    ; yuna closeup 2
    ;=====

    ; we need to flip auto-subtitle vram send parity
    ; so this line goes to 1DC (as 1BC is currently used)
    .redefine SCENE_autoPlaceParity 1
    
    ; "lia"
    .incbin "include/scene16/string230021.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 5 $13E8
    
    cut_waitForFrameMinSec 1 26.274+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; dark queen 1
    ;=====
    
    ; "yuna..."
    .incbin "include/scene16/string230023.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 27.653+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 6 $1576
    
    cut_waitForFrameMinSec 1 31.579+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "lia is no more"
    .incbin "include/scene16/string230024.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 33.685+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now, come to me"
    .incbin "include/scene16/string230025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 35.975+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "do so, and"
    .incbin "include/scene16/string230026.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 40.370+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna closeup 3
    ;=====
    
    ; "okay! i'm with you"
    .incbin "include/scene16/string230027.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 47.156+0.100+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 7 $1953
    
    cut_waitForFrameMinSec 1 48.066+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you think i'm gonna"
    .incbin "include/scene16/string230028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 51.352+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no way"
    .incbin "include/scene16/string230029.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 53.777+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no how"
    .incbin "include/scene16/string230030.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 55.193+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "never"
    .incbin "include/scene16/string230031.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 56.437+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; dark queen disappears
    ;=====
    
    ; "so you mean to"
    .incbin "include/scene16/string230032.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 57.262+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 9 $1FC2
    
    cut_waitForFrameMinSec 2 15.577+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 2 18.137+0.300+subOffset
    cut_subsOff
    
    ;=====
    ; yuna planet
    ;=====
    
    ; "huh? what happened"
    .incbin "include/scene16/string230034.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01E0
    
    SYNC_adpcmTime $A $21CE
    
    cut_waitForFrameMinSec 2 24.339+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna!"
    .incbin "include/scene16/string230035.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01E8
    
      cut_waitForFrameMinSec 2 27.639-0.200+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 2 29.332+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "guys"
    .incbin "include/scene16/string230036.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01E0
    
      cut_waitForFrameMinSec 2 30.733+0.300+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 2 33.258+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 2 34.076+0.300+subOffset
    cut_subsOff
    
    ;=====
    ; reunion
    ;=====
    
    ; "hey, are you okay"
    .incbin "include/scene16/string230037.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01E0
    
      cut_waitForFrameMinSec 2 34.076+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $B $2516
    
    cut_waitForFrameMinSec 2 38.336-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf

    ; force auto-parity to place at 1BC
    .redefine SCENE_autoPlaceParity 0
    
    ; "that's my line"
    .incbin "include/scene16/string230038.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 40.968+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yeah, i'm great!"
    .incbin "include/scene16/string230039.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 42.675+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; reunion 2
    ;=====
    
    ; "alright! we beat"
    .incbin "include/scene16/string230040.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 44.261+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $C $275F
    
    cut_waitForFrameMinSec 2 48.080+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you sure about"
    .incbin "include/scene16/string230041.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 51.829-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what's the darkness"
    .incbin "include/scene16/string230042.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 53.464+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; earthquake
    ;=====
    
    ; "what's that!?"
    .incbin "include/scene16/string230043.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 56.125+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $D $2A03
    
    ; game needs a bunch of sprites for the rock flying animation
    cut_setHighPrioritySprObjOffset 8
    
    cut_waitForFrameMinSec 3 1.999+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna... that's the true form"
    .incbin "include/scene16/string230044.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 2.999+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $E $2B23
    
    cut_waitForFrameMinSec 3 5.221-0.125+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna..."
    .incbin "include/scene16/string230045.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 9.638+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; gattai time
    ;=====
    
    ; "yuna... let's fuse"
    .incbin "include/scene16/string230046.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 12.945+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $F $2D64
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrameMinSec 3 13.792+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?...r-right"
    .incbin "include/scene16/string230047.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 15.719+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "let's go"
    .incbin "include/scene16/string230048.bin"
    SCENE_prepAndSendGrpAuto
    
;    cut_waitForFrameMinSec 3 16.708+subOffset
;    cut_subsOff
;    cut_swapAndShowBuf   
    cut_waitForFrameMinSec 3 18.315-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now, o light"
    .incbin "include/scene16/string230049.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 18.721+0.600+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 3 20.677+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "to me"
    .incbin "include/scene16/string230050.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 22.846+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 3 23.991+0.100+subOffset
    cut_subsOff
    
;    cut_waitForFrameMinSec 1 26.629+subOffset
;    cut_subsOff
;    cut_swapAndShowBuf
    
    ; note: 1E0 after dark queen disappears
    
    cut_terminator
.ends





