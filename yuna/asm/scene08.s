
;==============================================================================
; scene 08: black hole intro
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene08.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene08_ovlScene.inc"
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

;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free
  ; script resources
/*  scene00PatchGrp:
    .incbin "out/grp/scene00_patch.bin" FSIZE scene00PatchGrpSize
    .define scene00PatchGrpPartSize (scene00PatchGrpSize/4)
    .define scene00PatchGrp_part1 scene00PatchGrp+(scene00PatchGrpPartSize*0)
    .define scene00PatchGrp_part2 scene00PatchGrp+(scene00PatchGrpPartSize*1)
    .define scene00PatchGrp_part3 scene00PatchGrp+(scene00PatchGrpPartSize*2)
    .define scene00PatchGrp_part4 scene00PatchGrp+(scene00PatchGrpPartSize*3)
  scene00PatchMap:
    .incbin "out/maps/scene00_patch.bin" FSIZE scene00PatchMapSize
  scene00UnpatchMap:
;    .define scene00UnpatchMapSize $100
    .incbin "rsrc_raw/grp/scene00_unpatch_map.bin" FSIZE scene00UnpatchMapSize */
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $20
    
    ;=====
    ; narration
    ;=====
    
    ; "when a star larger than the sun"
    .incbin "include/scene8/string90000.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 1 $007B
    
;    +$29
    
    cut_waitForFrameMinSec 0 2.783
    cut_swapAndShowBuf
    
    ; "it experiences a"
    .incbin "include/scene8/string90001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 6.238
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the star is forced to"
    .incbin "include/scene8/string90002.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 8.393
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that is what we"
    .incbin "include/scene8/string90003.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 12.135
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "their existence was"
    .incbin "include/scene8/string90004.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 14.857
      cut_subsOff
    
    cut_waitForFrameMinSec 0 15.901
    cut_swapAndShowBuf
    
    ; "and now, several"
    .incbin "include/scene8/string90005.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 19.507
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this particular black hole"
    .incbin "include/scene8/string90006.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 22.093
      cut_subsOff
    
    cut_waitForFrameMinSec 0 22.955
    cut_swapAndShowBuf
    
    ; "was first observed"
    .incbin "include/scene8/string90007.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 29.091
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 30.968
    cut_subsOff
    
    ;=====
    ; ship
    ;=====
    
    ; "this is right about"
    .incbin "include/scene8/string90008.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 3 $07EB
    
    cut_waitForFrameMinSec 0 34.438
    cut_swapAndShowBuf
    
    ; "hey, hey"
    .incbin "include/scene8/string90009.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 38.561
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "y-yuna"
    .incbin "include/scene8/string90010.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 40.483
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh? why do you ask"
    .incbin "include/scene8/string90011.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 45.139
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "can you not"
    .incbin "include/scene8/string90012.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 47.815
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "a black hole's spherical surface"
    .incbin "include/scene8/string90013.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 50.050
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "all light particles"
    .incbin "include/scene8/string90014.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 54.688
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay..."
    .incbin "include/scene8/string90015.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 0 58.771+0.200
      cut_subsOff
    
    cut_waitForFrameMinSec 0 59.928
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now look"
    .incbin "include/scene8/string90016.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 1.289
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, i get it"
    .incbin "include/scene8/string90017.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 5.973
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i thought it was"
    .incbin "include/scene8/string90018.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 8.888
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now you understand"
    .incbin "include/scene8/string90019.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 12.392
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 14.286
    cut_subsOff
    
