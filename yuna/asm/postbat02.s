
;==============================================================================
; postbat 02: mai 1
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "postbat02.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/postbat02_ovlScene.inc"
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
    
    .incbin "include/postbat2/string430000.bin"
;    cut_prepAndSendGrp $01BC
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 1 $0084
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
    cut_subsOff
    
/*    SYNC_adpcmTime 1 $007B
;    cut_waitForFrameMinSec 0 2.733-0.683
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410001.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 2 $0112
    
;    cut_waitForFrameMinSec 0 5.244-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410002.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 3 $018C
    
;    cut_waitForFrameMinSec 0 7.255-0.683
    cut_subsOff
    cut_swapAndShowBuf
    
;    .incbin "include/postbat0/string410003.bin"
;    SCENE_prepAndSendGrpAuto
    
;    cut_waitForFrameMinSec 0 9.738
;    cut_subsOff
;    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410004.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 4 $02F6
    
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410005.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 5 $033E
    
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410006.bin"
    SCENE_prepAndSendGrpAuto
    
    cut_waitForFrameMinSec 0 16.490
    cut_subsOff
    cut_swapAndShowBuf
    
    .incbin "include/postbat0/string410007.bin"
    SCENE_prepAndSendGrpAuto
    
    SYNC_adpcmTime 6 $047B
    
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 0 19.832
    cut_subsOff */
    
    cut_terminator
.ends
