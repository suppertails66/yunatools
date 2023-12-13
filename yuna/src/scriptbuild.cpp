#include "pce/PcePalette.h"
#include "yuna/YunaScriptReader.h"
#include "yuna/YunaLineWrapper.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TFileManip.h"
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

TThingyTable table;

// special opcode to trigger string jump.
// only checked at start of string;
// this is done solely to distinguish strings that were
// originally null from pointers that happen to have a
// low byte of zero.
const static int code_jump = 0x01;

// minimum length an original string must be to be replaced.
// this effectively means merely that the string must not be null
// (terminator is a guaranteed byte, and even one SJIS character adds
// another 2 bytes)
const static int minReplaceStringSize = 3;

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

void createUnindexedBlock(YunaScriptReader::ResultCollection& strings,
                          TBufStream& ofs,
                          bool excludeInplaceStrings = false) {
  for (YunaScriptReader::ResultCollection::iterator it = strings.begin();
       it != strings.end();
       ++it) {
    YunaScriptReader::ResultString& str = *it;
    
    if (excludeInplaceStrings && (str.str.size() <= str.srcSize)) continue;
    
    ofs.writeString(str.str);
  }
  
  ofs.seek(0);
}

void createBlockIndex(YunaScriptReader::ResultCollection& strings,
                      TBufStream& ofs) {
  int offset = 0;
  int num = 0;
  for (YunaScriptReader::ResultCollection::iterator it = strings.begin();
       it != strings.end();
       ++it) {
    YunaScriptReader::ResultString& str = *it;
    
    // some files have dummy indices of 0xFFFF
    while (num < str.srcOffset) {
      ofs.writeu16le(0xFFFF);
      ++num;
    }
    
//    if (str.str.size() <= str.srcSize) continue;
    
    ofs.writeu16le(offset);
    offset += str.str.size();
    ++num;
  }
  
  ofs.seek(0);
}

void getBlockIndexAsVector(YunaScriptReader::ResultCollection& strings,
                      std::vector<int>& results,
                      bool excludeInplaceStrings = false) {
  int offset = 0;
  for (YunaScriptReader::ResultCollection::iterator it = strings.begin();
       it != strings.end();
       ++it) {
    YunaScriptReader::ResultString& str = *it;
    
    if (excludeInplaceStrings && (str.str.size() <= str.srcSize)) {
      results.push_back(0);
    }
    else {
      results.push_back(offset);
      offset += str.str.size();
    }
  }
}

void updateOldIndexedBlock(TBufStream& fullUnindexedBlockOfs,
                           YunaScriptReader::ResultCollection& unindexedStrings,
                           int outputBlockBasePos) {
  std::vector<int> index;
  getBlockIndexAsVector(unindexedStrings, index, true);
  
  for (int i = 0; i < index.size(); i++) {
    YunaScriptReader::ResultString& str = unindexedStrings[i];
    
    // don't update if we don't have space for the new pointer
    // (only possible if the string was null to begin with,
    // in which case it doesn't matter)
    if (str.srcSize < minReplaceStringSize) continue;
    
    // don't bother with literal strings; we won't be changing them,
    // so the old data can remain as-is.
    // at least we'd better not be changing them.
    // the way things have been going, i wouldn't even be surprised
    // at this point.
//    if (str.isLiteral) continue;
    
    // write string inplace if possible
    if (str.str.size() <= str.srcSize) {
      fullUnindexedBlockOfs.seek(str.srcPointer);
      fullUnindexedBlockOfs.writeString(str.str);
    }
    else {
      int newOffset = index[i] + outputBlockBasePos + 0xA006;
      
      fullUnindexedBlockOfs.seek(str.srcPointer);
      fullUnindexedBlockOfs.writeu8(code_jump);
      fullUnindexedBlockOfs.writeu16le(newOffset);
    }
  }
  
  fullUnindexedBlockOfs.seek(0);
}

