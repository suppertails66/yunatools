
;.include "include/global.inc"

/*.memorymap
   defaultslot     0
   ; ROM area
   slotsize        $2000
   slot            0       $0000
   slot            1       $2000
   slot            2       $4000
   slot            3       $6000
   slot            4       $8000
   slot            5       $A000
   slot            6       $C000
   slot            7       $E000
.endme */

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

.background "subintro_2.bin"

; 2416 bytes
.unbackground $3690 $3FFF

.include "include/subintro_ovlScene.inc"
.include "include/scene_mini_common.inc"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

.include "overlay/scene_mini.s"

; TODO: so here's an interesting point of fact:
; the timing of the CD audio against this scene is different
; if you sit through the full game intro beforehand compared
; to if you skip it (in both original game and hack).
; CD drive head position issue? does mednafen actually emulate that??

; - if skipped, after the CD_PLAY command is issued,
;   sync counter is $14A
; - if not skipped, after the CD_PLAY command is issued,
;   sync counter is $13E

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; DEBUG: skip intro
;================================

/*.bank 0 slot 0
.orga $4015
.section "skip intro 2" overwrite
  jmp $48AF
.ends */

;================================
; ugh
;================================

/*.bank 0 slot 0
.orga $448E
.section "fix 1" overwrite
  nop
  nop
  nop
  nop
  nop
  nop
.ends */

; TODO: replace all BIOS "display off" commands with "bg off"?
; and remove "sprite off"s?

/*.bank 0 slot 0
.orga $4534
.section "fix 1" overwrite
  jsr fixRiaPortrait
.ends

.bank 0 slot 0
.section "fix 2" free
  fixRiaPortrait:
    inc noSubtitleSatbThisFrame.w
    
    ; make up work
    jsr $5159
    
    stz noSubtitleSatbThisFrame.w
    
    rts
.ends */

/*.bank 0 slot 0
.orga $4502
.section "fix 1" overwrite
  nop
  nop
  nop
.ends

.bank 0 slot 0
.orga $4511
.section "fix 2" overwrite
  nop
  nop
  nop
.ends */

;================================
; when loading the resources for the scene with yuna's cruiser
; blasting off into the distance, the original game installs
; some scanline interrupts, then does all the graphics loading.
; however, these interrupts are apparently active and attempting
; to do stuff throughout the loading, which leads to visible
; artifacting and/or outright load errors when combined with our
; modifications (e.g. having sprite display enabled during this scene).
; to circumvent this, we simply reverse the order of operations here
; so the graphics are loaded before the interrupts are activated.
;================================

.define setScreenSize $5C71
.define setBgXy $6254
.define loadGrpProbably $5159
.define installScanlineVec0 $7632
.define installScanlineVec1 $7643

.bank 0 slot 0
.orga $44F4
.section "fix 1" SIZE $43 overwrite
/*  ; ?
  stz $0044
  lda #$2F
  sta $00F8
  lda #$72
  sta $00FA
  lda #$4D
  sta $00FB
  jsr installScanlineVec0
  ; ?
  lda #$AF
  sta $00F8
  lda #$81
  sta $00FA
  lda #$4D
  sta $00FB
  jsr installScanlineVec1  
  ; ?
  lda #$04
  jsr setScreenSize
  ; ?
  stz $00F8
  stz $00F9
  lda #$D0
  sta $00FA
  lda #$00
  sta $00FB
  jsr setBgXy
  ; ?
  ; loading (glitched graphics if sprites on)
  lda #$00
  sta $00C0
  lda #$04
  sta $00F8
  lda #$07
  sta $00F9
  jsr loadGrpProbably */
  
  ; ?
  lda #$04
  jsr setScreenSize
  ; ?
  stz $00F8
  stz $00F9
  lda #$D0
  sta $00FA
  lda #$00
  sta $00FB
  jsr setBgXy
  ; ?
  ; loading (glitched graphics if sprites on)
  lda #$00
  sta $00C0
  lda #$04
  sta $00F8
  lda #$07
  sta $00F9
  jsr loadGrpProbably
  ; ?
  stz $0044
  lda #$2F
  sta $00F8
  lda #$72
  sta $00FA
  lda #$4D
  sta $00FB
  jsr installScanlineVec0
  ; ?
  lda #$AF
  sta $00F8
  lda #$81
  sta $00FA
  lda #$4D
  sta $00FB
  jsr installScanlineVec1
