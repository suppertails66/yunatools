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
    cout << "Yuna PCECD cutscene overlay include generator" << endl;
    cout << "Usage: " << argv[0] << " [infile] [basename]" << endl;
    cout << "Options: " << endl;
    cout << "  -fill           Select fill character for free space detection"
      << endl;
    cout << "  -bgstartoffset  Select additional space at start to ignore when backgrounding"
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
  
  int bgStartOffset = 0;
  TOpt::readNumericOpt(argc, argv, "-bgstartoffset", &bgStartOffset);
  
  bool noBackground = TOpt::hasFlag(argc, argv, "--nobackground");
  
  TBufStream ifs;
  ifs.open(inFile.c_str());
  
  std::ofstream ofs;
  ofs.open(string("asm/include/") + baseName + "_ovlScene.inc");
  
  ifs.seek(ifs.size() - 1);
  while (ifs.peek() == fillChar) ifs.seekoff(-1);
  int freeSpaceStart_raw = ifs.tell();
  // safety
  freeSpaceStart_raw += freeSpaceStartSafetyBuffer;
  freeSpaceStart_raw += bgStartOffset;
  int freeSpaceSize_raw = ifs.size() - freeSpaceStart_raw;
  freeSpaceSize_raw -= 0x2000;
//  cerr << hex << freeSpaceSize_raw
//    << " " << 0xE000 - freeSpaceSize_raw << endl;
  
//  TStringSearchResultList searchResults
//    = TStringSearch::search(ifs, "AE * * D0 *");
//  cerr << searchResults.size() << endl;
  
  TStringSearchResultList searchResults;

/*; SYNC interrupt vector

00527F  AE A4 26             ldx paletteTransferRequest [$26A4]
005282  D0 07                bne [$528B]
  005284  20 39 51             jsr $5139
  005287  20 AB 51             jsr $51AB
  00528A  60                   rts 
; if palette read or write requested
00528B  A9 00                lda #$00
00528D  8D 02 04             sta $0402
005290  A9 00                lda #$00
005292  8D 03 04             sta $0403
005295  E0 02                cpx #$02
005297  F0 0D                beq [$52A6]
005299  E0 01                cpx #$01
00529B  D0 E7                bne [$5284]
; if read requested
  ; read from color ram
  00529D  F3 04 04 00 00 00 00 tai $0404,$0000,#$0000
  0052A4  80 07                bra [$52AD]
; else if write requested
  ; write to color ram
  0052A6  E3 00 00 04 04 00 00 tia $0000,$0404,#$0000
0052AD  9C A4 26             stz paletteTransferRequest [$26A4]
0052B0  80 D2                bra [$5284] */

/*  TStringSearchResultList searchResults
    = TStringSearch::search(ifs,
        std::string(
          "AE * * "
          "D0 * "
          "20 * * "
          "20 * * "
          "60 "
          "A9 00 "
          "8D 02 04 "
          "A9 00 "
          "8D 03 04"
        )
      ); */
  int syncVector_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "AE * * "
          "D0 * "
          "20 * * "
          "20 * * "
          "60 "
          "A9 00 "
          "8D 02 04 "
          "A9 00 "
          "8D 03 04"
        )
      ).offset;
//  cerr << hex << syncVector_raw + loadAddr << endl;
  int syncMakeup1_raw
    = getAddrParamAsRawOffset(ifs, syncVector_raw + (0x5284 - 0x527F));
  int syncMakeup2_raw
    = getAddrParamAsRawOffset(ifs, syncVector_raw + (0x5287 - 0x527F));

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
  
/*004D74  A5 3E                lda $003E
004D76  F0 04                beq [$4D7C]
004D78  C6 3D                dec $003D
004D7A  F0 0A                beq [$4D86]
  004D7C  60                   rts 
; loop
  ; terminate if ???
  004D7D  20 3C 4E             jsr $4E3C
  004D80  90 17                bcc [$4D99]
    004D82  68                   pla 
    004D83  53 40                tam #$40
    004D85  60                   rts 
    
  ; init -- runs only on first loop?
    004D86  03 00                st0 #$00
    004D88  13 00                st1 #$00
    004D8A  23 7F                st2 #$7F
    004D8C  03 02                st0 #$02
    ; max sprites capped at 0x20?
    004D8E  A9 20                lda #$20
    004D90  85 3B                sta $003B
    004D92  43 40                tma #$40 */
  int genHighPrioritySpriteObj_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "A5 3E "
          "F0 04 "
          "C6 3D "
          "F0 0A "
          "60 "
          "20 * * "
          "90 17 "
          "68 "
          "53 40 "
          "60 "
          "03 00 "
          "13 00 "
          "23 7F "
          "03 02 "
          "A9 20 "
          "85 3B "
          "43 40"
        )
      ).offset;
  
