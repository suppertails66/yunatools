
;==============================================================================
; postbat 09: emily
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat09.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat09_ovlScene.inc"
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
    
    .incbin "include/postbat9/string500001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $007F
    
    cut_waitForFrameMinSec 0 2.116
    cut_swapAndShowBuf
    
    .incbin "include/postbat9/string500002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0158
    
    cut_waitForFrameMinSec 0 5.744
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 8.457
    cut_subsOff
    
    cut_terminator
.ends
