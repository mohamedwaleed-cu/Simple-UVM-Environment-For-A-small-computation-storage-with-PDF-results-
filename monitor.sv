  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "my_driver.sv"
// The monitor has a virtual interface handle with which 
// it can monitor the events happening on the interface.
// It sees new transactions and then captures information 
// into a packet and sends it to the scoreboard
// using another mailbox.
class monitor extends uvm_monitor;

  `uvm_component_utils(monitor)

  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_port  #(my_transaction) mon_analysis_port;
  virtual dut_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    mon_analysis_port = new ("mon_analysis_port", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // This task monitors the interface for a complete 
    // transaction and writes into analysis port when complete
    forever begin
      @ (posedge vif.CLK);
			//if (vif.RESET) begin
				begin
				my_transaction item = my_transaction::type_id::create("item");			
				item.adda = vif.adda;
				item.addb = vif.addb;
				item.addc = vif.addc;
				item.OP   = vif.OP;
				item.we   = vif.we;
				item.DQ   = vif.DQ;
				mon_analysis_port.write(item);
`uvm_info("MON", $sformatf("Saw address A = %0d  Saw address B = %0d  Saw address C = %0d  ", item.adda,item.addb,item.addc), UVM_LOW);
`uvm_info("MON", $sformatf("Saw OPERATION = %0d  Saw write_enable = %0d  Saw DQ = %0d  ", item.OP,item.we,item.DQ), UVM_LOW);



			end
    end
  endtask
endclass