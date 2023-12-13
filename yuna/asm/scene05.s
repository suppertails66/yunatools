
;==============================================================================
; scene 05: arrival at mariana
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene05.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene05_ovlScene.inc"
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
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
;    cut_waitForFrame $20
    cut_waitForFrame $40
    
    ;=====
    ; narration
    ;=====
    
    ; "planet mariana"
    .incbin "include/scene5/string60000.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $009F
    
    cut_waitForFrameMinSec 0 2.692
    cut_swapAndShowBuf
    
    ; "mariana of the"
    .incbin "include/scene5/string60001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 4.757-0.100
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the climate there"
    .incbin "include/scene5/string60002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 10.946
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "and its paltry"
    .incbin "include/scene5/string60003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 13.166
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now, it has become"
    .incbin "include/scene5/string60004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 15.874
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "though it lacks"
    .incbin "include/scene5/string60005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 19.355
      cut_subsOff
    
    cut_waitForFrameMinSec 0 20.688
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "recent research"
    .incbin "include/scene5/string60006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 24.698
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "and possessed"
    .incbin "include/scene5/string60007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.886
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ha"
    .incbin "include/scene5/string60008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 33.985
      cut_subsOff
    
    ;=====
    ; ship
    ;=====
    
;    SYNC_adpcmTime 2 $0807
    SYNC_adpcmTime 3 $08B8
    
;    cut_waitForFrameMinSec 0 37.221
    cut_waitForFrameMinSec 0 38.056
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wooow"
    .incbin "include/scene5/string60009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 39.897
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but the earth"
    .incbin "include/scene5/string60010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 42.149
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i really don't see"
    .incbin "include/scene5/string60011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 45.044
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "c'mon elner"
    .incbin "include/scene5/string60012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 48.338
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the ocean is just"
    .incbin "include/scene5/string60013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 50.607
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 53.168
    cut_subsOff
    
    cut_terminator
.ends





