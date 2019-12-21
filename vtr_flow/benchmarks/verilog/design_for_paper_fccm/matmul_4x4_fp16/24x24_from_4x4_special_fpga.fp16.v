`timescale 1ns/1ns
`define EXPONENT 5
`define MANTISSA 10
`define SIGN 1
`define DWIDTH (`SIGN+`EXPONENT+`MANTISSA)
`define IEEE_COMPLIANCE 1
`define AWIDTH 16
`define MEM_SIZE 7
`define MAT_MUL_SIZE 128
`define LOG2_MAT_MUL_SIZE 4
`define BB_MAT_MUL_SIZE `MAT_MUL_SIZE
`define NUM_CYCLES_IN_MAC 8


module matrix_multiplication(
  clk,
  clk_mem,
  reset,
  enable_writing_to_mem,
  enable_reading_from_mem,
  data_pi,
  addr_pi,
  we_a,
  we_b,
  we_c,
  data_from_out_mat,
  start_mat_mul,
  done_mat_mul
);

  input clk;
  input clk_mem;
  input enable_writing_to_mem;
  input enable_reading_from_mem;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input we_a;
  input we_b;
  input we_c;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  output done_mat_mul;

  input reset;
  input start_mat_mul;
  reg enable_writing_to_mem_reg;
  reg enable_reading_from_mem_reg;
  reg [`AWIDTH-1:0] addr_pi_reg;
  always @(posedge clk_mem) begin
    if(reset) begin
      enable_writing_to_mem_reg <= 0;
      enable_reading_from_mem_reg <= 0;
      addr_pi_reg <= 0;
    end else begin
      enable_writing_to_mem_reg <= enable_writing_to_mem;
      enable_reading_from_mem_reg <= enable_reading_from_mem;
      addr_pi_reg <= addr_pi;
    end
  end
/////////////////////////////////////////////////
// BRAMs to store matrix A
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_0;

  wire [`AWIDTH-1:0] a_addr_0_0;
  wire [`AWIDTH-1:0] a_addr_1_0;
  wire [`AWIDTH-1:0] a_addr_2_0;
  wire [`AWIDTH-1:0] a_addr_3_0;
  wire [`AWIDTH-1:0] a_addr_4_0;
  wire [`AWIDTH-1:0] a_addr_5_0;

  wire [`AWIDTH-1:0] a_addr_muxed_0_0;
  wire [`AWIDTH-1:0] a_addr_muxed_1_0;
  wire [`AWIDTH-1:0] a_addr_muxed_2_0;
  wire [`AWIDTH-1:0] a_addr_muxed_3_0;
  wire [`AWIDTH-1:0] a_addr_muxed_4_0;
  wire [`AWIDTH-1:0] a_addr_muxed_5_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_5_0_reg;

  reg  [`AWIDTH-1:0] a_addr_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_5_0_reg;


  always @(posedge clk_mem) begin
    if(reset) begin
      a_addr_0_0_reg <= `MEM_SIZE-1;
      a_addr_1_0_reg <= `MEM_SIZE-1;
      a_addr_2_0_reg <= `MEM_SIZE-1;
      a_addr_3_0_reg <= `MEM_SIZE-1;
      a_addr_4_0_reg <= `MEM_SIZE-1;
      a_addr_5_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_0_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_1_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_2_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_3_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_4_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_5_0_reg <= `MEM_SIZE-1;
    end else begin
      a_addr_0_0_reg <= a_addr_0_0;
      a_addr_1_0_reg <= a_addr_1_0;
      a_addr_2_0_reg <= a_addr_2_0;
      a_addr_3_0_reg <= a_addr_3_0;
      a_addr_4_0_reg <= a_addr_4_0;
      a_addr_5_0_reg <= a_addr_5_0;
      a_addr_muxed_0_0_reg <= a_addr_muxed_0_0;
      a_addr_muxed_1_0_reg <= a_addr_muxed_1_0;
      a_addr_muxed_2_0_reg <= a_addr_muxed_2_0;
      a_addr_muxed_3_0_reg <= a_addr_muxed_3_0;
      a_addr_muxed_4_0_reg <= a_addr_muxed_4_0;
      a_addr_muxed_5_0_reg <= a_addr_muxed_5_0;
    end
  end

  assign a_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_0_0_reg;
  assign a_addr_muxed_1_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_1_0_reg;
  assign a_addr_muxed_2_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_2_0_reg;
  assign a_addr_muxed_3_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_3_0_reg;
  assign a_addr_muxed_4_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_4_0_reg;
  assign a_addr_muxed_5_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_5_0_reg;

  // BRAM matrix A 0_0
  ram matrix_A_0_0 (
    .addr0(a_addr_muxed_0_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_0_0),
    .clk(clk_mem));

  // BRAM matrix A 1_0
  ram matrix_A_1_0 (
    .addr0(a_addr_muxed_1_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_1_0),
    .clk(clk_mem));

  // BRAM matrix A 2_0
  ram matrix_A_2_0 (
    .addr0(a_addr_muxed_2_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_2_0),
    .clk(clk_mem));

  // BRAM matrix A 3_0
  ram matrix_A_3_0 (
    .addr0(a_addr_muxed_3_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_3_0),
    .clk(clk_mem));

  // BRAM matrix A 4_0
  ram matrix_A_4_0 (
    .addr0(a_addr_muxed_4_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_4_0),
    .clk(clk_mem));

  // BRAM matrix A 5_0
  ram matrix_A_5_0 (
    .addr0(a_addr_muxed_5_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_5_0),
    .clk(clk_mem));

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_0_reg;
  always @(posedge clk_mem) begin
    if (reset) begin
      a_data_0_0_reg <= 0;
      a_data_1_0_reg <= 0;
      a_data_2_0_reg <= 0;
      a_data_3_0_reg <= 0;
      a_data_4_0_reg <= 0;
      a_data_5_0_reg <= 0;
    end else begin
      a_data_0_0_reg <= a_data_0_0;
      a_data_1_0_reg <= a_data_1_0;
      a_data_2_0_reg <= a_data_2_0;
      a_data_3_0_reg <= a_data_3_0;
      a_data_4_0_reg <= a_data_4_0;
      a_data_5_0_reg <= a_data_5_0;
    end
  end

