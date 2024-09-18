onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/Clkin
add wave -noupdate /top_tb/PORT_SW
add wave -noupdate /top_tb/PORT_KEYS
add wave -noupdate /top_tb/reset
add wave -noupdate /top_tb/HEX01_OUT
add wave -noupdate /top_tb/HEX23_OUT
add wave -noupdate /top_tb/HEX45_OUT
add wave -noupdate /top_tb/LEDR
add wave -noupdate /top_tb/PWMout
add wave -noupdate /top_tb/Instruction_out
add wave -noupdate /top_tb/adress_from_cpu_o
add wave -noupdate /top_tb/DATA_from_cpu_o
add wave -noupdate /top_tb/DATA_from_peripherials_o
add wave -noupdate /top_tb/IFG_oo
add wave -noupdate /top_tb/irq_clear_o
add wave -noupdate /top_tb/eint_o
add wave -noupdate /top_tb/jal_address_out
add wave -noupdate /top_tb/q
add wave -noupdate /top_tb/Memwrite_out_o
add wave -noupdate /top_tb/Memread_out_o
add wave -noupdate /top_tb/GIE_o
add wave -noupdate /top_tb/INTR_o
add wave -noupdate /top_tb/INTA_o
add wave -noupdate /top_tb/data_from_buss_enable_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2638665281 ps} 0}
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
WaveRestoreZoom {0 ps} {262865600 ps}
