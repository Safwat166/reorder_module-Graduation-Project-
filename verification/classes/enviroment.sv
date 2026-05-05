class enviroment;
    sequencer     seq;
    driver        driv;
    // monitor       mon;
    // scoreboard    scr;
    mailbox       seq2driv;
    // mailbox       mon2scr;
    event         e1;
    // event         e2;

    function new(virtual intf vif);
        seq2driv = new();
        // mon2scr = new();
        seq = new(seq2driv, e1);
        driv = new(seq2driv, vif, e1);
        // mon  = new(mon2scr, vif, e2);
        // scr  = new(mon2scr, e2);
    endfunction

    task run();
        fork
            seq.input_values();
            driv.receive_data();
            // mon.sample_out();
            // scr.receive_out();
        join_any
    endtask
endclass