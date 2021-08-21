#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TBufStream.h"
#include "util/TFileManip.h"
#include "util/TStringConversion.h"
#include "util/TGraphic.h"
#include "util/TPngConversion.h"
#include "util/TOpt.h"
#include "util/TArray.h"
#include "util/TByte.h"
#include "util/TFileManip.h"
#include "pce/PceSpritePattern.h"
#include "pce/PcePalette.h"
#include "pce/PcePaletteLine.h"
#include "yuna/YunaImage.h"
#include <iostream>
#include <string>

using namespace std;
using namespace BlackT;
using namespace Pce;


string as2bHex(int num) {
  string str = TStringConversion::intToString(num,
                  TStringConversion::baseHex).substr(2, string::npos);
  while (str.size() < 2) str = string("0") + str;
  
//  return "<$" + str + ">";
  return str;
}

string as2bHexPrefix(int num) {
  return "$" + as2bHex(num) + "";
}

std::string getAsmHex(int value) {
  std::string raw
    = TStringConversion::intToString(value, TStringConversion::baseHex)
            .substr(2, string::npos);
  while (raw.size() < 4) raw = std::string("0") + raw;
  return std::string("$") + raw;
}

void binToDcb(TStream& ifs, std::ostream& ofs) {
  int constsPerLine = 16;
  
  while (true) {
    if (ifs.eof()) break;
    
    ofs << "  .db ";
    
    for (int i = 0; i < constsPerLine; i++) {
      if (ifs.eof()) break;
      
      TByte next = ifs.get();
      ofs << as2bHexPrefix(next);
      if (!ifs.eof() && (i != constsPerLine - 1)) ofs << ",";
    }
    
    ofs << std::endl;
  }
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Yuna sprite definition extractor" << endl;
    cout << "Usage: " << argv[0] << " <infile> <defcount>" << endl;
    cout << "Disassembled content is written to standard output." << endl;
    cout << "Options:" << std::endl;
    cout << "  -s   Starting offset" << std::endl;
    
    return 0;
  }
  
  char* infile = argv[1];
  int numDefs = TStringConversion::stringToInt(std::string(argv[2]));
//  char* outfile = argv[3];
  
//  int startOffset = 0;
//  TOpt::readNumericOpt(argc, argv, "-s", &startOffset);
  
//  TOpt::readNumericOpt(argc, argv, "-r", &patternsPerRow);
  
//  PcePaletteLine palLine;
//  bool hasPalLine = false;
//  char* palOpt = TOpt::getOpt(argc, argv, "-p");
//  if (palOpt != NULL) {
//    TBufStream ifs;
//    ifs.open(palOpt);
//    palLine.read(ifs);
//    
//    hasPalLine = true;
//  }

  TBufStream ifs;
  ifs.open(infile);
//  ifs.seek(startOffset);
  ifs.seek(0x1000);
  
  for (int i = 0; i < numDefs; i++) {
    cout << "  ;======================" << endl;
    cout << "  ; SPRITE STATE " << i << endl;
    cout << "  ;======================" << endl;
    cout << endl;
    
    int spriteNum = 0;
    while (true) {
      int y = ifs.readu16le();
      int x = ifs.readu16le();
      int patNum = ifs.readu16le();
      int flags = ifs.readu16le();
      
      if (patNum == 0xFFFF) {
        cout << "  ; terminator" << endl;
        cout << "  .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF" << endl;
        cout << endl;
        break;
      }
      
      cout << "    ;==========" << endl;
      cout << "    ; sprite " << spriteNum++ << endl;
      cout << "    ;==========" << endl;
      
      cout << "    ; y" << endl;
      cout << "    .dw " << getAsmHex(y) << endl;
      cout << "    ; x" << endl;
      cout << "    .dw " << getAsmHex(x) << endl;
      cout << "    ; patnum" << endl;
      cout << "    .dw " << getAsmHex(patNum) << endl;
      cout << "    ; flags" << endl;
      cout << "    .dw " << getAsmHex(flags) << endl;
      cout << endl;
    }
  }
  
  cout << "  ;======================" << endl;
  cout << "  ; remainder " << endl;
  cout << "  ;======================" << endl;
  
  TBufStream remainder;
  binToDcb(ifs, cout);
  
  return 0;
}