/////////////////////////////////////////////////
// BRAMs to store matrix B
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5;

  wire [`AWIDTH-1:0] b_addr_0_0;
  wire [`AWIDTH-1:0] b_addr_0_1;
  wire [`AWIDTH-1:0] b_addr_0_2;
  wire [`AWIDTH-1:0] b_addr_0_3;
  wire [`AWIDTH-1:0] b_addr_0_4;
  wire [`AWIDTH-1:0] b_addr_0_5;

  wire [`AWIDTH-1:0] b_addr_muxed_0_0;
  wire [`AWIDTH-1:0] b_addr_muxed_0_1;
  wire [`AWIDTH-1:0] b_addr_muxed_0_2;
  wire [`AWIDTH-1:0] b_addr_muxed_0_3;
  wire [`AWIDTH-1:0] b_addr_muxed_0_4;
  wire [`AWIDTH-1:0] b_addr_muxed_0_5;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_5_reg;

  reg  [`AWIDTH-1:0] b_addr_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_0_5_reg;



  always @(posedge clk_mem) begin
    if(reset) begin
      b_addr_0_0_reg <= `MEM_SIZE-1;
      b_addr_0_1_reg <= `MEM_SIZE-1;
      b_addr_0_2_reg <= `MEM_SIZE-1;
      b_addr_0_3_reg <= `MEM_SIZE-1;
      b_addr_0_4_reg <= `MEM_SIZE-1;
      b_addr_0_5_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_0_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_1_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_2_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_3_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_4_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_5_reg <= `MEM_SIZE-1;
    end else begin
      b_addr_0_0_reg <= b_addr_0_0;
      b_addr_0_1_reg <= b_addr_0_1;
      b_addr_0_2_reg <= b_addr_0_2;
      b_addr_0_3_reg <= b_addr_0_3;
      b_addr_0_4_reg <= b_addr_0_4;
      b_addr_0_5_reg <= b_addr_0_5;
      b_addr_muxed_0_0_reg <= b_addr_muxed_0_0;
      b_addr_muxed_0_1_reg <= b_addr_muxed_0_1;
      b_addr_muxed_0_2_reg <= b_addr_muxed_0_2;
      b_addr_muxed_0_3_reg <= b_addr_muxed_0_3;
      b_addr_muxed_0_4_reg <= b_addr_muxed_0_4;
      b_addr_muxed_0_5_reg <= b_addr_muxed_0_5;
    end
  end

  assign b_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_0_reg;
  assign b_addr_muxed_0_1 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_1_reg;
  assign b_addr_muxed_0_2 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_2_reg;
  assign b_addr_muxed_0_3 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_3_reg;
  assign b_addr_muxed_0_4 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_4_reg;
  assign b_addr_muxed_0_5 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_5_reg;

  // BRAM matrix B 0_0
  ram matrix_B_0_0 (
    .addr0(b_addr_muxed_0_0_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_0),
    .clk(clk_mem));

  // BRAM matrix B 0_1
  ram matrix_B_0_1 (
    .addr0(b_addr_muxed_0_1_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_1),
    .clk(clk_mem));

  // BRAM matrix B 0_2
  ram matrix_B_0_2 (
    .addr0(b_addr_muxed_0_2_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_2),
    .clk(clk_mem));

  // BRAM matrix B 0_3
  ram matrix_B_0_3 (
    .addr0(b_addr_muxed_0_3_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_3),
    .clk(clk_mem));

  // BRAM matrix B 0_4
  ram matrix_B_0_4 (
    .addr0(b_addr_muxed_0_4_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_4),
    .clk(clk_mem));

  // BRAM matrix B 0_5
  ram matrix_B_0_5 (
    .addr0(b_addr_muxed_0_5_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_5),
    .clk(clk_mem));

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5_reg;
  always @(posedge clk_mem) begin
    if (reset) begin
      b_data_0_0_reg <= 0;
      b_data_0_1_reg <= 0;
      b_data_0_2_reg <= 0;
      b_data_0_3_reg <= 0;
      b_data_0_4_reg <= 0;
      b_data_0_5_reg <= 0;
    end else begin
      b_data_0_0_reg <= b_data_0_0;
      b_data_0_1_reg <= b_data_0_1;
      b_data_0_2_reg <= b_data_0_2;
      b_data_0_3_reg <= b_data_0_3;
      b_data_0_4_reg <= b_data_0_4;
      b_data_0_5_reg <= b_data_0_5;
    end
  end

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  reg [`AWIDTH-1:0] c_addr;

  wire [`AWIDTH-1:0] c_addr_muxed_0_0;
  wire [`AWIDTH-1:0] c_addr_muxed_0_1;
  wire [`AWIDTH-1:0] c_addr_muxed_0_2;
  wire [`AWIDTH-1:0] c_addr_muxed_0_3;
  wire [`AWIDTH-1:0] c_addr_muxed_0_4;
  wire [`AWIDTH-1:0] c_addr_muxed_0_5;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_5_reg;

  assign c_addr_muxed_0_0 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_1 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_2 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_3 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_4 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_5 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;

  always @(posedge clk_mem) begin
    if(reset || done_mat_mul) begin
      c_addr <= 0;
    end
    else if (start_mat_mul) begin
      c_addr <= c_addr + 1;
    end
  end

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_5;

