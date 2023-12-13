
;==============================================================================
; scene 18: intro 1
;==============================================================================

; TODO: patch any needed EX_DSPOFF commands to EX_BGOFF

;===================================
; common include
;===================================

.include "include/scene_common.inc"

;.unbackground $3E5F+$40 $9FFF

.background "scene18.bin"

;==============================================================================
; INCLUDED PATCHES
;==============================================================================

; this comes first
; (due to including the auto-generated unbackground statements)
.include "include/scene18_ovlScene.inc"
.include "overlay/scene.s"

;==============================================================================
; other modifications specific to this executable
;==============================================================================

;================================
; ensure hardware timer is correctly
; set up at end of scene
;================================

;   ----- holy shit this is stupid
;   v
; after much much MUCH frustration, i've determined why the OP's
; timing can vary depending on when this cutscene is skipped.
; the game does not clean up properly after the PSG driver
; after the scene ends, and while the playing track is faded out
; at the end no matter what, the driver itself remains active
; (but is not used for anything during the title/opening,
; and is presumably reloaded when the game proper starts).
; critically, the hardware timer is left in whatever state
; it was in, and it will continue to generate interrupts
; until stopped (which does not occur until the actual gameplay
; starts).
; here's where it gets tricky. there are three possible outcomes
; for skipping this scene:
; 1. RUN is held at the time the scene starts. in this case, the
;    game immediately skips the scene without doing anything.
;    the internal sound driver is never loaded or run, and the
;    timer remains disabled.
; 2. RUN is pressed during the "this is a story..." screen at the
;    start. in this case, the game has loaded the driver, but has
;    yet to start playing anything.
;    in this case, the timer is turned on, but the divider register
;    remains at zero (interrupt every 1024 cycles).
; 3. RUN is pressed any other time (after music has started playing),
;    or the scene is shown in its entirety.
;    starting a track sets the timer to a longer period (e.g. 0x73),
;    and though it will remain turned on, it will keep this value
;    through the title screen and opening.
; in cases 1 and 3, the timer will either be turned off or have a
; long period between generating interrupts, producing minimal impact
; on performance.
; the problem is case 2, which generates interrupts with such frequency
; that it induces considerable lag just from the time the game spends
; acknowledging them and realizing it has no work to do.
; the title screen isn't running too many computations and
; doesn't seem to suffer any noticeable ill effects, but the OP is
; another story. over the course of the sequence, it will accumulate
; a considerable amount of lag, enough to quite noticeably desynchronize
; the visuals from the "normal" state.
;
; so, here's the question: which of these settings did the developers
; actually time the opening animation against, the normal behavior
; or the bugged one?
; because i already timed it against the bugged version.
; ...and the answer appears to be "the non-bugged version".
; motherfuckers.

.bank 0 slot 0
.orga $4023
.section "fix timer init 1" overwrite
  jmp fixTimerInit
.ends

.bank 0 slot 0
.section "fix timer init 2" free
  fixTimerInit:
    ; turn off the timer
    stz $0C01
    
    ; make up work
    jmp $4C56
.ends

;================================
; convert unwanted EX_DSPOFF commands
; to EX_BGOFF
;================================
  
  ; "FIRST" album scroll
  fixDspOffWithSprClrAndSync $4398

;================================
; 
;================================

.bank 0 slot 0
.orga $41DD
.section "fix intro 1" overwrite
  jsr fixIntro
.ends

.bank 0 slot 0
.section "fix intro 2" free
  introMap:
    .incbin "out/maps/intro.bin" FSIZE introMapSize
  introGrp:
    .incbin "out/grp/intro.bin" FSIZE introGrpSize
;    .define introGrpPartSize (introGrpSize/2)
;    .define introGrp_part1 introGrp+(introGrpPartSize*0)
;    .define introGrp_part2 introGrp+(introGrpPartSize*1)
;  introPal:
;    .incbin "out/pal/intro_suit_patch_line.pal" FSIZE introPalSize
  
  ; row 10
  .define introMapDst 10*64/2
  .define introGrpDst $900
