
;==============================================================================
; scene 04: arrival at flint
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene04.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene04_ovlScene.inc"
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
    
    ; "the cardia star system"
    .incbin "include/scene4/string50000.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 1 $009F
    
    cut_waitForFrameMinSec 0 2.669
    cut_swapAndShowBuf
    
    ; "instead, it's"
    .incbin "include/scene4/string50001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 5.830
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "however, the"
    .incbin "include/scene4/string50002.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 10.881
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now, development"
    .incbin "include/scene4/string50003.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 15.495
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the human cultural"
    .incbin "include/scene4/string50004.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 18.839
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "serves as a"
    .incbin "include/scene4/string50005.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 22.612
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; ship
    ;=====
    
    ; "it seems we've"
    .incbin "include/scene4/string50006.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 25.368
      cut_subsOff
    
;    SYNC_adpcmTime 2 $060F
    SYNC_adpcmTime 3 $06C0
    
    cut_waitForFrameMinSec 0 28.830
    cut_swapAndShowBuf
    
    ; "ah, is that ri..."
    .incbin "include/scene4/string50007.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 30.673
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what's wrong"
    .incbin "include/scene4/string50008.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 32.436
      cut_subsOff
    
    cut_waitForFrameMinSec 0 33.842
    cut_swapAndShowBuf
    
    ; "the warp was"
    .incbin "include/scene4/string50009.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 36.868
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "they say that"
    .incbin "include/scene4/string50010.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 39.815
      cut_subsOff
    
    cut_waitForFrameMinSec 0 41.228
    cut_swapAndShowBuf
    
    ; "you don't say"
    .incbin "include/scene4/string50011.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 43.611
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "then again"
    .incbin "include/scene4/string50012.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 46.844
      cut_subsOff
    
    cut_waitForFrameMinSec 0 48.154
    cut_swapAndShowBuf
  
    cut_waitForFrameMinSec 0 50.187+0.300
    cut_subsOff
    
    cut_terminator
.ends





