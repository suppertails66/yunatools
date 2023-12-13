
;==============================================================================
; postbat 0C: sayuka
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat0C.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat0C_ovlScene.inc"
.undefine playAdpcm
.define use_playAdpcmSpecial
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

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
    
    cut_waitForFrame $0030
    
    .incbin "include/postbatC/string530002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0090
    
    cut_waitForFrameMinSec 0 2.400
    cut_swapAndShowBuf
    
    .incbin "include/postbatC/string530003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 6.748
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbatC/string530004.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $026F
    
    cut_waitForFrameMinSec 0 10.383
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 13.943
    cut_subsOff
    
    cut_terminator
.ends
