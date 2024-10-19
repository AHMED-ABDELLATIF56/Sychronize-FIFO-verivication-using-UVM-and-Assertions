package FIFO_agent_;
	import FIFO_driver_::*;
	import uvm_pkg::*;
	import FIFO_sequencer_::*;
	import FIFO_monitor_::*;
	import FIFO_config_obj_::*;
	import FIFO_seq_item_::*;
	`include "uvm_macros.svh"

	class FIFO_agent extends uvm_agent;
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		FIFO_sequencer seq;
		FIFO_config_obj co;
		FIFO_monitor mon;
		FIFO_driver drv;
		uvm_analysis_port #(FIFO_seq_item) agt_ap;
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_agent)
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_agent", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		// Build phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if (!uvm_config_db#(FIFO_config_obj)::get(this, "", "FIFO_vif_CO",co)) begin
				`uvm_fatal("build_phase","Agent can not get the interface")
			end
			mon = FIFO_monitor::type_id::create("mon",this);
			seq = FIFO_sequencer::type_id::create("seq",this);
			drv = FIFO_driver::type_id::create("drv",this);
			agt_ap = new("agt_ap",this);
		endfunction 

		// Connect phase
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			drv.FIFO_driver_vif = co.FIFO_config_vif;
			mon.FIFO_vif = co.FIFO_config_vif; 
			drv.seq_item_port.connect(seq.seq_item_export);
			mon.mon_ap.connect(agt_ap);
		endfunction 
	
	endclass : FIFO_agent
endpackage : FIFO_agent_