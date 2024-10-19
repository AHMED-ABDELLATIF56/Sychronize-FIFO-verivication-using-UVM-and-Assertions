package FIFO_score_board_;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_::*;
import shared_package::*;


	class FIFO_score_board extends uvm_scoreboard;
		/*-------------------------------------------------------------------------------
		-- Interface, port, fields
		-------------------------------------------------------------------------------*/
			FIFO_seq_item seq_item;
			uvm_analysis_export #(FIFO_seq_item) sb_ex;
			uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

			// Outs to compare with
			logic [FIFO_WIDTH-1:0] data_out_ref;
			logic wr_ack_ref, overflow_ref;
			logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
		/*-------------------------------------------------------------------------------
		-- UVM Factory register
		-------------------------------------------------------------------------------*/
			// Provide implementations of virtual methods such as get_type_name and create
			`uvm_component_utils(FIFO_score_board)
		
		/*-------------------------------------------------------------------------------
		-- Functions
		-------------------------------------------------------------------------------*/
			// Constructor
			function new(string name = "FIFO_score_board", uvm_component parent=null);
				super.new(name, parent);
			endfunction : new

			// Build phase
			function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			seq_item = FIFO_seq_item::type_id::create("seq_item");
			sb_ex = new("sb_ex",this);
			sb_fifo = new("sb_fifo",this);
			endfunction

			// Connect phase
			function void connect_phase(uvm_phase phase);
				super.connect_phase(phase);
				sb_ex.connect(sb_fifo.analysis_export);
			endfunction 

			// Run phase
			task run_phase(uvm_phase phase);
				super.run_phase(phase);
				forever begin
					sb_fifo.get(seq_item);
					reference_model(seq_item);
					if (seq_item.data_out!=data_out_ref)
			        begin
						`uvm_error("run_phase", $sformatf("The DUT gives data_out:%b 
						while the Golden model gives data_out : %b",seq_item.data_out,data_out_ref));
						error_count++;
					end else begin
						correct_count++;
					end
				end	 	
			endtask  

			function reference_model(FIFO_seq_item seq_item);

				logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
				logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
				logic [max_fifo_addr:0] count;

				if (!seq_item.rst_n) begin
					wr_ptr = 0;
					rd_ptr = 0;
					count = 0;
					underflow_ref = 0;
					overflow_ref = 0;
				end
				else begin
					/* Read operatio before write operation to read the right value 
					when read and write signals asserted together*/

					if (seq_item.rd_en && count != 0) begin
						data_out_ref = mem[rd_ptr];
						rd_ptr = rd_ptr + 1;
						count = count - 1;
					end else begin
						if (empty_ref && seq_item.rd_en)
							underflow_ref = 1;
						else
							underflow_ref = 0;
					end 

					if (seq_item.wr_en && !full_ref) begin
						mem[wr_ptr] = seq_item.data_in;
						wr_ack_ref = 1;
						wr_ptr = wr_ptr + 1;
						count = count + 1;
					end
					else begin 
						wr_ack_ref = 0; 
						if (full_ref & seq_item.wr_en)
							overflow_ref = 1;
						else
							overflow_ref = 0;
					end
				end 
				
				
				if (count == FIFO_DEPTH) 
					full_ref = 1;
				else 
					full_ref = 0;
				
				if (count == 0)	
					empty_ref = 1;
				else 
					empty_ref = 0;

				if (count == FIFO_DEPTH-1)
					almostfull_ref = 1; 
				else
					almostfull_ref = 0;

				if (count == 1)
					almostempty_ref = 1;
				else 
					almostempty_ref = 0;
			endfunction  
		
		endclass : FIFO_score_board	
endpackage : FIFO_score_board_