void createTextBlock(TBufStream& oldScriptIfs, int block0Size,
                     int oldUnindexedBlockSize,
                     YunaScriptReader::ResultCollection& unindexedStrings,
                     YunaScriptReader::ResultCollection& indexedStrings,
                     TBufStream& ofs) {
  TBufStream unindexedBlockOfs;
  TBufStream blockIndexOfs;
  TBufStream indexedBlockOfs;
  
  // create data
  
//  createUnindexedBlock(unindexedStrings, unindexedBlockOfs);
  // it turns out that the block0 script data directly references
  // the strings in the unindexed block by offset.
  // i have no desire to take apart the entire scripting system
  // so i can redirect those, so we'll instead copy the old block,
  // replace the first 2 bytes of each string in the unindexed block
  // with a pointer to its replacement,
  // then update all relevant read routines to jump to this pointer
  // before performing their normal operation.
  // this game is really fucking stupid.
  
  int ofsBasePos = ofs.tell();
  // placeholders for sizes
  ofs.seekoff(6);
  
  int block0Pos = oldScriptIfs.tell();
  int oldUnindexedBlockPos = block0Pos + block0Size;
  
  createUnindexedBlock(unindexedStrings, unindexedBlockOfs, true);
  createBlockIndex(indexedStrings, blockIndexOfs);
  createUnindexedBlock(indexedStrings, indexedBlockOfs);
  
//  std::vector<int> newUnindexedBlockIndex;
//  createBlockIndex(unindexedStrings, newUnindexedBlockIndex);
  
  // oldScriptIfs now points to old unindexed string block
  oldScriptIfs.seek(oldUnindexedBlockPos);
  // copy to new block
  TBufStream fullUnindexedBlockOfs;
  fullUnindexedBlockOfs.writeFrom(oldScriptIfs,
                                  oldUnindexedBlockSize);
  // copy in new strings
  fullUnindexedBlockOfs.writeFrom(unindexedBlockOfs,
                                  unindexedBlockOfs.size());
  
  // write block data
  oldScriptIfs.seek(block0Pos);
  ofs.writeFrom(oldScriptIfs, block0Size);
  
  // update old unindexed strings with new pointers
  fullUnindexedBlockOfs.seek(0);
  updateOldIndexedBlock(fullUnindexedBlockOfs,
                        unindexedStrings,
                        ofs.tell() - ofsBasePos - 6 + oldUnindexedBlockSize);
  
  ofs.writeFrom(fullUnindexedBlockOfs, fullUnindexedBlockOfs.size());
  ofs.writeFrom(blockIndexOfs, blockIndexOfs.size());
  ofs.writeFrom(indexedBlockOfs, indexedBlockOfs.size());
  
  int ofsEndPos = ofs.tell();
  
  // write block sizes
  ofs.seek(ofsBasePos);
  ofs.writeu16le(block0Size);
  ofs.writeu16le(fullUnindexedBlockOfs.size());
  ofs.writeu16le(blockIndexOfs.size());
  
  ofs.seek(ofsEndPos);
}

void outputAsmInclude(YunaScriptReader::ResultCollection& strings,
                      string labelName,
                      string outBaseName,
                      bool noOverwrite = false) {
  std::ofstream ofs;
  ofs.open((outBaseName + "_strings.inc").c_str());
  std::ofstream overwriteOfs;
  overwriteOfs.open((outBaseName + "_strings_overwrite.inc").c_str());
  
  int num = 0;
  for (YunaScriptReader::ResultCollection::iterator it = strings.begin();
       it != strings.end();
       ++it) {
    YunaScriptReader::ResultString& str = *it;
    
    // ignore strings too short to overwrite
    if (noOverwrite || (str.srcSize >= minReplaceStringSize)) {
      ofs << labelName << "_string" << num << ":" << endl;
      
      TBufStream ifs;
      ifs.writeString(str.str);
      ifs.seek(0);
      
      binToDcb(ifs, ofs);
      
      if (!noOverwrite) {
        overwriteOfs << ".org " << str.srcPointer << endl;
        overwriteOfs << ".section \"" << labelName << " static strings "
          << num << "\" overwrite" << endl;
        overwriteOfs << "  .db " << code_jump << endl;
        overwriteOfs << "  .dw " << labelName << "_string" << num << endl;
        overwriteOfs << ".ends" << endl;
        
        // unbackground the unused portion of the original string
        if (str.srcSize > minReplaceStringSize) {
          overwriteOfs << ".unbackground "
            << str.srcPointer + minReplaceStringSize
            << " "
            << (str.srcPointer + minReplaceStringSize)
                + (str.srcSize - minReplaceStringSize)
                - 1
            << endl;
        }
      }
    }
    
    ++num;
  }
}

