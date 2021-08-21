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

int patternsPerRow = 16;

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Yuna graphics extractor" << endl;
    cout << "Usage: " << argv[0] << " <infile> <outfile>" << endl;
    cout << "Options:" << std::endl;
    cout << "  -s   Starting offset" << std::endl;
    
    return 0;
  }
  
  char* infile = argv[1];
  char* outfile = argv[2];
  
  int startOffset = 0;
  TOpt::readNumericOpt(argc, argv, "-s", &startOffset);
  
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
  ifs.seek(startOffset);
  
  YunaImage img;
  img.read(ifs);
  
//  img.exportColor("test4.png");
  img.exportColor(outfile);
  
  return 0;
}
