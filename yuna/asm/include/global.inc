
;==============================================================================
; HARDWARE
;==============================================================================

.define bytesPerPattern $20

.define patternW 8
.define patternH 8
.define spritePatternW 16
.define spritePatternH 16

.define spriteAttrBaseX 32
.define spriteAttrBaseY 64

.define bytesPerSpritePattern $80
.define bytesPerSpritePatternPlane $20

.define vce_crLo $400
.define vce_crHi $401
.define vce_ctaLo $402
.define vce_ctaHi $403
.define vce_ctwLo $404
.define vce_ctwHi $405

;==============================================================================
; BIOS
;==============================================================================

.define EX_IRQON $E084
.define EX_IRQOFF $E087
.define EX_BGON $E08A
.define EX_BGOFF $E08D
.define EX_SPRON $E090
.define EX_SPROFF $E093
.define EX_DSPON $E096
.define EX_DSPOFF $E099

;==============================================================================
; FONT
;==============================================================================

.define bytesPerRawFontChar 10
.define rawFontCharW 8
.define rawFontCharH 10
.define fullFontCharW 16
.define fullFontCharH 16
.define fullFontCharBytesPerLine 2

.define fontBaseOffset $50
.define fontMaxChars $60
.define limitedFontMaxChars $5C
.define digitBaseOffset $51
.define digitZeroOffset $51
.define digitSpaceOffset $50
.define nullCharOffset $9F

.define code_jump      $01
.define code_linebreak $0A

.define code_dteBase fontBaseOffset+fontMaxChars

;==============================================================================
; SCENE FONT
;==============================================================================

.define linesPerRawSceneFontChar 10
.define bytesPerSceneFontChar 10
.define numSceneFontChars $50

.define sceneFontCharsBase $50

; offset the raw font character by this many lines within the
; 16x16 areas that are actually rendered
;.define rawFontCharYOffset 3

;==============================================================================
; TEXT
;==============================================================================

; font will be included into free space
.define fontLoadType_normal 0
; font must be preloaded into a (static, guaranteed paged-in) area
.define fontLoadType_preload 1
