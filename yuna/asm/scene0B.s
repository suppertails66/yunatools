
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
    
;    SYNC_adpcmTime 1 $0092
    SYNC_adpcmTime 2 $0143
    
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
    
    cut_waitForFrameMinSec 0 27.304-0.050+subOffset
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
    
    SYNC_adpcmTime 3 $0897
    
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
    
    SYNC_adpcmTime 4 $09EB
    
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
    
    SYNC_adpcmTime 5 $0E70
    
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
    
    SYNC_adpcmTime 6 $13B6
    
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
    
    SYNC_adpcmTime 7 $197A
    
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
    
    SYNC_adpcmTime 8 $1CA0
    
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
    
    SYNC_adpcmTime 9 $209D
    
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
    
;    SYNC_adpcmTime $A $21C5
    SYNC_adpcmTime $B $240D
    
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
    
    SYNC_adpcmTime $C $260D
    
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
    
;    SYNC_adpcmTime $D $2766
    
    SYNC_adpcmTime $E $28BD
    cut_waitForFrameMinSec 2 55.000+subOffset
    
    ; "be careful, yuna"
    .incbin "include/sceneB/string120043.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime $F $2A65
    
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
    
;    SYNC_adpcmTime $10 $2CE3
    SYNC_adpcmTime $10 $2CDB
    
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
    
;    SYNC_adpcmTime $11 $318E
    SYNC_adpcmTime $11 $3183
    
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
    
;    SYNC_adpcmTime $12 $329D
    SYNC_adpcmTime $12 $3292
      
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
    
;    SYNC_adpcmTime $13 $3558
    SYNC_adpcmTime $13 $354E
    
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
    
;    SYNC_adpcmTime $14 $3A86
    SYNC_adpcmTime $14 $3A77
    
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
    
    cut_terminator
.ends





