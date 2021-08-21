
;==============================================================================
; scene 1C: credits
;==============================================================================

;.include "include/global.inc"

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

;===================================
; common include
;===================================

;.include "include/scene_mini_common.inc"

;.unbackground $3E5F+$40 $9FFF

.background "scene1C.bin"

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/scene1C_strings_overwrite.inc"

.bank 0 slot 0
.section "scene1C static strings free" free
  .include "include/scene1C_strings.inc"
.ends

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene1C_ovlScene.inc"
.include "include/scene_mini_common.inc"
.define enableSceneAutoVregProtect 1
.include "overlay/scene_mini.s"

.include "include/scene1C_ovlAdvString.inc"
.include "overlay/adv_string.s"

.define ovlText_fontLoadType fontLoadType_normal
.define ovlText_useNarrowFont 1
; this scene expects text to use palette 0x6 instead of 0xF,
; for the fade effects
.define text_overrideStdPalette 1
.define text_overridePaletteNum $6
.include "include/scene1C_ovlText.inc"
.include "overlay/text.s"

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
    
;    SYNC_setTime 0
    cut_setPalette $08
    
    SYNC_varTime 1 $82
    
    ;=====
    ; title
    ;=====
    
    cut_waitForFrame $0100
    
    ; "hajimete atta toki"
    cut_startNewString $01BC
    .incbin "include/scene1C/string290000.bin"
    
    ; 10.672 = 11.733 = 1.0613
;    cut_waitForFrameMinSec 0 15.75
;    cut_waitForFrame $3A0
;    cut_waitForFrameMinSec 0 25.973
    cut_waitForFrameMinSec 0 25.600
    cut_swapAndShowBuf
    
    ; "anata ni mitsume"
    cut_startNewString $00B0
    .incbin "include/scene1C/string290001.bin"
    
    cut_waitForFrameMinSec 0 30.796
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "kinou to chigau"
    cut_startNewString $01BC
    .incbin "include/scene1C/string290002.bin"
    
;    cut_waitForFrameMinSec 0 35.997
    cut_waitForFrame $864-$10
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "sabishi yoru ni TOUCH ME"
    cut_startNewString $00B0
    .incbin "include/scene1C/string290003.bin"
    
;      cut_waitForFrameMinSec 0 43.793
      cut_waitForFrame $A20-$10
      cut_subsOff
    
;    cut_waitForFrameMinSec 0 46.402
    cut_waitForFrame $AB0
    cut_swapAndShowBuf
    
    ; "kitsuku daite yo SHOW ME"
    cut_startNewString $01BC
    .incbin "include/scene1C/string290004.bin"
    
    cut_waitForFrame $BE8
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "daisukiyo! daisukiyo!"
    cut_startNewString $00B0
    .incbin "include/scene1C/string290005.bin"
    
    cut_waitForFrame $D20
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "minna anata ga kaeta no yo!"
    cut_startNewString $01BC
    .incbin "include/scene1C/string290006.bin"
    
      cut_waitForFrame $F26
      cut_subsOff
    
    cut_waitForFrame $F70
    cut_swapAndShowBuf
    
    ; "powaa ga dodon agate iku wa!"
    cut_startNewString $00B0
    .incbin "include/scene1C/string290007.bin"
    
;      cut_waitForFrame $1066
;      cut_subsOff
    
    cut_waitForFrame $10AE
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "IMAGINATION daisuki!"
    cut_startNewString $01BC
    .incbin "include/scene1C/string290008.bin"
    
;      cut_waitForFrame $1180
;      cut_subsOff
    
    cut_waitForFrame $11E0
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "kitsuku daite yo SHOW ME!"
    cut_startNewString $00B0
    .incbin "include/scene1C/string290009.bin"
    
    cut_waitForFrame $1304
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "watashi dake o mite ite!!"
    cut_startNewString $01BC
    .incbin "include/scene1C/string290010.bin"
    
    cut_waitForFrame $144C
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrame $1624
    cut_subsOff
    
    cut_terminator
.ends

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; cd audio sync
;================================

.bank 0 slot 0
.orga $40D0
.section "fix initial sync 1" overwrite
  jsr fixInitialSync
  nop
  nop
.ends

.bank 0 slot 0
.section "fix initial sync 2" free
  fixInitialSync:
    jsr incrementSyncVarCounter
    
    ; make up work
    smb2 $44
    jmp $E096
.ends

;================================
; clear smaller tilemap area for credits pages
; corresponding to moved position of graphics
;================================

.bank 0 slot 0
.orga $4B78
.section "credits tilemap clear width" overwrite
;  lda #$20
  lda #15
