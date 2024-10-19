package FIFO_env_;
import FIFO_driver_::*;
import uvm_pkg::*;
import FIFO_sequencer_::*;
import FIFO_coverage_::*;
import FIFO_score_board_::*;
import FIFO_agent_::*;
`include "uvm_macros.svh"
	
	class FIFO_env extends  uvm_env;
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		FIFO_agent agt;
		FIFO_coverage cov;
		FIFO_score_board sb;
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_env)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_env", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		// Build phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov = FIFO_coverage::type_id::create("cov",this);
			sb = FIFO_score_board::type_id::create("sb",this);
			agt = FIFO_agent::type_id::create("agt",this);
		endfunction 

		// Connect phase
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			agt.agt_ap.connect(cov.cov_ex);
			agt.agt_ap.connect(sb.sb_ex);
		endfunction 	
	endclass : FIFO_env

endpackage : FIFO_env_