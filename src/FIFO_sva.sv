module FIFO_sva (data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	input [FIFO_WIDTH-1:0] data_in;
	input clk, rst_n, wr_en, rd_en;
	output reg [FIFO_WIDTH-1:0] data_out;
	output reg wr_ack, overflow;
	output full, empty, almostfull, almostempty, underflow;

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