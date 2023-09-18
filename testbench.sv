
//This is a basic UVM  testbench.



`include "uvm_macros.svh"
`include "my_testbench_pkg.sv"

// The top module that contains the DUT and interface.
// This module starts the test.
module top;
  import uvm_pkg::*;
  import my_testbench_pkg::*;
  
  // Instantiate the interface
  dut_if dut_if1();
  
  // Instantiate the DUT and connect it to the interface
  dut dut1(.dif(dut_if1));
  
  // Clock generator
  initial begin
    dut_if1.CLK = 0;
    forever #5 dut_if1.CLK = ~dut_if1.CLK;
  end

	//initialize memory with preloading file
   initial begin
	   #10 $readmemh("input_file",dut_if1.MEMORY);
           end
  
  initial begin
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vif", dut_if1);
    // Start the test
    run_test("my_test");
  end
  
//// writing final output of the memory in a file
initial begin
int fh;
#80     fh=$fopen("output_file","w+");
	for (int i=0;i<=15;i++)
	begin
		$fdisplay(fh,"%0d",dut_if1.MEMORY[i]);
		
	end

$fclose(fh);
end


  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule

