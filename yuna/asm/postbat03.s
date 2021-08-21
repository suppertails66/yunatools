
;==============================================================================
; postbat 03: mai in corridor
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat03.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat03_ovlScene.inc"
.undefine playAdpcm
.define use_playAdpcmSpecial
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

;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free
  
  ; lol, i set everything up for this only to discover that it in fact has
  ; no voiceovers
  subtitleScriptData:
/*    ;=====
    ; init
    ;=====
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ;=====
    ; scene
    ;=====
    
    cut_waitForFrame $0040
    
    .incbin "include/postbat3/string440001.bin"
    SCENE_prepAndSendGrpAuto
    
;    SYNC_adpcmTime 1 $00E4
    cut_swapAndShowBuf */
    
/*    .incbin "include/postbat1/string420003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $01EC
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420004.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 11.692-0.683
      cut_subsOff
    
    cut_waitForFrameMinSec 0 15.918-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 17.210-0.683
      cut_subsOff
    
    cut_waitForFrameMinSec 0 19.157-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420006.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 21.103
      cut_subsOff
    
    cut_waitForFrameMinSec 0 23.448
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420007.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 27.411
      cut_subsOff
    
    cut_waitForFrameMinSec 0 30.755
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 31.784
    cut_subsOff */
    
    cut_terminator
.ends
