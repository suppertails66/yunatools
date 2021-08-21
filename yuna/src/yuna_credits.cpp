#include "pce/PcePalette.h"
#include "yuna/YunaScriptReader.h"
#include "yuna/YunaLineWrapper.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include "util/TFileManip.h"
#include <cctype>
#include <string>
#include <vector>
#include <iostream>
#include <sstream>
#include <fstream>

using namespace std;
using namespace BlackT;
using namespace Pce;

// offset each image's bg + sprites by this many tiles
const static int tileOffsetX = 8;
const static int tileOffsetY = -8;

void offsetBg(TStream& ofs, int offset) {
  ofs.seek(offset);
  
  ofs.seekoff(2);
  int x = ofs.readu16le();
  int y = ofs.readu16le();
  ofs.seekoff(-4);
  ofs.writeu16le(x + tileOffsetX);
  ofs.writeu16le(y + tileOffsetY);
}

void offsetSprites(TStream& ofs, int offset) {
  for (int i = 0; i < 64; i++) {
    ofs.seek(offset + (i * 8));
    int y = ofs.readu16le();
    int x = ofs.readu16le();
    
    if ((x == 0xFFFF) && (y == 0xFFFF)) break;
    
    ofs.seekoff(-4);
    ofs.writeu16le(y + (tileOffsetY * 8));
    ofs.writeu16le(x + (tileOffsetX * 8));
  }
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Yuna credits offsetter" << endl;
    cout << "Usage: " << argv[0]
      << " <infile> <outfile>" << endl;
  }
  
  string infile(argv[1]);
  string outfile(argv[2]);
  
  TBufStream ofs;
  ofs.open(infile.c_str());
  
  offsetBg(ofs, 0x0);
  offsetSprites(ofs, 0x361E);
  
  offsetBg(ofs, 0x3790);
  offsetSprites(ofs, 0x6225);
  
  offsetBg(ofs, 0x6347);
  offsetSprites(ofs, 0x9839);
  
  offsetBg(ofs, 0x9973);
  offsetSprites(ofs, 0xDDEA);
  
  offsetBg(ofs, 0xDF7C);
  offsetSprites(ofs, 0x11E73);
  
  offsetBg(ofs, 0x11FD5);
//  offsetSprites(ofs, 0x);
  
  offsetBg(ofs, 0x14160);
  offsetSprites(ofs, 0x18D40);
  
  offsetBg(ofs, 0x18EFA);
//  offsetSprites(ofs, 0x);
  
  offsetBg(ofs, 0x1B085);
  offsetSprites(ofs, 0x1F062);
  
  offsetBg(ofs, 0x1F1F4);
  offsetSprites(ofs, 0x22BD3);
  
  offsetBg(ofs, 0x22D4D);
  offsetSprites(ofs, 0x25C60);
  
  offsetBg(ofs, 0x25DB2);
  
  ofs.save(outfile.c_str());
  
  return 0;
}

