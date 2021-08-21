
;==============================================================================
; title screen sprite definitions
;==============================================================================

.include "include/global.inc"

;.unbackground $3690 $3FFF

; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $2000
   slot            0       $0000
.endme

.rombankmap
  bankstotal $1
  
  banksize $2000
  banks $1
.endro

.emptyfill $00

.background "title_spritedef.bin"

;==============================================================================
; macros
;==============================================================================

; absolute base position of upper-left corner of our new logo
.define newLogoBaseX 119+32
.define newLogoBaseY 64+64

; offset of the spinning heart from original position
.define heartXOffset -36+1
.define heartYOffset 28-2

; offset of the "galaxy fraulein" text from original position
.define sublogoXOffset -5
.define sublogoYOffset 0

.macro generateSpriteFlags ARGS w h pal
  .dw (w<<8)|(h<<12)|pal
.endm

.macro generateSpriteAttr ARGS x y patnum w h pal
  .dw y
  .dw x
  .dw patnum
  generateSpriteFlags w h pal
.endm

.macro generateStdBigSpriteAttr ARGS x y patnum pal
  generateSpriteAttr x y patnum 1 2 pal
.endm

.macro generateNewTitleLogo ARGS palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*0) newLogoBaseY+(spritePatternH*4*0) $00B0 palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*1) newLogoBaseY+(spritePatternH*4*0) $00C0 palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*2) newLogoBaseY+(spritePatternH*4*0) $00D0 palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*3) newLogoBaseY+(spritePatternH*4*0) $00E0 palette
  
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*0) newLogoBaseY+(spritePatternH*4*1) $00F0 palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*1) newLogoBaseY+(spritePatternH*4*1) $0100 palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*2) newLogoBaseY+(spritePatternH*4*1) $0110 palette
  generateStdBigSpriteAttr newLogoBaseX+(spritePatternW*2*3) newLogoBaseY+(spritePatternH*4*1) $0120 palette
.endm

;==============================================================================
; sprite defs
;==============================================================================

; HACK: fuck this stupid fucking screen.
; we read this back from the file while building because it has to go
; on a completely different part of the disc, and this is easier than
; trying to link that in with this.

.bank 0 slot 0
.org $1FFE
.section "sprite defs palette hack" overwrite
  .dw paletteChunk
.ends

.bank 0 slot 0
.org $1000
.section "sprite defs 1" overwrite
  ;======================
  ; SPRITE STATE 0
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108C

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118C

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118C

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118C

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 1
  ;======================

/*    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108C

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108C

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118C

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108C

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318C

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $0090
    ; patnum
    .dw $0006
    ; flags
    .dw $008C

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008C

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118C

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318C

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018C */
  
    generateNewTitleLogo 12

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 2
  ;======================

/*    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108C

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108C

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118C

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108C

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318C

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $0090
    ; patnum
    .dw $0006
    ; flags
    .dw $008C

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008C

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118C

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318C

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018C */
  
    generateNewTitleLogo 12

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108C

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118C

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118C

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118C

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 3
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008C

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018C

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018C

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018C

/*    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108C

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108C

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118C

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108C

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318C

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008C

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118C

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318C

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018C */
  
    generateNewTitleLogo 12

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108C

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118C

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118C

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118C

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 4
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008D

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018D

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018D

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018D

/*    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108D

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108D

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118D

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108D

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318D

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008D

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118D

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318D

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018D */
  
    generateNewTitleLogo 13

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108D

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118D

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118D

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118D

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 5
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008E

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018E

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018E

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018E

/*    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108E

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108E

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118E

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108E

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318E

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008E

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118E

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318E

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018E */
  
    generateNewTitleLogo 14

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108E

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118E

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118E

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118E

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 6
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 7
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00BE+heartYOffset
    ; x
    .dw $00EE+heartXOffset
    ; patnum
    .dw $0070
    ; flags
    .dw $118F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 8
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00BE+heartYOffset
    ; x
    .dw $00EE+heartXOffset
    ; patnum
    .dw $0078
    ; flags
    .dw $118F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 9
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00BE+heartYOffset
    ; x
    .dw $00EE+heartXOffset
    ; patnum
    .dw $0080
    ; flags
    .dw $118F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 10
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00BE+heartYOffset
    ; x
    .dw $00EE+heartXOffset
    ; patnum
    .dw $0088
    ; flags
    .dw $118F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 11
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00BE+heartYOffset
    ; x
    .dw $00EE+heartXOffset
    ; patnum
    .dw $0090
    ; flags
    .dw $118F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 12
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $004C
    ; flags
    .dw $008F

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $00BE+heartYOffset
    ; x
    .dw $00EE+heartXOffset
    ; patnum
    .dw $0098
    ; flags
    .dw $118F

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0048
    ; flags
    .dw $018F

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0044
    ; flags
    .dw $018F

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00B0+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0040
    ; flags
    .dw $018F

