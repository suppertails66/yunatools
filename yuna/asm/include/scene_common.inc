
;==============================================================================
; 
;==============================================================================

.include "include/global.inc"

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
   
   slotsize        $6000
   slot            1       $4000
.endme

.rombankmap
  bankstotal $1
  
  banksize $A000
  banks $1
.endro

.emptyfill $FF

;===================================
; misc
;===================================

.define sceneOp_terminator $00
.define sceneOp_waitForFrame $01
.define sceneOp_br $02
.define sceneOp_resetCompBuffers $03
.define sceneOp_prepAndSendGrp $04
.define sceneOp_swapAndShowBuf $05
.define sceneOp_subsOff $06
.define sceneOp_finishCurrentLine $07
.define sceneOp_setPalette $08
.define sceneOp_setHighPrioritySprObjOffset $09
.define sceneOp_setLowPrioritySprObjOffset $0A
;.define sceneOp_clearSyncTimer $0B
;.define sceneOp_subtractFromSyncTimer $0B
.define sceneOp_resetSyncTimerFromAdpcm $0B
.define sceneOp_writePalette $0C
.define sceneOp_writeVram $0D
.define sceneOp_waitForAdpcm $0E
.define sceneOp_queueSubsOff $0F
.define sceneOp_writeMem $10
.define sceneOp_andOr $11

.define numSubtitleCompBufferLines 2
.define spritesPerSubtitleCompLineBuffer 16
.define maxNumSubtitleSprites spritesPerSubtitleCompLineBuffer*numSubtitleCompBufferLines
; allocate an extra sprite per line to allow for the outlining algorithm
; (which uses two extra pixel columns, and possibly needs an extra pattern.
; the extra allocation here is not actually USED, but ensures the generated
; outline gets sent.)
.define bytesPerSubtitleCompLineBuffer bytesPerSpritePatternPlane*(spritesPerSubtitleCompLineBuffer+1)
.define sizeOfAllSubtitleCompBuffers numSubtitleCompBufferLines*bytesPerSubtitleCompLineBuffer

; we use a 24-pixel wide area to compose the character data,
; i.e. 3 bytes per line
.define bytesPerSubtitleCharCompBufferLine 3
.define subtitleCharCompBufferSize spritePatternH*bytesPerSubtitleCharCompBufferLine

; sprites are 16 pixels tall, but the font is only 10 pixels high,
; so we apply some padding at the top to make things more centered
.define numSubtitleFontCharTopPaddingLines 3
.define numSubtitleFontCharBottomPaddingLines spritePatternH-linesPerRawSceneFontChar-numSubtitleFontCharTopPaddingLines

.define satVramAddr $7F00

; white/black
;.define defaultSubColor $01FF
;.define defaultSubShadowColor $0000

; light blue/black

;.define defaultSubColor $01C7
;.define defaultSubColor $01D7

; G/R/B

; light blue
;.define defaultSubColor ($2<<3)|($7<<6)|($7)
; yellow
;.define defaultSubColor ($7<<3)|($7<<6)|($1)
; white
.define defaultSubColor ($7<<3)|($7<<6)|($7)
.define defaultSubShadowColor $0000

;=====
; speed settings.
; if an action is reliably fast enough,
; it's possible to handle more than one per vsync cycle
;=====

; maximum number of script ops to handle per cycle
; (including character literals, which are costly to render,
; hence the limit of 1)
;.define maxScriptActionsPerIteration 2
; max sprite attributes to generate per cycle
;.define maxSpriteAttrTransfersPerIteration 4
; max sprite graphics to transfer to vram per cycle
;.define maxSpriteGrpTransfersPerIteration 2

; maximum number of script ops to handle per cycle
; (including character literals, which are costly to render,
; hence the limit of 1)
.define default_maxScriptActionsPerIteration 2
; max sprite attributes to generate per cycle
.define default_maxSpriteAttrTransfersPerIteration 4
; max sprite graphics to transfer to vram per cycle
.define default_maxSpriteGrpTransfersPerIteration 2

;.define numSubtitleLines 2

;=============================
; structs
;=============================

.struct SubtitleCompBufferLineState
  startPtr              dw
  pixelW                db
  numPatterns           db
  ; the fields below are used during queue evaluation
  ; during composition, this is set to the number of
  ; patterns remaining to be converted and sent
  patternTransfersLeft  db
  ; current getpos
  currentPtr            dw