;  .define introPalDst $60
  
  fixIntro:
    ; make up work (load resources)
    jsr $54C6
    
    ; load new stuff
    ; i *think* this is safe without the irq off...?
    ; afaik no interrupt active at this point will attempt
    ; to write to the video registers
    jsr EX_IRQOFF
      ; graphics
      st0 #$00
      st1 #<introGrpDst
      st2 #>introGrpDst
      st0 #02
      tia introGrp,$0002,introGrpSize
      
      ; map
      st0 #$00
      st1 #<introMapDst
      st2 #>introMapDst
      st0 #02
      tia introMap,$0002,introMapSize
    jsr EX_IRQON
    
    rts
.ends
  
  

;==============================================================================
; script
;==============================================================================

.bank 0 slot 0
.section "script 1" free  
  ; script resources
  introSuitPatchGrp:
    .incbin "out/grp/intro_suit_patch.bin" FSIZE introSuitPatchGrpSize
    .define introSuitPatchGrpPartSize (introSuitPatchGrpSize/4)
    .define introSuitPatchGrp_part1 introSuitPatchGrp+(introSuitPatchGrpPartSize*0)
    .define introSuitPatchGrp_part2 introSuitPatchGrp+(introSuitPatchGrpPartSize*1)
    .define introSuitPatchGrp_part3 introSuitPatchGrp+(introSuitPatchGrpPartSize*2)
    .define introSuitPatchGrp_part4 introSuitPatchGrp+(introSuitPatchGrpPartSize*3)
  introSuitPatchMap:
    .incbin "out/maps/intro_suit_patch.bin" FSIZE introSuitPatchMapSize
  introSuitUnpatchMap:
    .define introSuitUnpatchMapSize $100
    .rept introSuitUnpatchMapSize/2
      .dw $F7ED
    .endr
  
  subtitleScriptData:
    ;=====
    ; init
    ;=====
    
    cut_resetCompBuffers
    cut_setPalette $08
    
    ;=====
    ; yuna classroom intro
    ;=====
    
    cut_waitForFrame $0100
    
    ; "hi there!"
    .incbin "include/scene18/string250000.bin"
    cut_prepAndSendGrp $01BC
    
;    cut_waitForAdpcm 1
    SYNC_adpcmTime 1 $0244
    
    cut_waitForFrameMinSec 0 9.629
    cut_swapAndShowBuf
    
    ; "i'm a first-year"
    .incbin "include/scene18/string250001.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 0 12.677
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "up 'til now"
    .incbin "include/scene18/string250002.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 0 16.529+(1/60)
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i was just a"
/*    .incbin "include/scene18/string250003.bin"
    cut_prepAndSendGrp $01DC
    
;    cut_waitForFrame $0475
;    cut_waitForFrameMinSec 0 19.364-(8/60)
    cut_waitForFrameMinSec 0 19.364-(4/60)
    cut_subsOff
    cut_swapAndShowBuf*/
    
    cut_waitForFrameMinSec 0 21.842
    cut_subsOff
    
    ;=====
    ; contest scene
    ;=====
    
    ; "and now, the grand prize"
    .incbin "include/scene18/string250004.bin"
    cut_prepAndSendGrp $01DC
    
;    cut_waitForAdpcm 2
    SYNC_adpcmTime 2 $05C2
    
;    cut_waitForFrame $05E6
    cut_waitForFrameMinSec 0 25.539
    cut_swapAndShowBuf
    
    ; "our miss galaxy"
    .incbin "include/scene18/string250005.bin"
    
;      cut_waitForFrame $06BF
      cut_waitForFrameMinSec 0 29.148+(8/60)
      cut_subsOff
    
    cut_prepAndSendGrp $01DC
;    cut_waitForFrame $06E2
    cut_waitForFrameMinSec 0 29.739
    cut_swapAndShowBuf
    
    ; "representing earth"
    .incbin "include/scene18/string250006.bin"
    
;      cut_waitForFrame $07B4
      cut_waitForFrameMinSec 0 33.242
      cut_subsOff
    
    cut_prepAndSendGrp $01DC
    
;    cut_waitForFrame $07D5
    cut_waitForFrameMinSec 0 33.793
    cut_swapAndShowBuf
    
    ; "it was unbelievable"
    .incbin "include/scene18/string250007.bin"
    
      cut_waitForFrameMinSec 0 36.735
      cut_subsOff
    
    cut_prepAndSendGrp $01DC
    
