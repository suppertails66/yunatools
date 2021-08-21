
;==============================================================================
; scene 0B: entering dark gate
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene0B.bin"

.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene0B_ovlScene.inc"
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
.orga $4057
.section "elner flight fix 1" overwrite
  ; starting line of lower-screen sprite crop
  ; (we want this to be below the subtitle display area)
  lda #$AF+$30
.ends */

;================================
; 
;================================

.bank 0 slot 0
.orga $47AF
.section "fix red alert 1" overwrite
  jsr fixRedAlert
.ends

.bank 0 slot 0
.section "fix red alert 2" free
  redAlertMap:
;    .incbin "out/maps/intro.bin" FSIZE introMapSize
    .incbin "out/maps/scene0B_patch.bin" FSIZE redAlertMapSize
  redAlertGrp:
;    .incbin "out/grp/intro.bin" FSIZE introGrpSize
    .incbin "out/grp/scene0B_patch.bin" FSIZE redAlertGrpSize
  redAlertPal:
    .incbin "out/pal/scene0B_patch_line.pal" FSIZE redAlertPalSize
  
  ; row 10
;  .define redAlertMapDst 10*64/2
  .define redAlertMapDst $300
  .define redAlertGrpDst $5200
;  .define introPalDst $60
  
  fixRedAlert:
    ; make up work (load resources)
    jsr $514E
    
    ; load new stuff
    ; i *think* this is safe without the irq off...?
    ; afaik no interrupt active at this point will attempt
    ; to write to the video registers
    jsr EX_IRQOFF
      ; graphics
      st0 #$00
      st1 #<redAlertGrpDst
      st2 #>redAlertGrpDst
      st0 #02
      tia redAlertGrp,$0002,redAlertGrpSize
      
      ; map
      st0 #$00
      st1 #<redAlertMapDst
      st2 #>redAlertMapDst
      st0 #02
      tia redAlertMap,$0002,redAlertMapSize
      
      ; palette
      lda #$70
      sta vce_ctaLo.w
      lda #$00
      sta vce_ctaHi.w
      tia redAlertPal,vce_ctwLo,redAlertPalSize
    jsr EX_IRQON
    
    rts
.ends

;==============================================================================
; script
;==============================================================================

.define subOffset 0

.bank 0 slot 0
.section "script 1" free
  ; script resources
/*  redAlertPatchGrp:
    .incbin "out/grp/scene0B_patch.bin" FSIZE redAlertPatchGrpSize
    .define redAlertPatchGrpPartSize (redAlertPatchGrpSize/4)
    .define redAlertPatchGrp_part1 redAlertPatchGrp+(redAlertPatchGrpPartSize*0)
    .define redAlertPatchGrp_part2 redAlertPatchGrp+(redAlertPatchGrpPartSize*1)
    .define redAlertPatchGrp_part3 redAlertPatchGrp+(redAlertPatchGrpPartSize*2)
    .define redAlertPatchGrp_part4 redAlertPatchGrp+(redAlertPatchGrpPartSize*3)
  redAlertPatchMap:
    .incbin "out/maps/scene0B_patch.bin" FSIZE redAlertPatchMapSize
;  redAlertUnpatchMap:
;    .define redAlertUnpatchMapSize $100
;    .rept redAlertUnpatchMapSize/2
;      .dw $F7ED
;    .endr */
  
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
    ; arrival
    ;=====
    
    ; "we're finally here"
    .incbin "include/sceneB/string120000.bin"
 ;   cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $011D
    
    cut_waitForFrameMinSec 0 5.417+subOffset
    cut_swapAndShowBuf
    
    ; "i think i'm getting the"
    .incbin "include/sceneB/string120001.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 7.955+subOffset
      cut_subsOff
    
;    cut_waitForFrameMinSec 0 7.955+subOffset
    cut_waitForFrameMinSec 0 9.065+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you're getting cold feet"
    .incbin "include/sceneB/string120002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 11.349+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so that door won't"
    .incbin "include/sceneB/string120003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 13.580+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, you've gotta be"
    .incbin "include/sceneB/string120004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 18.645+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what? you're making"
    .incbin "include/sceneB/string120005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 23.060+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "uh, marina"
    .incbin "include/sceneB/string120006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 27.304+0.100+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yeah, no kidding"
    .incbin "include/sceneB/string120007.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 31.493+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 32.595+subOffset
    cut_swapAndShowBuf
    
    ; "hmph. you guys are"
    .incbin "include/sceneB/string120008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 33.525+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, can you hear"
    .incbin "include/sceneB/string120009.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 35.935+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $087F
    
    cut_waitForFrameMinSec 0 36.694+subOffset
    cut_swapAndShowBuf
    
    ; "ah, it's ryudia"
    .incbin "include/sceneB/string120010.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 38.707+subOffset
      cut_subsOff
    
