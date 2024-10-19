package FIFO_reset_seq_;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_::*;

	class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		FIFO_seq_item seq_item;
	
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_reset_seq)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_reset_seq");
			super.new(name);
		endfunction : new

		task body();
			seq_item = FIFO_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n = 0;
			finish_item(seq_item);
		endtask : body
	
	endclass : FIFO_reset_seq
endpackage : FIFO_reset_seq_