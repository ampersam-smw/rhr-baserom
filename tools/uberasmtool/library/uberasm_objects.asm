; include common freeram
incsrc "../../../shared/freeram.asm"
; include retry definitions
incsrc "../retry_config/ram.asm"

; UberASM Objects system
;
; run the init in gamemode 12 (level load) and the main in gamemode 14 (in level)
;
; This system requires ObjecTool and reserves Extended objects 98-CF
; see patches/objectool/custom_object_code.asm for details

macro ObjectRoutine(object_number, routine)
    db <object_number>-$98 : dw <routine>
endmacro

routines:
.init
    %ObjectRoutine($98, free_vertical_scroll)
    %ObjectRoutine($99, no_horizontal_scroll)
    %ObjectRoutine($9A, set_state_to_off)
    %ObjectRoutine($9B, block_duplication)
    %ObjectRoutine($9C, toggle_status_bar)
    %ObjectRoutine($9D, toggle_lr_scroll)
    %ObjectRoutine($9E, enable_sfx_echo)
    %ObjectRoutine($A2, vanilla_turnaround)
    %ObjectRoutine($A9, spinjump_fireballs)
    %ObjectRoutine($AA, springboard_fixes)
    %ObjectRoutine($B0, retry_instant)
    %ObjectRoutine($B1, retry_prompt)
    %ObjectRoutine($B2, retry_bottom_left)
    %ObjectRoutine($B3, retry_no_midway_powerup)
    %ObjectRoutine($B4, retry_vanilla)
..end

.main
    %ObjectRoutine($A0, no_powerups)
    %ObjectRoutine($A3, eight_frame_float)
    %ObjectRoutine($A4, zero_float_delay)
    %ObjectRoutine($A5, death_on_power_up_loss)
    %ObjectRoutine($A7, press_lr_to_die)
    %ObjectRoutine($AB, disable_cape_flight)
    %ObjectRoutine($AC, disable_screen_shake)
..end

init:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl
.not_castle_entrance

    phb
    phk
    plb
    lda.b #routines_init&$FF
    sta $00
    lda.b #routines_init>>8
    sta $01
    rep #$10
    ldy.w #routines_init_end-routines_init-3
    jsr run_routines
    plb

.return
    rtl

main:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl
.not_castle_entrance

    phb
    phk
    plb
    lda.b #routines_main&$FF
    sta $00
    lda.b #routines_main>>8
    sta $01
    rep #$10
    ldy.w #routines_main_end-routines_main-3
    jsr run_routines
    plb

.return
    rtl


; word routine table pointer in $00-$01
; table size - 3 (in bytes) in 16-bit Y (16-bit needed since 3 * 0x68 > 0xFF)
; clobbers: $02, $03, $04
run_routines:
    lda #$00
    xba             ; zero out high byte of A so we can transfer to 16-bit X later
.loop
    lda ($00),y     ; load current custom object number
    sta $02         ; cache in $02
    lsr #3          ; divide custom object number by 8 to get byte index into FreeRAM
    sta $03         ; cache in $03
    stz $04         ; zero out $04 so 16-bit X can load index later
    lda $02         ; restore custom object number from $02
    and #$07        ; modulo 8 to get bit index
    tax
    lda ..masks,x   ; load correct mask for the bit
    ldx $03         ; load byte index from $03-$04
    and !objectool_level_flags_freeram,x
    beq ..next      ; if bit not set skip the routine

    iny
    lda ($00),y
    sta $02
    iny
    lda ($00),y
    sta $03         ; otherwise, load word routine address into $02-$03

    phy             ; pushing current table index rather than caching in scratch so routines can use scratch
    sep #$10        ; ensuring routines get 8-bit everything
    ldx #$00
    jsr ($0002|!dp,x)   ; jump to object routine in $02-$03
    rep #$10        ; restore 16-bit X/Y
    ply             ; restore current table index

    dey #2          ; need to undo the two iny's from earlier

..next
    dey #3          ; move to next table entry
    bpl .loop
    sep #$10
    rts

..masks
    db 1,2,4,8,16,32,64,128


;---------------------------------------------------------------------
; Code to run for each extended object
; IDs correspond to patches/objectool/custom_object_code.asm
;---------------------------------------------------------------------

; Extended Object 98
; Free vertical scrolling
free_vertical_scroll:
    lda #$01 : sta $1404|!addr
    rts

; Extended Object 99
; lock horizontal scroll
no_horizontal_scroll:
    stz $1411|!addr
    rts

