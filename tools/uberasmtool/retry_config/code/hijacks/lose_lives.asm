pushpc

; Enable/disable life loss on death depending on the setting and table.
org $00D0D8
    jml lose_lives
    nop

pullpc

lose_lives:
if not(!infinite_lives)
    ; Check if we need to decrement lives.
    jsr shared_get_bitwise_mask
    and.l tables_lose_lives,x : beq .normal

    ; If yes and lives at 0, go to game over.
    lda $0DBE|!addr : beq .game_over

    ; Otherwise, decrement them if Retry is disabled.
    jsr shared_get_prompt_type
    cmp #$04 : bne .normal
    dec $0DBE|!addr
    bpl .normal
.game_over:
    jml $00D0DD|!bank
.normal:
endif
    jml $00D0E6|!bank