.ends

;================================
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================

/*  fixSprOff $41D2
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

  ; initial scroll up finished, logo comes in
  fixSprOff $41D2
  ; 2: title logo off
  fixDspOffWithSprClrAndSync_doVarSync $4252
  ; 3
  fixDspOff_doVarSync $42C6
  ; 4: yuna + elner portrait off
  fixDspOffWithSprClrAndSync_doVarSync $431F
  ; 5
  fixDspOffWithSprClrAndSync_doVarSync $43F8
  ; 6
  fixDspOffWithSprClrAndSync_doVarSync $448B
  ; 7
  fixDspOffWithSprClrAndSync_doVarSync $44EB
  ; 8
  fixDspOffWithSprClrAndSync_doVarSync $4572
  ; 9
  fixDspOff_doVarSync $468F
  ; 10
  fixDspOffWithSprClrAndSync_doVarSync $46EC
  ; 11
  fixDspOffWithSprClrAndSync_doVarSync $4745
  ; 12
  fixDspOffWithSprClrAndSync_doVarSync $4771
  ; 13
  fixDspOffWithSprClrAndSync_doVarSync $479B
  ; 14
  fixDspOffWithSprClrAndSync_doVarSync $47D9
  ; 15
  fixDspOffWithSprClrAndSync_doVarSync $485F

/*.bank 0 slot 0
.orga $4252
.section "test 1" overwrite
  jsr $755D
  jsr $5C8D
  jsr EX_BGOFF
.ends */

.bank 0 slot 0
.orga $41B2
.section "fix initial sync 1" overwrite
  jsr fixInitialSync
  nop
.ends

.bank 0 slot 0
.section "fix initial sync 2" free
  fixInitialSync:
    jsr incrementSyncVarCounter
    
    ; make up work
    smb0 $66
    smb2 $44
    rts
.ends

/*.bank 0 slot 0
.orga $48EA
.section "test 1" overwrite
  jsr test
.ends

.bank 0 slot 0
.section "test 2" free
  test:
    ; make up work
    jsr $E081
    
;    stz $0C01
    rts
.ends */



;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free
  
  subtitleScriptData:
  
    ;=====
    ; init
    ;=====
    
    cut_setPalette $08
    
    ; theoretically, this should be the only sync point we need...
    ; there's no CD loading beyond the initial setup since CD audio
    ; plays throughout the sequence.
    ; though i'm sure some some PCE archwizard could explain to me
    ; that there are actually a bazillion potential sources of
    ; error in this entirely linear sequence.
    ; SUCH AS THE TIMER I JUST SPENT MANY HOURS REALIZING NEEDED
    ; TO BE DISABLED.
    SYNC_varTime 1 $13E
  
    ;=====
    ; we can't send anything too early or it screws up the game's
    ; regular graphics loading, so idle until it's safe to proceed
    ;=====
    
;    cut_waitForFrame $0140
    cut_waitForFrame $0300
  
    ;=====
    ; title
    ;=====
    
    ; "galaxy fraulein legend yuna"
    cut_startNewString $01BC
    .incbin "include/subintro/string300015.bin"
    
    cut_waitForFrame $034F
    cut_swapAndShowBuf
    
;    cut_waitForFrame $03E0

;    cut_queueSubsOff $03D8
  
    ;=====
    ; song start
    ;=====
    
    ; "senoku no hoshi"
;    cut_startNewString $01DC
;    cut_startNewString $01E2
    cut_startNewString $01E0
    .incbin "include/subintro/string300000.bin"
    
    cut_waitForFrame $0420
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "watashi wa atsui"
    cut_startNewString $01BC
    .incbin "include/subintro/string300001.bin"
    
;    SYNC_varTime 2 $431
    
    cut_waitForFrame $0530
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_queueSubsOff $05D8
    
    cut_startNewString $01DC
    ; "senoku no fuku"
    ; (we're so tight on space that i had to split this string
    ; across sections to make it work)
;    .incbin "include/subintro/string300002.bin" READ 3
    ; no space!!
    ; see bootloader_7 for the rest
    cut_jump ovlScene_subtitleScriptData

.ends

;.define subtitleScriptData ovlScene_subtitleScriptData
