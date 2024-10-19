package FIFO_monitor_;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_::*;

	class FIFO_monitor extends  uvm_monitor;
	
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		virtual FIFO_if FIFO_vif;
		FIFO_seq_item seq_item;
		uvm_analysis_port #(FIFO_seq_item) mon_ap;
	
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_monitor)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_monitor", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		// Build phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new("mon_ap",this);
		endfunction 

		// Run phase
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				seq_item.rst_n = FIFO_vif.rst_n;
				seq_item.wr_en = FIFO_vif.wr_en;
				seq_item.rd_en = FIFO_vif.rd_en;
				seq_item.data_in = FIFO_vif.data_in;
				seq_item.wr_ack = FIFO_vif.wr_ack;
				seq_item.overflow = FIFO_vif.overflow;
				seq_item.underflow = FIFO_vif.underflow;
				seq_item.almostfull = FIFO_vif.almostfull;
				seq_item.almostempty = FIFO_vif.almostempty;
				seq_item.data_out = FIFO_vif.data_out;
				seq_item.full = FIFO_vif.full;
				seq_item.empty = FIFO_vif.empty;
				@(negedge FIFO_vif.clk);
				mon_ap.write(seq_item);
				`uvm_info("run phase",seq_item.convert2string(),UVM_HIGH)
			end
		endtask  
	
	endclass : FIFO_monitor
endpackage : FIFO_monitor_