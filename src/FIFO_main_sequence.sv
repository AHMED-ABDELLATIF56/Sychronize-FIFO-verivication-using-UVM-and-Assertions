package FIFO_main_sequence_;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_::*;

	class FIFO_main_sequence extends  uvm_sequence #(FIFO_seq_item);	
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		FIFO_seq_item seq_item;
	
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_main_sequence)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_main_sequence");
			super.new(name);
		endfunction : new

		task body();
			// Write only
			repeat (1000) begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.wr_en = 1;
				seq_item.rd_en= 0;
				seq_item.rst_n = $random();
				seq_item.data_in = $random();
				finish_item(seq_item);
			end
			// Read only
			repeat (1000) begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.wr_en = 0;
				seq_item.rd_en= 1;
				seq_item.rst_n = $random();
				seq_item.data_in = $random();
				finish_item(seq_item);
			end
			// Write - Read 
			repeat (1000) begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body

	endclass : FIFO_main_sequence
endpackage : FIFO_main_sequence_