;    cut_waitForAdpcm 3
    SYNC_adpcmTime 3 $095F
    
;    cut_waitForFrame $0946
    cut_waitForFrameMinSec 0 39.939
    cut_swapAndShowBuf
    
    ; "my friend na"
    .incbin "include/scene18/string250008.bin"
    cut_prepAndSendGrp $01BC
    
;    cut_waitForFrame $09B0
    cut_waitForFrameMinSec 0 41.729
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "...and i won"
    .incbin "include/scene18/string250009.bin"
    cut_prepAndSendGrp $01DC
    
;    cut_waitForFrame $0B03
    cut_waitForFrameMinSec 0 47.342
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; the terrible burden of being an idol
    ;=====
    
    ; "then everything just went"
    .incbin "include/scene18/string250010.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrame $0B73
;      cut_waitForFrame $0B6A
      cut_waitForFrameMinSec 0 49.200-(2/60)
      cut_subsOff
    
;    cut_waitForAdpcm 4
    SYNC_adpcmTime 4 $0BB0
    
;    cut_waitForFrame $0B94
    cut_waitForFrameMinSec 0 49.810
    cut_swapAndShowBuf
    
    ; "before i knew it"
    .incbin "include/scene18/string250011.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrameMinSec 0 51.315
      cut_waitForFrameMinSec 0 51.832+0.200+0.200
      cut_subsOff
    
;    cut_waitForFrame $0C40
    cut_waitForFrameMinSec 0 52.732
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i did tv appearances"
    .incbin "include/scene18/string250012.bin"
    cut_prepAndSendGrp $01BC
    
;    cut_waitForFrame $0CE0
    cut_waitForFrameMinSec 0 55.422
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i wasn't a normal"
    .incbin "include/scene18/string250014.bin"
    cut_prepAndSendGrp $01DC
    
;    cut_waitForFrame $0DF2
    cut_waitForFrameMinSec 1 0.213
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 3.222+(6/60)
    cut_subsOff
    
    ;=====
    ; meeting with elner
    ;=====
    
    ; "then one day"
    .incbin "include/scene18/string250015.bin"
    cut_prepAndSendGrp $01DC
    
  ;    cut_waitForFrame $0EB5
    
;    cut_waitForAdpcm 5
    SYNC_adpcmTime 5 $0F72
    
;    cut_waitForFrame $0F53
    cut_waitForFrameMinSec 1 5.853
    cut_swapAndShowBuf
    
    ; "that's when..."
    .incbin "include/scene18/string250016.bin"
    cut_prepAndSendGrp $01BC
    
;    cut_waitForFrame $1095
    cut_waitForFrameMinSec 1 11.216
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna...yuna!"
    .incbin "include/scene18/string250017.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrame $10D6
      cut_waitForFrameMinSec 1 12.232+(6/60)
      cut_subsOff
    
;    cut_waitForAdpcm 6
    SYNC_adpcmTime 6 $1117
    
;    cut_waitForFrame $1129
    cut_waitForFrameMinSec 1 13.848
    cut_swapAndShowBuf
    
    ; "hm...who is it?"
    .incbin "include/scene18/string250018.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 1 17.284
      cut_subsOff
    
;    cut_waitForFrame $11FA
;    cut_waitForFrameMinSec 1 17.284
    cut_waitForFrameMinSec 1 18.606
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "mama?"
    .incbin "include/scene18/string250019.bin"
    cut_prepAndSendGrp $01DC
    
;    cut_waitForFrame $12A0
    cut_waitForFrameMinSec 1 20.090
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "ah, at last we meet"
    .incbin "include/scene18/string250020.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrame $12DF-45
      cut_waitForFrameMinSec 1 21.090
      cut_subsOff
    
    cut_waitForFrameMinSec 1 23.187
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what?!"
    .incbin "include/scene18/string250021.bin"
    cut_prepAndSendGrp $01DC
  
;      cut_waitForFrame $1432
      cut_waitForFrameMinSec 1 26.748
      cut_subsOff
    
