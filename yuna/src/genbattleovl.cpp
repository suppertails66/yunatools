#include "yuna/YunaTranslationSheet.h"
#include "pce/PcePalette.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include "util/TCsv.h"
#include "util/TParse.h"
#include "util/TStringSearch.h"
#include "util/TOpt.h"
#include <string>
#include <iostream>
#include <fstream>

using namespace std;
using namespace BlackT;
using namespace Pce;

const static int sectorSize = 0x800;
const static int blockSize = 0x14 * 0x800;
const static int loadAddr = 0x4000;
const static int freeSpaceStartSafetyBuffer = 0x40;

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

void outputDefine(std::ostream& ofs, string label, int value) {
//  cout << ".define " << label << " " << getHexWordNumStr(value) << endl;
  ofs << ".define " << label << " " << getHexWordNumStr(value) << endl;
}

void outputDefineFromRawOffset(std::ostream& ofs, string label, int value) {
  ofs << ".define " << label << " " << getHexWordNumStr(value + loadAddr) << endl;
}

/*int getByteParamWithOldOffset(TStream& ifs, int origOpStartAddr) {
  ifs.seek(getPrintCharOffset(origOpStartAddr + 1));
  return ifs.readu8();
}

int getWordParamWithOldOffset(TStream& ifs, int origOpStartAddr) {
  ifs.seek(getPrintCharOffset(origOpStartAddr + 1));
  return ifs.readu16le();
} */

/*int getByteParamWithOldOffset(TStream& ifs, int origOpStartAddr) {
  ifs.seek(getPrintCharOffset(origOpStartAddr + 1));
  return ifs.readu8();
} */

int getAddrParamAsRawOffset(TStream& ifs, int origOpStartAddr) {
  ifs.seek(origOpStartAddr + 1);
  return ifs.readu16le() - loadAddr;
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Yuna PCECD battle overlay include generator" << endl;
    cout << "Usage: " << argv[0] << " [infile] [basename]" << endl;
    cout << "Options: " << endl;
    cout << "  -fill           Select fill character for free space detection"
      << endl;
    cout << " --nobackground   Don't unbackground free space"
      << endl;
    return 0;
  }
  
  try {
  
  std::string inFile(argv[1]);
  std::string baseName(argv[2]);
  
  int fillCharValue = 0x00;
  TOpt::readNumericOpt(argc, argv, "-fill", &fillCharValue);
  char fillChar = fillCharValue;
  
  bool noBackground = TOpt::hasFlag(argc, argv, "--nobackground");
  
  TBufStream ifs;
  ifs.open(inFile.c_str());
  
  std::ofstream ofs;
  ofs.open(string("asm/include/") + baseName + "_ovlBattle.inc");
  
  ifs.seek(ifs.size() - 1);
  while (ifs.peek() == fillChar) ifs.seekoff(-1);
  int freeSpaceStart_raw = ifs.tell();
  // safety
  freeSpaceStart_raw += freeSpaceStartSafetyBuffer;
  int freeSpaceSize_raw = ifs.size() - freeSpaceStart_raw;
  freeSpaceSize_raw -= 0x2000;
  
  TStringSearchResultList searchResults;
  
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
//  cerr << hex << add2BTo29_raw << endl;

/*    searchResults = TStringSearch::searchFullStream(ifs,
        std::string(
          "DA 18 A2 29 F4 65 2B E8 F4 65 2C FA 60"
        )
      );
  cerr << searchResults.size() << endl; */
  
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

/*0075D9  DA                   phx 
  0075DA  AA                   tax 
  0075DB  A5 29                lda $0029
  0075DD  86 29                stx $0029
  0075DF  38                   sec 
  0075E0  E5 29                sbc $0029
  0075E2  85 29                sta $0029
  0075E4  A5 2A                lda $002A
  0075E6  64 2A                stz $002A
  0075E8  E5 2A                sbc $002A
  0075EA  85 2A                sta $002A
0075EC  FA                   plx 
0075ED  60                   rts */
  int subFrom29_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "DA AA A5 29 86 29 38 E5 29 85 29 A5 2A 64 2A E5 2A 85 2A FA 60"
        )
      ).offset;

