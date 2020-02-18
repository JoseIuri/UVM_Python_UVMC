//Top
module top;

  import uvm_pkg::*;
  import my_pkg::*;
  logic clk;
  logic rst;
  
  initial begin
    clk = 0;
    rst = 1;
    #22 rst = 0;
    
  end
  
  always #5 clk = !clk;
  
  logic [1:0] state;
  
  input_if in(clk, rst);
  output_if out(clk, rst);
  
  adder sum(in, out, state);

  initial begin
    `ifdef XCELIUM
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif
    
    uvm_config_db#(input_vif)::set(uvm_root::get(), "*.env_h.mst.*", "vif", in);
    uvm_config_db#(output_vif)::set(uvm_root::get(), "*.env_h.slv.*",  "vif", out);
    
    run_test("simple_test");
  end
endmodule