// `define LOG2(x) ( \
// 	(x <= 2) ? 1 : \
// 	(x <= 4) ? 2 : \
// 	(x <= 8) ? 3 : \
// 	(x <= 16) ? 4 : \
// 	(x <= 32) ? 5 : \
// 	(x <= 64) ? 6 : \
// 	(x <= 128) ? 7 : \
// 	(x <= 256) ? 8 : \
// 	(x <= 512) ? 9 : \
// 	(x <= 1024) ? 10 : \
// 	(x <= 2048) ? 11 : \
// 	(x <= 4096) ? 12 : \
// 	(x <= 8192) ? 13 : \
// 	(x <= 16384) ? 14 : \
// 	(x <= 32768) ? 15 : \
// 	(x <= 65536) ? 16 : \
// 	(x <= 131072) ? 17 : \
// 	(x <= 262144) ? 18 : \
// 	(x <= 524288) ? 19 : \
// 	(x <= 1048576) ? 20 : \
// 	(x <= 2097152) ? 21 : \
// 	(x <= 4194304) ? 22 : \
// 	(x <= 8388608) ? 23 : \
// 	(x <= 16777216) ? 24 : \
// 	(x <= 33554432) ? 25 : \
// 	(x <= 67108864) ? 26 : \
// 	(x <= 134217728) ? 27 : \
// 	(x <= 268435456) ? 28 : \
// 	(x <= 536870912) ? 29 : \
// 	(x <= 1073741824) ? 30 : \
// 	0 )

// `define SIMULATION
// `define ROW_LEN_BITS 8
`define COL_ID_BITS 8
`define ROW_ID_BITS 8
`define MAT_VAL_BITS 8
`define VEC_VAL_BITS 8
`define MULT_BITS (`VEC_VAL_BITS + `MAT_VAL_BITS)
`define NUM_CHANNEL 32
`define NUM_CHANNEL_BITS 5 //$clog2(`NUM_CHANNEL)
`define LANE_NUM (3 * `NUM_CHANNEL)
// `define LANE_NUM_BITS $clog2(`LANE_NUM)
`define NUM_MAT_VALS 9088
`define NUM_COL_IDS `NUM_MAT_VALS
`define NUM_ROW_IDS `NUM_MAT_VALS
`define NUM_VEC_VALS 128

