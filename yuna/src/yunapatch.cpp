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

const static int sectorSize = 0x800;

void patchFile(TBufStream& ofs,
               std::string filename,
               int offset,
               int sizeLimit = -1) {
  if (!TFileManip::fileExists(filename)) {
    throw TGenericException(T_SRCANDLINE,
                            "patchFile()",
                            std::string("File does not exist: ")
                              + filename);
  }
  
  TBufStream ifs;
  ifs.open(filename.c_str());
  
  if (sizeLimit == -1) sizeLimit = ifs.size();
  
  ofs.seek(offset);
  ofs.writeFrom(ifs, sizeLimit);
}

void patchFileBySector(TBufStream& ofs,
               std::string filename,
               int sectorNum,
               int sizeLimit = -1) {
  patchFile(ofs, filename, sectorNum * sectorSize, sizeLimit);
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Yuna ISO patcher" << endl;
    cout << "Usage: " << argv[0]
      << " <infile> <outfile>" << endl;
  }
  
  string infile(argv[1]);
  string outfile(argv[2]);

  // patching modified files to the ISO one by one resulted in
  // ridiculous disk I/O, so i've turned the original shell script
  // into this dedicated program to speed it up
  
  TBufStream ofs;
  ofs.open(infile.c_str());
  
  // 0x8C96
  patchFileBySector(
    ofs, "out/base/subintro_2.bin", 0x2, 0xA000);
  patchFileBySector(
    ofs, "out/base/load_42.bin", 0x42, 0xA000);
  patchFileBySector(
    ofs, "out/base/title_202.bin", 0x202, 0xA000);
//  patchFileBySector(
//    ofs, "out/base/boot_2E2.bin", 0x2E2, 0x4400);
  patchFileBySector(
    ofs, "out/base/boot_2E2.bin", 0x2E2, 0xA000);
  patchFileBySector(
    ofs, "out/script/script.bin", 0x85EA, 0x88000);
  patchFileBySector(
    ofs, "out/base/adv_87EA.bin", 0x87EA, 0x8000);
  patchFileBySector(
    ofs, "out/base/grp_889A.bin", 0x889A, 0x24000);
  patchFileBySector(
    ofs, "out/base/grp_892A.bin", 0x892A, 0x24000);
  patchFileBySector(
    ofs, "out/base/grp_8C8A.bin", 0x8C8A, 0x24000);
  patchFileBySector(
    ofs, "out/base/grp_8D62.bin", 0x8D62, 0x24000);
  patchFileBySector(
    ofs, "out/base/bootloader2_A97C.bin", 0xA97C, 0x800);
  patchFileBySector(
    ofs, "out/base/bootloader4_A97E.bin", 0xA97E, 0x800);
  patchFileBySector(
    ofs, "out/base/bootloader5_A97F.bin", 0xA97F, 0x800);
  patchFileBySector(
    ofs, "out/base/bootloader7_A981.bin", 0xA981, 0x800);
  patchFileBySector(
    ofs, "out/base/bootloader8_A982.bin", 0xA982, 0x800);
  patchFileBySector(
    ofs, "out/base/battle0_B1BA.bin", 0xB1BA, 0xA000);
  patchFileBySector(
    ofs, "out/base/battle2_B1E2.bin", 0xB1E2, 0xA000);
  patchFileBySector(
    ofs, "out/base/battle3_B1F6.bin", 0xB1F6, 0xA000);
  patchFileBySector(
    ofs, "out/base/battle4_B20A.bin", 0xB20A, 0xA000);
  patchFileBySector(
    ofs, "out/base/battle_yuna_all_B3BA.bin", 0xB3BA, 0x14000);
  patchFileBySector(
    ofs, "out/base/battle_enemy_all_B3FA.bin", 0xB3FA, 0x8000);
  patchFileBySector(
    ofs, "out/base/battle_yuna_stats_B43A.bin", 0xB43A, 0x9800);
  patchFileBySector(
    ofs, "out/base/postbat_all_B4DA.bin", 0xB4DA, 0xAA000);
  patchFileBySector(
    ofs, "out/base/scenes_all_E23A.bin", 0xE23A, 0x122000);
  
  // minor one-off graphics and things
  patchFile(
    ofs, "out/grp/flint_map.bin", 0x4DBF19C, 0x80);
  patchFile(
    ofs, "out/grp/blackhole_txt.bin", 0x6366F90, 0xC00);
  // duplicated over and over again for no reason and i don't know
  // which one is actually used.
  // unless one of these is for some other cutscene that uses カ
  // as a sprite overlay, which is very probable
  patchFile(
    ofs, "out/grp/flint_txt.bin", 0x41770B0, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x41D70B0, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x4261A90, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x42970B0, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x5D690B0, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x5D690B0, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x5DBF0B0, 0x800);
    patchFile(
      ofs, "out/grp/flint_txt.bin", 0x62A50B0, 0x800);
  patchFile(
    ofs, "out/grp/mariana_txt.bin", 0x41A3050, 0x800);
    patchFile(
      ofs, "out/grp/mariana_txt.bin", 0x62D1050, 0x800);
  patchFile(
    ofs, "out/grp/luries_txt.bin", 0x63050B0, 0x800);
  patchFile(
    ofs, "out/grp/balmood_txt.bin", 0x63340B0, 0x800);
  patchFile(
    ofs, "out/grp/darknebula_txt.bin", 0x638FA90, 0x800);
  patchFile(
    ofs, "out/grp/asteroid_txt.bin", 0x63C50B0, 0xC00);
  patchFile(
    ofs, "out/grp/poka.bin", 0x478E991, 0x2000);
  patchFile(
    ofs, "out/grp/temple_doka.bin", 0x4970812, 0x1000);
  patchFile(
    ofs, "out/grp/credits_grp.bin", 0x698D000, 0x28000);
  patchFile(
    ofs, "out/base/title_spritedef.bin", 0x116D12, 0x2000);
    patchFile(
      ofs, "out/base/title_spritedef.bin", 0x123C08, 0x2000);
  patchFile(
    ofs, "out/grp/title_spritedef_paloffset.bin", 0x11410E, 2);
  // ?
    patchFile(
      ofs, "out/grp/title_spritedef_paloffset.bin", 0x121004, 2);
  patchFile(
    ofs, "out/grp/title_sublogo_en.bin", 0x115112, 0x380);
    patchFile(
      ofs, "out/grp/title_sublogo_en.bin", 0x122008, 0x380);
  patchFile(
    ofs, "out/grp/hud_gemy.bin", 0x5408240);
  // ?
    patchFile(
      ofs, "out/grp/hud_gemy.bin", 0x5415000);
    patchFile(
      ofs, "out/grp/hud_gemy.bin", 0x5417000);
    patchFile(
      ofs, "out/grp/hud_gemy.bin", 0x5419000);
    patchFile(
      ofs, "out/grp/hud_gemy.bin", 0x541B000);
    patchFile(
      ofs, "out/grp/hud_gemy.bin", 0x541D000);
  
  ofs.save(outfile.c_str());
  
  return 0;
}

