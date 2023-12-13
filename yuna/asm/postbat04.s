
;==============================================================================
; postbat 04: shiori
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat04.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat04_ovlScene.inc"
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
    
    .incbin "include/postbat4/string450001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $008D
    
    cut_waitForFrameMinSec 0 2.35
    cut_swapAndShowBuf
    
    .incbin "include/postbat4/string450002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 7.191
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat4/string450003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 9.566
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 12.966+0.15
    cut_subsOff
    
    cut_terminator
.ends