const static unsigned char sceneStringTerminator = 0x07;

void outputFileSeparatedSceneStrings(YunaScriptReader::ResultCollection& strings,
                      string fileBaseName,
                      string outFolder) {
  TFileManip::createDirectory(outFolder);
  
//  int num = 0;
  for (YunaScriptReader::ResultCollection::iterator it = strings.begin();
       it != strings.end();
       ++it) {
    YunaScriptReader::ResultString& str = *it;
    
    int id = str.srcOffset;
    std::string outName = outFolder + "/" + fileBaseName
      + TStringConversion::intToString(id)
      + ".bin";
    
    TBufStream ofs;
    // oops, this is the one time we don't want to null-terminate
    // the strings
    ofs.writeString(str.str.substr(0, str.str.size() - 1)
                    + (char)sceneStringTerminator);
//    cerr << outName << endl;
    ofs.save(outName.c_str());
    
//    ++num;
  }
}

void outputAutoInsertedRegion(YunaScriptReader::ResultCollection& strings,
                              TBufStream& ofs,
                              int regionNum,
                              int pointerBase,
                              TByte fillChar = 0x00) {
  // detect end of free area
  int freeAreaStart = ofs.size();
  while (freeAreaStart > 0) {
    ofs.seek(freeAreaStart - 1);
    TByte next = ofs.get();
    if (next != fillChar) break;
    --freeAreaStart;
  }
  
  // safety in case some of the trailing fill bytes happen to be used
  // for content at the end of the used space
  freeAreaStart += 0x10;
  
  int freeAreaSize = ofs.size() - freeAreaStart;
  
  for (YunaScriptReader::ResultCollection::iterator it = strings.begin();
       it != strings.end();
       ++it) {
    YunaScriptReader::ResultString& str = *it;
    
    // ignore strings too short to overwrite
    if (str.srcSize < minReplaceStringSize) continue;
    
    int oldOffset = str.srcPointer;
    int newSize = str.str.size();
    
    if (newSize > freeAreaSize) {
      throw TGenericException(T_SRCANDLINE,
                              "outputAutoInsertedRegion()",
                              string("Not enough space in region ")
                                + TStringConversion::intToString(regionNum)
                                + " to insert string "
                                + TStringConversion::intToString(
                                    str.srcOffset));
    }
    
    // write pointer
    ofs.seek(oldOffset);
    ofs.writeu8(code_jump);
    ofs.writeu16le(pointerBase + freeAreaStart);
    
    // write string
    ofs.seek(freeAreaStart);
    ofs.writeString(str.str);
    
    // update free area state
    freeAreaStart += newSize;
    freeAreaSize -= newSize;
  }
}

const static int textCharsStart = 0x50;
//const static int textCharsEnd = 0xAC;
const static int textCharsEnd = 0xB0;
const static int textEncodingMax = 0x100;
const static int maxDictionarySymbols = textEncodingMax - textCharsEnd;


typedef std::map<std::string, int> UseCountTable;
//typedef std::map<std::string, double> EfficiencyTable;
typedef std::map<double, std::string> EfficiencyTable;

bool isCompressable(std::string& str) {
  for (int i = 0; i < str.size(); i++) {
    if (str[i] < textCharsStart) return false;
    if (str[i] >= textCharsEnd) return false;
  }
  
  return true;
}

