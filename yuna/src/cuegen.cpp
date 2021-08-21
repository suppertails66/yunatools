#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include "util/TCsv.h"
#include "util/TSoundFile.h"
#include "util/TCdMsf.h"
#include <vector>
#include <string>
#include <iostream>

using namespace std;
using namespace BlackT;
//using namespace Pce;

// wait, why am i writing this program at all when i already have discaster
// which will do all these calculations and much more??

vector<int> trackOffsets;

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

struct TrackEvent {
public:
  enum type {
    type_none,
    type_trackStart
  };
};

void addTrackOffset(int offset) {
  trackOffsets.push_back(offset);
}

int main(int argc, char* argv[]) {
  // 00
  addTrackOffset(0);
  // 01
  addTrackOffset(4320);
  // 02
  addTrackOffset(75370);
  // 03
  addTrackOffset(7642);
  // 04
  addTrackOffset(7343);
  // 05
  addTrackOffset(7323);
  // 06
  addTrackOffset(7331);
  // 07
  addTrackOffset(9098);
  // 08
  addTrackOffset(9100);
  // 09
  addTrackOffset(5050);
  // 10
  addTrackOffset(75231);
  
  TCdMsf pos;
  pos.fromSectorNum(0);
  
  cout << "FILE \"yuna.bin\" BINARY" << endl;
  
  for (unsigned int i = 0; i < trackOffsets.size(); i++) {
    pos.fromSectorNum(pos.toSectorNum() + trackOffsets[i]);
//    cout << "FILE \"yuna_" << getNumStr(i + 1) << ".wav\" WAVE" << endl;
//    cout << "  TRACK " << getNumStr(i + 1) << " AUDIO" << endl;
//    cout << "    INDEX 01 00:00:00" << endl;
    cout << "  TRACK " << getNumStr(i + 1) << " AUDIO" << endl;
    cout << "    INDEX 01 00:00:00" << endl;
  }
  
  return 0;
}
