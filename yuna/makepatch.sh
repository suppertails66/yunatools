versionnum="v1.1"

filename_orig="patch/auto_patch/Ginga Ojousama Densetsu Yuna EN [${versionnum}-original].xdelta"
filename_rerelease="patch/auto_patch/Ginga Ojousama Densetsu Yuna EN [${versionnum}-rerelease].xdelta"
filenameredump_orig="patch/redump_patch/Ginga Ojousama Densetsu Yuna EN [${versionnum}-original] Redump.xdelta"
filenameredump_rerelease="patch/redump_patch/Ginga Ojousama Densetsu Yuna EN [${versionnum}-rerelease] Redump.xdelta"
filenamesplitbin_orig="patch/splitbin_patch/Ginga Ojousama Densetsu Yuna EN [${versionnum}-original] SplitBin.xdelta"
filenamesplitbin_rerelease="patch/splitbin_patch/Ginga Ojousama Densetsu Yuna EN [${versionnum}-rerelease] SplitBin.xdelta"

mkdir -p patch
mkdir -p patch/auto_patch
mkdir -p patch/redump_patch
mkdir -p patch/splitbin_patch


./build.sh

rm -f "$filename"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "$filename"
xdelta3 -e -f -B 154050560 -s "patch/exclude/yuna_orig_02.iso" "yuna_02_build.iso" "$filename_orig"
xdelta3 -e -f -B 154050560 -s "patch/exclude/yuna_rerelease_02.iso" "yuna_02_build.iso" "$filename_rerelease"

rm -f "$filenameredump"
../discaster/discaster yuna.dsc
xdelta3 -e -f -B 488764416 -s "patch/exclude/yuna_orig.bin" "yuna_build.bin" "$filenameredump_orig"
xdelta3 -e -f -B 488740896 -s "patch/exclude/yuna_rerelease.bin" "yuna_build.bin" "$filenameredump_rerelease"


#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip0.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip1.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip2.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip2_soundfix.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip3.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip4.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip5.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip6.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip7.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip8.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip9.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip10.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip11.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip12.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip13.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip14.xdelta"
#xdelta3 -e -B 154050560 -s yuna_02.iso yuna_02_build.iso "yuna_en_wip15.xdelta"