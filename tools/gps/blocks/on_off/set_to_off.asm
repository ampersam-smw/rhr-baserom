; act as 25
db $42

JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch
JMP Return : JMP Switch : JMP Switch : JMP Switch : JMP Switch

Switch:
    LDA $14AF|!addr                 ;\ check ON/OFF state
    BNE Return                      ;/ ...skip if OFF
    LDA #$01 : STA $14AF|!addr      ;> set switch to off
    LDA #$0B : STA $1DF9|!addr      ;> play switch sound
Return:
    RTL

print "Sets the switch state to OFF when anything (incl. dead sprites) touches it."