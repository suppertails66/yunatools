
;==============================================================================
; scene 1B: ending
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene1B.bin"

.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene1B_ovlScene.inc"
;.define enable_sceneAutoBusySkip 1
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

/*;================================
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
.ends */

;================================
; fix cropping of yuna corridor scene
;================================

.bank 0 slot 0
.orga $451E
.section "yuna corridor fix 1" overwrite
  jsr fixYunaCorridor
.ends

.define yunaCorridorFixCropSpace 16

.bank 0 slot 0
.section "yuna corridor fix 2" free
  fixYunaCorridor:
    ; make up work (install lower sprite crop handler)
    jsr $79DC
    
    ; install our own cropping handler to make sure sprites are turned
    ; back on for subtitles
    ; line num
    lda #$AF+yunaCorridorFixCropSpace
    sta $46+(4*1)+0
    ; jump target (this is an existing handler)
    lda #$B1
    sta $267F+(4*2)+0.w
    lda #$4C
    sta $267F+(4*2)+1.w
    ; enable
    smb4 $44
    
    ; and turn sprites back off after subtitles so they'll be off
    ; at the start of the next frame
    ; linenum
    lda #$AF+yunaCorridorFixCropSpace+32
    sta $46+(5*1)+0
    ; jump target (this is an existing handler)
    lda #$C0
    sta $267F+(5*2)+0.w
    lda #$4C
    sta $267F+(5*2)+1.w
    ; enable
    smb5 $44
    
    rts
.ends

; no need to turn off handlers manually --
; game automatically clear all of them at end of scene

/*.bank 0 slot 0
;.orga $4202
.orga $427B
.section "yuna corridor fix 3" overwrite
  jsr fixElnerFlight2
.ends

.bank 0 slot 0
.section "yuna corridor fix 4" free
  fixElnerFlight2:
    ; disable our extra sprite uncropping handlers
    rmb4 $44
    rmb5 $44
    
    ; make up work (idle)
    jmp $6D81
  
;  fixElnerFlight_cropHandler:
;    
;    rts
.ends */

;==============================================================================
; script
;==============================================================================