void addStringToUseCountTable(std::string& input,
                        UseCountTable& useCountTable,
                        int minLength, int maxLength) {
  int total = input.size() - minLength;
  if (total <= 0) return;
  
  for (int i = 0; i < total; ) {
    int basePos = i;
    for (int j = minLength; j < maxLength; j++) {
      int length = j;
      if (basePos + length >= input.size()) break;
      
      std::string str = input.substr(basePos, length);
      if (!isCompressable(str)) break;
      
      ++(useCountTable[str]);
    }
    
    // skip literal arguments to ops
/*    if ((unsigned char)input[i] < textCharsStart) {
      ++i;
      int opSize = numOpParamWords((unsigned char)input[i]);
      i += opSize;
    }
    else {
      ++i;
    } */
    ++i;
  }
}

void addRegionsToUseCountTable(YunaScriptReader::RegionToResultMap& input,
                        UseCountTable& useCountTable,
                        int minLength, int maxLength) {
  for (YunaScriptReader::RegionToResultMap::iterator it = input.begin();
       it != input.end();
       ++it) {
    YunaScriptReader::ResultCollection& results = it->second;
    for (YunaScriptReader::ResultCollection::iterator jt = results.begin();
         jt != results.end();
         ++jt) {
//      std::cerr << jt->srcOffset << std::endl;
      if (jt->isLiteral) continue;
      
      addStringToUseCountTable(jt->str, useCountTable,
                               minLength, maxLength);
    }
  }
}

void buildEfficiencyTable(UseCountTable& useCountTable,
                        EfficiencyTable& efficiencyTable) {
  for (UseCountTable::iterator it = useCountTable.begin();
       it != useCountTable.end();
       ++it) {
    std::string str = it->first;
    // penalize by 1 byte (length of the dictionary code)
    double strLen = str.size() - 1;
    double uses = it->second;
//    efficiencyTable[str] = strLen / uses;
    
    efficiencyTable[strLen / uses] = str;
  }
}

void applyDictionaryEntry(std::string entry,
                          YunaScriptReader::RegionToResultMap& input,
                          std::string replacement) {
  for (YunaScriptReader::RegionToResultMap::iterator it = input.begin();
       it != input.end();
       ++it) {
    YunaScriptReader::ResultCollection& results = it->second;
    int index = -1;
    for (YunaScriptReader::ResultCollection::iterator jt = results.begin();
         jt != results.end();
         ++jt) {
      ++index;
      
      std::string str = jt->str;
      if (str.size() < entry.size()) continue;
      
      std::string newStr;
      int i;
      for (i = 0; i < str.size() - entry.size(); ) {
        if ((unsigned char)str[i] < textCharsStart) {
/*          int numParams = numOpParamWords((unsigned char)str[i]);
          
          newStr += str[i];
          for (int j = 0; j < numParams; j++) {
            newStr += str[i + 1 + j];
          }
          
          ++i;
          i += numParams; */
          newStr += str[i];
          ++i;
          continue;
        }
        
        if (entry.compare(str.substr(i, entry.size())) == 0) {
          newStr += replacement;
          i += entry.size();
        }
        else {
          newStr += str[i];
          ++i;
        }
      }
      
      while (i < str.size()) newStr += str[i++];
      
      jt->str = newStr;
    }
  }
}

void generateCompressionDictionary(
    YunaScriptReader::RegionToResultMap& results,
    std::string outputDictFileName) {
  TBufStream dictOfs;
  for (int i = 0; i < maxDictionarySymbols; i++) {
//    cerr << i << endl;
    UseCountTable useCountTable;
    addRegionsToUseCountTable(results, useCountTable, 2, 3);
    EfficiencyTable efficiencyTable;
    buildEfficiencyTable(useCountTable, efficiencyTable);
    
//    std::cout << efficiencyTable.begin()->first << std::endl;
    
    // if no compressions are possible, give up
    if (efficiencyTable.empty()) break;  
    
    int symbol = i + textCharsEnd;
    applyDictionaryEntry(efficiencyTable.begin()->second,
                         results,
                         std::string() + (char)symbol);
    
    // debug
/*    TBufStream temp;
    temp.writeString(efficiencyTable.begin()->second);
    temp.seek(0);
//    binToDcb(temp, cout);
    std::cout << "\"";
    while (!temp.eof()) {
      std::cout << table.getEntry(temp.get());
    }
    std::cout << "\"" << std::endl; */
    
    dictOfs.writeString(efficiencyTable.begin()->second);
  }
  
//  dictOfs.save((outPrefix + "dictionary.bin").c_str());
  dictOfs.save(outputDictFileName.c_str());
}

