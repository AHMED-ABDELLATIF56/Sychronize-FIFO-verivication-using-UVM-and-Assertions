package FIFO_sequencer_;
	import FIFO_seq_item_::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class FIFO_sequencer extends  uvm_sequencer #(FIFO_seq_item);
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_sequencer)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_sequencer", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new
	
	endclass : FIFO_sequencer
endpackage : FIFO_sequencer_