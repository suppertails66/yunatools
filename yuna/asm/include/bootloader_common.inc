
;==============================================================================
; 
;==============================================================================

.include "include/global.inc"

/*.memorymap
   defaultslot     0
   ; ROM area
   slotsize        $2000
   slot            0       $0000
   slot            1       $2000
   slot            2       $4000
   slot            3       $6000
   slot            4       $8000
   slot            5       $A000
   slot            6       $C000
   slot            7       $E000
.endme */

; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $800
   slot            0       $3800
.endme

.rombankmap
  bankstotal $1
  
  banksize $800
  banks $1
.endro

.emptyfill $FF

;==============================================================================
; constants
;==============================================================================

.define ovlBoot_newCodeBase $3885

; FIXME: directly specifying the page like this is not best practice,
; but probably doesn't actually matter
; (commercial games will usually/always pull the base values from the BIOS
; and then add an offset, i assume to account for a hypothetical future
; hardware revision which might map the memory differently)
.define ovlBoot_extraPagesBase $81