// merge a set of RegionToResultMaps into a single RegionToResultMap
void mergeResultMaps(
    std::vector<YunaScriptReader::RegionToResultMap*>& allSrcPtrs,
    YunaScriptReader::RegionToResultMap& dst) {
  int targetOutputId = 0;
  for (std::vector<YunaScriptReader::RegionToResultMap*>::iterator it
        = allSrcPtrs.begin();
       it != allSrcPtrs.end();
       ++it) {
    YunaScriptReader::RegionToResultMap& src = **it;
    for (YunaScriptReader::RegionToResultMap::iterator jt = src.begin();
         jt != src.end();
         ++jt) {
      dst[targetOutputId++] = jt->second;
    }
  }
}

// undo the effect of mergeResultMaps(), applying any changes made to
// the merged maps back to the separate originals
void unmergeResultMaps(
    YunaScriptReader::RegionToResultMap& src,
    std::vector<YunaScriptReader::RegionToResultMap*>& allSrcPtrs) {
  int targetInputId = 0;
  for (std::vector<YunaScriptReader::RegionToResultMap*>::iterator it
        = allSrcPtrs.begin();
       it != allSrcPtrs.end();
       ++it) {
    YunaScriptReader::RegionToResultMap& dst = **it;
    for (YunaScriptReader::RegionToResultMap::iterator jt = dst.begin();
         jt != dst.end();
         ++jt) {
      jt->second = src[targetInputId++];
    }
  }
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Yuna PCECD script builder" << endl;
    cout << "Usage: " << argv[0] << " [inprefix] [outprefix]"
      << endl;
    return 0;
  }
  
//  string infile(argv[1]);
  string inPrefix(argv[1]);
  string outPrefix(argv[2]);

  table.readSjis("table/yuna_en.tbl");
  
  //=====
  // read main script
  //=====
  
  YunaScriptReader::RegionToResultMap scriptResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "script.txt").c_str());
    YunaScriptReader(ifs, scriptResults, table)();
  }
  
  //=====
  // compress main script
  //=====
  
  generateCompressionDictionary(
    scriptResults, outPrefix + "script_dictionary.bin");
  
  //=====
  // output main script
  //=====
  
  {
    TBufStream oldScriptIfs;
    oldScriptIfs.open("base/textall_85EA.bin");
    
    TBufStream scriptOfs;
    
    for (int i = 0; i < 34; i++) {
      YunaScriptReader::ResultCollection& unindexedStrings
        = scriptResults[i * 2];
      YunaScriptReader::ResultCollection& indexedStrings
        = scriptResults[(i * 2) + 1];
      
      oldScriptIfs.seek((i * 0x4000) + 0);
      int block0Size = oldScriptIfs.readu16le();
      int oldUnindexedStringBlockSize = oldScriptIfs.readu16le();
      oldScriptIfs.seekoff(2);
      
//      TBufStream oldBlock0;
//      oldBlock0.writeFrom(oldScriptIfs, block0Size);
//      oldBlock0.seek(0);
      
      TBufStream ofs;
      createTextBlock(oldScriptIfs, block0Size,
                      oldUnindexedStringBlockSize,
                      unindexedStrings,
                      indexedStrings,
                      ofs);
      
      if (ofs.size() > 0x4000) {
        cerr << "Error: text block " << i << " is too big!" << endl;
        cerr << "Max is 16384, actual is " << ofs.size() << endl;
        return 1;
      }
      
      // pad to expected output size
      ofs.padToSize(0x4000, 0x00);
      
      // HACK: correct bad adpcm command in block 23
      // (the sound effect that is supposed to play when the "dead" robots
      // fly across the screen in the dark world)
      if (i == 23) {
        // the byte at 0x7A8 is 0x01, but should be 0x00.
        // otherwise, AD_PLAY ends up having its mode field set to 0x40,
        // which apparently suppresses reloading the address...
        // despite the bios manual indicating it does nothing?
        ofs.seek(0x7A8);
        ofs.writeu8(0x00);
      }
      
      ofs.seek(0);
      scriptOfs.writeFrom(ofs, ofs.size());
//      std::string outName = outPrefix + "out/script/script"
//        + TStringConversion::stringToInt(;
//      ofs.save(outName.c_str());
    }
    
    scriptOfs.save((outPrefix + "script.bin").c_str());
  }
  
  //=================
  // read system_adv
  //=================
  
  YunaScriptReader::RegionToResultMap systemAdvResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "system_adv.txt").c_str());
    YunaScriptReader(ifs, systemAdvResults, table)();
  }
  
  //=================
  // output system_adv
  //=================
  
