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

int main(int argc, char* argv[]) {
/*  if (argc < 4) {
    cout << "Usage: " << argv[0] << " <scenenum> <stringbase> <stringcount>" << endl;
    return 0;
  }
  
  int sceneNum = TStringConversion::stringToInt(string(argv[1]));
  int stringBase = TStringConversion::stringToInt(string(argv[2]));
  int stringCount = TStringConversion::stringToInt(string(argv[3]));
  
  cout << "//=========================================================================="
    << endl;
  cout << "// scene " << sceneNum
    << endl;
  cout << "//=========================================================================="
    << endl;
  cout << endl;
  
  for (int i = 0; i < stringCount; i++) {
    cout << "#STARTSTRING(" << i << ", 0, 0, 0)" << endl;
    cout << "#IMPORTSTRING(" << stringBase + i << ")" << endl;
    cout << "#ENDSTRING()" << endl;
    cout << endl;
  } */
  
/*  for (int j = 0; j < 0x1D; j++) {
    int sceneNum = j;
//    int stringBase = sceneNum * 100000;
    int stringBase = (sceneNum + 1) * 10000;
    if (stringBase == 0) stringBase = 10000;
    int stringCount = 100;
    
    cout << "//=========================================================================="
      << endl;
    cout << "// scene "
      << TStringConversion::intToString(sceneNum, TStringConversion::baseHex)
      << " ("
      << sceneNum
      << ")"
      << endl;
    cout << "//=========================================================================="
      << endl;
    cout << endl;
    
    cout << "#STARTREGION(" << j << ")" << endl;
    cout << endl;
    
    for (int i = 0; i < stringCount; i++) {
      cout << "#STARTSTRING(" << stringBase + i << ", 0, 0, 0)" << endl;
      cout << "#IMPORTSTRING(" << stringBase + i << ")" << endl;
      cout << "#ENDSTRING()" << endl;
      cout << endl;
    }
    
    cout << "#ENDREGION(" << j << ")" << endl;
    cout << endl;
  } */
  
  for (int j = 0; j < 0x11; j++) {
    int sceneNum = j;
//    int stringBase = sceneNum * 100000;
    int stringBase = ((sceneNum + 1) * 10000) + 400000;
    if (stringBase == 0) stringBase = 10000;
    int stringCount = 100;
    
    cout << "//=========================================================================="
      << endl;
    cout << "// postbat "
      << TStringConversion::intToString(sceneNum, TStringConversion::baseHex)
      << " ("
      << sceneNum
      << ")"
      << endl;
    cout << "//=========================================================================="
      << endl;
    cout << endl;
    
    cout << "#STARTREGION(" << j << ")" << endl;
    cout << endl;
    
    for (int i = 0; i < stringCount; i++) {
      cout << "#STARTSTRING(" << stringBase + i << ", 0, 0, 0)" << endl;
      cout << "#IMPORTSTRING(" << stringBase + i << ")" << endl;
      cout << "#ENDSTRING()" << endl;
      cout << endl;
    }
    
    cout << "#ENDREGION(" << j << ")" << endl;
    cout << endl;
  }
  
  return 0;
}
