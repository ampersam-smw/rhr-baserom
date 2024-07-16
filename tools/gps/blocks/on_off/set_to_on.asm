; act as 25
db $42

JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch
JMP Return : JMP Switch : JMP Switch : JMP Switch : JMP Switch

Switch:
    LDA $14AF|!addr                 ;\ check ON/OFF state
    BEQ Return                      ;/ ...skip if ON
    STZ $14AF|!addr                 ;> set switch to on
    LDA #$0B :  STA $1DF9|!addr     ;> play switch sound
Return:
    RTL

print "Sets the switch state to ON when anything (incl. dead sprites) touches it."