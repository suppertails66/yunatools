set -o errexit

mkdir -p asm/include

make ovltext_gen
make gensceneovl
make genbattleovl
make genadvstringovl

./ovltext_gen "base/adv_87EA.bin" 0x6950 > "asm/include/adv_ovlText.inc"
./ovltext_gen "base/boot_2E2.bin" 0x62F6 > "asm/include/boot_ovlText.inc"
./ovltext_gen "base/load_42.bin" 0x620B > "asm/include/load_ovlText.inc"
./ovltext_gen "base/title_202.bin" 0x63E5 > "asm/include/title_ovlText.inc"
./ovltext_gen "base/scene19.bin" 0x64D2 > "asm/include/scene19_ovlText.inc"
./ovltext_gen "base/scene1C.bin" 0x75B0 > "asm/include/scene1C_ovlText.inc"
./ovltext_gen "base/battle0_B1BA.bin" 0x7A5C > "asm/include/battle0_ovlText.inc"
./ovltext_gen "base/battle2_B1E2.bin" 0x792C > "asm/include/battle2_ovlText.inc"
./ovltext_gen "base/battle3_B1F6.bin" 0x7983 > "asm/include/battle3_ovlText.inc"
./ovltext_gen "base/battle4_B20A.bin" 0x7C74 > "asm/include/battle4_ovlText.inc"



make gensceneovl

for file in base/scene*.bin; do
  if [ ! $file == "base/scenes_all_E23A.bin" ]; then
    nameshort=$(basename $file .bin)
    echo $nameshort
    if [ $file == "base/scene10.bin" ]; then
      ./gensceneovl "$file" "$nameshort" -bgstartoffset 0x80
    else
      ./gensceneovl "$file" "$nameshort"
    fi
  fi
done;

for file in base/postbat*.bin; do
  if [ ! $file == "base/postbat_all_B4DA.bin" ]; then
    nameshort=$(basename $file .bin)
    echo $nameshort
    ./gensceneovl "$file" "$nameshort"
  fi
done;

#./gensceneovl "base/subintro_2.bin" "subintro" -fill 0xFF
echo "subintro"
./gensceneovl "base/subintro_2.bin" "subintro" --nobackground

echo "title"
./gensceneovl "base/title_202.bin" "title"

#./gensceneovl "base/postbat00_B4DA.bin" "postbat00"



make genbattleovl

echo "battle0"
./genbattleovl "base/battle0_B1BA.bin" "battle0" --nobackground
echo "battle2"
./genbattleovl "base/battle2_B1E2.bin" "battle2"
echo "battle3"
./genbattleovl "base/battle3_B1F6.bin" "battle3"
echo "battle4"
./genbattleovl "base/battle4_B20A.bin" "battle4"



make genadvstringovl

echo "advstring adv"
./genadvstringovl "base/adv_87EA.bin" "adv" --nobackground
echo "advstring boot"
./genadvstringovl "base/boot_2E2.bin" "boot" --nobackground
echo "advstring load"
./genadvstringovl "base/load_42.bin" "load" --nobackground
echo "advstring title"
./genadvstringovl "base/title_202.bin" "title" --nobackground
echo "advstring scene19"
./genadvstringovl "base/scene19.bin" "scene19"
echo "advstring scene1C"
./genadvstringovl "base/scene1C.bin" "scene1C" --nobackground

