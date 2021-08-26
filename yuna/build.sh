
echo "*******************************************************************************"
echo "Setting up environment..."
echo "*******************************************************************************"

set -o errexit

BASE_PWD=$PWD
PATH=".:$PATH"
INROM="yuna_02.iso"
OUTROM="yuna_02_build.iso"
WLADX="./wla-dx/binaries/wla-huc6280"
WLALINK="./wla-dx/binaries/wlalink"
DISCASTER="../discaster/discaster"

function remapPalette() {
  oldFile=$1
  palFile=$2
  newFile=$3
  
  convert "$oldFile" -dither None -remap "$palFile" PNG32:$newFile
}

function remapPaletteOverwrite() {
  newFile=$1
  palFile=$2
  
  remapPalette $newFile $palFile $newFile
}

#remapPaletteOverwrite "rsrc/grp/temple_doka.png" "rsrc/grp/temple_doka_palette.png"
#exit

#mkdir -p log
mkdir -p out

echo "********************************************************************************"
echo "Building project tools..."
echo "********************************************************************************"

make blackt
make libpce
make

if [ ! -f $WLADX ]; then
  
  echo "********************************************************************************"
  echo "Building WLA-DX..."
  echo "********************************************************************************"
  
  cd wla-dx
    cmake -G "Unix Makefiles" .
    make
  cd $BASE_PWD
  
fi

echo "*******************************************************************************"
echo "Copying binaries..."
echo "*******************************************************************************"

cp -r base out

cp "$INROM" "$OUTROM"

echo "*******************************************************************************"
echo "Building font..."
echo "*******************************************************************************"

numFontChars=96
numLimitedFontChars=92
bytesPerFontChar=10

mkdir -p out/font
fontbuild "font/" "out/font/font.bin" "out/font/fontwidth.bin"
fontbuild "font/scene/" "out/font/font_scene.bin" "out/font/fontwidth_scene.bin"
fontbuild "font/narrow/" "out/font/font_narrow.bin" "out/font/fontwidth_narrow.bin"

datsnip "out/font/font.bin" 0 $(($numLimitedFontChars*$bytesPerFontChar)) "out/font/font_limited.bin"
datsnip "out/font/fontwidth.bin" 0 $(($numLimitedFontChars*1)) "out/font/fontwidth_limited.bin"

echo "*******************************************************************************"
echo "Building prerendered subtitles..."
echo "*******************************************************************************"

cp -r rsrc_raw/pal out
cp -r rsrc/grp out

subrender "font/scene/" "font/scene/table.tbl" "asm/include/scene10/string170005.bin" "table/yuna_scenes_en.tbl" "out/grp/scene10-170005.png"
subrender "font/scene/" "font/scene/table.tbl" "asm/include/scene10/string170006.bin" "table/yuna_scenes_en.tbl" "out/grp/scene10-170006.png"
subrender "font/scene/" "font/scene/table.tbl" "asm/include/scene10/string170007.bin" "table/yuna_scenes_en.tbl" "out/grp/scene10-170007.png"
subrender "font/scene/" "font/scene/table.tbl" "asm/include/scene10/string170008.bin" "table/yuna_scenes_en.tbl" "out/grp/scene10-170008.png"
subrender "font/scene/" "font/scene/table.tbl" "asm/include/scene10/string170009.bin" "table/yuna_scenes_en.tbl" "out/grp/scene10-170009.png"
subrender "font/scene/" "font/scene/table.tbl" "asm/include/scene10/string170010.bin" "table/yuna_scenes_en.tbl" "out/grp/scene10-170010.png"
datsnip "out/pal/scene10_pan.pal" $((0x7*0x20)) 0x20 "out/pal/scene10_pan_line.pal"

echo "*******************************************************************************"
echo "Building graphics..."
echo "*******************************************************************************"

#mkdir -p out/grp
mkdir -p out/maps

remapPaletteOverwrite "out/grp/intro_suit_patch.png" "out/grp/orig/intro_suit_patch.png"
remapPaletteOverwrite "out/grp/scene00_patch.png" "out/grp/orig/scene00_patch.png"