/*004CA3  A5 2D                lda $002D
004CA5  F0 04                beq [$4CAB]
004CA7  C6 3C                dec $003C
004CA9  F0 0A                beq [$4CB5]
  004CAB  60                   rts 
; loop
    004CAC  20 60 4D             jsr $4D60
    004CAF  90 21                bcc [$4CD2]
    ; if srcaddr was not set?
      004CB1  68                   pla 
      004CB2  53 40                tam #$40
      004CB4  60                   rts 
  ; vram write target = $7F80, the second half of the sprite table
  004CB5  03 00                st0 #$00
  004CB7  13 80                st1 #$80
  004CB9  23 7F                st2 #$7F */
  int genLowPrioritySpriteObj_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "A5 2D "
          "F0 04 "
          "C6 3C "
          "F0 0A "
          "60 "
          "20 * * "
          "90 21 "
          "68 "
          "53 40 "
          "60 "
          "03 00 "
          "13 80 "
          "23 7F "
        )
      ).offset;
  
/*; clear sprite table
00755D  20 A2 E0             jsr EX_SATCLR [$E0A2]
; sprite table to SATB
007560  20 9F E0             jsr EX_SPRDMA [$E09F]
007563  9C E3 26             stz $26E3
007566  9C E2 26             stz $26E2
007569  60                   rts */
  int clearAndSendSpriteTable_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "20 A2 E0 "
          "20 9F E0 "
          "9C * * "
          "9C * * "
          "60"
        )
      ).offset;
  
  ifs.seek(clearAndSendSpriteTable_raw + 7);
  int spriteTableClearMakeup1 = ifs.readu16le();
  ifs.seek(clearAndSendSpriteTable_raw + 10);
  int spriteTableClearMakeup2 = ifs.readu16le();
  
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
  
/*006B72  A9 80                lda #$80
006B74  85 20                sta $0020
006B76  A5 1B                lda $001B
006B78  F0 02                beq [$6B7C]
006B7A  64 20                stz $0020
006B7C  43 40                tma #$40
006B7E  85 1D                sta $001D
006B80  AD 7D 26             lda $267D
006B83  53 40                tam #$40
006B85  A5 C2                lda $00C2
006B87  85 29                sta $0029
006B89  A5 C3                lda $00C3
006B8B  4A                   lsr 
006B8C  66 29                ror $0029
006B8E  4A                   lsr 
006B8F  66 29                ror $0029
006B91  4A                   lsr 
006B92  66 29                ror $0029
006B94  4A                   lsr 
006B95  66 29                ror $0029
006B97  4A                   lsr 
006B98  66 29                ror $0029
006B9A  85 2A                sta $002A
006B9C  20 0F 6D             jsr $6D0F
006B9F  A5 F8                lda $00F8
006BA1  8D 0E 6C             sta $6C0E
006BA4  18                   clc 
006BA5  69 04                adc #$04
006BA7  85 2B                sta $002B
006BA9  A5 F9                lda $00F9
006BAB  8D 0F 6C             sta $6C0F
006BAE  69 00                adc #$00
006BB0  85 2C                sta $002C
006BB2  A6 CA                ldx $00CA
006BB4  BD 5F 76             lda $765F,X*/
  TStringSearchResultList setUpSpritesRaw_raw_list
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "A9 80 "
          "85 20 "
          "A5 1B "
          "F0 02 "
          "64 20 "
          "43 40 "
          "85 1D "
          "AD 7D 26 "
          "53 40 "
          "A5 C2 "
          "85 29 "
          "A5 C3 "
          "4A "
          "66 29 "
          "4A "
          "66 29 "
          "4A "
          "66 29 "
          "4A "
          "66 29 "
          "4A "
          "66 29 "
          "85 2A "
          "20 * * "
          "A5 F8 "
          "8D * * "
          "18 "
          "69 04 "
          "85 2B "
          "A5 F9 "
          "8D * * "
          "69 00 "
          "85 2C "
          "A6 CA "
          "BD * *"
        )
      );
  int setUpSpritesRaw_raw = -1;
  if (setUpSpritesRaw_raw_list.size() != 0) {
    setUpSpritesRaw_raw = setUpSpritesRaw_raw_list[0].offset;
    
//    ifs.seek(setUpSpritesRaw_raw + (0x6C98 - 0x6B72));
//    if (ifs.readu16be() != 0xA900) return 1;
  }

