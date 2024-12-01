; These tables determine which sprite tile and palette to use for the sprite status bar.
; Each element of the status bar needs one 16x16 tile reserved for it, but you can choose
; a different one for each level (for example, picking a tile that's unused in that level)
; if you don't want to reserve sprite space for the entire game.
; You can also disable each element individually (or all of them) by using a value of $0000 for the specific level.
; Note that these tables are ignored if !sprite_status_bar = 0 in "settings.asm".
; If you do want to enable one or more elements, specify the tile number to use as a 4 digit number:
; pick the tile in the Lunar Magic 8x8 editor, then subtract 0x400 from it (for example, tile 0x480 -> use $0080,
; tile 0x560 -> use $0160). And yes, any tile in SP1/2/3/4 can be used here.
;
; Additionally, the first digit in the number specifies the palette that will be used:
; 0 = palette 8, 1 = palette 9, etc. For example, $1080 means "use tile $80 (in SP2) with palette 9".
; It's suggested to use palette 8 for coins and timer (i.e., use 0 as the first digit) and palette B for
; the item box (i.e., use 3 as the first digit). Note that using palettes C-F will make the tiles affected
; by color math effects such as translucency and screen darkening effects.
; The default settings replace the berry, flopping fish and smiling coin tiles.
;
; NOTE: enabling the coin counter also enables the display of the Yoshi Coins collected.
; By default the Yoshi Coins are displayed with the same coin tile as the coin counter, but you can
; edit it to a different tile by editing the "gfx/coin.bin" file (the first tile is used for the coin counter,
; the second for the Yoshi Coins display).

; default settings for the baserom
!ITEMB = $3080 ; with item_box table
!TIMER = $0020 ; use with timer table
!COINS = $0022 ; use with coins table

; if you would like to change an individual level's setting to be different from these pre-set values,
; you can do so in the table below following the instructions above

; don't change
!__off = $0000 ; flag to not display any status bar items
!NEVER = $0000 ; a flag to ensure it's always disabled on title level, don't remove it from the tables below

item_box:
   ;      0      1      2      3      4      5      6      7      8      9      A      B      C      D      E      F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 000-00F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 010-01F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 020-02F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 030-03F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 040-04F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 050-05F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 060-06F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 070-07F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 080-08F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 090-09F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0A0-0AF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0B0-0BF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!NEVER,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0C0-0CF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0D0-0DF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0E0-0EF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0F0-0FF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 100-10F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 110-11F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 120-12F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!ITEMB,!__off,!__off,!__off,!__off ; 130-13F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 140-14F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 150-15F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 160-16F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 170-17F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 180-18F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 190-19F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1A0-1AF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1B0-1BF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1C0-1CF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1D0-1DF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1E0-1EF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1F0-1FF

timer:
   ;      0      1      2      3      4      5      6      7      8      9      A      B      C      D      E      F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 000-00F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 010-01F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 020-02F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 030-03F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 040-04F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 050-05F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 060-06F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 070-07F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 080-08F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 090-09F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0A0-0AF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0B0-0BF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!NEVER,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0C0-0CF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0D0-0DF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0E0-0EF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0F0-0FF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 100-10F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 110-11F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 120-12F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!TIMER,!__off,!__off,!__off,!__off ; 130-13F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 140-14F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 150-15F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 160-16F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 170-17F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 180-18F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 190-19F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1A0-1AF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1B0-1BF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1C0-1CF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1D0-1DF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1E0-1EF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1F0-1FF

coins:
   ;      0      1      2      3      4      5      6      7      8      9      A      B      C      D      E      F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 000-00F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 010-01F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 020-02F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 030-03F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 040-04F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 050-05F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 060-06F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 070-07F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 080-08F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 090-09F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0A0-0AF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0B0-0BF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!NEVER,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0C0-0CF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0D0-0DF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0E0-0EF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 0F0-0FF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 100-10F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 110-11F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 120-12F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!COINS,!__off,!__off,!__off,!__off ; 130-13F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 140-14F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 150-15F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 160-16F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 170-17F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 180-18F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 190-19F
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1A0-1AF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1B0-1BF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1C0-1CF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1D0-1DF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1E0-1EF
    dw !__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off,!__off ; 1F0-1FF
