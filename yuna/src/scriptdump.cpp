#include "yuna/YunaTranslationSheet.h"
#include "pce/PcePalette.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include <cctype>
#include <string>
#include <vector>
#include <iostream>
#include <sstream>
#include <fstream>

using namespace std;
using namespace BlackT;
using namespace Pce;

YunaTranslationSheet translationSheet;
TThingyTable tableSjisUtf8;

std::string getNumStr(int num) {
  std::string str = TStringConversion::intToString(num);
  while (str.size() < 2) str = string("0") + str;
  return str;
}

std::string getHexByteNumStr(int num) {
  std::string str = TStringConversion::intToString(num,
    TStringConversion::baseHex).substr(2, string::npos);
  while (str.size() < 2) str = string("0") + str;
  return string("$") + str;
}

std::string getHexWordNumStr(int num) {
  std::string str = TStringConversion::intToString(num,
    TStringConversion::baseHex).substr(2, string::npos);
  while (str.size() < 4) str = string("0") + str;
  return string("$") + str;
}

void addLabelWide(std::ostream& outofs, std::string text) {
  std::ostringstream ofs;
  
  ofs << "//=========================================================================="
    << endl;
  ofs << "// " << text
    << endl;
  ofs << "//==========================================================================";
  
  outofs << ofs.str();
  outofs << endl << endl;
  
  std::ostringstream ofs2;
  ofs2 << "//====================================="
    << endl;
  ofs2 << "// " << text
    << endl;
  ofs2 << "//=====================================";
  
  YunaTranslationString transStr;
  transStr.command = "";
  transStr.original = ofs2.str();
  translationSheet.addEntry(transStr);
}

void addLabelNarrow(std::ostream& outofs, std::string text) {
  std::ostringstream ofs;
  
  ofs << "//====================================="
    << endl;
  ofs << "// " << text
    << endl;
  ofs << "//=====================================";
  
  outofs << ofs.str();
  outofs << endl << endl;
  
  std::ostringstream ofs2;
  ofs2 << "//=================="
    << endl;
  ofs2 << "// " << text
    << endl;
  ofs2 << "//==================";
  
  YunaTranslationString transStr;
  transStr.command = "";
  transStr.original = ofs2.str();
  translationSheet.addEntry(transStr);
}

void addComment(std::ostream& ofs, std::string text) {
  ofs << "// " << text
    << endl;
  ofs << endl;
}

const static int textBlockBaseSector = 0x85EA;
const static int textBlockSize = 0x4000;
const static int sectorSize = 0x800;

/*void dumpString(TStream& ifs, std::ostream& outofs, int index,
                int srcOffsetOverride = -1) {
  std::ostringstream ofs;
  int startPos = ifs.tell();
  
  bool atLineStart = true;
  bool onCommentLine = false;
  bool literalsNotColors = false;
  while (true) {
    char next = ifs.get();
    if (next == 0x00) break;
    
    if (next > 0) {
      if (next == '\x0A') {
        // linebreak
        ofs << "[br]" << endl;
        atLineStart = true;
        onCommentLine = false;
      }
      else {
        if (!literalsNotColors
            && (isdigit(next)
                || (next == 'A')
                || (next == 'B')
                || (next == 'C')
                || (next == 'D')
                || (next == 'E')
                || (next == 'F'))
            ) {
          if (onCommentLine) {
            ofs << endl;
            onCommentLine = false;
          }
          ofs << "[color" << next << "]" << endl;
          onCommentLine = false;
          atLineStart = true;
        }
        else {
//          if (atLineStart) {
//            ofs << "// ";
//            atLineStart = false;
//            onCommentLine = true;
//          }
          if (atLineStart) {
            atLineStart = false;
            onCommentLine = false;
          }
          
          ofs << next;
          
          literalsNotColors = true;
        }
      }
    }
    else {
      // 2-byte sjis sequence
      
      char nextnext = ifs.get();
      unsigned char uNext = next;
      unsigned char uNextNext = nextnext;
      
      if ((uNext == 0x81) && (uNextNext == 0xA5)) {
        // "more" indicator"
        
        if (!atLineStart) {
          ofs << endl;
        }
        ofs << endl;
        
        ofs << "[more]" << endl;
        atLineStart = true;
        onCommentLine = false;
      }
      else {
        if (atLineStart) {
          ofs << "// ";
          atLineStart = false;
          onCommentLine = true;
        }
        
        ofs << next << nextnext;
      }
    }
  }
  
  if (!atLineStart) ofs << endl;
  ofs << endl;
  
  // literal string flag
  // i'm assuming these bajillion little strings with "f63 = 0"
  // and the like are actually used for setting/evaluating
  // conditions or something, so flag them as such
  bool isLiteral = literalsNotColors;
  
  outofs << "#STARTSTRING(" << index
    << ", "
    <<  TStringConversion::intToString(
          (srcOffsetOverride == -1) ? startPos : srcOffsetOverride,
          TStringConversion::baseHex)
    << ", "
    <<  TStringConversion::intToString(ifs.tell() - startPos,
          TStringConversion::baseHex)
    << ", "
    << TStringConversion::intToString(isLiteral)
    << ")" << endl << endl;
    
  outofs << ofs.str();
  
  outofs << endl << "#ENDSTRING()" << endl << endl;
} */