///////////////// ORing the data ///////////////////

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_1;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_2;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_3;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_4;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_3_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_4_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_5_reg;

  always @(posedge clk_mem) begin
    if(reset) begin
      data_from_out_mat_0_0_reg <= 0;
      data_from_out_mat_0_1_reg <= 0;
      data_from_out_mat_0_2_reg <= 0;
      data_from_out_mat_0_3_reg <= 0;
      data_from_out_mat_0_4_reg <= 0;
      data_from_out_mat_0_5_reg <= 0;
    end else begin
      data_from_out_mat_0_0_reg <= data_from_out_mat_0_0;
      data_from_out_mat_0_1_reg <= data_from_out_mat_0_1;
      data_from_out_mat_0_2_reg <= data_from_out_mat_0_2;
      data_from_out_mat_0_3_reg <= data_from_out_mat_0_3;
      data_from_out_mat_0_4_reg <= data_from_out_mat_0_4;
      data_from_out_mat_0_5_reg <= data_from_out_mat_0_5;
    end
  end

  always @(posedge clk_mem) begin
    if(reset) begin
      data_from_out_mat <= 0;
      c_reg_1 <= 0;
      c_reg_2 <= 0;
      c_reg_3 <= 0;
      c_reg_4 <= 0;
    end else begin
      c_reg_1 <= data_from_out_mat_0_0_reg | data_from_out_mat_0_1_reg;
      c_reg_2 <= c_reg_1 | data_from_out_mat_0_2_reg;
      c_reg_3 <= c_reg_2 | data_from_out_mat_0_3_reg;
      c_reg_4 <= c_reg_3 | data_from_out_mat_0_4_reg;
      data_from_out_mat <= c_reg_4 | data_from_out_mat_0_5_reg;
    end
  end

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_3_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_4_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_5_reg;
  always @(posedge clk_mem) begin
    if(reset) begin
      c_data_row_0_reg <= 0;
      c_addr_muxed_0_0_reg <= 0;
      c_data_row_1_reg <= 0;
      c_addr_muxed_0_1_reg <= 0;
      c_data_row_2_reg <= 0;
      c_addr_muxed_0_2_reg <= 0;
      c_data_row_3_reg <= 0;
      c_addr_muxed_0_3_reg <= 0;
      c_data_row_4_reg <= 0;
      c_addr_muxed_0_4_reg <= 0;
      c_data_row_5_reg <= 0;
      c_addr_muxed_0_5_reg <= 0;
    end else begin
      c_data_row_0_reg <= c_data_row_0;
      c_addr_muxed_0_0_reg <= c_addr_muxed_0_0;
      c_data_row_1_reg <= c_data_row_1;
      c_addr_muxed_0_1_reg <= c_addr_muxed_0_1;
      c_data_row_2_reg <= c_data_row_2;
      c_addr_muxed_0_2_reg <= c_addr_muxed_0_2;
      c_data_row_3_reg <= c_data_row_3;
      c_addr_muxed_0_3_reg <= c_addr_muxed_0_3;
      c_data_row_4_reg <= c_data_row_4;
      c_addr_muxed_0_4_reg <= c_addr_muxed_0_4;
      c_data_row_5_reg <= c_data_row_5;
      c_addr_muxed_0_5_reg <= c_addr_muxed_0_5;
    end
  end

  //  BRAM matrix C row_0
  ram matrix_row_0 (
    .addr0(c_addr_muxed_0_0_reg),
    .d0(c_data_row_0_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_0),
    .clk(clk_mem));

  //  BRAM matrix C row_1
  ram matrix_row_1 (
    .addr0(c_addr_muxed_0_1_reg),
    .d0(c_data_row_1_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_1),
    .clk(clk_mem));

  //  BRAM matrix C row_2
  ram matrix_row_2 (
    .addr0(c_addr_muxed_0_2_reg),
    .d0(c_data_row_2_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_2),
    .clk(clk_mem));

  //  BRAM matrix C row_3
  ram matrix_row_3 (
    .addr0(c_addr_muxed_0_3_reg),
    .d0(c_data_row_3_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_3),
    .clk(clk_mem));

  //  BRAM matrix C row_4
  ram matrix_row_4 (
    .addr0(c_addr_muxed_0_4_reg),
    .d0(c_data_row_4_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_4),
    .clk(clk_mem));

  //  BRAM matrix C row_5
  ram matrix_row_5 (
    .addr0(c_addr_muxed_0_5_reg),
    .d0(c_data_row_5_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_5),
    .clk(clk_mem));

/////////////////////////////////////////////////
// The 24x24 matmul instantiation
/////////////////////////////////////////////////

matmul_24x24_systolic u_matmul_24x24_systolic (
  .clk(clk),
  .done_mat_mul(done_mat_mul),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .a_data_0_0(a_data_0_0_reg),
  .a_addr_0_0(a_addr_0_0),
  .b_data_0_0(b_data_0_0_reg),
  .b_addr_0_0(b_addr_0_0),
  .a_data_1_0(a_data_1_0_reg),
  .a_addr_1_0(a_addr_1_0),
  .b_data_0_1(b_data_0_1_reg),
  .b_addr_0_1(b_addr_0_1),
  .a_data_2_0(a_data_2_0_reg),
  .a_addr_2_0(a_addr_2_0),
  .b_data_0_2(b_data_0_2_reg),
  .b_addr_0_2(b_addr_0_2),
  .a_data_3_0(a_data_3_0_reg),
  .a_addr_3_0(a_addr_3_0),
  .b_data_0_3(b_data_0_3_reg),
  .b_addr_0_3(b_addr_0_3),
  .a_data_4_0(a_data_4_0_reg),
  .a_addr_4_0(a_addr_4_0),
  .b_data_0_4(b_data_0_4_reg),
  .b_addr_0_4(b_addr_0_4),
  .a_data_5_0(a_data_5_0_reg),
  .a_addr_5_0(a_addr_5_0),
  .b_data_0_5(b_data_0_5_reg),
  .b_addr_0_5(b_addr_0_5),

  .c_data_row_0(c_data_row_0),
  .c_data_row_1(c_data_row_1),
  .c_data_row_2(c_data_row_2),
  .c_data_row_3(c_data_row_3),
  .c_data_row_4(c_data_row_4),
  .c_data_row_5(c_data_row_5)
);
endmodule


/////////////////////////////////////////////////
// The 24x24 matmul definition
/////////////////////////////////////////////////

