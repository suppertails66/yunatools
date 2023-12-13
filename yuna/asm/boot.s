
;.include "sys/pce_arch.s"
;.include "base/macros.s"

.include "include/global.inc"

; could someone please rewrite wla-dx to allow dynamic bank sizes?
; thanks
.memorymap
   defaultslot     0
   
   slotsize        $A000
   slot            0       $4000
.endme

.rombankmap
  bankstotal $1
  
  banksize $A000
  banks $1
.endro

.emptyfill $FF

.background "boot_2E2.bin"

.unbackground $4100 $47FF
;.unbackground $4800 $4FFF

;===================================
; new hardcoded strings
; (note: at top of this file due to
; containing additional auto-generated
; unbackground statements for old strings)
;===================================

.include "include/system_boot_strings_overwrite.inc"

.bank 0 slot 0
.section "system_boot static strings free" free
  .include "include/system_boot_strings.inc"
.ends

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

.define ovlText_fontLoadType fontLoadType_normal
.define ovlText_useLimitedFont 1
.include "include/boot_ovlText.inc"
.include "overlay/text.s"

.include "include/boot_ovlAdvString.inc"
.include "overlay/adv_string.s"

;==============================================================================
; 
;==============================================================================

;===================================
; don't set up alternate cd track
; with CD_BASE (since we're not
; translating the backup track)
;===================================

.bank 0 slot 0
.orga $40C6
.section "no backup track 1" overwrite
  jmp $40D5
.ends

;===================================
; DEBUG: cutscene forcer
;===================================

/*.bank 0 slot 0
.orga $417A
.section "force scene 1" overwrite
  ; prog num (DO NOT CHANGE)
  lda #$02
.ends

; - 00 = first cruiser takeoff
; - 01 = yuna in cockpit after first cruiser takeoff
; - 02 = lia shows up to fight final boss
; - 03 = dark gate scroll
; - 04 = flint (machine planet) intro
; - 05 = mariana (water planet) intro
; - 06 = loureezus (jungle planet) intro
; - 07 = balmood (floating island planet) intro
; - 08 = black hole intro
; - 09 = dark nebula intro
; - 0A = flint asteroid field intro
; - 0B = entering dark gate
; - 0C = asteroid explosion + aftermath
; - 0D = ultimate gattai
; - 0E = sayuka arrival
; - 0F = leaving mariana after temple + message from ryudia
; - 10 = erina awakening
; - 11 = marina awakening
; - 12 = gina awakening
; - 13 = gina fusion
; - 14 = marina fusion
; - 15 = erina fusion
; - 16 = lia death
; - 17 = leftovers from trial version/kiosk demo.
;          "on sale october 23rd", then the alternate title screen
;          (program 6)
; - 18 = intro
; - 19 = swimsuit contest results
; - 1A = ultimate attack on final boss
; - 1B = ending
; - 1C = credits
.bank 0 slot 0
.orga $41A4
.section "force scene 2" overwrite
  ; scene num
  lda #$19
.ends*/

;===================================
; DEBUG: post-battle scene forcer
;===================================

/*.bank 0 slot 0
.orga $417A
.section "force postbat 1" overwrite
  ; prog num (DO NOT CHANGE)
  lda #$05
.ends

;  - 00 = yoshika
;  - 01 = rock princess
;  - 02 = mai 1 (beach)
;  - 03 = mai 2 (corridor)
;  - 04 = shiori
;  - 05 = alephtina
;  - 06 = luminaev
;  - 07 = remin
;  - 08 = ryudia
;  - 09 = emily
;  - 0A = gatekeeper
;  - 0B = yuna beats lia
;  - 0C = sayuka
;  - 0D = lia beats yuna
;  - 0E = kaede
;  - 0F = mari
;  - 10 = sayuka beats lia
.bank 0 slot 0
.orga $41A4
.section "force postbat 2" overwrite
  ; scene num
  lda #$00
.ends*/



