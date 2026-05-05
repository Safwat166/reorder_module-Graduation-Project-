class transaction;
    bit                   rst_n;
    bit                   valid_data;
    bit                   en_op;
    bit      [127:0]      input_activations;
    bit      [23:0]       new_three_col_C;
    bit      [23:0]       new_three_col_D;
    bit      [7:0]        filter_size;
    bit                   initial_window;
endclass
