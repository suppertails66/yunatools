
;==============================================================================
; scene 1A: ultimate attack on final boss
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene1A.bin"

.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene1A_ovlScene.inc"
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
; fix cropping of elner flight scenes
;================================

/*.bank 0 slot 0
.orga $418C
.section "elner flight fix 1" overwrite
  jsr fixElnerFlight
.ends

.define elnerFlightFixCropSpace 16

.bank 0 slot 0
.section "elner flight fix 2" free
  fixElnerFlight:
    ; make up work (install lower sprite crop handler)
    jsr $7BAE
    
    ; install our own cropping handler to make sure sprites are turned
    ; back on for subtitles
    ; line num
    ; (needs to be low enough to crop off elner's "tail" bobbing below
    ; the original crop threshold, but high enough not to also crop the subtitles)
    lda #$AF+elnerFlightFixCropSpace
    sta $46+(4*1)+0
    ; jump target (this is an existing handler)
    lda #$BE
    sta $267F+(4*2)+0.w
    lda #$47
    sta $267F+(4*2)+1.w
    ; enable
    smb4 $44
    
    ; and turn sprites back off after subtitles so they'll be off
    ; at the start of the next frame
    ; linenum
    lda #$AF+elnerFlightFixCropSpace+32
    sta $46+(5*1)+0
    ; jump target (this is an existing handler)
    lda #$CD
    sta $267F+(5*2)+0.w
    lda #$47
    sta $267F+(5*2)+1.w
    ; enable
    smb5 $44
    
    rts
  
;  fixElnerFlight_cropHandler:
;    
;    rts
.ends

.bank 0 slot 0
;.orga $4202
.orga $427B
.section "elner flight fix 3" overwrite
  jsr fixElnerFlight2
.ends

.bank 0 slot 0
.section "elner flight fix 4" free
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

.define subOffset 0.683

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
    
    cut_setHighPrioritySprObjOffset 16
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    cut_waitForFrame $40
    
    ;=====
    ; ultimate attack
    ;=====
    
    SYNC_adpcmTime 1 $0155
    
    ; "el-line atomic shot"
    .incbin "include/scene1A/string270000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.185+subOffset
    cut_swapAndShowBuf
    
    ; "how could i"
    .incbin "include/scene1A/string270001.bin"
    SCENE_prepAndSendGrpAuto

      cut_waitForFrameMinSec 0 13.003+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $06AB
    
    cut_waitForFrameMinSec 0 30.840+subOffset
    cut_swapAndShowBuf

    cut_waitForFrameMinSec 0 36.263+subOffset
    cut_subsOff
    
    cut_terminator
.ends





