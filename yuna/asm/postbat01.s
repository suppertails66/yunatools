
;==============================================================================
; postbat 01: rock princess
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat01.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat01_ovlScene.inc"
.undefine playAdpcm
.define use_playAdpcmSpecial
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
    
    cut_waitForFrame $0040
    
    .incbin "include/postbat1/string420002.bin"
;    cut_prepAndSendGrp $01BC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $00E4
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420003.bin"
    SCENE_prepAndSendGrpAuto
    
      SYNC_adpcmTime 2 $01EC
      cut_subsOff
    
    cut_waitForFrameMinSec 0 9.657
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420004.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 11.692-0.683
      cut_subsOff
    
    cut_waitForFrameMinSec 0 15.918-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420005.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 17.210-0.683
      cut_subsOff
    
    cut_waitForFrameMinSec 0 19.157-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420006.bin"
    SCENE_prepAndSendGrpAuto
    
      cut_waitForFrameMinSec 0 21.103
;      cut_waitForFrameMinSec 0 22.183
      cut_subsOff
    
    cut_waitForFrameMinSec 0 23.448
    cut_swapAndShowBuf
    
    .incbin "include/postbat1/string420007.bin"
    SCENE_prepAndSendGrpAuto
    
;      cut_waitForFrameMinSec 0 27.411
      cut_waitForFrameMinSec 0 28.498
      cut_subsOff
    
    cut_waitForFrameMinSec 0 30.755
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 31.784+0.600
    cut_subsOff
    
/*    SYNC_adpcmTime 1 $0084
;    cut_waitForFrameMinSec 0 2.733-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $01DC
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430003.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $03C5
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430004.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $0459
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430005.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 5 $0497
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430007.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 6 $0603
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430008.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 7 $0681
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430009.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 32.988-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430010.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 8 $0838
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430011.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 9 $097D
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430012.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 10 $0A4D
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430013.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 49.541-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430014.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 53.471-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430016.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 11 $0DBE
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430017.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 1 1.284
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430018.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 12 $0F51
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430019.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 13 $1039
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430021.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 14 $10F7
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430022.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 15 $11F2
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat2/string430023.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 16 $12E5
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 22.291
    cut_subsOff */
    
    cut_terminator
.ends
