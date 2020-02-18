typedef virtual input_if input_vif;

class driver_in extends uvm_driver #(tr_in);
    `uvm_component_utils(driver_in)
    input_vif vif;
    event begin_record, end_record;

    function new(string name = "driver_in", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(input_vif)::get(this, "", "vif", vif));
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive(phase);
            record_tr();
        join
    endtask

    virtual protected task reset_signals();
        wait (vif.rst === 1);
        forever begin
            vif.valid <= '0;
            vif.A <= 'x;
            vif.B <= 'x;
            @(posedge vif.rst);
        end
    endtask

    virtual protected task get_and_drive(uvm_phase phase);
        wait(vif.rst === 1);
        @(negedge vif.rst);
        @(posedge vif.clk);
        
        forever begin
            seq_item_port.try_next_item(req);
            -> begin_record;
            drive_transfer(req);
            seq_item_port.item_done();
        end
    endtask

    virtual protected task drive_transfer(tr_in tr);
        vif.A = tr.A;
        vif.B = tr.B;
        vif.valid = 1;

        @(posedge vif.clk)
        
        while(!vif.ready)
            @(posedge vif.clk);
        
        -> end_record;
        @(posedge vif.clk); //hold time
        vif.valid = 0;
        @(posedge vif.clk);
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(req, "driver_in");
            @(end_record);
            end_tr(req);
        end
    endtask
endclass