/*006BA9  A5 FA                lda $00FA
006BAB  D0 05                bne [$6BB2]
006BAD  9C 72 6C             stz $6C72
006BB0  80 05                bra [$6BB7]
  006BB2  A9 40                lda #$40
  006BB4  8D 72 6C             sta $6C72
006BB7  A5 F8                lda $00F8
006BB9  CD 63 29             cmp $2963
006BBC  D0 1C                bne [$6BDA]
006BBE  A5 F9                lda $00F9
006BC0  CD 64 29             cmp $2964
006BC3  D0 15                bne [$6BDA]
006BC5  AD 65 29             lda $2965
006BC8  0D 66 29             ora $2966
006BCB  F0 17                beq [$6BE4]
006BCD  AD 65 29             lda $2965
006BD0  85 F8                sta $00F8
006BD2  AD 66 29             lda $2966
006BD5  85 F9                sta $00F9
006BD7  4C 69 6C             jmp $6C69
006BDA  A5 F8                lda $00F8
006BDC  8D 63 29             sta $2963
006BDF  A5 F9                lda $00F9
006BE1  8D 64 29             sta $2964
006BE4  43 40                tma #$40
006BE6  48                   pha 
006BE7  AD 59 29             lda $2959
006BEA  53 40                tam #$40 */
  
  TStringSearchResultList playAdpcm_raw_list
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "A5 FA "
          "D0 05 "
          "9C * * "
          "80 05 "
          "A9 40 "
          "8D * * "
          "A5 F8 "
          "CD * * "
          "D0 1C "
          "A5 F9 "
          "CD * * "
          "D0 15 "
          "AD * * "
          "0D * * "
          "F0 17 "
          "AD * * "
          "85 F8 "
          "AD * * "
          "85 F9 "
          "4C * * "
          "A5 F8 "
          "8D * * "
          "A5 F9 "
          "8D * * "
          "43 40 "
          "48 "
          "AD 59 29 "
          "53 40"
        )
      );
  // this routine does NOT exist in scene1C.
  // or if it does, it's in some altered form.
  int playAdpcm_raw = -1;
  int playAdpcmMakeup1 = -1;
  if (playAdpcm_raw_list.size() != 0) {
    playAdpcm_raw = playAdpcm_raw_list[0].offset;
    
    ifs.seek(playAdpcm_raw + (0x6BAE - 0x6BA9));
    playAdpcmMakeup1 = ifs.readu16le();
  }
  