/*    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00A0
    ; x
    .dw $0100
    ; patnum
    .dw $006A
    ; flags
    .dw $108F

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00B0
    ; patnum
    .dw $0038
    ; flags
    .dw $108F

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00D0
    ; x
    .dw $00C0
    ; patnum
    .dw $0030
    ; flags
    .dw $118F

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $003A
    ; flags
    .dw $108F

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $0010
    ; flags
    .dw $318F

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0090
    ; patnum
    .dw $0004
    ; flags
    .dw $008F

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $00B0
    ; x
    .dw $00A0
    ; patnum
    .dw $0008
    ; flags
    .dw $118F

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00C0
    ; patnum
    .dw $0020
    ; flags
    .dw $318F

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0090
    ; x
    .dw $00A0
    ; patnum
    .dw $0000
    ; flags
    .dw $018F */
  
    generateNewTitleLogo 15

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0090+sublogoXOffset
    ; patnum
    .dw $0068
    ; flags
    .dw $108F

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0070+sublogoXOffset
    ; patnum
    .dw $0060
    ; flags
    .dw $118F

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0050+sublogoXOffset
    ; patnum
    .dw $0058
    ; flags
    .dw $118F

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0090+sublogoYOffset
    ; x
    .dw $0030+sublogoXOffset
    ; patnum
    .dw $0050
    ; flags
    .dw $118F

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 13
  ; (note: the fullscreen flash effect)
  ;======================

    ;==========
    ; sprite 0
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $0100
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 1
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $00E0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 2
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $00C0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 3
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $00A0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 4
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0100
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 5
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00E0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 6
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00C0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 7
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $00A0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 8
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $0100
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 9
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00E0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 10
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00C0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 11
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $00A0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 12
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $0100
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 13
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $00E0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 14
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $00C0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 15
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $00A0
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 16
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $0080
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 17
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $0060
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 18
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $0040
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 19
    ;==========
    ; y
    .dw $0100
    ; x
    .dw $0020
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 20
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0080
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 21
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0060
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 22
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0040
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 23
    ;==========
    ; y
    .dw $00C0
    ; x
    .dw $0020
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 24
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $0080
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 25
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $0060
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 26
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $0040
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 27
    ;==========
    ; y
    .dw $0080
    ; x
    .dw $0020
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 28
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $0080
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 29
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $0060
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 30
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $0040
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

    ;==========
    ; sprite 31
    ;==========
    ; y
    .dw $0040
    ; x
    .dw $0020
    ; patnum
    .dw $00A0
    ; flags
    .dw $318C

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 14
  ;======================

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; SPRITE STATE 15
  ;======================

  ; terminator
  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

  ;======================
  ; remainder 
  ;======================
  paletteChunk:
  .db $04,$00,$00,$00,$01,$00,$F8,$01,$F8,$01,$F8,$01,$F8,$01,$C7,$01
  .db $C7,$01,$C7,$01,$C7,$01,$C7,$01,$C7,$01,$C7,$01,$C7,$01,$F8,$01
  .db $FF,$01,$00,$00,$57,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01
  .db $FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01
  .db $FF,$01,$00,$00,$47,$00,$BF,$01,$7F,$01,$3F,$01,$BD,$00,$17,$01
  .db $B8,$01,$FA,$01,$FF,$01,$5F,$01,$F7,$01,$EF,$01,$A7,$01,$FE,$00
  .db $FF,$01,$00,$00,$01,$00,$3F,$01,$FE,$00,$BD,$00,$3B,$00,$87,$00
  .db $28,$01,$B8,$01,$FD,$01,$CF,$00,$A7,$01,$5F,$01,$17,$01,$7C,$00
  .db $FF,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.ends
