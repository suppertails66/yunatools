.define printSimpleString $67A2
.define stringSrcPtr $00BE
.bank 0 slot 0
.orga $5766
.section "stdStringLookup fix 0" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $580C
.section "stdStringLookup fix 1" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $582E
.section "stdStringLookup fix 2" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $586A
.section "stdStringLookup fix 3" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $58BC
.section "stdStringLookup fix 4" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $595F
.section "stdStringLookup fix 5" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5981
.section "stdStringLookup fix 6" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $71FC
.section "stdStringLookup fix 7" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7295
.section "stdStringLookup fix 8" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $73B9
.section "stdStringLookup fix 9" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $73DF
.section "stdStringLookup fix 10" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $74B7
.section "stdStringLookup fix 11" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $74D2
.section "stdStringLookup fix 12" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7508
.section "stdStringLookup fix 13" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7523
.section "stdStringLookup fix 14" overwrite
  jsr doNewStandardStringLookup
.ends
.define fileNumInsert0 $727A
.define fileNumInsert1 $739E