void dumpString(TStream& ifs, std::ostream& outofs, int index,
                int srcOffsetOverride = -1) {
  std::ostringstream ofs;
  std::ostringstream preOfs;
  std::ostringstream contentOfs;
  std::ostringstream postOfs;
  int startPos = ifs.tell();
  
  bool atLineStart = true;
  bool onCommentLine = false;
  bool literalsNotColors = false;
  while (true) {
    char next = ifs.get();
    if (next == 0x00) break;
    
    if (next > 0) {
      if (next == '\x0A') {
        // linebreak
        ofs << "[br]" << endl;
        atLineStart = true;
        onCommentLine = false;
        
        contentOfs << "[br]" << endl;
      }
      else {
        if (!literalsNotColors
            && (isdigit(next)
                || (next == 'A')
                || (next == 'B')
                || (next == 'C')
                || (next == 'D')
                || (next == 'E')
                || (next == 'F'))
            ) {
          if (onCommentLine) {
            ofs << endl;
            onCommentLine = false;
          }
          ofs << "[color" << next << "]" << endl;
          onCommentLine = false;
          atLineStart = true;
          
          if (!contentOfs.str().size()) {
            preOfs << "[color" << next << "]";
          }
          else {
            contentOfs << "[color" << next << "]" << endl;
          }
        }
        else {
//          if (atLineStart) {
//            ofs << "// ";
//            atLineStart = false;
//            onCommentLine = true;
//          }
          if (atLineStart) {
            atLineStart = false;
            onCommentLine = false;
          }
          
          ofs << next;
          contentOfs << next;
          
          literalsNotColors = true;
        }
      }
    }
    else {
      // 2-byte sjis sequence
      
      char nextnext = ifs.get();
      unsigned char uNext = next;
      unsigned char uNextNext = nextnext;
      
      if ((uNext == 0x81) && (uNextNext == 0xA5)) {
        // "more" indicator"
        
        if (!atLineStart) {
          ofs << endl;
        }
        ofs << endl;
        
        ofs << "[more]" << endl;
        atLineStart = true;
        onCommentLine = false;
        
        // FIXME: is this assumption safe?
        postOfs << "[more]";
      }
      else {
        if (atLineStart) {
          ofs << "// ";
          atLineStart = false;
          onCommentLine = true;
        }
        
        ofs << next << nextnext;
        contentOfs << next << nextnext;
      }
    }
  }
  
  if (!atLineStart) ofs << endl;
  ofs << endl;
  
  // literal string flag
  // i'm assuming these bajillion little strings with "f63 = 0"
  // and the like are actually used for setting/evaluating
  // conditions or something, so flag them as such
  bool isLiteral = literalsNotColors;
  
  // add translation string
  int srcId = -1;
  if (!isLiteral) {
    YunaTranslationString transStr;
    transStr.id = translationSheet.nextEntryId();
    srcId = transStr.id;
    transStr.sharedContentPre = preOfs.str();
    transStr.sharedContentPost = postOfs.str();
//    transStr.original = contentOfs.str();
    // convert from SJIS to UTF8
//    std::cerr << translationSheet.nextEntryId() << endl;
    {
      std::string origRaw = contentOfs.str();
      TBufStream conv;
      conv.writeString(origRaw);
      conv.seek(0);
//      cerr << conv.size() << endl;
      while (!conv.eof()) {
        if (conv.peek() == '\x0A') {
          transStr.original += conv.get();
        }
        else if (conv.peek() == '[') {
          std::string name;
          while (!conv.eof()) {
            char next = conv.get();
            name += next;
            if (next == ']') break;
          }
          transStr.original += name;
        }
        else {
          TThingyTable::MatchResult result = tableSjisUtf8.matchId(conv);
          transStr.original += tableSjisUtf8.getEntry(result.id);
        }
      }
    }
    translationSheet.addEntry(transStr);
  }
  
  outofs << "#STARTSTRING(" << index
    << ", "
    <<  TStringConversion::intToString(
          (srcOffsetOverride == -1) ? startPos : srcOffsetOverride,
          TStringConversion::baseHex)
    << ", "
    <<  TStringConversion::intToString(ifs.tell() - startPos,
          TStringConversion::baseHex)
    << ", "
    << TStringConversion::intToString(isLiteral)
    << ")" << endl << endl;
  
  if (isLiteral) {
    outofs << ofs.str();
  }
  else {
    outofs << "#IMPORTSTRING(" << srcId << ")" << endl;
  }
  
  outofs << endl << "#ENDSTRING()" << endl << endl;
}

