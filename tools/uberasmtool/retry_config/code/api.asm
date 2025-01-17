;================================================
; Routines that can be called by external UberASM files
;================================================

;================================================
; Routine to respawn in the level (at the current checkpoint),
; effectively the same as dying and hitting Retry, or dying with
; instant Retry enabled.
;
; Inputs: N/A
; Outputs: N/A
; Pre: A/X/Y 8 bits
; Post: A/X/Y 8 bits
; Example: JSL retry_api_respawn_in_level
;================================================
respawn_in_level:
    jml in_level_main_dying_respawn

;================================================
; Routine to save the game, which will also save the addresses
; defined in the sram_tables.asm file.
;
; Inputs: N/A
; Outputs: N/A
; Pre: N/A
; Post: A/X/Y 8 bits, DB/X/Y preserved
; Example: JSL retry_api_save_game
;================================================
save_game:
    jsr shared_save_game
    rtl

;================================================
; Routine to remove the current level's checkpoint, meaning
; entering it again will load the main sublevel's entrance.
; Only makes sense to be called during a level gamemode.
;
; Inputs: N/A
; Outputs: N/A
; Pre: A/X/Y 8 bits
; Post: A/X/Y 8 bits, DB/X/Y preserved
; Example: JSL retry_api_reset_level_checkpoint
;================================================
reset_level_checkpoint:
    jsr shared_reset_checkpoint
    rtl

;================================================
; Routine to remove all levels checkpoints, effectively resetting
; their state as if it were a new game. If you're saving the CPs
; to SRAM, you'll need to call the save game routine afterwards to
; also reset the CPs state in SRAM.
;
; Inputs: N/A
; Outputs: N/A
; Pre: N/A
; Post: A/X/Y size preserved, DB/X/Y preserved
; Example: JSL retry_api_reset_all_checkpoints
;================================================
reset_all_checkpoints:
    ; A/X/Y 8 bits
    phx : phy : php
    sep #$30

    ; Initialize the checkpoint ram table.
    ldx #$BE
    ldy #$5F
-   tya : cmp #$25 : bcc +
    clc : adc #$DC
+   sta !ram_checkpoint,x
    lda #$00 : adc #$00 : sta !ram_checkpoint+1,x
    lda $1EA2|!addr,y : and #~$40 : sta $1EA2|!addr,y
    dex #2
    dey : bpl -

    ; Initialize respawn RAM in case it's called inside a level.
    %lda_13BF() : asl : tax
    rep #$20
    lda !ram_checkpoint,x : sta !ram_respawn

    ; Initialize "set checkpoint" handle to $FFFF.
    lda #$FFFF : sta !ram_set_checkpoint

    ; Restore X/Y/P
    plp : ply : plx
    rtl

;================================================
; Routine to configure which tiles will be used by the sprite status
; bar. You can configure three elements: item box, timer and coin
; counter. Each element needs a 16x16 sprite tile to be reserved.
; This routine can be called in each level that needs the sprite
; status bar (with UberASM level init code), or in gamemode 10 init code
; to have the same configuration in every level. You can also use both
; together: setup a default global configuration with gamemode 10 code,
; and override it with level init code for levels that need special
; configurations. Additionally, the three elements don't need to all
; be used: you can enable just 1 or 2 of them.
; Each element needs a 16 bit value that determines which 16x16 tile
; it will use and what palette to use. The lower 9 bits are the tile
; number, while the higher 3 bits are the palette (000 = palette 8,
; 001 = palette 9, ..., 111 = palette F). If an element is set to
; $0000, it won't be displayed.
;
; Inputs: A = item box, X = timer, Y = coin counter
; Outputs: N/A
; Pre: A/X/Y 16 bits
; Post: A/X/Y size preserved, DB/X/Y preserved
; Example:
;     REP #$30
;     LDA #$3080 ; Item box: palette B, tile 0x80
;     LDX #$0088 ; Timer: palette 8, tile 0x88
;     LDY #$00C2 ; Coin counter: palette 8, tile 0xC2
;     JSL retry_api_configure_sprite_status_bar
;     SEP #$30
;================================================
configure_sprite_status_bar:
if !sprite_status_bar
    sta !ram_status_bar_item_box_tile
    txa : sta !ram_status_bar_timer_tile
    tya : sta !ram_status_bar_coins_tile
endif
    rtl

;================================================
; Routine to get the current Retry type, i.e. if currently the level is
; set to have Retry prompt, instant Retry or no Retry.
; The returned value has this format:
; - $01 = Retry prompt enabled & play the vanilla death song when the player dies
; - $02 = Retry prompt enabled & play only the death sfx when the player dies
; - $03 = instant Retry enabled
; - $04 = Retry disabled
;
; Inputs: N/A
; Outputs: A = Retry type
; Pre: A 8 bits
; Post: A/X/Y size preserved, DB/X/Y preserved
; Example: JSL retry_api_get_retry_type
;================================================
get_retry_type:
    jsr shared_get_prompt_type
    rtl

;================================================
; Routine to get the address in SRAM for a specific variable.
; By "variable" it's meant any of the RAM addresses that are saved to SRAM
; specified in the sram save table. The returned address will be coherent
; with the current save file loaded when this routine is called (so, make
; sure to not call it before a save file is loaded!).
; This could be useful to read/write values in SRAM directly, for example
; if you need to update some SRAM value without the game being saved.
; Note: this will always return "variable not found" if !sram_feature = 0.
;
; Inputs: variable address to search for in ROM right after the JSL
;         This means the call should look like this:
;             JSL retry_api_get_sram_variable_address
;             dl <variable address>
; Outputs: Carry set = variable not found
;          Carry clear = variable found -> SRAM address stored in $00-$02
;            In this case the value in SRAM can be accessed indirectly with the
;            LDA/STA [$00] and LDA/STA [$00],y instructions.
; Pre: N/A
; Post: A/X/Y 8 bit and clobbered, DB preserved
; Example:
;         JSL retry_api_get_sram_variable_address
;         dl retry_ram_death_counter ; Variable to search for
;         BCS not_found
;     found:
;         LDY #$01
;         LDA #$09
;         STA [$00],y ; Set second death counter digit in SRAM to 9
;     not_found:
;         ...
;================================================
get_sram_variable_address:
if !sram_feature
    ; Use Y to read address after the routine call
    rep #$30 : ply
    phb : phk : plb
    stz $00
    ldx #$0000
.loop:
    ; Check if the current SRAM variables corresponds to the input
    lda.w sram_tables_save+0,x : cmp $0001,y : bne .next
    lda.w sram_tables_save+1,x : cmp $0002,y : bne .next
.found:
    ; If so, add the calculated offset to the save file SRAM address
    jsr sram_get_sram_addr
    clc : adc $00 : sta $00
    sep #$20
    lda.b #!sram_addr>>16 : sta $02
    ; Clear carry (address found)
    clc
    bra .return
.next:
    ; Update the SRAM offset with the current variable size
    lda.w sram_tables_save+3,x : clc : adc $00 : sta $00
    ; Go to the next SRAM variable
    txa : clc : adc #$0005
    ; If at the end of the SRAM table, end
    cmp.w #sram_tables_sram_defaults-sram_tables_save : bcs .not_found
    tax
    bra .loop
.not_found:
    ; Set carry (address not found)
    sec
.return:
    plb
    ; Make sure the code returns at the right place
    iny #3
    phy : sep #$30
else
    ; Make sure the code returns at the right place
    rep #$20
    lda $01,s : clc : adc #$0003 : sta $01,s
    ; Set carry (address not found)
    sep #$31
endif
    rtl
