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
  if (argc < 4) {
    cout << "Yuna graphics builder" << endl;
    cout << "Usage: " << argv[0] << " <basefile> <newgrp> <outfile>" << endl;
    
    return 0;
  }
  
  char* basefile = argv[1];
  char* newgrp = argv[2];
  char* outfile = argv[3];

  YunaImage img;
  {
    TBufStream ifs;
    ifs.open(basefile);
    img.read(ifs);
  }
  
  TGraphic grp;
  TPngConversion::RGBAPngToGraphic(std::string(newgrp), grp);
  
//  img.exportColor("test4.png");
//  img.exportColor(outfile);
  
  img.import(grp);
  
  TBufStream ofs;
  img.write(ofs);
  ofs.save(outfile);
  
  return 0;
}