;    cut_waitForAdpcm 7
    SYNC_adpcmTime 7 $149E
    
;    cut_waitForFrame 5247
    cut_waitForFrameMinSec 1 27.880
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "eek! a ghost!"
    .incbin "include/scene18/string250022.bin"
    cut_prepAndSendGrp $01BC
  
;      cut_waitForFrame 5319
      cut_waitForFrameMinSec 1 28.925
      cut_subsOff
    
;    cut_waitForFrame 5525
    cut_waitForFrameMinSec 1 30.164
    cut_subsOff
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 1 32.303
    cut_subsOff
    
    ;=====
    ; elner appearance
    ;=====
    
;  24.565 (1+29.948)
;  24.367
;  .99193975
;  1.00812574383
; 44458hz
; 44290 hz
; what are these goddamn numbers??
; empirically, taking a 44100Hz recording
; and shifting the rate to 44290Hz seems to produce
; a result close enough to the actual game speed
; for our timing needs.
; i have no idea what the hell mednafen is doing
; to produce this discrepancy (the source recordings
; are direct emulator output!)
    
    ; "i am elner"
    .incbin "include/scene18/string250023.bin"
;    cut_waitForFrameMinSec 1 39.200
    cut_prepAndSendGrp $01DC
    
;    cut_waitForAdpcm 8
    SYNC_adpcmTime 8 $179C
    
    cut_waitForFrameMinSec 1 40.664
    cut_swapAndShowBuf
    
    ; "i have been waiting"
    .incbin "include/scene18/string250024.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 1 42.568
;      cut_subsOff
    
    cut_waitForFrameMinSec 1 44.177
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "geez, that scared"
    .incbin "include/scene18/string250025.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 1 47.419+(9/60)
      cut_subsOff
    
    ;=====
    ; space scroll
    ;=====
    
;    cut_waitForAdpcm 9
    SYNC_adpcmTime 9 $1960
    
    cut_waitForFrameMinSec 1 48.193
    cut_swapAndShowBuf
    
    ; "so, according to"
    .incbin "include/scene18/string250026.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 50.796
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "there was apparently this"
    .incbin "include/scene18/string250027.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 1 56.312
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the power of darkness"
    .incbin "include/scene18/string250028.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 1 59.564
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "as part of the matrix"
    .incbin "include/scene18/string250029.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 2.554
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the darkness lost by"
    .incbin "include/scene18/string250030.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 6.716
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yuna, listen"
    .incbin "include/scene18/string250032.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 10.833
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the power of darkness is"
    .incbin "include/scene18/string250033.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 13.650
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "it is trying to take"
    .incbin "include/scene18/string250034.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 16.698
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "...huh?"
    .incbin "include/scene18/string250035.bin"
    cut_prepAndSendGrp $01BC
    
    ; $2097
    cut_waitForFrameMinSec 2 19.853
    cut_subsOff
    cut_swapAndShowBuf
    
    ; previous line is very short, and the next line is very long,
    ; so we have to schedule the subtitle cutoff asynchronously
    ; (otherwise, it would get delayed past the load transition)
;    cut_queueSubsOff $20AF
    cut_queueSubsOff $20DD+4
    
    ;=====
    ; police at house
    ;=====
    
    ; "and the girls"
    .incbin "include/scene18/string250036.bin"
    cut_prepAndSendGrp $01DC
    
;      cut_waitForFrame $20AE
;      cut_subsOff
    
;    cut_waitForAdpcm 10
;    SYNC_adpcmTime $20B8
    SYNC_adpcmTime 10 $210C
    
    cut_waitForFrameMinSec 2 20.903
;    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that's its doing"
    .incbin "include/scene18/string250037.bin"
    cut_prepAndSendGrp $01BC
    
;    cut_waitForFrameMinSec 2 27.866
    cut_waitForFrameMinSec 2 25.170
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but what's the darkness"
    .incbin "include/scene18/string250038.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 28.853
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "well..."
    .incbin "include/scene18/string250039.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 32.428-(6/60)
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yoko appears
    ;=====
    
    ; "yuna! come out"
    .incbin "include/scene18/string250040.bin"
    cut_prepAndSendGrp $01DC
    
  ;    cut_waitForFrameMinSec 2 32.539
