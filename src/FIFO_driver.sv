package FIFO_driver_;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_config_obj_::*;
	import FIFO_seq_item_::*;

	class FIFO_driver extends uvm_driver #(FIFO_seq_item);
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		virtual FIFO_if FIFO_driver_vif;
		FIFO_seq_item seq_item;
		FIFO_config_obj co;
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_driver)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_driver", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		// Build phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
		endfunction

		// Run phase
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				seq_item_port.get_next_item(seq_item);
				FIFO_driver_vif.rst_n = seq_item.rst_n;
				FIFO_driver_vif.data_in = seq_item.data_in;
				FIFO_driver_vif.rd_en = seq_item.rd_en;
				FIFO_driver_vif.wr_en = seq_item.wr_en;
				@(negedge FIFO_driver_vif.clk);
				seq_item_port.item_done();
			end
		endtask 
	endclass : FIFO_driver
endpackage : FIFO_driver_