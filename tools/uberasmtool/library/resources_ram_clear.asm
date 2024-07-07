incsrc "../../../shared/freeram.asm"

; Bytes to clear in each bank
!Bytes = 16

init:
    ldx #!Bytes-1
    lda #$00
    -
    sta !objectool_level_flags_bank,x
    sta !toggles_freeram_bank,x
    sta !scroll_pipes_freeram_bank,x
    dex
    bpl -
    rtl
