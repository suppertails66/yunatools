
;==============================================================================
; scene 1A: ultimate attack on final boss
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene1A.bin"

.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene1A_ovlScene.inc"
;.define enable_sceneAutoBusySkip 1
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;==============================================================================
; script
;==============================================================================

.define subOffset 0.683

.bank 0 slot 0
.section "script 1" free
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
    cut_waitForFrame $40
    
    ;=====
    ; ultimate attack
    ;=====
    
    SYNC_adpcmTime 1 $017B
    
    ; "el-line atomic shot"
    .incbin "include/scene1A/string270000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.185+subOffset
    cut_swapAndShowBuf
    
    ; "how could i"
    .incbin "include/scene1A/string270001.bin"
    SCENE_prepAndSendGrpAuto

      cut_waitForFrameMinSec 0 13.003+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $06D1
    
    cut_waitForFrameMinSec 0 30.840+subOffset
    cut_swapAndShowBuf

    cut_waitForFrameMinSec 0 36.263+subOffset
    cut_subsOff
    
    cut_terminator
.ends