//  outputAsmInclude(systemAdvResults[0], "systemAdv",
//                   "asm/include/system_adv");
  outputAsmInclude(systemAdvResults[0], "system",
                   "asm/include/system_adv");
  
  //=================
  // system_boot
  //=================
  
  YunaScriptReader::RegionToResultMap systemBootResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "system_boot.txt").c_str());
    YunaScriptReader(ifs, systemBootResults, table)();
  }
  
  outputAsmInclude(systemBootResults[0], "system",
                   "asm/include/system_boot");
  
  //=================
  // system_load
  //=================
  
  YunaScriptReader::RegionToResultMap systemLoadResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "system_load.txt").c_str());
    YunaScriptReader(ifs, systemLoadResults, table)();
  }
  
  outputAsmInclude(systemLoadResults[0], "system",
                   "asm/include/system_load");
  
  //=================
  // system_title
  //=================
  
  YunaScriptReader::RegionToResultMap systemTitleResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "system_title.txt").c_str());
    YunaScriptReader(ifs, systemTitleResults, table)();
  }
  
  outputAsmInclude(systemTitleResults[0], "system",
                   "asm/include/system_title");
  
  //=================
  // scene19
  //=================
  
  YunaScriptReader::RegionToResultMap scene19Results;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "scene19.txt").c_str());
    YunaScriptReader(ifs, scene19Results, table)();
  }
  
  outputAsmInclude(scene19Results[0], "scene19",
                   "asm/include/scene19");
  
  //=================
  // scene1C
  //=================
  
  YunaScriptReader::RegionToResultMap scene1CResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "scene1C.txt").c_str());
    YunaScriptReader(ifs, scene1CResults, table)();
  }
  
  outputAsmInclude(scene1CResults[0], "scene1C",
                   "asm/include/scene1C");
  
  //=================
  // read battle0
  //=================
  
  YunaScriptReader::RegionToResultMap battle0Results;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "battle0.txt").c_str());
    YunaScriptReader(ifs, battle0Results, table)();
  }
  
  //=================
  // read yuna battle messages
  //=================
  
  YunaScriptReader::RegionToResultMap battleYunaResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "battle_yuna.txt").c_str());
    YunaScriptReader(ifs, battleYunaResults, table)();
  }
  
  //=================
  // read enemy battle messages
  //=================
  
  YunaScriptReader::RegionToResultMap battleEnemyResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "battle_enemy.txt").c_str());
    YunaScriptReader(ifs, battleEnemyResults, table)();
  }
  
  //=================
  // compress battle messages
  //=================
  
  YunaScriptReader::RegionToResultMap allBattleStrings;
  {
    std::vector<YunaScriptReader::RegionToResultMap*> allSrcPtrs;
    allSrcPtrs.push_back(&battle0Results);
    allSrcPtrs.push_back(&battleYunaResults);
    allSrcPtrs.push_back(&battleEnemyResults);
    
    // merge everything into one giant map for compression
    mergeResultMaps(allSrcPtrs, allBattleStrings);
    
    // compress
    generateCompressionDictionary(
      allBattleStrings, outPrefix + "battle_dictionary.bin");
    
    // restore results from merge back to individual containers
    unmergeResultMaps(allBattleStrings, allSrcPtrs);
  }