module matmul_24x24_systolic(
  clk,
  done_mat_mul,
  reset,
  start_mat_mul,
  a_data_0_0,
  a_addr_0_0,
  b_data_0_0,
  b_addr_0_0,
  a_data_1_0,
  a_addr_1_0,
  b_data_0_1,
  b_addr_0_1,
  a_data_2_0,
  a_addr_2_0,
  b_data_0_2,
  b_addr_0_2,
  a_data_3_0,
  a_addr_3_0,
  b_data_0_3,
  b_addr_0_3,
  a_data_4_0,
  a_addr_4_0,
  b_data_0_4,
  b_addr_0_4,
  a_data_5_0,
  a_addr_5_0,
  b_data_0_5,
  b_addr_0_5,

  c_data_row_0,
  c_data_row_1,
  c_data_row_2,
  c_data_row_3,
  c_data_row_4,
  c_data_row_5
);
  input clk;
  output done_mat_mul;

  input reset;
  input start_mat_mul;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_0;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_5;

  output [`AWIDTH-1:0] a_addr_0_0;
  output [`AWIDTH-1:0] a_addr_1_0;
  output [`AWIDTH-1:0] a_addr_2_0;
  output [`AWIDTH-1:0] a_addr_3_0;
  output [`AWIDTH-1:0] a_addr_4_0;
  output [`AWIDTH-1:0] a_addr_5_0;

  output [`AWIDTH-1:0] b_addr_0_0;
  output [`AWIDTH-1:0] b_addr_0_1;
  output [`AWIDTH-1:0] b_addr_0_2;
  output [`AWIDTH-1:0] b_addr_0_3;
  output [`AWIDTH-1:0] b_addr_0_4;
  output [`AWIDTH-1:0] b_addr_0_5;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_0_0;
  wire done_mat_mul_0_1;
  wire done_mat_mul_0_2;
  wire done_mat_mul_0_3;
  wire done_mat_mul_0_4;
  wire done_mat_mul_0_5;
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;
  wire done_mat_mul_1_2;
  wire done_mat_mul_1_3;
  wire done_mat_mul_1_4;
  wire done_mat_mul_1_5;
  wire done_mat_mul_2_0;
  wire done_mat_mul_2_1;
  wire done_mat_mul_2_2;
  wire done_mat_mul_2_3;
  wire done_mat_mul_2_4;
  wire done_mat_mul_2_5;
  wire done_mat_mul_3_0;
  wire done_mat_mul_3_1;
  wire done_mat_mul_3_2;
  wire done_mat_mul_3_3;
  wire done_mat_mul_3_4;
  wire done_mat_mul_3_5;
  wire done_mat_mul_4_0;
  wire done_mat_mul_4_1;
  wire done_mat_mul_4_2;
  wire done_mat_mul_4_3;
  wire done_mat_mul_4_4;
  wire done_mat_mul_4_5;
  wire done_mat_mul_5_0;
  wire done_mat_mul_5_1;
  wire done_mat_mul_5_2;
  wire done_mat_mul_5_3;
  wire done_mat_mul_5_4;
  wire done_mat_mul_5_5;

  assign done_mat_mul = done_mat_mul_0_0;

  /////////////////////////////////////////////////
  // Matmul 0_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_to_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_to_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0_to_0_1;

matmul_4x4_systolic u_matmul_4x4_systolic_0_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_0),
  .a_data(a_data_0_0),
  .b_data(b_data_0_0),
  .a_data_in(a_data_in_0_0_NC),
  .b_data_in(b_data_in_0_0_NC),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_0_0_to_0_1),
  .a_data_out(a_data_0_0_to_0_1),
  .b_data_out(b_data_0_0_to_1_0),
  .a_addr(a_addr_0_0),
  .b_addr(b_addr_0_0),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 0_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_1_to_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1_to_1_1;
  wire [`AWIDTH-1:0] a_addr_0_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_1_to_0_2;

matmul_4x4_systolic u_matmul_4x4_systolic_0_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_1),
  .a_data(a_data_0_1_NC),
  .b_data(b_data_0_1),
  .a_data_in(a_data_0_0_to_0_1),
  .b_data_in(b_data_in_0_1_NC),
  .c_data_in(c_data_0_0_to_0_1),
  .c_data_out(c_data_0_1_to_0_2),
  .a_data_out(a_data_0_1_to_0_2),
  .b_data_out(b_data_0_1_to_1_1),
  .a_addr(a_addr_0_1_NC),
  .b_addr(b_addr_0_1),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd0),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 0_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_2_to_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2_to_1_2;
  wire [`AWIDTH-1:0] a_addr_0_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_2_to_0_3;

matmul_4x4_systolic u_matmul_4x4_systolic_0_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_2),
  .a_data(a_data_0_2_NC),
  .b_data(b_data_0_2),
  .a_data_in(a_data_0_1_to_0_2),
  .b_data_in(b_data_in_0_2_NC),
  .c_data_in(c_data_0_1_to_0_2),
  .c_data_out(c_data_0_2_to_0_3),
  .a_data_out(a_data_0_2_to_0_3),
  .b_data_out(b_data_0_2_to_1_2),
  .a_addr(a_addr_0_2_NC),
  .b_addr(b_addr_0_2),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd0),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 0_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_3_to_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3_to_1_3;
  wire [`AWIDTH-1:0] a_addr_0_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_3_to_0_4;

matmul_4x4_systolic u_matmul_4x4_systolic_0_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_3),
  .a_data(a_data_0_3_NC),
  .b_data(b_data_0_3),
  .a_data_in(a_data_0_2_to_0_3),
  .b_data_in(b_data_in_0_3_NC),
  .c_data_in(c_data_0_2_to_0_3),
  .c_data_out(c_data_0_3_to_0_4),
  .a_data_out(a_data_0_3_to_0_4),
  .b_data_out(b_data_0_3_to_1_3),
  .a_addr(a_addr_0_3_NC),
  .b_addr(b_addr_0_3),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd0),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 0_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_4_to_0_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4_to_1_4;
  wire [`AWIDTH-1:0] a_addr_0_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_4_to_0_5;