.define subOffset -0.300

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
/*  yunaHeadTurnSprites:
    .incbin "rsrc_raw/grp/scene02_headturn_sprites.bin" FSIZE yunaHeadTurnSpritesSize
    .define yunaHeadTurnSpritesPartSize (yunaHeadTurnSpritesSize/4)
    .define yunaHeadTurnSprites_part1 yunaHeadTurnSprites+(yunaHeadTurnSpritesPartSize*0)
    .define yunaHeadTurnSprites_part2 yunaHeadTurnSprites+(yunaHeadTurnSpritesPartSize*1)
    .define yunaHeadTurnSprites_part3 yunaHeadTurnSprites+(yunaHeadTurnSpritesPartSize*2)
    .define yunaHeadTurnSprites_part4 yunaHeadTurnSprites+(yunaHeadTurnSpritesPartSize*3) */
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ; don't set this initially -- airport panning scene relies on these slots
;    cut_setHighPrioritySprObjOffset 16
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    cut_waitForFrame $40
    
    ;=====
    ; yuna
    ;=====
    
    ; "are you really"
    .incbin "include/scene1B/string280000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $01CE
    
    ; this is now safe to turn on
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrameMinSec 0 8.383+subOffset
    cut_swapAndShowBuf
    
    ; "yes"
    .incbin "include/scene1B/string280001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.658-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; el-line
    ;=====
    
    ; "we've checked the"
    .incbin "include/scene1B/string280002.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 11.551-0.150+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 2 $02AC
    
    cut_waitForFrameMinSec 0 12.384+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "however"
    .incbin "include/scene1B/string280003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.433+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "we must wait until"
    .incbin "include/scene1B/string280004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 19.612+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna
    ;=====
    
    ; "can't we do it"
    .incbin "include/scene1B/string280005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 24.423+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $05B4
    
    cut_waitForFrameMinSec 0 25.316+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "if you did that"
    .incbin "include/scene1B/string280006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 28.936+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but"
    .incbin "include/scene1B/string280007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 34.593+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; el-line
    ;=====
    
    ; "don't worry"
    .incbin "include/scene1B/string280008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 35.498+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 4 $0851
    
    cut_waitForFrameMinSec 0 36.426+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna
    ;=====
    
    ; "we'll definitely"
    .incbin "include/scene1B/string280009.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 41.059+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 5 $0AC1
    
    cut_waitForFrameMinSec 1 3.148+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; robots
    ;=====
    
    ; "it's been fun"
    .incbin "include/scene1B/string280010.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 6.351+0.450+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 6 $0FA4
    
    cut_waitForFrameMinSec 1 7.709+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm sure we'll be able"
    .incbin "include/scene1B/string280011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 12.353+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hang in there"
    .incbin "include/scene1B/string280012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 15.091+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; el-line
    ;=====
    
    ; "well then, yuna"
    .incbin "include/scene1B/string280013.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 19.712-0.200+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 7 $130F
    
    cut_waitForFrameMinSec 1 22.010+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; blast-off
    ;=====
    
    ; "goodbye, yuna"
    .incbin "include/scene1B/string280015.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 25.987+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 9 $15CB
    
    cut_waitForFrameMinSec 1 33.311+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna
    ;=====
    
    ; "guys..."
    .incbin "include/scene1B/string280016.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 35.871-0.150+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $A $1733
    
    cut_waitForFrameMinSec 1 39.955+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "don't go"
    .incbin "include/scene1B/string280017.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 41.503-0.200+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 1 43.182+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; tv station corridor
    ;=====
    
    ; "why the long face"
    .incbin "include/scene1B/string280018.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 47.719-2.000+subOffset
      cut_subsOff
    
    ; throttle speed
    cut_writeMem maxScriptActionsPerIteration 1
    cut_writeMem maxSpriteAttrTransfersPerIteration 1
    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    SYNC_adpcmTime $C $19FA

    .redefine subOffset subOffset-0.050
    
    cut_waitForFrameMinSec 1 53.792-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm fine"
    .incbin "include/scene1B/string280019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 57.698+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you've got your cheeks all"
    .incbin "include/scene1B/string280020.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 59.937+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 2 1.104+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ever heard of"
    .incbin "include/scene1B/string280021.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 3.247+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, shove off"
    .incbin "include/scene1B/string280022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 7.510+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna + lia
    ;=====
    
    ; "huh? no way!"
    .incbin "include/scene1B/string280024.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 8.975+0.300+subOffset
      cut_subsOff
    
    ; restore speed
    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
    cut_writeMem maxSpriteAttrTransfersPerIteration default_maxSpriteAttrTransfersPerIteration
    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration

    .redefine subOffset subOffset-0.050
    
    SYNC_adpcmTime $D $20AE
    
;    cut_waitForFrameMinSec 2 21.502+subOffset
;    cut_subsOff
;    cut_swapAndShowBuf
    cut_waitForFrameMinSec 2 19.883+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "how!?"
    .incbin "include/scene1B/string280025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 23.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i've made my"
    .incbin "include/scene1B/string280026.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 24.467-0.100+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 2 26.229+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "you did? for real!?"
    .incbin "include/scene1B/string280027.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 27.670+0.100+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $E $2298
    
    cut_waitForFrameMinSec 2 28.313+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia
    ;=====
    
    ; "yuna..."
    .incbin "include/scene1B/string280028.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 30.433+0.100+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $F $233B
    
    cut_waitForFrameMinSec 2 30.933+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this time, we fight as"
    .incbin "include/scene1B/string280029.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 31.624+0.300+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $10 $2470
    
    cut_waitForFrameMinSec 2 35.994-0.200+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna
    ;=====
    
    ; "yeah!"
    .incbin "include/scene1B/string280030.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 38.304+0.150+subOffset
      cut_subsOff
    
    SYNC_adpcmTime $11 $2517
    
    cut_waitForFrameMinSec 2 38.935-0.150+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 2 39.328+subOffset
    cut_waitForFrameMinSec 2 39.935+subOffset
    cut_subsOff
    
    cut_terminator
.ends





