onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datap/clk
add wave -noupdate /tb_datap/wren
add wave -noupdate /tb_datap/writeAddr
add wave -noupdate /tb_datap/RFaddr
add wave -noupdate /tb_datap/IRin
add wave -noupdate /tb_datap/PCin
add wave -noupdate /tb_datap/PCsel
add wave -noupdate /tb_datap/imm1_in
add wave -noupdate /tb_datap/imm2_in
add wave -noupdate /tb_datap/OPC
add wave -noupdate /tb_datap/Ain
add wave -noupdate /tb_datap/Cin
add wave -noupdate /tb_datap/rst
add wave -noupdate /tb_datap/RFin
add wave -noupdate /tb_datap/RFout
add wave -noupdate /tb_datap/Mem_out
add wave -noupdate /tb_datap/Mem_in
add wave -noupdate /tb_datap/Mem_wr
add wave -noupdate /tb_datap/Cout
add wave -noupdate /tb_datap/Mem_tb
add wave -noupdate /tb_datap/readAddr_tb
add wave -noupdate /tb_datap/writeAddr_tb
add wave -noupdate /tb_datap/TBactive
add wave -noupdate /tb_datap/Cflag
add wave -noupdate /tb_datap/Zflag
add wave -noupdate /tb_datap/Nflag
add wave -noupdate /tb_datap/st
add wave -noupdate /tb_datap/ld
add wave -noupdate /tb_datap/mov
add wave -noupdate /tb_datap/done
add wave -noupdate /tb_datap/add
add wave -noupdate /tb_datap/sub
add wave -noupdate /tb_datap/andf
add wave -noupdate /tb_datap/orf
add wave -noupdate /tb_datap/xorf
add wave -noupdate /tb_datap/jmp
add wave -noupdate /tb_datap/jc
add wave -noupdate /tb_datap/jnc
add wave -noupdate -radix hexadecimal /tb_datap/PC
add wave -noupdate -radix hexadecimal /tb_datap/IR
add wave -noupdate -radix hexadecimal /tb_datap/dataIn
add wave -noupdate -radix hexadecimal /tb_datap/dataIn2
add wave -noupdate -radix hexadecimal /tb_datap/message
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4240280 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {105973 ps} {2153973 ps}
