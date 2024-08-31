onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_top/clk
add wave -noupdate -radix hexadecimal /tb_top/rst
add wave -noupdate -radix hexadecimal /tb_top/ena
add wave -noupdate -radix hexadecimal /tb_top/Done
add wave -noupdate -radix hexadecimal /tb_top/TB_active
add wave -noupdate -radix hexadecimal /tb_top/TB_ITCM_wren
add wave -noupdate -radix hexadecimal /tb_top/TB_DTCM_wren
add wave -noupdate -radix hexadecimal /tb_top/TB_ITCM_W_Addr
add wave -noupdate -radix hexadecimal /tb_top/TB_DTCM_W_Addr
add wave -noupdate -radix hexadecimal /tb_top/TB_DTCM_R_Addr
add wave -noupdate -radix hexadecimal /tb_top/TB_ITCM_in
add wave -noupdate -radix hexadecimal /tb_top/TB_DTCM_in
add wave -noupdate -radix hexadecimal /tb_top/TB_DTCM_out
add wave -noupdate -radix hexadecimal /tb_top/PC
add wave -noupdate -radix hexadecimal /tb_top/IR
add wave -noupdate -radix hexadecimal /tb_top/Message
add wave -noupdate -radix hexadecimal /tb_top/busIO
add wave -noupdate -radix hexadecimal /tb_top/R1
add wave -noupdate -radix hexadecimal /tb_top/R2
add wave -noupdate -radix hexadecimal /tb_top/R3
add wave -noupdate -radix hexadecimal /tb_top/R4
add wave -noupdate -radix hexadecimal /tb_top/R5
add wave -noupdate -radix hexadecimal /tb_top/R6
add wave -noupdate -radix hexadecimal /tb_top/R7
add wave -noupdate -radix hexadecimal /tb_top/R8
add wave -noupdate -radix hexadecimal /tb_top/R9
add wave -noupdate -radix hexadecimal /tb_top/R10
add wave -noupdate -radix hexadecimal /tb_top/R11
add wave -noupdate -radix hexadecimal /tb_top/R12
add wave -noupdate -radix hexadecimal /tb_top/R13
add wave -noupdate -radix hexadecimal /tb_top/R14
add wave -noupdate -radix hexadecimal /tb_top/R15
add wave -noupdate -radix hexadecimal /tb_top/Cflag
add wave -noupdate -radix hexadecimal /tb_top/Nflag
add wave -noupdate -radix hexadecimal /tb_top/Zflag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12417246 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
configure wave -valuecolwidth 134
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
WaveRestoreZoom {12387844 ps} {12566898 ps}
