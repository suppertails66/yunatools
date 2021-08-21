
.memorymap
   defaultslot     2
   ; ROM area
   slotsize        $4000
   slot            0       $0000
   slot            1       $4000
   slot            2       $8000
   ; RAM area
   slotsize        $2000
   slot            3       $C000
   slot            4       $E000
.endme

.define memCtrlPort $3E
.define ioCtrlPort  $3F
.define vCtrPort    $7E
.define hCtrPort    $7F
.define psgPort     $7F
.define vdpDataPort $BE
.define vdpCtrlPort $BF
.define ioAbPort    $DC
.define ioBmPort    $DD

.define resetVector     $0000
.define interruptVector $0038
.define pauseVector     $0066

.define ramStart  $C000
.define ramEnd    $E000
.define ramSize   (ramEnd - ramStart)

.define vramSize  $4000

.define stackPointerBase $DFF0

.define threeDGlassesCtrl   $FFF8
.define cartRamCtrl         $FFFC
.define mapperSlot0Ctrl     $FFFD
.define mapperSlot1Ctrl     $FFFE
.define mapperSlot2Ctrl     $FFFF

.define numVdpRegs 11

.define vdpModeCtrl1RegNum       $00
.define vdpModeCtrl2RegNum       $01
.define vdpNameTableAddrRegNum   $02
.define vdpColorTableAddrRegNum  $03
.define vdpPatTableAddrRegNum    $04
.define vdpSpriteTableAddrRegNum $05
.define vdpSpritePatAddrRegNum   $06
.define vdpOverscanRegNum        $07
.define vdpBgXScrollRegNum       $08
.define vdpBgYScrollRegNum       $09
.define vdpLineCtrRegNum         $0A

.define vdpCodeVramRead          $00
.define vdpCodeVramWrite         $40
.define vdpCodeRegWrite          $80
.define vdpCodeCramWrite         $C0

.define vdpScrollRegColSelectMask $F1
.define vdpScrollRegFineMask $07

.struct FullPalette
  tilePalette       ds 16
  spritePalette     ds 16
.endst

.define fullPaletteSize 32
.define paletteSize 16
.define bytesPerTile 32
.define tilePixelW 8
.define tilePixelH 8

.define screenPixelWidth 256
.define standardScreenPixelHeight 192

.define tilemapBytesPerTile $2
.define tilemapRowByteSize $40

.define spriteTableSize $100
.define spriteTableUsedSize $C0
.define numSpriteTableEntries $40

.define spriteTableBlock0Offset $0
.define spriteTableBlock0Size $40
.define spriteTableBlock1Offset $80
.define spriteTableBlock1Size $80

.define spriteTableYOffset $0
.define spriteTableXOffset $80
.define spriteTableNOffset $81

.define padAButton2BitNum          5
.define padAButton1BitNum          4
.define padARightBitNum            3
.define padALeftBitNum             2
.define padADownBitNum             1
.define padAUpBitNum               0

.define padAButton2Mask            $20
.define padAButton1Mask            $10
.define padARightMask              $08
.define padALeftMask               $04
.define padADownMask               $02
.define padAUpMask                 $01
