
;==============================================================================
; scene 12: gina awakening
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene12.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene12_ovlScene.inc"
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;==============================================================================
; script
;==============================================================================

.define timeOffset 29/60

.bank 0 slot 0
.section "script 1" free
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
;    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $20
    
    ;=====
    ; gina reveal
    ;=====
    
    ; "yuna, i've been waiting"
    .incbin "include/scene12/string190000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0542
    
    cut_waitForFrameMinSec 0 21.972+timeOffset
    cut_swapAndShowBuf
    
    ; just for posterity, i'd like to note that the one-frame glitch
    ; briefly visible at this point is in the original game.
    ; not everything is my fault!
    
    ; "how do you do"
    .incbin "include/scene12/string190001.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 26.573+timeOffset
      cut_subsOff
    
    SYNC_adpcmTime 3 $0A73
    cut_waitForFrameMinSec 0 44.028+timeOffset+(3/60)
    cut_swapAndShowBuf
    
    ; "a pleasure to meet you"
    .incbin "include/scene12/string190002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 47.396+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; 
    ;=====
    
    ; "hm? so you're one of"
    .incbin "include/scene12/string190003.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 48.576+timeOffset
      cut_subsOff
    
    SYNC_adpcmTime 4 $0DC1
    
    cut_waitForFrameMinSec 0 58.008+timeOffset
    cut_swapAndShowBuf
    
    ; "that's right"
    .incbin "include/scene12/string190004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 1.817+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh..."
    .incbin "include/scene12/string190005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 2.656+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey hey, you don't"
    .incbin "include/scene12/string190006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 3.580+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i can't say that i"
    .incbin "include/scene12/string190007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 6.679+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "at any rate, yuna"
    .incbin "include/scene12/string190008.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 1 8.354+timeOffset
      cut_subsOff
    
    SYNC_adpcmTime 5 $1077
    
    cut_waitForFrameMinSec 1 9.869+timeOffset
    cut_swapAndShowBuf
    
    ; "another one of your"
    .incbin "include/scene12/string190009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 12.933+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "come on, let's"
    .incbin "include/scene12/string190010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 17.261+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "right"
    .incbin "include/scene12/string190011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 19.391+timeOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 20.391+timeOffset
    cut_subsOff
    
    cut_terminator
.ends





