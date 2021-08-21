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

YunaTranslationSheet translationSheet;

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

void importScript(string basename) {
  TBufStream ifs;
  ifs.open((string("script/") + basename).c_str());
  TBufStream ofs;
  while (!ifs.eof()) {
    std::string line;
    ifs.getLine(line);
    
    TBufStream lineIfs;
    lineIfs.writeString(line);
    lineIfs.seek(0);
    
    bool success = false;
    
    TParse::skipSpace(lineIfs);
    if (TParse::checkChar(lineIfs, '#')) {
      TParse::matchChar(lineIfs, '#');
      
      std::string name = TParse::matchName(lineIfs);
      TParse::matchChar(lineIfs, '(');
      
      for (int i = 0; i < name.size(); i++) {
        name[i] = toupper(name[i]);
      }
      
      if (name.compare("IMPORTSTRING") == 0) {
        int id = TParse::matchInt(lineIfs);
//        cerr << id << endl;
        
        YunaTranslationString str = translationSheet.getEntry(id);
        ofs.writeString(str.sharedContentPre);
        ofs.put('\n');
        ofs.writeString(str.translation);
        ofs.put('\n');
        ofs.writeString(str.sharedContentPost);
        ofs.put('\n');
        
        TParse::matchChar(lineIfs, ')');
        success = true;
      }
    }
    
    if (!success) {
      ofs.writeString(line);
      ofs.put('\n');
    }
  }
  
  ofs.save((string("out/scripttxt/") + basename).c_str());
}

int main(int argc, char* argv[]) {
  if (argc < 2) {
    cout << "Yuna PCECD script importer" << endl;
    cout << "Usage: " << argv[0] << " [scriptcsv]"
      << endl;
    return 0;
  }
  
  translationSheet.importCsv(string(argv[1]));
  
  importScript("battle0.txt");
  importScript("battle2.txt");
  importScript("battle3.txt");
  importScript("battle4.txt");
  importScript("battle_enemy.txt");
  importScript("battle_yuna.txt");
  importScript("postbat.txt");
  importScript("scenes.txt");
  importScript("script.txt");
  importScript("subintro.txt");
  importScript("scene19.txt");
  importScript("scene1C.txt");
  importScript("system_adv.txt");
  importScript("system_boot.txt");
  importScript("system_load.txt");
  importScript("system_title.txt");
  importScript("title.txt");
  
  return 0;
}
