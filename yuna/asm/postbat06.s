
;==============================================================================
; postbat 06: luminaev
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat06.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat06_ovlScene.inc"
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
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ;=====
    ; scene
    ;=====
    
    cut_waitForFrame $0040
    
    .incbin "include/postbat6/string470001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0084
    
    cut_waitForFrameMinSec 0 2.200+0.100
    cut_swapAndShowBuf
    
    .incbin "include/postbat6/string470002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $01AE
    
    cut_waitForFrameMinSec 0 7.166+0.100
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat6/string470003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 9.445+0.050
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 11.221+0.050
    cut_subsOff
    
    cut_terminator
.ends