.endst

.struct SpriteAttribute
  y             dw
  x             dw
  pattern       dw
  flags         dw
.endst

/*.struct SubtitleCompBufferState
  .rept numSubtitleLines
    .ds _sizeof_SubtitleCompBufferLineState,$00
  .endr
.endst */

;===================================
; offset defines for bootloader2.
; bootloader2 is loaded to $3800
; and remains there for the duration
; of each scene, so some extra code
; and data has been placed in it.
; since the structure of wla-dx makes it
; utterly impossible to actually link
; bootloader2 with the individual scene
; ASM files, we have to make do with
; jump tables and other stupid
; space-wasting techniques.
;===================================

.define ovlScene_extraContentLoadAddr $3800
.define ovlScene_extraContentBase $3885

.define ovlScene_jumpTable_setUpStdBanks    ovlScene_extraContentBase+(3*0)
.define ovlScene_jumpTable_restoreOldBanks  ovlScene_extraContentBase+(3*1)
;.define ovlScene_jumpTable_doHighPrioritySpriteObjOffset  ovlScene_extraContentBase+(3*2)
.define ovlScene_jumpTableEnd ovlScene_jumpTable_restoreOldBanks+3

.define ovlScene_font ovlScene_jumpTableEnd
.define ovlScene_fontWidthTable ovlScene_font+(numSceneFontChars*bytesPerSceneFontChar)
.define ovlScene_fontLut ovlScene_fontWidthTable+numSceneFontChars
;.define ovlScene_highPrioritySpriteObjGenerationOffset ovlScene_fontLut+numSceneFontChars

;===================================
; loop optimization macros
; probably don't really go here but whatever
;===================================

.macro leftShiftRightTwoLoop
  .rept linesPerRawSceneFontChar INDEX count
    asl subtitleCharCompBuffer+2+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
    rol subtitleCharCompBuffer+1+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
  .endr
.endm

.macro rightShiftLeftTwoLoop
  .rept linesPerRawSceneFontChar INDEX count
    lsr subtitleCharCompBuffer+0+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
    ror subtitleCharCompBuffer+1+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
  .endr
.endm

.macro leftShiftLeftTwoLoop
  .rept linesPerRawSceneFontChar INDEX count
    asl subtitleCharCompBuffer+1+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
    rol subtitleCharCompBuffer+0+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
  .endr
.endm

.macro rightShiftRightTwoLoop
  .rept linesPerRawSceneFontChar INDEX count
    lsr subtitleCharCompBuffer+1+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
    ror subtitleCharCompBuffer+2+(bytesPerSubtitleCharCompBufferLine*numSubtitleFontCharTopPaddingLines)+(count*bytesPerSubtitleCharCompBufferLine).w
  .endr
.endm

;===================================
; macros for commonly-needed patch operations
;===================================

.macro fixSprOff ARGS addr
  .bank 0 slot 0
  .orga addr
  .section "fixSprOff \@" overwrite
    ; instead of turning sprites off entirely,
    ; just clear non-subtitle ones out
    ; (NOTE: this takes effect one frame later
    ; than shutting them off entirely would,
    ; so use caution)
    jsr clearAndSendSubtitleExclusionOverwrite
  .ends
.endm

.macro fixDspOff ARGS addr
  .bank 0 slot 0
  .orga addr
  .section "fixDspOff \@" overwrite
    ; turn off only the background
    jsr EX_BGOFF
  .ends
.endm

/*.macro fixDspOffWithSprClr ARGS addr
  .bank 0 slot 0
  .orga addr
  .section "fixDspOffWithSprClr \@" overwrite
    jsr clearAndSendSubtitleExclusionOverwrite
    jsr EX_BGOFF
  .ends
.endm */

.macro fixDspOffWithSprClrAndSync ARGS addr
  .bank 0 slot 0
  .orga addr
  .section "fixDspOffWithSprClrAndSync \@" overwrite
    ; swap the order of the operations here --
    ; clear non-sub sprites, wait for sync so
    ; that the effect kicks in the frame after that,
    ; then turn BG off.
    ; this ensures that all layers disappear simultaneously
    ; instead of the sprites disappearing one frame after
    ; the background
    jsr clearAndSendSubtitleExclusionOverwrite
    jsr waitForSync
    jsr EX_BGOFF
  .ends
