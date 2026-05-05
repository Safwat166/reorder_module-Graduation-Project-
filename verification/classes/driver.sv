class driver;
    virtual    intf    vif;
    mailbox            seq2driv;
    transaction        trans_driv;
    event              e1;

    function new(mailbox seq2driv, virtual intf vif, event e1);
        this.seq2driv = seq2driv;
        this.vif = vif;
        this.e1 = e1;
    endfunction

    task receive_data;
        forever begin
            seq2driv.get(trans_driv);
            vif.rst_n <= trans_driv.rst_n;
            vif.driver_cb.valid_data <= trans_driv.valid_data;
            vif.driver_cb.en_op <= trans_driv.en_op;
            vif.driver_cb.input_activations <= trans_driv.input_activations;
            vif.driver_cb.filter_size <= trans_driv.filter_size;
            vif.driver_cb.initial_window <= trans_driv.initial_window;
            @(posedge vif.driver_cb);
            -> e1;
        end
    endtask
endclass