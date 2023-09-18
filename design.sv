`include "uvm_macros.svh"
//`include "testbench.sv"
import uvm_pkg::*;
//import my_testbench_pkg::*;

interface dut_if;
  parameter ADDRESS_WIDTH = 16;
  parameter DATA_WIDTH=16;
  logic CLK, RESET;
  logic [1:0] OP;
  logic [ADDRESS_WIDTH-1:0] adda;
  logic [ADDRESS_WIDTH-1:0] addb;
  logic [ADDRESS_WIDTH-1:0] addc;
  bit we;	
  reg [DATA_WIDTH-1:0] MEMORY [ADDRESS_WIDTH-1:0];
  logic [DATA_WIDTH-1:0] DQ;	
endinterface



module dut (dut_if dif);


 reg [dif.DATA_WIDTH-1:0] OUT;
 //reg out_en;

 
 always@(posedge dif.CLK)
 begin
    if(!dif.RESET)
    begin
          for (integer i = 0; i < 16 ; i = i + 1)
            begin
              dif.MEMORY[i] <= 0;
            end
    end
    else if(dif.we)
    begin
        if(dif.OP == 2'b00)
	begin
        dif.MEMORY[dif.addc]<= dif.DQ;
	end
        else if(dif.OP == 2'b01)
	begin
        dif.MEMORY[dif.addc]=dif.MEMORY[dif.adda]+ dif.MEMORY[dif.addb];
	end
        else if(dif.OP == 2'b10)
	begin
        dif.MEMORY[dif.addc]= dif.MEMORY[dif.adda]- dif.MEMORY[dif.addb];    
	end           
    end
    else
        begin
        OUT <= dif.MEMORY[dif.adda];
        end	
 end
 assign dif.DQ = dif.we ? OUT : 16'h0 ;   
endmodule

