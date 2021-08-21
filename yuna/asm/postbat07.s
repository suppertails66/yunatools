
;==============================================================================
; postbat 07: remin
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat07.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat07_ovlScene.inc"
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
    
;    cut_setHighPrioritySprObjOffset 16
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ;=====
    ; scene
    ;=====
    
    cut_waitForFrame $0040
    
    .incbin "include/postbat7/string480000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $007B
    
    cut_waitForFrameMinSec 0 2.05
    cut_swapAndShowBuf
    
    .incbin "include/postbat7/string480001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0134
    
    cut_waitForFrameMinSec 0 5.121
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat7/string480002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $01DA
    
    cut_waitForFrameMinSec 0 7.894
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat7/string480003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $024C
    
    cut_waitForFrameMinSec 0 9.772
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 13.708-0.180
    cut_subsOff
    
    cut_terminator
.ends