//  generateCompressionDictionary(
//    battle0Results, outPrefix + "battle_dictionary.bin");
  
  //=================
  // output battle0
  //=================
  
  outputAsmInclude(battle0Results[0], "battle0",
                   "asm/include/battle0");
  outputAsmInclude(battle0Results[1], "battle0_new",
                   "asm/include/battle0_new",
                   true);
  
  //=================
  // output yuna battle messages
  //=================
  
  {
    TBufStream ifs;
    ifs.open("base/battle_yuna_all_B3BA.bin");
    
    for (int i = 0; i < 40; i++) {
      int baseAddr = i * 0x800;
      ifs.seek(baseAddr);
      TBufStream tempIfs;
      tempIfs.writeFrom(ifs, 0x800);
      tempIfs.seek(0);
      
      outputAutoInsertedRegion(battleYunaResults[i], tempIfs,
                               i, 0x9000, 0x00);
      
      ifs.seek(baseAddr);
      tempIfs.seek(0);
      ifs.writeFrom(tempIfs, 0x800);
    }
    
//    ifs.save((outPrefix + "battle_yuna_all_B3BA.bin").c_str());
    ifs.save("out/base/battle_yuna_all_B3BA.bin");
  }
  
  //=================
  // output enemy battle messages
  //=================
  
  {
    TBufStream ifs;
    ifs.open("base/battle_enemy_all_B3FA.bin");
    
    for (int i = 0; i < 16; i++) {
      int baseAddr = i * 0x800;
      ifs.seek(baseAddr);
      TBufStream tempIfs;
      tempIfs.writeFrom(ifs, 0x800);
      tempIfs.seek(0);
      
      outputAutoInsertedRegion(battleEnemyResults[i], tempIfs,
                               i, 0x9800, 0x00);
      
      ifs.seek(baseAddr);
      tempIfs.seek(0);
      ifs.writeFrom(tempIfs, 0x800);
    }
    
//    ifs.save((outPrefix + "battle_yuna_all_B3BA.bin").c_str());
    ifs.save("out/base/battle_enemy_all_B3FA.bin");
  }
  
  //=================
  // battle2
  //=================
  
  YunaScriptReader::RegionToResultMap battle2Results;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "battle2.txt").c_str());
    YunaScriptReader(ifs, battle2Results, table)();
  }
  
  outputAsmInclude(battle2Results[0], "battle2",
                   "asm/include/battle2");
  outputAsmInclude(battle2Results[1], "battle2_enemy",
                   "asm/include/battle2_enemy");
  outputAsmInclude(battle2Results[2], "battle2_ally",
                   "asm/include/battle2_ally");
  
  //=================
  // battle3
  //=================
  
  YunaScriptReader::RegionToResultMap battle3Results;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "battle3.txt").c_str());
    YunaScriptReader(ifs, battle3Results, table)();
  }
  
  outputAsmInclude(battle3Results[0], "battle3",
                   "asm/include/battle3");
  outputAsmInclude(battle3Results[1], "battle3_enemy",
                   "asm/include/battle3_enemy");
  outputAsmInclude(battle3Results[2], "battle3_ally",
                   "asm/include/battle3_ally");
  
  //=================
  // battle4
  //=================
  
  YunaScriptReader::RegionToResultMap battle4Results;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "battle4.txt").c_str());
    YunaScriptReader(ifs, battle4Results, table)();
  }
  
  outputAsmInclude(battle4Results[0], "battle4",
                   "asm/include/battle4");
  outputAsmInclude(battle4Results[1], "battle4_enemy",
                   "asm/include/battle4_enemy");
  outputAsmInclude(battle4Results[2], "battle4_ally",
                   "asm/include/battle4_ally");
  
  //=================
  // inject font + width table into yuna stat block
  // for use in battle0 (where we don't have enough
  // space in the executable and have to load to
  // internal RAM instead)
  //=================
  
  // assumes max of 0x5C chars
  const static int battle0FontLoadOffset = 0x400;
  const static int battle0WidthTableLoadOffset = 0x798;
  const static int battle0DictLoadOffset = 0x340;
  
  {
    TBufStream ifs;
    ifs.open("base/battle_yuna_stats_B43A.bin");
    
    TBufStream fontIfs;
//    fontIfs.open("out/font/font.bin");
    fontIfs.open("out/font/font_limited.bin");
    TBufStream widthIfs;
//    widthIfs.open("out/font/fontwidth.bin");
    widthIfs.open("out/font/fontwidth_limited.bin");
    TBufStream dictIfs;
    dictIfs.open("out/script/battle_dictionary.bin");
    
    
    for (int i = 0; i < 19; i++) {
      fontIfs.seek(0);
      ifs.seek((i * 0x800) + battle0FontLoadOffset);
      ifs.writeFrom(fontIfs, fontIfs.size());
      
      widthIfs.seek(0);
      ifs.seek((i * 0x800) + battle0WidthTableLoadOffset);
      ifs.writeFrom(widthIfs, widthIfs.size());
      
      dictIfs.seek(0);
      ifs.seek((i * 0x800) + battle0DictLoadOffset);
      ifs.writeFrom(dictIfs, dictIfs.size());
    }
    
    ifs.save("out/base/battle_yuna_stats_B43A.bin");
  }
  
  //=================
  // output scenes
  //=================
  
  TThingyTable tableScenes;
  tableScenes.readSjis("table/yuna_scenes_en.tbl");
  
  YunaScriptReader::RegionToResultMap scenesResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "scenes.txt").c_str());
    YunaScriptReader(ifs, scenesResults, tableScenes)();
  }
  
  for (YunaScriptReader::RegionToResultMap::iterator it
        = scenesResults.begin();
       it != scenesResults.end();
       ++it) {
    int num = it->first;
    std::string numStr =
      TStringConversion::intToString(num, TStringConversion::baseHex)
      .substr(2, string::npos);
    
//    outputAsmInclude(it->second, string("sceneStrings") + numStr,
//                     string("asm/include/scene") + numStr);
    outputFileSeparatedSceneStrings(it->second, string("string"),
                     string("asm/include/scene") + numStr);
  }
  
  //=================
  // output postbat
  //=================
  
  tableScenes.readSjis("table/yuna_scenes_en.tbl");
  
  YunaScriptReader::RegionToResultMap postbatResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "postbat.txt").c_str());
    YunaScriptReader(ifs, postbatResults, tableScenes)();
  }
  
  for (YunaScriptReader::RegionToResultMap::iterator it
        = postbatResults.begin();
       it != postbatResults.end();
       ++it) {
    int num = it->first;
    std::string numStr =
      TStringConversion::intToString(num, TStringConversion::baseHex)
      .substr(2, string::npos);
    
//    outputAsmInclude(it->second, string("sceneStrings") + numStr,
//                     string("asm/include/scene") + numStr);
    outputFileSeparatedSceneStrings(it->second, string("string"),
                     string("asm/include/postbat") + numStr);
  }
  
  //=================
  // output subintro
  //=================
  
  YunaScriptReader::RegionToResultMap subintroResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "subintro.txt").c_str());
    YunaScriptReader(ifs, subintroResults, tableScenes)();
  }
  
//  generateCompressionDictionary(
//    subintroResults, outPrefix + "subintro_dictionary.bin");
  
  outputFileSeparatedSceneStrings(subintroResults.at(0), string("string"),
                   string("asm/include/subintro"));
  
  //=================
  // output title
  //=================
  
  YunaScriptReader::RegionToResultMap titleResults;
  {
    TBufStream ifs;
    ifs.open((inPrefix + "title.txt").c_str());
    YunaScriptReader(ifs, titleResults, tableScenes)();
  }
  
  outputFileSeparatedSceneStrings(titleResults.at(0), string("string"),
                   string("asm/include/title"));
  
  return 0;
}