;      cut_waitForFrame $23B2
      cut_waitForFrameMinSec 2 33.077+(7/60)
      cut_subsOff
    
;    cut_waitForAdpcm 13
    SYNC_adpcmTime 13 $25D4
    
    cut_waitForFrameMinSec 2 41.337
 ;   cut_subsOff
    cut_swapAndShowBuf
    
    ; "as the one who should truly"
    .incbin "include/scene18/string250041.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 43.862
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what's that at this"
    .incbin "include/scene18/string250042.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 2 47.966+(8/60)
      cut_subsOff
    
;    cut_waitForAdpcm 14
    SYNC_adpcmTime 14 $2797
    
    cut_waitForFrameMinSec 2 48.783
    cut_swapAndShowBuf
    
    ; "aah!"
    .incbin "include/scene18/string250043.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 2 50.936-(4/60)
      cut_subsOff
    
    cut_waitForFrameMinSec 2 51.759
    cut_swapAndShowBuf
    
    ; "what's the matter?"
    .incbin "include/scene18/string250044.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 53.075
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that girl, she was"
    .incbin "include/scene18/string250045.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 2 54.372
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that's yoko mizuno"
    .incbin "include/scene18/string250046.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 2 57.493
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what's she dressed like that"
    .incbin "include/scene18/string250047.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 2 57.411
;      cut_subsOff
    
    cut_waitForFrameMinSec 2 59.191
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "that is a battle suit"
    .incbin "include/scene18/string250048.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 3 1.107
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "the darkness has kidnapped"
    .incbin "include/scene18/string250049.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 3 4.267
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "what? why?!"
    .incbin "include/scene18/string250050.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 3 7.949
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "because you are"
    .incbin "include/scene18/string250051.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 3 9.232
      cut_subsOff
    
;    cut_waitForAdpcm 15
    SYNC_adpcmTime 15 $2CA7
    
    cut_waitForFrameMinSec 3 10.543
    cut_swapAndShowBuf
    
    ; "fight, yuna!"
    .incbin "include/scene18/string250052.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 3 13.930
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "huh?!"
    .incbin "include/scene18/string250053.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 3 15.314
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna battle suit
    ;=====
    
    ; "what's with these clothes"
    .incbin "include/scene18/string250054.bin"
    cut_prepAndSendGrp $01DC
    
      cut_waitForFrameMinSec 3 16.314
      cut_subsOff
    
    ; set up sprite offset for this scene
;    cut_waitForFrame $2ED9-$10
    cut_waitForFrame $2EF7
    cut_setHighPrioritySprObjOffset 16
      
      ; game uses sprites for this sequence.
      ; since they take up too many sprites per line to show subtitles
      ; on top, we temporarily patch over the relevant area with background
      ; tiles to mask the problem.
      
      ; palette
      cut_writePalette $0070 introSuitPatchPalSize
        .incbin "out/pal/intro_suit_patch_line.pal" FSIZE introSuitPatchPalSize
        
      ; graphics
      cut_writeVram introSuitPatchGrp_part1 $6A00+((introSuitPatchGrpPartSize*0)/2) introSuitPatchGrpPartSize
      cut_writeVram introSuitPatchGrp_part2 $6A00+((introSuitPatchGrpPartSize*1)/2) introSuitPatchGrpPartSize
      cut_writeVram introSuitPatchGrp_part3 $6A00+((introSuitPatchGrpPartSize*2)/2) introSuitPatchGrpPartSize
      cut_writeVram introSuitPatchGrp_part4 $6A00+((introSuitPatchGrpPartSize*3)/2) introSuitPatchGrpPartSize
;      cut_writeVram $6A00 introSuitPatchGrpSize
;        .incbin "out/grp/intro_suit_patch.bin" FSIZE introSuitPatchGrpSize
      
      ; transfer bg map
      cut_waitForFrame $3028
      cut_writeVram introSuitPatchMap $0300 introSuitPatchMapSize
    
