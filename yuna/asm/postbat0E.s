
;==============================================================================
; postbat 0E: kaede
;==============================================================================

; TODO: patch any needed EX_DSPOFF commands to EX_BGOFF

;===================================
; common include
;===================================

.include "include/scene_common.inc"

;.unbackground $3E5F+$40 $9FFF

.background "postbat0E.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat0E_ovlScene.inc"
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
;    SYNC_adpcmTime $0000
  
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ;=====
    ; scene
    ;=====
    
    cut_waitForFrame $0040
    
    ; "oh, kaede, i'm so sorry"
    .incbin "include/postbatE/string550000.bin"
;    cut_prepAndSendGrp $01BC
    SCENE_prepAndSendGrpAuto
    
;    cut_waitForAdpcm 1
    SYNC_adpcmTime 1 $007F
    cut_swapAndShowBuf
    
    ; "oh no! she's not dead"
    .incbin "include/postbatE/string550002.bin"
;    cut_prepAndSendGrp $01DC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0186
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "am i... a murderer!?"
    .incbin "include/postbatE/string550003.bin"
    SCENE_prepAndSendGrpAuto
    cut_waitForFrameMinSec 0 10.950
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "she's fine"
    .incbin "include/postbatE/string550004.bin"
    SCENE_prepAndSendGrpAuto
    SYNC_adpcmTime 3 $033F
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thank goodness"
    .incbin "include/postbatE/string550005.bin"
    SCENE_prepAndSendGrpAuto
    cut_waitForFrameMinSec 0 20.054
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what if kaede really does"
    .incbin "include/postbatE/string550006.bin"
    SCENE_prepAndSendGrpAuto
    cut_waitForFrameMinSec 0 23.687
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "she doesn't hate you"
    .incbin "include/postbatE/string550007.bin"
    SCENE_prepAndSendGrpAuto
    SYNC_adpcmTime 4 $06B6
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the power of darkness"
    .incbin "include/postbatE/string550008.bin"
    SCENE_prepAndSendGrpAuto
    SYNC_adpcmTime 5 $07D5
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "still, i'm relieved"
    .incbin "include/postbatE/string550009.bin"
    SCENE_prepAndSendGrpAuto
    SYNC_adpcmTime 6 $0925
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thanks to your power of light"
    .incbin "include/postbatE/string550010.bin"
    SCENE_prepAndSendGrpAuto
    cut_waitForFrameMinSec 0 40.931
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "thank goodness"
    .incbin "include/postbatE/string550011.bin"
    SCENE_prepAndSendGrpAuto
    SYNC_adpcmTime 7 $0AA4
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but if anyone sees"
    .incbin "include/postbatE/string550012.bin"
    SCENE_prepAndSendGrpAuto
      cut_waitForFrameMinSec 0 46.662
      cut_subsOff
    cut_waitForFrameMinSec 0 47.925
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "she'll be so embarrassed"
    .incbin "include/postbatE/string550013.bin"
    SCENE_prepAndSendGrpAuto
    SYNC_adpcmTime 8 $0C3E
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what should i do?"
    .incbin "include/postbatE/string550014.bin"
    SCENE_prepAndSendGrpAuto
    cut_waitForFrameMinSec 0 56.652
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 57.400+(9/60)
    cut_subsOff
    
    cut_terminator
.ends
