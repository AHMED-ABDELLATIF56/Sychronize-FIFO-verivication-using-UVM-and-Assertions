package FIFO_seq_item_;
import shared_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

	class FIFO_seq_item extends  uvm_sequence_item;
	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;
		rand logic [FIFO_WIDTH-1:0] data_in;
		rand logic rst_n, wr_en, rd_en;
		logic [FIFO_WIDTH-1:0] data_out;
		logic wr_ack, overflow;
		logic full, empty, almostfull, almostempty, underflow;
	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_seq_item)
	
	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "FIFO_seq_item");
			super.new(name);
		endfunction : new

		function string convert2string_sim();
			return $sformatf("rst_n=%b ,data_in=%b ,wr_en=%b ,rd_en=%b ,data_out=%b "
				,rst_n,data_in,wr_en,rd_en,data_out);
		endfunction

	/*-------------------------------------------------------------------------------
	-- Constrain
	-------------------------------------------------------------------------------*/
		constraint c {
			rst_n dist {1:/95 , 0:/5};
			wr_en dist {1:/WR_EN_ON_DIST , 0:/(100-WR_EN_ON_DIST)};
			rd_en dist {1:/RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};
		}

	endclass : FIFO_seq_item

endpackage : FIFO_seq_item_