#include "pce/PcePalette.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include "util/TStringSearch.h"
#include <cctype>
#include <string>
#include <iostream>
#include <fstream>

using namespace std;
using namespace BlackT;
using namespace Pce;

std::string getNumStr(int num) {
  std::string str = TStringConversion::intToString(num);
  while (str.size() < 2) str = string("0") + str;
  return str;
}

std::string getHexWordNumStr(int num) {
  std::string str = TStringConversion::intToString(num,
    TStringConversion::baseHex).substr(2, string::npos);
  while (str.size() < 4) str = string("0") + str;
  return string("$") + str;
}

const static int origPrintCharBase = 0x6950;
const static int loadAddr = 0x4000;
int printChar_offset = 0;
inline int getPrintCharOffset(int origAddr) {
  return printChar_offset + (origAddr - origPrintCharBase) - loadAddr;
}

void outputDefine(string label, int value) {
  cout << ".define " << label << " " << getHexWordNumStr(value) << endl;
}

int getByteParam(TStream& ifs, int origOpStartAddr) {
  ifs.seek(origOpStartAddr + 1);
  return ifs.readu8();
}

int getWordParam(TStream& ifs, int origOpStartAddr) {
  ifs.seek(origOpStartAddr + 1);
  return ifs.readu16le();
}

int getByteParamWithOldOffset(TStream& ifs, int origOpStartAddr) {
  ifs.seek(getPrintCharOffset(origOpStartAddr + 1));
  return ifs.readu8();
}

int getWordParamWithOldOffset(TStream& ifs, int origOpStartAddr) {
  ifs.seek(getPrintCharOffset(origOpStartAddr + 1));
  return ifs.readu16le();
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "ovlText define generator" << endl;
    cout << "Usage: " << argv[0] << " [infile] [printChar_offset]"
      << endl;
    return 0;
  }
  
  string infile(argv[1]);
  printChar_offset = TStringConversion::stringToInt(string(argv[2]));
  
  outputDefine("ovlText_printChar_offset", printChar_offset);

  TBufStream ifs;
  ifs.open(infile.c_str());
  
//  int calcVramTilemapPos_offset = getWordParamWithOldOffset(ifs, 0x6976);
//  outputDefine("ovlText_calcVramTilemapPos_offset",
//               calcVramTilemapPos_offset);
  
/*006976  20 53 67             jsr $6753
; save to $27-$28
006979  A5 29                lda $0029
00697B  85 27                sta $0027
00697D  A5 2A                lda $002A
00697F  85 28                sta $0028
006981  A5 FE                lda $00FE
006983  85 2B                sta $002B
006985  A5 FA                lda $00FA
006987  85 25                sta $0025
; set dst for custom character transfer
006989  8D A2 69             sta $69A2
00698C  A5 FB                lda $00FB
00698E  85 26                sta $0026
006990  8D A3 69             sta $69A3
006993  A5 F8                lda $00F8
006995  C9 9A                cmp #$9A*/
  int calcVramTilemapPos_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "20 * * A5 29 85 27 A5 2A 85 28 A5 FE 85 2B A5 FA 85 25 8D * *"
        )
      ).offset;
  int calcVramTilemapPos_offset
    = getWordParam(ifs, calcVramTilemapPos_offset_raw);
  outputDefine("ovlText_calcVramTilemapPos_offset",
               calcVramTilemapPos_offset);
  
  ifs.seek(calcVramTilemapPos_offset - loadAddr + 2);
  int tilemapLineW_offset = ifs.readu16le();
  outputDefine("ovlText_tilemapLineW_offset",
               tilemapLineW_offset);
  
  ifs.seek(calcVramTilemapPos_offset - loadAddr + 5);
  int multTo29_offset = ifs.readu16le();
  outputDefine("ovlText_multTo29_offset",
               multTo29_offset);
  
//  ifs.seek(calcVramTilemapPos_offset - loadAddr + 9);
//  int addTo29_offset = ifs.readu16le();
//  outputDefine("ovlText_addTo29_offset",
//               addTo29_offset);
  
//  outputDefine("ovlText_add2BTo29_offset",
//               getWordParamWithOldOffset(ifs, 0x6AFE));
//  outputDefine("ovlText_addTo29_offset",
//               getWordParamWithOldOffset(ifs, 0x6B6F));
/*0075EE  DA                   phx 
0075EF  18                   clc 
0075F0  A2 29                ldx #$29
0075F2  F4                   set 
0075F3  65 2B                adc $002B
0075F5  E8                   inx 
0075F6  F4                   set 
0075F7  65 2C                adc $002C
0075F9  FA                   plx 
0075FA  60                   rts */
  int add2BTo29_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "DA 18 A2 29 F4 65 2B E8 F4 65 2C FA 60"
        )
      ).offset;
  outputDefine("ovlText_add2BTo29_offset",
               add2BTo29_raw + loadAddr);
               
  
