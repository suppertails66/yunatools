
;==============================================================================
; title screen
;==============================================================================

;.include "include/global.inc"

;.unbackground $3690 $3FFF

; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $A000
   slot            0       $4000
.endme

.rombankmap
  bankstotal $1
  
  banksize $A000
  banks $1
.endro

.emptyfill $FF

.background "title_202.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

.include "include/title_ovlScene.inc"
.include "include/scene_mini_common.inc"

.include "overlay/scene_mini.s"

.define ovlText_fontLoadType fontLoadType_normal
.include "include/title_ovlText.inc"
.include "overlay/text.s"

.include "include/title_ovlAdvString.inc"
.include "overlay/adv_string.s"

;===================================
; new hardcoded strings
;===================================

.include "include/system_title_strings_overwrite.inc"

.bank 0 slot 0
.section "system_title static strings free" free
  .include "include/system_title_strings.inc"
.ends

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================

/*  fixSprOff $41D2

  ; FIXME: this is supposed to hide the title logo.
  ; it should occur on the same frame as the bg blackout,
  ; but since we're forcing sprites on for the subtitles,
  ; it ends up kicking in a frame too late
  fixDspOffWithSprClrAndSync $4252
;  fixDspOff $4252
  fixDspOff $42C6
  fixDspOffWithSprClrAndSync $431F
  fixDspOffWithSprClrAndSync $43F8
  fixDspOffWithSprClrAndSync $448B
  fixDspOffWithSprClrAndSync $44EB
  fixDspOffWithSprClrAndSync $4572
  fixDspOff $468F
  fixDspOffWithSprClrAndSync $46EC
  fixDspOffWithSprClrAndSync $4745
  fixDspOffWithSprClrAndSync $4771
  fixDspOffWithSprClrAndSync $479B
  fixDspOffWithSprClrAndSync $47D9
  fixDspOffWithSprClrAndSync $485F */

/*.bank 0 slot 0
.orga $4252
.section "test 1" overwrite
  jsr $755D
  jsr $5C8D
  jsr EX_BGOFF
.ends */

;================================
; load new title logo graphics
;================================

.define newTitleLogoGrpVramDst $3000

.bank 0 slot 0
.orga $40D8
.section "title logo 1" overwrite
  jsr loadNewTitleLogoGrp
.ends

.bank 0 slot 0
.section "title logo 2" free
  newTitleLogoGrp:
    .incbin "out/grp/title_logo.bin" FSIZE newTitleLogoGrp_size
  
  loadNewTitleLogoGrp:
    ; make up work
    jsr $6CAB
    
    ; refresh display
    jsr waitForSync
    
    jsr EX_IRQOFF
;      st0 #$00
;      st1 #<newTitleLogoGrpVramDst
;      st2 #>newTitleLogoGrpVramDst
;      st0 #$02
      
      lda #<newTitleLogoGrpVramDst
      ldx #>newTitleLogoGrpVramDst
      ; EX_SETWRT
      jsr $E0AE
      
      rmb6 $00F5
        tia newTitleLogoGrp,$0002,newTitleLogoGrp_size
      smb6 $00F5
    jsr EX_IRQON
    
    rts
.ends

;================================
; ensure the screen is correctly cleared when we exit the title
; (by selecting a menu option, waiting out the music, etc.).
; by default, our subtitles will override the game's attempt
; to turn off sprites using EX_DSPOFF, so we need to make sure
; that doesn't happen
;================================

