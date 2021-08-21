#include "smpce/SmPceMsgScriptDecmp.h"
#include "smpce/SmPceVarScriptDecmp.h"
#include "smpce/SmPceFileIndex.h"
#include "smpce/SmPceGraphic.h"
#include "pce/okiadpcm.h"
#include "pce/PcePalette.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include "util/TCsv.h"
#include "util/TSoundFile.h"
#include <string>
#include <iostream>

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

void generate(std::string baseName, int num) {
  for (int i = 0; i < num; i++) {
    std::string numStr = getNumStr(i);
    cout << ".db " << baseName << "sub" << numStr << "PatternsOffsetLo"
      << ","
      << baseName << "sub" << numStr << "PatternsOffsetMid"
      << ","
      << baseName << "sub" << numStr << "PatternsOffsetHi"
      << endl;
  }
  
  for (int i = 0; i < num; i++) {
    std::string numStr = getNumStr(i);
    cout << ".db " << baseName << "sub" << numStr << "AttributesOffsetLo"
      << ","
      << baseName << "sub" << numStr << "AttributesOffsetMid"
      << ","
      << baseName << "sub" << numStr << "AttributesOffsetHi"
      << endl;
  }
  
  for (int i = 0; i < num; i++) {
    std::string numStr = getNumStr(i);
    cout << ".db " << baseName << "sub" << numStr << "NumPatterns"
      << endl;
  }
  
  for (int i = 0; i < num; i++) {
    std::string numStr = getNumStr(i);
    cout << ".dw " << baseName << "sub" << numStr << "PatternsSize"
      << endl;
  }
  
  for (int i = 0; i < num; i++) {
    std::string numStr = getNumStr(i);
    cout << "; " << numStr << endl;
    cout << ".dw $0000" << endl;
  }
}

void printSpriteObj(TStream& ifs, int offset) {
  ifs.seek(offset);
  int count = ifs.readu8();
  
  cout << "; number of sprites" << endl;
  cout << ".db " << count << endl;
  cout << "; sprite data" << endl;
  for (int i = 0; i < count; i++) {
    int y = ifs.readu16le();
    int x = ifs.readu16le();
    int tile = ifs.readu16le();
    int flags = ifs.readu16le();
    
    cout << ".dw "
      << getHexWordNumStr(y)
      << ","
      << getHexWordNumStr(x)
      << ","
      << getHexWordNumStr(tile)
      << ","
      << getHexWordNumStr(flags)
      << endl;
  }
  
  cout << endl;
}

int main(int argc, char* argv[]) {
//  generate("preboss_", 52);
//  generate("ending_", 10);

  TBufStream ifs;
  ifs.open("base/intro_21_E000.bin");
  
  printSpriteObj(ifs, 0x826);
  printSpriteObj(ifs, 0x987);
  printSpriteObj(ifs, 0xAF0);
  
  return 0;
}
