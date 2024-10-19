module FIFO_top ();
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_::*;


	bit clk;
	initial begin
		clk=0;
		forever begin
			#2 clk=~clk;
		end 
	end

	FIFO_if F (clk);
	FIFO dut (F.data_in, F.wr_en, F.rd_en, F.clk, F.rst_n, F.full, F.empty, F.almostfull, 
		F.almostempty, F.wr_ack, F.overflow, F.underflow, F.data_out);

	initial begin
		uvm_config_db#(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_if",F);
		run_test("FIFO_test");
	end
endmodule : FIFO_top