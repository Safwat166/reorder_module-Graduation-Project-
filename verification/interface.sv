interface intf;
    logic          clk;
    logic          rst_n;
    logic          valid_data;
    logic          en_op;
    logic [127:0]  input_activations;
    logic [7:0]    filter_size;
    logic          initial_window;
    logic          load_done;
    logic          row_transition;
    logic          available_data;
    logic          finished_op;
    logic          request3_col;
    logic [111:0]  out_A;
    logic [111:0]  out_B;

/*--------------------------------------------------------------------
-- Driver Clocking Block to avoid racing between driver and DUT
--------------------------------------------------------------------*/
    clocking driver_cb @(posedge clk);
        default   input    #1step   output     #1step;
            output        clk;
            output        rst_n;
            output        valid_data;
            output        en_op;
            output        input_activations;
            output        filter_size;
            output        initial_window;
    endclocking
endinterface