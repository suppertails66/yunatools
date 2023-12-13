
;==============================================================================
; postbat 00: yoshika
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat00.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat00_ovlScene.inc"
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
    
    .incbin "include/postbat0/string410000.bin"
;    cut_prepAndSendGrp $01BC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $007B
;    cut_waitForFrameMinSec 0 2.733-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0112
    
;    cut_waitForFrameMinSec 0 5.244-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $018C
    
;    cut_waitForFrameMinSec 0 7.255-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
;    .incbin "include/postbat0/string410003.bin"
;    SCENE_prepAndSendGrpAuto
    
;    cut_waitForFrameMinSec 0 9.738
;    cut_subsOff
;    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410004.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $02F6
    
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410005.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 5 $033E
    
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 16.490
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410007.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 6 $047B
    
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 19.832
    cut_subsOff
    
    cut_terminator
.ends