.ends

.bank 0 slot 0
.orga $4B7C
.section "credits tilemap clear height" overwrite
;  lda #$0C
  lda #$16
.ends

;================================
; add linebreak functionality to printSimpleString
;================================

.bank 0 slot 0
.orga $7A65
.section "credits linebreak 1" overwrite
  jmp doCreditsLinebreakCheck
.ends

.bank 0 slot 0
.section "credits linebreak 2" free
  doCreditsLinebreakCheck:
    ; make up work
    bne @notTerminated
      jmp $7A96
    @notTerminated:
    inc $BE
    bne +
      inc $BF
    +:
    
    ; check if linebreak
    cmp #code_linebreak
    bne @notLinebreak
      ; increment y-pos
      inc $1C
      inc $1C
      ; reset x-pos
      stz $1B
      jmp $7A61
    @notLinebreak:
    jmp $7A6D
    
.ends

;================================
; adjust credits timing for existing pages
;================================

; every original game page has its display time changed
; by this many frames.
; note that we pretty much have to do this to compensate for
; the considerable amount of additional lag introduced by
; having to render more characters for the translated credits.
.define globalCreditsPageTimeAdjustment -15

.define idle $6B81

.macro adjustCreditTime ARGS addr orig offset
  .redefine adjustCreditsTime_targetTime orig - offset + globalCreditsPageTimeAdjustment

  .bank 0 slot 0
  .orga addr
  .section "adjust credit time \@" overwrite
    .if orig > 256
      lda #(adjustCreditsTime_targetTime # $FF)
      jsr idle
      .if adjustCreditsTime_targetTime <= 256
        nop
        nop
        nop
        nop
        nop
      .else
        lda #adjustCreditsTime_targetTime - $100
        jsr idle
      .endif
    .else
      .if adjustCreditsTime_targetTime > 256
        .fail
      .endif
      
      lda #adjustCreditsTime_targetTime # $FF
      jsr idle
      
      ; for some reason they split things up like this...
      .if adjustCreditsTime_targetTime >= 128
        nop
        nop
        nop
        nop
        nop
      .endif
    .endif
  .ends
.endm

  ; "executive producer"
  adjustCreditTime $411A $78      0
  ; "voice cast"
  adjustCreditTime $4151 $78+$3C  120
  ; waiting period
  adjustCreditTime $41C7 $3C      0
  ; "lia"
  adjustCreditTime $41FE $78      0
  ; "gina"
  adjustCreditTime $4235 $3C      0
  ; "mai"
  adjustCreditTime $42D8 $3C      0
  ; "yuna's dad"
  adjustCreditTime $430F $78      0
  ; "elner"
  adjustCreditTime $4346 $3C      0
  ; "narration"
  adjustCreditTime $43E9 $3C      0
  ; "concept"
  adjustCreditTime $4420 $78      0
  ; "scenario"
  ; (no idle period, display time is tied entirely to picture fade)
;  adjustCreditTime 
  ; "visual director"
  adjustCreditTime $44F5 $78      0
  ; "artwork "
  adjustCreditTime $452C $78      0
  ; "visual setting"
  adjustCreditTime $45A3 $3C      0
  ; "queen of darkness"
  adjustCreditTime $45DA $78      0
  ; "theme song"
  adjustCreditTime $4611 $3C      30
  adjustCreditTime $467A $78+$3C  150
  ; "insert song"
  adjustCreditTime $46B6 $78      0
  ; "ending theme song"
  adjustCreditTime $472D $78      0
  ; "programming"
  ; (gee, someone sure felt like they deserved to be lingered on)
  adjustCreditTime $4764 $78+$3C  150
  ; "course data"
  adjustCreditTime $4804 $78      0
  ; "graphics"
  adjustCreditTime $483B $78      0
  ; "sound"
  adjustCreditTime $48DE $3C      0
  ; "special thanks"
  adjustCreditTime $4915 $78      0
  ; "aoni production co"
  adjustCreditTime $49B8 $3C      0
  ; "red company"
  adjustCreditTime $49EF $78      0
  ; "producer"
  adjustCreditTime $4A66 $78+$3C  150+10
  ; "produced by"
  adjustCreditTime $4AA2 $78      0

;================================
; extra page for translation credits
;================================

.define showCreditsPage $4B6E
.define waitForFrame $6C75
.define clearTilemapArea $83EC

.define newCreditsPageStringAddr $50D3

/*.bank 0 slot 0
.orga $411F
.section "extra credits page test" overwrite
  jmp $4AA7
.ends */

