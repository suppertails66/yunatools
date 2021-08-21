.define printSimpleString $65C8
.define stringSrcPtr $00BE
.bank 0 slot 0
.orga $5585
.section "stdStringLookup fix 0" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $562B
.section "stdStringLookup fix 1" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $564D
.section "stdStringLookup fix 2" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5689
.section "stdStringLookup fix 3" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $56DB
.section "stdStringLookup fix 4" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $577E
.section "stdStringLookup fix 5" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $57A0
.section "stdStringLookup fix 6" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7022
.section "stdStringLookup fix 7" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $70BB
.section "stdStringLookup fix 8" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $71DF
.section "stdStringLookup fix 9" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7205
.section "stdStringLookup fix 10" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $72DD
.section "stdStringLookup fix 11" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $72F8
.section "stdStringLookup fix 12" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $732E
.section "stdStringLookup fix 13" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7349
.section "stdStringLookup fix 14" overwrite
  jsr doNewStandardStringLookup
.ends
.define fileNumInsert0 $70A0
.define fileNumInsert1 $71C4
