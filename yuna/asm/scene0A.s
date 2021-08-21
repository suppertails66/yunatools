
;==============================================================================
; scene 0A: flint asteroid field intro
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene0A.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene0A_ovlScene.inc"
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

.define subOffset 1.510

.bank 0 slot 0
.section "script 1" free
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_setHighPrioritySprObjOffset 16
    
    cut_waitForFrame $200
    
    ;=====
    ; arrival
    ;=====
    
    ; "and here we are"
    .incbin "include/sceneA/string110000.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
    SYNC_adpcmTime 2 $02C6
    
    cut_waitForFrameMinSec 0 11.007+subOffset
    cut_swapAndShowBuf
    
    ; "what are you talking about"
    .incbin "include/sceneA/string110001.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 15.381+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; more like, "am i"
    .incbin "include/sceneA/string110002.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
    cut_waitForFrameMinSec 0 19.505+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "hm? hm!?"
    .incbin "include/sceneA/string110003.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 22.248+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "uh... well, you're the"
    .incbin "include/sceneA/string110004.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
    cut_waitForFrameMinSec 0 26.164+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ding ding ding"
    .incbin "include/sceneA/string110005.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 29.433+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "and don't you forget"
    .incbin "include/sceneA/string110006.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
    cut_waitForFrameMinSec 0 30.913+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ugh...hey, elner"
    .incbin "include/sceneA/string110007.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 34.755+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "with the battle with lia"
    .incbin "include/sceneA/string110008.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
    cut_waitForFrameMinSec 0 39.849+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i liked her better before"
    .incbin "include/sceneA/string110009.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 44.121+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "don't worry, i"
    .incbin "include/sceneA/string110010.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
    cut_waitForFrameMinSec 0 45.529+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "how could you"
    .incbin "include/sceneA/string110011.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 49.199+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 50.880+subOffset
    cut_swapAndShowBuf
    
    ; "there, back to"
    .incbin "include/sceneA/string110012.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $0070
    
      cut_waitForFrameMinSec 0 54.480+subOffset
      cut_subsOff
    
    cut_waitForFrameMinSec 0 55.690+subOffset
    cut_swapAndShowBuf
    
    ; "the asteroids of the"
    .incbin "include/sceneA/string110013.bin"
;    SCENE_prepAndSendGrpAuto
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 0 57.929+subOffset-0.500
      cut_subsOff
    
    SYNC_adpcmTime 3 $0DF8
    
    cut_waitForFrameMinSec 0 58.720+subOffset
    cut_swapAndShowBuf
    
    ; "larger ones"
    .incbin "include/sceneA/string110014.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 3.542+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "smaller ones"
    .incbin "include/sceneA/string110015.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 6.095+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "at present"
    .incbin "include/sceneA/string110016.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 12.167+subOffset
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 16.459+subOffset
    cut_subsOff
    
    ;=====
    ; narration
    ;=====
    
    ; "although it is called"
/*    .incbin "include/scene9/string100001.bin"
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
    cut_subsOff */
    
    cut_terminator
.ends





