
;==============================================================================
; scene 0E: sayuka arrival
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene0E.bin"

; the first adpcm clip in this scene, and no others, uses a different routine
; from usual, which we have to take into account for syncing purposes
.define incAdpcmCounterOnPlayAdpcmAlt

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene0E_ovlScene.inc"
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;==============================================================================
; script
;==============================================================================

.define subOffset 0

.bank 0 slot 0
.section "script 1" free
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $40
    
    ;=====
    ; laser
    ;=====
    
    ; "huh? what?"
    .incbin "include/sceneE/string150000.bin"
    cut_prepAndSendGrp $01DC
    
    SYNC_adpcmTime 1 $00BD
    
    cut_waitForFrameMinSec 0 3.150-0.100+subOffset
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 4.705+subOffset+0.300
    cut_subsOff
    
    ; game needs almost all of vram for the laser sequence,
    ; so idle here until it's done...
    
    cut_waitForFrameMinSec 0 20.000+subOffset
    
    ;=====
    ; sayuka intro
    ;=====
    
    ; "lia, i was granted"
    .incbin "include/sceneE/string150002.bin"
    cut_prepAndSendGrp $01BC
    
;    SYNC_adpcmTime 2 $01CA
    SYNC_adpcmTime 3 $0512
    
    cut_waitForFrameMinSec 0 21.717+subOffset
    cut_swapAndShowBuf
    
    ; "in truth"
    .incbin "include/sceneE/string150003.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrameMinSec 0 25.917+subOffset+0.400
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 27.917-0.050+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "for you to be"
    .incbin "include/sceneE/string150004.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 0 31.670+subOffset+0.400
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 33.956-0.100+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you have always been"
    .incbin "include/sceneE/string150005.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrameMinSec 0 37.509+subOffset+0.400
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 39.185+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "my apologies"
    .incbin "include/sceneE/string150006.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 0 41.985+subOffset
;      cut_subsOff
    
    cut_waitForFrameMinSec 0 43.738+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia
    ;=====
    
    ; "sayuka, what are you"
    .incbin "include/sceneE/string150008.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 48.062+subOffset+0.400
      cut_subsOff
    
    SYNC_adpcmTime 4 $0C13
    
    cut_waitForFrameMinSec 0 51.586+subOffset
    cut_swapAndShowBuf
    
    ; "a fraulein doesn't"
    .incbin "include/sceneE/string150009.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 55.634-0.100+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; sayuka narrow
    ;=====
    
    ; "lia, your dark power"
    .incbin "include/sceneE/string150010.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 58.139+subOffset+0.400
      cut_subsOff
    
    SYNC_adpcmTime 5 $0E56
    
    cut_waitForFrameMinSec 1 1.216+subOffset
    cut_swapAndShowBuf
    
    ; "as such, you"
    .incbin "include/sceneE/string150011.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 9.550+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia pan
    ;=====
    
    ; "hmph! shut up"
    .incbin "include/sceneE/string150012.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 1 14.284+subOffset+0.400
      cut_subsOff
    
    SYNC_adpcmTime 6 $11F9
    
    cut_waitForFrameMinSec 1 16.741+subOffset
    cut_swapAndShowBuf
    
    ; "i don't want to"
    .incbin "include/sceneE/string150013.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 19.742+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hey, who's that"
    .incbin "include/sceneE/string150014.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 21.808+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; sayuka pan
    ;=====
    
    ; "even should you take"
    .incbin "include/sceneE/string150015.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 1 23.418+subOffset+0.400
      cut_subsOff
    
    SYNC_adpcmTime 7 $14D6
    
    cut_waitForFrameMinSec 1 28.971+subOffset
    cut_swapAndShowBuf
    
    ; "those words are also"
    .incbin "include/sceneE/string150016.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 1 32.638+subOffset+0.400+0.300
      cut_subsOff
    
    cut_waitForFrameMinSec 1 35.962-0.100+subOffset
    cut_swapAndShowBuf
    
    ; "with all due respect"
    .incbin "include/sceneE/string150017.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 39.258+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; lia 2
    ;=====
    
    ; "she... really said"
    .incbin "include/sceneE/string150018.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrameMinSec 1 45.239+subOffset+0.400
      cut_waitForFrameMinSec 1 45.239-0.100+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 8 $18CD
    
    cut_waitForFrameMinSec 1 47.564+subOffset
    cut_swapAndShowBuf
    
    ;=====
    ; sayuka 2
    ;=====
    
    ; "indeed. but..."
    .incbin "include/sceneE/string150019.bin"
    cut_prepAndSendGrp $01BC
      
      cut_waitForFrameMinSec 1 52.516-0.100+subOffset
      cut_subsOff
    
    SYNC_adpcmTime 9 $1A85
    
    cut_waitForFrameMinSec 1 53.212+subOffset
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "before that, it appears"
    .incbin "include/sceneE/string150020.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 56.088+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yes, i fear that"
    .incbin "include/sceneE/string150021.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 1 59.031+subOffset+0.400
;      cut_subsOff
    
    cut_waitForFrameMinSec 2 0.603+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well then, lia"
    .incbin "include/sceneE/string150022.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 9.032+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "here i come"
    .incbin "include/sceneE/string150023.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 11.652-0.100+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 2 12.719-0.200+subOffset+0.400
    cut_subsOff
    
    cut_terminator
.ends





