init:
    jsl double_hit_fix_init
    rtl

main:
    jsl retry_in_level_main
    jsl double_hit_fix_main
    jsl clear_score_sprites_main
    JSL ScreenScrollingPipes_SSPMaincode
    rtl

nmi:
    jsl retry_nmi_level
    rtl
