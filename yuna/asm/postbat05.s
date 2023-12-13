
;==============================================================================
; postbat 05: alephtina
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat05.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat05_ovlScene.inc"
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
    
    cut_waitForFrame $0040
    
    .incbin "include/postbat5/string460001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0083
    
    cut_waitForFrameMinSec 0 2.183
    cut_swapAndShowBuf
    
    .incbin "include/postbat5/string460002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 4.120
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat5/string460003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0197
    
    cut_waitForFrameMinSec 0 6.781
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat5/string460004.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $022D
    
    cut_waitForFrameMinSec 0 9.278
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 10.619-0.100
    cut_subsOff
    
    cut_terminator
.ends