matmul_4x4_systolic u_matmul_4x4_systolic_0_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_4),
  .a_data(a_data_0_4_NC),
  .b_data(b_data_0_4),
  .a_data_in(a_data_0_3_to_0_4),
  .b_data_in(b_data_in_0_4_NC),
  .c_data_in(c_data_0_3_to_0_4),
  .c_data_out(c_data_0_4_to_0_5),
  .a_data_out(a_data_0_4_to_0_5),
  .b_data_out(b_data_0_4_to_1_4),
  .a_addr(a_addr_0_4_NC),
  .b_addr(b_addr_0_4),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd0),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 0_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_5_to_0_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5_to_1_5;
  wire [`AWIDTH-1:0] a_addr_0_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_5_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_0_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_5),
  .a_data(a_data_0_5_NC),
  .b_data(b_data_0_5),
  .a_data_in(a_data_0_4_to_0_5),
  .b_data_in(b_data_in_0_5_NC),
  .c_data_in(c_data_0_4_to_0_5),
  .c_data_out(c_data_row_0),
  .a_data_out(a_data_0_5_to_0_6),
  .b_data_out(b_data_0_5_to_1_5),
  .a_addr(a_addr_0_5_NC),
  .b_addr(b_addr_0_5),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd0),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 1_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0_to_1_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_0_to_2_0;
  wire [`AWIDTH-1:0] b_addr_1_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_1_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_0_to_1_1;

matmul_4x4_systolic u_matmul_4x4_systolic_1_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_0),
  .a_data(a_data_1_0),
  .b_data(b_data_1_0_NC),
  .a_data_in(a_data_in_1_0_NC),
  .b_data_in(b_data_0_0_to_1_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_1_0_to_1_1),
  .a_data_out(a_data_1_0_to_1_1),
  .b_data_out(b_data_1_0_to_2_0),
  .a_addr(a_addr_1_0),
  .b_addr(b_addr_1_0_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd1),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 1_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_1_to_1_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_1_to_2_1;
  wire [`AWIDTH-1:0] a_addr_1_1_NC;
  wire [`AWIDTH-1:0] b_addr_1_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_1_to_1_2;

matmul_4x4_systolic u_matmul_4x4_systolic_1_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_1),
  .a_data(a_data_1_1_NC),
  .b_data(b_data_1_1_NC),
  .a_data_in(a_data_1_0_to_1_1),
  .b_data_in(b_data_0_1_to_1_1),
  .c_data_in(c_data_1_0_to_1_1),
  .c_data_out(c_data_1_1_to_1_2),
  .a_data_out(a_data_1_1_to_1_2),
  .b_data_out(b_data_1_1_to_2_1),
  .a_addr(a_addr_1_1_NC),
  .b_addr(b_addr_1_1_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd1),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 1_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_2_to_1_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_2_to_2_2;
  wire [`AWIDTH-1:0] a_addr_1_2_NC;
  wire [`AWIDTH-1:0] b_addr_1_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_2_to_1_3;

matmul_4x4_systolic u_matmul_4x4_systolic_1_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_2),
  .a_data(a_data_1_2_NC),
  .b_data(b_data_1_2_NC),
  .a_data_in(a_data_1_1_to_1_2),
  .b_data_in(b_data_0_2_to_1_2),
  .c_data_in(c_data_1_1_to_1_2),
  .c_data_out(c_data_1_2_to_1_3),
  .a_data_out(a_data_1_2_to_1_3),
  .b_data_out(b_data_1_2_to_2_2),
  .a_addr(a_addr_1_2_NC),
  .b_addr(b_addr_1_2_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd1),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 1_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_3_to_1_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_3_to_2_3;
  wire [`AWIDTH-1:0] a_addr_1_3_NC;
  wire [`AWIDTH-1:0] b_addr_1_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_3_to_1_4;

matmul_4x4_systolic u_matmul_4x4_systolic_1_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_3),
  .a_data(a_data_1_3_NC),
  .b_data(b_data_1_3_NC),
  .a_data_in(a_data_1_2_to_1_3),
  .b_data_in(b_data_0_3_to_1_3),
  .c_data_in(c_data_1_2_to_1_3),
  .c_data_out(c_data_1_3_to_1_4),
  .a_data_out(a_data_1_3_to_1_4),
  .b_data_out(b_data_1_3_to_2_3),
  .a_addr(a_addr_1_3_NC),
  .b_addr(b_addr_1_3_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd1),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 1_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_4_to_1_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_4_to_2_4;
  wire [`AWIDTH-1:0] a_addr_1_4_NC;
  wire [`AWIDTH-1:0] b_addr_1_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_4_to_1_5;

