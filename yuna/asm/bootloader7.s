
;==============================================================================
; bootloader 7 - subintro
;==============================================================================

;.include "include/bootloader_common.inc"


; i tried to avoid doing this, i really did!!



; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $800
   slot            0       $3800
.endme

.rombankmap
  bankstotal $1
  
  banksize $800
  banks $1
.endro

.emptyfill $FF



.background "bootloader7_A981.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

.define ovlBoot_newCodeBase $3885
; this scene uses a weird memory mapping
.define ovlBoot_extraPagesBase $86

;.include "overlay/bootloader.s"



.include "include/scene_mini_common.inc"

;===================================
; jump table + interface
;===================================

;.redefine SYNC_time $431

.bank 0 slot 0
.orga ovlBoot_newCodeBase
.section "scene common interface 1" SIZE $77B overwrite
;.block "bootloader addendum"
  ;===================================
  ; jump table
  ;===================================
  
  ; 0
  jmp setUpStdBanks
  ; 1
  jmp restoreOldBanks
  ; 2
;  jmp doHighPrioritySpriteObjOffset
  
  ;===================================
  ; font
  ;===================================
  
  font:
    .incbin "out/font/font_scene.bin"
  fontWidthTable:
    .incbin "out/font/fontwidth_scene.bin"
  
  ; lookup table for font.
  ; this isn't necessary (it's just encoding a multiplication by 10)
  ; but saves having to manually compute it and deal with saving
  ; the $29/$2B math registers in the sync interrupt handler
  fontLut:
    .rept numSceneFontChars INDEX count
      .dw font+(count*bytesPerSceneFontChar)
    .endr
  
  subtitleScriptData:
    SYNC_setTime $13E
    
    ; "senoku no fuku"
;    .incbin "include/subintro/string300002.bin" SKIP 3
    .incbin "include/subintro/string300002.bin"
    
;      SYNC_varTime 3 $564
    
  ;    cut_queueSubsOff $0612
    
    cut_waitForFrame $0675
;    cut_subsOff
    cut_swapAndShowBuf
    
;    SYNC_varTime 4 $69B
    
    ; "watashi wa tobu wa"
    cut_startNewString $01BC
    .incbin "include/subintro/string300003.bin"
    
    cut_waitForFrame $07A0-8
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_queueSubsOff $086C
    
    ; "doudemoii koto nanka"
    cut_startNewString $01E4
    .incbin "include/subintro/string300004.bin"
    
;    cut_waitForFrame $0895
    cut_waitForFrame $08B4
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "anata niwa"
    cut_startNewString $01CA
    .incbin "include/subintro/string300005.bin"
    
    cut_waitForFrame $0A1C
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "atarashii sekai ga"
    cut_startNewString $0180+$14
    .incbin "include/subintro/string300006.bin"
    
    ; coming in pretty tight on a loading transition here...
    ; better to hit this slightly too early, because if it's
    ; even a little too late, it'll get delayed by a lot
    cut_waitForFrame $0AA0-1
    cut_subsOff
    cut_swapAndShowBuf
    
/*    ; "hikari no shower"
    cut_startNewString $01A8
    .incbin "include/subintro/string300007.bin"
    
      ; oh my gooooood this fucking scene
      ; i sure hope mednafen's timing is absolutely spot-on
      ; and its emulation of hardware quirks is flawless
      ; because otherwise this IS going to screw up on a real machine somehow.
      ; and probably every single other scene in the game too.
;      cut_waitForFrame $0BA0
;      cut_subsOffNoClear
      
;      cut_waitForFrame $0BB4
;      cut_subsOnNoClear
      
      cut_waitForFrame $0C2C
      cut_subsOff
    
    cut_waitForFrame $0C84
    cut_swapAndShowBuf
    
    ; "anata no mono yo"
    cut_startNewString $01D0
    .incbin "include/subintro/string300009.bin"
    
    cut_waitForFrame $0DAC
    cut_subsOff
    cut_swapAndShowBuf */
    
    ; the commented-out code above displays the two spoken (parenthesized)
    ; lyrics as part of their "parent" lines.
    ; however, the use of sprites in the "anata no mono yo" line means that if
    ; we do that, we're forced to put a linebreak in the transcription
    ; in a somewhat awkward place (between "DREAMING" and "GIRL") to avoid
    ; exceeding the sprites-per-line limit.
    ; so, this version instead splits those off into separate lines.
    
    ; "hikari no shower"
    cut_startNewString $01A8
    .incbin "include/subintro/string300007.bin"
      
      cut_waitForFrame $0C2C
      cut_subsOff
    
    cut_waitForFrame $0C84-1
    cut_swapAndShowBuf
    
    ; "(majide hageshiku)"
    cut_startNewString $01D0
    .incbin "include/subintro/string300008.bin"
    
    cut_waitForFrame $0D48
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "anata no mono yo"
    cut_startNewString $01A8
    .incbin "include/subintro/string300009.bin"
    
    cut_waitForFrame $0DAC
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "(majide yasashiku)"
    cut_startNewString $01D0
    .incbin "include/subintro/string300010.bin"
    
    cut_waitForFrame $0E68
    cut_subsOff
    cut_swapAndShowBuf
    
    
    
    ; "mou risetto wa"
    cut_startNewString $0190
    .incbin "include/subintro/string300011.bin"
    
    cut_waitForFrame $0EB6-8
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wasurenaide watashi"
    cut_startNewString $01D0
    .incbin "include/subintro/string300012.bin"
    
    cut_waitForFrame $0F4F
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "(yuna...kimi ga)"
    cut_startNewString $01B0
    .incbin "include/subintro/string300013.bin"
    
    cut_waitForFrame $102E-44
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "wasurenaide watashi"
;    cut_startNewString $0190
    cut_startNewString $01D0
    .incbin "include/subintro/string300014.bin"
    
;    cut_waitForFrame $1058
    cut_waitForFrame $1098+8
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrame $1192
    cut_subsOff
    
    cut_terminator
  
/*  doHighPrioritySpriteObjOffset:
    ; subtract raw offset from max sprite count
    sec
    sbc highPrioritySpriteObjGenerationOffset.w
    sta $003B
    
    ; offset target VRAM position accordingly
    lda highPrioritySpriteObjGenerationOffset.w
    asl
    asl
    sta 
    
    ; make up work
    tma #$40
    rts
  
  ; any high-priority sprite objects the game generates will be offset
  ; from their normal position in the SAT by this many attribute entries
  highPrioritySpriteObjGenerationOffset:
    .db $00 */
  
  ;===================================
  ; extra code
  ;===================================
  
  setUpStdBanks:
    tma #$08
    sta restoreOldBanks@slot3+1.w
    tma #$10
    sta restoreOldBanks@slot4+1.w
;    tma #$20
;    sta restoreOldBanks@slot5+1.w
    
    lda #ovlBoot_extraPagesBase
    tam #$08
    ina
    tam #$10
;    ina
;    tam #$20
    
    rts
  
  restoreOldBanks:
    @slot3:
    lda #$00
    tam #$08
    @slot4:
    lda #$00
    tam #$10
;    @slot5:
;    lda #$00
;    tam #$20
    
    rts
;.endb
.ends


;==============================================================================
; other modifications specific to this executable
;==============================================================================



