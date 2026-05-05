`timescale 1ns/1ps
module reorder_tb;
    import pack::*;

    intf       intf1();
    virtual    intf    vif;
    enviroment         env;

    reorder_module DUT (
        .clk(intf1.clk),
        .rst_n(intf1.rst_n),
        .valid_data(intf1.valid_data),
        .en_op(intf1.en_op),
        .input_activations(intf1.input_activations),
        .filter_size(intf1.filter_size),
        .initial_window(intf1.initial_window),
        .load_done(intf1.load_done),
        .row_transition(intf1.row_transition),
        .available_data(intf1.available_data),
        .finished_op(intf1.finished_op),
        .request3_col(intf1.request3_col),
        .out_A(intf1.out_A),
        .out_B(intf1.out_B)
    );

    initial begin
        intf1.clk = 0;
        vif = intf1;
        env = new(vif);
        env.run();
        #5;
        $stop;
    end

    always #5 intf1.clk = ~(intf1.clk);
endmodule