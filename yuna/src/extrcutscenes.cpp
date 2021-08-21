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
#include <string>
#include <iostream>

using namespace std;
using namespace BlackT;
using namespace Pce;

int sectorSize = 0x800;
int blockSize = 0x14 * 0x800;

int main(int argc, char* argv[]) {
  if (argc < 1) {
    cout << "Yuna PCECD cutscene extractor" << endl;
    return 0;
  }
  
  {
    TBufStream ifs;
    ifs.open("base/scenes_all_E23A.bin");
    
    for (int i = 0; i < 0x1D; i++) {
      int sectorOffset = i * 0x14;
      int realSectorNum = sectorOffset + 0xE23A;
      std::string realSectorNumStr = TStringConversion::intToString
        (realSectorNum, TStringConversion::baseHex).substr(2, string::npos);
      std::string idString = TStringConversion::intToString
                  (i, TStringConversion::baseHex).substr(2, string::npos);
      while (idString.size() < 2) idString = string("0") + idString;
      
      ifs.seek(sectorOffset * sectorSize);
      TBufStream temp;
      temp.writeFrom(ifs, blockSize);
      
  /*    temp.seek(temp.size() - 1);
      while (temp.peek() == 0x00) temp.seekoff(-1);
      int remaining = temp.size() - temp.tell();
      cerr << idString << ": " << hex << remaining
        << " " << 0xE000 - remaining << endl; */
      
      temp.save((string("base/scene")
                + idString
  //              + "_"
  //              + realSectorNumStr
                + ".bin").c_str());
      
    }
  }
  
  {
    TBufStream ifs;
    ifs.open("base/postbat_all_B4DA.bin");
    
    for (int i = 0; i < 0x11; i++) {
      int sectorOffset = i * 0x14;
      int realSectorNum = sectorOffset + 0xB4DA;
      std::string realSectorNumStr = TStringConversion::intToString
        (realSectorNum, TStringConversion::baseHex).substr(2, string::npos);
      std::string idString = TStringConversion::intToString
                  (i, TStringConversion::baseHex).substr(2, string::npos);
      while (idString.size() < 2) idString = string("0") + idString;
      
      ifs.seek(sectorOffset * sectorSize);
      TBufStream temp;
      temp.writeFrom(ifs, blockSize);
      
  /*    temp.seek(temp.size() - 1);
      while (temp.peek() == 0x00) temp.seekoff(-1);
      int remaining = temp.size() - temp.tell();
      cerr << idString << ": " << hex << remaining
        << " " << 0xE000 - remaining << endl; */
      
      temp.save((string("base/postbat")
                + idString
  //              + "_"
  //              + realSectorNumStr
                + ".bin").c_str());
      
    }
  }
  
  return 0;
}