void dumpTextBlock(TStream& ifs, std::ostream& ofs, int blockNum) {
  addLabelWide(ofs,
               string("Text block ")
                + TStringConversion::intToString(blockNum)
                + " (sector "
                + TStringConversion::intToString(
                    textBlockBaseSector
                    + ((blockNum * textBlockSize) / sectorSize),
                    TStringConversion::baseHex)
                + ")");
  
  int blockBaseAddr = (textBlockBaseSector * sectorSize)
                        + (blockNum * textBlockSize);
  ifs.seek(blockBaseAddr);
  
  int unindexedStringBlockOffset = ifs.readu16le() + 6;
  int stringIndexBlockOffset = unindexedStringBlockOffset + ifs.readu16le();
  int indexedStringBlockOffset = stringIndexBlockOffset + ifs.readu16le();
  
  //=====
  // unindexed strings
  //=====
  
  int unindexedStringBlockSize
    = stringIndexBlockOffset - unindexedStringBlockOffset;
  
  addLabelNarrow(ofs,
                 string("Unindexed strings "));
  
  ofs << "#STARTREGION(" << (blockNum * 2) << ")" << endl
    << endl;
  
  ofs << "#SETSIZE(-1, -1)" << endl
    << endl;
  
//  ofs << "#STARTUNINDEXEDSTRINGBLOCK()" << endl
//    << endl;
  
  ifs.seek(blockBaseAddr + unindexedStringBlockOffset);
  int unindexedStringNum = 0;
  while ((ifs.tell() - blockBaseAddr - unindexedStringBlockOffset)
          < unindexedStringBlockSize) {
    dumpString(ifs, ofs, unindexedStringNum,
               ifs.tell() - (blockBaseAddr + unindexedStringBlockOffset));
    ++unindexedStringNum;
  }
  
//  ofs << "#ENDUNINDEXEDSTRINGBLOCK()" << endl
//    << endl;
  
  ofs << "#ENDREGION(" << (blockNum * 2) << ")" << endl
    << endl;
  
  //=====
  // indexed strings
  //=====
  
  int indexedStringBlockSize
    = indexedStringBlockOffset - stringIndexBlockOffset;
  int numIndexedStrings = indexedStringBlockSize/2;
  
  addLabelNarrow(ofs,
                 string("Indexed strings "));
  
  ofs << "#STARTREGION(" << (blockNum * 2) + 1 << ")" << endl
    << endl;
  
  ofs << "#SETSIZE(240, 4)" << endl
    << endl;
  
//  ofs << "#STARTINDEXEDSTRINGBLOCK()" << endl
//    << endl;
  
  ifs.seek(blockBaseAddr + stringIndexBlockOffset);
//  cerr << ifs.tell() << endl;
  
  std::vector<int> stringIndex;
  for (int i = 0; i < numIndexedStrings; i++) {
    stringIndex.push_back(ifs.readu16le());
  }
  
  for (int i = 0; i < numIndexedStrings; i++) {
    if (stringIndex[i] == 0xFFFF) continue;
    ifs.seek(blockBaseAddr + indexedStringBlockOffset + stringIndex[i]);
    dumpString(ifs, ofs, i,
               ifs.tell() - (blockBaseAddr + indexedStringBlockOffset));
  }
  
//  ofs << "#ENDINDEXEDSTRINGBLOCK()" << endl
//    << endl;
  
  ofs << "#ENDREGION(" << (blockNum * 2) + 1 << ")" << endl
    << endl;
}