`define FIFO_DEPTH 8
`define MAX_COLS (1<<`COL_ID_BITS)

// MACROS for BVB
`define BYTES_PER_ADDR_PER_BRAM 4
`define VEC_VAL_BYTES (`VEC_VAL_BITS/8)
`define VEC_VAL_OFFSET $clog2(`VEC_VAL_BITS)
`define NUM_VEC_VALS_PER_ADDR_PER_BRAM (`BYTES_PER_ADDR_PER_BRAM/`VEC_VAL_BYTES)
`define NUM_VEC_VALS_PER_ADDR `NUM_VEC_VALS
`define NUM_VEC_VALS_PER_ADDR_BITS $clog2(`NUM_VEC_VALS_PER_ADDR)
`define NUM_BRAMS (`NUM_VEC_VALS_PER_ADDR/`NUM_VEC_VALS_PER_ADDR_PER_BRAM)
`define NUM_ADDR (`NUM_VEC_VALS/`NUM_VEC_VALS_PER_ADDR)
`define BVB_AWIDTH 1 //$clog2(`NUM_ADDR) Use `NUM_ADDR when `NUM_ADDR>1
`define BVB_DWIDTH (`NUM_VEC_VALS_PER_ADDR*`VEC_VAL_BITS)
`define COUNTER_BITS `BVB_AWIDTH
`define LOCAL_ID_BITS `NUM_VEC_VALS_PER_ADDR_BITS


module spmv(
	input clk,
	input rst,

	output reg done_reg
);

	// Row ID fifo signal
	wire [(`ROW_ID_BITS*`NUM_CHANNEL)-1:0] row_id;
	wire [`NUM_CHANNEL-1:0] row_id_empty;
	wire [`NUM_CHANNEL-1:0] row_id_rd_en;

	// column id fifo signals
	wire [(`COL_ID_BITS*`NUM_CHANNEL-1):0] col_id;
	wire [`NUM_CHANNEL-1:0] col_id_empty;
	wire [`NUM_CHANNEL-1:0] col_id_rd_en; 

	// matrix elements fifo signals
	wire [(`MAT_VAL_BITS*`NUM_CHANNEL)-1:0] mat_val;
	wire [`NUM_CHANNEL-1:0] mat_val_empty;
	wire [`NUM_CHANNEL-1:0] mat_val_rd_en;

	// The above the FIFOs are called fetcher FIFOs as they are a part of fetcher module and are filled by fetcher.

	// Fetcher module signals. There are just the above three put together.
	wire [((`ROW_ID_BITS+`COL_ID_BITS+`MAT_VAL_BITS)*`NUM_CHANNEL)-1:0] fetcher_out;
	wire [3*`NUM_CHANNEL-1:0] fetcher_empty;
	wire [3*`NUM_CHANNEL-1:0] fetcher_rd_en;

	// Vector values fifo signals
	wire [`VEC_VAL_BITS*`NUM_CHANNEL-1:0] vec_val;
	wire [`NUM_CHANNEL-1:0] vec_val_empty;
	wire [`NUM_CHANNEL-1:0] vec_val_rd_en;

	// 1 if at least 1 of the fetcher FIFOs is empty
	reg all_empty;

	// Signal to start the engine
	reg start;

	// Output data
	wire [(`MULT_BITS*`NUM_CHANNEL)-1:0] wr_data;
	// Address to store output data
	wire [(`ROW_ID_BITS*`NUM_CHANNEL)-1:0] wr_addr;
	// Memory to write the output data
	reg [`MULT_BITS-1:0] write_mem [(1<<`ROW_ID_BITS)-1:0];

	reg [(`MULT_BITS*`NUM_CHANNEL)-1:0] wr_data_reg;
	reg [(`ROW_ID_BITS*`NUM_CHANNEL)-1:0] wr_addr_reg;
	wire [`NUM_CHANNEL-1:0] wr_en;

	// Signals to indicate that the computation is complete
	wire [`NUM_CHANNEL-1:0] done;
	reg done_all, done_delay1, done_delay2;

	wire fetcher_done;

	always@(posedge clk or posedge rst) begin
		if (rst) begin
			all_empty <= 1;
			start <= 0;
		end
		else begin
			all_empty <= (|fetcher_empty) & (~start);
			if (!all_empty) begin
				start <= 1;
			end
		end
	end

	always@(posedge clk) begin
		wr_data_reg <= wr_data;
		wr_addr_reg <= wr_addr;
		done_all <= &done;
		done_delay1 <= done_all;
		done_delay2 <= done_delay1;
		done_reg <= done_delay2;
	`ifdef SIMULATION
		if(done_delay2) begin
			$writememh("/home/aatman/Desktop/SpMV/src/coe/out.txt", write_mem);
		end
	`endif
	end

	// always@(posedge clk) begin 
	// 	if(wr_en[0]) begin 
	// 		write_mem[wr_addr_reg[(0+1)*`ROW_ID_BITS-1: 0*`ROW_ID_BITS]] <= wr_data_reg[(0+1)*`MULT_BITS-1: 0*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[1]) begin 
	// 		write_mem[wr_addr_reg[(1+1)*`ROW_ID_BITS-1: 1*`ROW_ID_BITS]] <= wr_data_reg[(1+1)*`MULT_BITS-1: 1*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[2]) begin 
	// 		write_mem[wr_addr_reg[(2+1)*`ROW_ID_BITS-1: 2*`ROW_ID_BITS]] <= wr_data_reg[(2+1)*`MULT_BITS-1: 2*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[3]) begin 
	// 		write_mem[wr_addr_reg[(3+1)*`ROW_ID_BITS-1: 3*`ROW_ID_BITS]] <= wr_data_reg[(3+1)*`MULT_BITS-1: 3*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[4]) begin 
	// 		write_mem[wr_addr_reg[(4+1)*`ROW_ID_BITS-1: 4*`ROW_ID_BITS]] <= wr_data_reg[(4+1)*`MULT_BITS-1: 4*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[5]) begin 
	// 		write_mem[wr_addr_reg[(5+1)*`ROW_ID_BITS-1: 5*`ROW_ID_BITS]] <= wr_data_reg[(5+1)*`MULT_BITS-1: 5*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[6]) begin 
	// 		write_mem[wr_addr_reg[(6+1)*`ROW_ID_BITS-1: 6*`ROW_ID_BITS]] <= wr_data_reg[(6+1)*`MULT_BITS-1: 6*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[7]) begin 
	// 		write_mem[wr_addr_reg[(7+1)*`ROW_ID_BITS-1: 7*`ROW_ID_BITS]] <= wr_data_reg[(7+1)*`MULT_BITS-1: 7*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[8]) begin 
	// 		write_mem[wr_addr_reg[(8+1)*`ROW_ID_BITS-1: 8*`ROW_ID_BITS]] <= wr_data_reg[(8+1)*`MULT_BITS-1: 8*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[9]) begin 
	// 		write_mem[wr_addr_reg[(9+1)*`ROW_ID_BITS-1: 9*`ROW_ID_BITS]] <= wr_data_reg[(9+1)*`MULT_BITS-1: 9*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[10]) begin 
	// 		write_mem[wr_addr_reg[(10+1)*`ROW_ID_BITS-1: 10*`ROW_ID_BITS]] <= wr_data_reg[(10+1)*`MULT_BITS-1: 10*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[11]) begin 
	// 		write_mem[wr_addr_reg[(11+1)*`ROW_ID_BITS-1: 11*`ROW_ID_BITS]] <= wr_data_reg[(11+1)*`MULT_BITS-1: 11*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[12]) begin 
	// 		write_mem[wr_addr_reg[(12+1)*`ROW_ID_BITS-1: 12*`ROW_ID_BITS]] <= wr_data_reg[(12+1)*`MULT_BITS-1: 12*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[13]) begin 
	// 		write_mem[wr_addr_reg[(13+1)*`ROW_ID_BITS-1: 13*`ROW_ID_BITS]] <= wr_data_reg[(13+1)*`MULT_BITS-1: 13*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[14]) begin 
	// 		write_mem[wr_addr_reg[(14+1)*`ROW_ID_BITS-1: 14*`ROW_ID_BITS]] <= wr_data_reg[(14+1)*`MULT_BITS-1: 14*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[15]) begin 
	// 		write_mem[wr_addr_reg[(15+1)*`ROW_ID_BITS-1: 15*`ROW_ID_BITS]] <= wr_data_reg[(15+1)*`MULT_BITS-1: 15*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[16]) begin 
	// 		write_mem[wr_addr_reg[(16+1)*`ROW_ID_BITS-1: 16*`ROW_ID_BITS]] <= wr_data_reg[(16+1)*`MULT_BITS-1: 16*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[17]) begin 
	// 		write_mem[wr_addr_reg[(17+1)*`ROW_ID_BITS-1: 17*`ROW_ID_BITS]] <= wr_data_reg[(17+1)*`MULT_BITS-1: 17*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[18]) begin 
	// 		write_mem[wr_addr_reg[(18+1)*`ROW_ID_BITS-1: 18*`ROW_ID_BITS]] <= wr_data_reg[(18+1)*`MULT_BITS-1: 18*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[19]) begin 
	// 		write_mem[wr_addr_reg[(19+1)*`ROW_ID_BITS-1: 19*`ROW_ID_BITS]] <= wr_data_reg[(19+1)*`MULT_BITS-1: 19*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[20]) begin 
	// 		write_mem[wr_addr_reg[(20+1)*`ROW_ID_BITS-1: 20*`ROW_ID_BITS]] <= wr_data_reg[(20+1)*`MULT_BITS-1: 20*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[21]) begin 
	// 		write_mem[wr_addr_reg[(21+1)*`ROW_ID_BITS-1: 21*`ROW_ID_BITS]] <= wr_data_reg[(21+1)*`MULT_BITS-1: 21*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[22]) begin 
	// 		write_mem[wr_addr_reg[(22+1)*`ROW_ID_BITS-1: 22*`ROW_ID_BITS]] <= wr_data_reg[(22+1)*`MULT_BITS-1: 22*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[23]) begin 
	// 		write_mem[wr_addr_reg[(23+1)*`ROW_ID_BITS-1: 23*`ROW_ID_BITS]] <= wr_data_reg[(23+1)*`MULT_BITS-1: 23*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[24]) begin 
	// 		write_mem[wr_addr_reg[(24+1)*`ROW_ID_BITS-1: 24*`ROW_ID_BITS]] <= wr_data_reg[(24+1)*`MULT_BITS-1: 24*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[25]) begin 
	// 		write_mem[wr_addr_reg[(25+1)*`ROW_ID_BITS-1: 25*`ROW_ID_BITS]] <= wr_data_reg[(25+1)*`MULT_BITS-1: 25*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[26]) begin 
	// 		write_mem[wr_addr_reg[(26+1)*`ROW_ID_BITS-1: 26*`ROW_ID_BITS]] <= wr_data_reg[(26+1)*`MULT_BITS-1: 26*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[27]) begin 
	// 		write_mem[wr_addr_reg[(27+1)*`ROW_ID_BITS-1: 27*`ROW_ID_BITS]] <= wr_data_reg[(27+1)*`MULT_BITS-1: 27*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[28]) begin 
	// 		write_mem[wr_addr_reg[(28+1)*`ROW_ID_BITS-1: 28*`ROW_ID_BITS]] <= wr_data_reg[(28+1)*`MULT_BITS-1: 28*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[29]) begin 
	// 		write_mem[wr_addr_reg[(29+1)*`ROW_ID_BITS-1: 29*`ROW_ID_BITS]] <= wr_data_reg[(29+1)*`MULT_BITS-1: 29*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[30]) begin 
	// 		write_mem[wr_addr_reg[(30+1)*`ROW_ID_BITS-1: 30*`ROW_ID_BITS]] <= wr_data_reg[(30+1)*`MULT_BITS-1: 30*`MULT_BITS]; 
	// 	end 
	// end

	// always@(posedge clk) begin 
	// 	if(wr_en[31]) begin 
	// 		write_mem[wr_addr_reg[(31+1)*`ROW_ID_BITS-1: 31*`ROW_ID_BITS]] <= wr_data_reg[(31+1)*`MULT_BITS-1: 31*`MULT_BITS]; 
	// 	end 
	// end

	// Assign FIFOs' read enables to the respective wires of fetcher read enable.
	assign fetcher_rd_en[3*`NUM_CHANNEL-1: 2*`NUM_CHANNEL] = row_id_rd_en;
	assign fetcher_rd_en[2*`NUM_CHANNEL-1: 1*`NUM_CHANNEL] = col_id_rd_en;
	assign fetcher_rd_en[1*`NUM_CHANNEL-1: 0] = mat_val_rd_en;

	fetcher fetcher (
		.clk(clk),
		.rst(rst),

		.mat_val_rd_en(fetcher_rd_en[1*`NUM_CHANNEL-1: 0]),
		.col_id_rd_en(fetcher_rd_en[2*`NUM_CHANNEL-1: 1*`NUM_CHANNEL]),
		.row_id_rd_en(fetcher_rd_en[3*`NUM_CHANNEL-1: 2*`NUM_CHANNEL]),

		.mat_val_out(fetcher_out[(1*`MAT_VAL_BITS*`NUM_CHANNEL)-1: 0]),
		.col_id_out(fetcher_out[(2*`COL_ID_BITS*`NUM_CHANNEL)-1: 1*`COL_ID_BITS*`NUM_CHANNEL]),
		.row_id_out(fetcher_out[(3*`ROW_ID_BITS*`NUM_CHANNEL)-1: 2*`ROW_ID_BITS*`NUM_CHANNEL]),

		.mat_val_empty(fetcher_empty[1*`NUM_CHANNEL-1: 0]),
		.col_id_empty(fetcher_empty[2*`NUM_CHANNEL-1: 1*`NUM_CHANNEL]),
		.row_id_empty(fetcher_empty[3*`NUM_CHANNEL-1: 2*`NUM_CHANNEL]),

		.done(fetcher_done)
	);

	assign row_id = fetcher_out[3*`ROW_ID_BITS*`NUM_CHANNEL-1: 2*`ROW_ID_BITS*`NUM_CHANNEL];
	assign row_id_empty = fetcher_empty[3*`NUM_CHANNEL-1: 2*`NUM_CHANNEL];

	assign col_id = fetcher_out[2*`COL_ID_BITS*`NUM_CHANNEL-1: 1*`COL_ID_BITS*`NUM_CHANNEL];
	assign col_id_empty = fetcher_empty[2*`NUM_CHANNEL-1: 1*`NUM_CHANNEL];

	assign mat_val = fetcher_out[1*`MAT_VAL_BITS*`NUM_CHANNEL-1: 0];
	assign mat_val_empty = fetcher_empty[1*`NUM_CHANNEL-1: 0];


	bvb bvb (
		.clk(clk),
		.rst(rst),
		.start(start),
		.id(col_id),
		.id_empty(col_id_empty),
		.id_rd_en(col_id_rd_en),
		.val(vec_val),
		.val_empty(vec_val_empty),
		.val_rd_en(vec_val_rd_en)
	);

	Big_Channel Big_Channel_ (
		.clk(clk), 
		.rst(rst),
		.start(start), 
		.fetcher_done(fetcher_done),
		.mat_val(mat_val), 
		.mat_val_empty(mat_val_empty), 
		.mat_val_rd_en(mat_val_rd_en), 
		.vec_val(vec_val), 
		.vec_val_empty(vec_val_empty), 
		.vec_val_rd_en(vec_val_rd_en), 
		.row_id(row_id), 
		.row_id_empty(row_id_empty), 
		.row_id_rd_en(row_id_rd_en), 
		.wr_data(wr_data), 
		.wr_addr(wr_addr), 
		.wr_en(wr_en),
		.done(done)
	);
endmodule



/* Fetcher Module */
module fetcher(
	input clk,
	input rst,

	input  [`NUM_CHANNEL-1:0] mat_val_rd_en,
	input  [`NUM_CHANNEL-1:0] col_id_rd_en,
	input  [`NUM_CHANNEL-1:0] row_id_rd_en,

	output [(`MAT_VAL_BITS*`NUM_CHANNEL)-1:0] mat_val_out,
	output [(`COL_ID_BITS*`NUM_CHANNEL)-1:0] col_id_out,
	output [(`ROW_ID_BITS*`NUM_CHANNEL)-1:0] row_id_out,

	output [`NUM_CHANNEL-1:0] mat_val_empty,
	output [`NUM_CHANNEL-1:0] col_id_empty,
	output [`NUM_CHANNEL-1:0] row_id_empty,

	output done
	);

`ifdef SIMULATION
	parameter MAT_VAL_FILE = "/home/aatman/Desktop/SpMV/src/coe/mat_val.txt";
	parameter COL_ID_FILE = "/home/aatman/Desktop/SpMV/src/coe/col_id.txt";
	parameter ROW_ID_FILE = "/home/aatman/Desktop/SpMV/src/coe/row_id.txt";
`endif

	// parameter FIFO_DEPTH = 8;
	parameter FIFO_DEPTH_BITS = $clog2(`FIFO_DEPTH);

	// parameter ROW_LEN_ROM_DWIDTH = `ROW_LEN_BITS * `NUM_CHANNEL;
	// parameter ROW_LEN_ROM_NUM_ADDR = `NUM_ROW_LENS/`NUM_CHANNEL;
	parameter ROW_ID_ROM_DWIDTH = `ROW_ID_BITS;
	parameter ROW_ID_ROM_NUM_ADDR = `NUM_ROW_IDS;
	// parameter ROW_ID_AWIDTH = $clog2(ROW_ID_ROM_NUM_ADDR);
	parameter ROW_ID_AWIDTH = $clog2(`NUM_ROW_IDS);

	// parameter MAT_VAL_ROM_DWIDTH = `MAT_VAL_BITS * `NUM_CHANNEL;
	// parameter MAT_VAL_ROM_NUM_ADDR = `NUM_MAT_VALS/`NUM_CHANNEL;
	parameter MAT_VAL_ROM_DWIDTH = `MAT_VAL_BITS;
	parameter MAT_VAL_ROM_NUM_ADDR = `NUM_MAT_VALS;
	// parameter MAT_VAL_AWIDTH = $clog2(MAT_VAL_ROM_NUM_ADDR);
	parameter MAT_VAL_AWIDTH = $clog2(`NUM_MAT_VALS);

	// parameter COL_ID_ROM_DWIDTH = `COL_ID_BITS * `NUM_CHANNEL;
	// parameter COL_ID_ROM_NUM_ADDR = `NUM_COL_IDS/`NUM_CHANNEL;
	parameter COL_ID_ROM_DWIDTH = `COL_ID_BITS;
	parameter COL_ID_ROM_NUM_ADDR = `NUM_COL_IDS;
	// parameter COL_ID_AWIDTH = $clog2(COL_ID_ROM_NUM_ADDR);
	parameter COL_ID_AWIDTH = $clog2(`NUM_COL_IDS);

	parameter NUM_CHANNEL_BITS = $clog2(`NUM_CHANNEL);

	reg [MAT_VAL_AWIDTH-1:0] mat_val_addr;
	reg [COL_ID_AWIDTH-1:0] col_id_addr;
	reg [ROW_ID_AWIDTH-1:0] row_id_addr;

	wire [MAT_VAL_ROM_DWIDTH-1:0] mat_val_dout;
	wire [COL_ID_ROM_DWIDTH-1:0] col_id_dout;
	wire [ROW_ID_ROM_DWIDTH-1:0] row_id_dout;

	reg [NUM_CHANNEL_BITS-1:0] mat_val_lane;
	reg [NUM_CHANNEL_BITS-1:0] col_id_lane;
	reg [NUM_CHANNEL_BITS-1:0] row_id_lane;
	 
	reg [`NUM_CHANNEL-1:0] mat_val_wr_en;
	reg [`NUM_CHANNEL-1:0] col_id_wr_en;
	reg [`NUM_CHANNEL-1:0] row_id_wr_en;

	wire [`NUM_CHANNEL-1:0] mat_val_full;
	wire [`NUM_CHANNEL-1:0] col_id_full;
	wire [`NUM_CHANNEL-1:0] row_id_full;

	wire [`NUM_CHANNEL-1:0] mat_val_full_shifted;
	wire [`NUM_CHANNEL-1:0] col_id_full_shifted;
	wire [`NUM_CHANNEL-1:0] row_id_full_shifted;

	// wire done;
	reg [MAT_VAL_AWIDTH:0] counter;

	spram #(
	`ifdef SIMULATION
		.INIT(MAT_VAL_FILE),
	`endif
		.AWIDTH(MAT_VAL_AWIDTH),
		.NUM_WORDS(MAT_VAL_ROM_NUM_ADDR),
		.DWIDTH(MAT_VAL_ROM_DWIDTH)
	) mat_val_rom (
		.clk(clk),
		.address(mat_val_addr),
		.wren(0),
		.din(0),
		.dout(mat_val_dout)
	);

	spram #(
	`ifdef SIMULATION
		.INIT(COL_ID_FILE),
	`endif
		.AWIDTH(COL_ID_AWIDTH),
		.NUM_WORDS(COL_ID_ROM_NUM_ADDR),
		.DWIDTH(COL_ID_ROM_DWIDTH)
	) col_id_rom (
		.clk(clk),
		.address(col_id_addr),
		.wren(0),
		.din(0),
		.dout(col_id_dout)
	);

	spram #(
	`ifdef SIMULATION
		.INIT(ROW_ID_FILE),
	`endif
		.AWIDTH(ROW_ID_AWIDTH),
		.NUM_WORDS(ROW_ID_ROM_NUM_ADDR),
		.DWIDTH(ROW_ID_ROM_DWIDTH)
	) row_id_rom (
		.clk(clk),
		.address(row_id_addr),
		.wren(0),
		.din(0),
		.dout(row_id_dout)
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_0 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[0]), // input wr_en 
		.re(mat_val_rd_en[0]), // input rd_en 
		.dout(mat_val_out[((0+1)*`MAT_VAL_BITS)-1:0*`MAT_VAL_BITS]), 
		.full(mat_val_full[0]), // output full 
		.empty(mat_val_empty[0]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_0 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[0]), // input wr_en 
		.re(col_id_rd_en[0]), // input rd_en 
		.dout(col_id_out[((0+1)*`COL_ID_BITS)-1:0*`COL_ID_BITS]), 
		.full(col_id_full[0]), // output full 
		.empty(col_id_empty[0]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_0 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[0]), // input wr_en 
		.re(row_id_rd_en[0]), // input rd_en 
		.dout(row_id_out[((0+1)*`ROW_ID_BITS)-1:0*`ROW_ID_BITS]), 
		.full(row_id_full[0]), // output full 
		.empty(row_id_empty[0]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_1 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[1]), // input wr_en 
		.re(mat_val_rd_en[1]), // input rd_en 
		.dout(mat_val_out[((1+1)*`MAT_VAL_BITS)-1:1*`MAT_VAL_BITS]), 
		.full(mat_val_full[1]), // output full 
		.empty(mat_val_empty[1]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_1 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[1]), // input wr_en 
		.re(col_id_rd_en[1]), // input rd_en 
		.dout(col_id_out[((1+1)*`COL_ID_BITS)-1:1*`COL_ID_BITS]), 
		.full(col_id_full[1]), // output full 
		.empty(col_id_empty[1]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_1 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[1]), // input wr_en 
		.re(row_id_rd_en[1]), // input rd_en 
		.dout(row_id_out[((1+1)*`ROW_ID_BITS)-1:1*`ROW_ID_BITS]), 
		.full(row_id_full[1]), // output full 
		.empty(row_id_empty[1]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_2 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[2]), // input wr_en 
		.re(mat_val_rd_en[2]), // input rd_en 
		.dout(mat_val_out[((2+1)*`MAT_VAL_BITS)-1:2*`MAT_VAL_BITS]), 
		.full(mat_val_full[2]), // output full 
		.empty(mat_val_empty[2]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_2 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[2]), // input wr_en 
		.re(col_id_rd_en[2]), // input rd_en 
		.dout(col_id_out[((2+1)*`COL_ID_BITS)-1:2*`COL_ID_BITS]), 
		.full(col_id_full[2]), // output full 
		.empty(col_id_empty[2]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_2 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[2]), // input wr_en 
		.re(row_id_rd_en[2]), // input rd_en 
		.dout(row_id_out[((2+1)*`ROW_ID_BITS)-1:2*`ROW_ID_BITS]), 
		.full(row_id_full[2]), // output full 
		.empty(row_id_empty[2]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_3 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[3]), // input wr_en 
		.re(mat_val_rd_en[3]), // input rd_en 
		.dout(mat_val_out[((3+1)*`MAT_VAL_BITS)-1:3*`MAT_VAL_BITS]), 
		.full(mat_val_full[3]), // output full 
		.empty(mat_val_empty[3]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_3 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[3]), // input wr_en 
		.re(col_id_rd_en[3]), // input rd_en 
		.dout(col_id_out[((3+1)*`COL_ID_BITS)-1:3*`COL_ID_BITS]), 
		.full(col_id_full[3]), // output full 
		.empty(col_id_empty[3]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_3 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[3]), // input wr_en 
		.re(row_id_rd_en[3]), // input rd_en 
		.dout(row_id_out[((3+1)*`ROW_ID_BITS)-1:3*`ROW_ID_BITS]), 
		.full(row_id_full[3]), // output full 
		.empty(row_id_empty[3]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_4 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[4]), // input wr_en 
		.re(mat_val_rd_en[4]), // input rd_en 
		.dout(mat_val_out[((4+1)*`MAT_VAL_BITS)-1:4*`MAT_VAL_BITS]), 
		.full(mat_val_full[4]), // output full 
		.empty(mat_val_empty[4]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_4 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[4]), // input wr_en 
		.re(col_id_rd_en[4]), // input rd_en 
		.dout(col_id_out[((4+1)*`COL_ID_BITS)-1:4*`COL_ID_BITS]), 
		.full(col_id_full[4]), // output full 
		.empty(col_id_empty[4]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_4 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[4]), // input wr_en 
		.re(row_id_rd_en[4]), // input rd_en 
		.dout(row_id_out[((4+1)*`ROW_ID_BITS)-1:4*`ROW_ID_BITS]), 
		.full(row_id_full[4]), // output full 
		.empty(row_id_empty[4]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_5 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[5]), // input wr_en 
		.re(mat_val_rd_en[5]), // input rd_en 
		.dout(mat_val_out[((5+1)*`MAT_VAL_BITS)-1:5*`MAT_VAL_BITS]), 
		.full(mat_val_full[5]), // output full 
		.empty(mat_val_empty[5]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_5 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[5]), // input wr_en 
		.re(col_id_rd_en[5]), // input rd_en 
		.dout(col_id_out[((5+1)*`COL_ID_BITS)-1:5*`COL_ID_BITS]), 
		.full(col_id_full[5]), // output full 
		.empty(col_id_empty[5]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_5 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[5]), // input wr_en 
		.re(row_id_rd_en[5]), // input rd_en 
		.dout(row_id_out[((5+1)*`ROW_ID_BITS)-1:5*`ROW_ID_BITS]), 
		.full(row_id_full[5]), // output full 
		.empty(row_id_empty[5]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_6 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[6]), // input wr_en 
		.re(mat_val_rd_en[6]), // input rd_en 
		.dout(mat_val_out[((6+1)*`MAT_VAL_BITS)-1:6*`MAT_VAL_BITS]), 
		.full(mat_val_full[6]), // output full 
		.empty(mat_val_empty[6]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_6 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[6]), // input wr_en 
		.re(col_id_rd_en[6]), // input rd_en 
		.dout(col_id_out[((6+1)*`COL_ID_BITS)-1:6*`COL_ID_BITS]), 
		.full(col_id_full[6]), // output full 
		.empty(col_id_empty[6]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_6 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[6]), // input wr_en 
		.re(row_id_rd_en[6]), // input rd_en 
		.dout(row_id_out[((6+1)*`ROW_ID_BITS)-1:6*`ROW_ID_BITS]), 
		.full(row_id_full[6]), // output full 
		.empty(row_id_empty[6]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_7 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[7]), // input wr_en 
		.re(mat_val_rd_en[7]), // input rd_en 
		.dout(mat_val_out[((7+1)*`MAT_VAL_BITS)-1:7*`MAT_VAL_BITS]), 
		.full(mat_val_full[7]), // output full 
		.empty(mat_val_empty[7]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_7 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[7]), // input wr_en 
		.re(col_id_rd_en[7]), // input rd_en 
		.dout(col_id_out[((7+1)*`COL_ID_BITS)-1:7*`COL_ID_BITS]), 
		.full(col_id_full[7]), // output full 
		.empty(col_id_empty[7]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_7 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[7]), // input wr_en 
		.re(row_id_rd_en[7]), // input rd_en 
		.dout(row_id_out[((7+1)*`ROW_ID_BITS)-1:7*`ROW_ID_BITS]), 
		.full(row_id_full[7]), // output full 
		.empty(row_id_empty[7]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_8 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[8]), // input wr_en 
		.re(mat_val_rd_en[8]), // input rd_en 
		.dout(mat_val_out[((8+1)*`MAT_VAL_BITS)-1:8*`MAT_VAL_BITS]), 
		.full(mat_val_full[8]), // output full 
		.empty(mat_val_empty[8]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_8 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[8]), // input wr_en 
		.re(col_id_rd_en[8]), // input rd_en 
		.dout(col_id_out[((8+1)*`COL_ID_BITS)-1:8*`COL_ID_BITS]), 
		.full(col_id_full[8]), // output full 
		.empty(col_id_empty[8]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_8 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[8]), // input wr_en 
		.re(row_id_rd_en[8]), // input rd_en 
		.dout(row_id_out[((8+1)*`ROW_ID_BITS)-1:8*`ROW_ID_BITS]), 
		.full(row_id_full[8]), // output full 
		.empty(row_id_empty[8]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_9 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[9]), // input wr_en 
		.re(mat_val_rd_en[9]), // input rd_en 
		.dout(mat_val_out[((9+1)*`MAT_VAL_BITS)-1:9*`MAT_VAL_BITS]), 
		.full(mat_val_full[9]), // output full 
		.empty(mat_val_empty[9]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_9 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[9]), // input wr_en 
		.re(col_id_rd_en[9]), // input rd_en 
		.dout(col_id_out[((9+1)*`COL_ID_BITS)-1:9*`COL_ID_BITS]), 
		.full(col_id_full[9]), // output full 
		.empty(col_id_empty[9]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_9 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[9]), // input wr_en 
		.re(row_id_rd_en[9]), // input rd_en 
		.dout(row_id_out[((9+1)*`ROW_ID_BITS)-1:9*`ROW_ID_BITS]), 
		.full(row_id_full[9]), // output full 
		.empty(row_id_empty[9]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_10 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[10]), // input wr_en 
		.re(mat_val_rd_en[10]), // input rd_en 
		.dout(mat_val_out[((10+1)*`MAT_VAL_BITS)-1:10*`MAT_VAL_BITS]), 
		.full(mat_val_full[10]), // output full 
		.empty(mat_val_empty[10]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_10 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[10]), // input wr_en 
		.re(col_id_rd_en[10]), // input rd_en 
		.dout(col_id_out[((10+1)*`COL_ID_BITS)-1:10*`COL_ID_BITS]), 
		.full(col_id_full[10]), // output full 
		.empty(col_id_empty[10]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_10 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[10]), // input wr_en 
		.re(row_id_rd_en[10]), // input rd_en 
		.dout(row_id_out[((10+1)*`ROW_ID_BITS)-1:10*`ROW_ID_BITS]), 
		.full(row_id_full[10]), // output full 
		.empty(row_id_empty[10]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_11 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[11]), // input wr_en 
		.re(mat_val_rd_en[11]), // input rd_en 
		.dout(mat_val_out[((11+1)*`MAT_VAL_BITS)-1:11*`MAT_VAL_BITS]), 
		.full(mat_val_full[11]), // output full 
		.empty(mat_val_empty[11]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_11 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[11]), // input wr_en 
		.re(col_id_rd_en[11]), // input rd_en 
		.dout(col_id_out[((11+1)*`COL_ID_BITS)-1:11*`COL_ID_BITS]), 
		.full(col_id_full[11]), // output full 
		.empty(col_id_empty[11]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_11 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[11]), // input wr_en 
		.re(row_id_rd_en[11]), // input rd_en 
		.dout(row_id_out[((11+1)*`ROW_ID_BITS)-1:11*`ROW_ID_BITS]), 
		.full(row_id_full[11]), // output full 
		.empty(row_id_empty[11]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_12 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[12]), // input wr_en 
		.re(mat_val_rd_en[12]), // input rd_en 
		.dout(mat_val_out[((12+1)*`MAT_VAL_BITS)-1:12*`MAT_VAL_BITS]), 
		.full(mat_val_full[12]), // output full 
		.empty(mat_val_empty[12]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_12 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[12]), // input wr_en 
		.re(col_id_rd_en[12]), // input rd_en 
		.dout(col_id_out[((12+1)*`COL_ID_BITS)-1:12*`COL_ID_BITS]), 
		.full(col_id_full[12]), // output full 
		.empty(col_id_empty[12]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_12 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[12]), // input wr_en 
		.re(row_id_rd_en[12]), // input rd_en 
		.dout(row_id_out[((12+1)*`ROW_ID_BITS)-1:12*`ROW_ID_BITS]), 
		.full(row_id_full[12]), // output full 
		.empty(row_id_empty[12]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_13 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[13]), // input wr_en 
		.re(mat_val_rd_en[13]), // input rd_en 
		.dout(mat_val_out[((13+1)*`MAT_VAL_BITS)-1:13*`MAT_VAL_BITS]), 
		.full(mat_val_full[13]), // output full 
		.empty(mat_val_empty[13]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_13 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[13]), // input wr_en 
		.re(col_id_rd_en[13]), // input rd_en 
		.dout(col_id_out[((13+1)*`COL_ID_BITS)-1:13*`COL_ID_BITS]), 
		.full(col_id_full[13]), // output full 
		.empty(col_id_empty[13]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_13 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[13]), // input wr_en 
		.re(row_id_rd_en[13]), // input rd_en 
		.dout(row_id_out[((13+1)*`ROW_ID_BITS)-1:13*`ROW_ID_BITS]), 
		.full(row_id_full[13]), // output full 
		.empty(row_id_empty[13]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_14 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[14]), // input wr_en 
		.re(mat_val_rd_en[14]), // input rd_en 
		.dout(mat_val_out[((14+1)*`MAT_VAL_BITS)-1:14*`MAT_VAL_BITS]), 
		.full(mat_val_full[14]), // output full 
		.empty(mat_val_empty[14]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_14 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[14]), // input wr_en 
		.re(col_id_rd_en[14]), // input rd_en 
		.dout(col_id_out[((14+1)*`COL_ID_BITS)-1:14*`COL_ID_BITS]), 
		.full(col_id_full[14]), // output full 
		.empty(col_id_empty[14]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_14 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[14]), // input wr_en 
		.re(row_id_rd_en[14]), // input rd_en 
		.dout(row_id_out[((14+1)*`ROW_ID_BITS)-1:14*`ROW_ID_BITS]), 
		.full(row_id_full[14]), // output full 
		.empty(row_id_empty[14]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_15 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[15]), // input wr_en 
		.re(mat_val_rd_en[15]), // input rd_en 
		.dout(mat_val_out[((15+1)*`MAT_VAL_BITS)-1:15*`MAT_VAL_BITS]), 
		.full(mat_val_full[15]), // output full 
		.empty(mat_val_empty[15]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_15 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[15]), // input wr_en 
		.re(col_id_rd_en[15]), // input rd_en 
		.dout(col_id_out[((15+1)*`COL_ID_BITS)-1:15*`COL_ID_BITS]), 
		.full(col_id_full[15]), // output full 
		.empty(col_id_empty[15]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_15 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[15]), // input wr_en 
		.re(row_id_rd_en[15]), // input rd_en 
		.dout(row_id_out[((15+1)*`ROW_ID_BITS)-1:15*`ROW_ID_BITS]), 
		.full(row_id_full[15]), // output full 
		.empty(row_id_empty[15]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_16 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[16]), // input wr_en 
		.re(mat_val_rd_en[16]), // input rd_en 
		.dout(mat_val_out[((16+1)*`MAT_VAL_BITS)-1:16*`MAT_VAL_BITS]), 
		.full(mat_val_full[16]), // output full 
		.empty(mat_val_empty[16]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_16 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[16]), // input wr_en 
		.re(col_id_rd_en[16]), // input rd_en 
		.dout(col_id_out[((16+1)*`COL_ID_BITS)-1:16*`COL_ID_BITS]), 
		.full(col_id_full[16]), // output full 
		.empty(col_id_empty[16]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_16 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[16]), // input wr_en 
		.re(row_id_rd_en[16]), // input rd_en 
		.dout(row_id_out[((16+1)*`ROW_ID_BITS)-1:16*`ROW_ID_BITS]), 
		.full(row_id_full[16]), // output full 
		.empty(row_id_empty[16]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_17 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[17]), // input wr_en 
		.re(mat_val_rd_en[17]), // input rd_en 
		.dout(mat_val_out[((17+1)*`MAT_VAL_BITS)-1:17*`MAT_VAL_BITS]), 
		.full(mat_val_full[17]), // output full 
		.empty(mat_val_empty[17]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_17 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[17]), // input wr_en 
		.re(col_id_rd_en[17]), // input rd_en 
		.dout(col_id_out[((17+1)*`COL_ID_BITS)-1:17*`COL_ID_BITS]), 
		.full(col_id_full[17]), // output full 
		.empty(col_id_empty[17]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_17 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[17]), // input wr_en 
		.re(row_id_rd_en[17]), // input rd_en 
		.dout(row_id_out[((17+1)*`ROW_ID_BITS)-1:17*`ROW_ID_BITS]), 
		.full(row_id_full[17]), // output full 
		.empty(row_id_empty[17]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_18 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[18]), // input wr_en 
		.re(mat_val_rd_en[18]), // input rd_en 
		.dout(mat_val_out[((18+1)*`MAT_VAL_BITS)-1:18*`MAT_VAL_BITS]), 
		.full(mat_val_full[18]), // output full 
		.empty(mat_val_empty[18]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_18 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[18]), // input wr_en 
		.re(col_id_rd_en[18]), // input rd_en 
		.dout(col_id_out[((18+1)*`COL_ID_BITS)-1:18*`COL_ID_BITS]), 
		.full(col_id_full[18]), // output full 
		.empty(col_id_empty[18]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_18 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[18]), // input wr_en 
		.re(row_id_rd_en[18]), // input rd_en 
		.dout(row_id_out[((18+1)*`ROW_ID_BITS)-1:18*`ROW_ID_BITS]), 
		.full(row_id_full[18]), // output full 
		.empty(row_id_empty[18]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_19 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[19]), // input wr_en 
		.re(mat_val_rd_en[19]), // input rd_en 
		.dout(mat_val_out[((19+1)*`MAT_VAL_BITS)-1:19*`MAT_VAL_BITS]), 
		.full(mat_val_full[19]), // output full 
		.empty(mat_val_empty[19]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_19 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[19]), // input wr_en 
		.re(col_id_rd_en[19]), // input rd_en 
		.dout(col_id_out[((19+1)*`COL_ID_BITS)-1:19*`COL_ID_BITS]), 
		.full(col_id_full[19]), // output full 
		.empty(col_id_empty[19]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_19 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[19]), // input wr_en 
		.re(row_id_rd_en[19]), // input rd_en 
		.dout(row_id_out[((19+1)*`ROW_ID_BITS)-1:19*`ROW_ID_BITS]), 
		.full(row_id_full[19]), // output full 
		.empty(row_id_empty[19]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_20 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[20]), // input wr_en 
		.re(mat_val_rd_en[20]), // input rd_en 
		.dout(mat_val_out[((20+1)*`MAT_VAL_BITS)-1:20*`MAT_VAL_BITS]), 
		.full(mat_val_full[20]), // output full 
		.empty(mat_val_empty[20]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_20 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[20]), // input wr_en 
		.re(col_id_rd_en[20]), // input rd_en 
		.dout(col_id_out[((20+1)*`COL_ID_BITS)-1:20*`COL_ID_BITS]), 
		.full(col_id_full[20]), // output full 
		.empty(col_id_empty[20]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_20 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[20]), // input wr_en 
		.re(row_id_rd_en[20]), // input rd_en 
		.dout(row_id_out[((20+1)*`ROW_ID_BITS)-1:20*`ROW_ID_BITS]), 
		.full(row_id_full[20]), // output full 
		.empty(row_id_empty[20]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_21 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[21]), // input wr_en 
		.re(mat_val_rd_en[21]), // input rd_en 
		.dout(mat_val_out[((21+1)*`MAT_VAL_BITS)-1:21*`MAT_VAL_BITS]), 
		.full(mat_val_full[21]), // output full 
		.empty(mat_val_empty[21]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_21 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[21]), // input wr_en 
		.re(col_id_rd_en[21]), // input rd_en 
		.dout(col_id_out[((21+1)*`COL_ID_BITS)-1:21*`COL_ID_BITS]), 
		.full(col_id_full[21]), // output full 
		.empty(col_id_empty[21]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_21 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[21]), // input wr_en 
		.re(row_id_rd_en[21]), // input rd_en 
		.dout(row_id_out[((21+1)*`ROW_ID_BITS)-1:21*`ROW_ID_BITS]), 
		.full(row_id_full[21]), // output full 
		.empty(row_id_empty[21]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_22 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[22]), // input wr_en 
		.re(mat_val_rd_en[22]), // input rd_en 
		.dout(mat_val_out[((22+1)*`MAT_VAL_BITS)-1:22*`MAT_VAL_BITS]), 
		.full(mat_val_full[22]), // output full 
		.empty(mat_val_empty[22]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_22 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[22]), // input wr_en 
		.re(col_id_rd_en[22]), // input rd_en 
		.dout(col_id_out[((22+1)*`COL_ID_BITS)-1:22*`COL_ID_BITS]), 
		.full(col_id_full[22]), // output full 
		.empty(col_id_empty[22]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_22 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[22]), // input wr_en 
		.re(row_id_rd_en[22]), // input rd_en 
		.dout(row_id_out[((22+1)*`ROW_ID_BITS)-1:22*`ROW_ID_BITS]), 
		.full(row_id_full[22]), // output full 
		.empty(row_id_empty[22]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_23 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[23]), // input wr_en 
		.re(mat_val_rd_en[23]), // input rd_en 
		.dout(mat_val_out[((23+1)*`MAT_VAL_BITS)-1:23*`MAT_VAL_BITS]), 
		.full(mat_val_full[23]), // output full 
		.empty(mat_val_empty[23]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_23 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[23]), // input wr_en 
		.re(col_id_rd_en[23]), // input rd_en 
		.dout(col_id_out[((23+1)*`COL_ID_BITS)-1:23*`COL_ID_BITS]), 
		.full(col_id_full[23]), // output full 
		.empty(col_id_empty[23]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_23 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[23]), // input wr_en 
		.re(row_id_rd_en[23]), // input rd_en 
		.dout(row_id_out[((23+1)*`ROW_ID_BITS)-1:23*`ROW_ID_BITS]), 
		.full(row_id_full[23]), // output full 
		.empty(row_id_empty[23]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_24 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[24]), // input wr_en 
		.re(mat_val_rd_en[24]), // input rd_en 
		.dout(mat_val_out[((24+1)*`MAT_VAL_BITS)-1:24*`MAT_VAL_BITS]), 
		.full(mat_val_full[24]), // output full 
		.empty(mat_val_empty[24]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_24 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[24]), // input wr_en 
		.re(col_id_rd_en[24]), // input rd_en 
		.dout(col_id_out[((24+1)*`COL_ID_BITS)-1:24*`COL_ID_BITS]), 
		.full(col_id_full[24]), // output full 
		.empty(col_id_empty[24]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_24 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[24]), // input wr_en 
		.re(row_id_rd_en[24]), // input rd_en 
		.dout(row_id_out[((24+1)*`ROW_ID_BITS)-1:24*`ROW_ID_BITS]), 
		.full(row_id_full[24]), // output full 
		.empty(row_id_empty[24]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_25 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[25]), // input wr_en 
		.re(mat_val_rd_en[25]), // input rd_en 
		.dout(mat_val_out[((25+1)*`MAT_VAL_BITS)-1:25*`MAT_VAL_BITS]), 
		.full(mat_val_full[25]), // output full 
		.empty(mat_val_empty[25]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_25 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[25]), // input wr_en 
		.re(col_id_rd_en[25]), // input rd_en 
		.dout(col_id_out[((25+1)*`COL_ID_BITS)-1:25*`COL_ID_BITS]), 
		.full(col_id_full[25]), // output full 
		.empty(col_id_empty[25]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_25 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[25]), // input wr_en 
		.re(row_id_rd_en[25]), // input rd_en 
		.dout(row_id_out[((25+1)*`ROW_ID_BITS)-1:25*`ROW_ID_BITS]), 
		.full(row_id_full[25]), // output full 
		.empty(row_id_empty[25]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_26 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[26]), // input wr_en 
		.re(mat_val_rd_en[26]), // input rd_en 
		.dout(mat_val_out[((26+1)*`MAT_VAL_BITS)-1:26*`MAT_VAL_BITS]), 
		.full(mat_val_full[26]), // output full 
		.empty(mat_val_empty[26]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_26 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[26]), // input wr_en 
		.re(col_id_rd_en[26]), // input rd_en 
		.dout(col_id_out[((26+1)*`COL_ID_BITS)-1:26*`COL_ID_BITS]), 
		.full(col_id_full[26]), // output full 
		.empty(col_id_empty[26]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_26 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[26]), // input wr_en 
		.re(row_id_rd_en[26]), // input rd_en 
		.dout(row_id_out[((26+1)*`ROW_ID_BITS)-1:26*`ROW_ID_BITS]), 
		.full(row_id_full[26]), // output full 
		.empty(row_id_empty[26]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_27 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[27]), // input wr_en 
		.re(mat_val_rd_en[27]), // input rd_en 
		.dout(mat_val_out[((27+1)*`MAT_VAL_BITS)-1:27*`MAT_VAL_BITS]), 
		.full(mat_val_full[27]), // output full 
		.empty(mat_val_empty[27]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_27 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[27]), // input wr_en 
		.re(col_id_rd_en[27]), // input rd_en 
		.dout(col_id_out[((27+1)*`COL_ID_BITS)-1:27*`COL_ID_BITS]), 
		.full(col_id_full[27]), // output full 
		.empty(col_id_empty[27]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_27 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[27]), // input wr_en 
		.re(row_id_rd_en[27]), // input rd_en 
		.dout(row_id_out[((27+1)*`ROW_ID_BITS)-1:27*`ROW_ID_BITS]), 
		.full(row_id_full[27]), // output full 
		.empty(row_id_empty[27]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_28 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[28]), // input wr_en 
		.re(mat_val_rd_en[28]), // input rd_en 
		.dout(mat_val_out[((28+1)*`MAT_VAL_BITS)-1:28*`MAT_VAL_BITS]), 
		.full(mat_val_full[28]), // output full 
		.empty(mat_val_empty[28]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_28 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[28]), // input wr_en 
		.re(col_id_rd_en[28]), // input rd_en 
		.dout(col_id_out[((28+1)*`COL_ID_BITS)-1:28*`COL_ID_BITS]), 
		.full(col_id_full[28]), // output full 
		.empty(col_id_empty[28]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_28 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[28]), // input wr_en 
		.re(row_id_rd_en[28]), // input rd_en 
		.dout(row_id_out[((28+1)*`ROW_ID_BITS)-1:28*`ROW_ID_BITS]), 
		.full(row_id_full[28]), // output full 
		.empty(row_id_empty[28]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_29 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[29]), // input wr_en 
		.re(mat_val_rd_en[29]), // input rd_en 
		.dout(mat_val_out[((29+1)*`MAT_VAL_BITS)-1:29*`MAT_VAL_BITS]), 
		.full(mat_val_full[29]), // output full 
		.empty(mat_val_empty[29]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_29 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[29]), // input wr_en 
		.re(col_id_rd_en[29]), // input rd_en 
		.dout(col_id_out[((29+1)*`COL_ID_BITS)-1:29*`COL_ID_BITS]), 
		.full(col_id_full[29]), // output full 
		.empty(col_id_empty[29]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_29 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[29]), // input wr_en 
		.re(row_id_rd_en[29]), // input rd_en 
		.dout(row_id_out[((29+1)*`ROW_ID_BITS)-1:29*`ROW_ID_BITS]), 
		.full(row_id_full[29]), // output full 
		.empty(row_id_empty[29]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_30 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[30]), // input wr_en 
		.re(mat_val_rd_en[30]), // input rd_en 
		.dout(mat_val_out[((30+1)*`MAT_VAL_BITS)-1:30*`MAT_VAL_BITS]), 
		.full(mat_val_full[30]), // output full 
		.empty(mat_val_empty[30]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_30 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[30]), // input wr_en 
		.re(col_id_rd_en[30]), // input rd_en 
		.dout(col_id_out[((30+1)*`COL_ID_BITS)-1:30*`COL_ID_BITS]), 
		.full(col_id_full[30]), // output full 
		.empty(col_id_empty[30]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_30 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[30]), // input wr_en 
		.re(row_id_rd_en[30]), // input rd_en 
		.dout(row_id_out[((30+1)*`ROW_ID_BITS)-1:30*`ROW_ID_BITS]), 
		.full(row_id_full[30]), // output full 
		.empty(row_id_empty[30]) // output empty 
	);

	generic_fifo_sc_a #(
		.dw(MAT_VAL_ROM_DWIDTH),
		.aw(FIFO_DEPTH_BITS)
	) fifo_mat_val_31 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(mat_val_dout), 
		.we(mat_val_wr_en[31]), // input wr_en 
		.re(mat_val_rd_en[31]), // input rd_en 
		.dout(mat_val_out[((31+1)*`MAT_VAL_BITS)-1:31*`MAT_VAL_BITS]), 
		.full(mat_val_full[31]), // output full 
		.empty(mat_val_empty[31]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(COL_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_col_id_31 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(col_id_dout), 
		.we(col_id_wr_en[31]), // input wr_en 
		.re(col_id_rd_en[31]), // input rd_en 
		.dout(col_id_out[((31+1)*`COL_ID_BITS)-1:31*`COL_ID_BITS]), 
		.full(col_id_full[31]), // output full 
		.empty(col_id_empty[31]) // output empty 
	); 

	generic_fifo_sc_a #( 
		.dw(ROW_ID_ROM_DWIDTH), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_row_id_31 ( 
		.clk(clk), // input clk 
		.rst(rst), // input clk 
		.clr(0), 
		.din(row_id_dout), 
		.we(row_id_wr_en[31]), // input wr_en 
		.re(row_id_rd_en[31]), // input rd_en 
		.dout(row_id_out[((31+1)*`ROW_ID_BITS)-1:31*`ROW_ID_BITS]), 
		.full(row_id_full[31]), // output full 
		.empty(row_id_empty[31]) // output empty 
	);

	//TODO: done signal check for matrix values only. Should check for all three. Use 3 done signals and the final done is the and of all three.
	assign done = (counter >=`NUM_MAT_VALS);

	assign mat_val_full_shifted = mat_val_full>>mat_val_lane;
	assign col_id_full_shifted = col_id_full>>col_id_lane;
	assign row_id_full_shifted = row_id_full>>row_id_lane;

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			mat_val_addr <= 0;
			col_id_addr <= 0;
			row_id_addr <= 0;

			mat_val_wr_en <= 0;
			col_id_wr_en <= 0;
			row_id_wr_en <= 0;

			mat_val_lane <= 0;
			col_id_lane <= 0;
			row_id_lane <= 0;

			counter <= 0;
		end
		else begin
			if(!done) begin
				// Write matrix value into its FIFO
				if (!mat_val_full_shifted[0]) begin
					mat_val_wr_en <= (({`NUM_CHANNEL{1'b0}}) | (1<<mat_val_lane));
					mat_val_lane <= mat_val_lane + 1;
					mat_val_addr <= mat_val_addr + 1;
					counter <= counter + 1;
				end

				// Write column ID into its FIFO
				if (!col_id_full_shifted[0]) begin
					col_id_wr_en <= (({`NUM_CHANNEL{1'b0}}) | (1<<col_id_lane));
					col_id_lane <= col_id_lane + 1;
					col_id_addr <= col_id_addr + 1;
				end

				// Write row id into its FIFO
				if (!row_id_full_shifted[0]) begin
					row_id_wr_en <= (({`NUM_CHANNEL{1'b0}}) | (1<<row_id_lane));
					row_id_lane <= row_id_lane + 1;
					row_id_addr <= row_id_addr + 1;
				end
			end
			else begin
				mat_val_wr_en <= 0;
				col_id_wr_en <= 0;
				row_id_wr_en <= 0;
			end
		end
	end
endmodule


module bvb(
	input clk,
	input rst,
	input start,
	// input from column ID FIFO
	input  [(`NUM_CHANNEL*`COL_ID_BITS)-1:0] id,
	input  [`NUM_CHANNEL-1:0] id_empty,
	// input to the column ID FIFO
	output [`NUM_CHANNEL-1:0] id_rd_en,

	// vector value FIFO outputs
	output [(`NUM_CHANNEL*`VEC_VAL_BITS)-1:0] val,
	output [`NUM_CHANNEL-1:0]   val_empty,
	// input to vector value FIFO
	input  [`NUM_CHANNEL-1:0]   val_rd_en
	// output reg [`NUM_CHANNEL-1:0] id_rd_en_reg
);

	// parameter MAX_COLS = (1<<`COL_ID_BITS);

	// parameter FIFO_DEPTH = 8;
	// parameter FIFO_DEPTH_BITS = `LOG2(FIFO_DEPTH);
	parameter FIFO_DEPTH_BITS = $clog2(`FIFO_DEPTH);

	// parameter BYTES_PER_ADDR_PER_BRAM = 4;
	// parameter VEC_VAL_BYTES = `VEC_VAL_BITS/8;
	// // parameter VEC_VAL_OFFSET = `LOG2(`VEC_VAL_BITS);
	// parameter VEC_VAL_OFFSET = $clog2(`VEC_VAL_BITS);
	// parameter NUM_VEC_VALS_PER_ADDR_PER_BRAM = BYTES_PER_ADDR_PER_BRAM/VEC_VAL_BYTES;
	// parameter NUM_VEC_VALS_PER_ADDR = `NUM_VEC_VALS;
	// // parameter NUM_VEC_VALS_PER_ADDR_BITS = `LOG2(NUM_VEC_VALS_PER_ADDR);
	// parameter NUM_VEC_VALS_PER_ADDR_BITS = $clog2(`NUM_VEC_VALS);
	// parameter NUM_BRAMS = NUM_VEC_VALS_PER_ADDR/NUM_VEC_VALS_PER_ADDR_PER_BRAM;
	// parameter NUM_ADDR_VEC_RAM = `NUM_VEC_VALS/NUM_VEC_VALS_PER_ADDR;
	// // parameter AWIDTH = `LOG2(NUM_ADDR);
	// parameter AWIDTH_VEC_RAM = 1; //$clog2(1);
	// parameter DWIDTH_VEC_RAM = NUM_VEC_VALS_PER_ADDR*`VEC_VAL_BITS;

	// parameter COUNTER_BITS = AWIDTH_VEC_RAM;
	parameter COUNTER_MAX  = ((1 << `COUNTER_BITS) - 1) & (`NUM_VEC_VALS_PER_ADDR!=`NUM_VEC_VALS);

	// parameter LOCAL_ID_BITS = NUM_VEC_VALS_PER_ADDR_BITS;

	reg [`COUNTER_BITS-1:0] counter;
	reg [`COUNTER_BITS-1:0] counter_delay;
	// // reg counter_wait;

	reg [`NUM_CHANNEL-1:0] val_wr_en;
	wire [`NUM_CHANNEL-1:0] val_full;

	wire [`BVB_DWIDTH-1:0] ram_out;

	wire [(`NUM_CHANNEL*`VEC_VAL_BITS)-1:0] fifo_in_val;

	reg [(`LOCAL_ID_BITS*`NUM_CHANNEL)-1:0] local_id;
	reg [`COL_ID_BITS-1:0] mask;

	wire [`BVB_DWIDTH-1:0] din_nc;

	reg [`NUM_CHANNEL-1:0] id_rd_en_reg;

	spram #(
	`ifdef SIMULATION
		.INIT("/home/aatman/Desktop/SpMV/src/coe/vec_val.txt"),
	`endif
		.AWIDTH(1),  // Replace this with `BVB_AWIDTH when NUM_ADDR become >= 2
		.NUM_WORDS(2),  // Replace this with NUM_ADDR_VEC_RAM
		.DWIDTH(`BVB_DWIDTH)
		) vector_ram (
			.clk(clk), 
			.wren(0),
			.address(counter_delay),  
			.din(din_nc), 
			.dout(ram_out)
		);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_0 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(0+1)*`VEC_VAL_BITS-1:0*`VEC_VAL_BITS]), 
		.we(val_wr_en[0]), // input wr_en 
		.re(val_rd_en[0]), // input rd_en 
		.dout(val[(0+1)*`VEC_VAL_BITS-1:0*`VEC_VAL_BITS]), 
		.full(val_full[0]), // output full 
		.empty(val_empty[0]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_1 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(1+1)*`VEC_VAL_BITS-1:1*`VEC_VAL_BITS]), 
		.we(val_wr_en[1]), // input wr_en 
		.re(val_rd_en[1]), // input rd_en 
		.dout(val[(1+1)*`VEC_VAL_BITS-1:1*`VEC_VAL_BITS]), 
		.full(val_full[1]), // output full 
		.empty(val_empty[1]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_2 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(2+1)*`VEC_VAL_BITS-1:2*`VEC_VAL_BITS]), 
		.we(val_wr_en[2]), // input wr_en 
		.re(val_rd_en[2]), // input rd_en 
		.dout(val[(2+1)*`VEC_VAL_BITS-1:2*`VEC_VAL_BITS]), 
		.full(val_full[2]), // output full 
		.empty(val_empty[2]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_3 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(3+1)*`VEC_VAL_BITS-1:3*`VEC_VAL_BITS]), 
		.we(val_wr_en[3]), // input wr_en 
		.re(val_rd_en[3]), // input rd_en 
		.dout(val[(3+1)*`VEC_VAL_BITS-1:3*`VEC_VAL_BITS]), 
		.full(val_full[3]), // output full 
		.empty(val_empty[3]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_4 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(4+1)*`VEC_VAL_BITS-1:4*`VEC_VAL_BITS]), 
		.we(val_wr_en[4]), // input wr_en 
		.re(val_rd_en[4]), // input rd_en 
		.dout(val[(4+1)*`VEC_VAL_BITS-1:4*`VEC_VAL_BITS]), 
		.full(val_full[4]), // output full 
		.empty(val_empty[4]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_5 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(5+1)*`VEC_VAL_BITS-1:5*`VEC_VAL_BITS]), 
		.we(val_wr_en[5]), // input wr_en 
		.re(val_rd_en[5]), // input rd_en 
		.dout(val[(5+1)*`VEC_VAL_BITS-1:5*`VEC_VAL_BITS]), 
		.full(val_full[5]), // output full 
		.empty(val_empty[5]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_6 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(6+1)*`VEC_VAL_BITS-1:6*`VEC_VAL_BITS]), 
		.we(val_wr_en[6]), // input wr_en 
		.re(val_rd_en[6]), // input rd_en 
		.dout(val[(6+1)*`VEC_VAL_BITS-1:6*`VEC_VAL_BITS]), 
		.full(val_full[6]), // output full 
		.empty(val_empty[6]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_7 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(7+1)*`VEC_VAL_BITS-1:7*`VEC_VAL_BITS]), 
		.we(val_wr_en[7]), // input wr_en 
		.re(val_rd_en[7]), // input rd_en 
		.dout(val[(7+1)*`VEC_VAL_BITS-1:7*`VEC_VAL_BITS]), 
		.full(val_full[7]), // output full 
		.empty(val_empty[7]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_8 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(8+1)*`VEC_VAL_BITS-1:8*`VEC_VAL_BITS]), 
		.we(val_wr_en[8]), // input wr_en 
		.re(val_rd_en[8]), // input rd_en 
		.dout(val[(8+1)*`VEC_VAL_BITS-1:8*`VEC_VAL_BITS]), 
		.full(val_full[8]), // output full 
		.empty(val_empty[8]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_9 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(9+1)*`VEC_VAL_BITS-1:9*`VEC_VAL_BITS]), 
		.we(val_wr_en[9]), // input wr_en 
		.re(val_rd_en[9]), // input rd_en 
		.dout(val[(9+1)*`VEC_VAL_BITS-1:9*`VEC_VAL_BITS]), 
		.full(val_full[9]), // output full 
		.empty(val_empty[9]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_10 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(10+1)*`VEC_VAL_BITS-1:10*`VEC_VAL_BITS]), 
		.we(val_wr_en[10]), // input wr_en 
		.re(val_rd_en[10]), // input rd_en 
		.dout(val[(10+1)*`VEC_VAL_BITS-1:10*`VEC_VAL_BITS]), 
		.full(val_full[10]), // output full 
		.empty(val_empty[10]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_11 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(11+1)*`VEC_VAL_BITS-1:11*`VEC_VAL_BITS]), 
		.we(val_wr_en[11]), // input wr_en 
		.re(val_rd_en[11]), // input rd_en 
		.dout(val[(11+1)*`VEC_VAL_BITS-1:11*`VEC_VAL_BITS]), 
		.full(val_full[11]), // output full 
		.empty(val_empty[11]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_12 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(12+1)*`VEC_VAL_BITS-1:12*`VEC_VAL_BITS]), 
		.we(val_wr_en[12]), // input wr_en 
		.re(val_rd_en[12]), // input rd_en 
		.dout(val[(12+1)*`VEC_VAL_BITS-1:12*`VEC_VAL_BITS]), 
		.full(val_full[12]), // output full 
		.empty(val_empty[12]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_13 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(13+1)*`VEC_VAL_BITS-1:13*`VEC_VAL_BITS]), 
		.we(val_wr_en[13]), // input wr_en 
		.re(val_rd_en[13]), // input rd_en 
		.dout(val[(13+1)*`VEC_VAL_BITS-1:13*`VEC_VAL_BITS]), 
		.full(val_full[13]), // output full 
		.empty(val_empty[13]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_14 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(14+1)*`VEC_VAL_BITS-1:14*`VEC_VAL_BITS]), 
		.we(val_wr_en[14]), // input wr_en 
		.re(val_rd_en[14]), // input rd_en 
		.dout(val[(14+1)*`VEC_VAL_BITS-1:14*`VEC_VAL_BITS]), 
		.full(val_full[14]), // output full 
		.empty(val_empty[14]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_15 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(15+1)*`VEC_VAL_BITS-1:15*`VEC_VAL_BITS]), 
		.we(val_wr_en[15]), // input wr_en 
		.re(val_rd_en[15]), // input rd_en 
		.dout(val[(15+1)*`VEC_VAL_BITS-1:15*`VEC_VAL_BITS]), 
		.full(val_full[15]), // output full 
		.empty(val_empty[15]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_16 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(16+1)*`VEC_VAL_BITS-1:16*`VEC_VAL_BITS]), 
		.we(val_wr_en[16]), // input wr_en 
		.re(val_rd_en[16]), // input rd_en 
		.dout(val[(16+1)*`VEC_VAL_BITS-1:16*`VEC_VAL_BITS]), 
		.full(val_full[16]), // output full 
		.empty(val_empty[16]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_17 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(17+1)*`VEC_VAL_BITS-1:17*`VEC_VAL_BITS]), 
		.we(val_wr_en[17]), // input wr_en 
		.re(val_rd_en[17]), // input rd_en 
		.dout(val[(17+1)*`VEC_VAL_BITS-1:17*`VEC_VAL_BITS]), 
		.full(val_full[17]), // output full 
		.empty(val_empty[17]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_18 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(18+1)*`VEC_VAL_BITS-1:18*`VEC_VAL_BITS]), 
		.we(val_wr_en[18]), // input wr_en 
		.re(val_rd_en[18]), // input rd_en 
		.dout(val[(18+1)*`VEC_VAL_BITS-1:18*`VEC_VAL_BITS]), 
		.full(val_full[18]), // output full 
		.empty(val_empty[18]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_19 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(19+1)*`VEC_VAL_BITS-1:19*`VEC_VAL_BITS]), 
		.we(val_wr_en[19]), // input wr_en 
		.re(val_rd_en[19]), // input rd_en 
		.dout(val[(19+1)*`VEC_VAL_BITS-1:19*`VEC_VAL_BITS]), 
		.full(val_full[19]), // output full 
		.empty(val_empty[19]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_20 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(20+1)*`VEC_VAL_BITS-1:20*`VEC_VAL_BITS]), 
		.we(val_wr_en[20]), // input wr_en 
		.re(val_rd_en[20]), // input rd_en 
		.dout(val[(20+1)*`VEC_VAL_BITS-1:20*`VEC_VAL_BITS]), 
		.full(val_full[20]), // output full 
		.empty(val_empty[20]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_21 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(21+1)*`VEC_VAL_BITS-1:21*`VEC_VAL_BITS]), 
		.we(val_wr_en[21]), // input wr_en 
		.re(val_rd_en[21]), // input rd_en 
		.dout(val[(21+1)*`VEC_VAL_BITS-1:21*`VEC_VAL_BITS]), 
		.full(val_full[21]), // output full 
		.empty(val_empty[21]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_22 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(22+1)*`VEC_VAL_BITS-1:22*`VEC_VAL_BITS]), 
		.we(val_wr_en[22]), // input wr_en 
		.re(val_rd_en[22]), // input rd_en 
		.dout(val[(22+1)*`VEC_VAL_BITS-1:22*`VEC_VAL_BITS]), 
		.full(val_full[22]), // output full 
		.empty(val_empty[22]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_23 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(23+1)*`VEC_VAL_BITS-1:23*`VEC_VAL_BITS]), 
		.we(val_wr_en[23]), // input wr_en 
		.re(val_rd_en[23]), // input rd_en 
		.dout(val[(23+1)*`VEC_VAL_BITS-1:23*`VEC_VAL_BITS]), 
		.full(val_full[23]), // output full 
		.empty(val_empty[23]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_24 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(24+1)*`VEC_VAL_BITS-1:24*`VEC_VAL_BITS]), 
		.we(val_wr_en[24]), // input wr_en 
		.re(val_rd_en[24]), // input rd_en 
		.dout(val[(24+1)*`VEC_VAL_BITS-1:24*`VEC_VAL_BITS]), 
		.full(val_full[24]), // output full 
		.empty(val_empty[24]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_25 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(25+1)*`VEC_VAL_BITS-1:25*`VEC_VAL_BITS]), 
		.we(val_wr_en[25]), // input wr_en 
		.re(val_rd_en[25]), // input rd_en 
		.dout(val[(25+1)*`VEC_VAL_BITS-1:25*`VEC_VAL_BITS]), 
		.full(val_full[25]), // output full 
		.empty(val_empty[25]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_26 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(26+1)*`VEC_VAL_BITS-1:26*`VEC_VAL_BITS]), 
		.we(val_wr_en[26]), // input wr_en 
		.re(val_rd_en[26]), // input rd_en 
		.dout(val[(26+1)*`VEC_VAL_BITS-1:26*`VEC_VAL_BITS]), 
		.full(val_full[26]), // output full 
		.empty(val_empty[26]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_27 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(27+1)*`VEC_VAL_BITS-1:27*`VEC_VAL_BITS]), 
		.we(val_wr_en[27]), // input wr_en 
		.re(val_rd_en[27]), // input rd_en 
		.dout(val[(27+1)*`VEC_VAL_BITS-1:27*`VEC_VAL_BITS]), 
		.full(val_full[27]), // output full 
		.empty(val_empty[27]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_28 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(28+1)*`VEC_VAL_BITS-1:28*`VEC_VAL_BITS]), 
		.we(val_wr_en[28]), // input wr_en 
		.re(val_rd_en[28]), // input rd_en 
		.dout(val[(28+1)*`VEC_VAL_BITS-1:28*`VEC_VAL_BITS]), 
		.full(val_full[28]), // output full 
		.empty(val_empty[28]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_29 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(29+1)*`VEC_VAL_BITS-1:29*`VEC_VAL_BITS]), 
		.we(val_wr_en[29]), // input wr_en 
		.re(val_rd_en[29]), // input rd_en 
		.dout(val[(29+1)*`VEC_VAL_BITS-1:29*`VEC_VAL_BITS]), 
		.full(val_full[29]), // output full 
		.empty(val_empty[29]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_30 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(30+1)*`VEC_VAL_BITS-1:30*`VEC_VAL_BITS]), 
		.we(val_wr_en[30]), // input wr_en 
		.re(val_rd_en[30]), // input rd_en 
		.dout(val[(30+1)*`VEC_VAL_BITS-1:30*`VEC_VAL_BITS]), 
		.full(val_full[30]), // output full 
		.empty(val_empty[30]) // output empty 
	);

	generic_fifo_sc_a #( 
		.dw(`VEC_VAL_BITS), 
		.aw(FIFO_DEPTH_BITS) 
	) fifo_bvb_31 ( 
		.clk(clk), // input clk 
		.rst(rst), 
		.clr(0), 
		.din(fifo_in_val[(31+1)*`VEC_VAL_BITS-1:31*`VEC_VAL_BITS]), 
		.we(val_wr_en[31]), // input wr_en 
		.re(val_rd_en[31]), // input rd_en 
		.dout(val[(31+1)*`VEC_VAL_BITS-1:31*`VEC_VAL_BITS]), 
		.full(val_full[31]), // output full 
		.empty(val_empty[31]) // output empty 
	);

 
	always @ (posedge clk) begin
		id_rd_en_reg <= id_rd_en;
	end

	assign id_rd_en[0] = start & (counter == id[(0*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(0*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[0]) & (~val_full[0]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[0]) begin 
			local_id[(0+1)*`LOCAL_ID_BITS-1:0*`LOCAL_ID_BITS] <= (id[(0+1)*`COL_ID_BITS-1:0*`COL_ID_BITS] & mask); 
			val_wr_en[0] <= 1; 
		end 
		else begin 
			val_wr_en[0] <= 0; 
		end 
	end

	assign id_rd_en[1] = start & (counter == id[(1*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(1*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[1]) & (~val_full[1]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[1]) begin 
			local_id[(1+1)*`LOCAL_ID_BITS-1:1*`LOCAL_ID_BITS] <= (id[(1+1)*`COL_ID_BITS-1:1*`COL_ID_BITS] & mask); 
			val_wr_en[1] <= 1; 
		end 
		else begin 
			val_wr_en[1] <= 0; 
		end 
	end

	assign id_rd_en[2] = start & (counter == id[(2*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(2*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[2]) & (~val_full[2]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[2]) begin 
			local_id[(2+1)*`LOCAL_ID_BITS-1:2*`LOCAL_ID_BITS] <= (id[(2+1)*`COL_ID_BITS-1:2*`COL_ID_BITS] & mask); 
			val_wr_en[2] <= 1; 
		end 
		else begin 
			val_wr_en[2] <= 0; 
		end 
	end

	assign id_rd_en[3] = start & (counter == id[(3*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(3*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[3]) & (~val_full[3]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[3]) begin 
			local_id[(3+1)*`LOCAL_ID_BITS-1:3*`LOCAL_ID_BITS] <= (id[(3+1)*`COL_ID_BITS-1:3*`COL_ID_BITS] & mask); 
			val_wr_en[3] <= 1; 
		end 
		else begin 
			val_wr_en[3] <= 0; 
		end 
	end

	assign id_rd_en[4] = start & (counter == id[(4*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(4*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[4]) & (~val_full[4]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[4]) begin 
			local_id[(4+1)*`LOCAL_ID_BITS-1:4*`LOCAL_ID_BITS] <= (id[(4+1)*`COL_ID_BITS-1:4*`COL_ID_BITS] & mask); 
			val_wr_en[4] <= 1; 
		end 
		else begin 
			val_wr_en[4] <= 0; 
		end 
	end

	assign id_rd_en[5] = start & (counter == id[(5*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(5*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[5]) & (~val_full[5]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[5]) begin 
			local_id[(5+1)*`LOCAL_ID_BITS-1:5*`LOCAL_ID_BITS] <= (id[(5+1)*`COL_ID_BITS-1:5*`COL_ID_BITS] & mask); 
			val_wr_en[5] <= 1; 
		end 
		else begin 
			val_wr_en[5] <= 0; 
		end 
	end

	assign id_rd_en[6] = start & (counter == id[(6*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(6*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[6]) & (~val_full[6]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[6]) begin 
			local_id[(6+1)*`LOCAL_ID_BITS-1:6*`LOCAL_ID_BITS] <= (id[(6+1)*`COL_ID_BITS-1:6*`COL_ID_BITS] & mask); 
			val_wr_en[6] <= 1; 
		end 
		else begin 
			val_wr_en[6] <= 0; 
		end 
	end

	assign id_rd_en[7] = start & (counter == id[(7*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(7*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[7]) & (~val_full[7]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[7]) begin 
			local_id[(7+1)*`LOCAL_ID_BITS-1:7*`LOCAL_ID_BITS] <= (id[(7+1)*`COL_ID_BITS-1:7*`COL_ID_BITS] & mask); 
			val_wr_en[7] <= 1; 
		end 
		else begin 
			val_wr_en[7] <= 0; 
		end 
	end

	assign id_rd_en[8] = start & (counter == id[(8*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(8*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[8]) & (~val_full[8]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[8]) begin 
			local_id[(8+1)*`LOCAL_ID_BITS-1:8*`LOCAL_ID_BITS] <= (id[(8+1)*`COL_ID_BITS-1:8*`COL_ID_BITS] & mask); 
			val_wr_en[8] <= 1; 
		end 
		else begin 
			val_wr_en[8] <= 0; 
		end 
	end

	assign id_rd_en[9] = start & (counter == id[(9*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(9*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[9]) & (~val_full[9]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[9]) begin 
			local_id[(9+1)*`LOCAL_ID_BITS-1:9*`LOCAL_ID_BITS] <= (id[(9+1)*`COL_ID_BITS-1:9*`COL_ID_BITS] & mask); 
			val_wr_en[9] <= 1; 
		end 
		else begin 
			val_wr_en[9] <= 0; 
		end 
	end

	assign id_rd_en[10] = start & (counter == id[(10*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(10*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[10]) & (~val_full[10]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[10]) begin 
			local_id[(10+1)*`LOCAL_ID_BITS-1:10*`LOCAL_ID_BITS] <= (id[(10+1)*`COL_ID_BITS-1:10*`COL_ID_BITS] & mask); 
			val_wr_en[10] <= 1; 
		end 
		else begin 
			val_wr_en[10] <= 0; 
		end 
	end

	assign id_rd_en[11] = start & (counter == id[(11*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(11*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[11]) & (~val_full[11]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[11]) begin 
			local_id[(11+1)*`LOCAL_ID_BITS-1:11*`LOCAL_ID_BITS] <= (id[(11+1)*`COL_ID_BITS-1:11*`COL_ID_BITS] & mask); 
			val_wr_en[11] <= 1; 
		end 
		else begin 
			val_wr_en[11] <= 0; 
		end 
	end

	assign id_rd_en[12] = start & (counter == id[(12*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(12*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[12]) & (~val_full[12]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[12]) begin 
			local_id[(12+1)*`LOCAL_ID_BITS-1:12*`LOCAL_ID_BITS] <= (id[(12+1)*`COL_ID_BITS-1:12*`COL_ID_BITS] & mask); 
			val_wr_en[12] <= 1; 
		end 
		else begin 
			val_wr_en[12] <= 0; 
		end 
	end

	assign id_rd_en[13] = start & (counter == id[(13*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(13*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[13]) & (~val_full[13]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[13]) begin 
			local_id[(13+1)*`LOCAL_ID_BITS-1:13*`LOCAL_ID_BITS] <= (id[(13+1)*`COL_ID_BITS-1:13*`COL_ID_BITS] & mask); 
			val_wr_en[13] <= 1; 
		end 
		else begin 
			val_wr_en[13] <= 0; 
		end 
	end

	assign id_rd_en[14] = start & (counter == id[(14*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(14*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[14]) & (~val_full[14]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[14]) begin 
			local_id[(14+1)*`LOCAL_ID_BITS-1:14*`LOCAL_ID_BITS] <= (id[(14+1)*`COL_ID_BITS-1:14*`COL_ID_BITS] & mask); 
			val_wr_en[14] <= 1; 
		end 
		else begin 
			val_wr_en[14] <= 0; 
		end 
	end

	assign id_rd_en[15] = start & (counter == id[(15*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(15*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[15]) & (~val_full[15]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[15]) begin 
			local_id[(15+1)*`LOCAL_ID_BITS-1:15*`LOCAL_ID_BITS] <= (id[(15+1)*`COL_ID_BITS-1:15*`COL_ID_BITS] & mask); 
			val_wr_en[15] <= 1; 
		end 
		else begin 
			val_wr_en[15] <= 0; 
		end 
	end

	assign id_rd_en[16] = start & (counter == id[(16*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(16*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[16]) & (~val_full[16]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[16]) begin 
			local_id[(16+1)*`LOCAL_ID_BITS-1:16*`LOCAL_ID_BITS] <= (id[(16+1)*`COL_ID_BITS-1:16*`COL_ID_BITS] & mask); 
			val_wr_en[16] <= 1; 
		end 
		else begin 
			val_wr_en[16] <= 0; 
		end 
	end

	assign id_rd_en[17] = start & (counter == id[(17*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(17*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[17]) & (~val_full[17]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[17]) begin 
			local_id[(17+1)*`LOCAL_ID_BITS-1:17*`LOCAL_ID_BITS] <= (id[(17+1)*`COL_ID_BITS-1:17*`COL_ID_BITS] & mask); 
			val_wr_en[17] <= 1; 
		end 
		else begin 
			val_wr_en[17] <= 0; 
		end 
	end

	assign id_rd_en[18] = start & (counter == id[(18*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(18*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[18]) & (~val_full[18]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[18]) begin 
			local_id[(18+1)*`LOCAL_ID_BITS-1:18*`LOCAL_ID_BITS] <= (id[(18+1)*`COL_ID_BITS-1:18*`COL_ID_BITS] & mask); 
			val_wr_en[18] <= 1; 
		end 
		else begin 
			val_wr_en[18] <= 0; 
		end 
	end

	assign id_rd_en[19] = start & (counter == id[(19*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(19*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[19]) & (~val_full[19]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[19]) begin 
			local_id[(19+1)*`LOCAL_ID_BITS-1:19*`LOCAL_ID_BITS] <= (id[(19+1)*`COL_ID_BITS-1:19*`COL_ID_BITS] & mask); 
			val_wr_en[19] <= 1; 
		end 
		else begin 
			val_wr_en[19] <= 0; 
		end 
	end

	assign id_rd_en[20] = start & (counter == id[(20*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(20*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[20]) & (~val_full[20]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[20]) begin 
			local_id[(20+1)*`LOCAL_ID_BITS-1:20*`LOCAL_ID_BITS] <= (id[(20+1)*`COL_ID_BITS-1:20*`COL_ID_BITS] & mask); 
			val_wr_en[20] <= 1; 
		end 
		else begin 
			val_wr_en[20] <= 0; 
		end 
	end

	assign id_rd_en[21] = start & (counter == id[(21*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(21*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[21]) & (~val_full[21]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[21]) begin 
			local_id[(21+1)*`LOCAL_ID_BITS-1:21*`LOCAL_ID_BITS] <= (id[(21+1)*`COL_ID_BITS-1:21*`COL_ID_BITS] & mask); 
			val_wr_en[21] <= 1; 
		end 
		else begin 
			val_wr_en[21] <= 0; 
		end 
	end

	assign id_rd_en[22] = start & (counter == id[(22*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(22*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[22]) & (~val_full[22]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[22]) begin 
			local_id[(22+1)*`LOCAL_ID_BITS-1:22*`LOCAL_ID_BITS] <= (id[(22+1)*`COL_ID_BITS-1:22*`COL_ID_BITS] & mask); 
			val_wr_en[22] <= 1; 
		end 
		else begin 
			val_wr_en[22] <= 0; 
		end 
	end

	assign id_rd_en[23] = start & (counter == id[(23*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(23*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[23]) & (~val_full[23]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[23]) begin 
			local_id[(23+1)*`LOCAL_ID_BITS-1:23*`LOCAL_ID_BITS] <= (id[(23+1)*`COL_ID_BITS-1:23*`COL_ID_BITS] & mask); 
			val_wr_en[23] <= 1; 
		end 
		else begin 
			val_wr_en[23] <= 0; 
		end 
	end

	assign id_rd_en[24] = start & (counter == id[(24*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(24*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[24]) & (~val_full[24]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[24]) begin 
			local_id[(24+1)*`LOCAL_ID_BITS-1:24*`LOCAL_ID_BITS] <= (id[(24+1)*`COL_ID_BITS-1:24*`COL_ID_BITS] & mask); 
			val_wr_en[24] <= 1; 
		end 
		else begin 
			val_wr_en[24] <= 0; 
		end 
	end

	assign id_rd_en[25] = start & (counter == id[(25*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(25*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[25]) & (~val_full[25]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[25]) begin 
			local_id[(25+1)*`LOCAL_ID_BITS-1:25*`LOCAL_ID_BITS] <= (id[(25+1)*`COL_ID_BITS-1:25*`COL_ID_BITS] & mask); 
			val_wr_en[25] <= 1; 
		end 
		else begin 
			val_wr_en[25] <= 0; 
		end 
	end

	assign id_rd_en[26] = start & (counter == id[(26*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(26*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[26]) & (~val_full[26]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[26]) begin 
			local_id[(26+1)*`LOCAL_ID_BITS-1:26*`LOCAL_ID_BITS] <= (id[(26+1)*`COL_ID_BITS-1:26*`COL_ID_BITS] & mask); 
			val_wr_en[26] <= 1; 
		end 
		else begin 
			val_wr_en[26] <= 0; 
		end 
	end

	assign id_rd_en[27] = start & (counter == id[(27*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(27*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[27]) & (~val_full[27]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[27]) begin 
			local_id[(27+1)*`LOCAL_ID_BITS-1:27*`LOCAL_ID_BITS] <= (id[(27+1)*`COL_ID_BITS-1:27*`COL_ID_BITS] & mask); 
			val_wr_en[27] <= 1; 
		end 
		else begin 
			val_wr_en[27] <= 0; 
		end 
	end

	assign id_rd_en[28] = start & (counter == id[(28*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(28*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[28]) & (~val_full[28]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[28]) begin 
			local_id[(28+1)*`LOCAL_ID_BITS-1:28*`LOCAL_ID_BITS] <= (id[(28+1)*`COL_ID_BITS-1:28*`COL_ID_BITS] & mask); 
			val_wr_en[28] <= 1; 
		end 
		else begin 
			val_wr_en[28] <= 0; 
		end 
	end

	assign id_rd_en[29] = start & (counter == id[(29*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(29*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[29]) & (~val_full[29]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[29]) begin 
			local_id[(29+1)*`LOCAL_ID_BITS-1:29*`LOCAL_ID_BITS] <= (id[(29+1)*`COL_ID_BITS-1:29*`COL_ID_BITS] & mask); 
			val_wr_en[29] <= 1; 
		end 
		else begin 
			val_wr_en[29] <= 0; 
		end 
	end

	assign id_rd_en[30] = start & (counter == id[(30*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(30*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[30]) & (~val_full[30]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[30]) begin 
			local_id[(30+1)*`LOCAL_ID_BITS-1:30*`LOCAL_ID_BITS] <= (id[(30+1)*`COL_ID_BITS-1:30*`COL_ID_BITS] & mask); 
			val_wr_en[30] <= 1; 
		end 
		else begin 
			val_wr_en[30] <= 0; 
		end 
	end

	assign id_rd_en[31] = start & (counter == id[(31*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS+`COUNTER_BITS-1:(31*`COL_ID_BITS)+`NUM_VEC_VALS_PER_ADDR_BITS]) & (~id_empty[31]) & (~val_full[31]); 
	always @ (posedge clk) begin 
		if(id_rd_en_reg[31]) begin 
			local_id[(31+1)*`LOCAL_ID_BITS-1:31*`LOCAL_ID_BITS] <= (id[(31+1)*`COL_ID_BITS-1:31*`COL_ID_BITS] & mask); 
			val_wr_en[31] <= 1; 
		end 
		else begin 
			val_wr_en[31] <= 0; 
		end 
	end

	Switch_Matrix xbar 
	(
		.in(ram_out),
		.addr(local_id),
		.out(fifo_in_val)
	);

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			counter <= 0;
			counter_delay <= 0;
			mask <= {`NUM_VEC_VALS_PER_ADDR_BITS{1'b1}};
		end
		else if (start) begin
			counter <= (counter == COUNTER_MAX) ? 0 : counter + 1;
			counter_delay <= counter;
		end
	end
endmodule

module Switch_Matrix
	(
		input [`BVB_AWIDTH-1:0] in,
		input [`NUM_CHANNEL*`LOCAL_ID_BITS-1:0] addr,
		output [(`NUM_CHANNEL*`VEC_VAL_BITS)-1:0] out
	);

	mux_128to1 mux_0 
	( 
		.in(in), 
		.sel(addr[(0+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:0*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(0+1)*`VEC_VAL_BITS-1:0*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_1 
	( 
		.in(in), 
		.sel(addr[(1+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:1*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(1+1)*`VEC_VAL_BITS-1:1*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_2 
	( 
		.in(in), 
		.sel(addr[(2+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:2*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(2+1)*`VEC_VAL_BITS-1:2*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_3 
	( 
		.in(in), 
		.sel(addr[(3+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:3*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(3+1)*`VEC_VAL_BITS-1:3*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_4 
	( 
		.in(in), 
		.sel(addr[(4+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:4*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(4+1)*`VEC_VAL_BITS-1:4*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_5 
	( 
		.in(in), 
		.sel(addr[(5+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:5*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(5+1)*`VEC_VAL_BITS-1:5*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_6 
	( 
		.in(in), 
		.sel(addr[(6+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:6*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(6+1)*`VEC_VAL_BITS-1:6*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_7 
	( 
		.in(in), 
		.sel(addr[(7+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:7*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(7+1)*`VEC_VAL_BITS-1:7*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_8 
	( 
		.in(in), 
		.sel(addr[(8+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:8*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(8+1)*`VEC_VAL_BITS-1:8*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_9 
	( 
		.in(in), 
		.sel(addr[(9+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:9*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(9+1)*`VEC_VAL_BITS-1:9*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_10 
	( 
		.in(in), 
		.sel(addr[(10+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:10*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(10+1)*`VEC_VAL_BITS-1:10*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_11 
	( 
		.in(in), 
		.sel(addr[(11+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:11*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(11+1)*`VEC_VAL_BITS-1:11*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_12 
	( 
		.in(in), 
		.sel(addr[(12+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:12*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(12+1)*`VEC_VAL_BITS-1:12*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_13 
	( 
		.in(in), 
		.sel(addr[(13+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:13*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(13+1)*`VEC_VAL_BITS-1:13*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_14 
	( 
		.in(in), 
		.sel(addr[(14+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:14*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(14+1)*`VEC_VAL_BITS-1:14*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_15 
	( 
		.in(in), 
		.sel(addr[(15+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:15*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(15+1)*`VEC_VAL_BITS-1:15*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_16 
	( 
		.in(in), 
		.sel(addr[(16+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:16*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(16+1)*`VEC_VAL_BITS-1:16*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_17 
	( 
		.in(in), 
		.sel(addr[(17+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:17*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(17+1)*`VEC_VAL_BITS-1:17*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_18 
	( 
		.in(in), 
		.sel(addr[(18+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:18*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(18+1)*`VEC_VAL_BITS-1:18*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_19 
	( 
		.in(in), 
		.sel(addr[(19+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:19*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(19+1)*`VEC_VAL_BITS-1:19*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_20 
	( 
		.in(in), 
		.sel(addr[(20+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:20*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(20+1)*`VEC_VAL_BITS-1:20*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_21 
	( 
		.in(in), 
		.sel(addr[(21+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:21*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(21+1)*`VEC_VAL_BITS-1:21*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_22 
	( 
		.in(in), 
		.sel(addr[(22+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:22*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(22+1)*`VEC_VAL_BITS-1:22*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_23 
	( 
		.in(in), 
		.sel(addr[(23+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:23*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(23+1)*`VEC_VAL_BITS-1:23*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_24 
	( 
		.in(in), 
		.sel(addr[(24+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:24*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(24+1)*`VEC_VAL_BITS-1:24*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_25 
	( 
		.in(in), 
		.sel(addr[(25+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:25*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(25+1)*`VEC_VAL_BITS-1:25*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_26 
	( 
		.in(in), 
		.sel(addr[(26+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:26*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(26+1)*`VEC_VAL_BITS-1:26*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_27 
	( 
		.in(in), 
		.sel(addr[(27+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:27*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(27+1)*`VEC_VAL_BITS-1:27*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_28 
	( 
		.in(in), 
		.sel(addr[(28+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:28*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(28+1)*`VEC_VAL_BITS-1:28*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_29 
	( 
		.in(in), 
		.sel(addr[(29+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:29*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(29+1)*`VEC_VAL_BITS-1:29*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_30 
	( 
		.in(in), 
		.sel(addr[(30+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:30*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(30+1)*`VEC_VAL_BITS-1:30*`VEC_VAL_BITS]) 
	);

	mux_128to1 mux_31 
	( 
		.in(in), 
		.sel(addr[(31+1)*`NUM_VEC_VALS_PER_ADDR_BITS-1:31*`NUM_VEC_VALS_PER_ADDR_BITS]), 
		.out(out[(31+1)*`VEC_VAL_BITS-1:31*`VEC_VAL_BITS]) 
	);
endmodule

module mux_2to1 
	(
		input [2*`VEC_VAL_BITS-1:0] in,
		input [1-1:0] sel,
		output [1*`VEC_VAL_BITS-1:0] out
	);

	reg [1*`VEC_VAL_BITS-1:0] mux_out;

	always @ (in or sel) begin
		case (sel)
			1'b00: mux_out <= in[1*`VEC_VAL_BITS-1:0];
			1'b01: mux_out <= in[2*`VEC_VAL_BITS-1:1*`VEC_VAL_BITS];
			default: mux_out <= 0;
		endcase
	end
	assign out = mux_out;
endmodule

// module mux_4to1 
// 	parameter 8 = 8
// 	)
// 	(
// 		input [4*8-1:0] in,
// 		input [2-1:0] sel,
// 		output [1*8-1:0] out
// 	);

// 	reg [1*8-1:0] mux_out;

// 	always @ (in or sel) begin
// 		case (sel)
// 			2'b00: mux_out <= in[1*8-1:0];
// 			2'b01: mux_out <= in[2*8-1:1*8];
// 			2'b10: mux_out <= in[3*8-1:2*8];
// 			2'b11: mux_out <= in[4*8-1:3*8];
// 			default: mux_out <= 0;
// 		endcase
// 	end

// 	assign out = mux_out;
// endmodule

module mux_8to1 
	(
		input [8*`VEC_VAL_BITS-1:0] in,
		input [3-1:0] sel,
		output [1*`VEC_VAL_BITS-1:0] out
	);

	reg [1*`VEC_VAL_BITS-1:0] mux_out;

	always @ (in or sel) begin
		case (sel)
			3'b000: mux_out <= in[1*`VEC_VAL_BITS-1:0];
			3'b001: mux_out <= in[2*`VEC_VAL_BITS-1:1*`VEC_VAL_BITS];
			3'b010: mux_out <= in[3*`VEC_VAL_BITS-1:2*`VEC_VAL_BITS];
			3'b011: mux_out <= in[4*`VEC_VAL_BITS-1:3*`VEC_VAL_BITS];
			3'b100: mux_out <= in[5*`VEC_VAL_BITS-1:4*`VEC_VAL_BITS];
			3'b101: mux_out <= in[6*`VEC_VAL_BITS-1:5*`VEC_VAL_BITS];
			3'b110: mux_out <= in[7*`VEC_VAL_BITS-1:6*`VEC_VAL_BITS];
			3'b111: mux_out <= in[8*`VEC_VAL_BITS-1:7*`VEC_VAL_BITS];
			default: mux_out <= 0;
		endcase
	end

	assign out = mux_out;
endmodule

module mux_16to1
	(
		input [16*`VEC_VAL_BITS-1:0] in,
		input [4-1:0] sel,
		output [1*`VEC_VAL_BITS-1:0] out
	);

	wire [1*`VEC_VAL_BITS-1:0] out1;
	wire [1*`VEC_VAL_BITS-1:0] out2;
	wire [2*`VEC_VAL_BITS-1:0] out3;

	mux_8to1 mux1
	(
		.in(in[8*`VEC_VAL_BITS-1:0]),
		.sel(sel[3-1:0]),
		.out(out1)
	);

	mux_8to1 mux2
	(
		.in(in[16*`VEC_VAL_BITS-1:8*`VEC_VAL_BITS]),
		.sel(sel[3-1:0]),
		.out(out2)
	);

	mux_2to1 mux_out
	(
		.in(out3),
		.sel(sel[4-1]),
		.out(out)
	);
	assign out3 = {out2, out1};
endmodule

module mux_32to1
	(
		input [32*`VEC_VAL_BITS-1:0] in,
		input [5-1:0] sel,
		output [1*`VEC_VAL_BITS-1:0] out
	);

	wire [1*`VEC_VAL_BITS-1:0] out1;
	wire [1*`VEC_VAL_BITS-1:0] out2;
	wire [2*`VEC_VAL_BITS-1:0] out3;

	mux_16to1 mux1
	(
		.in(in[16*`VEC_VAL_BITS-1:0]),
		.sel(sel[4-1:0]),
		.out(out1)
	);

	mux_16to1 mux2 
	(
		.in(in[32*`VEC_VAL_BITS-1:16*`VEC_VAL_BITS]),
		.sel(sel[4-1:0]),
		.out(out2)
	);

	mux_2to1 mux_out
	(
		.in(out3),
		.sel(sel[5-1]),
		.out(out)
	);
	assign out3 = {out2, out1};
endmodule

module mux_64to1
	(
		input [64*`VEC_VAL_BITS-1:0] in,
		input [6-1:0] sel,
		output [1*`VEC_VAL_BITS-1:0] out
	);

	wire [1*`VEC_VAL_BITS-1:0] out1;
	wire [1*`VEC_VAL_BITS-1:0] out2;
	wire [2*`VEC_VAL_BITS-1:0] out3;

	mux_32to1 mux1 
	(
		.in(in[32*`VEC_VAL_BITS-1:0]),
		.sel(sel[5-1:0]),
		.out(out1)
	);

	mux_32to1 mux2 
	(
		.in(in[64*`VEC_VAL_BITS-1:32*`VEC_VAL_BITS]),
		.sel(sel[5-1:0]),
		.out(out2)
	);

	mux_2to1 mux_out
	(
		.in(out3),
		.sel(sel[6-1]),
		.out(out)
	);
	assign out3 = {out2, out1};
endmodule

module mux_128to1
	(
		input [128*`VEC_VAL_BITS-1:0] in,
		input [7-1:0] sel,
		output [1*`VEC_VAL_BITS-1:0] out
	);

	wire [1*`VEC_VAL_BITS-1:0] out1;
	wire [1*`VEC_VAL_BITS-1:0] out2;
	wire [2*`VEC_VAL_BITS-1:0] out3;

	mux_64to1 mux1 
	(
		.in(in[64*`VEC_VAL_BITS-1:0]),
		.sel(sel[6-1:0]),
		.out(out1)
	);

	mux_64to1 mux2 
	(
		.in(in[128*`VEC_VAL_BITS-1:64*`VEC_VAL_BITS]),
		.sel(sel[6-1:0]),
		.out(out2)
	);

	mux_2to1 mux_out
	(
		.in(out3),
		.sel(sel[7-1]),
		.out(out)
	);
	assign out3 = {out2, out1};
endmodule

module Big_Channel(
	input clk, 
	input rst, 
	input start,
	input fetcher_done,
	
	input [`MAT_VAL_BITS * `NUM_CHANNEL -1 :0] mat_val,
	input [`NUM_CHANNEL - 1 : 0] mat_val_empty,
	output [`NUM_CHANNEL - 1 : 0] mat_val_rd_en,

	input [`VEC_VAL_BITS * `NUM_CHANNEL - 1 : 0] vec_val,
	input [`NUM_CHANNEL-1:0] vec_val_empty,
	output [`NUM_CHANNEL-1:0] vec_val_rd_en,

	input [`ROW_ID_BITS * `NUM_CHANNEL -1:0] row_id,
	input [`NUM_CHANNEL-1:0] row_id_empty,
	output [`NUM_CHANNEL-1:0] row_id_rd_en,

	output [`MULT_BITS * `NUM_CHANNEL -1:0] wr_data,
	output [`ROW_ID_BITS * `NUM_CHANNEL -1:0] wr_addr,
	output [`NUM_CHANNEL-1:0] wr_en,

	output [`NUM_CHANNEL-1:0] done
);
	
	Channel_Accumulator CH_0 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(0+1)*`MAT_VAL_BITS-1:0*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[0]), 
		.mat_val_rd_en(mat_val_rd_en[0]), 
		.vec_val(vec_val[(0+1)*`VEC_VAL_BITS-1:0*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[0]), 
		.vec_val_rd_en(vec_val_rd_en[0]), 
		.row_id(row_id[(0+1)*`ROW_ID_BITS-1:0*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[0]), 
		.row_id_rd_en(row_id_rd_en[0]), 
		.wr_data(wr_data[(0+1)*`MULT_BITS-1:0*`MULT_BITS]), 
		.wr_addr(wr_addr[(0+1)*`ROW_ID_BITS-1:0*`ROW_ID_BITS]), 
		.wr_en(wr_en[0]), 
		.done(done[0]) 
	);

	Channel_Accumulator CH_1 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(1+1)*`MAT_VAL_BITS-1:1*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[1]), 
		.mat_val_rd_en(mat_val_rd_en[1]), 
		.vec_val(vec_val[(1+1)*`VEC_VAL_BITS-1:1*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[1]), 
		.vec_val_rd_en(vec_val_rd_en[1]), 
		.row_id(row_id[(1+1)*`ROW_ID_BITS-1:1*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[1]), 
		.row_id_rd_en(row_id_rd_en[1]), 
		.wr_data(wr_data[(1+1)*`MULT_BITS-1:1*`MULT_BITS]), 
		.wr_addr(wr_addr[(1+1)*`ROW_ID_BITS-1:1*`ROW_ID_BITS]), 
		.wr_en(wr_en[1]), 
		.done(done[1]) 
	);

	Channel_Accumulator CH_2 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(2+1)*`MAT_VAL_BITS-1:2*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[2]), 
		.mat_val_rd_en(mat_val_rd_en[2]), 
		.vec_val(vec_val[(2+1)*`VEC_VAL_BITS-1:2*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[2]), 
		.vec_val_rd_en(vec_val_rd_en[2]), 
		.row_id(row_id[(2+1)*`ROW_ID_BITS-1:2*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[2]), 
		.row_id_rd_en(row_id_rd_en[2]), 
		.wr_data(wr_data[(2+1)*`MULT_BITS-1:2*`MULT_BITS]), 
		.wr_addr(wr_addr[(2+1)*`ROW_ID_BITS-1:2*`ROW_ID_BITS]), 
		.wr_en(wr_en[2]), 
		.done(done[2]) 
	);

	Channel_Accumulator CH_3 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(3+1)*`MAT_VAL_BITS-1:3*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[3]), 
		.mat_val_rd_en(mat_val_rd_en[3]), 
		.vec_val(vec_val[(3+1)*`VEC_VAL_BITS-1:3*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[3]), 
		.vec_val_rd_en(vec_val_rd_en[3]), 
		.row_id(row_id[(3+1)*`ROW_ID_BITS-1:3*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[3]), 
		.row_id_rd_en(row_id_rd_en[3]), 
		.wr_data(wr_data[(3+1)*`MULT_BITS-1:3*`MULT_BITS]), 
		.wr_addr(wr_addr[(3+1)*`ROW_ID_BITS-1:3*`ROW_ID_BITS]), 
		.wr_en(wr_en[3]), 
		.done(done[3]) 
	);

	Channel_Accumulator CH_4 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(4+1)*`MAT_VAL_BITS-1:4*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[4]), 
		.mat_val_rd_en(mat_val_rd_en[4]), 
		.vec_val(vec_val[(4+1)*`VEC_VAL_BITS-1:4*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[4]), 
		.vec_val_rd_en(vec_val_rd_en[4]), 
		.row_id(row_id[(4+1)*`ROW_ID_BITS-1:4*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[4]), 
		.row_id_rd_en(row_id_rd_en[4]), 
		.wr_data(wr_data[(4+1)*`MULT_BITS-1:4*`MULT_BITS]), 
		.wr_addr(wr_addr[(4+1)*`ROW_ID_BITS-1:4*`ROW_ID_BITS]), 
		.wr_en(wr_en[4]), 
		.done(done[4]) 
	);

	Channel_Accumulator CH_5 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(5+1)*`MAT_VAL_BITS-1:5*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[5]), 
		.mat_val_rd_en(mat_val_rd_en[5]), 
		.vec_val(vec_val[(5+1)*`VEC_VAL_BITS-1:5*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[5]), 
		.vec_val_rd_en(vec_val_rd_en[5]), 
		.row_id(row_id[(5+1)*`ROW_ID_BITS-1:5*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[5]), 
		.row_id_rd_en(row_id_rd_en[5]), 
		.wr_data(wr_data[(5+1)*`MULT_BITS-1:5*`MULT_BITS]), 
		.wr_addr(wr_addr[(5+1)*`ROW_ID_BITS-1:5*`ROW_ID_BITS]), 
		.wr_en(wr_en[5]), 
		.done(done[5]) 
	);

	Channel_Accumulator CH_6 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(6+1)*`MAT_VAL_BITS-1:6*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[6]), 
		.mat_val_rd_en(mat_val_rd_en[6]), 
		.vec_val(vec_val[(6+1)*`VEC_VAL_BITS-1:6*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[6]), 
		.vec_val_rd_en(vec_val_rd_en[6]), 
		.row_id(row_id[(6+1)*`ROW_ID_BITS-1:6*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[6]), 
		.row_id_rd_en(row_id_rd_en[6]), 
		.wr_data(wr_data[(6+1)*`MULT_BITS-1:6*`MULT_BITS]), 
		.wr_addr(wr_addr[(6+1)*`ROW_ID_BITS-1:6*`ROW_ID_BITS]), 
		.wr_en(wr_en[6]), 
		.done(done[6]) 
	);

	Channel_Accumulator CH_7 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(7+1)*`MAT_VAL_BITS-1:7*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[7]), 
		.mat_val_rd_en(mat_val_rd_en[7]), 
		.vec_val(vec_val[(7+1)*`VEC_VAL_BITS-1:7*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[7]), 
		.vec_val_rd_en(vec_val_rd_en[7]), 
		.row_id(row_id[(7+1)*`ROW_ID_BITS-1:7*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[7]), 
		.row_id_rd_en(row_id_rd_en[7]), 
		.wr_data(wr_data[(7+1)*`MULT_BITS-1:7*`MULT_BITS]), 
		.wr_addr(wr_addr[(7+1)*`ROW_ID_BITS-1:7*`ROW_ID_BITS]), 
		.wr_en(wr_en[7]), 
		.done(done[7]) 
	);

	Channel_Accumulator CH_8 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(8+1)*`MAT_VAL_BITS-1:8*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[8]), 
		.mat_val_rd_en(mat_val_rd_en[8]), 
		.vec_val(vec_val[(8+1)*`VEC_VAL_BITS-1:8*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[8]), 
		.vec_val_rd_en(vec_val_rd_en[8]), 
		.row_id(row_id[(8+1)*`ROW_ID_BITS-1:8*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[8]), 
		.row_id_rd_en(row_id_rd_en[8]), 
		.wr_data(wr_data[(8+1)*`MULT_BITS-1:8*`MULT_BITS]), 
		.wr_addr(wr_addr[(8+1)*`ROW_ID_BITS-1:8*`ROW_ID_BITS]), 
		.wr_en(wr_en[8]), 
		.done(done[8]) 
	);

	Channel_Accumulator CH_9 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(9+1)*`MAT_VAL_BITS-1:9*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[9]), 
		.mat_val_rd_en(mat_val_rd_en[9]), 
		.vec_val(vec_val[(9+1)*`VEC_VAL_BITS-1:9*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[9]), 
		.vec_val_rd_en(vec_val_rd_en[9]), 
		.row_id(row_id[(9+1)*`ROW_ID_BITS-1:9*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[9]), 
		.row_id_rd_en(row_id_rd_en[9]), 
		.wr_data(wr_data[(9+1)*`MULT_BITS-1:9*`MULT_BITS]), 
		.wr_addr(wr_addr[(9+1)*`ROW_ID_BITS-1:9*`ROW_ID_BITS]), 
		.wr_en(wr_en[9]), 
		.done(done[9]) 
	);

	Channel_Accumulator CH_10 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(10+1)*`MAT_VAL_BITS-1:10*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[10]), 
		.mat_val_rd_en(mat_val_rd_en[10]), 
		.vec_val(vec_val[(10+1)*`VEC_VAL_BITS-1:10*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[10]), 
		.vec_val_rd_en(vec_val_rd_en[10]), 
		.row_id(row_id[(10+1)*`ROW_ID_BITS-1:10*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[10]), 
		.row_id_rd_en(row_id_rd_en[10]), 
		.wr_data(wr_data[(10+1)*`MULT_BITS-1:10*`MULT_BITS]), 
		.wr_addr(wr_addr[(10+1)*`ROW_ID_BITS-1:10*`ROW_ID_BITS]), 
		.wr_en(wr_en[10]), 
		.done(done[10]) 
	);

	Channel_Accumulator CH_11 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(11+1)*`MAT_VAL_BITS-1:11*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[11]), 
		.mat_val_rd_en(mat_val_rd_en[11]), 
		.vec_val(vec_val[(11+1)*`VEC_VAL_BITS-1:11*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[11]), 
		.vec_val_rd_en(vec_val_rd_en[11]), 
		.row_id(row_id[(11+1)*`ROW_ID_BITS-1:11*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[11]), 
		.row_id_rd_en(row_id_rd_en[11]), 
		.wr_data(wr_data[(11+1)*`MULT_BITS-1:11*`MULT_BITS]), 
		.wr_addr(wr_addr[(11+1)*`ROW_ID_BITS-1:11*`ROW_ID_BITS]), 
		.wr_en(wr_en[11]), 
		.done(done[11]) 
	);

	Channel_Accumulator CH_12 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(12+1)*`MAT_VAL_BITS-1:12*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[12]), 
		.mat_val_rd_en(mat_val_rd_en[12]), 
		.vec_val(vec_val[(12+1)*`VEC_VAL_BITS-1:12*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[12]), 
		.vec_val_rd_en(vec_val_rd_en[12]), 
		.row_id(row_id[(12+1)*`ROW_ID_BITS-1:12*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[12]), 
		.row_id_rd_en(row_id_rd_en[12]), 
		.wr_data(wr_data[(12+1)*`MULT_BITS-1:12*`MULT_BITS]), 
		.wr_addr(wr_addr[(12+1)*`ROW_ID_BITS-1:12*`ROW_ID_BITS]), 
		.wr_en(wr_en[12]), 
		.done(done[12]) 
	);

	Channel_Accumulator CH_13 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(13+1)*`MAT_VAL_BITS-1:13*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[13]), 
		.mat_val_rd_en(mat_val_rd_en[13]), 
		.vec_val(vec_val[(13+1)*`VEC_VAL_BITS-1:13*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[13]), 
		.vec_val_rd_en(vec_val_rd_en[13]), 
		.row_id(row_id[(13+1)*`ROW_ID_BITS-1:13*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[13]), 
		.row_id_rd_en(row_id_rd_en[13]), 
		.wr_data(wr_data[(13+1)*`MULT_BITS-1:13*`MULT_BITS]), 
		.wr_addr(wr_addr[(13+1)*`ROW_ID_BITS-1:13*`ROW_ID_BITS]), 
		.wr_en(wr_en[13]), 
		.done(done[13]) 
	);

	Channel_Accumulator CH_14 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(14+1)*`MAT_VAL_BITS-1:14*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[14]), 
		.mat_val_rd_en(mat_val_rd_en[14]), 
		.vec_val(vec_val[(14+1)*`VEC_VAL_BITS-1:14*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[14]), 
		.vec_val_rd_en(vec_val_rd_en[14]), 
		.row_id(row_id[(14+1)*`ROW_ID_BITS-1:14*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[14]), 
		.row_id_rd_en(row_id_rd_en[14]), 
		.wr_data(wr_data[(14+1)*`MULT_BITS-1:14*`MULT_BITS]), 
		.wr_addr(wr_addr[(14+1)*`ROW_ID_BITS-1:14*`ROW_ID_BITS]), 
		.wr_en(wr_en[14]), 
		.done(done[14]) 
	);

	Channel_Accumulator CH_15 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(15+1)*`MAT_VAL_BITS-1:15*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[15]), 
		.mat_val_rd_en(mat_val_rd_en[15]), 
		.vec_val(vec_val[(15+1)*`VEC_VAL_BITS-1:15*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[15]), 
		.vec_val_rd_en(vec_val_rd_en[15]), 
		.row_id(row_id[(15+1)*`ROW_ID_BITS-1:15*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[15]), 
		.row_id_rd_en(row_id_rd_en[15]), 
		.wr_data(wr_data[(15+1)*`MULT_BITS-1:15*`MULT_BITS]), 
		.wr_addr(wr_addr[(15+1)*`ROW_ID_BITS-1:15*`ROW_ID_BITS]), 
		.wr_en(wr_en[15]), 
		.done(done[15]) 
	);

	Channel_Accumulator CH_16 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(16+1)*`MAT_VAL_BITS-1:16*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[16]), 
		.mat_val_rd_en(mat_val_rd_en[16]), 
		.vec_val(vec_val[(16+1)*`VEC_VAL_BITS-1:16*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[16]), 
		.vec_val_rd_en(vec_val_rd_en[16]), 
		.row_id(row_id[(16+1)*`ROW_ID_BITS-1:16*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[16]), 
		.row_id_rd_en(row_id_rd_en[16]), 
		.wr_data(wr_data[(16+1)*`MULT_BITS-1:16*`MULT_BITS]), 
		.wr_addr(wr_addr[(16+1)*`ROW_ID_BITS-1:16*`ROW_ID_BITS]), 
		.wr_en(wr_en[16]), 
		.done(done[16]) 
	);

	Channel_Accumulator CH_17 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(17+1)*`MAT_VAL_BITS-1:17*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[17]), 
		.mat_val_rd_en(mat_val_rd_en[17]), 
		.vec_val(vec_val[(17+1)*`VEC_VAL_BITS-1:17*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[17]), 
		.vec_val_rd_en(vec_val_rd_en[17]), 
		.row_id(row_id[(17+1)*`ROW_ID_BITS-1:17*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[17]), 
		.row_id_rd_en(row_id_rd_en[17]), 
		.wr_data(wr_data[(17+1)*`MULT_BITS-1:17*`MULT_BITS]), 
		.wr_addr(wr_addr[(17+1)*`ROW_ID_BITS-1:17*`ROW_ID_BITS]), 
		.wr_en(wr_en[17]), 
		.done(done[17]) 
	);

	Channel_Accumulator CH_18 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(18+1)*`MAT_VAL_BITS-1:18*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[18]), 
		.mat_val_rd_en(mat_val_rd_en[18]), 
		.vec_val(vec_val[(18+1)*`VEC_VAL_BITS-1:18*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[18]), 
		.vec_val_rd_en(vec_val_rd_en[18]), 
		.row_id(row_id[(18+1)*`ROW_ID_BITS-1:18*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[18]), 
		.row_id_rd_en(row_id_rd_en[18]), 
		.wr_data(wr_data[(18+1)*`MULT_BITS-1:18*`MULT_BITS]), 
		.wr_addr(wr_addr[(18+1)*`ROW_ID_BITS-1:18*`ROW_ID_BITS]), 
		.wr_en(wr_en[18]), 
		.done(done[18]) 
	);

	Channel_Accumulator CH_19 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(19+1)*`MAT_VAL_BITS-1:19*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[19]), 
		.mat_val_rd_en(mat_val_rd_en[19]), 
		.vec_val(vec_val[(19+1)*`VEC_VAL_BITS-1:19*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[19]), 
		.vec_val_rd_en(vec_val_rd_en[19]), 
		.row_id(row_id[(19+1)*`ROW_ID_BITS-1:19*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[19]), 
		.row_id_rd_en(row_id_rd_en[19]), 
		.wr_data(wr_data[(19+1)*`MULT_BITS-1:19*`MULT_BITS]), 
		.wr_addr(wr_addr[(19+1)*`ROW_ID_BITS-1:19*`ROW_ID_BITS]), 
		.wr_en(wr_en[19]), 
		.done(done[19]) 
	);

	Channel_Accumulator CH_20 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(20+1)*`MAT_VAL_BITS-1:20*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[20]), 
		.mat_val_rd_en(mat_val_rd_en[20]), 
		.vec_val(vec_val[(20+1)*`VEC_VAL_BITS-1:20*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[20]), 
		.vec_val_rd_en(vec_val_rd_en[20]), 
		.row_id(row_id[(20+1)*`ROW_ID_BITS-1:20*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[20]), 
		.row_id_rd_en(row_id_rd_en[20]), 
		.wr_data(wr_data[(20+1)*`MULT_BITS-1:20*`MULT_BITS]), 
		.wr_addr(wr_addr[(20+1)*`ROW_ID_BITS-1:20*`ROW_ID_BITS]), 
		.wr_en(wr_en[20]), 
		.done(done[20]) 
	);

	Channel_Accumulator CH_21 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(21+1)*`MAT_VAL_BITS-1:21*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[21]), 
		.mat_val_rd_en(mat_val_rd_en[21]), 
		.vec_val(vec_val[(21+1)*`VEC_VAL_BITS-1:21*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[21]), 
		.vec_val_rd_en(vec_val_rd_en[21]), 
		.row_id(row_id[(21+1)*`ROW_ID_BITS-1:21*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[21]), 
		.row_id_rd_en(row_id_rd_en[21]), 
		.wr_data(wr_data[(21+1)*`MULT_BITS-1:21*`MULT_BITS]), 
		.wr_addr(wr_addr[(21+1)*`ROW_ID_BITS-1:21*`ROW_ID_BITS]), 
		.wr_en(wr_en[21]), 
		.done(done[21]) 
	);

	Channel_Accumulator CH_22 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(22+1)*`MAT_VAL_BITS-1:22*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[22]), 
		.mat_val_rd_en(mat_val_rd_en[22]), 
		.vec_val(vec_val[(22+1)*`VEC_VAL_BITS-1:22*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[22]), 
		.vec_val_rd_en(vec_val_rd_en[22]), 
		.row_id(row_id[(22+1)*`ROW_ID_BITS-1:22*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[22]), 
		.row_id_rd_en(row_id_rd_en[22]), 
		.wr_data(wr_data[(22+1)*`MULT_BITS-1:22*`MULT_BITS]), 
		.wr_addr(wr_addr[(22+1)*`ROW_ID_BITS-1:22*`ROW_ID_BITS]), 
		.wr_en(wr_en[22]), 
		.done(done[22]) 
	);

	Channel_Accumulator CH_23 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(23+1)*`MAT_VAL_BITS-1:23*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[23]), 
		.mat_val_rd_en(mat_val_rd_en[23]), 
		.vec_val(vec_val[(23+1)*`VEC_VAL_BITS-1:23*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[23]), 
		.vec_val_rd_en(vec_val_rd_en[23]), 
		.row_id(row_id[(23+1)*`ROW_ID_BITS-1:23*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[23]), 
		.row_id_rd_en(row_id_rd_en[23]), 
		.wr_data(wr_data[(23+1)*`MULT_BITS-1:23*`MULT_BITS]), 
		.wr_addr(wr_addr[(23+1)*`ROW_ID_BITS-1:23*`ROW_ID_BITS]), 
		.wr_en(wr_en[23]), 
		.done(done[23]) 
	);

	Channel_Accumulator CH_24 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(24+1)*`MAT_VAL_BITS-1:24*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[24]), 
		.mat_val_rd_en(mat_val_rd_en[24]), 
		.vec_val(vec_val[(24+1)*`VEC_VAL_BITS-1:24*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[24]), 
		.vec_val_rd_en(vec_val_rd_en[24]), 
		.row_id(row_id[(24+1)*`ROW_ID_BITS-1:24*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[24]), 
		.row_id_rd_en(row_id_rd_en[24]), 
		.wr_data(wr_data[(24+1)*`MULT_BITS-1:24*`MULT_BITS]), 
		.wr_addr(wr_addr[(24+1)*`ROW_ID_BITS-1:24*`ROW_ID_BITS]), 
		.wr_en(wr_en[24]), 
		.done(done[24]) 
	);

	Channel_Accumulator CH_25 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(25+1)*`MAT_VAL_BITS-1:25*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[25]), 
		.mat_val_rd_en(mat_val_rd_en[25]), 
		.vec_val(vec_val[(25+1)*`VEC_VAL_BITS-1:25*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[25]), 
		.vec_val_rd_en(vec_val_rd_en[25]), 
		.row_id(row_id[(25+1)*`ROW_ID_BITS-1:25*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[25]), 
		.row_id_rd_en(row_id_rd_en[25]), 
		.wr_data(wr_data[(25+1)*`MULT_BITS-1:25*`MULT_BITS]), 
		.wr_addr(wr_addr[(25+1)*`ROW_ID_BITS-1:25*`ROW_ID_BITS]), 
		.wr_en(wr_en[25]), 
		.done(done[25]) 
	);

	Channel_Accumulator CH_26 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(26+1)*`MAT_VAL_BITS-1:26*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[26]), 
		.mat_val_rd_en(mat_val_rd_en[26]), 
		.vec_val(vec_val[(26+1)*`VEC_VAL_BITS-1:26*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[26]), 
		.vec_val_rd_en(vec_val_rd_en[26]), 
		.row_id(row_id[(26+1)*`ROW_ID_BITS-1:26*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[26]), 
		.row_id_rd_en(row_id_rd_en[26]), 
		.wr_data(wr_data[(26+1)*`MULT_BITS-1:26*`MULT_BITS]), 
		.wr_addr(wr_addr[(26+1)*`ROW_ID_BITS-1:26*`ROW_ID_BITS]), 
		.wr_en(wr_en[26]), 
		.done(done[26]) 
	);

	Channel_Accumulator CH_27 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(27+1)*`MAT_VAL_BITS-1:27*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[27]), 
		.mat_val_rd_en(mat_val_rd_en[27]), 
		.vec_val(vec_val[(27+1)*`VEC_VAL_BITS-1:27*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[27]), 
		.vec_val_rd_en(vec_val_rd_en[27]), 
		.row_id(row_id[(27+1)*`ROW_ID_BITS-1:27*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[27]), 
		.row_id_rd_en(row_id_rd_en[27]), 
		.wr_data(wr_data[(27+1)*`MULT_BITS-1:27*`MULT_BITS]), 
		.wr_addr(wr_addr[(27+1)*`ROW_ID_BITS-1:27*`ROW_ID_BITS]), 
		.wr_en(wr_en[27]), 
		.done(done[27]) 
	);

	Channel_Accumulator CH_28 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(28+1)*`MAT_VAL_BITS-1:28*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[28]), 
		.mat_val_rd_en(mat_val_rd_en[28]), 
		.vec_val(vec_val[(28+1)*`VEC_VAL_BITS-1:28*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[28]), 
		.vec_val_rd_en(vec_val_rd_en[28]), 
		.row_id(row_id[(28+1)*`ROW_ID_BITS-1:28*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[28]), 
		.row_id_rd_en(row_id_rd_en[28]), 
		.wr_data(wr_data[(28+1)*`MULT_BITS-1:28*`MULT_BITS]), 
		.wr_addr(wr_addr[(28+1)*`ROW_ID_BITS-1:28*`ROW_ID_BITS]), 
		.wr_en(wr_en[28]), 
		.done(done[28]) 
	);

	Channel_Accumulator CH_29 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(29+1)*`MAT_VAL_BITS-1:29*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[29]), 
		.mat_val_rd_en(mat_val_rd_en[29]), 
		.vec_val(vec_val[(29+1)*`VEC_VAL_BITS-1:29*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[29]), 
		.vec_val_rd_en(vec_val_rd_en[29]), 
		.row_id(row_id[(29+1)*`ROW_ID_BITS-1:29*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[29]), 
		.row_id_rd_en(row_id_rd_en[29]), 
		.wr_data(wr_data[(29+1)*`MULT_BITS-1:29*`MULT_BITS]), 
		.wr_addr(wr_addr[(29+1)*`ROW_ID_BITS-1:29*`ROW_ID_BITS]), 
		.wr_en(wr_en[29]), 
		.done(done[29]) 
	);

	Channel_Accumulator CH_30 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(30+1)*`MAT_VAL_BITS-1:30*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[30]), 
		.mat_val_rd_en(mat_val_rd_en[30]), 
		.vec_val(vec_val[(30+1)*`VEC_VAL_BITS-1:30*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[30]), 
		.vec_val_rd_en(vec_val_rd_en[30]), 
		.row_id(row_id[(30+1)*`ROW_ID_BITS-1:30*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[30]), 
		.row_id_rd_en(row_id_rd_en[30]), 
		.wr_data(wr_data[(30+1)*`MULT_BITS-1:30*`MULT_BITS]), 
		.wr_addr(wr_addr[(30+1)*`ROW_ID_BITS-1:30*`ROW_ID_BITS]), 
		.wr_en(wr_en[30]), 
		.done(done[30]) 
	);

	Channel_Accumulator CH_31 ( 
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.fetcher_done(fetcher_done), 
		.mat_val(mat_val[(31+1)*`MAT_VAL_BITS-1:31*`MAT_VAL_BITS]), 
		.mat_val_empty(mat_val_empty[31]), 
		.mat_val_rd_en(mat_val_rd_en[31]), 
		.vec_val(vec_val[(31+1)*`VEC_VAL_BITS-1:31*`VEC_VAL_BITS]), 
		.vec_val_empty(vec_val_empty[31]), 
		.vec_val_rd_en(vec_val_rd_en[31]), 
		.row_id(row_id[(31+1)*`ROW_ID_BITS-1:31*`ROW_ID_BITS]), 
		.row_id_empty(row_id_empty[31]), 
		.row_id_rd_en(row_id_rd_en[31]), 
		.wr_data(wr_data[(31+1)*`MULT_BITS-1:31*`MULT_BITS]), 
		.wr_addr(wr_addr[(31+1)*`ROW_ID_BITS-1:31*`ROW_ID_BITS]), 
		.wr_en(wr_en[31]), 
		.done(done[31]) 
	);
endmodule

module Channel_Accumulator(
	input clk, 
	input rst, 
	input start,
	input fetcher_done,
	
	input [`MAT_VAL_BITS-1:0] mat_val,
	input mat_val_empty,
	output mat_val_rd_en,

	input [`VEC_VAL_BITS-1:0] vec_val,
	input vec_val_empty,
	output vec_val_rd_en,

	input [`ROW_ID_BITS-1:0] row_id,
	input row_id_empty,
	output row_id_rd_en,

	  
	output [`MULT_BITS-1:0] wr_data,
	output [`ROW_ID_BITS-1:0] wr_addr,
	output wr_en,

	output done
	);
 
	wire mult_rd_en;
	wire mult_empty;
	wire [`MULT_BITS-1:0] mult_out;
	wire mult_done;
	
	Channel CH0(.clk(clk), 
				.rst(rst),
				.start(start),
				.fetcher_done(fetcher_done),
				.mat_val(mat_val), 
				.mat_val_empty(mat_val_empty), 
				.mat_val_rd_en(mat_val_rd_en),
				.vec_val(vec_val), 
				.vec_val_empty(vec_val_empty), 
				.vec_val_rd_en(vec_val_rd_en),
				.mult_out(mult_out),
				.mult_empty(mult_empty), 
				.mult_rd_en(mult_rd_en), 
				.done(mult_done)
	);
					
	Accumulator A0(	.clk(clk), 
					.rst(rst), 
					.start(start),
					.mult_done(mult_done),
					.row_id(row_id), 
					.row_id_empty(row_id_empty), 
					.row_id_rd_en(row_id_rd_en), 
					.mult_out(mult_out),
					.mult_empty(mult_empty), 
					.mult_rd_en(mult_rd_en), 
					.wr_addr(wr_addr), 
					.wr_data(wr_data),
					.wr_en(wr_en),
					.done(done)			
	);

endmodule

module Channel(
	input clk, 
	input rst,
	input start,
	input fetcher_done,

	input [`MAT_VAL_BITS-1:0] mat_val,
	input mat_val_empty,
	output mat_val_rd_en,

	input [`VEC_VAL_BITS-1:0] vec_val,
	input vec_val_empty,
	output vec_val_rd_en,

	output [`MULT_BITS-1:0] mult_out,
	output mult_empty,
	input mult_rd_en,

	output done 
	);

	parameter FIFO_DEPTH = 8;
	// parameter FIFO_DEPTH_BITS = `LOG2(FIFO_DEPTH);
	parameter FIFO_DEPTH_BITS = $clog2(8);

	reg [`MULT_BITS-1:0] mult;
	reg mult_wr_en;
	wire mult_full;
	
	reg vec_val_rd_en_reg;
	reg mat_val_rd_en_reg;

	generic_fifo_sc_a #(
		.dw(`MULT_BITS),
		.aw(FIFO_DEPTH_BITS)
		) fifo_mult (
		.clk(clk),
		.rst(rst),
		.clr(0),
		.din(mult),
		.we(mult_wr_en),
		.re(mult_rd_en),
		.dout(mult_out),
		.full(mult_full),
		.empty(mult_empty)
	);

	assign done = mat_val_empty & fetcher_done & start;

	assign vec_val_rd_en = start & (~vec_val_empty) & (~mat_val_empty) & (~mult_full);
	assign mat_val_rd_en = start & (~vec_val_empty) & (~mat_val_empty) & (~mult_full);

	always@(posedge clk) begin
		vec_val_rd_en_reg <= vec_val_rd_en;
		mat_val_rd_en_reg <= mat_val_rd_en;

		if(vec_val_rd_en_reg && mat_val_rd_en_reg) begin
			mult <= vec_val * mat_val;
			mult_wr_en <= 1;
		end
		else begin
			mult_wr_en <= 0;
		end
	end
endmodule

module Accumulator(
	input clk, 
	input rst, 
	input start, 
	input mult_done,

	input [`ROW_ID_BITS-1:0] row_id,
	input row_id_empty,
	output row_id_rd_en,

	input [`MULT_BITS-1:0] mult_out,
	input mult_empty,
	output mult_rd_en,

	output reg [`ROW_ID_BITS-1:0] wr_addr,
	output reg [`MULT_BITS-1:0] wr_data,
	output reg wr_en,

	output reg done
	);
	
	reg first_read;

	reg row_id_rd_en_reg;
	reg mult_rd_en_reg;

	assign row_id_rd_en = start & (~row_id_empty) & (~mult_empty);
	assign mult_rd_en = start & (~row_id_empty) & (~mult_empty);

	always@(posedge clk or posedge rst) begin
		if(rst) begin
			wr_data<=0;
			wr_en<=0;
			first_read <= 0;
			done <= 0;
		end 
		else if(start) begin
			done <= mult_done & row_id_empty;
			row_id_rd_en_reg <= row_id_rd_en;
			mult_rd_en_reg <= mult_rd_en;
			if(~first_read) begin
				wr_addr <= row_id;
				first_read <= 1;
			end 	
			else if(row_id_rd_en_reg & mult_rd_en_reg) begin
				if(row_id!=wr_addr) begin
					wr_en <= 1;
					wr_data <= mult_out;
					wr_addr <= row_id;
				end
				else begin
					wr_en <= 0;
					wr_data <= wr_data + mult_out;
				end
			end
			else if (done) begin
				wr_en <= 1;
			end
			else begin
				wr_en <= 0;
			end
		end
	end
endmodule


/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Universal FIFO Single Clock                                ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  D/L from: http://www.opencores.org/cores/generic_fifos/    ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: generic_fifo_sc_a.v,v 1.1.1.1 2002-09-25 05:42:06 rudi Exp $
//
//  $Date: 2002-09-25 05:42:06 $
//  $Revision: 1.1.1.1 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//
//
//
//
//
//
//
//
//
//

// `include "timescale.v"

/*

Description
===========

I/Os
----
rst	low active, either sync. or async. master reset (see below how to select)
clr	synchronous clear (just like reset but always synchronous), high active
re	read enable, synchronous, high active
we	read enable, synchronous, high active
din	Data Input
dout	Data Output

full	Indicates the FIFO is full (combinatorial output)
full_r	same as above, but registered output (see note below)
empty	Indicates the FIFO is empty
empty_r	same as above, but registered output (see note below)

full_n		Indicates if the FIFO has space for N entries (combinatorial output)
full_n_r	same as above, but registered output (see note below)
empty_n		Indicates the FIFO has at least N entries (combinatorial output)
empty_n_r	same as above, but registered output (see note below)

level		indicates the FIFO level:
		2'b00	0-25%	 full
		2'b01	25-50%	 full
		2'b10	50-75%	 full
		2'b11	%75-100% full

combinatorial vs. registered status outputs
-------------------------------------------
Both the combinatorial and registered status outputs have exactly the same
synchronous timing. Meaning they are being asserted immediately at the clock
edge after the last read or write. The combinatorial outputs however, pass
through several levels of logic before they are output. The registered status
outputs are direct outputs of a flip-flop. The reason both are provided, is
that the registered outputs require quite a bit of additional logic inside
the FIFO. If you can meet timing of your device with the combinatorial
outputs, use them ! The FIFO will be smaller. If the status signals are
in the critical pass, use the registered outputs, they have a much smaller
output delay (actually only Tcq).

Parameters
----------
The FIFO takes 3 parameters:
dw	Data bus width
aw	Address bus width (Determines the FIFO size by evaluating 2^aw)
n	N is a second status threshold constant for full_n and empty_n
	If you have no need for the second status threshold, do not
	connect the outputs and the logic should be removed by your
	synthesis tool.

Synthesis Results
-----------------
In a Spartan 2e a 8 bit wide, 8 entries deep FIFO, takes 85 LUTs and runs
at about 116 MHz (IO insertion disabled). The registered status outputs
are valid after 2.1NS, the combinatorial once take out to 6.5 NS to be
available.


Misc
----
This design assumes you will do appropriate status checking externally.

IMPORTANT ! writing while the FIFO is full or reading while the FIFO is
empty will place the FIFO in an undefined state.

*/


// Selecting Sync. or Async Reset
// ------------------------------
// Uncomment one of the two lines below. The first line for
// synchronous reset, the second for asynchronous reset

// `define SC_FIFO_ASYNC_RESET				// Uncomment for Syncr. reset
// `define SC_FIFO_ASYNC_RESET	or posedge rst		// Uncomment for Async. reset


module generic_fifo_sc_a
	#(parameter dw=8,
	  parameter aw=8)
	(clk, rst, clr, din, we, dout, re,
	full, empty);

parameter max_size = 1<<aw;

input 			clk, rst, clr;
input 	[dw-1:0]	din;
input 			we;
output	[dw-1:0]	dout;
input 	wire		re;
output			full;
output			empty;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//
wire 	[dw-1:0]	din_nc;
wire 	[dw-1:0]	out_nc;
reg		[aw-1:0]	wp;
wire	[aw-1:0]	wp_pl1;
reg		[aw-1:0]	rp;
wire	[aw-1:0]	rp_pl1;
reg					gb;

////////////////////////////////////////////////////////////////////
//
// Memory Block
//
dpram #(
	.AWIDTH(aw),
	.DWIDTH(dw)
	) u0 (
	.clk(clk),
	.address_a(rp),
	.wren_a(0),
	.data_a(din_nc),
	.out_a(dout),
	.address_b(wp),
	.wren_b(we),
	.data_b(din),
	.out_b(out_nc)
);


////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

always @(posedge clk or posedge rst)
	if(rst)	wp <= {aw{1'b0}};
	else
	if(clr)		wp <= {aw{1'b0}};
	else
	if(we)		wp <= wp_pl1;

assign wp_pl1 = wp + { {aw-1{1'b0}}, 1'b1};

always @(posedge clk or posedge rst)
	if(rst)		rp <= {aw{1'b0}};
	else
	if(clr)		rp <= {aw{1'b0}};
	else
	if(re)		rp <= rp_pl1;

assign rp_pl1 = rp + { {aw-1{1'b0}}, 1'b1};

////////////////////////////////////////////////////////////////////
//
// Combinatorial Full & Empty Flags
//

assign empty = ((wp == rp) & !gb);
assign full  = ((wp == rp) &  gb);

// Guard Bit ...
always @(posedge clk or posedge rst)
	if(rst)						gb <= 1'b0;
	else
	if(clr)						gb <= 1'b0;
	else
	if((wp_pl1 == rp) & we)		gb <= 1'b1;
	else
	if(re)						gb <= 1'b0;

endmodule

module dpram #(
	parameter DWIDTH = 32,
	parameter AWIDTH = 10
  )
  (
	clk,
	address_a,
	address_b,
	wren_a,
	wren_b,
	data_a,
	data_b,
	out_a,
	out_b
);

parameter NUM_WORDS=1<<AWIDTH;

input clk;
input [(AWIDTH-1):0] address_a;
input [(AWIDTH-1):0] address_b;
input  wren_a;
input  wren_b;
input [(DWIDTH-1):0] data_a;
input [(DWIDTH-1):0] data_b;
output reg [(DWIDTH-1):0] out_a;
output reg [(DWIDTH-1):0] out_b;

`ifdef SIMULATION

	reg [DWIDTH-1:0] ram[NUM_WORDS-1:0];

	always @ (posedge clk) begin
		if (wren_a) begin
			ram[address_a] <= data_a;
		end
		else begin
			out_a <= ram[address_a];
		end
	end
	  
	always @ (posedge clk) begin 
		if (wren_b) begin
			ram[address_b] <= data_b;
		end 
		else begin
			out_b <= ram[address_b];
		end
	end

`else

	dual_port_ram u_dual_port_ram(
	.addr1(address_a),
	.we1(wren_a),
	.data1(data_a),
	.out1(out_a),
	.addr2(address_b),
	.we2(wren_b),
	.data2(data_b),
	.out2(out_b),
	.clk(clk)
	);

`endif

endmodule


module spram #(
`ifdef SIMULATION
	parameter INIT="init.txt",
`endif
	parameter AWIDTH=5,
	parameter NUM_WORDS=32,
	parameter DWIDTH=16)
	(
		input clk,
		input [(AWIDTH-1):0] address,
		input wren,
		input [(DWIDTH-1):0] din,
		output reg [(DWIDTH-1):0] dout
	);
	`ifdef SIMULATION
		reg [DWIDTH-1:0] mem [NUM_WORDS-1:0];

		initial begin
			$readmemh(INIT, mem);
		end

		always @ (posedge clk) begin 
			if (wren) begin
				mem[address] <= din;
			end
			else begin
				dout <= mem[address];
			end
		end
	`else 

		single_port_ram u_single_port_ram( 
		.addr(address),
		.we(wren),
		.data(din),
		.out(dout),
		.clk(clk)
		);

	`endif 
endmodule