/* 0075FB  38                   sec 
0075FC  A5 29                lda $0029
0075FE  E5 2B                sbc $002B
007600  85 29                sta $0029
007602  A5 2A                lda $002A
007604  E5 2C                sbc $002C
007606  85 2A                sta $002A
007608  60                   rts */
  int sub2BFrom29_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "38 A5 29 E5 2B 85 29 A5 2A E5 2C 85 2A 60"
        )
      ).offset;
  
/*007609  DA                   phx 
00760A  64 29                stz $0029
00760C  64 2A                stz $002A
00760E  86 2B                stx $002B
007610  64 2C                stz $002C
007612  A2 08                ldx #$08
007614  6A                   ror 
007615  90 03                bcc [$761A]*/
  int multTo29_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "DA 64 29 64 2A 86 2B 64 2C A2 08 6A 90 03"
        )
      ).offset;
  
/*  ifs.seek(clearAndSendSpriteTable_raw + 7);
  int spriteTableClearMakeup1 = ifs.readu16le();
  ifs.seek(clearAndSendSpriteTable_raw + 10);
  int spriteTableClearMakeup2 = ifs.readu16le(); */
  
/*005355  A5 1B                lda $001B
005357  85 1F                sta $001F
005359  64 1E                stz $001E
; loop
  ; fetch byte
  00535B  B2 BE                lda ($00BE)
  00535D  85 F9                sta $00F9
  ; done if terminator
  00535F  F0 4B                beq [$53AC]
  005361  E6 BE                inc $00BE
  005363  D0 02                bne [$5367]
    005365  E6 BF                inc $00BF
  ; fetch another byte
  005367  B2 BE                lda ($00BE)
  005369  85 F8                sta $00F8
  00536B  E6 BE                inc $00BE
  00536D  D0 02                bne [$5371]
    00536F  E6 BF                inc $00BF */
  int ovlBatStr_fullStringPrint_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "A5 1B "
          "85 1F "
          "64 1E "
          "B2 BE "
          "85 F9 "
          "F0 4B "
          "E6 BE "
          "D0 02 "
          "E6 BF "
          "B2 BE "
          "85 F8 "
          "E6 BE "
          "D0 02 "
          "E6 BF"
        )
      ).offset;
  
/*007E19  20 21 71             jsr $7121
; loop
  ; fetch byte
  007E1C  B2 BE                lda ($00BE)
  007E1E  85 F9                sta $00F9
  ; done if terminator
  007E20  F0 2F                beq [$7E51]
  007E22  E6 BE                inc $00BE
  007E24  D0 02                bne [$7E28]
    007E26  E6 BF                inc $00BF
  ; fetch another byte
  007E28  B2 BE                lda ($00BE)
  007E2A  85 F8                sta $00F8
  007E2C  E6 BE                inc $00BE
  007E2E  D0 02                bne [$7E32]
    007E30  E6 BF                inc $00BF
  ; print 16-bit codepoint
  007E32  64 FA                stz $00FA
  007E34  64 FB                stz $00FB */
  int ovlBatStr_simpleStringPrint_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "20 * * "
          "B2 BE "
          "85 F9 "
          "F0 2F "
          "E6 BE "
          "D0 02 "
          "E6 BF "
          "B2 BE "
          "85 F8 "
          "E6 BE "
          "D0 02 "
          "E6 BF "
          "64 FA "
          "64 FB"
        )
      ).offset;
  
/*005C8D  AD 41 22             lda $2241
005C90  CD 41 22             cmp $2241
005C93  F0 FB                beq [$5C90]
005C95  60                   rts  */
  int waitForSync_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "AD 41 22 "
          "CD 41 22 "
          "F0 FB "
          "60"
        )
      ).offset;
  
