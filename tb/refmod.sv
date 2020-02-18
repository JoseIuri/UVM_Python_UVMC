import uvmc_pkg::*;
class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    tr_in tr_i;
    tr_out tr_o;
    integer a, b;
    
    uvm_analysis_imp #(tr_in, refmod) in;
    uvm_analysis_export #(tr_out) out;

    uvm_put_port #(tr_in) in_rm;
    uvm_get_port #(tr_out) out_rm;

    uvm_tlm_fifo #(tr_in) source_refmod;
    uvm_tlm_fifo #(tr_out) refmod_sink;


    event begin_refmodtask;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);

        in_rm = new("in", this);
        out_rm = new("out", this);

        source_refmod = new("source_refmod", null, 1);
        refmod_sink  = new("refmod_sink", null, 1);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_o = tr_out::type_id::create("tr_o", this);
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        out_rm.connect( source_refmod.put_export );
        in_rm.connect( refmod_sink.get_export );
        uvmc_tlm #(tr_in)::connect(source_refmod.get_export,"refmod_i.in");
        uvmc_tlm #(tr_out)::connect(refmod_sink.put_export,"refmod_i.out");
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            @begin_refmodtask;
            in_rm.put(tr_i);
            #1
            out_rm.get(tr_o);
            out.write(tr_o);
        end
    endtask: run_phase

    virtual function write (tr_in t);
        tr_i = tr_in::type_id::create("tr", this);
        tr_i.copy(t);
        -> begin_refmodtask;
    endfunction


endclass: refmod