matmul_4x4_systolic u_matmul_4x4_systolic_1_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_4),
  .a_data(a_data_1_4_NC),
  .b_data(b_data_1_4_NC),
  .a_data_in(a_data_1_3_to_1_4),
  .b_data_in(b_data_0_4_to_1_4),
  .c_data_in(c_data_1_3_to_1_4),
  .c_data_out(c_data_1_4_to_1_5),
  .a_data_out(a_data_1_4_to_1_5),
  .b_data_out(b_data_1_4_to_2_4),
  .a_addr(a_addr_1_4_NC),
  .b_addr(b_addr_1_4_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd1),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 1_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_5_to_1_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_5_to_2_5;
  wire [`AWIDTH-1:0] a_addr_1_5_NC;
  wire [`AWIDTH-1:0] b_addr_1_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_5_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_1_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_5),
  .a_data(a_data_1_5_NC),
  .b_data(b_data_1_5_NC),
  .a_data_in(a_data_1_4_to_1_5),
  .b_data_in(b_data_0_5_to_1_5),
  .c_data_in(c_data_1_4_to_1_5),
  .c_data_out(c_data_row_1),
  .a_data_out(a_data_1_5_to_1_6),
  .b_data_out(b_data_1_5_to_2_5),
  .a_addr(a_addr_1_5_NC),
  .b_addr(b_addr_1_5_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd1),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 2_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0_to_2_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_0_to_3_0;
  wire [`AWIDTH-1:0] b_addr_2_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_2_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_0_to_2_1;

matmul_4x4_systolic u_matmul_4x4_systolic_2_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_0),
  .a_data(a_data_2_0),
  .b_data(b_data_2_0_NC),
  .a_data_in(a_data_in_2_0_NC),
  .b_data_in(b_data_1_0_to_2_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_2_0_to_2_1),
  .a_data_out(a_data_2_0_to_2_1),
  .b_data_out(b_data_2_0_to_3_0),
  .a_addr(a_addr_2_0),
  .b_addr(b_addr_2_0_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd2),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 2_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_1_to_2_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_1_to_3_1;
  wire [`AWIDTH-1:0] a_addr_2_1_NC;
  wire [`AWIDTH-1:0] b_addr_2_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_1_to_2_2;

matmul_4x4_systolic u_matmul_4x4_systolic_2_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_1),
  .a_data(a_data_2_1_NC),
  .b_data(b_data_2_1_NC),
  .a_data_in(a_data_2_0_to_2_1),
  .b_data_in(b_data_1_1_to_2_1),
  .c_data_in(c_data_2_0_to_2_1),
  .c_data_out(c_data_2_1_to_2_2),
  .a_data_out(a_data_2_1_to_2_2),
  .b_data_out(b_data_2_1_to_3_1),
  .a_addr(a_addr_2_1_NC),
  .b_addr(b_addr_2_1_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd2),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 2_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_2_to_2_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_2_to_3_2;
  wire [`AWIDTH-1:0] a_addr_2_2_NC;
  wire [`AWIDTH-1:0] b_addr_2_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_2_to_2_3;

matmul_4x4_systolic u_matmul_4x4_systolic_2_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_2),
  .a_data(a_data_2_2_NC),
  .b_data(b_data_2_2_NC),
  .a_data_in(a_data_2_1_to_2_2),
  .b_data_in(b_data_1_2_to_2_2),
  .c_data_in(c_data_2_1_to_2_2),
  .c_data_out(c_data_2_2_to_2_3),
  .a_data_out(a_data_2_2_to_2_3),
  .b_data_out(b_data_2_2_to_3_2),
  .a_addr(a_addr_2_2_NC),
  .b_addr(b_addr_2_2_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd2),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 2_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_3_to_2_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_3_to_3_3;
  wire [`AWIDTH-1:0] a_addr_2_3_NC;
  wire [`AWIDTH-1:0] b_addr_2_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_3_to_2_4;

matmul_4x4_systolic u_matmul_4x4_systolic_2_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_3),
  .a_data(a_data_2_3_NC),
  .b_data(b_data_2_3_NC),
  .a_data_in(a_data_2_2_to_2_3),
  .b_data_in(b_data_1_3_to_2_3),
  .c_data_in(c_data_2_2_to_2_3),
  .c_data_out(c_data_2_3_to_2_4),
  .a_data_out(a_data_2_3_to_2_4),
  .b_data_out(b_data_2_3_to_3_3),
  .a_addr(a_addr_2_3_NC),
  .b_addr(b_addr_2_3_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd2),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 2_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_4_to_2_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_4_to_3_4;
  wire [`AWIDTH-1:0] a_addr_2_4_NC;
  wire [`AWIDTH-1:0] b_addr_2_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_4_to_2_5;

matmul_4x4_systolic u_matmul_4x4_systolic_2_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_4),
  .a_data(a_data_2_4_NC),
  .b_data(b_data_2_4_NC),
  .a_data_in(a_data_2_3_to_2_4),
  .b_data_in(b_data_1_4_to_2_4),
  .c_data_in(c_data_2_3_to_2_4),
  .c_data_out(c_data_2_4_to_2_5),
  .a_data_out(a_data_2_4_to_2_5),
  .b_data_out(b_data_2_4_to_3_4),
  .a_addr(a_addr_2_4_NC),
  .b_addr(b_addr_2_4_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd2),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 2_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_5_to_2_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_5_to_3_5;
  wire [`AWIDTH-1:0] a_addr_2_5_NC;
  wire [`AWIDTH-1:0] b_addr_2_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_5_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_2_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_5),
  .a_data(a_data_2_5_NC),
  .b_data(b_data_2_5_NC),
  .a_data_in(a_data_2_4_to_2_5),
  .b_data_in(b_data_1_5_to_2_5),
  .c_data_in(c_data_2_4_to_2_5),
  .c_data_out(c_data_row_2),
  .a_data_out(a_data_2_5_to_2_6),
  .b_data_out(b_data_2_5_to_3_5),
  .a_addr(a_addr_2_5_NC),
  .b_addr(b_addr_2_5_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd2),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 3_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0_to_3_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_0_to_4_0;
  wire [`AWIDTH-1:0] b_addr_3_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_3_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_0_to_3_1;

matmul_4x4_systolic u_matmul_4x4_systolic_3_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_0),
  .a_data(a_data_3_0),
  .b_data(b_data_3_0_NC),
  .a_data_in(a_data_in_3_0_NC),
  .b_data_in(b_data_2_0_to_3_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_3_0_to_3_1),
  .a_data_out(a_data_3_0_to_3_1),
  .b_data_out(b_data_3_0_to_4_0),
  .a_addr(a_addr_3_0),
  .b_addr(b_addr_3_0_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd3),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 3_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_1_to_3_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_1_to_4_1;
  wire [`AWIDTH-1:0] a_addr_3_1_NC;
  wire [`AWIDTH-1:0] b_addr_3_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_1_to_3_2;

matmul_4x4_systolic u_matmul_4x4_systolic_3_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_1),
  .a_data(a_data_3_1_NC),
  .b_data(b_data_3_1_NC),
  .a_data_in(a_data_3_0_to_3_1),
  .b_data_in(b_data_2_1_to_3_1),
  .c_data_in(c_data_3_0_to_3_1),
  .c_data_out(c_data_3_1_to_3_2),
  .a_data_out(a_data_3_1_to_3_2),
  .b_data_out(b_data_3_1_to_4_1),
  .a_addr(a_addr_3_1_NC),
  .b_addr(b_addr_3_1_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd3),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 3_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_2_to_3_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_2_to_4_2;
  wire [`AWIDTH-1:0] a_addr_3_2_NC;
  wire [`AWIDTH-1:0] b_addr_3_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_2_to_3_3;

matmul_4x4_systolic u_matmul_4x4_systolic_3_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_2),
  .a_data(a_data_3_2_NC),
  .b_data(b_data_3_2_NC),
  .a_data_in(a_data_3_1_to_3_2),
  .b_data_in(b_data_2_2_to_3_2),
  .c_data_in(c_data_3_1_to_3_2),
  .c_data_out(c_data_3_2_to_3_3),
  .a_data_out(a_data_3_2_to_3_3),
  .b_data_out(b_data_3_2_to_4_2),
  .a_addr(a_addr_3_2_NC),
  .b_addr(b_addr_3_2_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd3),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 3_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_3_to_3_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_3_to_4_3;
  wire [`AWIDTH-1:0] a_addr_3_3_NC;
  wire [`AWIDTH-1:0] b_addr_3_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_3_to_3_4;

