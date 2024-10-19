package FIFO_test_;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_env_::*;
import FIFO_config_obj_::*;
import FIFO_main_sequence_::*;
import FIFO_reset_seq_::*;
import FIFO_agent_::*;
import FIFO_seq_item_::*;

	class FIFO_test extends  uvm_test;
	
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		FIFO_env env;
		FIFO_config_obj FIFO_config_obj_test;
		FIFO_main_sequence main_seq;
		FIFO_reset_seq rst_seq;
		FIFO_agent agt;
	
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_test)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_test", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = FIFO_env::type_id::create("env",this);
			agt = FIFO_agent::type_id::create("agt",this);
			FIFO_config_obj_test = FIFO_config_obj::type_id::create("FIFO_config_obj_test");
			rst_seq = FIFO_reset_seq::type_id::create("rst_seq");
			main_seq = FIFO_main_sequence::type_id::create("main_seq");

			if (!uvm_config_db#(virtual FIFO_if)::get(this, "", "FIFO_if",FIFO_config_obj_test.FIFO_config_vif )) begin
				`uvm_fatal("build_phase","test can not get the interface")
			end
			uvm_config_db#(FIFO_config_obj)::set(this, "*", "FIFO_vif_CO",FIFO_config_obj_test );
		endfunction 

		// Run phase
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info("run_phase","reset asserted",UVM_MEDIUM)
			rst_seq.start(agt.seq);
			`uvm_info("run_phase","reset desserted",UVM_MEDIUM)


			`uvm_info("run_phase","rand starrted",UVM_MEDIUM)
			main_seq.start(agt.seq);
			`uvm_info("run_phase","rand ended",UVM_MEDIUM)
			phase.drop_objection(this);
		endtask
	
	endclass : FIFO_test
endpackage : FIFO_test_