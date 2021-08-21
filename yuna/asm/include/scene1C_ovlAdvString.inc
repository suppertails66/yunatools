.define printSimpleString $7A5E
.define stringSrcPtr $00BE
.bank 0 slot 0
.orga $4AD8
.section "stdStringLookup fix 0" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4BA4
.section "stdStringLookup fix 1" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4BC4
.section "stdStringLookup fix 2" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4BE4
.section "stdStringLookup fix 3" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4C04
.section "stdStringLookup fix 4" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4C24
.section "stdStringLookup fix 5" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4C44
.section "stdStringLookup fix 6" overwrite
  jsr doNewStandardStringLookup
.ends
