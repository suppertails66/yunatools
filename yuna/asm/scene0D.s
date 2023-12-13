
;==============================================================================
; scene 0D: ultimate gattai
;==============================================================================

;===================================
; common include
;===================================

.include "include/scene_common.inc"

.background "scene0D.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene0D_ovlScene.inc"
;.define enable_sceneAutoBusySkip 1
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; add sync event after cd audio
; successfully starts
;================================

.bank 0 slot 0
.orga $40CC
.section "cd sync 1" overwrite
  jsr doCdSync
.ends

.bank 0 slot 0
.section "cd sync 2" free
  doCdSync:
    ; NOTE: incrementAdpcmSyncCounter ends by calling ovlScene_jumpTable_restoreOldBanks.
    ; but we never called ovlScene_jumpTable_setUpStdBanks!
    ; this didn't cause problems in the original release due to luck,
    ; but fixing the recursion issues in setUpStdBanks/restoreOldBanks
    ; caused this to start crashing the game.
    ; since we've made the assumption that the correct banks are loaded anyway,
    ; this is now a call to incrementAdpcmSyncCounter_sub, which does the same thing
    ; without calling restoreOldBanks afterward.
;    jsr incrementAdpcmSyncCounter
    jsr incrementAdpcmSyncCounter_sub
    ; make up work
    jmp $E096
.ends

;================================
; extend idle period before going into wait loop for cd audio end
; so that subtitles have time to shut off
;================================

.bank 0 slot 0
.orga $4546
.section "cd end 1" overwrite
  ; count of frames to idle
;  lda #$78
  lda #$F0
.ends

;==============================================================================
; script
;==============================================================================

.define subOffset -3.000

.bank 0 slot 0
.section "script 1" free
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
;    cut_setHighPrioritySprObjOffset 16
    
    ; throttle subtitle processing speed to avoid vblank overruns
    ; (which will cause flicker here if forcing is off)
;    cut_writeMem maxScriptActionsPerIteration 1
;    cut_writeMem maxSpriteAttrTransfersPerIteration 1
;    cut_writeMem maxSpriteGrpTransfersPerIteration 1
    
;    cut_waitForFrame $40
    
    SYNC_adpcmTime 1 $0107
    
    ;=====
    ; wait until the time for our one and only line
    ;=====
    
;    cut_waitForFrameMinSec 1 0.000+1.000+subOffset
    
    ; "behold! el-line"
    .incbin "include/sceneD/string140000.bin"
;    cut_prepAndSendGrp $01DC
    cut_prepAndSendGrp $01E8
    
    cut_waitForFrameMinSec 1 2.380+subOffset
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 4.404+subOffset
    cut_subsOff
    
    cut_terminator
.ends





