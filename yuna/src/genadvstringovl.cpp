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

std::string getNoPrefixHexByteNumStr(int num) {
  std::string str = TStringConversion::intToString(num,
    TStringConversion::baseHex).substr(2, string::npos);
  while (str.size() < 2) str = string("0") + str;
  return str;
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
    cout << "Yuna PCECD adv string overlay include generator" << endl;
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
  ofs.open(string("asm/include/") + baseName + "_ovlAdvString.inc");
  
  ifs.seek(ifs.size() - 1);
  while (ifs.peek() == fillChar) ifs.seekoff(-1);
  int freeSpaceStart_raw = ifs.tell();
  // safety
  freeSpaceStart_raw += freeSpaceStartSafetyBuffer;
  int freeSpaceSize_raw = ifs.size() - freeSpaceStart_raw;
  freeSpaceSize_raw -= 0x2000;
//  cerr << hex << freeSpaceSize_raw
//    << " " << 0xE000 - freeSpaceSize_raw << endl;
  
//  TStringSearchResultList searchResults
//    = TStringSearch::search(ifs, "AE * * D0 *");
//  cerr << searchResults.size() << endl;

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
  
/*006D0D  20 E2 59             jsr waitVsync [$59E2]
; loop
  006D10  B2 B3                lda ($00B3)
  006D12  85 F9                sta $00F9
  006D14  F0 2F                beq [$6D45]
    006D16  E6 B3                inc $00B3
    006D18  D0 02                bne [$6D1C]
      006D1A  E6 B4                inc $00B4
    006D1C  B2 B3                lda ($00B3)
    006D1E  85 F8                sta $00F8
    006D20  E6 B3                inc $00B3
    006D22  D0 02                bne [$6D26]
      006D24  E6 B4                inc $00B4
    006D26  64 FA                stz $00FA
    006D28  64 FB                stz $00FB */
  int printSimpleString_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "20 * * "
          "B2 * "
          "85 F9 "
          "F0 2F "
          "E6 * "
          "D0 02 "
          "E6 * "
          "B2 * "
          "85 F8 "
          "E6 * "
          "D0 02 "
          "E6 * "
          "64 FA "
          "64 FB"
        )
      ).offset;
  ifs.seek(printSimpleString_raw + (0x6D10 - 0x6D0D) + 1);
  int stringSrcPtr = ifs.readu8();
  
/*007852  69 50                adc #$50
007854  8D FC 76             sta $76FC
007857  A9 F3                lda #$F3
007859  85 B3                sta $00B3
00785B  A9 76                lda #$76
00785D  85 B4                sta $00B4
00785F  64 1B                stz $001B
007861  A5 A7                lda $00A7
007863  85 1C                sta $001C
007865  A9 03                lda #$03

007867  85 1D                sta $001D
007869  A9 01                lda #$01
00786B  85 1E                sta $001E
00786D  20 0D 6D             jsr $6D0D
007870  A9 78                lda #$78
007872  20 F5 58             jsr $58F5
007875  20 58 7B             jsr $7B58*/
//  int sjisDigitConv1_raw
  TStringSearchResultList sjisDigitConv1_searchResults
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "69 50 "
          "8D * * "
          "A9 * "
          "85 * "
          "A9 * "
          "85 * "
          "64 1B "
          "A5 * "
          "85 1C "
          "A9 03 "
          "85 1D "
          "A9 01 "
          "85 1E "
          "20 * * "
          "A9 78 "
          "20 * * "
          "20 * *"
        )
      );
//  for (int i = 0; i < sjisDigitConv1_searchResults.size(); i++) {
//    std::cerr << getHexWordNumStr(sjisDigitConv1_searchResults[i].offset) << std::endl;
//  }
  
  
/*006855  64 1B                stz $001B
006857  64 1C                stz $001C
006859  A5 F8                lda $00F8
00685B  85 27                sta $0027
00685D  A5 F9                lda $00F9
00685F  85 28                sta $0028
006861  20 2A 60             jsr pageInTextBlock? [$602A]
006864  C2                   cly 
006865  20 46 69             jsr seek27YIndexToNextNonSpace [$6946]
006868  B1 27                lda ($0027),Y
00686A  D0 08                bne [$6874]
  00686C  A5 1B                lda $001B
  00686E  85 F8                sta $00F8
  006870  20 42 60             jsr $6042
  006873  60                   rts 
006874  C8                   iny 
006875  C9 66                cmp #$66
006877  D0 2B                bne [$68A4]
006879  20 25 69             jsr $6925
00687C  A5 29                lda $0029
00687E  85 F8                sta $00F8
006880  A5 2A                lda $002A*/
/*  int evaluateConditionString_raw
    = TStringSearch::searchFullStreamForUnique(ifs,
        std::string(
          "64 1B "
          "64 1C "
          "A5 F8 "
          "85 27 "
          "A5 F9 "
          "85 28 "
          "20 * * "
          "C2 "
          "20 * * "
          "B1 27 "
          "D0 08"
        )
      ).offset; */

  TStringSearchResultList doStandardStringLookupCall_searchResults
    = TStringSearch::searchFullStream(ifs,
        std::string(
          "20 "
          + getNoPrefixHexByteNumStr(
              (printSimpleString_raw + loadAddr) & 0xFF)
          + " "
          + getNoPrefixHexByteNumStr(
              ((printSimpleString_raw + loadAddr) >> 8) & 0xFF)
        )
      );
  
  if (!noBackground) {
    ofs << ".unbackground "
      << getHexWordNumStr(freeSpaceStart_raw)
      << " "
      << getHexWordNumStr(freeSpaceStart_raw + freeSpaceSize_raw - 1)
      << endl;
  }
  outputDefineFromRawOffset(ofs,
    "printSimpleString", printSimpleString_raw);
  outputDefine(ofs,
    "stringSrcPtr", stringSrcPtr);
  
  {
    int num = 0;
    for (TStringSearchResultList::iterator it
          = doStandardStringLookupCall_searchResults.begin();
         it != doStandardStringLookupCall_searchResults.end();
         ++it) {
      int trueOffset = it->offset + loadAddr;
      ofs << ".bank 0 slot 0" << std::endl;
      ofs << ".orga " << getHexWordNumStr(trueOffset) << std::endl;
      ofs << ".section \"stdStringLookup fix " << num << "\" overwrite"
        << std::endl;
      ofs << "  jsr doNewStandardStringLookup" << std::endl;
      ofs << ".ends" << std::endl;
      ++num;
    }
  }
  for (int i = 0; i < sjisDigitConv1_searchResults.size(); i++) {
    std::string defName = "fileNumInsert"
      + TStringConversion::intToString(i);
    outputDefineFromRawOffset(ofs,
      defName, sjisDigitConv1_searchResults[i].offset);
  }
  
  }
  catch (TGenericException& e) {
    cerr << "exception: " << e.problem() << endl;
    return 1;
  }
  catch (...) {
    return 1;
  }
  
  return 0;
}
