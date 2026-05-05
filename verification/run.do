vlog package.sv interface.sv reorder_tb.sv ../*.v
vopt reorder_tb -o safwat +acc
vsim safwat

# Add signals with compact -width to avoid line wrapping
add list -nodelta \
         -label "clock"             -width 18  /reorder_tb/DUT/clk \
         -label "reset_neg"         -width 18  /reorder_tb/DUT/rst_n \
         -label "en_op"             -width 18  /reorder_tb/DUT/en_op \
         -label "valid_data"        -width 18  /reorder_tb/DUT/valid_data \
         -label "input_activations" -width 43  /reorder_tb/DUT/input_activations \
         -label "filter_size"       -width 25  /reorder_tb/DUT/filter_size \
         -label "initial_window"    -width 15  /reorder_tb/DUT/initial_window \
         -label "out_A"             -width 38  /reorder_tb/DUT/out_A \
         -label "out_B"             -width 38  /reorder_tb/DUT/out_B \
         -label "registerA"         -width 38  /reorder_tb/DUT/wire_A \
         -label "registerB"         -width 38  /reorder_tb/DUT/wire_B \
         -label "load_done"         -width 15  /reorder_tb/DUT/load_done \
         -label "row_transition"    -width 20  /reorder_tb/DUT/row_transition \
         -label "available_data"    -width 20  /reorder_tb/DUT/available_data \
         -label "finished_op"       -width 18  /reorder_tb/DUT/finished_op

do wave.do
run -all

# Now the list file will have all headers on a single line
write list reorder_output.lst
