.define printSimpleString $66B3
.define stringSrcPtr $00BE
.bank 0 slot 0
.orga $4130
.section "stdStringLookup fix 0" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $4149
.section "stdStringLookup fix 1" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5677
.section "stdStringLookup fix 2" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $571D
.section "stdStringLookup fix 3" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $573F
.section "stdStringLookup fix 4" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $577B
.section "stdStringLookup fix 5" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $57CD
.section "stdStringLookup fix 6" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5870
.section "stdStringLookup fix 7" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $5892
.section "stdStringLookup fix 8" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $710D
.section "stdStringLookup fix 9" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $71A6
.section "stdStringLookup fix 10" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $72CA
.section "stdStringLookup fix 11" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $72F0
.section "stdStringLookup fix 12" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $73C8
.section "stdStringLookup fix 13" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $73E3
.section "stdStringLookup fix 14" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7419
.section "stdStringLookup fix 15" overwrite
  jsr doNewStandardStringLookup
.ends
.bank 0 slot 0
.orga $7434
.section "stdStringLookup fix 16" overwrite
  jsr doNewStandardStringLookup
.ends
.define fileNumInsert0 $718B
.define fileNumInsert1 $72AF