.bank 0 slot 0
.orga $4ABC
.section "extra credits page 1" overwrite
  jmp doExtraCreditsPage
.ends

.bank 0 slot 0
.section "extra credits page 2" free
  doExtraCreditsPage:
    ; ?
    stz $000B
    ; ?
    lda #$02
    sta $000C
    ; credits page spec pointer
    lda #<extraCreditsPageDef
    sta $000D
    lda #>extraCreditsPageDef
    sta $000E
    ; ?
    lda #$0F
    sta $000F
    
    jsr showCreditsPage
    
    ; ?
    tii $8B90,$2992,$0020
    jsr EX_BGON
    jsr waitForFrame
    
    ; fade in?
    lda #$06
    sta $00F8
    lda #$01
    sta $00FA
    jsr $7338
    
    lda #180
    jsr idle
    
    ; fade out?
    jsr $73A5
    jsr EX_DSPOFF
    jsr waitForFrame
    
    ; clear tilemap
    ; tile number?
    stz $29
    lda #$02
    sta $2A
    ; w
    lda #$20
    sta $1C
    ; h
;    lda #$0C
    lda #$18
    sta $1D
    jsr clearTilemapArea
    
    ; make up work
    lda #$00
    sta $00CB
    jmp $4AC0
  
  extraCreditsPageDef:
    ; ???
    .db $08
    .dw newCreditsPageStringAddr
    ; null strings
    .rept 5
      .dw $4D9C
    .endr
.ends

;================================
; replace credits pages
;================================

.define creditsPageBaseOffset $4C4A

.macro replaceCreditsPage ARGS pageNum, firstPage
  .bank 0 slot 0
  .orga creditsPageBaseOffset+(pageNum*$D)+1
  .section "credits page replace \@" overwrite
    .dw firstPage
    ; null strings
    .rept 5
      .dw $4D9C
    .endr
  .ends  
.endm

  replaceCreditsPage 0, $4D9D
  replaceCreditsPage 1, $4DAB
  replaceCreditsPage 2, $4DC7
  replaceCreditsPage 3, $4DD3
  replaceCreditsPage 4, $4DFA
  replaceCreditsPage 5, $4E20
  replaceCreditsPage 6, $4E44
  replaceCreditsPage 7, $4E68
  replaceCreditsPage 8, $4E8D
  replaceCreditsPage 9, $4EB0
  replaceCreditsPage 10, $4ED5
  replaceCreditsPage 11, $4EFC
  replaceCreditsPage 12, $4F22
  replaceCreditsPage 13, $4F45
  replaceCreditsPage 14, $4F6B
  replaceCreditsPage 15, $4F8E
  replaceCreditsPage 16, $4FB6
  replaceCreditsPage 17, $4FE0
  replaceCreditsPage 18, $5006
  replaceCreditsPage 19, $502A
  replaceCreditsPage 20, $5042
  replaceCreditsPage 21, $505C
  replaceCreditsPage 22, $5067
  replaceCreditsPage 23, $5081
  replaceCreditsPage 24, $509F
  replaceCreditsPage 25, $50B9
/*  replaceCreditsPage 26, $50D3
  replaceCreditsPage 27, $50EE
  replaceCreditsPage 28, $510C
  replaceCreditsPage 29, $5121
  replaceCreditsPage 30, $513A
  replaceCreditsPage 31, $5155
  replaceCreditsPage 32, $516F
  replaceCreditsPage 33, $517B
  replaceCreditsPage 34, $5199
  replaceCreditsPage 35, $51B7
  replaceCreditsPage 36, $51DA
  replaceCreditsPage 37, $5205
  replaceCreditsPage 38, $5222
  replaceCreditsPage 39, $5247
  replaceCreditsPage 40, $525C
  replaceCreditsPage 41, $5271
  replaceCreditsPage 42, $5298
  replaceCreditsPage 43, $52A1
  replaceCreditsPage 44, $52C4
  replaceCreditsPage 45, $52E1
  replaceCreditsPage 46, $52FE
  replaceCreditsPage 47, $531D
  replaceCreditsPage 48, $533C
  replaceCreditsPage 49, $5353
  replaceCreditsPage 50, $5372
  replaceCreditsPage 51, $538F
  replaceCreditsPage 52, $53AC
  replaceCreditsPage 53, $53CB
  replaceCreditsPage 54, $53EA
  replaceCreditsPage 55, $53F8
  replaceCreditsPage 56, $5407
  replaceCreditsPage 57, $5422
  replaceCreditsPage 58, $5432
  replaceCreditsPage 59, $5441
  replaceCreditsPage 60, $5462 */

