package FIFO_config_obj_;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class FIFO_config_obj extends  uvm_object;
	
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		virtual FIFO_if FIFO_config_vif;
	
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_config_obj)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_config_obj");
			super.new(name);
		endfunction : new
	
	endclass : FIFO_config_obj
	
endpackage : FIFO_config_obj_