.bank 0 slot 0
.section "exit fix 1" free
  doExitFix:
    ; jump script to end so we don't get any surprises
    sei
      lda #<scriptEnd
      sta subtitleScriptPtr.w
      lda #>scriptEnd
      sta subtitleScriptPtr.w
    cli
    
    ; subtitles off
    stz subtitleDisplayOn.w
    
    ; set up sprite clear (which will now include
    ; the subtitles because they're turned off) 
    jsr clearAndSendSubtitleExclusionOverwrite
    
    ; refresh display
    jsr waitForSync
    
    ; turn screen off
    jmp EX_DSPOFF
.ends

; "continue"
.bank 0 slot 0
.orga $4243
.section "exit fix 2" overwrite
  jsr doExitFix
  nop
  nop
  nop
.ends

; debug menu
.bank 0 slot 0
.orga $4286
.section "exit fix 3" overwrite
  jsr doExitFix
  nop
  nop
  nop
.ends

; "new game"
.bank 0 slot 0
.orga $42BF
.section "exit fix 4" overwrite
  jsr doExitFix
  nop
  nop
  nop
.ends

; resetting to opening scene
.bank 0 slot 0
.orga $42FD
.section "exit fix 5" overwrite
  jsr doExitFix
  nop
  nop
  nop
.ends

;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free
  
  subtitleScriptData:
  
/*    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    cut_waitForFrame $0100
    .incbin "include/scene18/string250000.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 6.000
    cut_swapAndShowBuf */
  
    ;=====
    ; init
    ;=====
    
;    cut_setHighPrioritySprObjOffset 16
    
    SYNC_setTime 8
    cut_setPalette $08
  
    ;=====
    ; title
    ;=====
    
    cut_waitForFrame $0100
    
    ; "one two three go"
    ; (omitted: aside from being in english already,
    ; i don't think this is technically part of the official lyrics.
    ; though i'll confess i haven't bought the album to check.)
;    cut_startNewString $01BC
;    .incbin "include/title/string310000.bin"
    
    ; 10.672 = 11.733 = 1.0613
;    cut_waitForFrameMinSec 0 11.733
;    cut_swapAndShowBuf
    
;    cut_waitForFrameMinSec 0 13.647
;    cut_subsOff
    
    ; "konna ni kanashisugite"
    cut_startNewString $01DC
    .incbin "include/title/string310001.bin"
    
    cut_waitForFrameMinSec 0 25.660
    cut_swapAndShowBuf
    
    ; "namida ga tomaranaino"
    cut_startNewString $01BC
    .incbin "include/title/string310002.bin"
    
    cut_waitForFrameMinSec 0 30.689
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "anata no kotoba"
    cut_startNewString $01DC
    .incbin "include/title/string310003.bin"
    
    cut_waitForFrameMinSec 0 37.684
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "mitomeruno ga kowakatta"
    cut_startNewString $01BC
    .incbin "include/title/string310004.bin"
    
    cut_waitForFrameMinSec 0 42.753
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "umaku todokanai"
    cut_startNewString $01DC
    .incbin "include/title/string310005.bin"
    
    cut_waitForFrameMinSec 0 48.772
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ano hi yorisotta"
    cut_startNewString $01BC
    .incbin "include/title/string310006.bin"
    
    cut_waitForFrameMinSec 0 54.778
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "nukumori dake wa"
    cut_startNewString $01DC
    .incbin "include/title/string310007.bin"
    
    cut_waitForFrameMinSec 0 58.157
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "burning love datte"
    cut_startNewString $01BC
    .incbin "include/title/string310008.bin"
    
    cut_waitForFrameMinSec 1 3.806
    cut_subsOff
    cut_swapAndShowBuf
    
    ; why is the timing drifting...?
    ; is the game lagging on this near-motionless screen?
    ; is this some dumb "oh the system actually runs at 59.999 FPS" thing?
    
    ; "motto motto sakenderu"
    cut_startNewString $01DC
    .incbin "include/title/string310009.bin"
    
    cut_waitForFrameMinSec 1 6.802-0.05
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "itsudemo watashi dake"
    cut_startNewString $01BC
    .incbin "include/title/string310010.bin"
    
    cut_waitForFrameMinSec 1 10.366-0.1
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "burning heart atsui"
    cut_startNewString $01DC
    .incbin "include/title/string310011.bin"
    
    cut_waitForFrameMinSec 1 15.818-0.1
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "zutto zutto tomaranai"
    cut_startNewString $01BC
    .incbin "include/title/string310012.bin"
    
    cut_waitForFrameMinSec 1 19.025-0.25
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "kono omoi tsutaeruno"
    cut_startNewString $01DC
    .incbin "include/title/string310013.bin"
    
    cut_waitForFrameMinSec 1 22.417-0.2
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "p.s. i love you"
    cut_startNewString $01BC
    .incbin "include/title/string310014.bin"
    
    cut_waitForFrameMinSec 1 26.324-0.2
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 31.554-0.2
    cut_subsOff
    
    scriptEnd:
      cut_terminator
.ends

;.define subtitleScriptData ovlScene_subtitleScriptData