/*0075CE  18                   clc 
0075CF  65 29                adc $0029
0075D1  85 29                sta $0029
0075D3  62                   cla 
0075D4  65 2A                adc $002A
0075D6  85 2A                sta $002A
0075D8  60                   rts */
  int addTo29_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "18 65 29 85 29 62 65 2A 85 2A 60"
        )
      ).offset;
  outputDefine("ovlText_addTo29_offset",
               addTo29_raw + loadAddr);
  
//  int textBaseX_offset = getByteParamWithOldOffset(ifs, 0x6970);
//  outputDefine("ovlText_textBaseX_offset",
//               textBaseX_offset);
/*006970  65 A5                adc $00A5
; multiply by y-pos
006972  A6 FD                ldx $00FD
; save y-pos to $1A
006974  86 1A                stx $001A
; compute $29-$2A = base dstoffset for new tilemap data
006976  20 53 67             jsr $6753
; save to $27-$28
006979  A5 29                lda $0029
00697B  85 27                sta $0027
00697D  A5 2A                lda $002A
00697F  85 28                sta $0028
006981  A5 FE                lda $00FE
006983  85 2B                sta $002B
006985  A5 FA                lda $00FA
006987  85 25                sta $0025*/
  int textBaseX_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "65 * A6 FD 86 1A 20 * * A5 29 85 27 A5 2A 85 28 A5 FE 85 2B A5 FA 85 25"
        )
      ).offset;
  outputDefine("ovlText_textBaseX_offset",
               getByteParam(ifs, textBaseX_offset_raw));
  
/*  0069D3  06 F8                asl $00F8
0069D5  2A                   rol 
0069D6  06 F8                asl $00F8
0069D8  2A                   rol 
0069D9  AA                   tax 
0069DA  A5 F8                lda $00F8
; set vram read mode
0069DC  20 AB E0             jsr $E0AB
0069DF  F3 02 00 CB 2A 20 00 tai $0002,$2ACB,#$0020
0069E6  A2 29                ldx #$29
0069E8  18                   clc 
0069E9  F4                   set 
0069EA  6D B3 26             adc $26B3
0069ED  E8                   inx 
0069EE  F4                   set 
0069EF  69 00                adc #$00 */
//  outputDefine("ovlText_vramReadBackBufferTop_offset",
//               getWordParamWithOldOffset(ifs, 0x69DF + 2));
  int ovlText_vramReadBackBufferTop_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "06 F8 2A 06 F8 2A AA A5 F8 20 AB E0 F3 02 00 * * 20 00"
          " A2 29 18 F4 6D * * E8 F4 69 00"
        )
      ).offset;
  ifs.seek(ovlText_vramReadBackBufferTop_offset_raw
            + (0x69E2 - 0x69D3));
//  std::cerr << ovlText_vramReadBackBufferTop_offset_raw << std::endl;
  int ovlText_vramReadBackBufferTop_offset = ifs.readu16le();
  outputDefine("ovlText_vramReadBackBufferTop_offset",
               ovlText_vramReadBackBufferTop_offset);
  
//  outputDefine("ovlText_vramReadBackBufferBottom_offset",
//               getWordParamWithOldOffset(ifs, 0x6A12 + 2));
  outputDefine("ovlText_vramReadBackBufferBottom_offset",
               ovlText_vramReadBackBufferTop_offset + 0x20);
  
//  int charOutputPatternBufferBase_offset
//    = getWordParamWithOldOffset(ifs, 0x6B17);
/*  006B17  E3 6B 2A 02 00 80 00 tia $2A6B,$0002,#$0080
  006B1E  80 29                bra [$6B49]
; else
  006B20  A5 C0                lda $00C0
  006B22  A6 C1                ldx $00C1
  006B24  85 2B                sta $002B
  006B26  86 2C                stx $002C
  006B28  85 25                sta $0025
  006B2A  86 26                stx $0026
  ; set vram write mode
  006B2C  20 AE E0             jsr $E0AE
  006B2F  E3 6B 2A 02 00 80 00 tia $2A6B,$0002,#$0080
  ; dstaddr += 0x40
  006B36  A9 40                lda #$40
  006B38  85 29                sta $0029*/
