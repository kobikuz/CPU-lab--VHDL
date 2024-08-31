onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_pwm_tb/Y_i
add wave -noupdate /top_pwm_tb/X_i
add wave -noupdate /top_pwm_tb/ALUout_o
add wave -noupdate /top_pwm_tb/ALUFN_i
add wave -noupdate /top_pwm_tb/clk
add wave -noupdate /top_pwm_tb/enable
add wave -noupdate /top_pwm_tb/reset
add wave -noupdate /top_pwm_tb/pwm_o
add wave -noupdate /top_pwm_tb/curr_o
add wave -noupdate /top_pwm_tb/Nflag_o
add wave -noupdate /top_pwm_tb/Cflag_o
add wave -noupdate /top_pwm_tb/Zflag_o
add wave -noupdate /top_pwm_tb/Vflag_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4799241 ps} 0}
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
WaveRestoreZoom {3388422 ps} {7410694 ps}
