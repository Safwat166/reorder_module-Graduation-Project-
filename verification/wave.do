onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /reorder_tb/DUT/clk
add wave -noupdate /reorder_tb/DUT/rst_n
add wave -noupdate /reorder_tb/DUT/valid_data
add wave -noupdate -expand -group {input activations} /reorder_tb/DUT/input_activations
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reg_A
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reg_B
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reg_C
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reg_D
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reuse_A
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reuse_B
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reuse_C
add wave -noupdate -expand -group {intermediate registers} /reorder_tb/DUT/intermediate_reg_inst/reuse_D
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/en_op
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/valid_left_A
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/valid_left_B
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/valid_up_A
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/valid_up_B
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/valid_reuse
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/sel_C
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/sel_D
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/sel_C_D
add wave -noupdate -expand -group {control signals} -color Cyan /reorder_tb/DUT/initial_window
add wave -noupdate -expand -group Registers /reorder_tb/DUT/wire_A
add wave -noupdate -expand -group Registers /reorder_tb/DUT/wire_B
add wave -noupdate -expand -group Registers /reorder_tb/DUT/wire_C
add wave -noupdate -expand -group Registers /reorder_tb/DUT/wire_D
add wave -noupdate -expand -group {output activations} -color Gold /reorder_tb/DUT/out_A
add wave -noupdate -expand -group {output activations} -color Gold /reorder_tb/DUT/out_B
add wave -noupdate -expand -group {output activations} -color Gold /reorder_tb/DUT/load_done
add wave -noupdate -expand -group {output activations} -color Yellow /reorder_tb/DUT/request3_col
add wave -noupdate -expand -group {output activations} -color Gold /reorder_tb/DUT/available_data
add wave -noupdate -expand -group {output activations} -color Gold /reorder_tb/DUT/finished_op
add wave -noupdate -expand -group {output activations} -color Yellow /reorder_tb/DUT/row_transition
add wave -noupdate -group {track subfilters} /reorder_tb/DUT/valid_logic_inst/subfilter_ver
add wave -noupdate -group {track subfilters} /reorder_tb/DUT/valid_logic_inst/subfilter_hor
add wave -noupdate -group {track subfilters} /reorder_tb/DUT/valid_logic_inst/num_subfilter
add wave -noupdate -group {track subfilters} /reorder_tb/DUT/intermediate_reg_inst/row_transition_reg
add wave -noupdate -group {RegE input and output} /reorder_tb/DUT/shift_up_A
add wave -noupdate -group {RegE input and output} /reorder_tb/DUT/shift_up_B
add wave -noupdate -group {intermediate registers for reusing} /reorder_tb/DUT/reuse_A
add wave -noupdate -group {intermediate registers for reusing} /reorder_tb/DUT/reuse_B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {370528 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 229
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1270500 ps}