; Extended Object 9A
; Set ON/OFF state to OFF
set_state_to_off:
    lda #$01 : sta $14AF|!addr
    rts

; Extended Object 9B
; Toggle block duplication
block_duplication:
    lda #$01 : sta !toggle_block_duplication_freeram
    rts

; Extended Object 9C
; Toggle status bar
toggle_status_bar:
    lda #$01 : sta !toggle_statusbar_freeram
    rts

; Extended Object 9D
; Toggle l/r scroll
toggle_lr_scroll:
    lda #$01 : sta !toggle_lr_scroll_freeram
    rts

; Extended Object 9E
; Enable Echo channel in inserted music
enable_sfx_echo:
    lda $1DFA|!addr : bne +
    lda #$06 : sta $1DFA|!addr
    +
    rts

; Extended Object 9F (skipped because it loads a door tile)

; Extended Object A0
; Cannot collect power-ups in the level
no_powerups:
    stz $19             ; Reset powerup.
    stz $0DC2|!addr     ; Reset item box.
    rts

; Extended Object A1 (skipped because it loads a door tile)

; Extended Object A2
; Toggle vanilla cape spin in air
vanilla_turnaround:
    lda #$01 : sta !toggle_capespin_direction_freeram
    rts

; Extended Object A3
; Enable eight frame float with cape
eight_frame_float:
    lda $15             ;\ Check if A or B button is being held
    and #$80            ;/
    beq +
    lda #$08            ;\ Store 8 frames to cape float
    sta $14A5|!addr     ;/
    +
    rts

; Extended Object A4
; Zero float delay with cape
zero_float_delay:
    lda $187A|!addr     ;\ Check if Mario is riding Yoshi with wings...
    and $141E|!addr     ;/
    bne +
    stz $14A5|!addr     ; Disable the float timer
    +
    rts

; Extended Object A5
; death on power up loss
death_on_power_up_loss:
    lda $71             ;\ Check if mario is in hurt state
    cmp #$01            ;/
    bne +
    jsl $00F606|!bank   ; Kill the player
+
    rts

; Extended Object A6 (is skipped because it loads a door tile)

; Extended Object A7
press_lr_to_die:
    lda $17             ;\ Check if L & R are pressed
    and #%00110000      ;|
    cmp #$30            ;/
    bne +
    jsl $00F606|!bank   ; Kill the player
+
    rts

; Extended Object A8 (is skipped because it loads a door tile)

; Extended Object A9
; toggle spin jump fireballs
spinjump_fireballs:
    lda #$01 : sta !toggle_spinjump_fireball_freeram
    rts

; Extended Object AA
; toggle springboard fixes
springboard_fixes:
    lda #$01 : sta !toggle_springboard_fixes_freeram
    rts

; Extended Object AB
; disable cape flight
disable_cape_flight:
    stz $149F|!addr     ; store zero to the flight timer to prevent take off
    rts

; Extended Object AC
; disable screen shake
disable_screen_shake:
    sta $1887|!addr       ; store zero to the layer 1 shake timer
    rts

; Extended Object AD
; Extended Object AE
; Extended Object AF

; Extended Object B0
; Use instant retry
retry_instant:
    lda #$03 : sta !retry_ram_prompt_override
    rts

; Extended Object B1
; Use prompt retry
retry_prompt:
    lda #$02 : sta !retry_ram_prompt_override
    rts

; Extended Object B2
; Display retry prompt in bottom left
retry_bottom_left:
    lda #$09 : sta !retry_ram_prompt_x_pos
    lda #$d0 : sta !retry_ram_prompt_y_pos
    rts

; Extended Object B3
; No powerup from midways
retry_no_midway_powerup:
    lda #$00 : sta !retry_ram_midway_powerup
    rts

; Extended Object B4
; Vanilla death sequence
retry_vanilla:
    lda #$04 : sta !retry_ram_prompt_override
    rts
; Extended Object B5
; Extended Object B6
; Extended Object B7
; Extended Object B8
; Extended Object B9
; Extended Object BA
; Extended Object BB
; Extended Object BC
; Extended Object BD
; Extended Object BE
; Extended Object BF
; Extended Object C0
; Extended Object C1
; Extended Object C2
; Extended Object C3
; Extended Object C4
; Extended Object C5
; Extended Object C6
; Extended Object C7
; Extended Object C8
; Extended Object C9
; Extended Object CA
; Extended Object CB
; Extended Object CC
; Extended Object CD
; Extended Object CE
; Extended Object CF