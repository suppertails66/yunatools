set -o errexit

mkdir -p rsrc/grp/orig

make

# ./grpunmap_pce rsrc_raw/grp/title_logo_grp.bin rsrc_raw/grp/title_logo_map.bin 64 32 rsrc/grp/orig/title_logo.png -v 0x100 -p rsrc_raw/pal/title_logo.pal -t
# ./grpunmap_pce rsrc_raw/grp/title_logo_grp.bin rsrc_raw/grp/title_logo_map.bin 64 32 rsrc/grp/orig/title_logo_grayscale.png -v 0x100 -t
# ./grpunmap_pce "rsrc_raw/grp/loading_grp.bin" "rsrc_raw/map/loading.map" 64 64 "rsrc/grp/orig/loading.png" -v 0x0 -p "rsrc_raw/pal/loading.pal"
# ./grpdmp_pce "rsrc_raw/grp/dungeon_logo.bin" "rsrc/grp/orig/dungeon_logo.png" -p "rsrc_raw/pal/dungeon_logo_line.pal" -r 16
# ./grpdmp_pce "rsrc_raw/grp/button_yesno.bin" "rsrc/grp/orig/button_yesno.png" -p "rsrc_raw/pal/dungeon_button_line.pal" -r 6
# ./grpdmp_pce "rsrc_raw/grp/button_onoff.bin" "rsrc/grp/orig/button_onoff.png" -p "rsrc_raw/pal/dungeon_button_line.pal" -r 6
# 
# ./spritedmp_pce "rsrc_raw/grp/mrflea.bin" "rsrc/grp/orig/mrflea.png" -p "rsrc_raw/pal/dungeon_mrflea_line.pal" -r 16
# 
# ./spritedmp_pce "rsrc_raw/grp/bayoen.bin" "rsrc/grp/orig/bayoen_ba.png" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -s 0x0
# ./spritedmp_pce "rsrc_raw/grp/bayoen.bin" "rsrc/grp/orig/bayoen_yo.png" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -s 0x800
# ./spritedmp_pce "rsrc_raw/grp/bayoen.bin" "rsrc/grp/orig/bayoen_e.png" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -s 0x400
# ./spritedmp_pce "rsrc_raw/grp/bayoen.bin" "rsrc/grp/orig/bayoen_n.png" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -s 0xC00
# 
# ./grpunmap_pce "rsrc_raw/grp/error_accard.bin" "rsrc_raw/grp/error_accard.bin" 64 64 "rsrc/grp/orig/error_accard.png" -v 0x0 -p "rsrc_raw/pal/error_accard.pal"
# ./grpunmap_pce "rsrc_raw/grp/error_clearbak.bin" "rsrc_raw/grp/error_clearbak.bin" 64 64 "rsrc/grp/orig/error_clearbak.png" -v 0x0 -p "rsrc_raw/pal/error_clearbak.pal"
# ./grpunmap_pce "rsrc_raw/grp/error_clearfiles.bin" "rsrc_raw/grp/error_clearfiles.bin" 64 64 "rsrc/grp/orig/error_clearfiles.png" -v 0x0 -p "rsrc_raw/pal/error_clearfiles.pal"

# ./spritedmp_pce "rsrc_raw/grp/bayoen.bin" "rsrc/grp/orig/bayoen_n.png" -p "rsrc_raw/pal/dungeon_bayoen_line.pal" -r 2 -s 0xC00

# ./yuna_grpextr "rsrc_raw/img/karaoke.bin" "rsrc/grp/orig/karaoke.png"
# ./yuna_grpextr "rsrc_raw/img/snap.bin" "rsrc/grp/orig/snap.png"
# ./yuna_grpextr "base/grp_8D62.bin" "rsrc/grp/orig/noentry.png" -s 0x4316
# ./datsnip "base/grp_8D62.bin" 0x4316 0x218A "rsrc_raw/img/noentry.bin"
# #./yuna_grpextr "base/grp_8C8A.bin" "rsrc/grp/orig/noentry2.png" -s 0x64A1

# ./spritedmp_pce "rsrc_raw/grp/flint_map.bin" "rsrc/grp/orig/flint_map.png" -p "rsrc_raw/pal/flint_map_line.pal" -r 1 -s 0x0

# ./spritedmp_pce "rsrc_raw/grp/blackhole_txt.bin" "rsrc/grp/orig/blackhole_txt.png" -r 8 -s 0x0
# ./spritedmp_pce "rsrc_raw/grp/flint_txt.bin" "rsrc/grp/orig/flint_txt.png" -r 8 -s 0x0
# ./datsnip "yuna_02.iso" 0x41A3050 0x800 "rsrc_raw/grp/mariana_txt.bin"
# ./spritedmp_pce "rsrc_raw/grp/mariana_txt.bin" "rsrc/grp/orig/mariana_txt.png" -r 8 -s 0x0
# ./datsnip "yuna_02.iso" 0x63050B0 0x800 "rsrc_raw/grp/luries_txt.bin"
# ./spritedmp_pce "rsrc_raw/grp/luries_txt.bin" "rsrc/grp/orig/luries_txt.png" -r 8 -s 0x0
# ./datsnip "yuna_02.iso" 0x63340B0 0x800 "rsrc_raw/grp/balmood_txt.bin"
# ./spritedmp_pce "rsrc_raw/grp/balmood_txt.bin" "rsrc/grp/orig/balmood_txt.png" -r 6 -s 0x0
#./datsnip "yuna_02.iso" 0x638FA90 0x800 "rsrc_raw/grp/darknebula_txt.bin"
#./spritedmp_pce "rsrc_raw/grp/darknebula_txt.bin" "rsrc/grp/orig/darknebula_txt.png" -r 8 -s 0x0
# ./datsnip "yuna_02.iso" 0x63C50B0 0xC00 "rsrc_raw/grp/asteroid_txt.bin"
# ./spritedmp_pce "rsrc_raw/grp/asteroid_txt.bin" "rsrc/grp/orig/asteroid_txt.png" -r 8 -s 0x0

./datsnip "yuna_02.iso" 0x5408240 0x460 "rsrc_raw/grp/hud_gemy.bin"
#./grpdmp_pce "rsrc_raw/grp/hud_gemy.bin" "rsrc/grp/orig/hud_gemy.png" -p "rsrc_raw/pal/hud_pal7.pal" -r 5
./grpdmp_pce "rsrc_raw/grp/hud_gemy.bin" "rsrc/grp/orig/hud_gemy.png" -r 5

#./datsnip "yuna_02.iso" 0x698D000 0x27F3D "rsrc_raw/grp/credits_bg.bin"
#./datsnip "yuna_02.iso" 0x698D000 0x28000 "rsrc_raw/grp/credits_grp.bin"

#./datsnip "yuna_02.iso" 0x4970812 0x1000 "rsrc_raw/grp/temple_doka.bin"
#./spritedmp_pce "rsrc_raw/grp/temple_doka.bin" "rsrc/grp/temple_doka_raw.png" -r 2 -s 0x0 -p "rsrc_raw/pal/temple_doka.pal"

# ./spritedmp_pce "rsrc_raw/grp/title_sublogo_en.bin" "rsrc/grp/orig/title_sublogo_en.png" -r 7 -s 0x0