const static int battleYunaTextBlockBaseSector = 0xB3BA;
const static int battleYunaTextBlockSize = 0x800;
const static int battleYunaTextLoadAddr = 0x9000;

const static int battleEnemyTextBlockBaseSector = 0xB3FA;
const static int battleEnemyTextBlockSize = 0x800;
const static int battleEnemyTextLoadAddr = 0x9800;

void dumpBattleEnemyTextBlock(TStream& ifs, std::ostream& ofs, int blockNum) {
  addLabelWide(ofs,
               string("Enemy battle message block ")
                + TStringConversion::intToString(blockNum)
                + " (sector "
                + TStringConversion::intToString(
                    battleEnemyTextBlockBaseSector
                    + ((blockNum * battleEnemyTextBlockSize) / sectorSize),
                    TStringConversion::baseHex)
                + ")");
  
  ofs << "#STARTREGION(" << blockNum << ")" << endl
    << endl;
    
  ifs.seek((battleEnemyTextBlockBaseSector + blockNum) * sectorSize);
  TBufStream blockifs;
  blockifs.writeFrom(ifs, battleEnemyTextBlockSize);
  
  int stringIndex = 0;
  
  for (int i = 0; i < (0x9842 - 0x982A) / 2; i++) {
    // invalid: "FF 17"
    if ((blockNum == 12) && (stringIndex == 10)) {
      ++stringIndex;
      continue;
    }
    
    blockifs.seek((0x982A - battleEnemyTextLoadAddr) + (i * 2));
    int offset = blockifs.readu16le() - battleEnemyTextLoadAddr;
    blockifs.seek(offset);
    dumpString(blockifs, ofs, stringIndex++);
  }
  
  for (int i = 0; i < (0x9856 - 0x984A) / 2; i++) {
    blockifs.seek((0x984A - battleEnemyTextLoadAddr) + (i * 2));
    int offset = blockifs.readu16le() - battleEnemyTextLoadAddr;
    blockifs.seek(offset);
    dumpString(blockifs, ofs, stringIndex++);
  }
  
  ofs << "#ENDREGION(" << blockNum << ")" << endl
    << endl;
}

void dumpBattleYunaTextBlock(TStream& ifs, std::ostream& ofs, int blockNum) {
  addLabelWide(ofs,
               string("Yuna battle message block ")
                + TStringConversion::intToString(blockNum)
                + " (sector "
                + TStringConversion::intToString(
                    battleYunaTextBlockBaseSector
                    + ((blockNum * battleYunaTextBlockSize) / sectorSize),
                    TStringConversion::baseHex)
                + ")");
  
  ofs << "#STARTREGION(" << blockNum << ")" << endl
    << endl;
    
  ifs.seek((battleYunaTextBlockBaseSector + blockNum) * sectorSize);
  TBufStream blockifs;
  blockifs.writeFrom(ifs, battleYunaTextBlockSize);
  
  int stringIndex = 0;
  
  for (int i = 0; i < (0x903B - 0x9021) / 2; i++) {
    // apparently invalid
    if ((blockNum == 34) && (stringIndex >= 9)) {
      ++stringIndex;
      continue;
    }
    
    blockifs.seek((0x9021 - battleYunaTextLoadAddr) + (i * 2));
    int offset = blockifs.readu16le() - battleYunaTextLoadAddr;
    blockifs.seek(offset);
    dumpString(blockifs, ofs, stringIndex++);
  }
  
  ofs << "#ENDREGION(" << blockNum << ")" << endl
    << endl;
}

