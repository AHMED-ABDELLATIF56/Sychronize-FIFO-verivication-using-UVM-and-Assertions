////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO (data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	input [FIFO_WIDTH-1:0] data_in;
	input clk, rst_n, wr_en, rd_en;
	output reg [FIFO_WIDTH-1:0] data_out;
	output reg wr_ack, overflow, underflow;
	output full, empty, almostfull, almostempty;
	 
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr <= 0;
			overflow <= 0;
		end
		else if (wr_en && count < FIFO_DEPTH) begin 
			mem[wr_ptr] <= data_in;
			wr_ptr <= wr_ptr + 1;
			wr_ack <= 1;
		end
		else begin 
			wr_ack <= 0; 
			if (full & wr_en)
				overflow <= 1;
			else
				overflow <= 0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rd_ptr <= 0;
			underflow <= 0;
		end
		else if (rd_en && count != 0) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end else begin
			if (empty && rd_en)
				underflow <= 1;
			else
				underflow <= 0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			count <= 0;
		end
		else begin
			if	( ({wr_en, rd_en} == 2'b10) && !full) 
				count <= count + 1;
			else if ( ({wr_en, rd_en} == 2'b01) && !empty)
				count <= count - 1;
			else if (({wr_en, rd_en} == 2'b11) && empty) 
				count <= count + 1;
			else if (({wr_en, rd_en} == 2'b11) && full) 
				count <= count - 1;
		end
	end

	assign full = (count == FIFO_DEPTH)? 1 : 0;
	assign empty = (count == 0)? 1 : 0;
	assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
	assign almostempty = (count == 1)? 1 : 0;
	
		// Assertions
		// full flag
		assert property (@(posedge clk) (count == FIFO_DEPTH) |-> full );
		cover property (@(posedge clk) (count == FIFO_DEPTH) |-> full );
		// empty flag
		assert property (@(posedge clk) (count == 0) |-> empty );
		cover property (@(posedge clk) (count == 0) |-> empty );
		// almost full flag
		assert property (@(posedge clk) (count == FIFO_DEPTH-1) |-> almostfull );
		cover property (@(posedge clk) (count == FIFO_DEPTH-1) |-> almostfull);
		// almost empty flag
		assert property (@(posedge clk) (count == 1) |-> almostempty );
		cover property (@(posedge clk) (count == 1) |-> almostempty );
		// Over flow flag
		assert property (@(posedge clk) disable iff(!rst_n) (full && wr_en) |=> (overflow));
		cover property (@(posedge clk) disable iff(!rst_n) (full && wr_en) |=> (overflow));
		// Under flow flag
		assert property (@(posedge clk) disable iff(!rst_n) (empty && rd_en) |=> (underflow));
		cover property (@(posedge clk) disable iff(!rst_n) (empty && rd_en) |=> (underflow));
		// Write acknoledge flag
		assert property (@(posedge clk) disable iff(!rst_n) (wr_en && !full) |=> (wr_ack));
		cover property (@(posedge clk) disable iff(!rst_n) (wr_en && !full) |=> (wr_ack));
		// internal counters 
		// Write pointer
		assert property (@(posedge clk) disable iff(!rst_n) (wr_en && !full && wr_ptr!=7) |=> (wr_ptr==$past(wr_ptr)+1));
		cover property (@(posedge clk) disable iff(!rst_n) (wr_en && !full && wr_ptr!=7) |=> (wr_ptr==$past(wr_ptr)+1));
		// Write pointer if we wrote in the 8 places we will return to the beginning
		assert property (@(posedge clk) disable iff(!rst_n) (wr_en && !full && wr_ptr==7) |=> (wr_ptr==0));
		cover property (@(posedge clk) disable iff(!rst_n) (wr_en && !full && wr_ptr==7) |=> (wr_ptr==0));
		// Read pointer
		assert property (@(posedge clk) disable iff(!rst_n) (rd_en && !empty && rd_ptr!=7) |=> (rd_ptr==$past(rd_ptr)+1));
		cover property (@(posedge clk) disable iff(!rst_n) (rd_en && !empty && rd_ptr!=7) |=> (rd_ptr==$past(rd_ptr)+1));
		// Read pointer if we read the 8 places we will return to the beginning
		assert property (@(posedge clk) disable iff(!rst_n) (rd_en && !empty && rd_ptr==7) |=> (rd_ptr==0));
		cover property (@(posedge clk) disable iff(!rst_n) (rd_en && !empty && rd_ptr==7) |=> (rd_ptr==0));
		// counter
		assert property (@(posedge clk) disable iff(!rst_n) (wr_en && !full && !rd_en) |=> (count==$past(count)+1));
		cover property (@(posedge clk) disable iff(!rst_n) (wr_en && !full && !rd_en) |=> (count==$past(count)+1));
		assert property (@(posedge clk) disable iff(!rst_n) (rd_en && !empty && !wr_en) |=> (count==$past(count)-1));
		cover property (@(posedge clk) disable iff(!rst_n) (rd_en && !empty && !wr_en) |=> (count==$past(count)-1));
		assert property (@(posedge clk) disable iff(!rst_n) (wr_en && empty && rd_en) |=> (count==$past(count)+1));
		cover property (@(posedge clk) disable iff(!rst_n) (wr_en && empty && rd_en) |=> (count==$past(count)+1));
		assert property (@(posedge clk) disable iff(!rst_n) (wr_en && full && rd_en) |=> (count==$past(count)-1));
		cover property (@(posedge clk) disable iff(!rst_n) (wr_en && full && rd_en) |=> (count==$past(count)-1));

endmodule