class sequencer;
    transaction trans_seq;
    mailbox     seq2driv;
    event       e1;
    
    parameter bit [127:0] DIRECTED_IN = { 
    8'd0, 8'd1, 8'd2, 8'd3,
    8'd4, 8'd5, 8'd6, 8'd7,
    8'd8, 8'd9, 8'd10, 8'd11,
    8'd12, 8'd13, 8'd14, 8'd15
    };

    parameter bit [127:0] DIRECTED_IN1 = { 
    8'd1, 8'd2, 8'd3, 8'd4,
    8'd5, 8'd6, 8'd7, 8'd8,
    8'd9, 8'd10, 8'd11, 8'd12,
    8'd13, 8'd14, 8'd15, 8'd16
    };

    /*---------------------------------------------------
    -- constructor
    ---------------------------------------------------*/
    function new(mailbox    seq2driv ,event    e1);
        this.seq2driv = seq2driv;
        this.e1 = e1;
        trans_seq = new();
    endfunction

    /*---------------------------------------------------
    -- sequences
    ---------------------------------------------------*/
    task input_values;
    
        // reset the design
        reset();

        // filter size 3x3
        // trans_seq.initial_window = 1;
        // seq2driv.put(trans_seq);
        // @(e1);
        // trans_seq.initial_window = 0;
        // seq2driv.put(trans_seq);
        // @(e1);
        // loading_state(DIRECTED_IN, 8'd3);
        // operation_state_3();
        // loading_state(DIRECTED_IN1, 8'd3);
        // operation_state_3();
        // trans_seq.initial_window = 1;
        // seq2driv.put(trans_seq);
        // @(e1);
        // trans_seq.initial_window = 0;
        // seq2driv.put(trans_seq);
        // @(e1);
        // loading_state(DIRECTED_IN, 8'd3);
        // operation_state_3();


        // filter size 6x6
        // loading_state(DIRECTED_IN1, 8'd6);
        // operation_state(DIRECTED_IN ,8'd6);
        // operation_state_3();
        // seq2driv.put(trans_seq);
        // @(e1);
        // loading_state(DIRECTED_IN, 8'd6);
        // operation_state(DIRECTED_IN1, 8'd6);
        // operation_state_3();

        // filter size 9x9
        loading_state(DIRECTED_IN1, 8'd9);
        operation_state(DIRECTED_IN ,8'd9);
        operation_state_3();
        operation_state_3();
        seq2driv.put(trans_seq);
        @(e1);
        loading_state(DIRECTED_IN, 8'd9);
        operation_state(DIRECTED_IN1 ,8'd9);
        operation_state_3();
        operation_state_3();
        seq2driv.put(trans_seq);
        @(e1);
        loading_state(DIRECTED_IN1, 8'd9);
        operation_state(DIRECTED_IN ,8'd9);
        operation_state_3();
        operation_state_3();
    endtask : input_values

    /*---------------------------------------------------
    -- reset task
    ---------------------------------------------------*/
    task reset();
        trans_seq.rst_n = 1'b0;
        seq2driv.put(trans_seq);
        @(e1);
        trans_seq.rst_n = 1'b1;
        seq2driv.put(trans_seq);
        @(e1);
    endtask : reset

    /*---------------------------------------------------
    -- loading state task
    ---------------------------------------------------*/
    task loading_state(input bit [127:0] SEQ, input bit [7:0] size);
        for(int i=1; i<5; i++) begin
            trans_seq.filter_size = size;
            trans_seq.input_activations=SEQ*i;
            trans_seq.valid_data = 1'b1;
            seq2driv.put(trans_seq);
            @(e1);
        end

        // delay waiting for enable operation signal
        for(int i=0; i<2; i++) begin
            trans_seq.valid_data = 0;
            seq2driv.put(trans_seq);
            @(e1);
        end
    endtask : loading_state

    /*---------------------------------------------------
    -- operation state in case filter 3*3 task
    -- or for last subfilter
    ---------------------------------------------------*/
    task operation_state_3();
        // starting operation state
        for(int i=0; i<10; i++) begin
            trans_seq.en_op = 1;
            seq2driv.put(trans_seq);
            @(e1);
        end
        trans_seq.en_op = 0;
        seq2driv.put(trans_seq);
        @(e1);
    endtask : operation_state_3

    /*---------------------------------------------------
    -- operation state in case filter > 3*3 task
    ---------------------------------------------------*/
    task operation_state(input bit [127:0] reuse_window, input bit [7:0] size);
        for(int i=0; i<3; i++) begin
            trans_seq.en_op = 1;
            seq2driv.put(trans_seq);
            @(e1);
        end
        loading_state(reuse_window ,size);
        trans_seq.en_op = 1;
        seq2driv.put(trans_seq);
        @(e1);
        trans_seq.en_op = 0;
        seq2driv.put(trans_seq);
        @(e1);
    endtask : operation_state

endclass