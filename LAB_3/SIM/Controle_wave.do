onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ctrl/rst
add wave -noupdate /tb_ctrl/ena
add wave -noupdate /tb_ctrl/clk
add wave -noupdate /tb_ctrl/RFaddr
add wave -noupdate /tb_ctrl/IRin
add wave -noupdate /tb_ctrl/PCin
add wave -noupdate /tb_ctrl/PCsel
add wave -noupdate /tb_ctrl/imm1_in
add wave -noupdate /tb_ctrl/imm2_in
add wave -noupdate /tb_ctrl/OPC
add wave -noupdate /tb_ctrl/Ain
add wave -noupdate /tb_ctrl/Cin
add wave -noupdate /tb_ctrl/RFin
add wave -noupdate /tb_ctrl/RFout
add wave -noupdate /tb_ctrl/Cout
add wave -noupdate /tb_ctrl/Mem_wt
add wave -noupdate /tb_ctrl/Mem_out
add wave -noupdate /tb_ctrl/Mem_in
add wave -noupdate /tb_ctrl/Cflag
add wave -noupdate /tb_ctrl/Zflag
add wave -noupdate /tb_ctrl/Nflag
add wave -noupdate /tb_ctrl/st
add wave -noupdate /tb_ctrl/ld
add wave -noupdate /tb_ctrl/mov
add wave -noupdate /tb_ctrl/done
add wave -noupdate /tb_ctrl/add
add wave -noupdate /tb_ctrl/sub
add wave -noupdate /tb_ctrl/andf
add wave -noupdate /tb_ctrl/orf
add wave -noupdate /tb_ctrl/xorf
add wave -noupdate /tb_ctrl/jmp
add wave -noupdate /tb_ctrl/jc
add wave -noupdate /tb_ctrl/jnc
add wave -noupdate /tb_ctrl/Message
add wave -noupdate /tb_ctrl/Message2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5144100 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 229
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2719978 ps}