/*  
  00646D  68                   pla 
  00646E  53 40                tam #$40
  006470  68                   pla 
  006471  53 20                tam #$20
  006473  A5 2B                lda $002B
  006475  85 F8                sta $00F8
  006477  A5 2C                lda $002C
  006479  85 F9                sta $00F9
  00647B  A9 00                lda #$00
  00647D  85 FA                sta $00FA
  00647F  A9 08                lda #$08
  006481  85 FB                sta $00FB
  
  006483  20 C3 E0             jsr $E0C3
  006486  A5 FC                lda $00FC
  006488  85 F8                sta $00F8
  00648A  8D 65 29             sta $2965
  00648D  A5 FD                lda $00FD
  00648F  85 F9                sta $00F9
  006491  8D 66 29             sta $2966
  006494  64 FA                stz $00FA
  006496  64 FB                stz $00FB
  006498  A9 0E                lda #$0E
  00649A  85 FF                sta $00FF
     v--------- target this line
  00649C  A9 00                lda #$00
  00649E  85 FE                sta $00FE
  0064A0  20 3C E0             jsr AD_PLAY [$E03C]
  0064A3  60                   rts */
  
  TStringSearchResultList playAdpcmSpecial_raw_list
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "68 "
          "53 40 "
          "68 "
          "53 20 "
          "A5 2B "
          "85 F8 "
          "A5 2C "
          "85 F9 "
          "A9 00 "
          "85 FA "
          "A9 08 "
          "85 FB "
          "20 C3 E0 "
          "A5 FC "
          "85 F8 "
          "8D * * "
          "A5 FD "
          "85 F9 "
          "8D * * "
          "64 FA "
          "64 FB "
          "A9 0E "
          "85 FF "
          "A9 00 "
          "85 FE "
          "20 3C E0 "
          "60"
        )
      );
  // this routine does NOT exist in scene1C.
  // or if it does, it's in some altered form.
  int playAdpcmSpecial_raw = -1;
  if (playAdpcmSpecial_raw_list.size() == 1) {
    playAdpcmSpecial_raw = playAdpcmSpecial_raw_list[0].offset
      + 0x2D;
  }
  
  /*006C63  A5 FA                lda $00FA
  006C65  D0 05                bne [$6C6C]
  ; if
    006C67  9C 84 6C             stz $6C84
    006C6A  80 05                bra [$6C71]
  ; else
    006C6C  A9 40                lda #$40
    006C6E  8D 84 6C             sta $6C84
  006C71  AD 65 29             lda $2965
  006C74  85 F8                sta $00F8
  006C76  AD 66 29             lda $2966
  006C79  85 F9                sta $00F9
  006C7B  64 FA                stz $00FA
  006C7D  64 FB                stz $00FB
  006C7F  A9 0E                lda #$0E
  006C81  85 FF                sta $00FF
  006C83  A9 00                lda #$00
  006C85  85 FE                sta $00FE
  006C87  20 3C E0             jsr $E03C
  006C8A  60                   rts */
  TStringSearchResultList playAdpcmAlt_raw_list
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "A5 FA "
          "D0 05 "
          "9C * * "
          "80 05 "
          "A9 40 "
          "8D * * "
          "AD 65 29 "
          "85 F8 "
          "AD 66 29 "
          "85 F9 "
          "64 FA "
          "64 FB "
          "A9 0E "
          "85 FF "
          "A9 00 "
          "85 FE "
          "20 3C E0 "
          "60"
        )
      );
  int playAdpcmAlt_raw = -1;
  if (playAdpcmAlt_raw_list.size() == 1) {
    playAdpcmAlt_raw = playAdpcmAlt_raw_list[0].offset;
//      + 0x20;
  }
  
  if (!noBackground) {
    ofs << ".unbackground "
      << getHexWordNumStr(freeSpaceStart_raw)
      << " "
      << getHexWordNumStr(freeSpaceStart_raw + freeSpaceSize_raw - 1)
      << endl;
  }
  outputDefineFromRawOffset(ofs, "syncVector", syncVector_raw);
  outputDefineFromRawOffset(ofs, "syncMakeup1", syncMakeup1_raw);
  outputDefineFromRawOffset(ofs, "syncMakeup2", syncMakeup2_raw);
  outputDefineFromRawOffset(
    ofs, "genHighPrioritySpriteObj", genHighPrioritySpriteObj_raw);
  outputDefineFromRawOffset(
    ofs, "genLowPrioritySpriteObj", genLowPrioritySpriteObj_raw);
  outputDefineFromRawOffset(
    ofs, "clearAndSendSpriteTable", clearAndSendSpriteTable_raw);
  outputDefine(
    ofs, "spriteTableClearMakeup1", spriteTableClearMakeup1);
  outputDefine(
    ofs, "spriteTableClearMakeup2", spriteTableClearMakeup2);
  outputDefineFromRawOffset(
    ofs, "waitForSync", waitForSync_raw);
  if (setUpSpritesRaw_raw != -1) {
    outputDefineFromRawOffset(
      ofs, "setUpSpritesRaw", setUpSpritesRaw_raw);
  }
  if (playAdpcm_raw != -1) {
    outputDefineFromRawOffset(
      ofs, "playAdpcm", playAdpcm_raw);
  }
  if (playAdpcmMakeup1 != -1) {
    outputDefine(
      ofs, "playAdpcmMakeup1", playAdpcmMakeup1);
  }
  if (playAdpcmSpecial_raw != -1) {
    outputDefineFromRawOffset(
      ofs, "playAdpcmSpecial", playAdpcmSpecial_raw);
  }
  if (playAdpcmAlt_raw != -1) {
    outputDefineFromRawOffset(
      ofs, "playAdpcmAlt", playAdpcmAlt_raw);
  }
  
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