/*    cut_setHighPrioritySprObjOffset 16
    
    ; "hey, hey, are we ready"
    .incbin "include/scene0/string10000.bin"
    cut_prepAndSendGrp $01DC
    
;    cut_waitForAdpcm 1
    SYNC_adpcmTime 2 $01DA
    
;    cut_waitForFrameMinSec 0 9.629
    cut_waitForFrameMinSec 0 8.512
    cut_swapAndShowBuf
    
    ; "is this a train"
    .incbin "include/scene0/string10001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 11.061
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "heh-heh, my bad"
    .incbin "include/scene0/string10002.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 13.846
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "all right, then"
    .incbin "include/scene0/string10003.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 16.321
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well..."
    .incbin "include/scene0/string10004.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 20.475
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia
    ;=====
    
      cut_waitForFrameMinSec 0 22.763
      cut_subsOff
    
    cut_setHighPrioritySprObjOffset 0
    
    ; "so you've finally"
    .incbin "include/scene0/string10005.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 42.648-3
      
      ; palette
      cut_writePalette $0060 scene00PatchPalSize
        .incbin "out/pal/scene00_patch_line.pal" FSIZE scene00PatchPalSize
        
      ; graphics
      cut_writeVram scene00PatchGrp_part1 $0900+((scene00PatchGrpPartSize*0)/2) scene00PatchGrpPartSize
      cut_writeVram scene00PatchGrp_part2 $0900+((scene00PatchGrpPartSize*1)/2) scene00PatchGrpPartSize
      cut_writeVram scene00PatchGrp_part3 $0900+((scene00PatchGrpPartSize*2)/2) scene00PatchGrpPartSize
      cut_writeVram scene00PatchGrp_part4 $0900+((scene00PatchGrpPartSize*3)/2) scene00PatchGrpPartSize
;      cut_writeVram $6A00 scene00PatchGrpSize
;        .incbin "out/grp/intro_suit_patch.bin" FSIZE scene00PatchGrpSize
      
      ; transfer bg map
;      cut_waitForFrame $3028
      cut_writeVram scene00PatchMap $0700 scene00PatchMapSize
    
    SYNC_adpcmTime 5 $0960+4
    
    cut_waitForFrameMinSec 0 42.648
    cut_swapAndShowBuf
    
    ; "it's true she can"
    .incbin "include/scene0/string10006.bin"
    cut_prepAndSendGrp $01C0
    
    cut_waitForFrameMinSec 0 45.797
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well, it's"
    .incbin "include/scene0/string10007.bin"
    cut_prepAndSendGrp $01E0
    
    cut_waitForFrameMinSec 0 48.272
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i wonder if that"
    .incbin "include/scene0/string10008.bin"
    cut_prepAndSendGrp $01C0
    
    cut_waitForFrameMinSec 0 50.527
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "for now, why don't"
    .incbin "include/scene0/string10009.bin"
    cut_prepAndSendGrp $01E0
    
    cut_waitForFrameMinSec 0 54.711
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 57.297
    cut_subsOff
      
    ; patch over our temporary tilemap with blank tilemap
;        cut_waitForFrame $2FCA
    cut_writeVram scene00UnpatchMap $0700 scene00UnpatchMapSize
    
    ;=====
    ; cockpit 2
    ;=====
    
    cut_waitForFrameMinSec 1 3.148
    
    cut_setHighPrioritySprObjOffset 16
    
    ; "hey, hey, where are we"
    .incbin "include/scene0/string10010.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 6 $0F93
    
    cut_waitForFrameMinSec 1 7.124
    cut_swapAndShowBuf
    
    ; "you have a navigation map"
    .incbin "include/scene0/string10011.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 9.507
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "we'll follow your directions"
    .incbin "include/scene0/string10012.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 11.339
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh...i'm the one"
    .incbin "include/scene0/string10013.bin"
    cut_prepAndSendGrp $01BC
    
;    cut_waitForFrameMinSec 1 14.660
    cut_waitForFrameMinSec 1 13.459
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'm telling you"
    .incbin "include/scene0/string10014.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 16.749
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; done
    ;=====
    
    cut_waitForFrameMinSec 1 19.898
    cut_subsOff
    
;    cut_setHighPrioritySprObjOffset 0 */
    
    cut_terminator
.ends