for file in tilemappers/*.txt; do
  tilemapper_pce "$file"
done;

datsnip "out/pal/intro_suit_patch.pal" $((0x7*0x20)) 0x20 "out/pal/intro_suit_patch_line.pal"
datsnip "out/pal/intro.pal" $((0x6*0x20)) 0x20 "out/pal/intro_line.pal"
datsnip "out/pal/scene00_patch.pal" $((0x6*0x20)) 0x40 "out/pal/scene00_patch_line.pal"
datsnip "out/pal/scene0B_patch.pal" $((0x7*0x20)) 0x20 "out/pal/scene0B_patch_line.pal"

#remapPaletteOverwrite "out/grp/karaoke.png" "out/grp/karaoke_remap.png"
remapPaletteOverwrite "out/grp/karaoke.png" "out/grp/orig/karaoke.png"
yuna_grpbuild "rsrc_raw/img/karaoke.bin" "out/grp/karaoke.png" "out/grp/karaoke.bin"
datpatch "out/base/grp_889A.bin" "out/base/grp_889A.bin" "out/grp/karaoke.bin" 0xC942 0 0x218A

#remapPaletteOverwrite "out/grp/snap.png" "out/grp/snap_remap.png"
remapPaletteOverwrite "out/grp/snap.png" "out/grp/orig/snap.png"
yuna_grpbuild "rsrc_raw/img/snap.bin" "out/grp/snap.png" "out/grp/snap.bin"
datpatch "out/base/grp_892A.bin" "out/base/grp_892A.bin" "out/grp/snap.bin" 0x64A1 0 0x218A

#remapPaletteOverwrite "rsrc/grp/noentry_map.png" "rsrc/grp/orig/noentry_map.png"
remapPaletteOverwrite "out/grp/noentry.png" "out/grp/orig/noentry.png"
yuna_grpbuild "rsrc_raw/img/noentry.bin" "out/grp/noentry.png" "out/grp/noentry.bin"
datpatch "out/base/grp_8C8A.bin" "out/base/grp_8C8A.bin" "out/grp/noentry.bin" 0x64A1 0 0x218A
datpatch "out/base/grp_8D62.bin" "out/base/grp_8D62.bin" "out/grp/noentry.bin" 0x4316 0 0x218A

spriteundmp_pce "rsrc/grp/flint_map.png" "out/grp/flint_map.bin" -p "rsrc_raw/pal/flint_map_line.pal" -r 1 -n 1

spriteundmp_pce "rsrc/grp/blackhole_txt.png" "out/grp/blackhole_txt.bin" -r 8 -n 24
spriteundmp_pce "rsrc/grp/flint_txt.png" "out/grp/flint_txt.bin" -r 8 -n 16
spriteundmp_pce "rsrc/grp/mariana_txt.png" "out/grp/mariana_txt.bin" -r 8 -n 16
spriteundmp_pce "rsrc/grp/luries_txt.png" "out/grp/luries_txt.bin" -r 8 -n 16
spriteundmp_pce "rsrc/grp/balmood_txt.png" "out/grp/balmood_txt.bin" -r 6 -n 12
spriteundmp_pce "rsrc/grp/darknebula_txt.png" "out/grp/darknebula_txt.bin" -r 8 -n 16
spriteundmp_pce "rsrc/grp/asteroid_txt.png" "out/grp/asteroid_txt.bin" -r 8 -n 24

spriteundmp_pce "rsrc/grp/title_sublogo_en.png" "out/grp/title_sublogo_en.bin" -r 7 -n 7

bigspriteundmp_pce "rsrc/grp/title_logo.png" "out/grp/title_logo.bin" -p "rsrc_raw/pal/title_logo_yellow.pal" -r 4 -n 8 -w 2 -h 4

spritelayout_pce "rsrc/grp/poka.png" "rsrc_raw/grp/poka.bin" "rsrc_raw/layout/poka.txt" "out/grp/poka.bin" -p "rsrc_raw/pal/poka.pal"

spritelayout_pce "rsrc/grp/temple_doka.png" "rsrc_raw/grp/temple_doka.bin" "rsrc_raw/layout/temple_doka.txt" "out/grp/temple_doka.bin" -p "rsrc_raw/pal/temple_doka.pal"

grpundmp_pce "rsrc/grp/hud_gemy.png" 35 "out/grp/hud_gemy.bin" -r 5

yuna_credits "rsrc_raw/grp/credits_grp.bin" "out/grp/credits_grp.bin"

# remapPalette "out/grp/title_background.png" "out/grp/orig/title_logo.png" "out/grp/title_background.png"
# remapPalette "out/grp/title_wreath.png" "out/grp/orig/title_logo.png" "out/grp/title_wreath.png"
# remapPalette "out/grp/title_main.png" "out/grp/subtitle_remap.png" "out/grp/title_main.png"
# remapPalette "out/grp/title_sub.png" "out/grp/subtitle_remap.png" "out/grp/title_sub.png"
# remapPalette "out/grp/title_overlay.png" "out/grp/title_overlay_remap.png" "out/grp/title_overlay.png"
# 
# remapPalette "out/grp/loading.png" "out/grp/orig/loading.png" "out/grp/loading.png"
# remapPalette "out/grp/dungeon_logo.png" "out/grp/orig/dungeon_logo.png" "out/grp/dungeon_logo.png"
# 
# convert -page +0+0 "out/grp/title_main_wreath_bg_mod.png" -page +0+0 "out/grp/title_main.png" -background none -layers mosaic PNG32:out/grp/title_main.png
# 
# convert -page +0+0 "out/grp/title_sub.png" -page +0+0 "out/grp/title_overlay.png" -background none -layers mosaic -crop 240x24+0+0 PNG32:out/grp/title_sub.png
# 
# #convert -background none "out/grp/mrflea_bayoen.png" -crop 32x16+0+0 -crop 32x16+0+0 -page +0+0 "out/grp/mrflea_here.png"  -background none -layers mosaic PNG32:out/grp/mrflea.png
# 
# for file in tilemappers/*.txt; do
#   tilemapper_pce "$file"
# done;
# 
# patchtilemap "out/grp/title_background.map" 64 "out/grp/title_wreath.map" 40 0 3 "out/grp/title_background.map"
# patchtilemap "out/grp/title_background.map" 64 "out/grp/title_main.map" 30 5 3 "out/grp/title_background.map"
# patchtilemap "out/grp/title_background.map" 64 "out/grp/title_sub.map" 30 5 12 "out/grp/title_background.map"
# 
# spriteoverlaymaker "out/grp/title_overlay.png" "rsrc_raw/pal/title_logo.pal" 0x220 "out/grp/title_overlay_grp.bin" "out/grp/title_overlay_sprites.bin"
# 
# grpundmp_pce "out/grp/dungeon_logo.png" 96 "out/grp/dungeon_logo.bin" -p "rsrc_raw/pal/dungeon_logo_line.pal"
# grpundmp_pce "out/grp/button_yesno.png" 24 "out/grp/button_yesno.bin" -p "rsrc_raw/pal/dungeon_button_line.pal" -r 6
# grpundmp_pce "out/grp/button_onoff.png" 24 "out/grp/button_onoff.bin" -p "rsrc_raw/pal/dungeon_button_line.pal" -r 6
# 
# convert "out/grp/mrflea_bayoen.png" -crop 32x16+0+0 "out/grp/mrflea_bayoen1.png"
# convert "out/grp/mrflea_bayoen.png" -crop 16x16+32+0 "out/grp/mrflea_bayoen2.png"
# convert -size 160x16 xc:none\
#   -page +0+0 "out/grp/mrflea_here.png"\
#   -page +64+0 "out/grp/mrflea_bayoen1.png"\
#   -page +144+0 "out/grp/mrflea_bayoen2.png"\
#   -page +96+0 "out/grp/mrflea_think.png"\
#   -background none -layers mosaic\
#   PNG32:out/grp/mrflea.png
# 
# spriteundmp_pce "out/grp/mrflea.png" "out/grp/mrflea.bin" -n 10 -p "rsrc_raw/pal/dungeon_mrflea_line.pal"
# 
# convert "out/grp/bayoen.png" -crop 32x32+0+0 "out/grp/bayoen1.png"
# convert "out/grp/bayoen.png" -crop 32x32+32+0 "out/grp/bayoen2.png"
# convert "out/grp/bayoen.png" -crop 32x32+64+0 "out/grp/bayoen3.png"
# convert "out/grp/bayoen.png" -crop 32x32+96+0 "out/grp/bayoen4.png"
# 
# spriteundmp_pce "out/grp/bayoen1.png" "out/grp/bayoen1.bin" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -n 4
# spriteundmp_pce "out/grp/bayoen2.png" "out/grp/bayoen2.bin" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -n 4
# spriteundmp_pce "out/grp/bayoen3.png" "out/grp/bayoen3.bin" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -n 4
# spriteundmp_pce "out/grp/bayoen4.png" "out/grp/bayoen4.bin" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -n 4
# spriteundmp_pce "out/grp/bayoen_tilde.png" "out/grp/bayoen_tilde.bin" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -n 4
# cp "rsrc_raw/grp/bayoen.bin" "out/grp/bayoen.bin"
# datpatch "out/grp/bayoen.bin" "out/grp/bayoen.bin" "out/grp/bayoen1.bin" 0x0
# datpatch "out/grp/bayoen.bin" "out/grp/bayoen.bin" "out/grp/bayoen2.bin" 0x800
# datpatch "out/grp/bayoen.bin" "out/grp/bayoen.bin" "out/grp/bayoen3.bin" 0x400
# datpatch "out/grp/bayoen.bin" "out/grp/bayoen.bin" "out/grp/bayoen4.bin" 0xC00
# datpatch "out/grp/bayoen.bin" "out/grp/bayoen.bin" "out/grp/bayoen_tilde.bin" 0x200
# 
# echo "*******************************************************************************"
# echo "Patching graphics..."
# echo "*******************************************************************************"
# 
# # these one-by-one patches directly to the ISO are extremely slow and wasteful,
# # but good enough for our limited purposes
# 
# datpatch "out/base/loading_1129.bin" "out/base/loading_1129.bin" "out/grp/loading.map" 0x0000
# datpatch "out/base/loading_1129.bin" "out/base/loading_1129.bin" "out/grp/loading.bin" 0x2000
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/dungeon_logo.bin" 0x9D8800
# # ?
# datpatch "$OUTROM" "$OUTROM" "out/grp/dungeon_logo.bin" 0x10299A3
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/button_yesno.bin" 0x9EA600
# datpatch "$OUTROM" "$OUTROM" "out/grp/button_onoff.bin" 0x9EA900
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/mrflea.bin" 0xDD4E20
# datpatch "$OUTROM" "$OUTROM" "out/grp/mrflea.bin" 0x1022400
# datpatch "$OUTROM" "$OUTROM" "out/grp/mrflea.bin" 0x199E800
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/bayoen.bin" 0x9F7400
# datpatch "$OUTROM" "$OUTROM" "out/grp/bayoen.bin" 0x11585A3
# 
# printf \
# "\x04\
# \x81\x00\x56\x00\x08\x01\x86\x01\
# \x81\x00\x76\x00\x12\x01\x86\x00\
# \xA9\x00\x66\x00\x16\x01\x86\x00\
# \xC1\x00\x6C\x00\x1A\x01\x86\x00\
# " > "out/grp/mrflea_spritedef.bin"
# datpatch "$OUTROM" "$OUTROM" "out/grp/mrflea_spritedef.bin" 0x102460D
# datpatch "$OUTROM" "$OUTROM" "out/grp/mrflea_spritedef.bin" 0x19A74D0
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/error_accard.map" 0x924800
# datpatch "$OUTROM" "$OUTROM" "out/grp/error_accard.bin" 0x926800
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/error_clearbak.map" 0x948800
# datpatch "$OUTROM" "$OUTROM" "out/grp/error_clearbak.bin" 0x94A800
# 
# datpatch "$OUTROM" "$OUTROM" "out/grp/error_clearfiles.map" 0x900800
# datpatch "$OUTROM" "$OUTROM" "out/grp/error_clearfiles.bin" 0x902800

echo "*******************************************************************************"
echo "Building script..."
echo "*******************************************************************************"

mkdir -p out/script
mkdir -p out/scripttxt
mkdir -p out/scriptwrap
#mkdir -p out/script/include

importscript "script/script.csv"

scriptwrap "out/scripttxt/battle0.txt" "out/scriptwrap/battle0.txt"
scriptwrap "out/scripttxt/battle2.txt" "out/scriptwrap/battle2.txt"
scriptwrap "out/scripttxt/battle3.txt" "out/scriptwrap/battle3.txt"
scriptwrap "out/scripttxt/battle4.txt" "out/scriptwrap/battle4.txt"
scriptwrap "out/scripttxt/battle_enemy.txt" "out/scriptwrap/battle_enemy.txt"
scriptwrap "out/scripttxt/battle_yuna.txt" "out/scriptwrap/battle_yuna.txt"
scriptwrap "out/scripttxt/postbat.txt" "out/scriptwrap/postbat.txt" "table/yuna_scenes_en.tbl" "out/font/fontwidth_scene.bin"
scriptwrap "out/scripttxt/scene19.txt" "out/scriptwrap/scene19.txt"
scriptwrap "out/scripttxt/scene1C.txt" "out/scriptwrap/scene1C.txt" "table/yuna_en.tbl" "out/font/fontwidth_narrow.bin"
scriptwrap "out/scripttxt/script.txt" "out/scriptwrap/script.txt"
scriptwrap "out/scripttxt/system_adv.txt" "out/scriptwrap/system_adv.txt"
scriptwrap "out/scripttxt/system_boot.txt" "out/scriptwrap/system_boot.txt"
scriptwrap "out/scripttxt/system_load.txt" "out/scriptwrap/system_load.txt"
scriptwrap "out/scripttxt/system_title.txt" "out/scriptwrap/system_title.txt"

scriptwrap "out/scripttxt/scenes.txt" "out/scriptwrap/scenes.txt" "table/yuna_scenes_en.tbl" "out/font/fontwidth_scene.bin"
scriptwrap "out/scripttxt/subintro.txt" "out/scriptwrap/subintro.txt" "table/yuna_scenes_en.tbl" "out/font/fontwidth_scene.bin"
scriptwrap "out/scripttxt/title.txt" "out/scriptwrap/title.txt" "table/yuna_scenes_en.tbl" "out/font/fontwidth_scene.bin"

#scriptbuild "script/" "out/script/"
scriptbuild "out/scriptwrap/" "out/script/"

# echo "*******************************************************************************"
# echo "Building subtitles..."
# echo "*******************************************************************************"
# 
# cp -r rsrc/subs out
# 
# for file in {out/subs/intro,out/subs/preboss,out/subs/ending}/*.png; do
#   name=$(basename $file .png)
#   dname=$(basename $(dirname $file))
#   
#   mkdir -p "out/subs_build/$dname"
#   
# #  echo $name $dname
#   spriteblockmaker "$file" "out/subs_build/$dname/$name.bin"
# done
# 
# # fucking pc engine and its goddamn dumbass video hardware
# for i in `seq -w 03 15`; do
#   spriteblockmaker "out/subs/intro/$i.png" "out/subs_build/intro/$i.bin" -y -8
# done
# 
# echo "*******************************************************************************"
# echo "Prepping disc..."
# echo "*******************************************************************************"
# 
# mkdir -p out/include
# 
# discprep "$OUTROM" "$OUTROM" "out/include/"
# 
# echo "********************************************************************************"
# echo "Applying ASM patches..."
# echo "********************************************************************************"
# 
# #mkdir -p "out/base"
# 
# function applyAsmPatch() {
#   infile=$1
#   asmname=$2
#   linkfile=$3
#   infile_base=$(basename $infile)
#   infile_base_noext=$(basename $infile .bin)
#   
#   cp "$infile" "asm/$infile_base"
#   
#   cd asm
#     # apply hacks
#     ../$WLADX -I ".." -o "$asmname.o" "$asmname.s"
#     ../$WLALINK -v -S "$linkfile" "${infile_base}_build"
#   cd $BASE_PWD
#   
#   mv -f "asm/${infile_base}_build" "out/base/${infile_base}"
#   rm "asm/${infile_base}"
#   
#   rm asm/*.o
# }
# 
# padfile "out/base/boot_11.bin" 0x2000
# padfile "out/base/intro_21.bin" 0x1A000
# padfile "out/base/boot2_1121.bin" 0x2000
# padfile "out/base/dungeon_12B1.bin" 0x34000
# 
# applyAsmPatch "out/base/boot_11.bin" "boot" "boot_link"
# applyAsmPatch "out/base/intro_21.bin" "intro" "intro_link"
# applyAsmPatch "out/base/boot2_1121.bin" "boot2" "boot2_link"
# applyAsmPatch "out/base/dungeon_12B1.bin" "dungeon_text" "dungeon_text_link"
# applyAsmPatch "out/base/dungeon_12B1.bin" "dungeon" "dungeon_link"

echo "********************************************************************************"
echo "Applying ASM patches..."
echo "********************************************************************************"

function applyAsmPatch() {
  infile=$1
  asmname=$2
#  linkfile=$3
  infile_base=$(basename $infile)
  infile_base_noext=$(basename $infile .bin)
  
  linkfile=${asmname}_link
  
  echo "******************************"
  echo "patching: $asmname"
  echo "******************************"
  
  # generate linkfile
  printf "[objects]\n${asmname}.o" >"asm/$linkfile"
  
  cp "$infile" "asm/$infile_base"
  
  cd asm
    # apply hacks
    ../$WLADX -I ".." -o "$asmname.o" "$asmname.s"
    ../$WLALINK -v -S "$linkfile" "${infile_base}_build"
  cd $BASE_PWD
  
  mv -f "asm/${infile_base}_build" "out/base/${infile_base}"
  rm "asm/${infile_base}"
  
  rm asm/*.o
  
  # delete linkfile
  rm "asm/$linkfile"
}

# padfile "out/base/boot_11.bin" 0x2000
# padfile "out/base/intro_21.bin" 0x1A000
# padfile "out/base/boot2_1121.bin" 0x2000
# padfile "out/base/dungeon_12B1.bin" 0x34000
# 
# applyAsmPatch "out/base/boot_11.bin" "boot" "boot_link"
# applyAsmPatch "out/base/intro_21.bin" "intro" "intro_link"
# applyAsmPatch "out/base/boot2_1121.bin" "boot2" "boot2_link"
# applyAsmPatch "out/base/dungeon_12B1.bin" "dungeon_text" "dungeon_text_link"
# applyAsmPatch "out/base/dungeon_12B1.bin" "dungeon" "dungeon_link"

applyAsmPatch "out/base/adv_87EA.bin" "adv"
applyAsmPatch "out/base/battle0_B1BA.bin" "battle0"
applyAsmPatch "out/base/battle2_B1E2.bin" "battle2"
applyAsmPatch "out/base/battle3_B1F6.bin" "battle3"
applyAsmPatch "out/base/battle4_B20A.bin" "battle4"
applyAsmPatch "out/base/boot_2E2.bin" "boot"
applyAsmPatch "out/base/bootloader2_A97C.bin" "bootloader2"
applyAsmPatch "out/base/bootloader4_A97E.bin" "bootloader4"
applyAsmPatch "out/base/bootloader5_A97F.bin" "bootloader5"
applyAsmPatch "out/base/bootloader7_A981.bin" "bootloader7"
applyAsmPatch "out/base/bootloader8_A982.bin" "bootloader8"
applyAsmPatch "out/base/load_42.bin" "load"
applyAsmPatch "out/base/subintro_2.bin" "subintro"
applyAsmPatch "out/base/title_202.bin" "title"
applyAsmPatch "out/base/title_spritedef.bin" "title_spritedef"

# TEST
#applyAsmPatch "out/base/scene18_E41A.bin" "scene18"
#applyAsmPatch "out/base/scene18.bin" "scene18"

for i in `seq 0 28`; do
  numstr=$(printf "%02X" $i)
#  echo $numstr
  scenebase="scene${numstr}"
  scenefile="out/base/$scenebase.bin"
  
  # build scene if its asm file exists
  if [ -f "asm/$scenebase.s" ]; then
    applyAsmPatch "$scenefile" "$scenebase"
  fi;
  
done;

for i in `seq 0 16`; do
  numstr=$(printf "%02X" $i)
#  echo $numstr
  scenebase="postbat${numstr}"
  scenefile="out/base/$scenebase.bin"
  
  # build scene if its asm file exists
  if [ -f "asm/$scenebase.s" ]; then
    applyAsmPatch "$scenefile" "$scenebase"
  fi;
  
done;

# HACK: get palette chunk offset from sprite definition file so we can
# patch it to the separate data block where it is stored
datsnip "out/base/title_spritedef.bin" 0x1FFE 0x2 "out/grp/title_spritedef_paloffset.bin"

echo "********************************************************************************"
echo "Patching disc..."
echo "********************************************************************************"

# patch scene files to scene pack
for i in `seq 0 28`; do
  numstr=$(printf "%02X" $i)
  scenebase="scene${numstr}"
  scenefile="out/base/$scenebase.bin"
  
  datpatch "out/base/scenes_all_E23A.bin" "out/base/scenes_all_E23A.bin" "$scenefile" $(($i*0xA000)) 0 0xA000
done;

# patch postbat files to postbat pack
for i in `seq 0 16`; do
  numstr=$(printf "%02X" $i)
  scenebase="postbat${numstr}"
  scenefile="out/base/$scenebase.bin"
  
  datpatch "out/base/postbat_all_B4DA.bin" "out/base/postbat_all_B4DA.bin" "$scenefile" $(($i*0xA000)) 0 0xA000
done;

yunapatch "$OUTROM" "$OUTROM"

# FIXME: wastes tons of time repeatedly reading and writing back the whole ISO
# from disk. this should be turned into a one-off program that patches
# everything at once.

# ./datpatch "$OUTROM" "$OUTROM" "out/base/subintro_2.bin" $((0x2*0x800)) 0 0xA000
# 
# ./datpatch "$OUTROM" "$OUTROM" "out/base/bootloader2_A97C.bin" $((0xA97C*0x800)) 0 0x800
# 
# # patch scene pack to disc
# datpatch "$OUTROM" "$OUTROM" "out/base/scenes_all_E23A.bin" $((0xE23A*0x800)) 0 0x122000
# 
# ./datpatch "$OUTROM" "$OUTROM" "out/script/script.bin" $((0x85EA*0x800)) 0 0x88000
# ./datpatch "$OUTROM" "$OUTROM" "out/base/adv_87EA.bin" $((0x87EA*0x800)) 0 0x8000
# ./datpatch "$OUTROM" "$OUTROM" "out/base/battle_yuna_all_B3BA.bin" $((0xB3BA*0x800)) 0 0x14000
# ./datpatch "$OUTROM" "$OUTROM" "out/base/battle_enemy_all_B3FA.bin" $((0xB3FA*0x800)) 0 0x8000
# ./datpatch "$OUTROM" "$OUTROM" "out/base/battle0_B1BA.bin" $((0xB1BA*0x800)) 0 0xA000
# ./datpatch "$OUTROM" "$OUTROM" "out/base/battle_yuna_stats_B43A.bin" $((0xB43A*0x800)) 0 0x9800

# echo "*******************************************************************************"
# echo "Building disc..."
# echo "*******************************************************************************"
# 
# $DISCASTER "yuna.dsc"

echo "*******************************************************************************"
echo "Success!"
echo "Output file:" $OUTROM
echo "*******************************************************************************"
