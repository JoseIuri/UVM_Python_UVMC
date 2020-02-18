class env extends uvm_env;
    agent_in    mst;
    agent_out   slv;
    scoreboard  scb;
    coverage    cov;

    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        // to_refmod = new("to_refmod", this); 
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mst = agent_in::type_id::create("mst", this);
        slv = agent_out::type_id::create("slv", this);
        scb = scoreboard::type_id::create("scb", this);
        cov = coverage::type_id::create("cov", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect MST to FIFO
        mst.item_ref_port.connect(scb.ap_rfm);
        slv.item_collected_port.connect(scb.ap_comp);

        mst.item_ref_port.connect(cov.req_port);
        slv.item_collected_port.connect(cov.resp_port);
        
    endfunction
endclass