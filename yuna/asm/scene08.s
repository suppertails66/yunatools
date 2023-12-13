
;==============================================================================
; scene 08: black hole intro
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene08.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene08_ovlScene.inc"
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
    
    cut_waitForFrame $20
    
    ;=====
    ; narration
    ;=====
    
    ; "when a star larger than the sun"
    .incbin "include/scene8/string90000.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 1 $00A1
    
;    +$29
    
    cut_waitForFrameMinSec 0 2.783
    cut_swapAndShowBuf
    
    ; "it experiences a"
    .incbin "include/scene8/string90001.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 6.238
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the star is forced to"
    .incbin "include/scene8/string90002.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 8.393
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that is what we"
    .incbin "include/scene8/string90003.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 12.135
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "their existence was"
    .incbin "include/scene8/string90004.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 14.857
      cut_subsOff
    
    cut_waitForFrameMinSec 0 15.901
    cut_swapAndShowBuf
    
    ; "and now, several"
    .incbin "include/scene8/string90005.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 19.507
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this particular black hole"
    .incbin "include/scene8/string90006.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrameMinSec 0 22.093
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 22.955
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "was first observed"
    .incbin "include/scene8/string90007.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 29.091
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 30.968
    cut_subsOff
    
    ;=====
    ; ship
    ;=====
    
    ; "this is right about"
    .incbin "include/scene8/string90008.bin"
    cut_prepAndSendGrp $01DC
    
;    SYNC_adpcmTime 2 $0760
    SYNC_adpcmTime 3 $0811
    
    cut_waitForFrameMinSec 0 34.438
    cut_swapAndShowBuf
    
    ; "hey, hey"
    .incbin "include/scene8/string90009.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 38.561
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "y-yuna"
    .incbin "include/scene8/string90010.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 40.483
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh? why do you ask"
    .incbin "include/scene8/string90011.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 45.139
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "can you not"
    .incbin "include/scene8/string90012.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 47.815
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "a black hole's spherical surface"
    .incbin "include/scene8/string90013.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 50.050
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "all light particles"
    .incbin "include/scene8/string90014.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 54.688
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "okay..."
    .incbin "include/scene8/string90015.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 0 58.771+0.200
      cut_subsOff
    
    cut_waitForFrameMinSec 0 59.928
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now look"
    .incbin "include/scene8/string90016.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 1.289
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "oh, i get it"
    .incbin "include/scene8/string90017.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 5.973
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i thought it was"
    .incbin "include/scene8/string90018.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 8.888
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "now you understand"
    .incbin "include/scene8/string90019.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 12.392
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 14.286
    cut_subsOff
    
    cut_terminator
.ends





