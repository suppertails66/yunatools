
set -o errexit

tempFontFile=".fontrender_temp"



function renderString() {
  printf "$2" > $tempFontFile
  
#  ./fontrender "font/12px_outline/" "$tempFontFile" "font/12px_outline/table.tbl" "$1.png"
#  ./fontrender "font/" "$tempFontFile" "font/table.tbl" "$1.png"
  ./fontrender "font/orig/" "$tempFontFile" "font/table.tbl" "$1.png"
}

function renderStringNarrow() {
  printf "$2" > $tempFontFile
  
#  ./fontrender "font/12px_outline/" "$tempFontFile" "font/12px_outline/table.tbl" "$1.png"
#  ./fontrender "font/" "$tempFontFile" "font/table.tbl" "$1.png"
  ./fontrender "font/12px/" "$tempFontFile" "font/12px/table.tbl" "$1.png"
}



make blackt && make fontrender

# renderString render1 "In the vicinity of Lyra"
# renderString render2 "Black Hole"
# renderString render3 "GNC-01089"

# renderString render1 "Cardia Star System"
# renderString render2 "Artificial Planet Flint"

# renderString render1 "Planter System"
# renderString render2 "Planet Mariana"

# renderString render1 "Capé System"
# #renderString render2 "Planet Luries"
# renderString render2 "Planet Loureezus"

# renderString render1 "Tian Star Sector"
# renderString render2 "Planet Balmood"

# renderString render1 "The Eastern Outer Arm of the Milky Way"
# renderString render2 "The Dark Nebula"

renderString render1 "Cardia Star System"
renderString render2 "In the vicinity of Artificial Planet Flint"
renderString render3 "The Asteroid Belt"


rm $tempFontFile