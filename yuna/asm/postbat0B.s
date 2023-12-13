
;==============================================================================
; postbat 0B: yuna beats lia
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat0B.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat0B_ovlScene.inc"
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
    
    .incbin "include/postbatB/string520001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0081
    
    cut_waitForFrameMinSec 0 2.150
    cut_swapAndShowBuf
    
    .incbin "include/postbatB/string520002.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 6.400-0.300
      cut_subsOff
    
    SYNC_adpcmTime 2 $0186
    
    cut_waitForFrameMinSec 0 8.141
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 12.800-0.050
    cut_subsOff
    
    cut_terminator
.ends
