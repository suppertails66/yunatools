
;==============================================================================
; scene 10: erina awakening
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene10.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene10_ovlScene.inc"
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; elner flight crop fix
;================================

.bank 0 slot 0
.orga $4428
.section "elner flight fix 1" overwrite
  ; starting line of lower-screen sprite crop
  ; (we want this to be below the subtitle display area)
  lda #$AF+$30
.ends

;================================
; load prerendered subs for
; yuna closeup
;================================

.define closeupPrenderedSubGrpDst $5E00

.bank 0 slot 0
.orga $40C3
.section "prerendered subs 1" overwrite
  jsr loadCloseupPrerenderedSubGrp
.ends

.bank 0 slot 0
.section "prerendered subs 2" free
  loadCloseupPrerenderedSubGrp:
    ; make up work (load original graphics)
    jsr $70C3
    
    ; load additional graphics
    jsr EX_IRQOFF
      ; set write dst
      st0 #$00
      st1 #<closeupPrenderedSubGrpDst
      st2 #>closeupPrenderedSubGrpDst
      
      ; write
      st0 #$02
      tia panGrp,$0002,panGrpSize
    jsr EX_IRQON
    
    rts
.ends

;==============================================================================
; script
;==============================================================================

.define panTilemapDst $300

.bank 0 slot 0
.section "script 1" free
  ; script resources
  panGrp:
    .incbin "out/grp/scene10_pan.bin" FSIZE panGrpSize
;    .define panGrpPartSize (panGrpSize/4)
;    .define panGrp_part1 panGrp+(panGrpPartSize*0)
;    .define panGrp_part2 panGrp+(panGrpPartSize*1)
;    .define panGrp_part3 panGrp+(panGrpPartSize*2)
;    .define panGrp_part4 panGrp+(panGrpPartSize*3)
  panMapBlank:
    .incbin "out/maps/scene10-blank.bin" FSIZE panMapBlankSize
  panMap170005:
    .incbin "out/maps/scene10-170005.bin" FSIZE panMap170005Size
  panMap170006:
    .incbin "out/maps/scene10-170006.bin" FSIZE panMap170006Size
  panMap170007:
    .incbin "out/maps/scene10-170007.bin" FSIZE panMap170007Size
  panMap170008:
    .incbin "out/maps/scene10-170008.bin" FSIZE panMap170008Size
  panMap170009:
    .incbin "out/maps/scene10-170009.bin" FSIZE panMap170009Size
  panMap170010:
    .incbin "out/maps/scene10-170010.bin" FSIZE panMap170010Size
;  scene00UnpatchMap:
;;    .define scene00UnpatchMapSize $100
;    .incbin "rsrc_raw/grp/scene00_unpatch_map.bin" FSIZE scene00UnpatchMapSize
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $20
    
    ;=====
    ; initial shot
    ;=====
    
    ; "yuna, don't you feel that"
    .incbin "include/scene10/string170000.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01BC
    
    SYNC_adpcmTime 1 $00A3
    
    cut_waitForFrameMinSec 0 2.766
    cut_swapAndShowBuf
    
    ; "feel what"
    .incbin "include/scene10/string170001.bin"
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
    
    ;=====
    ; closeup
    ;
    ; okay, here things get tricky.
    ; the game does an entirely sprite-based pan down and up yuna's body.
    ; while it would probably be possible to get sprite-based subtitles
    ; working with a lot of effort, i decided it would be much easier
    ; to just use prerendered tile-based subs for the affected lines.
    ; so here, we simply load in tilemaps as needed.
    ;
    ; (why does even attempting to render sprite subtitles during this scene
    ; break the sprite cropping raster effect entirely? i could understand if
    ; it was lagging enough that the first-line scanline interrupt failed to
    ; trigger during rendering, but somehow the mere act of having rendered
    ; it at all permanently breaks everything.)
    ;=====
    
/*    ; "ah"
    .incbin "include/scene10/string170005.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 13.589
      cut_subsOff */
    
    SYNC_adpcmTime 2 $03B4
    
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
    
    SYNC_adpcmTime 4 $12FD
    
;    cut_waitForFrameMinSec 1 21.051
    cut_waitForFrameMinSec 1 22.253-0.100
    cut_swapAndShowBuf
    
    ; "erina"
    .incbin "include/scene10/string170012.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 1 23.444-0.200
      cut_subsOff
    
    SYNC_adpcmTime 5 $159D
    
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
;    cut_writeMem $2047 $AF
    
    ; clear "sprites on" flag, which was previously forced on
    ; by the subtitles, to allow animation of elner flying in
    ; to be correctly cropped
    cut_andOr $20F3 $BF $00
    
    SYNC_adpcmTime 6 $1730
    
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
    
    SYNC_adpcmTime 7 $1A44
    
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
    
    SYNC_adpcmTime 8 $1CD1
    
    cut_waitForFrameMinSec 2 3.050
    cut_swapAndShowBuf
    
    ; "you don't go around"
    .incbin "include/scene10/string170020.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 7.056-0.125
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
    
    SYNC_adpcmTime 9 $212D
    
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
    cut_subsOff
    
    cut_terminator
.ends