.endm

;===================================
; scene op macros
;===================================

.macro cut_resetCompBuffers
  .db sceneOp_resetCompBuffers
.endm

.macro cut_setPalette ARGS palIndex
  .db sceneOp_setPalette
    .db palIndex
.endm

.macro cut_waitForFrame ARGS time
  .if time - SYNC_time < 0
;    .fail
    .db sceneOp_waitForFrame
      .dw 0
  .else
    .db sceneOp_waitForFrame
      .dw (time - SYNC_time)
  .endif
  
.endm

; audacity can report times in absolutely goddamn every format there is...
; except 60fps frames
.macro cut_waitForFrameMinSec ARGS min sec
  ; FIXME: i'm pretty sure the pce cpu is not clocked
  ; at exactly 60 frames per second, so this timing drifts?
  cut_waitForFrame ((min*60)+sec)*60
;  .db sceneOp_waitForFrame
;    .dw ((min*60)+sec)*60
.endm

.macro cut_queueSubsOffMinSec ARGS min sec
  cut_queueSubsOff ((min*60)+sec)*60
.endm

.macro cut_prepAndSendGrp ARGS tileIndex
  .db sceneOp_prepAndSendGrp
    .dw tileIndex
.endm

.macro cut_swapAndShowBuf
  .db sceneOp_swapAndShowBuf
.endm

.macro cut_subsOff
  .db sceneOp_subsOff
.endm

.macro cut_setHighPrioritySprObjOffset ARGS offset
  .db sceneOp_setHighPrioritySprObjOffset
    .db offset
.endm

.macro cut_setLowPrioritySprObjOffset ARGS offset
  .db sceneOp_setLowPrioritySprObjOffset
    .db offset
.endm

;.macro cut_resetSyncTimer
;  .db sceneOp_resetSyncTimer
;.endm

;.macro cut_subtractFromSyncTimer ARGS time
;  .db sceneOp_subtractFromSyncTimer
;    .dw time
;.endm

;.macro cut_resetSyncTimerFromAdpcm ARGS time
;  .db sceneOp_resetSyncTimer
;    .dw time
;.endm

.macro cut_resetSyncTimerFromAdpcm
  .db sceneOp_resetSyncTimerFromAdpcm
.endm

.macro cut_waitForAdpcm ARGS counter
  .db sceneOp_waitForAdpcm
    .db counter
;    .dw time
.endm

.macro cut_writePalette ARGS dst sz
  .db sceneOp_writePalette
    .dw sz
    .dw dst
.endm

.macro cut_writeVram ARGS src dst sz
  .db sceneOp_writeVram
    .dw src
    .dw sz
    .dw dst
.endm

.macro cut_queueSubsOff ARGS time
  .if time - SYNC_time < 0
    .fail
  .endif

  .db sceneOp_queueSubsOff
    .dw (time - SYNC_time)
.endm

.macro cut_writeMem ARGS addr value
  .db sceneOp_writeMem
    .dw addr
    .db value
.endm

.macro cut_andOr ARGS addr andVal orVal
  .db sceneOp_andOr
    .dw addr
    .db andVal
    .db orVal
.endm

.macro cut_terminator
  .db sceneOp_terminator
.endm

;===================================
; scene timing hack(?)
;===================================

.define SYNC_time 0

.macro SYNC_adpcmTime ARGS index newtime
;  .redefine SYNC_time time
;  cut_resetSyncTimer
  
;  cut_resetSyncTimerFromAdpcm (newtime-SYNC_time)
  cut_waitForAdpcm index
;  cut_resetSyncTimerFromAdpcm
  .redefine SYNC_time newtime
.endm

.define SCENE_autoPlaceBaseAddr $01BC
.define SCENE_autoPlaceSeparation $0020
.define SCENE_autoPlaceParity 0

.macro SCENE_prepAndSendGrpAuto
  .ifeq SCENE_autoPlaceParity 0
    cut_prepAndSendGrp SCENE_autoPlaceBaseAddr
    .redefine SCENE_autoPlaceParity 1
  .else
    cut_prepAndSendGrp SCENE_autoPlaceBaseAddr+SCENE_autoPlaceSeparation
    .redefine SCENE_autoPlaceParity 0
  .endif
.endm