/*005300  A9 03                lda #$03
005302  85 1F                sta $001F
; loop
  005304  A5 29                lda $0029
  005306  85 F8                sta $00F8
  005308  A5 2A                lda $002A
  00530A  85 F9                sta $00F9
  00530C  A9 0A                lda #$0A
  00530E  85 FA                sta $00FA
  005310  64 FB                stz $00FB
  ; MA_DIV16S
  005312  20 C9 E0             jsr $E0C9
  005315  A5 FC                lda $00FC
  005317  85 29                sta $0029
  005319  A5 FD                lda $00FD
  00531B  85 2A                sta $002A */
  int ovlBatStr_numToSjis3Digit_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "A9 03 "
          "85 1F "
          "A5 29 "
          "85 F8 "
          "A5 2A "
          "85 F9 "
          "A9 0A "
          "85 FA "
          "64 FB "
          "20 C9 E0 "
          "A5 FC "
          "85 29 "
          "A5 FD "
          "85 2A"
        )
      ).offset;
  
  ifs.seek(ovlBatStr_numToSjis3Digit_offset_raw + (0x5327 - 0x5300) + 1);
  int ovlBatStr_numConvBuffer_offset = ifs.readu16le();
  
  /*0051E5  20 ED 58             jsr $58ED
; ?
0051E8  A2 0F                ldx #$0F
0051EA  AD 7E 26             lda $267E
0051ED  F0 02                beq [$51F1]
  0051EF  A2 0D                ldx #$0D
0051F1  86 11                stx $0011
; VRAM dst?
0051F3  A9 50                lda #$50
0051F5  85 F8                sta $00F8
0051F7  A9 7E                lda #$7E
0051F9  85 F9                sta $00F9
; ?
0051FB  A9 12                lda #$12
0051FD  85 FA                sta $00FA
0051FF  A9 02                lda #$02
005201  85 FB                sta $00FB
005203  A9 0E                lda #$0E
005205  85 FC                sta $00FC */
  int ovlBatStr_drawHud1_offset_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "20 * * "
          "A2 0F "
          "AD * * "
          "F0 02 "
          "A2 0D "
          "86 11 "
          "A9 50 "
          "85 F8 "
          "A9 7E "
          "85 F9 "
          "A9 * "
          "85 FA "
          "A9 * "
          "85 FB "
          "A9 * "
          "85 FC"
        )
      ).offset;
  
  if (!noBackground) {
    ofs << ".unbackground "
      << getHexWordNumStr(freeSpaceStart_raw)
      << " "
      << getHexWordNumStr(freeSpaceStart_raw + freeSpaceSize_raw - 1)
      << endl;
  }
//  outputDefineFromRawOffset(ofs, "syncVector", syncVector_raw);
//  outputDefine(
//    ofs, "spriteTableClearMakeup2", spriteTableClearMakeup2);
  outputDefineFromRawOffset(
    ofs, "ovlBatStr_fullStringPrint_offset", ovlBatStr_fullStringPrint_offset_raw);
  outputDefineFromRawOffset(
    ofs, "ovlBatStr_simpleStringPrint_offset", ovlBatStr_simpleStringPrint_offset_raw);
  outputDefineFromRawOffset(
    ofs, "ovlBatStr_waitVblank_offset", waitForSync_raw);
  outputDefineFromRawOffset(
    ofs, "ovlBatStr_numToSjis3Digit_offset", ovlBatStr_numToSjis3Digit_offset_raw);
  outputDefine(
    ofs, "ovlBatStr_numConvBuffer_offset", ovlBatStr_numConvBuffer_offset);
  outputDefineFromRawOffset(
    ofs, "ovlBatStr_drawHud1_offset", ovlBatStr_drawHud1_offset_raw);
  
  return 0;
  
  }
  catch (TGenericException& e) {
    cerr << "exception: " << e.problem() << endl;
    return 1;
  }
  catch (...) {
    return 1;
  }
}