int main(int argc, char* argv[]) {
  if (argc < 2) {
    cout << "Yuna PCECD script dumper" << endl;
    cout << "Usage: " << argv[0] << " [infile]"
      << endl;
    return 0;
  }
  
  string infile(argv[1]);
//  string outfile(argv[2]);

  tableSjisUtf8.readUtf8("table/sjis_utf8_yuna.tbl");

  TBufStream ifs;
  ifs.open(infile.c_str());
  
  {
    std::ofstream ofs;
    ofs.open("script/script.txt", ios_base::binary);
    
    for (int i = 0; i < 34; i++) {
      dumpTextBlock(ifs, ofs, i);
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/battle_enemy.txt", ios_base::binary);
    
    for (int i = 0; i < 16; i++) {
      dumpBattleEnemyTextBlock(ifs, ofs, i);
    }
    
//    for (int i = 24; i < 32; i++) {
//      dumpBattleEnemyTextBlock(ifs, ofs, i);
//    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/battle_yuna.txt", ios_base::binary);
    
    for (int i = 0; i < 40; i++) {
      dumpBattleYunaTextBlock(ifs, ofs, i);
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/battle0.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("battle0: standard battle (yuna vs. somebody else)"));
    
    addLabelWide(ofs,
                 string("generic messages"));
    
    ofs << "#STARTREGION(" << 0 << ")" << endl
      << endl;
    
      ifs.seek((0xB1BA * sectorSize) + 0x10);
      int unindexedStringNum = 0;
      for (int i = 0; i < 32; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1BA * sectorSize));
      }
    
    ofs << "#ENDREGION(" << 0 << ")" << endl
      << endl;
  }
  
  // battle1 is not used so who the hell cares about trying to dump it
  
  {
    std::ofstream ofs;
    ofs.open("script/battle2.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("battle2: \'cutscene\' battle of ria vs. sayuka"));
    
    addLabelWide(ofs,
                 string("generic messages"));
    
    ofs << "#STARTREGION(" << 0 << ")" << endl
      << endl;
    
      ifs.seek((0xB1E2 * sectorSize) + 0x0F);
      int unindexedStringNum = 0;
      for (int i = 0; i < 28; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1E2 * sectorSize));
      }
    
    ofs << "#ENDREGION(" << 0 << ")" << endl
      << endl;
    
    addLabelWide(ofs,
                 string("enemy messages"));
    
    ofs << "#STARTREGION(" << 1 << ")" << endl
      << endl;
    
    {
      ifs.seek((0xB1E2 * sectorSize) + 0x10A0);
      int unindexedStringNum = 0;
      for (int i = 0; i < 9; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1E2 * sectorSize));
      }
    }
    
    ofs << "#ENDREGION(" << 1 << ")" << endl
      << endl;
    
    addLabelWide(ofs,
                 string("ria messages"));
    
    ofs << "#STARTREGION(" << 2 << ")" << endl
      << endl;
    
    {
      ifs.seek((0xB1E2 * sectorSize) + 0x1258);
      int unindexedStringNum = 0;
//      for (int i = 0; i < 18; i++) {
      for (int i = 0; i < 14; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1E2 * sectorSize));
      }
    }
    
    ofs << "#ENDREGION(" << 2 << ")" << endl
      << endl;
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/battle3.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("battle3: \'cutscene\' battle of ria vs. final boss"));
    
    addLabelWide(ofs,
                 string("generic messages"));
    
    ofs << "#STARTREGION(" << 0 << ")" << endl
      << endl;
    
      ifs.seek((0xB1F6 * sectorSize) + 0x0F);
      int unindexedStringNum = 0;
      for (int i = 0; i < 28; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1F6 * sectorSize));
      }
    
    ofs << "#ENDREGION(" << 0 << ")" << endl
      << endl;
    
    addLabelWide(ofs,
                 string("enemy messages"));
    
    ofs << "#STARTREGION(" << 1 << ")" << endl
      << endl;
    
    {
      ifs.seek((0xB1F6 * sectorSize) + 0x113E);
      int unindexedStringNum = 0;
      for (int i = 0; i < 9; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1F6 * sectorSize));
      }
    }
    
    ofs << "#ENDREGION(" << 1 << ")" << endl
      << endl;
    
    addLabelWide(ofs,
                 string("ria messages"));
    
    ofs << "#STARTREGION(" << 2 << ")" << endl
      << endl;
    
    {
      ifs.seek((0xB1F6 * sectorSize) + 0x1334);
      int unindexedStringNum = 0;
//      for (int i = 0; i < 18; i++) {
      for (int i = 0; i < 14; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB1F6 * sectorSize));
      }
    }
    
    ofs << "#ENDREGION(" << 2 << ")" << endl
      << endl;
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/battle4.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("battle4: final boss"));
    
    addLabelWide(ofs,
                 string("generic messages"));
    
    ofs << "#STARTREGION(" << 0 << ")" << endl
      << endl;
    
      ifs.seek((0xB20A * sectorSize) + 0x11);
      int unindexedStringNum = 0;
      for (int i = 0; i < 24; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB20A * sectorSize));
      }
    
    ofs << "#ENDREGION(" << 0 << ")" << endl
      << endl;
    
    addLabelWide(ofs,
                 string("enemy messages"));
    
    ofs << "#STARTREGION(" << 1 << ")" << endl
      << endl;
    
    {
      ifs.seek((0xB20A * sectorSize) + 0x11DA);
      int unindexedStringNum = 0;
      for (int i = 0; i < 9; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB20A * sectorSize));
      }
    }
    
    ofs << "#ENDREGION(" << 1 << ")" << endl
      << endl;
    
    addLabelWide(ofs,
                 string("ria messages"));
    
    ofs << "#STARTREGION(" << 2 << ")" << endl
      << endl;
    
    {
      ifs.seek((0xB20A * sectorSize) + 0x159A);
      int unindexedStringNum = 0;
//      for (int i = 0; i < 18; i++) {
      for (int i = 0; i < 14; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xB20A * sectorSize));
      }
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/system_adv.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("system messages from adv"));
    
    int num = 0;
    
    {
      ifs.seek((0x87EA * sectorSize) + 0x35E4);
      int unindexedStringNum = 0;
      for (int i = 0; i < 21; i++) {
        dumpString(ifs, ofs, num++,
          ifs.tell() - (0x87EA * sectorSize));
      }
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/system_load.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("system messages from load"));
    
    {
      ifs.seek((0x42 * sectorSize) + 0x2E32);
      int unindexedStringNum = 0;
      for (int i = 0; i < 21; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0x42 * sectorSize));
      }
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/system_title.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("system messages from title"));
    
    {
      ifs.seek((0x202 * sectorSize) + 0x300C);
      int unindexedStringNum = 0;
      for (int i = 0; i < 21; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0x202 * sectorSize));
      }
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/system_boot.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("system messages from boot"));
    
    int num = 0;
    
    {
      ifs.seek((0x2E2 * sectorSize) + 0x2F1D);
      for (int i = 0; i < 21; i++) {
        dumpString(ifs, ofs, num++,
          ifs.tell() - (0x2E2 * sectorSize));
      }
    }
    
    {
      ifs.seek((0x2E2 * sectorSize) + 0x01AC);
      for (int i = 0; i < 2; i++) {
        dumpString(ifs, ofs, num++,
          ifs.tell() - (0x2E2 * sectorSize));
      }
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/scene19.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("strings from scene 19 (swimsuit contest results)"));
    
    {
      ifs.seek((0xE42E * sectorSize) + 0x7);
      for (int i = 0; i < 13; i++) {
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xE42E * sectorSize));
      }
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/scene1C.txt", ios_base::binary);
    
    addLabelWide(ofs,
                 string("strings from scene 1C (credits)"));
    
    {
      ifs.seek((0xE46A * sectorSize) + 0xD9D);
      for (int i = 0; i < 156; i++) {
//        cerr << i << " " << ifs.tell() << endl;
        dumpString(ifs, ofs, i,
          ifs.tell() - (0xE46A * sectorSize));
      }
//      cerr << "done" << endl;
    }
  }
  
  {
    std::ofstream ofs;
    ofs.open("script/system_adv.txt", ios_base::binary
                | ios_base::app);
    
    addLabelWide(ofs,
                 string("debug"));
    
    int num = 21;
    
    {
      ifs.seek((0x87EA * sectorSize) + 0x4795);
      for (int i = 0; i < 1; i++) {
        dumpString(ifs, ofs, num++,
          ifs.tell() - (0x87EA * sectorSize));
      }
    }
    
    {
      ifs.seek((0x87EA * sectorSize) + 0x67);
      for (int i = 0; i < 2; i++) {
        dumpString(ifs, ofs, num++,
          ifs.tell() - (0x87EA * sectorSize));
      }
    }
  }
  
  translationSheet.exportCsv("script/script.csv");
  
  return 0;
}
