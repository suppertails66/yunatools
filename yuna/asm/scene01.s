
;==============================================================================
; scene 01: journey to flint
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene01.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene01_ovlScene.inc"
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
    
    ;=====
    ; cockpit
    ;=====
    
    cut_waitForFrame $60
    
    ; "roger"
    .incbin "include/scene1/string20000.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 1 $0095
    
    cut_waitForFrameMinSec 0 2.536-(2/60)
    cut_swapAndShowBuf
    
    ; "let's see... all i gotta do"
    .incbin "include/scene1/string20001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 3.950
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "please do get it right"
    .incbin "include/scene1/string20002.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 7.303
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yeah, yeah"
    .incbin "include/scene1/string20003.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 10.021
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "let's see"
    .incbin "include/scene1/string20004.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 12.097
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "X..."
    .incbin "include/scene1/string20005.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 13.847
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "uh"
    .incbin "include/scene1/string20006.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrameMinSec 0 16.746+(30/60)
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 17.794
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what was it"
    .incbin "include/scene1/string20007.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 0 18.794
      cut_subsOff
    
    cut_waitForFrameMinSec 0 19.723
    cut_swapAndShowBuf
    
    ; "Y"
    .incbin "include/scene1/string20008.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 20.617
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that's right"
    .incbin "include/scene1/string20009.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 22.367
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 24.692
    cut_subsOff
    
    ; "okay, initiating"
    .incbin "include/scene1/string20010.bin"
    cut_prepAndSendGrp $01DC
    
    ;=====
    ; space
    ;=====
    
    SYNC_adpcmTime 2 $066D
    
    cut_waitForFrameMinSec 0 27.438-(3/60)
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 30.210
    cut_subsOff
    
    cut_terminator
.ends





