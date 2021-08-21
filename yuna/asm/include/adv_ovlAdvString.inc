.define printSimpleString $6D0D
.define stringSrcPtr $00B3
.bank 0 slot 0
.orga $42F3
.section "stdStringLookup fix 0" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $569E
.section "stdStringLookup fix 1" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5744
.section "stdStringLookup fix 2" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5766
.section "stdStringLookup fix 3" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $57A2
.section "stdStringLookup fix 4" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $57F4
.section "stdStringLookup fix 5" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5897
.section "stdStringLookup fix 6" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $58B9
.section "stdStringLookup fix 7" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $77D4
.section "stdStringLookup fix 8" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $786D
.section "stdStringLookup fix 9" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7991
.section "stdStringLookup fix 10" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $79B7
.section "stdStringLookup fix 11" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7A8F
.section "stdStringLookup fix 12" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7AAA
.section "stdStringLookup fix 13" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7AE0
.section "stdStringLookup fix 14" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7AFB
.section "stdStringLookup fix 15" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $87ED
.section "stdStringLookup fix 16" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $880F
.section "stdStringLookup fix 17" overwrite
  jsr doNewStandardStringLookup
.ends
.define fileNumInsert0 $7852
.define fileNumInsert1 $7976
