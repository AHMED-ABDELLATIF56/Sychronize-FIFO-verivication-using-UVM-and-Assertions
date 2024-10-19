package shared_package;
	int correct_count = 0;
	int error_count = 0;

	int RD_EN_ON_DIST = 30;
	int WR_EN_ON_DIST = 70;

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	logic test_finished;
	
endpackage : shared_package