matmul_4x4_systolic u_matmul_4x4_systolic_3_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_3),
  .a_data(a_data_3_3_NC),
  .b_data(b_data_3_3_NC),
  .a_data_in(a_data_3_2_to_3_3),
  .b_data_in(b_data_2_3_to_3_3),
  .c_data_in(c_data_3_2_to_3_3),
  .c_data_out(c_data_3_3_to_3_4),
  .a_data_out(a_data_3_3_to_3_4),
  .b_data_out(b_data_3_3_to_4_3),
  .a_addr(a_addr_3_3_NC),
  .b_addr(b_addr_3_3_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd3),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 3_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_4_to_3_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_4_to_4_4;
  wire [`AWIDTH-1:0] a_addr_3_4_NC;
  wire [`AWIDTH-1:0] b_addr_3_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_4_to_3_5;

matmul_4x4_systolic u_matmul_4x4_systolic_3_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_4),
  .a_data(a_data_3_4_NC),
  .b_data(b_data_3_4_NC),
  .a_data_in(a_data_3_3_to_3_4),
  .b_data_in(b_data_2_4_to_3_4),
  .c_data_in(c_data_3_3_to_3_4),
  .c_data_out(c_data_3_4_to_3_5),
  .a_data_out(a_data_3_4_to_3_5),
  .b_data_out(b_data_3_4_to_4_4),
  .a_addr(a_addr_3_4_NC),
  .b_addr(b_addr_3_4_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd3),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 3_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_5_to_3_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_5_to_4_5;
  wire [`AWIDTH-1:0] a_addr_3_5_NC;
  wire [`AWIDTH-1:0] b_addr_3_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_5_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_3_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_5),
  .a_data(a_data_3_5_NC),
  .b_data(b_data_3_5_NC),
  .a_data_in(a_data_3_4_to_3_5),
  .b_data_in(b_data_2_5_to_3_5),
  .c_data_in(c_data_3_4_to_3_5),
  .c_data_out(c_data_row_3),
  .a_data_out(a_data_3_5_to_3_6),
  .b_data_out(b_data_3_5_to_4_5),
  .a_addr(a_addr_3_5_NC),
  .b_addr(b_addr_3_5_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd3),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 4_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0_to_4_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_0_to_5_0;
  wire [`AWIDTH-1:0] b_addr_4_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_4_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_0_to_4_1;

matmul_4x4_systolic u_matmul_4x4_systolic_4_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_0),
  .a_data(a_data_4_0),
  .b_data(b_data_4_0_NC),
  .a_data_in(a_data_in_4_0_NC),
  .b_data_in(b_data_3_0_to_4_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_4_0_to_4_1),
  .a_data_out(a_data_4_0_to_4_1),
  .b_data_out(b_data_4_0_to_5_0),
  .a_addr(a_addr_4_0),
  .b_addr(b_addr_4_0_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd4),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 4_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_1_to_4_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_1_to_5_1;
  wire [`AWIDTH-1:0] a_addr_4_1_NC;
  wire [`AWIDTH-1:0] b_addr_4_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_1_to_4_2;

matmul_4x4_systolic u_matmul_4x4_systolic_4_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_1),
  .a_data(a_data_4_1_NC),
  .b_data(b_data_4_1_NC),
  .a_data_in(a_data_4_0_to_4_1),
  .b_data_in(b_data_3_1_to_4_1),
  .c_data_in(c_data_4_0_to_4_1),
  .c_data_out(c_data_4_1_to_4_2),
  .a_data_out(a_data_4_1_to_4_2),
  .b_data_out(b_data_4_1_to_5_1),
  .a_addr(a_addr_4_1_NC),
  .b_addr(b_addr_4_1_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd4),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 4_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_2_to_4_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_2_to_5_2;
  wire [`AWIDTH-1:0] a_addr_4_2_NC;
  wire [`AWIDTH-1:0] b_addr_4_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_2_to_4_3;

matmul_4x4_systolic u_matmul_4x4_systolic_4_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_2),
  .a_data(a_data_4_2_NC),
  .b_data(b_data_4_2_NC),
  .a_data_in(a_data_4_1_to_4_2),
  .b_data_in(b_data_3_2_to_4_2),
  .c_data_in(c_data_4_1_to_4_2),
  .c_data_out(c_data_4_2_to_4_3),
  .a_data_out(a_data_4_2_to_4_3),
  .b_data_out(b_data_4_2_to_5_2),
  .a_addr(a_addr_4_2_NC),
  .b_addr(b_addr_4_2_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd4),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 4_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_3_to_4_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_3_to_5_3;
  wire [`AWIDTH-1:0] a_addr_4_3_NC;
  wire [`AWIDTH-1:0] b_addr_4_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_3_to_4_4;

matmul_4x4_systolic u_matmul_4x4_systolic_4_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_3),
  .a_data(a_data_4_3_NC),
  .b_data(b_data_4_3_NC),
  .a_data_in(a_data_4_2_to_4_3),
  .b_data_in(b_data_3_3_to_4_3),
  .c_data_in(c_data_4_2_to_4_3),
  .c_data_out(c_data_4_3_to_4_4),
  .a_data_out(a_data_4_3_to_4_4),
  .b_data_out(b_data_4_3_to_5_3),
  .a_addr(a_addr_4_3_NC),
  .b_addr(b_addr_4_3_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd4),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 4_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_4_to_4_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_4_to_5_4;
  wire [`AWIDTH-1:0] a_addr_4_4_NC;
  wire [`AWIDTH-1:0] b_addr_4_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_4_to_4_5;

matmul_4x4_systolic u_matmul_4x4_systolic_4_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_4),
  .a_data(a_data_4_4_NC),
  .b_data(b_data_4_4_NC),
  .a_data_in(a_data_4_3_to_4_4),
  .b_data_in(b_data_3_4_to_4_4),
  .c_data_in(c_data_4_3_to_4_4),
  .c_data_out(c_data_4_4_to_4_5),
  .a_data_out(a_data_4_4_to_4_5),
  .b_data_out(b_data_4_4_to_5_4),
  .a_addr(a_addr_4_4_NC),
  .b_addr(b_addr_4_4_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd4),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 4_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_5_to_4_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_5_to_5_5;
  wire [`AWIDTH-1:0] a_addr_4_5_NC;
  wire [`AWIDTH-1:0] b_addr_4_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_5_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_4_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_5),
  .a_data(a_data_4_5_NC),
  .b_data(b_data_4_5_NC),
  .a_data_in(a_data_4_4_to_4_5),
  .b_data_in(b_data_3_5_to_4_5),
  .c_data_in(c_data_4_4_to_4_5),
  .c_data_out(c_data_row_4),
  .a_data_out(a_data_4_5_to_4_6),
  .b_data_out(b_data_4_5_to_5_5),
  .a_addr(a_addr_4_5_NC),
  .b_addr(b_addr_4_5_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd4),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 5_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_0_to_5_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_0_to_6_0;
  wire [`AWIDTH-1:0] b_addr_5_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_5_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_0_to_5_1;

