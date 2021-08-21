
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
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================
  
  ; "FIRST" album scroll
;  fixDspOffWithSprClrAndSync $4398

;================================
; no sprite letterboxing on lower part of scene
;================================

/*.bank 0 slot 0
.orga $4113
.section "sprite letterbox fix 1" overwrite
  nop
  nop
  nop
.ends */

;================================
; add conditional disabling of low-priority sprite generation
; below cutoff threshold
;================================

/*.bank 0 slot 0
.orga $40B2
.section "sprite letterbox fix 1" overwrite
  nop
  nop
  nop
.ends*/

; FIXME: +0x40
/*.define spriteYCutoffLine $D0+$40


.bank 0 slot 0
.orga $480F
.section "fuck 1" overwrite
  loc_480F:
    lda ($0034),Y
.ends

.bank 0 slot 0
.orga $482F
.section "fuck 2" overwrite
  loc_482F:
    dec $003B
.ends

.bank 0 slot 0
.orga $4835
.section "fuck 3" overwrite
  loc_4835:
    st1 #$00
.ends


.bank 0 slot 0
.orga $47ED
.section "sprite display cutoff low-priority 1" SIZE $22 overwrite
;  jmp doLowPrioritySpriteCutoffCheck
  tma #$10
  pha
    lda #$82
    tam #$10
    jsr doLowPrioritySpriteCutoffCheck
    tax
  pla
  tam #$10
  txa
  spriteCutoffStatusCodeOp:
  ; 0 = normal
  ; 1 = skipped
  ; 2 = terminated
  cmp #$00
  beq loc_480F
  cmp #$01
  beq loc_482F
  ; otherwise, assume terminated
  bne loc_4835
;  cmp #$02
;  beq $4835
  
.ends

; NOTE: cannot go in free space
; (bank is not guaranteed due to read operation).
; extra space has been allocated for this purpose
.bank 0 slot 0
.orga $807E
.section "sprite display cutoff low-priority 2" SIZE $80 overwrite
  doLowPrioritySpriteCutoffCheck:
    lda ($34),Y
      ; add y-offset
    clc 
    adc $38
    sta spriteYTemp+0.w
    iny 
      ; byte 1
    lda ($34),Y
    adc $39
    sta spriteYTemp+1.w
    iny 
  
    lda spriteCutoffFlag.w
    beq @display
    
    ; check if targeting a position greater than allowed
    lda spriteYTemp+1.w
    cmp #$00
    bne @doNotDisplay
    
    lda spriteYTemp+0.w
    cmp #<spriteYCutoffLine
    bcs @doNotDisplay
    
    @display:
      ; make up work
      lda spriteYTemp+0.w
      sta $02.w
      lda spriteYTemp+1.w
      sta $03.w
;        jmp $47FE

      ; make up x-work
      lda ($0034),Y
      ; add x-offset
      clc 
      adc $36
      sta $0002.w
      iny 
      ; byte 3
      lda ($34),Y
      adc $37
      sta $0003.w
      iny

      ; return code = 0 (display)
      lda #$00
      rts
    
    @doNotDisplay:
      ; skip remaining bytes in data
      iny
      iny
      ; check for terminator (pattern num == 0xFF)
      lda ($34),Y
      cmp #$FF
      beq @terminated
        iny
        iny
        iny
        iny
;          jmp $482F
        ; return code = 1 (skipped)
        lda #$01
        rts
      @terminated:
      
      ; ???
      sta $02.w
      sta $03.w
      sta $02.w
      sta $03.w
;        jmp $4835
      ; return code = 2 (terminated)
      lda #$02
      rts
    
  spriteYTemp:
    .dw 0
  
  spriteCutoffFlag:
    .db $00
.ends */

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
    
    SYNC_adpcmTime 1 $007D
    
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
;    cut_writeMem $2047 $AF
    
    ; clear "sprites on" flag, which was previously forced on
    ; by the subtitles, to allow animation of elner flying in
    ; to be correctly cropped
    cut_andOr $20F3 $BF $00
    
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
    cut_subsOff
    