;    cut_waitForFrameMinSec 0 38.707+subOffset
    cut_waitForFrameMinSec 0 39.827+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia 1
    ;=====
    
    ; "the power of darkness"
    .incbin "include/sceneB/string120011.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 40.721+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 4 $09C5
    
    cut_waitForFrameMinSec 0 42.355+subOffset
    cut_swapAndShowBuf
    
    ; "i sense that"
    .incbin "include/sceneB/string120012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 45.705+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "if you don't take"
    .incbin "include/sceneB/string120013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 50.653+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what? but what"
    .incbin "include/sceneB/string120014.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 53.930+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia 2
    ;=====
    
    ; "yuna, i shall lend"
    .incbin "include/sceneB/string120015.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 59.853+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 5 $0E4A
    
    cut_waitForFrameMinSec 1 1.623+subOffset
    cut_swapAndShowBuf
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
    cut_writeMem maxScriptActionsPerIteration 1
    cut_writeMem maxSpriteAttrTransfersPerIteration 1
    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    ; "huh? how will"
    .incbin "include/sceneB/string120016.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 6.092+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i will send you"
    .incbin "include/sceneB/string120017.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 8.214+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "if you and i"
    .incbin "include/sceneB/string120018.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 11.744+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "recite the incantation"
    .incbin "include/sceneB/string120019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 17.116+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "got it"
    .incbin "include/sceneB/string120020.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 19.374+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; pre-chant
    ;=====
    
    ; "me and ryudia are"
    .incbin "include/sceneB/string120021.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 1 20.186+subOffset
      cut_waitForFrameMinSec 1 20.374+subOffset
      cut_subsOff
    
    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
    cut_writeMem maxSpriteAttrTransfersPerIteration default_maxSpriteAttrTransfersPerIteration
    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration
    
    SYNC_adpcmTime 6 $1390
    
    cut_waitForFrameMinSec 1 24.096+subOffset
    cut_swapAndShowBuf
    
    ; "everyone join in"
    .incbin "include/sceneB/string120022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 27.626+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay"
    .incbin "include/sceneB/string120023.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 29.333+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "are you ready"
    .incbin "include/sceneB/string120024.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 30.245+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ready for anything"
    .incbin "include/sceneB/string120025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 31.698+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; chant 1
    ;=====
    
    ; "gate, gate"
    .incbin "include/sceneB/string120026.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 33.287+0.300+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 1 34.457+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "if mine appeal"
    .incbin "include/sceneB/string120027.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 39.030+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thy frozen maw"
    .incbin "include/sceneB/string120028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 41.210+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thy frosty"
    .incbin "include/sceneB/string120068.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 43.815+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; chant 2
    ;=====
    
    ; "my voice is"
    .incbin "include/sceneB/string120029.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 47.824+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 7 $1954
    
    cut_waitForFrameMinSec 1 48.745+subOffset
    cut_swapAndShowBuf
    
    ; "my gaze the"
    .incbin "include/sceneB/string120030.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 51.575+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "beneath my fingers"
    .incbin "include/sceneB/string120031.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 54.704+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "shall supply shiver"
    .incbin "include/sceneB/string120032.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 57.607+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; chant 3
    ;=====
    
    ; "door, door, within thy"
    .incbin "include/sceneB/string120033.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 1.078+subOffset
      cut_subsOff
    
    ; i thought the subtitles were making this scene lag,
    ; but apparently it's doing that on its own...
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    SYNC_adpcmTime 8 $1C7A
    
    cut_waitForFrameMinSec 2 2.171+subOffset
    cut_swapAndShowBuf
    
    ; "and turn again"
    .incbin "include/sceneB/string120034.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 6.654+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "door, door, if this"
    .incbin "include/sceneB/string120035.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 9.530+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "unseal for me"
    .incbin "include/sceneB/string120036.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 13.841+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; chant end
    ;=====
    
    ; "door! open"
    .incbin "include/sceneB/string120037.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 18.525+subOffset
      cut_subsOff
    
;    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
;    cut_writeMem maxSpriteAttrTransfersPerIteration ;default_maxSpriteAttrTransfersPerIteration
;    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration
    
    SYNC_adpcmTime 9 $2085
    
    cut_waitForFrameMinSec 2 19.186+subOffset
    cut_swapAndShowBuf
    
    ;=====
    ; door opened
    ;=====
    
    ; "it's open"
    .incbin "include/sceneB/string120038.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 23.154-0.750+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $B $23E7
    
;    cut_waitForFrameMinSec 2 35.912+subOffset
    cut_waitForFrameMinSec 2 36.842+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "great work, yuna"
    .incbin "include/sceneB/string120039.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 37.601+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i didn't think it was"
    .incbin "include/sceneB/string120040.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 39.172+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay, guys"
    .incbin "include/sceneB/string120041.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 41.546+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $C $25F9
    
    cut_waitForFrameMinSec 2 42.449+subOffset
    cut_swapAndShowBuf
    
    ; "okay"
    .incbin "include/sceneB/string120042.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 44.995+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 2 45.727+0.300+subOffset
    cut_subsOff
    
    ;=====
    ; takeoff
    ;=====
    