matmul_4x4_systolic u_matmul_4x4_systolic_5_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_0),
  .a_data(a_data_5_0),
  .b_data(b_data_5_0_NC),
  .a_data_in(a_data_in_5_0_NC),
  .b_data_in(b_data_4_0_to_5_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_5_0_to_5_1),
  .a_data_out(a_data_5_0_to_5_1),
  .b_data_out(b_data_5_0_to_6_0),
  .a_addr(a_addr_5_0),
  .b_addr(b_addr_5_0_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd5),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 5_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_1_to_5_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_1_to_6_1;
  wire [`AWIDTH-1:0] a_addr_5_1_NC;
  wire [`AWIDTH-1:0] b_addr_5_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_1_to_5_2;

matmul_4x4_systolic u_matmul_4x4_systolic_5_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_1),
  .a_data(a_data_5_1_NC),
  .b_data(b_data_5_1_NC),
  .a_data_in(a_data_5_0_to_5_1),
  .b_data_in(b_data_4_1_to_5_1),
  .c_data_in(c_data_5_0_to_5_1),
  .c_data_out(c_data_5_1_to_5_2),
  .a_data_out(a_data_5_1_to_5_2),
  .b_data_out(b_data_5_1_to_6_1),
  .a_addr(a_addr_5_1_NC),
  .b_addr(b_addr_5_1_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd5),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 5_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_2_to_5_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_2_to_6_2;
  wire [`AWIDTH-1:0] a_addr_5_2_NC;
  wire [`AWIDTH-1:0] b_addr_5_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_2_to_5_3;

matmul_4x4_systolic u_matmul_4x4_systolic_5_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_2),
  .a_data(a_data_5_2_NC),
  .b_data(b_data_5_2_NC),
  .a_data_in(a_data_5_1_to_5_2),
  .b_data_in(b_data_4_2_to_5_2),
  .c_data_in(c_data_5_1_to_5_2),
  .c_data_out(c_data_5_2_to_5_3),
  .a_data_out(a_data_5_2_to_5_3),
  .b_data_out(b_data_5_2_to_6_2),
  .a_addr(a_addr_5_2_NC),
  .b_addr(b_addr_5_2_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd5),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 5_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_3_to_5_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_3_to_6_3;
  wire [`AWIDTH-1:0] a_addr_5_3_NC;
  wire [`AWIDTH-1:0] b_addr_5_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_3_to_5_4;

matmul_4x4_systolic u_matmul_4x4_systolic_5_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_3),
  .a_data(a_data_5_3_NC),
  .b_data(b_data_5_3_NC),
  .a_data_in(a_data_5_2_to_5_3),
  .b_data_in(b_data_4_3_to_5_3),
  .c_data_in(c_data_5_2_to_5_3),
  .c_data_out(c_data_5_3_to_5_4),
  .a_data_out(a_data_5_3_to_5_4),
  .b_data_out(b_data_5_3_to_6_3),
  .a_addr(a_addr_5_3_NC),
  .b_addr(b_addr_5_3_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd5),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 5_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_4_to_5_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_4_to_6_4;
  wire [`AWIDTH-1:0] a_addr_5_4_NC;
  wire [`AWIDTH-1:0] b_addr_5_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_4_to_5_5;

matmul_4x4_systolic u_matmul_4x4_systolic_5_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_4),
  .a_data(a_data_5_4_NC),
  .b_data(b_data_5_4_NC),
  .a_data_in(a_data_5_3_to_5_4),
  .b_data_in(b_data_4_4_to_5_4),
  .c_data_in(c_data_5_3_to_5_4),
  .c_data_out(c_data_5_4_to_5_5),
  .a_data_out(a_data_5_4_to_5_5),
  .b_data_out(b_data_5_4_to_6_4),
  .a_addr(a_addr_5_4_NC),
  .b_addr(b_addr_5_4_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd5),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 5_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_5_to_5_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_5_to_6_5;
  wire [`AWIDTH-1:0] a_addr_5_5_NC;
  wire [`AWIDTH-1:0] b_addr_5_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_5_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_5_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_5),
  .a_data(a_data_5_5_NC),
  .b_data(b_data_5_5_NC),
  .a_data_in(a_data_5_4_to_5_5),
  .b_data_in(b_data_4_5_to_5_5),
  .c_data_in(c_data_5_4_to_5_5),
  .c_data_out(c_data_row_5),
  .a_data_out(a_data_5_5_to_5_6),
  .b_data_out(b_data_5_5_to_6_5),
  .a_addr(a_addr_5_5_NC),
  .b_addr(b_addr_5_5_NC),
  .final_mat_mul_size(8'd24),
  .a_loc(8'd5),
  .b_loc(8'd5)
);

endmodule

module ram (addr0, d0, we0, q0, clk);

input [`AWIDTH-1:0] addr0;
input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] d0;
input we0;
output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] q0;
input clk;

single_port_ram u_single_port_ram(
  .data(d0),
  .we(we0),
  .addr(addr0),
  .clk(clk),
  .out(q0)
);
endmodule