/*    ; "yuna, don't you feel that"
    .incbin "include/scene10/string170000.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
;    SYNC_adpcmTime 1 $007A
    
;    cut_waitForFrameMinSec 0 2.716-0.066
    cut_swapAndShowBuf
    
    ; "yaaay"
    .incbin "include/scene11/string180001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 5.558-0.066
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you really think"
    .incbin "include/scene11/string180002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 8.444
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "there could be one"
    .incbin "include/scene11/string180003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.610
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i don't think so"
    .incbin "include/scene11/string180004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 12.242
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay okay"
    .incbin "include/scene11/string180005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 13.268
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "who cares"
    .incbin "include/scene11/string180006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.245
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ah, you're ducking"
    .incbin "include/scene11/string180007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.985
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, don't you"
    .incbin "include/scene11/string180008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 18.500
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?"
    .incbin "include/scene11/string180009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 21.148
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i do"
    .incbin "include/scene11/string180010.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 22.148
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 22.945
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it feels like"
    .incbin "include/scene11/string180011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 24.321
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "so, what does that"
    .incbin "include/scene11/string180012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 27.050
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "...you get it, right"
    .incbin "include/scene11/string180013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 28.796
    cut_subsOff
    cut_swapAndShowBuf
    
    ; NOTE: there's some emulator issue here that causes the sound
    ; to screw up and go out of sync, so I'm pretty much just guessing
    ; at the timing on these lines
    
    ; "umm...uhh..."
    .incbin "include/scene11/string180014.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.391
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no fair suddenly changing"
    .incbin "include/scene11/string180015.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 34.681
;    cut_waitForFrameMinSec 0 34.681-2.500
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; flash
    ;=====
    
    ; "ah! it's bright"
    .incbin "include/scene11/string180016.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 37.646
;      cut_waitForFrameMinSec 0 37.646-2.500
      cut_subsOff
    
    SYNC_adpcmTime 2 $09C4
    
    cut_waitForFrameMinSec 0 42.296
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, open your eyes"
    .incbin "include/scene11/string180017.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 44.121
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you need to see this"
    .incbin "include/scene11/string180018.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 46.002
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but it's so bright"
    .incbin "include/scene11/string180019.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 47.092
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "huh?"
    .incbin "include/scene11/string180020.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 48.658
      cut_subsOff
    
    SYNC_adpcmTime 3 $0CB9
    
    cut_waitForFrameMinSec 0 54.453
;    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; marina introduction
    ;=====
    
    ; "how do you do"
    .incbin "include/scene11/string180021.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 55.212
      cut_waitForFrameMinSec 0 55.453
      cut_subsOff
    
    SYNC_adpcmTime 5 $11F3
    
    cut_waitForFrameMinSec 1 17.230
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's been a while"
    .incbin "include/scene11/string180022.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 18.791
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you're yuna"
    .incbin "include/scene11/string180023.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 21.896
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm marina"
    .incbin "include/scene11/string180024.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 24.064
      cut_subsOff
    
    cut_waitForFrameMinSec 1 25.473
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it's nice to meet you"
    .incbin "include/scene11/string180025.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 26.933
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna introduction
    ;=====
    
    ; "oh, thank you"
    .incbin "include/scene11/string180026.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 27.663
      cut_subsOff
    
    SYNC_adpcmTime 6 $14ED
    
    cut_waitForFrameMinSec 1 29.932
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i, uh..."
    .incbin "include/scene11/string180027.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 34.801
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wait, what do i"
    .incbin "include/scene11/string180028.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 36.755
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "umm..."
    .incbin "include/scene11/string180029.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 39.473
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you're very pink"
    .incbin "include/scene11/string180030.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 1 40.551
;      cut_subsOff
    
    cut_waitForFrameMinSec 1 42.135
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "ignore her, marina"
    .incbin "include/scene11/string180031.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 43.067
      cut_subsOff
    
    SYNC_adpcmTime 7 $183E
    
    cut_waitForFrameMinSec 1 44.061
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "c'mon, you're embarrassing"
    .incbin "include/scene11/string180033.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 47.284
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "somehow, i feel like"
    .incbin "include/scene11/string180034.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 49.575
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "marina, we want"
    .incbin "include/scene11/string180035.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 52.001
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'll do anything i can"
    .incbin "include/scene11/string180036.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 55.157
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "deep in the darkest"
    .incbin "include/scene11/string180037.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 56.982
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm certain that she'll"
    .incbin "include/scene11/string180038.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 2.721
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "gotcha"
    .incbin "include/scene11/string180039.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 6.219
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "umm..."
    .incbin "include/scene11/string180040.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 10.392
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i don't know if i follow"
    .incbin "include/scene11/string180041.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 11.622
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "what's 'amazing'"
    .incbin "include/scene11/string180042.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 14.002
      cut_subsOff
    
    SYNC_adpcmTime 8 $1FCA
    
    cut_waitForFrameMinSec 2 16.209
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "in other words"
    .incbin "include/scene11/string180043.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 19.848
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, no no no"
    .incbin "include/scene11/string180044.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 22.325
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this is all"
    .incbin "include/scene11/string180045.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 25.655
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "for pete's sake"
    .incbin "include/scene11/string180046.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 2 26.862
      cut_subsOff
    
    SYNC_adpcmTime 9 $2276
    
    cut_waitForFrameMinSec 2 27.598
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "come on, now"
    .incbin "include/scene11/string180047.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 30.259
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well, shall we"
    .incbin "include/scene11/string180048.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 31.865
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "agreed"
    .incbin "include/scene11/string180049.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 34.291
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "in any case"
    .incbin "include/scene11/string180050.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 35.437
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "right!"
    .incbin "include/scene11/string180051.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 2 37.194
    cut_subsOff
    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 2 37.885
    cut_waitForFrameMinSec 2 38.194
    cut_subsOff */
    
    cut_terminator
.ends