/*  TStringSearchResultList test
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "E3 * * 02 00 80 00 80 * A5 * A6 * 85 2B 86 2C 85 25 86 26"
          " 20 AE E0 E3 * * 02 00 80 00 A9 40 85 29"
        )
      );
  std::cerr << test.size() << std::endl; */
  int charOutputPatternBufferBase_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "E3 * * 02 00 80 00 80 * A5 * A6 * 85 2B 86 2C 85 25 86 26"
          " 20 AE E0 E3 * * 02 00 80 00 A9 40 85 29"
        )
      ).offset;
  ifs.seek(charOutputPatternBufferBase_offset_raw + 1);
  int charOutputPatternBufferBase_offset
    = ifs.readu16le();
    
  outputDefine("ovlText_charOutputPatternBufferBase_offset",
               charOutputPatternBufferBase_offset);
  outputDefine("ovlText_charOutputPatternBufferUL_offset",
               charOutputPatternBufferBase_offset + 0x00);
  outputDefine("ovlText_charOutputPatternBufferLL_offset",
               charOutputPatternBufferBase_offset + 0x20);
  outputDefine("ovlText_charOutputPatternBufferUR_offset",
               charOutputPatternBufferBase_offset + 0x40);
  outputDefine("ovlText_charOutputPatternBufferLR_offset",
               charOutputPatternBufferBase_offset + 0x60);
  
/*  006ADE  E5 A7                sbc $00A7
  006AE0  85 F8                sta $00F8
  006AE2  64 F9                stz $00F9
  006AE4  A5 A9                lda $00A9
  006AE6  85 FA                sta $00FA
  006AE8  A5 AA                lda $00AA
  006AEA  85 FB                sta $00FB
  ; MA_MUL16U
  006AEC  20 C3 E0             jsr MA_MUL16U [$E0C3]
  ; $29 = (charX * 1.5) * 0x20
  006AEF  A5 19                lda $0019
  006AF1  A2 20                ldx #$20
  006AF3  20 F1 80             jsr multTo29 [$80F1]*/
  int ovlText_unkA7_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "E5 * 85 F8 64 F9 A5 * 85 FA A5 * 85 FB 20 C3 E0 A5 19 A2 20"
        )
      ).offset;
//  int ovlText_reg_gap = (0x6ADE - loadAddr) - ovlText_unkA7_offset_raw;
//  std::cerr << ovlText_reg_gap << std::endl;
  
  outputDefine("ovlText_unkA7_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6ADE - 0x6ADE)));
  outputDefine("ovlText_unkA9_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6AE4 - 0x6ADE)));
  outputDefine("ovlText_unkAA_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6AE8 - 0x6ADE)));
  outputDefine("ovlText_unkAD_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6B01 - 0x6ADE)));
  outputDefine("ovlText_unkAE_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6B05 - 0x6ADE)));
  outputDefine("ovlText_unkC0_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6B20 - 0x6ADE)));
  outputDefine("ovlText_unkC1_offset",
               getByteParam(ifs,
               ovlText_unkA7_offset_raw + (0x6B22 - 0x6ADE)));
  
/*  00695A  A9 4B                lda #$4B
  00695C  85 FA                sta $00FA
  00695E  A9 2A                lda #$2A
  006960  85 FB                sta $00FB
; $18 = flag: nonzero if this is an odd-numbered character
006962  64 18                stz $0018
006964  A5 FC                lda $00FC
006966  4A                   lsr 
006967  90 02                bcc [$696B]
  006969  E6 18                inc $0018
00696B  18                   clc 
00696C  65 FC                adc $00FC
; $19 = (charX * 1.5)
00696E  85 19                sta $0019
; add ???
; base offset for text??
006970  65 A5                adc $00A5 */
  int defaultBuffer_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "A9 * 85 FA A9 * 85 FB 64 18 A5 FC 4A 90 02 E6 18 18 65 FC 85 19 65 *"
        )
      ).offset;
  
//  int defaultBufferLo_offset = getByteParamWithOldOffset(ifs, 0x695A);
//  int defaultBufferHi_offset = getByteParamWithOldOffset(ifs, 0x695E);
  int defaultBufferLo_offset
    = getByteParam(ifs, defaultBuffer_offset_raw);
  int defaultBufferHi_offset
    = getByteParam(ifs, defaultBuffer_offset_raw + 4);
  int defaultBuffer_offset
    = (defaultBufferHi_offset << 8) | defaultBufferLo_offset;
  outputDefine("ovlText_defaultBuffer_offset",
               defaultBuffer_offset);
  
  
  return 0;
}
