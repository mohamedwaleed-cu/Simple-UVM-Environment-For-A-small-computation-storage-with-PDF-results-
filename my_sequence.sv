  import uvm_pkg::*;
`include "uvm_macros.svh"
class my_transaction extends uvm_sequence_item;

  `uvm_object_utils(my_transaction)
  parameter add_width=16;
  rand bit we;
  rand int OP;
  rand int adda;
  rand int addb;
  rand int addc;
  rand int DQ;	
  

  constraint c_OP {  OP >= 0; OP < 3; }
  constraint c_adda {  adda >= 0; adda < add_width; }
  constraint c_addb { addb >= 0; addb < add_width; }
  constraint c_addc { addc >= 0; addc < add_width; }
  constraint c_DQ { DQ >= 0; DQ < 256;}
  constraint c_we { we>=0;  we<2; }

  virtual function string convert2str();
    return $sformatf("adda=%0d,addb=%0d,addc=%0d,OP=%0d,we=%0d, DQ=%0d", adda,addb,addc,OP,we,DQ);
  endfunction

  function new (string name = "");
    super.new(name);
  endfunction

endclass: my_transaction

class my_sequence extends uvm_sequence#(my_transaction);

  `uvm_object_utils(my_sequence)

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
    repeat(8) begin
      req = my_transaction::type_id::create("req");
      start_item(req);
      if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
      end


	

	finish_item(req);
     end	

  endtask: body

endclass: my_sequence