;    SYNC_adpcmTime $D $274B
    
    SYNC_adpcmTime $E $28AB
    cut_waitForFrameMinSec 2 55.000+subOffset
    
    ; "be careful, yuna"
    .incbin "include/sceneB/string120043.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime $F $2A3F
    
    cut_waitForFrameMinSec 3 0.977+subOffset
    cut_swapAndShowBuf
    
    ; "i pray for your"
    .incbin "include/sceneB/string120044.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 3.505+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thank you"
    .incbin "include/sceneB/string120045.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 5.744+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "we're crossing through"
    .incbin "include/sceneB/string120046.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 6.864+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay"
    .incbin "include/sceneB/string120047.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 8.651+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ryudia 3
    ;=====
    
    ; "yuna...i suppose you"
    .incbin "include/sceneB/string120048.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 9.292+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $10 $2CB5
    
    cut_waitForFrameMinSec 3 11.495+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the universe is"
    .incbin "include/sceneB/string120049.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 16.218-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "do all you can"
    .incbin "include/sceneB/string120050.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 19.748-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; entering gate
    ;=====
    
    ; "huh? what's going on"
    .incbin "include/sceneB/string120051.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 22.249+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $11 $316E
    
    cut_waitForFrameMinSec 3 31.350+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; throttle subtitle processing speed
    cut_writeMem maxScriptActionsPerIteration 1
    cut_writeMem maxSpriteAttrTransfersPerIteration 1
    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    ; "what happened"
/*    .incbin "include/sceneB/string120052.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 34.095+subOffset
    cut_subsOff
    cut_swapAndShowBuf */
    
    ;=====
    ; red alert!!
    ;=====
    
    ; "yuna, the whole"
;    cut_queueSubsOffMinSec 3 35.016+subOffset
    .incbin "include/sceneB/string120053.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 35.016-0.200+subOffset
      cut_subsOff
    
    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
    cut_writeMem maxSpriteAttrTransfersPerIteration default_maxSpriteAttrTransfersPerIteration
    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration
    
    SYNC_adpcmTime $12 $326C
      
    ; palette
/*    cut_writePalette $0070 redAlertPatchPalSize
      .incbin "out/pal/scene0B_patch_line.pal" FSIZE redAlertPatchPalSize
      
    ; graphics
    cut_writeVram redAlertPatchGrp_part1 $5200+((redAlertPatchGrpPartSize*0)/2) redAlertPatchGrpPartSize
    cut_writeVram redAlertPatchGrp_part2 $5200+((redAlertPatchGrpPartSize*1)/2) redAlertPatchGrpPartSize
    cut_writeVram redAlertPatchGrp_part3 $5200+((redAlertPatchGrpPartSize*2)/2) redAlertPatchGrpPartSize
    cut_writeVram redAlertPatchGrp_part4 $5200+((redAlertPatchGrpPartSize*3)/2) redAlertPatchGrpPartSize
    
    ; transfer bg map
;    cut_waitForFrame $3028
    cut_writeVram redAlertPatchMap $0300 redAlertPatchMapSize */
    
    cut_waitForFrameMinSec 3 35.892-0.150+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but the gauges"
    .incbin "include/sceneB/string120054.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 39.413-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ahh! any more of this"
    .incbin "include/sceneB/string120055.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 41.417+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what!? what are we"
    .incbin "include/sceneB/string120056.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 44.316+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; red alert!! 2
    ;=====
    
    ; "hey! hey! what are we"
    .incbin "include/sceneB/string120057.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 3 46.618+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $13 $3528
    
    cut_waitForFrameMinSec 3 47.548+subOffset
    cut_swapAndShowBuf
    
    ; "think of something"
    .incbin "include/sceneB/string120058.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 49.498+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "don't tell me that"
    .incbin "include/sceneB/string120059.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 51.322+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, it's really weird"
    .incbin "include/sceneB/string120060.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 53.543-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "don't tell me that"
    .incbin "include/sceneB/string120061.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 57.019+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, you should"
    .incbin "include/sceneB/string120062.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 3 59.159+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the worst-case"
    .incbin "include/sceneB/string120063.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 4 1.570+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "nooo! i'm scared"
    .incbin "include/sceneB/string120064.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 4 4.234+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ahh! the cruiser's"
    .incbin "include/sceneB/string120065.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 4 7.628+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $14 $3A66
    
;    cut_waitForFrameMinSec 4 9.543+subOffset
    cut_waitForFrameMinSec 4 10.220+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wha--!?"
    .incbin "include/sceneB/string120066.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 4 11.637+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 4 12.197+subOffset
    cut_subsOff
    
    ; "hey, you're not hurt"
/*    .incbin "include/sceneC/string130001.bin"
    cut_prepAndSendGrp $01BC+16
    
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
    .incbin "include/sceneC/string130038.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 56.367+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
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
    
;    cut_waitForFrameMinSec 0 20.000+subOffset */
    
    cut_terminator
.ends





