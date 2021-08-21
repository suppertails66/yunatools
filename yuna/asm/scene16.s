
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
    ; lia death 1
    ;=====
    
    ; "lia"
    .incbin "include/scene16/string230000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0083
    
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
    
    SYNC_adpcmTime 2 $0766
    
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
    
    SYNC_adpcmTime 3 $0B15
    
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
    
    SYNC_adpcmTime 5 $13CF
    
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
    
    SYNC_adpcmTime 6 $1552
    
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
    
    SYNC_adpcmTime 7 $192F
    
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
    
    SYNC_adpcmTime 9 $1FB3
    
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
    
    SYNC_adpcmTime $A $21AA
    
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
    
    SYNC_adpcmTime $B $24FA
    
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
    
    SYNC_adpcmTime $C $273B
    
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
    
    SYNC_adpcmTime $D $29F0
    
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
    
    SYNC_adpcmTime $E $2B00
    
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
    
    SYNC_adpcmTime $F $2D42
    
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

/*    SYNC_adpcmTime 1 $0081
    
    cut_waitForFrameMinSec 0 2.15+0.333+subOffset
    cut_swapAndShowBuf
    
    ; "here you die"
    .incbin "include/scene2/string30001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 3.365+0.333+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "look out"
    .incbin "include/scene2/string30002.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 4.851+subOffset
      cut_subsOff

    SYNC_adpcmTime 2 $015E
    
    cut_waitForFrameMinSec 0 5.692+0.333+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you... why"
    .incbin "include/scene2/string30003.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 0 6.725+0.300+subOffset
      cut_subsOff

    SYNC_adpcmTime 3 $01ED
    
    cut_waitForFrameMinSec 0 8.491+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 10.190+subOffset
    cut_subsOff
    
    ;=====
    ; heroic return of lia
    ;=====
    
    .redefine subOffset -0.050
    
    ; here, most of vram is taken up by sprites.
    ; however, the sprites of yuna turning to face elner aren't
    ; needed until the end of the scene, so we temporarily overwrite them
    ; and restore the original contents once they're needed
    
    ; first part of the scene is a rare instance of a high-priority object
    ; with lots of sprites; dial back the offset a bit here so we don't
    ; spill into the low-priority section of the sprite table
    cut_setHighPrioritySprObjOffset 12
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    ; "ah! lia"
    .incbin "include/scene2/string30004.bin"
    cut_prepAndSendGrp $00A0

    SYNC_adpcmTime 4 $026A
    
    cut_waitForFrameMinSec 0 11.813+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_writeMem skipHighPriorityObjDrawFrames $FF
;    cut_writeMem skipLowPriorityObjDrawFrames $FF
    
    ; "lia, what do you"
    .incbin "include/scene2/string30005.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 13.230+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna... i'm sorry"
    .incbin "include/scene2/string30006.bin"
    cut_prepAndSendGrp $00A0
    
      ; something causes a flicker here if subs are on
      ; as lia draws her saber, and i have no idea what.
      ; throttling and disabling both low and high priority
      ; processing don't help.
      ; possibly there are just so many sprites getting drawn at once
      ; that merely sending the subtitles is enough to overrun vblank
      cut_waitForFrameMinSec 0 15.685-0.100+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 16.749+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_writeMem skipHighPriorityObjDrawFrames $00
;    cut_writeMem skipLowPriorityObjDrawFrames $00
    
    ; restore normal sprite offset
    cut_setHighPrioritySprObjOffset 16
    
    ; "i was wrong"
    .incbin "include/scene2/string30007.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 19.677+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "in the end..."
    .incbin "include/scene2/string30008.bin"
    cut_prepAndSendGrp $00A0
    
    cut_waitForFrameMinSec 0 21.806+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "being a fraulein"
    .incbin "include/scene2/string30009.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 23.446+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "to be kind to"
    .incbin "include/scene2/string30010.bin"
    cut_prepAndSendGrp $00A0
    
    cut_waitForFrameMinSec 0 29.653+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that is a fraulein"
    .incbin "include/scene2/string30011.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 33.387+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "being the best, fighting"
    .incbin "include/scene2/string30012.bin"
    cut_prepAndSendGrp $00A0
    
    cut_waitForFrameMinSec 0 35.937+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now i understand too"
    .incbin "include/scene2/string30013.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 40.135+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "alright! so, lia"
    .incbin "include/scene2/string30014.bin"
    cut_prepAndSendGrp $00A0
    
      cut_waitForFrameMinSec 0 41.822-0.100+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 43.097+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna"
    .incbin "include/scene2/string30015.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 48.033+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; restore yuna head turn sprites
    cut_writeVram yunaHeadTurnSprites_part1 $2800+((yunaHeadTurnSpritesPartSize*0)/2) yunaHeadTurnSpritesPartSize
    cut_writeVram yunaHeadTurnSprites_part2 $2800+((yunaHeadTurnSpritesPartSize*1)/2) yunaHeadTurnSpritesPartSize
    cut_writeVram yunaHeadTurnSprites_part3 $2800+((yunaHeadTurnSpritesPartSize*2)/2) yunaHeadTurnSpritesPartSize
    cut_writeVram yunaHeadTurnSprites_part4 $2800+((yunaHeadTurnSpritesPartSize*3)/2) yunaHeadTurnSpritesPartSize
    
    ;=====
    ; heroic return of elner
    ;=====
    
    cut_waitForFrameMinSec 0 49.166+subOffset
    cut_subsOff

    ; wait for voice clip to sync before drawing subtitles --
    ; we need to wait for the last scene to get cleared due to
    ; lack of vram,
    ; and there's a convenient gasp at the start of the clip
    ; which doesn't need to be subtitled
    SYNC_adpcmTime 5 $0C17
    
    ; "elner!"
    .incbin "include/scene2/string30016.bin"
    cut_prepAndSendGrp $01DC
    
    ; disable sprite forcing to avoid interfering with
    ; upper bound of scanline sprite cropping
    cut_writeMem subtitleSpriteForcingOn $00
    
;    cut_waitForFrameMinSec 0 51.853+subOffset
    cut_waitForFrameMinSec 0 52.789+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna..."
    .incbin "include/scene2/string30017.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 53.965+subOffset
      cut_subsOff
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    SYNC_adpcmTime 6 $0D68
    
    cut_waitForFrameMinSec 0 57.863+subOffset
;    cut_subsOff
    cut_swapAndShowBuf

    ; this scene has an unusual occurrence:
    ; enough sprites are being drawn at once to cause vblank overruns
    ; during subtitle preparation, even with maximum speed throttling,
    ; and since sprite cropping is being used for elner, we can't just
    ; let subtitle sprite forcing "solve" the problem for us.
    ; so by setting this flag, we can prevent subtitles from being
    ; processed at all if a low-priority sprite object (i.e. yuna)
    ; was drawn on the same frame.
    cut_writeMem skipLowPriorityObjDrawFrames $FF
    
    ; "thank goodness"
    .incbin "include/scene2/string30018.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 58.601+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm sorry"
    .incbin "include/scene2/string30019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 3.100+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's fine"
    .incbin "include/scene2/string30020.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 6.465+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but what happened"
    .incbin "include/scene2/string30021.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 10.766+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "lia saved me"
    .incbin "include/scene2/string30022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 13.093+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thank you, lia"
    .incbin "include/scene2/string30023.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 16.776+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 1 18.544+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia speech 2
    ;=====
    
    ; "the savior of light"
    .incbin "include/scene2/string30024.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 20.733+0.200+subOffset
      cut_subsOff
    
    ; restore processing speed
;    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
;    cut_writeMem maxSpriteAttrTransfersPerIteration default_maxSpriteAttrTransfersPerIteration
;    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration
    
    ; return to normal processing
    cut_writeMem skipLowPriorityObjDrawFrames $00
    
    SYNC_adpcmTime 7 $1396
    
    ; re-enable sprite forcing
    cut_writeMem subtitleSpriteForcingOn $FF
    
    cut_waitForFrameMinSec 1 24.245+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you don't stand a chance"
    .incbin "include/scene2/string30025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 28.374+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but still..."
    .incbin "include/scene2/string30026.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 30.246+0.300+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 1 32.014+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i can never forgive you"
    .incbin "include/scene2/string30027.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 34.118+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "time to pay back"
    .incbin "include/scene2/string30028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 38.736+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "lia!"
    .incbin "include/scene2/string30029.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 41.458+0.200+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 8 $1875
    
    cut_waitForFrameMinSec 1 45.424+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; dark queen speech 2
    ;=====
    
    ; "you, lia..."
    .incbin "include/scene2/string30030.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 1 46.197+subOffset
      cut_waitForFrameMinSec 1 46.424+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 9 $1927
    
    cut_waitForFrameMinSec 1 47.905+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i will dispose"
    .incbin "include/scene2/string30031.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 52.610+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 54.198+subOffset
    cut_subsOff
    
    
    
    
    
    ; restore processing speed
;    cut_writeMem maxScriptActionsPerIteration default_maxScriptActionsPerIteration
;    cut_writeMem maxSpriteAttrTransfersPerIteration default_maxSpriteAttrTransfersPerIteration
;    cut_writeMem maxSpriteGrpTransfersPerIteration default_maxSpriteGrpTransfersPerIteration */
    
    cut_terminator
.ends





