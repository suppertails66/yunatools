
;==============================================================================
; scene 09: dark nebula intro
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene09.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene09_ovlScene.inc"
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

;================================
; elner flight crop fix
;================================

;.bank 0 slot 0
;.orga $408B
;.section "fix 1" overwrite
;  ; disable sprites but not bg
;  jsr $E093
;.ends

/*.bank 0 slot 0
.orga $4434
.section "elner flight fix 1" overwrite
  ; no lower sprite crop
  nop
  nop
  nop
.ends*/

/*.bank 0 slot 0
.orga $4428
.section "elner flight fix 1" overwrite
  ; starting line of lower-screen sprite crop
  ; (we want this to be below the subtitle display area)
  lda #$AF+$30
.ends */

;==============================================================================
; script
;==============================================================================

.define subOffset 0.683-0.025

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
    
    ; "the dark nebula"
    .incbin "include/scene9/string100000.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0079
    
    cut_waitForFrameMinSec 0 2.016+subOffset
    cut_swapAndShowBuf
    
    ; "although it is called"
    .incbin "include/scene9/string100001.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 3.981+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "there, a space"
    .incbin "include/scene9/string100002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 8.255+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this dark space"
    .incbin "include/scene9/string100003.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 14.149+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "no one can perceive"
    .incbin "include/scene9/string100004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 18.501+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 21.750+subOffset
    cut_subsOff
    
    ; "yuna, i want you to"
 /*   .incbin "include/scene7/string80002.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 22.104
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "elner, your voice is scaring me"
    .incbin "include/scene7/string80003.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 26.119-0.330
      cut_subsOff
    
    cut_waitForFrameMinSec 0 27.591-0.330
    cut_swapAndShowBuf
    
    ; "did you enter the"
    .incbin "include/scene7/string80004.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 30.732-0.330
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?"
    .incbin "include/scene7/string80005.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 34.642-0.330-0.050
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "isn't this good enough"
    .incbin "include/scene7/string80006.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 35.307-0.330
;      cut_subsOff
    
;    cut_waitForFrameMinSec 0 36.158-0.330
    cut_waitForFrameMinSec 0 36.174
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "even though"
    .incbin "include/scene7/string80007.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 40.112-0.330
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yay, yay"
    .incbin "include/scene7/string80008.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 43.973-0.330
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; planet intro
    ;=====
    
    ; "the giant planet balmood"
    .incbin "include/scene7/string80009.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 47.411-0.330
      cut_subsOff
    
    SYNC_adpcmTime 5 $0B59
    
    cut_waitForFrameMinSec 0 49.448-0.330
    cut_swapAndShowBuf
    
    ; "one that failed to"
    .incbin "include/scene7/string80010.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 53.732
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "this not-so-unusual"
    .incbin "include/scene7/string80011.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 57.455
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "because it contained abundant"
    .incbin "include/scene7/string80012.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 2.431
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "at present, it"
    .incbin "include/scene7/string80013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 7.439
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 12.492
    cut_subsOff */
    
    cut_terminator
.ends





