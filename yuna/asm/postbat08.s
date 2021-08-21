
;==============================================================================
; postbat 08: ryudia
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat08.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat08_ovlScene.inc"
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
    
    .incbin "include/postbat8/string490001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $007B
    
    cut_waitForFrameMinSec 0 2.05
    cut_swapAndShowBuf
    
    .incbin "include/postbat8/string490002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0115
    
    cut_waitForFrameMinSec 0 4.612
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat8/string490003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $01B6
    
    cut_waitForFrameMinSec 0 7.291
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat8/string490004.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $02BB
    
    cut_waitForFrameMinSec 0 7.291
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat8/string490005.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 5 $0362
    
    cut_waitForFrameMinSec 0 14.414
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat8/string490006.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 6 $04C5
    
    cut_waitForFrameMinSec 0 20.323
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat8/string490007.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 7 $0592
    
    cut_waitForFrameMinSec 0 23.730
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 27.236
    cut_subsOff
    
    cut_terminator
.ends