;      cut_waitForAdpcm 16
      SYNC_adpcmTime 16 $3073
    
      ; finally, display prepped text
      cut_waitForFrameMinSec 3 26.583
      cut_swapAndShowBuf
      
      ; "should danger ever befall you"
      .incbin "include/scene18/string250055.bin"
      cut_prepAndSendGrp $01BC
      
;        cut_waitForFrameMinSec 3 27.000-(2/60)
        ; actual cutout occurs at about $30D8
        cut_waitForFrame $30D4
        cut_subsOff
      
        ; patch over our temporary tilemap with blank tilemap
;        cut_waitForFrame $2FCA
        cut_writeVram introSuitUnpatchMap $0300 introSuitUnpatchMapSize
        
      cut_waitForFrameMinSec 3 28.591
      cut_swapAndShowBuf
      
;      cut_waitForFrameMinSec 3 32.031
;      cut_subsOff
      
      ; "what are you doing"
      .incbin "include/scene18/string250056.bin"
      cut_prepAndSendGrp $01DC
      
      cut_waitForFrameMinSec 3 32.641
      cut_subsOff
      cut_swapAndShowBuf
      
      ; "hey, you! you need to"
      .incbin "include/scene18/string250057.bin"
      cut_prepAndSendGrp $01BC
    
        cut_waitForFrameMinSec 3 35.607+(17/60)
        cut_subsOff
    
    ; restore normal sprite obj settings
;    cut_waitForFrame $3208+$10
    cut_waitForFrame $32B6
    cut_setHighPrioritySprObjOffset 0
    
    ;=====
    ; yuna yoko faceoff
    ;=====
  
;    cut_waitForAdpcm 17
    SYNC_adpcmTime 17 $32C2
    
    cut_waitForFrameMinSec 3 36.488+(5/60)
    cut_swapAndShowBuf
    
    ; "it's the middle of the night"
    .incbin "include/scene18/string250058.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 3 39.604
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "be a little more considerate"
    .incbin "include/scene18/string250059.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 3 43.112+(8/60)
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "shut up, shut up, shut up"
    .incbin "include/scene18/string250060.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 3 46.402
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "if you just hadn't been there"
    .incbin "include/scene18/string250061.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 3 47.936
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "i'll never forgive you"
    .incbin "include/scene18/string250063.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 3 52.417
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; yuna yoko battle
    ;=====
    
    ; "but why me?!"
    .incbin "include/scene18/string250064.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 3 55.369
      cut_subsOff
  
    SYNC_adpcmTime 18 $37CE
    
    cut_waitForFrameMinSec 3 58.030
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "yoko, you shouldn't be"
    .incbin "include/scene18/string250065.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 4 1.630
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "please just calm down"
    .incbin "include/scene18/string250066.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 4 4.156
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "shut up"
    .incbin "include/scene18/string250067.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 4 6.294
    cut_subsOff
    cut_swapAndShowBuf
    
    ;=====
    ; battle aftermath
    ;=====
    
    ; "are you alright"
    .incbin "include/scene18/string250068.bin"
    cut_prepAndSendGrp $01BC
    
;      cut_waitForFrameMinSec 4 5.653
      cut_waitForFrameMinSec 4 7.127
      cut_subsOff
  
    SYNC_adpcmTime 20 $3D6A
    
    cut_waitForFrameMinSec 4 22.025
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "don't worry!"
    .incbin "include/scene18/string250069.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 4 24.328
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "but more importantly"
    .incbin "include/scene18/string250070.bin"
    cut_prepAndSendGrp $01BC
    
    cut_waitForFrameMinSec 4 28.441
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "you must be vigilant!"
    .incbin "include/scene18/string250071.bin"
    cut_prepAndSendGrp $01DC
    
    cut_waitForFrameMinSec 4 31.054
    cut_subsOff
    cut_swapAndShowBuf
    
    ; "how did i get myself into this"
    .incbin "include/scene18/string250072.bin"
    cut_prepAndSendGrp $01BC
    
      cut_waitForFrameMinSec 4 32.167+0.500+(4/60)
      cut_subsOff
    
    cut_waitForFrameMinSec 4 35.186
    cut_swapAndShowBuf
    
    cut_waitForFrameMinSec 4 37.789
    cut_subsOff
    
    cut_terminator
.ends



