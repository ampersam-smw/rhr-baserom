db $42
JMP Mario : JMP Mario : JMP Mario : JMP End : JMP End : JMP End : JMP End
JMP End : JMP End : JMP End

Mario:
	STZ $1411|!addr
End:
	RTL

print "Disable horizontal camera scroll."