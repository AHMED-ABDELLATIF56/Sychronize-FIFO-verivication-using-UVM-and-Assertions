package FIFO_coverage_;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_::*;
import shared_package::*;

	class FIFO_coverage extends uvm_component;
	
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		FIFO_seq_item seq_item;
		uvm_analysis_export #(FIFO_seq_item) cov_ex;
		uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
	
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_coverage)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/

		// Cover groups
		covergroup cg;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.wr_ack;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.full;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.empty;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.almostfull;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.almostempty;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.overflow;
			cross seq_item.wr_en , seq_item.rd_en , seq_item.underflow;	
		endgroup : cg

		// Constructor
		function new(string name = "FIFO_coverage", uvm_component parent=null);
			super.new(name, parent);
			cg = new;
		endfunction : new

		// Build phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			seq_item = FIFO_seq_item::type_id::create("seq_item");
			cov_ex = new("cov_ex",this);
			cov_fifo = new("cov_fifo",this);
		endfunction

		// Connect phase
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_ex.connect(cov_fifo.analysis_export);
		endfunction 

		// Run phase
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item);
				cg.sample();				
			end
		endtask 
	
	endclass : FIFO_coverage
endpackage : FIFO_coverage_