
;==============================================================================
; INCLUDED PATCHES
;==============================================================================



;==============================================================================
; other modifications specific to this executable
;==============================================================================

;===================================
; jump table + interface
;===================================

.bank 0 slot 0
.orga ovlBoot_newCodeBase
.section "scene common interface 1" overwrite
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
    tma #$20
    sta restoreOldBanks@slot5+1.w
    
    lda #ovlBoot_extraPagesBase
    tam #$08
    ina
    tam #$10
    ina
    tam #$20
    
    rts
  
  restoreOldBanks:
    @slot3:
    lda #$00
    tam #$08
    @slot4:
    lda #$00
    tam #$10
    @slot5:
    lda #$00
    tam #$20
    
    rts
;.endb
.ends

/*.bank 0 slot 0
.section "scene common interface 2" free
  setUpStdBanks:
    tma #$08
    sta restoreOldBanks@slot3+1.w
    tma #$10
    sta restoreOldBanks@slot4+2.w
    tma #$20
    sta restoreOldBanks@slot4+3.w
    
    ; FIXME: directly specifying the page like this is not best practice,
    ; but probably doesn't actually matter
    lda #$83
    tam #$08
    ina
    tam #$10
    ina
    tam #$20
    
    rts
  
  restoreOldBanks:
    @slot3:
    lda #$00
    tam #$08
    @slot4:
    lda #$00
    tam #$10
    @slot5:
    lda #$00
    tam #$20
    
    rts
.ends*/

/*.bank 0 slot 0
.orga $5284
.section "test 1" overwrite
  jsr syncTest
.ends

.bank 0 slot 0
.section "test 2" free
  syncFrameCounter:
    .dw $00
  
  syncTest:
    ; increment frame counter
    inc syncFrameCounter+0.w
    bne +
      inc syncFrameCounter+1.w
    +:
    
    ; make up work
    jmp $5139
.ends */
