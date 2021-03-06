`timescale 1ns/1ns
`define DWIDTH 8
`define AWIDTH 7
`define MEM_SIZE 128
`define MAT_MUL_SIZE 4
`define LOG2_MAT_MUL_SIZE 2
`define BB_MAT_MUL_SIZE `MAT_MUL_SIZE
`define NUM_CYCLES_IN_MAC 3


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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_0;

  wire [`AWIDTH-1:0] a_addr_0_0;
  wire [`AWIDTH-1:0] a_addr_1_0;
  wire [`AWIDTH-1:0] a_addr_2_0;
  wire [`AWIDTH-1:0] a_addr_3_0;
  wire [`AWIDTH-1:0] a_addr_4_0;
  wire [`AWIDTH-1:0] a_addr_5_0;
  wire [`AWIDTH-1:0] a_addr_6_0;
  wire [`AWIDTH-1:0] a_addr_7_0;
  wire [`AWIDTH-1:0] a_addr_8_0;
  wire [`AWIDTH-1:0] a_addr_9_0;
  wire [`AWIDTH-1:0] a_addr_10_0;
  wire [`AWIDTH-1:0] a_addr_11_0;
  wire [`AWIDTH-1:0] a_addr_12_0;
  wire [`AWIDTH-1:0] a_addr_13_0;
  wire [`AWIDTH-1:0] a_addr_14_0;
  wire [`AWIDTH-1:0] a_addr_15_0;

  wire [`AWIDTH-1:0] a_addr_muxed_0_0;
  wire [`AWIDTH-1:0] a_addr_muxed_1_0;
  wire [`AWIDTH-1:0] a_addr_muxed_2_0;
  wire [`AWIDTH-1:0] a_addr_muxed_3_0;
  wire [`AWIDTH-1:0] a_addr_muxed_4_0;
  wire [`AWIDTH-1:0] a_addr_muxed_5_0;
  wire [`AWIDTH-1:0] a_addr_muxed_6_0;
  wire [`AWIDTH-1:0] a_addr_muxed_7_0;
  wire [`AWIDTH-1:0] a_addr_muxed_8_0;
  wire [`AWIDTH-1:0] a_addr_muxed_9_0;
  wire [`AWIDTH-1:0] a_addr_muxed_10_0;
  wire [`AWIDTH-1:0] a_addr_muxed_11_0;
  wire [`AWIDTH-1:0] a_addr_muxed_12_0;
  wire [`AWIDTH-1:0] a_addr_muxed_13_0;
  wire [`AWIDTH-1:0] a_addr_muxed_14_0;
  wire [`AWIDTH-1:0] a_addr_muxed_15_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_5_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_6_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_7_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_8_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_9_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_10_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_11_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_12_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_13_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_14_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_15_0_reg;

  reg  [`AWIDTH-1:0] a_addr_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_5_0_reg;
  reg  [`AWIDTH-1:0] a_addr_6_0_reg;
  reg  [`AWIDTH-1:0] a_addr_7_0_reg;
  reg  [`AWIDTH-1:0] a_addr_8_0_reg;
  reg  [`AWIDTH-1:0] a_addr_9_0_reg;
  reg  [`AWIDTH-1:0] a_addr_10_0_reg;
  reg  [`AWIDTH-1:0] a_addr_11_0_reg;
  reg  [`AWIDTH-1:0] a_addr_12_0_reg;
  reg  [`AWIDTH-1:0] a_addr_13_0_reg;
  reg  [`AWIDTH-1:0] a_addr_14_0_reg;
  reg  [`AWIDTH-1:0] a_addr_15_0_reg;


  always @(posedge clk_mem) begin
    if(reset) begin
      a_addr_0_0_reg <= `MEM_SIZE-1;
      a_addr_1_0_reg <= `MEM_SIZE-1;
      a_addr_2_0_reg <= `MEM_SIZE-1;
      a_addr_3_0_reg <= `MEM_SIZE-1;
      a_addr_4_0_reg <= `MEM_SIZE-1;
      a_addr_5_0_reg <= `MEM_SIZE-1;
      a_addr_6_0_reg <= `MEM_SIZE-1;
      a_addr_7_0_reg <= `MEM_SIZE-1;
      a_addr_8_0_reg <= `MEM_SIZE-1;
      a_addr_9_0_reg <= `MEM_SIZE-1;
      a_addr_10_0_reg <= `MEM_SIZE-1;
      a_addr_11_0_reg <= `MEM_SIZE-1;
      a_addr_12_0_reg <= `MEM_SIZE-1;
      a_addr_13_0_reg <= `MEM_SIZE-1;
      a_addr_14_0_reg <= `MEM_SIZE-1;
      a_addr_15_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_0_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_1_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_2_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_3_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_4_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_5_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_6_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_7_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_8_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_9_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_10_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_11_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_12_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_13_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_14_0_reg <= `MEM_SIZE-1;
      a_addr_muxed_15_0_reg <= `MEM_SIZE-1;
    end else begin
      a_addr_0_0_reg <= a_addr_0_0;
      a_addr_1_0_reg <= a_addr_1_0;
      a_addr_2_0_reg <= a_addr_2_0;
      a_addr_3_0_reg <= a_addr_3_0;
      a_addr_4_0_reg <= a_addr_4_0;
      a_addr_5_0_reg <= a_addr_5_0;
      a_addr_6_0_reg <= a_addr_6_0;
      a_addr_7_0_reg <= a_addr_7_0;
      a_addr_8_0_reg <= a_addr_8_0;
      a_addr_9_0_reg <= a_addr_9_0;
      a_addr_10_0_reg <= a_addr_10_0;
      a_addr_11_0_reg <= a_addr_11_0;
      a_addr_12_0_reg <= a_addr_12_0;
      a_addr_13_0_reg <= a_addr_13_0;
      a_addr_14_0_reg <= a_addr_14_0;
      a_addr_15_0_reg <= a_addr_15_0;
      a_addr_muxed_0_0_reg <= a_addr_muxed_0_0;
      a_addr_muxed_1_0_reg <= a_addr_muxed_1_0;
      a_addr_muxed_2_0_reg <= a_addr_muxed_2_0;
      a_addr_muxed_3_0_reg <= a_addr_muxed_3_0;
      a_addr_muxed_4_0_reg <= a_addr_muxed_4_0;
      a_addr_muxed_5_0_reg <= a_addr_muxed_5_0;
      a_addr_muxed_6_0_reg <= a_addr_muxed_6_0;
      a_addr_muxed_7_0_reg <= a_addr_muxed_7_0;
      a_addr_muxed_8_0_reg <= a_addr_muxed_8_0;
      a_addr_muxed_9_0_reg <= a_addr_muxed_9_0;
      a_addr_muxed_10_0_reg <= a_addr_muxed_10_0;
      a_addr_muxed_11_0_reg <= a_addr_muxed_11_0;
      a_addr_muxed_12_0_reg <= a_addr_muxed_12_0;
      a_addr_muxed_13_0_reg <= a_addr_muxed_13_0;
      a_addr_muxed_14_0_reg <= a_addr_muxed_14_0;
      a_addr_muxed_15_0_reg <= a_addr_muxed_15_0;
    end
  end

  assign a_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_0_0_reg;
  assign a_addr_muxed_1_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_1_0_reg;
  assign a_addr_muxed_2_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_2_0_reg;
  assign a_addr_muxed_3_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_3_0_reg;
  assign a_addr_muxed_4_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_4_0_reg;
  assign a_addr_muxed_5_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_5_0_reg;
  assign a_addr_muxed_6_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_6_0_reg;
  assign a_addr_muxed_7_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_7_0_reg;
  assign a_addr_muxed_8_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_8_0_reg;
  assign a_addr_muxed_9_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_9_0_reg;
  assign a_addr_muxed_10_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_10_0_reg;
  assign a_addr_muxed_11_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_11_0_reg;
  assign a_addr_muxed_12_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_12_0_reg;
  assign a_addr_muxed_13_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_13_0_reg;
  assign a_addr_muxed_14_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_14_0_reg;
  assign a_addr_muxed_15_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_15_0_reg;

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

  // BRAM matrix A 6_0
  ram matrix_A_6_0 (
    .addr0(a_addr_muxed_6_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_6_0),
    .clk(clk_mem));

  // BRAM matrix A 7_0
  ram matrix_A_7_0 (
    .addr0(a_addr_muxed_7_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_7_0),
    .clk(clk_mem));

  // BRAM matrix A 8_0
  ram matrix_A_8_0 (
    .addr0(a_addr_muxed_8_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_8_0),
    .clk(clk_mem));

  // BRAM matrix A 9_0
  ram matrix_A_9_0 (
    .addr0(a_addr_muxed_9_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_9_0),
    .clk(clk_mem));

  // BRAM matrix A 10_0
  ram matrix_A_10_0 (
    .addr0(a_addr_muxed_10_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_10_0),
    .clk(clk_mem));

  // BRAM matrix A 11_0
  ram matrix_A_11_0 (
    .addr0(a_addr_muxed_11_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_11_0),
    .clk(clk_mem));

  // BRAM matrix A 12_0
  ram matrix_A_12_0 (
    .addr0(a_addr_muxed_12_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_12_0),
    .clk(clk_mem));

  // BRAM matrix A 13_0
  ram matrix_A_13_0 (
    .addr0(a_addr_muxed_13_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_13_0),
    .clk(clk_mem));

  // BRAM matrix A 14_0
  ram matrix_A_14_0 (
    .addr0(a_addr_muxed_14_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_14_0),
    .clk(clk_mem));

  // BRAM matrix A 15_0
  ram matrix_A_15_0 (
    .addr0(a_addr_muxed_15_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_15_0),
    .clk(clk_mem));

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_0_reg;
  always @(posedge clk_mem) begin
    if (reset) begin
      a_data_0_0_reg <= 0;
      a_data_1_0_reg <= 0;
      a_data_2_0_reg <= 0;
      a_data_3_0_reg <= 0;
      a_data_4_0_reg <= 0;
      a_data_5_0_reg <= 0;
      a_data_6_0_reg <= 0;
      a_data_7_0_reg <= 0;
      a_data_8_0_reg <= 0;
      a_data_9_0_reg <= 0;
      a_data_10_0_reg <= 0;
      a_data_11_0_reg <= 0;
      a_data_12_0_reg <= 0;
      a_data_13_0_reg <= 0;
      a_data_14_0_reg <= 0;
      a_data_15_0_reg <= 0;
    end else begin
      a_data_0_0_reg <= a_data_0_0;
      a_data_1_0_reg <= a_data_1_0;
      a_data_2_0_reg <= a_data_2_0;
      a_data_3_0_reg <= a_data_3_0;
      a_data_4_0_reg <= a_data_4_0;
      a_data_5_0_reg <= a_data_5_0;
      a_data_6_0_reg <= a_data_6_0;
      a_data_7_0_reg <= a_data_7_0;
      a_data_8_0_reg <= a_data_8_0;
      a_data_9_0_reg <= a_data_9_0;
      a_data_10_0_reg <= a_data_10_0;
      a_data_11_0_reg <= a_data_11_0;
      a_data_12_0_reg <= a_data_12_0;
      a_data_13_0_reg <= a_data_13_0;
      a_data_14_0_reg <= a_data_14_0;
      a_data_15_0_reg <= a_data_15_0;
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_15;

  wire [`AWIDTH-1:0] b_addr_0_0;
  wire [`AWIDTH-1:0] b_addr_0_1;
  wire [`AWIDTH-1:0] b_addr_0_2;
  wire [`AWIDTH-1:0] b_addr_0_3;
  wire [`AWIDTH-1:0] b_addr_0_4;
  wire [`AWIDTH-1:0] b_addr_0_5;
  wire [`AWIDTH-1:0] b_addr_0_6;
  wire [`AWIDTH-1:0] b_addr_0_7;
  wire [`AWIDTH-1:0] b_addr_0_8;
  wire [`AWIDTH-1:0] b_addr_0_9;
  wire [`AWIDTH-1:0] b_addr_0_10;
  wire [`AWIDTH-1:0] b_addr_0_11;
  wire [`AWIDTH-1:0] b_addr_0_12;
  wire [`AWIDTH-1:0] b_addr_0_13;
  wire [`AWIDTH-1:0] b_addr_0_14;
  wire [`AWIDTH-1:0] b_addr_0_15;

  wire [`AWIDTH-1:0] b_addr_muxed_0_0;
  wire [`AWIDTH-1:0] b_addr_muxed_0_1;
  wire [`AWIDTH-1:0] b_addr_muxed_0_2;
  wire [`AWIDTH-1:0] b_addr_muxed_0_3;
  wire [`AWIDTH-1:0] b_addr_muxed_0_4;
  wire [`AWIDTH-1:0] b_addr_muxed_0_5;
  wire [`AWIDTH-1:0] b_addr_muxed_0_6;
  wire [`AWIDTH-1:0] b_addr_muxed_0_7;
  wire [`AWIDTH-1:0] b_addr_muxed_0_8;
  wire [`AWIDTH-1:0] b_addr_muxed_0_9;
  wire [`AWIDTH-1:0] b_addr_muxed_0_10;
  wire [`AWIDTH-1:0] b_addr_muxed_0_11;
  wire [`AWIDTH-1:0] b_addr_muxed_0_12;
  wire [`AWIDTH-1:0] b_addr_muxed_0_13;
  wire [`AWIDTH-1:0] b_addr_muxed_0_14;
  wire [`AWIDTH-1:0] b_addr_muxed_0_15;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_5_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_6_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_7_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_8_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_9_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_10_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_11_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_12_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_13_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_14_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_15_reg;

  reg  [`AWIDTH-1:0] b_addr_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_0_5_reg;
  reg  [`AWIDTH-1:0] b_addr_0_6_reg;
  reg  [`AWIDTH-1:0] b_addr_0_7_reg;
  reg  [`AWIDTH-1:0] b_addr_0_8_reg;
  reg  [`AWIDTH-1:0] b_addr_0_9_reg;
  reg  [`AWIDTH-1:0] b_addr_0_10_reg;
  reg  [`AWIDTH-1:0] b_addr_0_11_reg;
  reg  [`AWIDTH-1:0] b_addr_0_12_reg;
  reg  [`AWIDTH-1:0] b_addr_0_13_reg;
  reg  [`AWIDTH-1:0] b_addr_0_14_reg;
  reg  [`AWIDTH-1:0] b_addr_0_15_reg;



  always @(posedge clk_mem) begin
    if(reset) begin
      b_addr_0_0_reg <= `MEM_SIZE-1;
      b_addr_0_1_reg <= `MEM_SIZE-1;
      b_addr_0_2_reg <= `MEM_SIZE-1;
      b_addr_0_3_reg <= `MEM_SIZE-1;
      b_addr_0_4_reg <= `MEM_SIZE-1;
      b_addr_0_5_reg <= `MEM_SIZE-1;
      b_addr_0_6_reg <= `MEM_SIZE-1;
      b_addr_0_7_reg <= `MEM_SIZE-1;
      b_addr_0_8_reg <= `MEM_SIZE-1;
      b_addr_0_9_reg <= `MEM_SIZE-1;
      b_addr_0_10_reg <= `MEM_SIZE-1;
      b_addr_0_11_reg <= `MEM_SIZE-1;
      b_addr_0_12_reg <= `MEM_SIZE-1;
      b_addr_0_13_reg <= `MEM_SIZE-1;
      b_addr_0_14_reg <= `MEM_SIZE-1;
      b_addr_0_15_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_0_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_1_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_2_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_3_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_4_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_5_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_6_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_7_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_8_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_9_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_10_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_11_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_12_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_13_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_14_reg <= `MEM_SIZE-1;
      b_addr_muxed_0_15_reg <= `MEM_SIZE-1;
    end else begin
      b_addr_0_0_reg <= b_addr_0_0;
      b_addr_0_1_reg <= b_addr_0_1;
      b_addr_0_2_reg <= b_addr_0_2;
      b_addr_0_3_reg <= b_addr_0_3;
      b_addr_0_4_reg <= b_addr_0_4;
      b_addr_0_5_reg <= b_addr_0_5;
      b_addr_0_6_reg <= b_addr_0_6;
      b_addr_0_7_reg <= b_addr_0_7;
      b_addr_0_8_reg <= b_addr_0_8;
      b_addr_0_9_reg <= b_addr_0_9;
      b_addr_0_10_reg <= b_addr_0_10;
      b_addr_0_11_reg <= b_addr_0_11;
      b_addr_0_12_reg <= b_addr_0_12;
      b_addr_0_13_reg <= b_addr_0_13;
      b_addr_0_14_reg <= b_addr_0_14;
      b_addr_0_15_reg <= b_addr_0_15;
      b_addr_muxed_0_0_reg <= b_addr_muxed_0_0;
      b_addr_muxed_0_1_reg <= b_addr_muxed_0_1;
      b_addr_muxed_0_2_reg <= b_addr_muxed_0_2;
      b_addr_muxed_0_3_reg <= b_addr_muxed_0_3;
      b_addr_muxed_0_4_reg <= b_addr_muxed_0_4;
      b_addr_muxed_0_5_reg <= b_addr_muxed_0_5;
      b_addr_muxed_0_6_reg <= b_addr_muxed_0_6;
      b_addr_muxed_0_7_reg <= b_addr_muxed_0_7;
      b_addr_muxed_0_8_reg <= b_addr_muxed_0_8;
      b_addr_muxed_0_9_reg <= b_addr_muxed_0_9;
      b_addr_muxed_0_10_reg <= b_addr_muxed_0_10;
      b_addr_muxed_0_11_reg <= b_addr_muxed_0_11;
      b_addr_muxed_0_12_reg <= b_addr_muxed_0_12;
      b_addr_muxed_0_13_reg <= b_addr_muxed_0_13;
      b_addr_muxed_0_14_reg <= b_addr_muxed_0_14;
      b_addr_muxed_0_15_reg <= b_addr_muxed_0_15;
    end
  end

  assign b_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_0_reg;
  assign b_addr_muxed_0_1 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_1_reg;
  assign b_addr_muxed_0_2 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_2_reg;
  assign b_addr_muxed_0_3 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_3_reg;
  assign b_addr_muxed_0_4 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_4_reg;
  assign b_addr_muxed_0_5 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_5_reg;
  assign b_addr_muxed_0_6 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_6_reg;
  assign b_addr_muxed_0_7 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_7_reg;
  assign b_addr_muxed_0_8 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_8_reg;
  assign b_addr_muxed_0_9 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_9_reg;
  assign b_addr_muxed_0_10 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_10_reg;
  assign b_addr_muxed_0_11 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_11_reg;
  assign b_addr_muxed_0_12 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_12_reg;
  assign b_addr_muxed_0_13 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_13_reg;
  assign b_addr_muxed_0_14 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_14_reg;
  assign b_addr_muxed_0_15 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_15_reg;

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

  // BRAM matrix B 0_6
  ram matrix_B_0_6 (
    .addr0(b_addr_muxed_0_6_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_6),
    .clk(clk_mem));

  // BRAM matrix B 0_7
  ram matrix_B_0_7 (
    .addr0(b_addr_muxed_0_7_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_7),
    .clk(clk_mem));

  // BRAM matrix B 0_8
  ram matrix_B_0_8 (
    .addr0(b_addr_muxed_0_8_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_8),
    .clk(clk_mem));

  // BRAM matrix B 0_9
  ram matrix_B_0_9 (
    .addr0(b_addr_muxed_0_9_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_9),
    .clk(clk_mem));

  // BRAM matrix B 0_10
  ram matrix_B_0_10 (
    .addr0(b_addr_muxed_0_10_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_10),
    .clk(clk_mem));

  // BRAM matrix B 0_11
  ram matrix_B_0_11 (
    .addr0(b_addr_muxed_0_11_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_11),
    .clk(clk_mem));

  // BRAM matrix B 0_12
  ram matrix_B_0_12 (
    .addr0(b_addr_muxed_0_12_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_12),
    .clk(clk_mem));

  // BRAM matrix B 0_13
  ram matrix_B_0_13 (
    .addr0(b_addr_muxed_0_13_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_13),
    .clk(clk_mem));

  // BRAM matrix B 0_14
  ram matrix_B_0_14 (
    .addr0(b_addr_muxed_0_14_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_14),
    .clk(clk_mem));

  // BRAM matrix B 0_15
  ram matrix_B_0_15 (
    .addr0(b_addr_muxed_0_15_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_15),
    .clk(clk_mem));

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_6_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_7_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_8_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_9_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_10_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_11_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_12_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_13_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_14_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_15_reg;
  always @(posedge clk_mem) begin
    if (reset) begin
      b_data_0_0_reg <= 0;
      b_data_0_1_reg <= 0;
      b_data_0_2_reg <= 0;
      b_data_0_3_reg <= 0;
      b_data_0_4_reg <= 0;
      b_data_0_5_reg <= 0;
      b_data_0_6_reg <= 0;
      b_data_0_7_reg <= 0;
      b_data_0_8_reg <= 0;
      b_data_0_9_reg <= 0;
      b_data_0_10_reg <= 0;
      b_data_0_11_reg <= 0;
      b_data_0_12_reg <= 0;
      b_data_0_13_reg <= 0;
      b_data_0_14_reg <= 0;
      b_data_0_15_reg <= 0;
    end else begin
      b_data_0_0_reg <= b_data_0_0;
      b_data_0_1_reg <= b_data_0_1;
      b_data_0_2_reg <= b_data_0_2;
      b_data_0_3_reg <= b_data_0_3;
      b_data_0_4_reg <= b_data_0_4;
      b_data_0_5_reg <= b_data_0_5;
      b_data_0_6_reg <= b_data_0_6;
      b_data_0_7_reg <= b_data_0_7;
      b_data_0_8_reg <= b_data_0_8;
      b_data_0_9_reg <= b_data_0_9;
      b_data_0_10_reg <= b_data_0_10;
      b_data_0_11_reg <= b_data_0_11;
      b_data_0_12_reg <= b_data_0_12;
      b_data_0_13_reg <= b_data_0_13;
      b_data_0_14_reg <= b_data_0_14;
      b_data_0_15_reg <= b_data_0_15;
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
  wire [`AWIDTH-1:0] c_addr_muxed_0_6;
  wire [`AWIDTH-1:0] c_addr_muxed_0_7;
  wire [`AWIDTH-1:0] c_addr_muxed_0_8;
  wire [`AWIDTH-1:0] c_addr_muxed_0_9;
  wire [`AWIDTH-1:0] c_addr_muxed_0_10;
  wire [`AWIDTH-1:0] c_addr_muxed_0_11;
  wire [`AWIDTH-1:0] c_addr_muxed_0_12;
  wire [`AWIDTH-1:0] c_addr_muxed_0_13;
  wire [`AWIDTH-1:0] c_addr_muxed_0_14;
  wire [`AWIDTH-1:0] c_addr_muxed_0_15;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_5_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_6_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_7_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_8_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_9_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_10_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_11_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_12_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_13_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_14_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_15_reg;

  assign c_addr_muxed_0_0 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_1 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_2 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_3 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_4 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_5 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_6 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_7 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_8 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_9 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_10 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_11 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_12 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_13 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_14 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_15 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;

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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_15;

///////////////// ORing the data ///////////////////

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_1;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_2;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_3;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_4;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_5;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_6;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_7;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_8;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_9;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_10;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_11;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_12;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_13;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_14;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_3_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_4_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_5_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_6_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_7_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_8_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_9_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_10_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_11_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_12_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_13_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_14_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_15_reg;

  always @(posedge clk_mem) begin
    if(reset) begin
      data_from_out_mat_0_0_reg <= 0;
      data_from_out_mat_0_1_reg <= 0;
      data_from_out_mat_0_2_reg <= 0;
      data_from_out_mat_0_3_reg <= 0;
      data_from_out_mat_0_4_reg <= 0;
      data_from_out_mat_0_5_reg <= 0;
      data_from_out_mat_0_6_reg <= 0;
      data_from_out_mat_0_7_reg <= 0;
      data_from_out_mat_0_8_reg <= 0;
      data_from_out_mat_0_9_reg <= 0;
      data_from_out_mat_0_10_reg <= 0;
      data_from_out_mat_0_11_reg <= 0;
      data_from_out_mat_0_12_reg <= 0;
      data_from_out_mat_0_13_reg <= 0;
      data_from_out_mat_0_14_reg <= 0;
      data_from_out_mat_0_15_reg <= 0;
    end else begin
      data_from_out_mat_0_0_reg <= data_from_out_mat_0_0;
      data_from_out_mat_0_1_reg <= data_from_out_mat_0_1;
      data_from_out_mat_0_2_reg <= data_from_out_mat_0_2;
      data_from_out_mat_0_3_reg <= data_from_out_mat_0_3;
      data_from_out_mat_0_4_reg <= data_from_out_mat_0_4;
      data_from_out_mat_0_5_reg <= data_from_out_mat_0_5;
      data_from_out_mat_0_6_reg <= data_from_out_mat_0_6;
      data_from_out_mat_0_7_reg <= data_from_out_mat_0_7;
      data_from_out_mat_0_8_reg <= data_from_out_mat_0_8;
      data_from_out_mat_0_9_reg <= data_from_out_mat_0_9;
      data_from_out_mat_0_10_reg <= data_from_out_mat_0_10;
      data_from_out_mat_0_11_reg <= data_from_out_mat_0_11;
      data_from_out_mat_0_12_reg <= data_from_out_mat_0_12;
      data_from_out_mat_0_13_reg <= data_from_out_mat_0_13;
      data_from_out_mat_0_14_reg <= data_from_out_mat_0_14;
      data_from_out_mat_0_15_reg <= data_from_out_mat_0_15;
    end
  end

  always @(posedge clk_mem) begin
    if(reset) begin
      data_from_out_mat <= 0;
      c_reg_1 <= 0;
      c_reg_2 <= 0;
      c_reg_3 <= 0;
      c_reg_4 <= 0;
      c_reg_5 <= 0;
      c_reg_6 <= 0;
      c_reg_7 <= 0;
      c_reg_8 <= 0;
      c_reg_9 <= 0;
      c_reg_10 <= 0;
      c_reg_11 <= 0;
      c_reg_12 <= 0;
      c_reg_13 <= 0;
      c_reg_14 <= 0;
    end else begin
      c_reg_1 <= data_from_out_mat_0_0_reg | data_from_out_mat_0_1_reg;
      c_reg_2 <= c_reg_1 | data_from_out_mat_0_2_reg;
      c_reg_3 <= c_reg_2 | data_from_out_mat_0_3_reg;
      c_reg_4 <= c_reg_3 | data_from_out_mat_0_4_reg;
      c_reg_5 <= c_reg_4 | data_from_out_mat_0_5_reg;
      c_reg_6 <= c_reg_5 | data_from_out_mat_0_6_reg;
      c_reg_7 <= c_reg_6 | data_from_out_mat_0_7_reg;
      c_reg_8 <= c_reg_7 | data_from_out_mat_0_8_reg;
      c_reg_9 <= c_reg_8 | data_from_out_mat_0_9_reg;
      c_reg_10 <= c_reg_9 | data_from_out_mat_0_10_reg;
      c_reg_11 <= c_reg_10 | data_from_out_mat_0_11_reg;
      c_reg_12 <= c_reg_11 | data_from_out_mat_0_12_reg;
      c_reg_13 <= c_reg_12 | data_from_out_mat_0_13_reg;
      c_reg_14 <= c_reg_13 | data_from_out_mat_0_14_reg;
      data_from_out_mat <= c_reg_14 | data_from_out_mat_0_15_reg;
    end
  end

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_3_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_4_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_5_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_6_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_7_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_8_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_9_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_10_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_11_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_12_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_13_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_14_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_15_reg;
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
      c_data_row_6_reg <= 0;
      c_addr_muxed_0_6_reg <= 0;
      c_data_row_7_reg <= 0;
      c_addr_muxed_0_7_reg <= 0;
      c_data_row_8_reg <= 0;
      c_addr_muxed_0_8_reg <= 0;
      c_data_row_9_reg <= 0;
      c_addr_muxed_0_9_reg <= 0;
      c_data_row_10_reg <= 0;
      c_addr_muxed_0_10_reg <= 0;
      c_data_row_11_reg <= 0;
      c_addr_muxed_0_11_reg <= 0;
      c_data_row_12_reg <= 0;
      c_addr_muxed_0_12_reg <= 0;
      c_data_row_13_reg <= 0;
      c_addr_muxed_0_13_reg <= 0;
      c_data_row_14_reg <= 0;
      c_addr_muxed_0_14_reg <= 0;
      c_data_row_15_reg <= 0;
      c_addr_muxed_0_15_reg <= 0;
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
      c_data_row_6_reg <= c_data_row_6;
      c_addr_muxed_0_6_reg <= c_addr_muxed_0_6;
      c_data_row_7_reg <= c_data_row_7;
      c_addr_muxed_0_7_reg <= c_addr_muxed_0_7;
      c_data_row_8_reg <= c_data_row_8;
      c_addr_muxed_0_8_reg <= c_addr_muxed_0_8;
      c_data_row_9_reg <= c_data_row_9;
      c_addr_muxed_0_9_reg <= c_addr_muxed_0_9;
      c_data_row_10_reg <= c_data_row_10;
      c_addr_muxed_0_10_reg <= c_addr_muxed_0_10;
      c_data_row_11_reg <= c_data_row_11;
      c_addr_muxed_0_11_reg <= c_addr_muxed_0_11;
      c_data_row_12_reg <= c_data_row_12;
      c_addr_muxed_0_12_reg <= c_addr_muxed_0_12;
      c_data_row_13_reg <= c_data_row_13;
      c_addr_muxed_0_13_reg <= c_addr_muxed_0_13;
      c_data_row_14_reg <= c_data_row_14;
      c_addr_muxed_0_14_reg <= c_addr_muxed_0_14;
      c_data_row_15_reg <= c_data_row_15;
      c_addr_muxed_0_15_reg <= c_addr_muxed_0_15;
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

  //  BRAM matrix C row_6
  ram matrix_row_6 (
    .addr0(c_addr_muxed_0_6_reg),
    .d0(c_data_row_6_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_6),
    .clk(clk_mem));

  //  BRAM matrix C row_7
  ram matrix_row_7 (
    .addr0(c_addr_muxed_0_7_reg),
    .d0(c_data_row_7_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_7),
    .clk(clk_mem));

  //  BRAM matrix C row_8
  ram matrix_row_8 (
    .addr0(c_addr_muxed_0_8_reg),
    .d0(c_data_row_8_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_8),
    .clk(clk_mem));

  //  BRAM matrix C row_9
  ram matrix_row_9 (
    .addr0(c_addr_muxed_0_9_reg),
    .d0(c_data_row_9_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_9),
    .clk(clk_mem));

  //  BRAM matrix C row_10
  ram matrix_row_10 (
    .addr0(c_addr_muxed_0_10_reg),
    .d0(c_data_row_10_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_10),
    .clk(clk_mem));

  //  BRAM matrix C row_11
  ram matrix_row_11 (
    .addr0(c_addr_muxed_0_11_reg),
    .d0(c_data_row_11_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_11),
    .clk(clk_mem));

  //  BRAM matrix C row_12
  ram matrix_row_12 (
    .addr0(c_addr_muxed_0_12_reg),
    .d0(c_data_row_12_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_12),
    .clk(clk_mem));

  //  BRAM matrix C row_13
  ram matrix_row_13 (
    .addr0(c_addr_muxed_0_13_reg),
    .d0(c_data_row_13_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_13),
    .clk(clk_mem));

  //  BRAM matrix C row_14
  ram matrix_row_14 (
    .addr0(c_addr_muxed_0_14_reg),
    .d0(c_data_row_14_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_14),
    .clk(clk_mem));

  //  BRAM matrix C row_15
  ram matrix_row_15 (
    .addr0(c_addr_muxed_0_15_reg),
    .d0(c_data_row_15_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_15),
    .clk(clk_mem));

/////////////////////////////////////////////////
// The 64x64 matmul instantiation
/////////////////////////////////////////////////

matmul_64x64_systolic u_matmul_64x64_systolic (
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
  .a_data_6_0(a_data_6_0_reg),
  .a_addr_6_0(a_addr_6_0),
  .b_data_0_6(b_data_0_6_reg),
  .b_addr_0_6(b_addr_0_6),
  .a_data_7_0(a_data_7_0_reg),
  .a_addr_7_0(a_addr_7_0),
  .b_data_0_7(b_data_0_7_reg),
  .b_addr_0_7(b_addr_0_7),
  .a_data_8_0(a_data_8_0_reg),
  .a_addr_8_0(a_addr_8_0),
  .b_data_0_8(b_data_0_8_reg),
  .b_addr_0_8(b_addr_0_8),
  .a_data_9_0(a_data_9_0_reg),
  .a_addr_9_0(a_addr_9_0),
  .b_data_0_9(b_data_0_9_reg),
  .b_addr_0_9(b_addr_0_9),
  .a_data_10_0(a_data_10_0_reg),
  .a_addr_10_0(a_addr_10_0),
  .b_data_0_10(b_data_0_10_reg),
  .b_addr_0_10(b_addr_0_10),
  .a_data_11_0(a_data_11_0_reg),
  .a_addr_11_0(a_addr_11_0),
  .b_data_0_11(b_data_0_11_reg),
  .b_addr_0_11(b_addr_0_11),
  .a_data_12_0(a_data_12_0_reg),
  .a_addr_12_0(a_addr_12_0),
  .b_data_0_12(b_data_0_12_reg),
  .b_addr_0_12(b_addr_0_12),
  .a_data_13_0(a_data_13_0_reg),
  .a_addr_13_0(a_addr_13_0),
  .b_data_0_13(b_data_0_13_reg),
  .b_addr_0_13(b_addr_0_13),
  .a_data_14_0(a_data_14_0_reg),
  .a_addr_14_0(a_addr_14_0),
  .b_data_0_14(b_data_0_14_reg),
  .b_addr_0_14(b_addr_0_14),
  .a_data_15_0(a_data_15_0_reg),
  .a_addr_15_0(a_addr_15_0),
  .b_data_0_15(b_data_0_15_reg),
  .b_addr_0_15(b_addr_0_15),

  .c_data_row_0(c_data_row_0),
  .c_data_row_1(c_data_row_1),
  .c_data_row_2(c_data_row_2),
  .c_data_row_3(c_data_row_3),
  .c_data_row_4(c_data_row_4),
  .c_data_row_5(c_data_row_5),
  .c_data_row_6(c_data_row_6),
  .c_data_row_7(c_data_row_7),
  .c_data_row_8(c_data_row_8),
  .c_data_row_9(c_data_row_9),
  .c_data_row_10(c_data_row_10),
  .c_data_row_11(c_data_row_11),
  .c_data_row_12(c_data_row_12),
  .c_data_row_13(c_data_row_13),
  .c_data_row_14(c_data_row_14),
  .c_data_row_15(c_data_row_15)
);
endmodule


/////////////////////////////////////////////////
// The 64x64 matmul definition
/////////////////////////////////////////////////

module matmul_64x64_systolic(
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
  a_data_6_0,
  a_addr_6_0,
  b_data_0_6,
  b_addr_0_6,
  a_data_7_0,
  a_addr_7_0,
  b_data_0_7,
  b_addr_0_7,
  a_data_8_0,
  a_addr_8_0,
  b_data_0_8,
  b_addr_0_8,
  a_data_9_0,
  a_addr_9_0,
  b_data_0_9,
  b_addr_0_9,
  a_data_10_0,
  a_addr_10_0,
  b_data_0_10,
  b_addr_0_10,
  a_data_11_0,
  a_addr_11_0,
  b_data_0_11,
  b_addr_0_11,
  a_data_12_0,
  a_addr_12_0,
  b_data_0_12,
  b_addr_0_12,
  a_data_13_0,
  a_addr_13_0,
  b_data_0_13,
  b_addr_0_13,
  a_data_14_0,
  a_addr_14_0,
  b_data_0_14,
  b_addr_0_14,
  a_data_15_0,
  a_addr_15_0,
  b_data_0_15,
  b_addr_0_15,

  c_data_row_0,
  c_data_row_1,
  c_data_row_2,
  c_data_row_3,
  c_data_row_4,
  c_data_row_5,
  c_data_row_6,
  c_data_row_7,
  c_data_row_8,
  c_data_row_9,
  c_data_row_10,
  c_data_row_11,
  c_data_row_12,
  c_data_row_13,
  c_data_row_14,
  c_data_row_15
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
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_0;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_6;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_7;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_8;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_9;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_10;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_11;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_12;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_13;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_14;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_15;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_5;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_6;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_7;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_8;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_9;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_10;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_11;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_12;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_13;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_14;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_15;

  output [`AWIDTH-1:0] a_addr_0_0;
  output [`AWIDTH-1:0] a_addr_1_0;
  output [`AWIDTH-1:0] a_addr_2_0;
  output [`AWIDTH-1:0] a_addr_3_0;
  output [`AWIDTH-1:0] a_addr_4_0;
  output [`AWIDTH-1:0] a_addr_5_0;
  output [`AWIDTH-1:0] a_addr_6_0;
  output [`AWIDTH-1:0] a_addr_7_0;
  output [`AWIDTH-1:0] a_addr_8_0;
  output [`AWIDTH-1:0] a_addr_9_0;
  output [`AWIDTH-1:0] a_addr_10_0;
  output [`AWIDTH-1:0] a_addr_11_0;
  output [`AWIDTH-1:0] a_addr_12_0;
  output [`AWIDTH-1:0] a_addr_13_0;
  output [`AWIDTH-1:0] a_addr_14_0;
  output [`AWIDTH-1:0] a_addr_15_0;

  output [`AWIDTH-1:0] b_addr_0_0;
  output [`AWIDTH-1:0] b_addr_0_1;
  output [`AWIDTH-1:0] b_addr_0_2;
  output [`AWIDTH-1:0] b_addr_0_3;
  output [`AWIDTH-1:0] b_addr_0_4;
  output [`AWIDTH-1:0] b_addr_0_5;
  output [`AWIDTH-1:0] b_addr_0_6;
  output [`AWIDTH-1:0] b_addr_0_7;
  output [`AWIDTH-1:0] b_addr_0_8;
  output [`AWIDTH-1:0] b_addr_0_9;
  output [`AWIDTH-1:0] b_addr_0_10;
  output [`AWIDTH-1:0] b_addr_0_11;
  output [`AWIDTH-1:0] b_addr_0_12;
  output [`AWIDTH-1:0] b_addr_0_13;
  output [`AWIDTH-1:0] b_addr_0_14;
  output [`AWIDTH-1:0] b_addr_0_15;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_0_0;
  wire done_mat_mul_0_1;
  wire done_mat_mul_0_2;
  wire done_mat_mul_0_3;
  wire done_mat_mul_0_4;
  wire done_mat_mul_0_5;
  wire done_mat_mul_0_6;
  wire done_mat_mul_0_7;
  wire done_mat_mul_0_8;
  wire done_mat_mul_0_9;
  wire done_mat_mul_0_10;
  wire done_mat_mul_0_11;
  wire done_mat_mul_0_12;
  wire done_mat_mul_0_13;
  wire done_mat_mul_0_14;
  wire done_mat_mul_0_15;
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;
  wire done_mat_mul_1_2;
  wire done_mat_mul_1_3;
  wire done_mat_mul_1_4;
  wire done_mat_mul_1_5;
  wire done_mat_mul_1_6;
  wire done_mat_mul_1_7;
  wire done_mat_mul_1_8;
  wire done_mat_mul_1_9;
  wire done_mat_mul_1_10;
  wire done_mat_mul_1_11;
  wire done_mat_mul_1_12;
  wire done_mat_mul_1_13;
  wire done_mat_mul_1_14;
  wire done_mat_mul_1_15;
  wire done_mat_mul_2_0;
  wire done_mat_mul_2_1;
  wire done_mat_mul_2_2;
  wire done_mat_mul_2_3;
  wire done_mat_mul_2_4;
  wire done_mat_mul_2_5;
  wire done_mat_mul_2_6;
  wire done_mat_mul_2_7;
  wire done_mat_mul_2_8;
  wire done_mat_mul_2_9;
  wire done_mat_mul_2_10;
  wire done_mat_mul_2_11;
  wire done_mat_mul_2_12;
  wire done_mat_mul_2_13;
  wire done_mat_mul_2_14;
  wire done_mat_mul_2_15;
  wire done_mat_mul_3_0;
  wire done_mat_mul_3_1;
  wire done_mat_mul_3_2;
  wire done_mat_mul_3_3;
  wire done_mat_mul_3_4;
  wire done_mat_mul_3_5;
  wire done_mat_mul_3_6;
  wire done_mat_mul_3_7;
  wire done_mat_mul_3_8;
  wire done_mat_mul_3_9;
  wire done_mat_mul_3_10;
  wire done_mat_mul_3_11;
  wire done_mat_mul_3_12;
  wire done_mat_mul_3_13;
  wire done_mat_mul_3_14;
  wire done_mat_mul_3_15;
  wire done_mat_mul_4_0;
  wire done_mat_mul_4_1;
  wire done_mat_mul_4_2;
  wire done_mat_mul_4_3;
  wire done_mat_mul_4_4;
  wire done_mat_mul_4_5;
  wire done_mat_mul_4_6;
  wire done_mat_mul_4_7;
  wire done_mat_mul_4_8;
  wire done_mat_mul_4_9;
  wire done_mat_mul_4_10;
  wire done_mat_mul_4_11;
  wire done_mat_mul_4_12;
  wire done_mat_mul_4_13;
  wire done_mat_mul_4_14;
  wire done_mat_mul_4_15;
  wire done_mat_mul_5_0;
  wire done_mat_mul_5_1;
  wire done_mat_mul_5_2;
  wire done_mat_mul_5_3;
  wire done_mat_mul_5_4;
  wire done_mat_mul_5_5;
  wire done_mat_mul_5_6;
  wire done_mat_mul_5_7;
  wire done_mat_mul_5_8;
  wire done_mat_mul_5_9;
  wire done_mat_mul_5_10;
  wire done_mat_mul_5_11;
  wire done_mat_mul_5_12;
  wire done_mat_mul_5_13;
  wire done_mat_mul_5_14;
  wire done_mat_mul_5_15;
  wire done_mat_mul_6_0;
  wire done_mat_mul_6_1;
  wire done_mat_mul_6_2;
  wire done_mat_mul_6_3;
  wire done_mat_mul_6_4;
  wire done_mat_mul_6_5;
  wire done_mat_mul_6_6;
  wire done_mat_mul_6_7;
  wire done_mat_mul_6_8;
  wire done_mat_mul_6_9;
  wire done_mat_mul_6_10;
  wire done_mat_mul_6_11;
  wire done_mat_mul_6_12;
  wire done_mat_mul_6_13;
  wire done_mat_mul_6_14;
  wire done_mat_mul_6_15;
  wire done_mat_mul_7_0;
  wire done_mat_mul_7_1;
  wire done_mat_mul_7_2;
  wire done_mat_mul_7_3;
  wire done_mat_mul_7_4;
  wire done_mat_mul_7_5;
  wire done_mat_mul_7_6;
  wire done_mat_mul_7_7;
  wire done_mat_mul_7_8;
  wire done_mat_mul_7_9;
  wire done_mat_mul_7_10;
  wire done_mat_mul_7_11;
  wire done_mat_mul_7_12;
  wire done_mat_mul_7_13;
  wire done_mat_mul_7_14;
  wire done_mat_mul_7_15;
  wire done_mat_mul_8_0;
  wire done_mat_mul_8_1;
  wire done_mat_mul_8_2;
  wire done_mat_mul_8_3;
  wire done_mat_mul_8_4;
  wire done_mat_mul_8_5;
  wire done_mat_mul_8_6;
  wire done_mat_mul_8_7;
  wire done_mat_mul_8_8;
  wire done_mat_mul_8_9;
  wire done_mat_mul_8_10;
  wire done_mat_mul_8_11;
  wire done_mat_mul_8_12;
  wire done_mat_mul_8_13;
  wire done_mat_mul_8_14;
  wire done_mat_mul_8_15;
  wire done_mat_mul_9_0;
  wire done_mat_mul_9_1;
  wire done_mat_mul_9_2;
  wire done_mat_mul_9_3;
  wire done_mat_mul_9_4;
  wire done_mat_mul_9_5;
  wire done_mat_mul_9_6;
  wire done_mat_mul_9_7;
  wire done_mat_mul_9_8;
  wire done_mat_mul_9_9;
  wire done_mat_mul_9_10;
  wire done_mat_mul_9_11;
  wire done_mat_mul_9_12;
  wire done_mat_mul_9_13;
  wire done_mat_mul_9_14;
  wire done_mat_mul_9_15;
  wire done_mat_mul_10_0;
  wire done_mat_mul_10_1;
  wire done_mat_mul_10_2;
  wire done_mat_mul_10_3;
  wire done_mat_mul_10_4;
  wire done_mat_mul_10_5;
  wire done_mat_mul_10_6;
  wire done_mat_mul_10_7;
  wire done_mat_mul_10_8;
  wire done_mat_mul_10_9;
  wire done_mat_mul_10_10;
  wire done_mat_mul_10_11;
  wire done_mat_mul_10_12;
  wire done_mat_mul_10_13;
  wire done_mat_mul_10_14;
  wire done_mat_mul_10_15;
  wire done_mat_mul_11_0;
  wire done_mat_mul_11_1;
  wire done_mat_mul_11_2;
  wire done_mat_mul_11_3;
  wire done_mat_mul_11_4;
  wire done_mat_mul_11_5;
  wire done_mat_mul_11_6;
  wire done_mat_mul_11_7;
  wire done_mat_mul_11_8;
  wire done_mat_mul_11_9;
  wire done_mat_mul_11_10;
  wire done_mat_mul_11_11;
  wire done_mat_mul_11_12;
  wire done_mat_mul_11_13;
  wire done_mat_mul_11_14;
  wire done_mat_mul_11_15;
  wire done_mat_mul_12_0;
  wire done_mat_mul_12_1;
  wire done_mat_mul_12_2;
  wire done_mat_mul_12_3;
  wire done_mat_mul_12_4;
  wire done_mat_mul_12_5;
  wire done_mat_mul_12_6;
  wire done_mat_mul_12_7;
  wire done_mat_mul_12_8;
  wire done_mat_mul_12_9;
  wire done_mat_mul_12_10;
  wire done_mat_mul_12_11;
  wire done_mat_mul_12_12;
  wire done_mat_mul_12_13;
  wire done_mat_mul_12_14;
  wire done_mat_mul_12_15;
  wire done_mat_mul_13_0;
  wire done_mat_mul_13_1;
  wire done_mat_mul_13_2;
  wire done_mat_mul_13_3;
  wire done_mat_mul_13_4;
  wire done_mat_mul_13_5;
  wire done_mat_mul_13_6;
  wire done_mat_mul_13_7;
  wire done_mat_mul_13_8;
  wire done_mat_mul_13_9;
  wire done_mat_mul_13_10;
  wire done_mat_mul_13_11;
  wire done_mat_mul_13_12;
  wire done_mat_mul_13_13;
  wire done_mat_mul_13_14;
  wire done_mat_mul_13_15;
  wire done_mat_mul_14_0;
  wire done_mat_mul_14_1;
  wire done_mat_mul_14_2;
  wire done_mat_mul_14_3;
  wire done_mat_mul_14_4;
  wire done_mat_mul_14_5;
  wire done_mat_mul_14_6;
  wire done_mat_mul_14_7;
  wire done_mat_mul_14_8;
  wire done_mat_mul_14_9;
  wire done_mat_mul_14_10;
  wire done_mat_mul_14_11;
  wire done_mat_mul_14_12;
  wire done_mat_mul_14_13;
  wire done_mat_mul_14_14;
  wire done_mat_mul_14_15;
  wire done_mat_mul_15_0;
  wire done_mat_mul_15_1;
  wire done_mat_mul_15_2;
  wire done_mat_mul_15_3;
  wire done_mat_mul_15_4;
  wire done_mat_mul_15_5;
  wire done_mat_mul_15_6;
  wire done_mat_mul_15_7;
  wire done_mat_mul_15_8;
  wire done_mat_mul_15_9;
  wire done_mat_mul_15_10;
  wire done_mat_mul_15_11;
  wire done_mat_mul_15_12;
  wire done_mat_mul_15_13;
  wire done_mat_mul_15_14;
  wire done_mat_mul_15_15;

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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_5_to_0_6;

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
  .c_data_out(c_data_0_5_to_0_6),
  .a_data_out(a_data_0_5_to_0_6),
  .b_data_out(b_data_0_5_to_1_5),
  .a_addr(a_addr_0_5_NC),
  .b_addr(b_addr_0_5),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 0_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_6_to_0_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_6_to_1_6;
  wire [`AWIDTH-1:0] a_addr_0_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_6_to_0_7;

matmul_4x4_systolic u_matmul_4x4_systolic_0_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_6),
  .a_data(a_data_0_6_NC),
  .b_data(b_data_0_6),
  .a_data_in(a_data_0_5_to_0_6),
  .b_data_in(b_data_in_0_6_NC),
  .c_data_in(c_data_0_5_to_0_6),
  .c_data_out(c_data_0_6_to_0_7),
  .a_data_out(a_data_0_6_to_0_7),
  .b_data_out(b_data_0_6_to_1_6),
  .a_addr(a_addr_0_6_NC),
  .b_addr(b_addr_0_6),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 0_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_7_to_0_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_7_to_1_7;
  wire [`AWIDTH-1:0] a_addr_0_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_7_to_0_8;

matmul_4x4_systolic u_matmul_4x4_systolic_0_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_7),
  .a_data(a_data_0_7_NC),
  .b_data(b_data_0_7),
  .a_data_in(a_data_0_6_to_0_7),
  .b_data_in(b_data_in_0_7_NC),
  .c_data_in(c_data_0_6_to_0_7),
  .c_data_out(c_data_0_7_to_0_8),
  .a_data_out(a_data_0_7_to_0_8),
  .b_data_out(b_data_0_7_to_1_7),
  .a_addr(a_addr_0_7_NC),
  .b_addr(b_addr_0_7),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 0_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_8_to_0_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_8_to_1_8;
  wire [`AWIDTH-1:0] a_addr_0_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_8_to_0_9;

matmul_4x4_systolic u_matmul_4x4_systolic_0_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_8),
  .a_data(a_data_0_8_NC),
  .b_data(b_data_0_8),
  .a_data_in(a_data_0_7_to_0_8),
  .b_data_in(b_data_in_0_8_NC),
  .c_data_in(c_data_0_7_to_0_8),
  .c_data_out(c_data_0_8_to_0_9),
  .a_data_out(a_data_0_8_to_0_9),
  .b_data_out(b_data_0_8_to_1_8),
  .a_addr(a_addr_0_8_NC),
  .b_addr(b_addr_0_8),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 0_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_9_to_0_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_9_to_1_9;
  wire [`AWIDTH-1:0] a_addr_0_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_9_to_0_10;

matmul_4x4_systolic u_matmul_4x4_systolic_0_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_9),
  .a_data(a_data_0_9_NC),
  .b_data(b_data_0_9),
  .a_data_in(a_data_0_8_to_0_9),
  .b_data_in(b_data_in_0_9_NC),
  .c_data_in(c_data_0_8_to_0_9),
  .c_data_out(c_data_0_9_to_0_10),
  .a_data_out(a_data_0_9_to_0_10),
  .b_data_out(b_data_0_9_to_1_9),
  .a_addr(a_addr_0_9_NC),
  .b_addr(b_addr_0_9),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 0_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_10_to_0_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_10_to_1_10;
  wire [`AWIDTH-1:0] a_addr_0_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_10_to_0_11;

matmul_4x4_systolic u_matmul_4x4_systolic_0_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_10),
  .a_data(a_data_0_10_NC),
  .b_data(b_data_0_10),
  .a_data_in(a_data_0_9_to_0_10),
  .b_data_in(b_data_in_0_10_NC),
  .c_data_in(c_data_0_9_to_0_10),
  .c_data_out(c_data_0_10_to_0_11),
  .a_data_out(a_data_0_10_to_0_11),
  .b_data_out(b_data_0_10_to_1_10),
  .a_addr(a_addr_0_10_NC),
  .b_addr(b_addr_0_10),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 0_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_11_to_0_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_11_to_1_11;
  wire [`AWIDTH-1:0] a_addr_0_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_11_to_0_12;

matmul_4x4_systolic u_matmul_4x4_systolic_0_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_11),
  .a_data(a_data_0_11_NC),
  .b_data(b_data_0_11),
  .a_data_in(a_data_0_10_to_0_11),
  .b_data_in(b_data_in_0_11_NC),
  .c_data_in(c_data_0_10_to_0_11),
  .c_data_out(c_data_0_11_to_0_12),
  .a_data_out(a_data_0_11_to_0_12),
  .b_data_out(b_data_0_11_to_1_11),
  .a_addr(a_addr_0_11_NC),
  .b_addr(b_addr_0_11),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 0_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_12_to_0_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_12_to_1_12;
  wire [`AWIDTH-1:0] a_addr_0_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_12_to_0_13;

matmul_4x4_systolic u_matmul_4x4_systolic_0_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_12),
  .a_data(a_data_0_12_NC),
  .b_data(b_data_0_12),
  .a_data_in(a_data_0_11_to_0_12),
  .b_data_in(b_data_in_0_12_NC),
  .c_data_in(c_data_0_11_to_0_12),
  .c_data_out(c_data_0_12_to_0_13),
  .a_data_out(a_data_0_12_to_0_13),
  .b_data_out(b_data_0_12_to_1_12),
  .a_addr(a_addr_0_12_NC),
  .b_addr(b_addr_0_12),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 0_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_13_to_0_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_13_to_1_13;
  wire [`AWIDTH-1:0] a_addr_0_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_13_to_0_14;

matmul_4x4_systolic u_matmul_4x4_systolic_0_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_13),
  .a_data(a_data_0_13_NC),
  .b_data(b_data_0_13),
  .a_data_in(a_data_0_12_to_0_13),
  .b_data_in(b_data_in_0_13_NC),
  .c_data_in(c_data_0_12_to_0_13),
  .c_data_out(c_data_0_13_to_0_14),
  .a_data_out(a_data_0_13_to_0_14),
  .b_data_out(b_data_0_13_to_1_13),
  .a_addr(a_addr_0_13_NC),
  .b_addr(b_addr_0_13),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 0_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_14_to_0_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_14_to_1_14;
  wire [`AWIDTH-1:0] a_addr_0_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_14_to_0_15;

matmul_4x4_systolic u_matmul_4x4_systolic_0_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_14),
  .a_data(a_data_0_14_NC),
  .b_data(b_data_0_14),
  .a_data_in(a_data_0_13_to_0_14),
  .b_data_in(b_data_in_0_14_NC),
  .c_data_in(c_data_0_13_to_0_14),
  .c_data_out(c_data_0_14_to_0_15),
  .a_data_out(a_data_0_14_to_0_15),
  .b_data_out(b_data_0_14_to_1_14),
  .a_addr(a_addr_0_14_NC),
  .b_addr(b_addr_0_14),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 0_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_15_to_0_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_15_to_1_15;
  wire [`AWIDTH-1:0] a_addr_0_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_0_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_15),
  .a_data(a_data_0_15_NC),
  .b_data(b_data_0_15),
  .a_data_in(a_data_0_14_to_0_15),
  .b_data_in(b_data_in_0_15_NC),
  .c_data_in(c_data_0_14_to_0_15),
  .c_data_out(c_data_row_0),
  .a_data_out(a_data_0_15_to_0_16),
  .b_data_out(b_data_0_15_to_1_15),
  .a_addr(a_addr_0_15_NC),
  .b_addr(b_addr_0_15),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd15)
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_5_to_1_6;

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
  .c_data_out(c_data_1_5_to_1_6),
  .a_data_out(a_data_1_5_to_1_6),
  .b_data_out(b_data_1_5_to_2_5),
  .a_addr(a_addr_1_5_NC),
  .b_addr(b_addr_1_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 1_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_6_to_1_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_6_to_2_6;
  wire [`AWIDTH-1:0] a_addr_1_6_NC;
  wire [`AWIDTH-1:0] b_addr_1_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_6_to_1_7;

matmul_4x4_systolic u_matmul_4x4_systolic_1_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_6),
  .a_data(a_data_1_6_NC),
  .b_data(b_data_1_6_NC),
  .a_data_in(a_data_1_5_to_1_6),
  .b_data_in(b_data_0_6_to_1_6),
  .c_data_in(c_data_1_5_to_1_6),
  .c_data_out(c_data_1_6_to_1_7),
  .a_data_out(a_data_1_6_to_1_7),
  .b_data_out(b_data_1_6_to_2_6),
  .a_addr(a_addr_1_6_NC),
  .b_addr(b_addr_1_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 1_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_7_to_1_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_7_to_2_7;
  wire [`AWIDTH-1:0] a_addr_1_7_NC;
  wire [`AWIDTH-1:0] b_addr_1_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_7_to_1_8;

matmul_4x4_systolic u_matmul_4x4_systolic_1_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_7),
  .a_data(a_data_1_7_NC),
  .b_data(b_data_1_7_NC),
  .a_data_in(a_data_1_6_to_1_7),
  .b_data_in(b_data_0_7_to_1_7),
  .c_data_in(c_data_1_6_to_1_7),
  .c_data_out(c_data_1_7_to_1_8),
  .a_data_out(a_data_1_7_to_1_8),
  .b_data_out(b_data_1_7_to_2_7),
  .a_addr(a_addr_1_7_NC),
  .b_addr(b_addr_1_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 1_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_8_to_1_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_8_to_2_8;
  wire [`AWIDTH-1:0] a_addr_1_8_NC;
  wire [`AWIDTH-1:0] b_addr_1_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_8_to_1_9;

matmul_4x4_systolic u_matmul_4x4_systolic_1_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_8),
  .a_data(a_data_1_8_NC),
  .b_data(b_data_1_8_NC),
  .a_data_in(a_data_1_7_to_1_8),
  .b_data_in(b_data_0_8_to_1_8),
  .c_data_in(c_data_1_7_to_1_8),
  .c_data_out(c_data_1_8_to_1_9),
  .a_data_out(a_data_1_8_to_1_9),
  .b_data_out(b_data_1_8_to_2_8),
  .a_addr(a_addr_1_8_NC),
  .b_addr(b_addr_1_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 1_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_9_to_1_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_9_to_2_9;
  wire [`AWIDTH-1:0] a_addr_1_9_NC;
  wire [`AWIDTH-1:0] b_addr_1_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_9_to_1_10;

matmul_4x4_systolic u_matmul_4x4_systolic_1_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_9),
  .a_data(a_data_1_9_NC),
  .b_data(b_data_1_9_NC),
  .a_data_in(a_data_1_8_to_1_9),
  .b_data_in(b_data_0_9_to_1_9),
  .c_data_in(c_data_1_8_to_1_9),
  .c_data_out(c_data_1_9_to_1_10),
  .a_data_out(a_data_1_9_to_1_10),
  .b_data_out(b_data_1_9_to_2_9),
  .a_addr(a_addr_1_9_NC),
  .b_addr(b_addr_1_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 1_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_10_to_1_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_10_to_2_10;
  wire [`AWIDTH-1:0] a_addr_1_10_NC;
  wire [`AWIDTH-1:0] b_addr_1_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_10_to_1_11;

matmul_4x4_systolic u_matmul_4x4_systolic_1_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_10),
  .a_data(a_data_1_10_NC),
  .b_data(b_data_1_10_NC),
  .a_data_in(a_data_1_9_to_1_10),
  .b_data_in(b_data_0_10_to_1_10),
  .c_data_in(c_data_1_9_to_1_10),
  .c_data_out(c_data_1_10_to_1_11),
  .a_data_out(a_data_1_10_to_1_11),
  .b_data_out(b_data_1_10_to_2_10),
  .a_addr(a_addr_1_10_NC),
  .b_addr(b_addr_1_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 1_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_11_to_1_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_11_to_2_11;
  wire [`AWIDTH-1:0] a_addr_1_11_NC;
  wire [`AWIDTH-1:0] b_addr_1_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_11_to_1_12;

matmul_4x4_systolic u_matmul_4x4_systolic_1_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_11),
  .a_data(a_data_1_11_NC),
  .b_data(b_data_1_11_NC),
  .a_data_in(a_data_1_10_to_1_11),
  .b_data_in(b_data_0_11_to_1_11),
  .c_data_in(c_data_1_10_to_1_11),
  .c_data_out(c_data_1_11_to_1_12),
  .a_data_out(a_data_1_11_to_1_12),
  .b_data_out(b_data_1_11_to_2_11),
  .a_addr(a_addr_1_11_NC),
  .b_addr(b_addr_1_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 1_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_12_to_1_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_12_to_2_12;
  wire [`AWIDTH-1:0] a_addr_1_12_NC;
  wire [`AWIDTH-1:0] b_addr_1_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_12_to_1_13;

matmul_4x4_systolic u_matmul_4x4_systolic_1_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_12),
  .a_data(a_data_1_12_NC),
  .b_data(b_data_1_12_NC),
  .a_data_in(a_data_1_11_to_1_12),
  .b_data_in(b_data_0_12_to_1_12),
  .c_data_in(c_data_1_11_to_1_12),
  .c_data_out(c_data_1_12_to_1_13),
  .a_data_out(a_data_1_12_to_1_13),
  .b_data_out(b_data_1_12_to_2_12),
  .a_addr(a_addr_1_12_NC),
  .b_addr(b_addr_1_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 1_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_13_to_1_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_13_to_2_13;
  wire [`AWIDTH-1:0] a_addr_1_13_NC;
  wire [`AWIDTH-1:0] b_addr_1_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_13_to_1_14;

matmul_4x4_systolic u_matmul_4x4_systolic_1_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_13),
  .a_data(a_data_1_13_NC),
  .b_data(b_data_1_13_NC),
  .a_data_in(a_data_1_12_to_1_13),
  .b_data_in(b_data_0_13_to_1_13),
  .c_data_in(c_data_1_12_to_1_13),
  .c_data_out(c_data_1_13_to_1_14),
  .a_data_out(a_data_1_13_to_1_14),
  .b_data_out(b_data_1_13_to_2_13),
  .a_addr(a_addr_1_13_NC),
  .b_addr(b_addr_1_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 1_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_14_to_1_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_14_to_2_14;
  wire [`AWIDTH-1:0] a_addr_1_14_NC;
  wire [`AWIDTH-1:0] b_addr_1_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_14_to_1_15;

matmul_4x4_systolic u_matmul_4x4_systolic_1_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_14),
  .a_data(a_data_1_14_NC),
  .b_data(b_data_1_14_NC),
  .a_data_in(a_data_1_13_to_1_14),
  .b_data_in(b_data_0_14_to_1_14),
  .c_data_in(c_data_1_13_to_1_14),
  .c_data_out(c_data_1_14_to_1_15),
  .a_data_out(a_data_1_14_to_1_15),
  .b_data_out(b_data_1_14_to_2_14),
  .a_addr(a_addr_1_14_NC),
  .b_addr(b_addr_1_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 1_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_15_to_1_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_15_to_2_15;
  wire [`AWIDTH-1:0] a_addr_1_15_NC;
  wire [`AWIDTH-1:0] b_addr_1_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_1_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_15),
  .a_data(a_data_1_15_NC),
  .b_data(b_data_1_15_NC),
  .a_data_in(a_data_1_14_to_1_15),
  .b_data_in(b_data_0_15_to_1_15),
  .c_data_in(c_data_1_14_to_1_15),
  .c_data_out(c_data_row_1),
  .a_data_out(a_data_1_15_to_1_16),
  .b_data_out(b_data_1_15_to_2_15),
  .a_addr(a_addr_1_15_NC),
  .b_addr(b_addr_1_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd15)
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_5_to_2_6;

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
  .c_data_out(c_data_2_5_to_2_6),
  .a_data_out(a_data_2_5_to_2_6),
  .b_data_out(b_data_2_5_to_3_5),
  .a_addr(a_addr_2_5_NC),
  .b_addr(b_addr_2_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 2_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_6_to_2_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_6_to_3_6;
  wire [`AWIDTH-1:0] a_addr_2_6_NC;
  wire [`AWIDTH-1:0] b_addr_2_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_6_to_2_7;

matmul_4x4_systolic u_matmul_4x4_systolic_2_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_6),
  .a_data(a_data_2_6_NC),
  .b_data(b_data_2_6_NC),
  .a_data_in(a_data_2_5_to_2_6),
  .b_data_in(b_data_1_6_to_2_6),
  .c_data_in(c_data_2_5_to_2_6),
  .c_data_out(c_data_2_6_to_2_7),
  .a_data_out(a_data_2_6_to_2_7),
  .b_data_out(b_data_2_6_to_3_6),
  .a_addr(a_addr_2_6_NC),
  .b_addr(b_addr_2_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 2_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_7_to_2_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_7_to_3_7;
  wire [`AWIDTH-1:0] a_addr_2_7_NC;
  wire [`AWIDTH-1:0] b_addr_2_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_7_to_2_8;

matmul_4x4_systolic u_matmul_4x4_systolic_2_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_7),
  .a_data(a_data_2_7_NC),
  .b_data(b_data_2_7_NC),
  .a_data_in(a_data_2_6_to_2_7),
  .b_data_in(b_data_1_7_to_2_7),
  .c_data_in(c_data_2_6_to_2_7),
  .c_data_out(c_data_2_7_to_2_8),
  .a_data_out(a_data_2_7_to_2_8),
  .b_data_out(b_data_2_7_to_3_7),
  .a_addr(a_addr_2_7_NC),
  .b_addr(b_addr_2_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 2_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_8_to_2_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_8_to_3_8;
  wire [`AWIDTH-1:0] a_addr_2_8_NC;
  wire [`AWIDTH-1:0] b_addr_2_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_8_to_2_9;

matmul_4x4_systolic u_matmul_4x4_systolic_2_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_8),
  .a_data(a_data_2_8_NC),
  .b_data(b_data_2_8_NC),
  .a_data_in(a_data_2_7_to_2_8),
  .b_data_in(b_data_1_8_to_2_8),
  .c_data_in(c_data_2_7_to_2_8),
  .c_data_out(c_data_2_8_to_2_9),
  .a_data_out(a_data_2_8_to_2_9),
  .b_data_out(b_data_2_8_to_3_8),
  .a_addr(a_addr_2_8_NC),
  .b_addr(b_addr_2_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 2_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_9_to_2_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_9_to_3_9;
  wire [`AWIDTH-1:0] a_addr_2_9_NC;
  wire [`AWIDTH-1:0] b_addr_2_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_9_to_2_10;

matmul_4x4_systolic u_matmul_4x4_systolic_2_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_9),
  .a_data(a_data_2_9_NC),
  .b_data(b_data_2_9_NC),
  .a_data_in(a_data_2_8_to_2_9),
  .b_data_in(b_data_1_9_to_2_9),
  .c_data_in(c_data_2_8_to_2_9),
  .c_data_out(c_data_2_9_to_2_10),
  .a_data_out(a_data_2_9_to_2_10),
  .b_data_out(b_data_2_9_to_3_9),
  .a_addr(a_addr_2_9_NC),
  .b_addr(b_addr_2_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 2_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_10_to_2_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_10_to_3_10;
  wire [`AWIDTH-1:0] a_addr_2_10_NC;
  wire [`AWIDTH-1:0] b_addr_2_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_10_to_2_11;

matmul_4x4_systolic u_matmul_4x4_systolic_2_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_10),
  .a_data(a_data_2_10_NC),
  .b_data(b_data_2_10_NC),
  .a_data_in(a_data_2_9_to_2_10),
  .b_data_in(b_data_1_10_to_2_10),
  .c_data_in(c_data_2_9_to_2_10),
  .c_data_out(c_data_2_10_to_2_11),
  .a_data_out(a_data_2_10_to_2_11),
  .b_data_out(b_data_2_10_to_3_10),
  .a_addr(a_addr_2_10_NC),
  .b_addr(b_addr_2_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 2_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_11_to_2_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_11_to_3_11;
  wire [`AWIDTH-1:0] a_addr_2_11_NC;
  wire [`AWIDTH-1:0] b_addr_2_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_11_to_2_12;

matmul_4x4_systolic u_matmul_4x4_systolic_2_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_11),
  .a_data(a_data_2_11_NC),
  .b_data(b_data_2_11_NC),
  .a_data_in(a_data_2_10_to_2_11),
  .b_data_in(b_data_1_11_to_2_11),
  .c_data_in(c_data_2_10_to_2_11),
  .c_data_out(c_data_2_11_to_2_12),
  .a_data_out(a_data_2_11_to_2_12),
  .b_data_out(b_data_2_11_to_3_11),
  .a_addr(a_addr_2_11_NC),
  .b_addr(b_addr_2_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 2_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_12_to_2_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_12_to_3_12;
  wire [`AWIDTH-1:0] a_addr_2_12_NC;
  wire [`AWIDTH-1:0] b_addr_2_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_12_to_2_13;

matmul_4x4_systolic u_matmul_4x4_systolic_2_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_12),
  .a_data(a_data_2_12_NC),
  .b_data(b_data_2_12_NC),
  .a_data_in(a_data_2_11_to_2_12),
  .b_data_in(b_data_1_12_to_2_12),
  .c_data_in(c_data_2_11_to_2_12),
  .c_data_out(c_data_2_12_to_2_13),
  .a_data_out(a_data_2_12_to_2_13),
  .b_data_out(b_data_2_12_to_3_12),
  .a_addr(a_addr_2_12_NC),
  .b_addr(b_addr_2_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 2_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_13_to_2_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_13_to_3_13;
  wire [`AWIDTH-1:0] a_addr_2_13_NC;
  wire [`AWIDTH-1:0] b_addr_2_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_13_to_2_14;

matmul_4x4_systolic u_matmul_4x4_systolic_2_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_13),
  .a_data(a_data_2_13_NC),
  .b_data(b_data_2_13_NC),
  .a_data_in(a_data_2_12_to_2_13),
  .b_data_in(b_data_1_13_to_2_13),
  .c_data_in(c_data_2_12_to_2_13),
  .c_data_out(c_data_2_13_to_2_14),
  .a_data_out(a_data_2_13_to_2_14),
  .b_data_out(b_data_2_13_to_3_13),
  .a_addr(a_addr_2_13_NC),
  .b_addr(b_addr_2_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 2_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_14_to_2_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_14_to_3_14;
  wire [`AWIDTH-1:0] a_addr_2_14_NC;
  wire [`AWIDTH-1:0] b_addr_2_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_14_to_2_15;

matmul_4x4_systolic u_matmul_4x4_systolic_2_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_14),
  .a_data(a_data_2_14_NC),
  .b_data(b_data_2_14_NC),
  .a_data_in(a_data_2_13_to_2_14),
  .b_data_in(b_data_1_14_to_2_14),
  .c_data_in(c_data_2_13_to_2_14),
  .c_data_out(c_data_2_14_to_2_15),
  .a_data_out(a_data_2_14_to_2_15),
  .b_data_out(b_data_2_14_to_3_14),
  .a_addr(a_addr_2_14_NC),
  .b_addr(b_addr_2_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 2_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_15_to_2_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_15_to_3_15;
  wire [`AWIDTH-1:0] a_addr_2_15_NC;
  wire [`AWIDTH-1:0] b_addr_2_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_2_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_15),
  .a_data(a_data_2_15_NC),
  .b_data(b_data_2_15_NC),
  .a_data_in(a_data_2_14_to_2_15),
  .b_data_in(b_data_1_15_to_2_15),
  .c_data_in(c_data_2_14_to_2_15),
  .c_data_out(c_data_row_2),
  .a_data_out(a_data_2_15_to_2_16),
  .b_data_out(b_data_2_15_to_3_15),
  .a_addr(a_addr_2_15_NC),
  .b_addr(b_addr_2_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd15)
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_5_to_3_6;

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
  .c_data_out(c_data_3_5_to_3_6),
  .a_data_out(a_data_3_5_to_3_6),
  .b_data_out(b_data_3_5_to_4_5),
  .a_addr(a_addr_3_5_NC),
  .b_addr(b_addr_3_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 3_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_6_to_3_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_6_to_4_6;
  wire [`AWIDTH-1:0] a_addr_3_6_NC;
  wire [`AWIDTH-1:0] b_addr_3_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_6_to_3_7;

matmul_4x4_systolic u_matmul_4x4_systolic_3_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_6),
  .a_data(a_data_3_6_NC),
  .b_data(b_data_3_6_NC),
  .a_data_in(a_data_3_5_to_3_6),
  .b_data_in(b_data_2_6_to_3_6),
  .c_data_in(c_data_3_5_to_3_6),
  .c_data_out(c_data_3_6_to_3_7),
  .a_data_out(a_data_3_6_to_3_7),
  .b_data_out(b_data_3_6_to_4_6),
  .a_addr(a_addr_3_6_NC),
  .b_addr(b_addr_3_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 3_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_7_to_3_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_7_to_4_7;
  wire [`AWIDTH-1:0] a_addr_3_7_NC;
  wire [`AWIDTH-1:0] b_addr_3_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_7_to_3_8;

matmul_4x4_systolic u_matmul_4x4_systolic_3_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_7),
  .a_data(a_data_3_7_NC),
  .b_data(b_data_3_7_NC),
  .a_data_in(a_data_3_6_to_3_7),
  .b_data_in(b_data_2_7_to_3_7),
  .c_data_in(c_data_3_6_to_3_7),
  .c_data_out(c_data_3_7_to_3_8),
  .a_data_out(a_data_3_7_to_3_8),
  .b_data_out(b_data_3_7_to_4_7),
  .a_addr(a_addr_3_7_NC),
  .b_addr(b_addr_3_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 3_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_8_to_3_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_8_to_4_8;
  wire [`AWIDTH-1:0] a_addr_3_8_NC;
  wire [`AWIDTH-1:0] b_addr_3_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_8_to_3_9;

matmul_4x4_systolic u_matmul_4x4_systolic_3_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_8),
  .a_data(a_data_3_8_NC),
  .b_data(b_data_3_8_NC),
  .a_data_in(a_data_3_7_to_3_8),
  .b_data_in(b_data_2_8_to_3_8),
  .c_data_in(c_data_3_7_to_3_8),
  .c_data_out(c_data_3_8_to_3_9),
  .a_data_out(a_data_3_8_to_3_9),
  .b_data_out(b_data_3_8_to_4_8),
  .a_addr(a_addr_3_8_NC),
  .b_addr(b_addr_3_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 3_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_9_to_3_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_9_to_4_9;
  wire [`AWIDTH-1:0] a_addr_3_9_NC;
  wire [`AWIDTH-1:0] b_addr_3_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_9_to_3_10;

matmul_4x4_systolic u_matmul_4x4_systolic_3_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_9),
  .a_data(a_data_3_9_NC),
  .b_data(b_data_3_9_NC),
  .a_data_in(a_data_3_8_to_3_9),
  .b_data_in(b_data_2_9_to_3_9),
  .c_data_in(c_data_3_8_to_3_9),
  .c_data_out(c_data_3_9_to_3_10),
  .a_data_out(a_data_3_9_to_3_10),
  .b_data_out(b_data_3_9_to_4_9),
  .a_addr(a_addr_3_9_NC),
  .b_addr(b_addr_3_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 3_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_10_to_3_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_10_to_4_10;
  wire [`AWIDTH-1:0] a_addr_3_10_NC;
  wire [`AWIDTH-1:0] b_addr_3_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_10_to_3_11;

matmul_4x4_systolic u_matmul_4x4_systolic_3_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_10),
  .a_data(a_data_3_10_NC),
  .b_data(b_data_3_10_NC),
  .a_data_in(a_data_3_9_to_3_10),
  .b_data_in(b_data_2_10_to_3_10),
  .c_data_in(c_data_3_9_to_3_10),
  .c_data_out(c_data_3_10_to_3_11),
  .a_data_out(a_data_3_10_to_3_11),
  .b_data_out(b_data_3_10_to_4_10),
  .a_addr(a_addr_3_10_NC),
  .b_addr(b_addr_3_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 3_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_11_to_3_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_11_to_4_11;
  wire [`AWIDTH-1:0] a_addr_3_11_NC;
  wire [`AWIDTH-1:0] b_addr_3_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_11_to_3_12;

matmul_4x4_systolic u_matmul_4x4_systolic_3_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_11),
  .a_data(a_data_3_11_NC),
  .b_data(b_data_3_11_NC),
  .a_data_in(a_data_3_10_to_3_11),
  .b_data_in(b_data_2_11_to_3_11),
  .c_data_in(c_data_3_10_to_3_11),
  .c_data_out(c_data_3_11_to_3_12),
  .a_data_out(a_data_3_11_to_3_12),
  .b_data_out(b_data_3_11_to_4_11),
  .a_addr(a_addr_3_11_NC),
  .b_addr(b_addr_3_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 3_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_12_to_3_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_12_to_4_12;
  wire [`AWIDTH-1:0] a_addr_3_12_NC;
  wire [`AWIDTH-1:0] b_addr_3_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_12_to_3_13;

matmul_4x4_systolic u_matmul_4x4_systolic_3_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_12),
  .a_data(a_data_3_12_NC),
  .b_data(b_data_3_12_NC),
  .a_data_in(a_data_3_11_to_3_12),
  .b_data_in(b_data_2_12_to_3_12),
  .c_data_in(c_data_3_11_to_3_12),
  .c_data_out(c_data_3_12_to_3_13),
  .a_data_out(a_data_3_12_to_3_13),
  .b_data_out(b_data_3_12_to_4_12),
  .a_addr(a_addr_3_12_NC),
  .b_addr(b_addr_3_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 3_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_13_to_3_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_13_to_4_13;
  wire [`AWIDTH-1:0] a_addr_3_13_NC;
  wire [`AWIDTH-1:0] b_addr_3_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_13_to_3_14;

matmul_4x4_systolic u_matmul_4x4_systolic_3_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_13),
  .a_data(a_data_3_13_NC),
  .b_data(b_data_3_13_NC),
  .a_data_in(a_data_3_12_to_3_13),
  .b_data_in(b_data_2_13_to_3_13),
  .c_data_in(c_data_3_12_to_3_13),
  .c_data_out(c_data_3_13_to_3_14),
  .a_data_out(a_data_3_13_to_3_14),
  .b_data_out(b_data_3_13_to_4_13),
  .a_addr(a_addr_3_13_NC),
  .b_addr(b_addr_3_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 3_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_14_to_3_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_14_to_4_14;
  wire [`AWIDTH-1:0] a_addr_3_14_NC;
  wire [`AWIDTH-1:0] b_addr_3_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_14_to_3_15;

matmul_4x4_systolic u_matmul_4x4_systolic_3_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_14),
  .a_data(a_data_3_14_NC),
  .b_data(b_data_3_14_NC),
  .a_data_in(a_data_3_13_to_3_14),
  .b_data_in(b_data_2_14_to_3_14),
  .c_data_in(c_data_3_13_to_3_14),
  .c_data_out(c_data_3_14_to_3_15),
  .a_data_out(a_data_3_14_to_3_15),
  .b_data_out(b_data_3_14_to_4_14),
  .a_addr(a_addr_3_14_NC),
  .b_addr(b_addr_3_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 3_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_15_to_3_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_15_to_4_15;
  wire [`AWIDTH-1:0] a_addr_3_15_NC;
  wire [`AWIDTH-1:0] b_addr_3_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_3_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_15),
  .a_data(a_data_3_15_NC),
  .b_data(b_data_3_15_NC),
  .a_data_in(a_data_3_14_to_3_15),
  .b_data_in(b_data_2_15_to_3_15),
  .c_data_in(c_data_3_14_to_3_15),
  .c_data_out(c_data_row_3),
  .a_data_out(a_data_3_15_to_3_16),
  .b_data_out(b_data_3_15_to_4_15),
  .a_addr(a_addr_3_15_NC),
  .b_addr(b_addr_3_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd15)
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_5_to_4_6;

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
  .c_data_out(c_data_4_5_to_4_6),
  .a_data_out(a_data_4_5_to_4_6),
  .b_data_out(b_data_4_5_to_5_5),
  .a_addr(a_addr_4_5_NC),
  .b_addr(b_addr_4_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 4_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_6_to_4_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_6_to_5_6;
  wire [`AWIDTH-1:0] a_addr_4_6_NC;
  wire [`AWIDTH-1:0] b_addr_4_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_6_to_4_7;

matmul_4x4_systolic u_matmul_4x4_systolic_4_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_6),
  .a_data(a_data_4_6_NC),
  .b_data(b_data_4_6_NC),
  .a_data_in(a_data_4_5_to_4_6),
  .b_data_in(b_data_3_6_to_4_6),
  .c_data_in(c_data_4_5_to_4_6),
  .c_data_out(c_data_4_6_to_4_7),
  .a_data_out(a_data_4_6_to_4_7),
  .b_data_out(b_data_4_6_to_5_6),
  .a_addr(a_addr_4_6_NC),
  .b_addr(b_addr_4_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 4_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_7_to_4_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_7_to_5_7;
  wire [`AWIDTH-1:0] a_addr_4_7_NC;
  wire [`AWIDTH-1:0] b_addr_4_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_7_to_4_8;

matmul_4x4_systolic u_matmul_4x4_systolic_4_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_7),
  .a_data(a_data_4_7_NC),
  .b_data(b_data_4_7_NC),
  .a_data_in(a_data_4_6_to_4_7),
  .b_data_in(b_data_3_7_to_4_7),
  .c_data_in(c_data_4_6_to_4_7),
  .c_data_out(c_data_4_7_to_4_8),
  .a_data_out(a_data_4_7_to_4_8),
  .b_data_out(b_data_4_7_to_5_7),
  .a_addr(a_addr_4_7_NC),
  .b_addr(b_addr_4_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 4_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_8_to_4_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_8_to_5_8;
  wire [`AWIDTH-1:0] a_addr_4_8_NC;
  wire [`AWIDTH-1:0] b_addr_4_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_8_to_4_9;

matmul_4x4_systolic u_matmul_4x4_systolic_4_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_8),
  .a_data(a_data_4_8_NC),
  .b_data(b_data_4_8_NC),
  .a_data_in(a_data_4_7_to_4_8),
  .b_data_in(b_data_3_8_to_4_8),
  .c_data_in(c_data_4_7_to_4_8),
  .c_data_out(c_data_4_8_to_4_9),
  .a_data_out(a_data_4_8_to_4_9),
  .b_data_out(b_data_4_8_to_5_8),
  .a_addr(a_addr_4_8_NC),
  .b_addr(b_addr_4_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 4_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_9_to_4_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_9_to_5_9;
  wire [`AWIDTH-1:0] a_addr_4_9_NC;
  wire [`AWIDTH-1:0] b_addr_4_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_9_to_4_10;

matmul_4x4_systolic u_matmul_4x4_systolic_4_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_9),
  .a_data(a_data_4_9_NC),
  .b_data(b_data_4_9_NC),
  .a_data_in(a_data_4_8_to_4_9),
  .b_data_in(b_data_3_9_to_4_9),
  .c_data_in(c_data_4_8_to_4_9),
  .c_data_out(c_data_4_9_to_4_10),
  .a_data_out(a_data_4_9_to_4_10),
  .b_data_out(b_data_4_9_to_5_9),
  .a_addr(a_addr_4_9_NC),
  .b_addr(b_addr_4_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 4_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_10_to_4_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_10_to_5_10;
  wire [`AWIDTH-1:0] a_addr_4_10_NC;
  wire [`AWIDTH-1:0] b_addr_4_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_10_to_4_11;

matmul_4x4_systolic u_matmul_4x4_systolic_4_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_10),
  .a_data(a_data_4_10_NC),
  .b_data(b_data_4_10_NC),
  .a_data_in(a_data_4_9_to_4_10),
  .b_data_in(b_data_3_10_to_4_10),
  .c_data_in(c_data_4_9_to_4_10),
  .c_data_out(c_data_4_10_to_4_11),
  .a_data_out(a_data_4_10_to_4_11),
  .b_data_out(b_data_4_10_to_5_10),
  .a_addr(a_addr_4_10_NC),
  .b_addr(b_addr_4_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 4_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_11_to_4_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_11_to_5_11;
  wire [`AWIDTH-1:0] a_addr_4_11_NC;
  wire [`AWIDTH-1:0] b_addr_4_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_11_to_4_12;

matmul_4x4_systolic u_matmul_4x4_systolic_4_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_11),
  .a_data(a_data_4_11_NC),
  .b_data(b_data_4_11_NC),
  .a_data_in(a_data_4_10_to_4_11),
  .b_data_in(b_data_3_11_to_4_11),
  .c_data_in(c_data_4_10_to_4_11),
  .c_data_out(c_data_4_11_to_4_12),
  .a_data_out(a_data_4_11_to_4_12),
  .b_data_out(b_data_4_11_to_5_11),
  .a_addr(a_addr_4_11_NC),
  .b_addr(b_addr_4_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 4_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_12_to_4_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_12_to_5_12;
  wire [`AWIDTH-1:0] a_addr_4_12_NC;
  wire [`AWIDTH-1:0] b_addr_4_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_12_to_4_13;

matmul_4x4_systolic u_matmul_4x4_systolic_4_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_12),
  .a_data(a_data_4_12_NC),
  .b_data(b_data_4_12_NC),
  .a_data_in(a_data_4_11_to_4_12),
  .b_data_in(b_data_3_12_to_4_12),
  .c_data_in(c_data_4_11_to_4_12),
  .c_data_out(c_data_4_12_to_4_13),
  .a_data_out(a_data_4_12_to_4_13),
  .b_data_out(b_data_4_12_to_5_12),
  .a_addr(a_addr_4_12_NC),
  .b_addr(b_addr_4_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 4_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_13_to_4_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_13_to_5_13;
  wire [`AWIDTH-1:0] a_addr_4_13_NC;
  wire [`AWIDTH-1:0] b_addr_4_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_13_to_4_14;

matmul_4x4_systolic u_matmul_4x4_systolic_4_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_13),
  .a_data(a_data_4_13_NC),
  .b_data(b_data_4_13_NC),
  .a_data_in(a_data_4_12_to_4_13),
  .b_data_in(b_data_3_13_to_4_13),
  .c_data_in(c_data_4_12_to_4_13),
  .c_data_out(c_data_4_13_to_4_14),
  .a_data_out(a_data_4_13_to_4_14),
  .b_data_out(b_data_4_13_to_5_13),
  .a_addr(a_addr_4_13_NC),
  .b_addr(b_addr_4_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 4_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_14_to_4_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_14_to_5_14;
  wire [`AWIDTH-1:0] a_addr_4_14_NC;
  wire [`AWIDTH-1:0] b_addr_4_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_14_to_4_15;

matmul_4x4_systolic u_matmul_4x4_systolic_4_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_14),
  .a_data(a_data_4_14_NC),
  .b_data(b_data_4_14_NC),
  .a_data_in(a_data_4_13_to_4_14),
  .b_data_in(b_data_3_14_to_4_14),
  .c_data_in(c_data_4_13_to_4_14),
  .c_data_out(c_data_4_14_to_4_15),
  .a_data_out(a_data_4_14_to_4_15),
  .b_data_out(b_data_4_14_to_5_14),
  .a_addr(a_addr_4_14_NC),
  .b_addr(b_addr_4_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 4_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_15_to_4_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_15_to_5_15;
  wire [`AWIDTH-1:0] a_addr_4_15_NC;
  wire [`AWIDTH-1:0] b_addr_4_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_4_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_15),
  .a_data(a_data_4_15_NC),
  .b_data(b_data_4_15_NC),
  .a_data_in(a_data_4_14_to_4_15),
  .b_data_in(b_data_3_15_to_4_15),
  .c_data_in(c_data_4_14_to_4_15),
  .c_data_out(c_data_row_4),
  .a_data_out(a_data_4_15_to_4_16),
  .b_data_out(b_data_4_15_to_5_15),
  .a_addr(a_addr_4_15_NC),
  .b_addr(b_addr_4_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd15)
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  .final_mat_mul_size(8'd64),
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_5_to_5_6;

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
  .c_data_out(c_data_5_5_to_5_6),
  .a_data_out(a_data_5_5_to_5_6),
  .b_data_out(b_data_5_5_to_6_5),
  .a_addr(a_addr_5_5_NC),
  .b_addr(b_addr_5_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 5_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_6_to_5_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_6_to_6_6;
  wire [`AWIDTH-1:0] a_addr_5_6_NC;
  wire [`AWIDTH-1:0] b_addr_5_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_6_to_5_7;

matmul_4x4_systolic u_matmul_4x4_systolic_5_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_6),
  .a_data(a_data_5_6_NC),
  .b_data(b_data_5_6_NC),
  .a_data_in(a_data_5_5_to_5_6),
  .b_data_in(b_data_4_6_to_5_6),
  .c_data_in(c_data_5_5_to_5_6),
  .c_data_out(c_data_5_6_to_5_7),
  .a_data_out(a_data_5_6_to_5_7),
  .b_data_out(b_data_5_6_to_6_6),
  .a_addr(a_addr_5_6_NC),
  .b_addr(b_addr_5_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 5_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_7_to_5_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_7_to_6_7;
  wire [`AWIDTH-1:0] a_addr_5_7_NC;
  wire [`AWIDTH-1:0] b_addr_5_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_7_to_5_8;

matmul_4x4_systolic u_matmul_4x4_systolic_5_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_7),
  .a_data(a_data_5_7_NC),
  .b_data(b_data_5_7_NC),
  .a_data_in(a_data_5_6_to_5_7),
  .b_data_in(b_data_4_7_to_5_7),
  .c_data_in(c_data_5_6_to_5_7),
  .c_data_out(c_data_5_7_to_5_8),
  .a_data_out(a_data_5_7_to_5_8),
  .b_data_out(b_data_5_7_to_6_7),
  .a_addr(a_addr_5_7_NC),
  .b_addr(b_addr_5_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 5_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_8_to_5_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_8_to_6_8;
  wire [`AWIDTH-1:0] a_addr_5_8_NC;
  wire [`AWIDTH-1:0] b_addr_5_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_8_to_5_9;

matmul_4x4_systolic u_matmul_4x4_systolic_5_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_8),
  .a_data(a_data_5_8_NC),
  .b_data(b_data_5_8_NC),
  .a_data_in(a_data_5_7_to_5_8),
  .b_data_in(b_data_4_8_to_5_8),
  .c_data_in(c_data_5_7_to_5_8),
  .c_data_out(c_data_5_8_to_5_9),
  .a_data_out(a_data_5_8_to_5_9),
  .b_data_out(b_data_5_8_to_6_8),
  .a_addr(a_addr_5_8_NC),
  .b_addr(b_addr_5_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 5_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_9_to_5_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_9_to_6_9;
  wire [`AWIDTH-1:0] a_addr_5_9_NC;
  wire [`AWIDTH-1:0] b_addr_5_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_9_to_5_10;

matmul_4x4_systolic u_matmul_4x4_systolic_5_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_9),
  .a_data(a_data_5_9_NC),
  .b_data(b_data_5_9_NC),
  .a_data_in(a_data_5_8_to_5_9),
  .b_data_in(b_data_4_9_to_5_9),
  .c_data_in(c_data_5_8_to_5_9),
  .c_data_out(c_data_5_9_to_5_10),
  .a_data_out(a_data_5_9_to_5_10),
  .b_data_out(b_data_5_9_to_6_9),
  .a_addr(a_addr_5_9_NC),
  .b_addr(b_addr_5_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 5_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_10_to_5_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_10_to_6_10;
  wire [`AWIDTH-1:0] a_addr_5_10_NC;
  wire [`AWIDTH-1:0] b_addr_5_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_10_to_5_11;

matmul_4x4_systolic u_matmul_4x4_systolic_5_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_10),
  .a_data(a_data_5_10_NC),
  .b_data(b_data_5_10_NC),
  .a_data_in(a_data_5_9_to_5_10),
  .b_data_in(b_data_4_10_to_5_10),
  .c_data_in(c_data_5_9_to_5_10),
  .c_data_out(c_data_5_10_to_5_11),
  .a_data_out(a_data_5_10_to_5_11),
  .b_data_out(b_data_5_10_to_6_10),
  .a_addr(a_addr_5_10_NC),
  .b_addr(b_addr_5_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 5_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_11_to_5_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_11_to_6_11;
  wire [`AWIDTH-1:0] a_addr_5_11_NC;
  wire [`AWIDTH-1:0] b_addr_5_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_11_to_5_12;

matmul_4x4_systolic u_matmul_4x4_systolic_5_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_11),
  .a_data(a_data_5_11_NC),
  .b_data(b_data_5_11_NC),
  .a_data_in(a_data_5_10_to_5_11),
  .b_data_in(b_data_4_11_to_5_11),
  .c_data_in(c_data_5_10_to_5_11),
  .c_data_out(c_data_5_11_to_5_12),
  .a_data_out(a_data_5_11_to_5_12),
  .b_data_out(b_data_5_11_to_6_11),
  .a_addr(a_addr_5_11_NC),
  .b_addr(b_addr_5_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 5_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_12_to_5_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_12_to_6_12;
  wire [`AWIDTH-1:0] a_addr_5_12_NC;
  wire [`AWIDTH-1:0] b_addr_5_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_12_to_5_13;

matmul_4x4_systolic u_matmul_4x4_systolic_5_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_12),
  .a_data(a_data_5_12_NC),
  .b_data(b_data_5_12_NC),
  .a_data_in(a_data_5_11_to_5_12),
  .b_data_in(b_data_4_12_to_5_12),
  .c_data_in(c_data_5_11_to_5_12),
  .c_data_out(c_data_5_12_to_5_13),
  .a_data_out(a_data_5_12_to_5_13),
  .b_data_out(b_data_5_12_to_6_12),
  .a_addr(a_addr_5_12_NC),
  .b_addr(b_addr_5_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 5_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_13_to_5_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_13_to_6_13;
  wire [`AWIDTH-1:0] a_addr_5_13_NC;
  wire [`AWIDTH-1:0] b_addr_5_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_13_to_5_14;

matmul_4x4_systolic u_matmul_4x4_systolic_5_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_13),
  .a_data(a_data_5_13_NC),
  .b_data(b_data_5_13_NC),
  .a_data_in(a_data_5_12_to_5_13),
  .b_data_in(b_data_4_13_to_5_13),
  .c_data_in(c_data_5_12_to_5_13),
  .c_data_out(c_data_5_13_to_5_14),
  .a_data_out(a_data_5_13_to_5_14),
  .b_data_out(b_data_5_13_to_6_13),
  .a_addr(a_addr_5_13_NC),
  .b_addr(b_addr_5_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 5_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_14_to_5_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_14_to_6_14;
  wire [`AWIDTH-1:0] a_addr_5_14_NC;
  wire [`AWIDTH-1:0] b_addr_5_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_5_14_to_5_15;

matmul_4x4_systolic u_matmul_4x4_systolic_5_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_14),
  .a_data(a_data_5_14_NC),
  .b_data(b_data_5_14_NC),
  .a_data_in(a_data_5_13_to_5_14),
  .b_data_in(b_data_4_14_to_5_14),
  .c_data_in(c_data_5_13_to_5_14),
  .c_data_out(c_data_5_14_to_5_15),
  .a_data_out(a_data_5_14_to_5_15),
  .b_data_out(b_data_5_14_to_6_14),
  .a_addr(a_addr_5_14_NC),
  .b_addr(b_addr_5_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 5_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_15_to_5_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_15_to_6_15;
  wire [`AWIDTH-1:0] a_addr_5_15_NC;
  wire [`AWIDTH-1:0] b_addr_5_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_5_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_5_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_5_15),
  .a_data(a_data_5_15_NC),
  .b_data(b_data_5_15_NC),
  .a_data_in(a_data_5_14_to_5_15),
  .b_data_in(b_data_4_15_to_5_15),
  .c_data_in(c_data_5_14_to_5_15),
  .c_data_out(c_data_row_5),
  .a_data_out(a_data_5_15_to_5_16),
  .b_data_out(b_data_5_15_to_6_15),
  .a_addr(a_addr_5_15_NC),
  .b_addr(b_addr_5_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 6_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_0_to_6_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_0_to_7_0;
  wire [`AWIDTH-1:0] b_addr_6_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_6_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_0_to_6_1;

matmul_4x4_systolic u_matmul_4x4_systolic_6_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_0),
  .a_data(a_data_6_0),
  .b_data(b_data_6_0_NC),
  .a_data_in(a_data_in_6_0_NC),
  .b_data_in(b_data_5_0_to_6_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_6_0_to_6_1),
  .a_data_out(a_data_6_0_to_6_1),
  .b_data_out(b_data_6_0_to_7_0),
  .a_addr(a_addr_6_0),
  .b_addr(b_addr_6_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 6_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_1_to_6_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_1_to_7_1;
  wire [`AWIDTH-1:0] a_addr_6_1_NC;
  wire [`AWIDTH-1:0] b_addr_6_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_1_to_6_2;

matmul_4x4_systolic u_matmul_4x4_systolic_6_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_1),
  .a_data(a_data_6_1_NC),
  .b_data(b_data_6_1_NC),
  .a_data_in(a_data_6_0_to_6_1),
  .b_data_in(b_data_5_1_to_6_1),
  .c_data_in(c_data_6_0_to_6_1),
  .c_data_out(c_data_6_1_to_6_2),
  .a_data_out(a_data_6_1_to_6_2),
  .b_data_out(b_data_6_1_to_7_1),
  .a_addr(a_addr_6_1_NC),
  .b_addr(b_addr_6_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 6_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_2_to_6_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_2_to_7_2;
  wire [`AWIDTH-1:0] a_addr_6_2_NC;
  wire [`AWIDTH-1:0] b_addr_6_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_2_to_6_3;

matmul_4x4_systolic u_matmul_4x4_systolic_6_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_2),
  .a_data(a_data_6_2_NC),
  .b_data(b_data_6_2_NC),
  .a_data_in(a_data_6_1_to_6_2),
  .b_data_in(b_data_5_2_to_6_2),
  .c_data_in(c_data_6_1_to_6_2),
  .c_data_out(c_data_6_2_to_6_3),
  .a_data_out(a_data_6_2_to_6_3),
  .b_data_out(b_data_6_2_to_7_2),
  .a_addr(a_addr_6_2_NC),
  .b_addr(b_addr_6_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 6_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_3_to_6_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_3_to_7_3;
  wire [`AWIDTH-1:0] a_addr_6_3_NC;
  wire [`AWIDTH-1:0] b_addr_6_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_3_to_6_4;

matmul_4x4_systolic u_matmul_4x4_systolic_6_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_3),
  .a_data(a_data_6_3_NC),
  .b_data(b_data_6_3_NC),
  .a_data_in(a_data_6_2_to_6_3),
  .b_data_in(b_data_5_3_to_6_3),
  .c_data_in(c_data_6_2_to_6_3),
  .c_data_out(c_data_6_3_to_6_4),
  .a_data_out(a_data_6_3_to_6_4),
  .b_data_out(b_data_6_3_to_7_3),
  .a_addr(a_addr_6_3_NC),
  .b_addr(b_addr_6_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 6_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_4_to_6_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_4_to_7_4;
  wire [`AWIDTH-1:0] a_addr_6_4_NC;
  wire [`AWIDTH-1:0] b_addr_6_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_4_to_6_5;

matmul_4x4_systolic u_matmul_4x4_systolic_6_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_4),
  .a_data(a_data_6_4_NC),
  .b_data(b_data_6_4_NC),
  .a_data_in(a_data_6_3_to_6_4),
  .b_data_in(b_data_5_4_to_6_4),
  .c_data_in(c_data_6_3_to_6_4),
  .c_data_out(c_data_6_4_to_6_5),
  .a_data_out(a_data_6_4_to_6_5),
  .b_data_out(b_data_6_4_to_7_4),
  .a_addr(a_addr_6_4_NC),
  .b_addr(b_addr_6_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 6_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_5_to_6_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_5_to_7_5;
  wire [`AWIDTH-1:0] a_addr_6_5_NC;
  wire [`AWIDTH-1:0] b_addr_6_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_5_to_6_6;

matmul_4x4_systolic u_matmul_4x4_systolic_6_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_5),
  .a_data(a_data_6_5_NC),
  .b_data(b_data_6_5_NC),
  .a_data_in(a_data_6_4_to_6_5),
  .b_data_in(b_data_5_5_to_6_5),
  .c_data_in(c_data_6_4_to_6_5),
  .c_data_out(c_data_6_5_to_6_6),
  .a_data_out(a_data_6_5_to_6_6),
  .b_data_out(b_data_6_5_to_7_5),
  .a_addr(a_addr_6_5_NC),
  .b_addr(b_addr_6_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 6_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_6_to_6_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_6_to_7_6;
  wire [`AWIDTH-1:0] a_addr_6_6_NC;
  wire [`AWIDTH-1:0] b_addr_6_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_6_to_6_7;

matmul_4x4_systolic u_matmul_4x4_systolic_6_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_6),
  .a_data(a_data_6_6_NC),
  .b_data(b_data_6_6_NC),
  .a_data_in(a_data_6_5_to_6_6),
  .b_data_in(b_data_5_6_to_6_6),
  .c_data_in(c_data_6_5_to_6_6),
  .c_data_out(c_data_6_6_to_6_7),
  .a_data_out(a_data_6_6_to_6_7),
  .b_data_out(b_data_6_6_to_7_6),
  .a_addr(a_addr_6_6_NC),
  .b_addr(b_addr_6_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 6_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_7_to_6_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_7_to_7_7;
  wire [`AWIDTH-1:0] a_addr_6_7_NC;
  wire [`AWIDTH-1:0] b_addr_6_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_7_to_6_8;

matmul_4x4_systolic u_matmul_4x4_systolic_6_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_7),
  .a_data(a_data_6_7_NC),
  .b_data(b_data_6_7_NC),
  .a_data_in(a_data_6_6_to_6_7),
  .b_data_in(b_data_5_7_to_6_7),
  .c_data_in(c_data_6_6_to_6_7),
  .c_data_out(c_data_6_7_to_6_8),
  .a_data_out(a_data_6_7_to_6_8),
  .b_data_out(b_data_6_7_to_7_7),
  .a_addr(a_addr_6_7_NC),
  .b_addr(b_addr_6_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 6_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_8_to_6_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_8_to_7_8;
  wire [`AWIDTH-1:0] a_addr_6_8_NC;
  wire [`AWIDTH-1:0] b_addr_6_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_8_to_6_9;

matmul_4x4_systolic u_matmul_4x4_systolic_6_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_8),
  .a_data(a_data_6_8_NC),
  .b_data(b_data_6_8_NC),
  .a_data_in(a_data_6_7_to_6_8),
  .b_data_in(b_data_5_8_to_6_8),
  .c_data_in(c_data_6_7_to_6_8),
  .c_data_out(c_data_6_8_to_6_9),
  .a_data_out(a_data_6_8_to_6_9),
  .b_data_out(b_data_6_8_to_7_8),
  .a_addr(a_addr_6_8_NC),
  .b_addr(b_addr_6_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 6_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_9_to_6_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_9_to_7_9;
  wire [`AWIDTH-1:0] a_addr_6_9_NC;
  wire [`AWIDTH-1:0] b_addr_6_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_9_to_6_10;

matmul_4x4_systolic u_matmul_4x4_systolic_6_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_9),
  .a_data(a_data_6_9_NC),
  .b_data(b_data_6_9_NC),
  .a_data_in(a_data_6_8_to_6_9),
  .b_data_in(b_data_5_9_to_6_9),
  .c_data_in(c_data_6_8_to_6_9),
  .c_data_out(c_data_6_9_to_6_10),
  .a_data_out(a_data_6_9_to_6_10),
  .b_data_out(b_data_6_9_to_7_9),
  .a_addr(a_addr_6_9_NC),
  .b_addr(b_addr_6_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 6_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_10_to_6_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_10_to_7_10;
  wire [`AWIDTH-1:0] a_addr_6_10_NC;
  wire [`AWIDTH-1:0] b_addr_6_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_10_to_6_11;

matmul_4x4_systolic u_matmul_4x4_systolic_6_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_10),
  .a_data(a_data_6_10_NC),
  .b_data(b_data_6_10_NC),
  .a_data_in(a_data_6_9_to_6_10),
  .b_data_in(b_data_5_10_to_6_10),
  .c_data_in(c_data_6_9_to_6_10),
  .c_data_out(c_data_6_10_to_6_11),
  .a_data_out(a_data_6_10_to_6_11),
  .b_data_out(b_data_6_10_to_7_10),
  .a_addr(a_addr_6_10_NC),
  .b_addr(b_addr_6_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 6_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_11_to_6_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_11_to_7_11;
  wire [`AWIDTH-1:0] a_addr_6_11_NC;
  wire [`AWIDTH-1:0] b_addr_6_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_11_to_6_12;

matmul_4x4_systolic u_matmul_4x4_systolic_6_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_11),
  .a_data(a_data_6_11_NC),
  .b_data(b_data_6_11_NC),
  .a_data_in(a_data_6_10_to_6_11),
  .b_data_in(b_data_5_11_to_6_11),
  .c_data_in(c_data_6_10_to_6_11),
  .c_data_out(c_data_6_11_to_6_12),
  .a_data_out(a_data_6_11_to_6_12),
  .b_data_out(b_data_6_11_to_7_11),
  .a_addr(a_addr_6_11_NC),
  .b_addr(b_addr_6_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 6_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_12_to_6_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_12_to_7_12;
  wire [`AWIDTH-1:0] a_addr_6_12_NC;
  wire [`AWIDTH-1:0] b_addr_6_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_12_to_6_13;

matmul_4x4_systolic u_matmul_4x4_systolic_6_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_12),
  .a_data(a_data_6_12_NC),
  .b_data(b_data_6_12_NC),
  .a_data_in(a_data_6_11_to_6_12),
  .b_data_in(b_data_5_12_to_6_12),
  .c_data_in(c_data_6_11_to_6_12),
  .c_data_out(c_data_6_12_to_6_13),
  .a_data_out(a_data_6_12_to_6_13),
  .b_data_out(b_data_6_12_to_7_12),
  .a_addr(a_addr_6_12_NC),
  .b_addr(b_addr_6_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 6_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_13_to_6_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_13_to_7_13;
  wire [`AWIDTH-1:0] a_addr_6_13_NC;
  wire [`AWIDTH-1:0] b_addr_6_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_13_to_6_14;

matmul_4x4_systolic u_matmul_4x4_systolic_6_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_13),
  .a_data(a_data_6_13_NC),
  .b_data(b_data_6_13_NC),
  .a_data_in(a_data_6_12_to_6_13),
  .b_data_in(b_data_5_13_to_6_13),
  .c_data_in(c_data_6_12_to_6_13),
  .c_data_out(c_data_6_13_to_6_14),
  .a_data_out(a_data_6_13_to_6_14),
  .b_data_out(b_data_6_13_to_7_13),
  .a_addr(a_addr_6_13_NC),
  .b_addr(b_addr_6_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 6_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_14_to_6_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_14_to_7_14;
  wire [`AWIDTH-1:0] a_addr_6_14_NC;
  wire [`AWIDTH-1:0] b_addr_6_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_6_14_to_6_15;

matmul_4x4_systolic u_matmul_4x4_systolic_6_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_14),
  .a_data(a_data_6_14_NC),
  .b_data(b_data_6_14_NC),
  .a_data_in(a_data_6_13_to_6_14),
  .b_data_in(b_data_5_14_to_6_14),
  .c_data_in(c_data_6_13_to_6_14),
  .c_data_out(c_data_6_14_to_6_15),
  .a_data_out(a_data_6_14_to_6_15),
  .b_data_out(b_data_6_14_to_7_14),
  .a_addr(a_addr_6_14_NC),
  .b_addr(b_addr_6_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 6_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_15_to_6_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_15_to_7_15;
  wire [`AWIDTH-1:0] a_addr_6_15_NC;
  wire [`AWIDTH-1:0] b_addr_6_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_6_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_6_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_6_15),
  .a_data(a_data_6_15_NC),
  .b_data(b_data_6_15_NC),
  .a_data_in(a_data_6_14_to_6_15),
  .b_data_in(b_data_5_15_to_6_15),
  .c_data_in(c_data_6_14_to_6_15),
  .c_data_out(c_data_row_6),
  .a_data_out(a_data_6_15_to_6_16),
  .b_data_out(b_data_6_15_to_7_15),
  .a_addr(a_addr_6_15_NC),
  .b_addr(b_addr_6_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 7_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_0_to_7_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_0_to_8_0;
  wire [`AWIDTH-1:0] b_addr_7_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_7_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_0_to_7_1;

matmul_4x4_systolic u_matmul_4x4_systolic_7_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_0),
  .a_data(a_data_7_0),
  .b_data(b_data_7_0_NC),
  .a_data_in(a_data_in_7_0_NC),
  .b_data_in(b_data_6_0_to_7_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_7_0_to_7_1),
  .a_data_out(a_data_7_0_to_7_1),
  .b_data_out(b_data_7_0_to_8_0),
  .a_addr(a_addr_7_0),
  .b_addr(b_addr_7_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 7_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_1_to_7_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_1_to_8_1;
  wire [`AWIDTH-1:0] a_addr_7_1_NC;
  wire [`AWIDTH-1:0] b_addr_7_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_1_to_7_2;

matmul_4x4_systolic u_matmul_4x4_systolic_7_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_1),
  .a_data(a_data_7_1_NC),
  .b_data(b_data_7_1_NC),
  .a_data_in(a_data_7_0_to_7_1),
  .b_data_in(b_data_6_1_to_7_1),
  .c_data_in(c_data_7_0_to_7_1),
  .c_data_out(c_data_7_1_to_7_2),
  .a_data_out(a_data_7_1_to_7_2),
  .b_data_out(b_data_7_1_to_8_1),
  .a_addr(a_addr_7_1_NC),
  .b_addr(b_addr_7_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 7_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_2_to_7_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_2_to_8_2;
  wire [`AWIDTH-1:0] a_addr_7_2_NC;
  wire [`AWIDTH-1:0] b_addr_7_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_2_to_7_3;

matmul_4x4_systolic u_matmul_4x4_systolic_7_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_2),
  .a_data(a_data_7_2_NC),
  .b_data(b_data_7_2_NC),
  .a_data_in(a_data_7_1_to_7_2),
  .b_data_in(b_data_6_2_to_7_2),
  .c_data_in(c_data_7_1_to_7_2),
  .c_data_out(c_data_7_2_to_7_3),
  .a_data_out(a_data_7_2_to_7_3),
  .b_data_out(b_data_7_2_to_8_2),
  .a_addr(a_addr_7_2_NC),
  .b_addr(b_addr_7_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 7_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_3_to_7_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_3_to_8_3;
  wire [`AWIDTH-1:0] a_addr_7_3_NC;
  wire [`AWIDTH-1:0] b_addr_7_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_3_to_7_4;

matmul_4x4_systolic u_matmul_4x4_systolic_7_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_3),
  .a_data(a_data_7_3_NC),
  .b_data(b_data_7_3_NC),
  .a_data_in(a_data_7_2_to_7_3),
  .b_data_in(b_data_6_3_to_7_3),
  .c_data_in(c_data_7_2_to_7_3),
  .c_data_out(c_data_7_3_to_7_4),
  .a_data_out(a_data_7_3_to_7_4),
  .b_data_out(b_data_7_3_to_8_3),
  .a_addr(a_addr_7_3_NC),
  .b_addr(b_addr_7_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 7_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_4_to_7_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_4_to_8_4;
  wire [`AWIDTH-1:0] a_addr_7_4_NC;
  wire [`AWIDTH-1:0] b_addr_7_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_4_to_7_5;

matmul_4x4_systolic u_matmul_4x4_systolic_7_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_4),
  .a_data(a_data_7_4_NC),
  .b_data(b_data_7_4_NC),
  .a_data_in(a_data_7_3_to_7_4),
  .b_data_in(b_data_6_4_to_7_4),
  .c_data_in(c_data_7_3_to_7_4),
  .c_data_out(c_data_7_4_to_7_5),
  .a_data_out(a_data_7_4_to_7_5),
  .b_data_out(b_data_7_4_to_8_4),
  .a_addr(a_addr_7_4_NC),
  .b_addr(b_addr_7_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 7_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_5_to_7_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_5_to_8_5;
  wire [`AWIDTH-1:0] a_addr_7_5_NC;
  wire [`AWIDTH-1:0] b_addr_7_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_5_to_7_6;

matmul_4x4_systolic u_matmul_4x4_systolic_7_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_5),
  .a_data(a_data_7_5_NC),
  .b_data(b_data_7_5_NC),
  .a_data_in(a_data_7_4_to_7_5),
  .b_data_in(b_data_6_5_to_7_5),
  .c_data_in(c_data_7_4_to_7_5),
  .c_data_out(c_data_7_5_to_7_6),
  .a_data_out(a_data_7_5_to_7_6),
  .b_data_out(b_data_7_5_to_8_5),
  .a_addr(a_addr_7_5_NC),
  .b_addr(b_addr_7_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 7_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_6_to_7_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_6_to_8_6;
  wire [`AWIDTH-1:0] a_addr_7_6_NC;
  wire [`AWIDTH-1:0] b_addr_7_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_6_to_7_7;

matmul_4x4_systolic u_matmul_4x4_systolic_7_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_6),
  .a_data(a_data_7_6_NC),
  .b_data(b_data_7_6_NC),
  .a_data_in(a_data_7_5_to_7_6),
  .b_data_in(b_data_6_6_to_7_6),
  .c_data_in(c_data_7_5_to_7_6),
  .c_data_out(c_data_7_6_to_7_7),
  .a_data_out(a_data_7_6_to_7_7),
  .b_data_out(b_data_7_6_to_8_6),
  .a_addr(a_addr_7_6_NC),
  .b_addr(b_addr_7_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 7_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_7_to_7_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_7_to_8_7;
  wire [`AWIDTH-1:0] a_addr_7_7_NC;
  wire [`AWIDTH-1:0] b_addr_7_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_7_to_7_8;

matmul_4x4_systolic u_matmul_4x4_systolic_7_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_7),
  .a_data(a_data_7_7_NC),
  .b_data(b_data_7_7_NC),
  .a_data_in(a_data_7_6_to_7_7),
  .b_data_in(b_data_6_7_to_7_7),
  .c_data_in(c_data_7_6_to_7_7),
  .c_data_out(c_data_7_7_to_7_8),
  .a_data_out(a_data_7_7_to_7_8),
  .b_data_out(b_data_7_7_to_8_7),
  .a_addr(a_addr_7_7_NC),
  .b_addr(b_addr_7_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 7_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_8_to_7_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_8_to_8_8;
  wire [`AWIDTH-1:0] a_addr_7_8_NC;
  wire [`AWIDTH-1:0] b_addr_7_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_8_to_7_9;

matmul_4x4_systolic u_matmul_4x4_systolic_7_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_8),
  .a_data(a_data_7_8_NC),
  .b_data(b_data_7_8_NC),
  .a_data_in(a_data_7_7_to_7_8),
  .b_data_in(b_data_6_8_to_7_8),
  .c_data_in(c_data_7_7_to_7_8),
  .c_data_out(c_data_7_8_to_7_9),
  .a_data_out(a_data_7_8_to_7_9),
  .b_data_out(b_data_7_8_to_8_8),
  .a_addr(a_addr_7_8_NC),
  .b_addr(b_addr_7_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 7_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_9_to_7_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_9_to_8_9;
  wire [`AWIDTH-1:0] a_addr_7_9_NC;
  wire [`AWIDTH-1:0] b_addr_7_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_9_to_7_10;

matmul_4x4_systolic u_matmul_4x4_systolic_7_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_9),
  .a_data(a_data_7_9_NC),
  .b_data(b_data_7_9_NC),
  .a_data_in(a_data_7_8_to_7_9),
  .b_data_in(b_data_6_9_to_7_9),
  .c_data_in(c_data_7_8_to_7_9),
  .c_data_out(c_data_7_9_to_7_10),
  .a_data_out(a_data_7_9_to_7_10),
  .b_data_out(b_data_7_9_to_8_9),
  .a_addr(a_addr_7_9_NC),
  .b_addr(b_addr_7_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 7_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_10_to_7_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_10_to_8_10;
  wire [`AWIDTH-1:0] a_addr_7_10_NC;
  wire [`AWIDTH-1:0] b_addr_7_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_10_to_7_11;

matmul_4x4_systolic u_matmul_4x4_systolic_7_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_10),
  .a_data(a_data_7_10_NC),
  .b_data(b_data_7_10_NC),
  .a_data_in(a_data_7_9_to_7_10),
  .b_data_in(b_data_6_10_to_7_10),
  .c_data_in(c_data_7_9_to_7_10),
  .c_data_out(c_data_7_10_to_7_11),
  .a_data_out(a_data_7_10_to_7_11),
  .b_data_out(b_data_7_10_to_8_10),
  .a_addr(a_addr_7_10_NC),
  .b_addr(b_addr_7_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 7_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_11_to_7_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_11_to_8_11;
  wire [`AWIDTH-1:0] a_addr_7_11_NC;
  wire [`AWIDTH-1:0] b_addr_7_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_11_to_7_12;

matmul_4x4_systolic u_matmul_4x4_systolic_7_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_11),
  .a_data(a_data_7_11_NC),
  .b_data(b_data_7_11_NC),
  .a_data_in(a_data_7_10_to_7_11),
  .b_data_in(b_data_6_11_to_7_11),
  .c_data_in(c_data_7_10_to_7_11),
  .c_data_out(c_data_7_11_to_7_12),
  .a_data_out(a_data_7_11_to_7_12),
  .b_data_out(b_data_7_11_to_8_11),
  .a_addr(a_addr_7_11_NC),
  .b_addr(b_addr_7_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 7_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_12_to_7_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_12_to_8_12;
  wire [`AWIDTH-1:0] a_addr_7_12_NC;
  wire [`AWIDTH-1:0] b_addr_7_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_12_to_7_13;

matmul_4x4_systolic u_matmul_4x4_systolic_7_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_12),
  .a_data(a_data_7_12_NC),
  .b_data(b_data_7_12_NC),
  .a_data_in(a_data_7_11_to_7_12),
  .b_data_in(b_data_6_12_to_7_12),
  .c_data_in(c_data_7_11_to_7_12),
  .c_data_out(c_data_7_12_to_7_13),
  .a_data_out(a_data_7_12_to_7_13),
  .b_data_out(b_data_7_12_to_8_12),
  .a_addr(a_addr_7_12_NC),
  .b_addr(b_addr_7_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 7_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_13_to_7_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_13_to_8_13;
  wire [`AWIDTH-1:0] a_addr_7_13_NC;
  wire [`AWIDTH-1:0] b_addr_7_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_13_to_7_14;

matmul_4x4_systolic u_matmul_4x4_systolic_7_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_13),
  .a_data(a_data_7_13_NC),
  .b_data(b_data_7_13_NC),
  .a_data_in(a_data_7_12_to_7_13),
  .b_data_in(b_data_6_13_to_7_13),
  .c_data_in(c_data_7_12_to_7_13),
  .c_data_out(c_data_7_13_to_7_14),
  .a_data_out(a_data_7_13_to_7_14),
  .b_data_out(b_data_7_13_to_8_13),
  .a_addr(a_addr_7_13_NC),
  .b_addr(b_addr_7_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 7_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_14_to_7_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_14_to_8_14;
  wire [`AWIDTH-1:0] a_addr_7_14_NC;
  wire [`AWIDTH-1:0] b_addr_7_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_7_14_to_7_15;

matmul_4x4_systolic u_matmul_4x4_systolic_7_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_14),
  .a_data(a_data_7_14_NC),
  .b_data(b_data_7_14_NC),
  .a_data_in(a_data_7_13_to_7_14),
  .b_data_in(b_data_6_14_to_7_14),
  .c_data_in(c_data_7_13_to_7_14),
  .c_data_out(c_data_7_14_to_7_15),
  .a_data_out(a_data_7_14_to_7_15),
  .b_data_out(b_data_7_14_to_8_14),
  .a_addr(a_addr_7_14_NC),
  .b_addr(b_addr_7_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 7_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_15_to_7_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_15_to_8_15;
  wire [`AWIDTH-1:0] a_addr_7_15_NC;
  wire [`AWIDTH-1:0] b_addr_7_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_7_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_7_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_7_15),
  .a_data(a_data_7_15_NC),
  .b_data(b_data_7_15_NC),
  .a_data_in(a_data_7_14_to_7_15),
  .b_data_in(b_data_6_15_to_7_15),
  .c_data_in(c_data_7_14_to_7_15),
  .c_data_out(c_data_row_7),
  .a_data_out(a_data_7_15_to_7_16),
  .b_data_out(b_data_7_15_to_8_15),
  .a_addr(a_addr_7_15_NC),
  .b_addr(b_addr_7_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 8_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_0_to_8_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_0_to_9_0;
  wire [`AWIDTH-1:0] b_addr_8_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_8_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_0_to_8_1;

matmul_4x4_systolic u_matmul_4x4_systolic_8_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_0),
  .a_data(a_data_8_0),
  .b_data(b_data_8_0_NC),
  .a_data_in(a_data_in_8_0_NC),
  .b_data_in(b_data_7_0_to_8_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_8_0_to_8_1),
  .a_data_out(a_data_8_0_to_8_1),
  .b_data_out(b_data_8_0_to_9_0),
  .a_addr(a_addr_8_0),
  .b_addr(b_addr_8_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 8_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_1_to_8_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_1_to_9_1;
  wire [`AWIDTH-1:0] a_addr_8_1_NC;
  wire [`AWIDTH-1:0] b_addr_8_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_1_to_8_2;

matmul_4x4_systolic u_matmul_4x4_systolic_8_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_1),
  .a_data(a_data_8_1_NC),
  .b_data(b_data_8_1_NC),
  .a_data_in(a_data_8_0_to_8_1),
  .b_data_in(b_data_7_1_to_8_1),
  .c_data_in(c_data_8_0_to_8_1),
  .c_data_out(c_data_8_1_to_8_2),
  .a_data_out(a_data_8_1_to_8_2),
  .b_data_out(b_data_8_1_to_9_1),
  .a_addr(a_addr_8_1_NC),
  .b_addr(b_addr_8_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 8_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_2_to_8_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_2_to_9_2;
  wire [`AWIDTH-1:0] a_addr_8_2_NC;
  wire [`AWIDTH-1:0] b_addr_8_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_2_to_8_3;

matmul_4x4_systolic u_matmul_4x4_systolic_8_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_2),
  .a_data(a_data_8_2_NC),
  .b_data(b_data_8_2_NC),
  .a_data_in(a_data_8_1_to_8_2),
  .b_data_in(b_data_7_2_to_8_2),
  .c_data_in(c_data_8_1_to_8_2),
  .c_data_out(c_data_8_2_to_8_3),
  .a_data_out(a_data_8_2_to_8_3),
  .b_data_out(b_data_8_2_to_9_2),
  .a_addr(a_addr_8_2_NC),
  .b_addr(b_addr_8_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 8_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_3_to_8_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_3_to_9_3;
  wire [`AWIDTH-1:0] a_addr_8_3_NC;
  wire [`AWIDTH-1:0] b_addr_8_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_3_to_8_4;

matmul_4x4_systolic u_matmul_4x4_systolic_8_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_3),
  .a_data(a_data_8_3_NC),
  .b_data(b_data_8_3_NC),
  .a_data_in(a_data_8_2_to_8_3),
  .b_data_in(b_data_7_3_to_8_3),
  .c_data_in(c_data_8_2_to_8_3),
  .c_data_out(c_data_8_3_to_8_4),
  .a_data_out(a_data_8_3_to_8_4),
  .b_data_out(b_data_8_3_to_9_3),
  .a_addr(a_addr_8_3_NC),
  .b_addr(b_addr_8_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 8_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_4_to_8_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_4_to_9_4;
  wire [`AWIDTH-1:0] a_addr_8_4_NC;
  wire [`AWIDTH-1:0] b_addr_8_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_4_to_8_5;

matmul_4x4_systolic u_matmul_4x4_systolic_8_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_4),
  .a_data(a_data_8_4_NC),
  .b_data(b_data_8_4_NC),
  .a_data_in(a_data_8_3_to_8_4),
  .b_data_in(b_data_7_4_to_8_4),
  .c_data_in(c_data_8_3_to_8_4),
  .c_data_out(c_data_8_4_to_8_5),
  .a_data_out(a_data_8_4_to_8_5),
  .b_data_out(b_data_8_4_to_9_4),
  .a_addr(a_addr_8_4_NC),
  .b_addr(b_addr_8_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 8_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_5_to_8_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_5_to_9_5;
  wire [`AWIDTH-1:0] a_addr_8_5_NC;
  wire [`AWIDTH-1:0] b_addr_8_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_5_to_8_6;

matmul_4x4_systolic u_matmul_4x4_systolic_8_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_5),
  .a_data(a_data_8_5_NC),
  .b_data(b_data_8_5_NC),
  .a_data_in(a_data_8_4_to_8_5),
  .b_data_in(b_data_7_5_to_8_5),
  .c_data_in(c_data_8_4_to_8_5),
  .c_data_out(c_data_8_5_to_8_6),
  .a_data_out(a_data_8_5_to_8_6),
  .b_data_out(b_data_8_5_to_9_5),
  .a_addr(a_addr_8_5_NC),
  .b_addr(b_addr_8_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 8_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_6_to_8_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_6_to_9_6;
  wire [`AWIDTH-1:0] a_addr_8_6_NC;
  wire [`AWIDTH-1:0] b_addr_8_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_6_to_8_7;

matmul_4x4_systolic u_matmul_4x4_systolic_8_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_6),
  .a_data(a_data_8_6_NC),
  .b_data(b_data_8_6_NC),
  .a_data_in(a_data_8_5_to_8_6),
  .b_data_in(b_data_7_6_to_8_6),
  .c_data_in(c_data_8_5_to_8_6),
  .c_data_out(c_data_8_6_to_8_7),
  .a_data_out(a_data_8_6_to_8_7),
  .b_data_out(b_data_8_6_to_9_6),
  .a_addr(a_addr_8_6_NC),
  .b_addr(b_addr_8_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 8_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_7_to_8_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_7_to_9_7;
  wire [`AWIDTH-1:0] a_addr_8_7_NC;
  wire [`AWIDTH-1:0] b_addr_8_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_7_to_8_8;

matmul_4x4_systolic u_matmul_4x4_systolic_8_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_7),
  .a_data(a_data_8_7_NC),
  .b_data(b_data_8_7_NC),
  .a_data_in(a_data_8_6_to_8_7),
  .b_data_in(b_data_7_7_to_8_7),
  .c_data_in(c_data_8_6_to_8_7),
  .c_data_out(c_data_8_7_to_8_8),
  .a_data_out(a_data_8_7_to_8_8),
  .b_data_out(b_data_8_7_to_9_7),
  .a_addr(a_addr_8_7_NC),
  .b_addr(b_addr_8_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 8_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_8_to_8_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_8_to_9_8;
  wire [`AWIDTH-1:0] a_addr_8_8_NC;
  wire [`AWIDTH-1:0] b_addr_8_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_8_to_8_9;

matmul_4x4_systolic u_matmul_4x4_systolic_8_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_8),
  .a_data(a_data_8_8_NC),
  .b_data(b_data_8_8_NC),
  .a_data_in(a_data_8_7_to_8_8),
  .b_data_in(b_data_7_8_to_8_8),
  .c_data_in(c_data_8_7_to_8_8),
  .c_data_out(c_data_8_8_to_8_9),
  .a_data_out(a_data_8_8_to_8_9),
  .b_data_out(b_data_8_8_to_9_8),
  .a_addr(a_addr_8_8_NC),
  .b_addr(b_addr_8_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 8_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_9_to_8_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_9_to_9_9;
  wire [`AWIDTH-1:0] a_addr_8_9_NC;
  wire [`AWIDTH-1:0] b_addr_8_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_9_to_8_10;

matmul_4x4_systolic u_matmul_4x4_systolic_8_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_9),
  .a_data(a_data_8_9_NC),
  .b_data(b_data_8_9_NC),
  .a_data_in(a_data_8_8_to_8_9),
  .b_data_in(b_data_7_9_to_8_9),
  .c_data_in(c_data_8_8_to_8_9),
  .c_data_out(c_data_8_9_to_8_10),
  .a_data_out(a_data_8_9_to_8_10),
  .b_data_out(b_data_8_9_to_9_9),
  .a_addr(a_addr_8_9_NC),
  .b_addr(b_addr_8_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 8_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_10_to_8_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_10_to_9_10;
  wire [`AWIDTH-1:0] a_addr_8_10_NC;
  wire [`AWIDTH-1:0] b_addr_8_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_10_to_8_11;

matmul_4x4_systolic u_matmul_4x4_systolic_8_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_10),
  .a_data(a_data_8_10_NC),
  .b_data(b_data_8_10_NC),
  .a_data_in(a_data_8_9_to_8_10),
  .b_data_in(b_data_7_10_to_8_10),
  .c_data_in(c_data_8_9_to_8_10),
  .c_data_out(c_data_8_10_to_8_11),
  .a_data_out(a_data_8_10_to_8_11),
  .b_data_out(b_data_8_10_to_9_10),
  .a_addr(a_addr_8_10_NC),
  .b_addr(b_addr_8_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 8_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_11_to_8_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_11_to_9_11;
  wire [`AWIDTH-1:0] a_addr_8_11_NC;
  wire [`AWIDTH-1:0] b_addr_8_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_11_to_8_12;

matmul_4x4_systolic u_matmul_4x4_systolic_8_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_11),
  .a_data(a_data_8_11_NC),
  .b_data(b_data_8_11_NC),
  .a_data_in(a_data_8_10_to_8_11),
  .b_data_in(b_data_7_11_to_8_11),
  .c_data_in(c_data_8_10_to_8_11),
  .c_data_out(c_data_8_11_to_8_12),
  .a_data_out(a_data_8_11_to_8_12),
  .b_data_out(b_data_8_11_to_9_11),
  .a_addr(a_addr_8_11_NC),
  .b_addr(b_addr_8_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 8_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_12_to_8_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_12_to_9_12;
  wire [`AWIDTH-1:0] a_addr_8_12_NC;
  wire [`AWIDTH-1:0] b_addr_8_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_12_to_8_13;

matmul_4x4_systolic u_matmul_4x4_systolic_8_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_12),
  .a_data(a_data_8_12_NC),
  .b_data(b_data_8_12_NC),
  .a_data_in(a_data_8_11_to_8_12),
  .b_data_in(b_data_7_12_to_8_12),
  .c_data_in(c_data_8_11_to_8_12),
  .c_data_out(c_data_8_12_to_8_13),
  .a_data_out(a_data_8_12_to_8_13),
  .b_data_out(b_data_8_12_to_9_12),
  .a_addr(a_addr_8_12_NC),
  .b_addr(b_addr_8_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 8_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_13_to_8_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_13_to_9_13;
  wire [`AWIDTH-1:0] a_addr_8_13_NC;
  wire [`AWIDTH-1:0] b_addr_8_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_13_to_8_14;

matmul_4x4_systolic u_matmul_4x4_systolic_8_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_13),
  .a_data(a_data_8_13_NC),
  .b_data(b_data_8_13_NC),
  .a_data_in(a_data_8_12_to_8_13),
  .b_data_in(b_data_7_13_to_8_13),
  .c_data_in(c_data_8_12_to_8_13),
  .c_data_out(c_data_8_13_to_8_14),
  .a_data_out(a_data_8_13_to_8_14),
  .b_data_out(b_data_8_13_to_9_13),
  .a_addr(a_addr_8_13_NC),
  .b_addr(b_addr_8_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 8_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_14_to_8_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_14_to_9_14;
  wire [`AWIDTH-1:0] a_addr_8_14_NC;
  wire [`AWIDTH-1:0] b_addr_8_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_8_14_to_8_15;

matmul_4x4_systolic u_matmul_4x4_systolic_8_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_14),
  .a_data(a_data_8_14_NC),
  .b_data(b_data_8_14_NC),
  .a_data_in(a_data_8_13_to_8_14),
  .b_data_in(b_data_7_14_to_8_14),
  .c_data_in(c_data_8_13_to_8_14),
  .c_data_out(c_data_8_14_to_8_15),
  .a_data_out(a_data_8_14_to_8_15),
  .b_data_out(b_data_8_14_to_9_14),
  .a_addr(a_addr_8_14_NC),
  .b_addr(b_addr_8_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 8_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_15_to_8_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_15_to_9_15;
  wire [`AWIDTH-1:0] a_addr_8_15_NC;
  wire [`AWIDTH-1:0] b_addr_8_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_8_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_8_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_8_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_8_15),
  .a_data(a_data_8_15_NC),
  .b_data(b_data_8_15_NC),
  .a_data_in(a_data_8_14_to_8_15),
  .b_data_in(b_data_7_15_to_8_15),
  .c_data_in(c_data_8_14_to_8_15),
  .c_data_out(c_data_row_8),
  .a_data_out(a_data_8_15_to_8_16),
  .b_data_out(b_data_8_15_to_9_15),
  .a_addr(a_addr_8_15_NC),
  .b_addr(b_addr_8_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd8),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 9_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_0_to_9_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_0_to_10_0;
  wire [`AWIDTH-1:0] b_addr_9_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_9_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_0_to_9_1;

matmul_4x4_systolic u_matmul_4x4_systolic_9_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_0),
  .a_data(a_data_9_0),
  .b_data(b_data_9_0_NC),
  .a_data_in(a_data_in_9_0_NC),
  .b_data_in(b_data_8_0_to_9_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_9_0_to_9_1),
  .a_data_out(a_data_9_0_to_9_1),
  .b_data_out(b_data_9_0_to_10_0),
  .a_addr(a_addr_9_0),
  .b_addr(b_addr_9_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 9_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_1_to_9_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_1_to_10_1;
  wire [`AWIDTH-1:0] a_addr_9_1_NC;
  wire [`AWIDTH-1:0] b_addr_9_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_1_to_9_2;

matmul_4x4_systolic u_matmul_4x4_systolic_9_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_1),
  .a_data(a_data_9_1_NC),
  .b_data(b_data_9_1_NC),
  .a_data_in(a_data_9_0_to_9_1),
  .b_data_in(b_data_8_1_to_9_1),
  .c_data_in(c_data_9_0_to_9_1),
  .c_data_out(c_data_9_1_to_9_2),
  .a_data_out(a_data_9_1_to_9_2),
  .b_data_out(b_data_9_1_to_10_1),
  .a_addr(a_addr_9_1_NC),
  .b_addr(b_addr_9_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 9_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_2_to_9_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_2_to_10_2;
  wire [`AWIDTH-1:0] a_addr_9_2_NC;
  wire [`AWIDTH-1:0] b_addr_9_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_2_to_9_3;

matmul_4x4_systolic u_matmul_4x4_systolic_9_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_2),
  .a_data(a_data_9_2_NC),
  .b_data(b_data_9_2_NC),
  .a_data_in(a_data_9_1_to_9_2),
  .b_data_in(b_data_8_2_to_9_2),
  .c_data_in(c_data_9_1_to_9_2),
  .c_data_out(c_data_9_2_to_9_3),
  .a_data_out(a_data_9_2_to_9_3),
  .b_data_out(b_data_9_2_to_10_2),
  .a_addr(a_addr_9_2_NC),
  .b_addr(b_addr_9_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 9_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_3_to_9_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_3_to_10_3;
  wire [`AWIDTH-1:0] a_addr_9_3_NC;
  wire [`AWIDTH-1:0] b_addr_9_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_3_to_9_4;

matmul_4x4_systolic u_matmul_4x4_systolic_9_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_3),
  .a_data(a_data_9_3_NC),
  .b_data(b_data_9_3_NC),
  .a_data_in(a_data_9_2_to_9_3),
  .b_data_in(b_data_8_3_to_9_3),
  .c_data_in(c_data_9_2_to_9_3),
  .c_data_out(c_data_9_3_to_9_4),
  .a_data_out(a_data_9_3_to_9_4),
  .b_data_out(b_data_9_3_to_10_3),
  .a_addr(a_addr_9_3_NC),
  .b_addr(b_addr_9_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 9_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_4_to_9_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_4_to_10_4;
  wire [`AWIDTH-1:0] a_addr_9_4_NC;
  wire [`AWIDTH-1:0] b_addr_9_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_4_to_9_5;

matmul_4x4_systolic u_matmul_4x4_systolic_9_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_4),
  .a_data(a_data_9_4_NC),
  .b_data(b_data_9_4_NC),
  .a_data_in(a_data_9_3_to_9_4),
  .b_data_in(b_data_8_4_to_9_4),
  .c_data_in(c_data_9_3_to_9_4),
  .c_data_out(c_data_9_4_to_9_5),
  .a_data_out(a_data_9_4_to_9_5),
  .b_data_out(b_data_9_4_to_10_4),
  .a_addr(a_addr_9_4_NC),
  .b_addr(b_addr_9_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 9_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_5_to_9_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_5_to_10_5;
  wire [`AWIDTH-1:0] a_addr_9_5_NC;
  wire [`AWIDTH-1:0] b_addr_9_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_5_to_9_6;

matmul_4x4_systolic u_matmul_4x4_systolic_9_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_5),
  .a_data(a_data_9_5_NC),
  .b_data(b_data_9_5_NC),
  .a_data_in(a_data_9_4_to_9_5),
  .b_data_in(b_data_8_5_to_9_5),
  .c_data_in(c_data_9_4_to_9_5),
  .c_data_out(c_data_9_5_to_9_6),
  .a_data_out(a_data_9_5_to_9_6),
  .b_data_out(b_data_9_5_to_10_5),
  .a_addr(a_addr_9_5_NC),
  .b_addr(b_addr_9_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 9_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_6_to_9_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_6_to_10_6;
  wire [`AWIDTH-1:0] a_addr_9_6_NC;
  wire [`AWIDTH-1:0] b_addr_9_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_6_to_9_7;

matmul_4x4_systolic u_matmul_4x4_systolic_9_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_6),
  .a_data(a_data_9_6_NC),
  .b_data(b_data_9_6_NC),
  .a_data_in(a_data_9_5_to_9_6),
  .b_data_in(b_data_8_6_to_9_6),
  .c_data_in(c_data_9_5_to_9_6),
  .c_data_out(c_data_9_6_to_9_7),
  .a_data_out(a_data_9_6_to_9_7),
  .b_data_out(b_data_9_6_to_10_6),
  .a_addr(a_addr_9_6_NC),
  .b_addr(b_addr_9_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 9_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_7_to_9_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_7_to_10_7;
  wire [`AWIDTH-1:0] a_addr_9_7_NC;
  wire [`AWIDTH-1:0] b_addr_9_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_7_to_9_8;

matmul_4x4_systolic u_matmul_4x4_systolic_9_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_7),
  .a_data(a_data_9_7_NC),
  .b_data(b_data_9_7_NC),
  .a_data_in(a_data_9_6_to_9_7),
  .b_data_in(b_data_8_7_to_9_7),
  .c_data_in(c_data_9_6_to_9_7),
  .c_data_out(c_data_9_7_to_9_8),
  .a_data_out(a_data_9_7_to_9_8),
  .b_data_out(b_data_9_7_to_10_7),
  .a_addr(a_addr_9_7_NC),
  .b_addr(b_addr_9_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 9_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_8_to_9_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_8_to_10_8;
  wire [`AWIDTH-1:0] a_addr_9_8_NC;
  wire [`AWIDTH-1:0] b_addr_9_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_8_to_9_9;

matmul_4x4_systolic u_matmul_4x4_systolic_9_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_8),
  .a_data(a_data_9_8_NC),
  .b_data(b_data_9_8_NC),
  .a_data_in(a_data_9_7_to_9_8),
  .b_data_in(b_data_8_8_to_9_8),
  .c_data_in(c_data_9_7_to_9_8),
  .c_data_out(c_data_9_8_to_9_9),
  .a_data_out(a_data_9_8_to_9_9),
  .b_data_out(b_data_9_8_to_10_8),
  .a_addr(a_addr_9_8_NC),
  .b_addr(b_addr_9_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 9_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_9_to_9_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_9_to_10_9;
  wire [`AWIDTH-1:0] a_addr_9_9_NC;
  wire [`AWIDTH-1:0] b_addr_9_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_9_to_9_10;

matmul_4x4_systolic u_matmul_4x4_systolic_9_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_9),
  .a_data(a_data_9_9_NC),
  .b_data(b_data_9_9_NC),
  .a_data_in(a_data_9_8_to_9_9),
  .b_data_in(b_data_8_9_to_9_9),
  .c_data_in(c_data_9_8_to_9_9),
  .c_data_out(c_data_9_9_to_9_10),
  .a_data_out(a_data_9_9_to_9_10),
  .b_data_out(b_data_9_9_to_10_9),
  .a_addr(a_addr_9_9_NC),
  .b_addr(b_addr_9_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 9_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_10_to_9_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_10_to_10_10;
  wire [`AWIDTH-1:0] a_addr_9_10_NC;
  wire [`AWIDTH-1:0] b_addr_9_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_10_to_9_11;

matmul_4x4_systolic u_matmul_4x4_systolic_9_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_10),
  .a_data(a_data_9_10_NC),
  .b_data(b_data_9_10_NC),
  .a_data_in(a_data_9_9_to_9_10),
  .b_data_in(b_data_8_10_to_9_10),
  .c_data_in(c_data_9_9_to_9_10),
  .c_data_out(c_data_9_10_to_9_11),
  .a_data_out(a_data_9_10_to_9_11),
  .b_data_out(b_data_9_10_to_10_10),
  .a_addr(a_addr_9_10_NC),
  .b_addr(b_addr_9_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 9_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_11_to_9_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_11_to_10_11;
  wire [`AWIDTH-1:0] a_addr_9_11_NC;
  wire [`AWIDTH-1:0] b_addr_9_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_11_to_9_12;

matmul_4x4_systolic u_matmul_4x4_systolic_9_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_11),
  .a_data(a_data_9_11_NC),
  .b_data(b_data_9_11_NC),
  .a_data_in(a_data_9_10_to_9_11),
  .b_data_in(b_data_8_11_to_9_11),
  .c_data_in(c_data_9_10_to_9_11),
  .c_data_out(c_data_9_11_to_9_12),
  .a_data_out(a_data_9_11_to_9_12),
  .b_data_out(b_data_9_11_to_10_11),
  .a_addr(a_addr_9_11_NC),
  .b_addr(b_addr_9_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 9_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_12_to_9_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_12_to_10_12;
  wire [`AWIDTH-1:0] a_addr_9_12_NC;
  wire [`AWIDTH-1:0] b_addr_9_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_12_to_9_13;

matmul_4x4_systolic u_matmul_4x4_systolic_9_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_12),
  .a_data(a_data_9_12_NC),
  .b_data(b_data_9_12_NC),
  .a_data_in(a_data_9_11_to_9_12),
  .b_data_in(b_data_8_12_to_9_12),
  .c_data_in(c_data_9_11_to_9_12),
  .c_data_out(c_data_9_12_to_9_13),
  .a_data_out(a_data_9_12_to_9_13),
  .b_data_out(b_data_9_12_to_10_12),
  .a_addr(a_addr_9_12_NC),
  .b_addr(b_addr_9_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 9_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_13_to_9_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_13_to_10_13;
  wire [`AWIDTH-1:0] a_addr_9_13_NC;
  wire [`AWIDTH-1:0] b_addr_9_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_13_to_9_14;

matmul_4x4_systolic u_matmul_4x4_systolic_9_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_13),
  .a_data(a_data_9_13_NC),
  .b_data(b_data_9_13_NC),
  .a_data_in(a_data_9_12_to_9_13),
  .b_data_in(b_data_8_13_to_9_13),
  .c_data_in(c_data_9_12_to_9_13),
  .c_data_out(c_data_9_13_to_9_14),
  .a_data_out(a_data_9_13_to_9_14),
  .b_data_out(b_data_9_13_to_10_13),
  .a_addr(a_addr_9_13_NC),
  .b_addr(b_addr_9_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 9_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_14_to_9_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_14_to_10_14;
  wire [`AWIDTH-1:0] a_addr_9_14_NC;
  wire [`AWIDTH-1:0] b_addr_9_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_9_14_to_9_15;

matmul_4x4_systolic u_matmul_4x4_systolic_9_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_14),
  .a_data(a_data_9_14_NC),
  .b_data(b_data_9_14_NC),
  .a_data_in(a_data_9_13_to_9_14),
  .b_data_in(b_data_8_14_to_9_14),
  .c_data_in(c_data_9_13_to_9_14),
  .c_data_out(c_data_9_14_to_9_15),
  .a_data_out(a_data_9_14_to_9_15),
  .b_data_out(b_data_9_14_to_10_14),
  .a_addr(a_addr_9_14_NC),
  .b_addr(b_addr_9_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 9_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_15_to_9_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_15_to_10_15;
  wire [`AWIDTH-1:0] a_addr_9_15_NC;
  wire [`AWIDTH-1:0] b_addr_9_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_9_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_9_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_9_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_9_15),
  .a_data(a_data_9_15_NC),
  .b_data(b_data_9_15_NC),
  .a_data_in(a_data_9_14_to_9_15),
  .b_data_in(b_data_8_15_to_9_15),
  .c_data_in(c_data_9_14_to_9_15),
  .c_data_out(c_data_row_9),
  .a_data_out(a_data_9_15_to_9_16),
  .b_data_out(b_data_9_15_to_10_15),
  .a_addr(a_addr_9_15_NC),
  .b_addr(b_addr_9_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd9),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 10_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_0_to_10_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_0_to_11_0;
  wire [`AWIDTH-1:0] b_addr_10_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_10_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_0_to_10_1;

matmul_4x4_systolic u_matmul_4x4_systolic_10_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_0),
  .a_data(a_data_10_0),
  .b_data(b_data_10_0_NC),
  .a_data_in(a_data_in_10_0_NC),
  .b_data_in(b_data_9_0_to_10_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_10_0_to_10_1),
  .a_data_out(a_data_10_0_to_10_1),
  .b_data_out(b_data_10_0_to_11_0),
  .a_addr(a_addr_10_0),
  .b_addr(b_addr_10_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 10_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_1_to_10_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_1_to_11_1;
  wire [`AWIDTH-1:0] a_addr_10_1_NC;
  wire [`AWIDTH-1:0] b_addr_10_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_1_to_10_2;

matmul_4x4_systolic u_matmul_4x4_systolic_10_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_1),
  .a_data(a_data_10_1_NC),
  .b_data(b_data_10_1_NC),
  .a_data_in(a_data_10_0_to_10_1),
  .b_data_in(b_data_9_1_to_10_1),
  .c_data_in(c_data_10_0_to_10_1),
  .c_data_out(c_data_10_1_to_10_2),
  .a_data_out(a_data_10_1_to_10_2),
  .b_data_out(b_data_10_1_to_11_1),
  .a_addr(a_addr_10_1_NC),
  .b_addr(b_addr_10_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 10_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_2_to_10_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_2_to_11_2;
  wire [`AWIDTH-1:0] a_addr_10_2_NC;
  wire [`AWIDTH-1:0] b_addr_10_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_2_to_10_3;

matmul_4x4_systolic u_matmul_4x4_systolic_10_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_2),
  .a_data(a_data_10_2_NC),
  .b_data(b_data_10_2_NC),
  .a_data_in(a_data_10_1_to_10_2),
  .b_data_in(b_data_9_2_to_10_2),
  .c_data_in(c_data_10_1_to_10_2),
  .c_data_out(c_data_10_2_to_10_3),
  .a_data_out(a_data_10_2_to_10_3),
  .b_data_out(b_data_10_2_to_11_2),
  .a_addr(a_addr_10_2_NC),
  .b_addr(b_addr_10_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 10_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_3_to_10_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_3_to_11_3;
  wire [`AWIDTH-1:0] a_addr_10_3_NC;
  wire [`AWIDTH-1:0] b_addr_10_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_3_to_10_4;

matmul_4x4_systolic u_matmul_4x4_systolic_10_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_3),
  .a_data(a_data_10_3_NC),
  .b_data(b_data_10_3_NC),
  .a_data_in(a_data_10_2_to_10_3),
  .b_data_in(b_data_9_3_to_10_3),
  .c_data_in(c_data_10_2_to_10_3),
  .c_data_out(c_data_10_3_to_10_4),
  .a_data_out(a_data_10_3_to_10_4),
  .b_data_out(b_data_10_3_to_11_3),
  .a_addr(a_addr_10_3_NC),
  .b_addr(b_addr_10_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 10_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_4_to_10_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_4_to_11_4;
  wire [`AWIDTH-1:0] a_addr_10_4_NC;
  wire [`AWIDTH-1:0] b_addr_10_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_4_to_10_5;

matmul_4x4_systolic u_matmul_4x4_systolic_10_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_4),
  .a_data(a_data_10_4_NC),
  .b_data(b_data_10_4_NC),
  .a_data_in(a_data_10_3_to_10_4),
  .b_data_in(b_data_9_4_to_10_4),
  .c_data_in(c_data_10_3_to_10_4),
  .c_data_out(c_data_10_4_to_10_5),
  .a_data_out(a_data_10_4_to_10_5),
  .b_data_out(b_data_10_4_to_11_4),
  .a_addr(a_addr_10_4_NC),
  .b_addr(b_addr_10_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 10_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_5_to_10_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_5_to_11_5;
  wire [`AWIDTH-1:0] a_addr_10_5_NC;
  wire [`AWIDTH-1:0] b_addr_10_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_5_to_10_6;

matmul_4x4_systolic u_matmul_4x4_systolic_10_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_5),
  .a_data(a_data_10_5_NC),
  .b_data(b_data_10_5_NC),
  .a_data_in(a_data_10_4_to_10_5),
  .b_data_in(b_data_9_5_to_10_5),
  .c_data_in(c_data_10_4_to_10_5),
  .c_data_out(c_data_10_5_to_10_6),
  .a_data_out(a_data_10_5_to_10_6),
  .b_data_out(b_data_10_5_to_11_5),
  .a_addr(a_addr_10_5_NC),
  .b_addr(b_addr_10_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 10_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_6_to_10_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_6_to_11_6;
  wire [`AWIDTH-1:0] a_addr_10_6_NC;
  wire [`AWIDTH-1:0] b_addr_10_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_6_to_10_7;

matmul_4x4_systolic u_matmul_4x4_systolic_10_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_6),
  .a_data(a_data_10_6_NC),
  .b_data(b_data_10_6_NC),
  .a_data_in(a_data_10_5_to_10_6),
  .b_data_in(b_data_9_6_to_10_6),
  .c_data_in(c_data_10_5_to_10_6),
  .c_data_out(c_data_10_6_to_10_7),
  .a_data_out(a_data_10_6_to_10_7),
  .b_data_out(b_data_10_6_to_11_6),
  .a_addr(a_addr_10_6_NC),
  .b_addr(b_addr_10_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 10_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_7_to_10_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_7_to_11_7;
  wire [`AWIDTH-1:0] a_addr_10_7_NC;
  wire [`AWIDTH-1:0] b_addr_10_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_7_to_10_8;

matmul_4x4_systolic u_matmul_4x4_systolic_10_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_7),
  .a_data(a_data_10_7_NC),
  .b_data(b_data_10_7_NC),
  .a_data_in(a_data_10_6_to_10_7),
  .b_data_in(b_data_9_7_to_10_7),
  .c_data_in(c_data_10_6_to_10_7),
  .c_data_out(c_data_10_7_to_10_8),
  .a_data_out(a_data_10_7_to_10_8),
  .b_data_out(b_data_10_7_to_11_7),
  .a_addr(a_addr_10_7_NC),
  .b_addr(b_addr_10_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 10_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_8_to_10_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_8_to_11_8;
  wire [`AWIDTH-1:0] a_addr_10_8_NC;
  wire [`AWIDTH-1:0] b_addr_10_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_8_to_10_9;

matmul_4x4_systolic u_matmul_4x4_systolic_10_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_8),
  .a_data(a_data_10_8_NC),
  .b_data(b_data_10_8_NC),
  .a_data_in(a_data_10_7_to_10_8),
  .b_data_in(b_data_9_8_to_10_8),
  .c_data_in(c_data_10_7_to_10_8),
  .c_data_out(c_data_10_8_to_10_9),
  .a_data_out(a_data_10_8_to_10_9),
  .b_data_out(b_data_10_8_to_11_8),
  .a_addr(a_addr_10_8_NC),
  .b_addr(b_addr_10_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 10_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_9_to_10_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_9_to_11_9;
  wire [`AWIDTH-1:0] a_addr_10_9_NC;
  wire [`AWIDTH-1:0] b_addr_10_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_9_to_10_10;

matmul_4x4_systolic u_matmul_4x4_systolic_10_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_9),
  .a_data(a_data_10_9_NC),
  .b_data(b_data_10_9_NC),
  .a_data_in(a_data_10_8_to_10_9),
  .b_data_in(b_data_9_9_to_10_9),
  .c_data_in(c_data_10_8_to_10_9),
  .c_data_out(c_data_10_9_to_10_10),
  .a_data_out(a_data_10_9_to_10_10),
  .b_data_out(b_data_10_9_to_11_9),
  .a_addr(a_addr_10_9_NC),
  .b_addr(b_addr_10_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 10_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_10_to_10_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_10_to_11_10;
  wire [`AWIDTH-1:0] a_addr_10_10_NC;
  wire [`AWIDTH-1:0] b_addr_10_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_10_to_10_11;

matmul_4x4_systolic u_matmul_4x4_systolic_10_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_10),
  .a_data(a_data_10_10_NC),
  .b_data(b_data_10_10_NC),
  .a_data_in(a_data_10_9_to_10_10),
  .b_data_in(b_data_9_10_to_10_10),
  .c_data_in(c_data_10_9_to_10_10),
  .c_data_out(c_data_10_10_to_10_11),
  .a_data_out(a_data_10_10_to_10_11),
  .b_data_out(b_data_10_10_to_11_10),
  .a_addr(a_addr_10_10_NC),
  .b_addr(b_addr_10_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 10_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_11_to_10_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_11_to_11_11;
  wire [`AWIDTH-1:0] a_addr_10_11_NC;
  wire [`AWIDTH-1:0] b_addr_10_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_11_to_10_12;

matmul_4x4_systolic u_matmul_4x4_systolic_10_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_11),
  .a_data(a_data_10_11_NC),
  .b_data(b_data_10_11_NC),
  .a_data_in(a_data_10_10_to_10_11),
  .b_data_in(b_data_9_11_to_10_11),
  .c_data_in(c_data_10_10_to_10_11),
  .c_data_out(c_data_10_11_to_10_12),
  .a_data_out(a_data_10_11_to_10_12),
  .b_data_out(b_data_10_11_to_11_11),
  .a_addr(a_addr_10_11_NC),
  .b_addr(b_addr_10_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 10_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_12_to_10_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_12_to_11_12;
  wire [`AWIDTH-1:0] a_addr_10_12_NC;
  wire [`AWIDTH-1:0] b_addr_10_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_12_to_10_13;

matmul_4x4_systolic u_matmul_4x4_systolic_10_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_12),
  .a_data(a_data_10_12_NC),
  .b_data(b_data_10_12_NC),
  .a_data_in(a_data_10_11_to_10_12),
  .b_data_in(b_data_9_12_to_10_12),
  .c_data_in(c_data_10_11_to_10_12),
  .c_data_out(c_data_10_12_to_10_13),
  .a_data_out(a_data_10_12_to_10_13),
  .b_data_out(b_data_10_12_to_11_12),
  .a_addr(a_addr_10_12_NC),
  .b_addr(b_addr_10_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 10_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_13_to_10_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_13_to_11_13;
  wire [`AWIDTH-1:0] a_addr_10_13_NC;
  wire [`AWIDTH-1:0] b_addr_10_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_13_to_10_14;

matmul_4x4_systolic u_matmul_4x4_systolic_10_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_13),
  .a_data(a_data_10_13_NC),
  .b_data(b_data_10_13_NC),
  .a_data_in(a_data_10_12_to_10_13),
  .b_data_in(b_data_9_13_to_10_13),
  .c_data_in(c_data_10_12_to_10_13),
  .c_data_out(c_data_10_13_to_10_14),
  .a_data_out(a_data_10_13_to_10_14),
  .b_data_out(b_data_10_13_to_11_13),
  .a_addr(a_addr_10_13_NC),
  .b_addr(b_addr_10_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 10_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_14_to_10_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_14_to_11_14;
  wire [`AWIDTH-1:0] a_addr_10_14_NC;
  wire [`AWIDTH-1:0] b_addr_10_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10_14_to_10_15;

matmul_4x4_systolic u_matmul_4x4_systolic_10_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_14),
  .a_data(a_data_10_14_NC),
  .b_data(b_data_10_14_NC),
  .a_data_in(a_data_10_13_to_10_14),
  .b_data_in(b_data_9_14_to_10_14),
  .c_data_in(c_data_10_13_to_10_14),
  .c_data_out(c_data_10_14_to_10_15),
  .a_data_out(a_data_10_14_to_10_15),
  .b_data_out(b_data_10_14_to_11_14),
  .a_addr(a_addr_10_14_NC),
  .b_addr(b_addr_10_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 10_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_15_to_10_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_15_to_11_15;
  wire [`AWIDTH-1:0] a_addr_10_15_NC;
  wire [`AWIDTH-1:0] b_addr_10_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_10_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10_15),
  .a_data(a_data_10_15_NC),
  .b_data(b_data_10_15_NC),
  .a_data_in(a_data_10_14_to_10_15),
  .b_data_in(b_data_9_15_to_10_15),
  .c_data_in(c_data_10_14_to_10_15),
  .c_data_out(c_data_row_10),
  .a_data_out(a_data_10_15_to_10_16),
  .b_data_out(b_data_10_15_to_11_15),
  .a_addr(a_addr_10_15_NC),
  .b_addr(b_addr_10_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd10),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 11_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_0_to_11_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_0_to_12_0;
  wire [`AWIDTH-1:0] b_addr_11_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_11_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_0_to_11_1;

matmul_4x4_systolic u_matmul_4x4_systolic_11_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_0),
  .a_data(a_data_11_0),
  .b_data(b_data_11_0_NC),
  .a_data_in(a_data_in_11_0_NC),
  .b_data_in(b_data_10_0_to_11_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_11_0_to_11_1),
  .a_data_out(a_data_11_0_to_11_1),
  .b_data_out(b_data_11_0_to_12_0),
  .a_addr(a_addr_11_0),
  .b_addr(b_addr_11_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 11_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_1_to_11_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_1_to_12_1;
  wire [`AWIDTH-1:0] a_addr_11_1_NC;
  wire [`AWIDTH-1:0] b_addr_11_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_1_to_11_2;

matmul_4x4_systolic u_matmul_4x4_systolic_11_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_1),
  .a_data(a_data_11_1_NC),
  .b_data(b_data_11_1_NC),
  .a_data_in(a_data_11_0_to_11_1),
  .b_data_in(b_data_10_1_to_11_1),
  .c_data_in(c_data_11_0_to_11_1),
  .c_data_out(c_data_11_1_to_11_2),
  .a_data_out(a_data_11_1_to_11_2),
  .b_data_out(b_data_11_1_to_12_1),
  .a_addr(a_addr_11_1_NC),
  .b_addr(b_addr_11_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 11_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_2_to_11_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_2_to_12_2;
  wire [`AWIDTH-1:0] a_addr_11_2_NC;
  wire [`AWIDTH-1:0] b_addr_11_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_2_to_11_3;

matmul_4x4_systolic u_matmul_4x4_systolic_11_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_2),
  .a_data(a_data_11_2_NC),
  .b_data(b_data_11_2_NC),
  .a_data_in(a_data_11_1_to_11_2),
  .b_data_in(b_data_10_2_to_11_2),
  .c_data_in(c_data_11_1_to_11_2),
  .c_data_out(c_data_11_2_to_11_3),
  .a_data_out(a_data_11_2_to_11_3),
  .b_data_out(b_data_11_2_to_12_2),
  .a_addr(a_addr_11_2_NC),
  .b_addr(b_addr_11_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 11_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_3_to_11_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_3_to_12_3;
  wire [`AWIDTH-1:0] a_addr_11_3_NC;
  wire [`AWIDTH-1:0] b_addr_11_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_3_to_11_4;

matmul_4x4_systolic u_matmul_4x4_systolic_11_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_3),
  .a_data(a_data_11_3_NC),
  .b_data(b_data_11_3_NC),
  .a_data_in(a_data_11_2_to_11_3),
  .b_data_in(b_data_10_3_to_11_3),
  .c_data_in(c_data_11_2_to_11_3),
  .c_data_out(c_data_11_3_to_11_4),
  .a_data_out(a_data_11_3_to_11_4),
  .b_data_out(b_data_11_3_to_12_3),
  .a_addr(a_addr_11_3_NC),
  .b_addr(b_addr_11_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 11_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_4_to_11_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_4_to_12_4;
  wire [`AWIDTH-1:0] a_addr_11_4_NC;
  wire [`AWIDTH-1:0] b_addr_11_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_4_to_11_5;

matmul_4x4_systolic u_matmul_4x4_systolic_11_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_4),
  .a_data(a_data_11_4_NC),
  .b_data(b_data_11_4_NC),
  .a_data_in(a_data_11_3_to_11_4),
  .b_data_in(b_data_10_4_to_11_4),
  .c_data_in(c_data_11_3_to_11_4),
  .c_data_out(c_data_11_4_to_11_5),
  .a_data_out(a_data_11_4_to_11_5),
  .b_data_out(b_data_11_4_to_12_4),
  .a_addr(a_addr_11_4_NC),
  .b_addr(b_addr_11_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 11_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_5_to_11_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_5_to_12_5;
  wire [`AWIDTH-1:0] a_addr_11_5_NC;
  wire [`AWIDTH-1:0] b_addr_11_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_5_to_11_6;

matmul_4x4_systolic u_matmul_4x4_systolic_11_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_5),
  .a_data(a_data_11_5_NC),
  .b_data(b_data_11_5_NC),
  .a_data_in(a_data_11_4_to_11_5),
  .b_data_in(b_data_10_5_to_11_5),
  .c_data_in(c_data_11_4_to_11_5),
  .c_data_out(c_data_11_5_to_11_6),
  .a_data_out(a_data_11_5_to_11_6),
  .b_data_out(b_data_11_5_to_12_5),
  .a_addr(a_addr_11_5_NC),
  .b_addr(b_addr_11_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 11_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_6_to_11_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_6_to_12_6;
  wire [`AWIDTH-1:0] a_addr_11_6_NC;
  wire [`AWIDTH-1:0] b_addr_11_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_6_to_11_7;

matmul_4x4_systolic u_matmul_4x4_systolic_11_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_6),
  .a_data(a_data_11_6_NC),
  .b_data(b_data_11_6_NC),
  .a_data_in(a_data_11_5_to_11_6),
  .b_data_in(b_data_10_6_to_11_6),
  .c_data_in(c_data_11_5_to_11_6),
  .c_data_out(c_data_11_6_to_11_7),
  .a_data_out(a_data_11_6_to_11_7),
  .b_data_out(b_data_11_6_to_12_6),
  .a_addr(a_addr_11_6_NC),
  .b_addr(b_addr_11_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 11_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_7_to_11_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_7_to_12_7;
  wire [`AWIDTH-1:0] a_addr_11_7_NC;
  wire [`AWIDTH-1:0] b_addr_11_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_7_to_11_8;

matmul_4x4_systolic u_matmul_4x4_systolic_11_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_7),
  .a_data(a_data_11_7_NC),
  .b_data(b_data_11_7_NC),
  .a_data_in(a_data_11_6_to_11_7),
  .b_data_in(b_data_10_7_to_11_7),
  .c_data_in(c_data_11_6_to_11_7),
  .c_data_out(c_data_11_7_to_11_8),
  .a_data_out(a_data_11_7_to_11_8),
  .b_data_out(b_data_11_7_to_12_7),
  .a_addr(a_addr_11_7_NC),
  .b_addr(b_addr_11_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 11_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_8_to_11_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_8_to_12_8;
  wire [`AWIDTH-1:0] a_addr_11_8_NC;
  wire [`AWIDTH-1:0] b_addr_11_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_8_to_11_9;

matmul_4x4_systolic u_matmul_4x4_systolic_11_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_8),
  .a_data(a_data_11_8_NC),
  .b_data(b_data_11_8_NC),
  .a_data_in(a_data_11_7_to_11_8),
  .b_data_in(b_data_10_8_to_11_8),
  .c_data_in(c_data_11_7_to_11_8),
  .c_data_out(c_data_11_8_to_11_9),
  .a_data_out(a_data_11_8_to_11_9),
  .b_data_out(b_data_11_8_to_12_8),
  .a_addr(a_addr_11_8_NC),
  .b_addr(b_addr_11_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 11_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_9_to_11_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_9_to_12_9;
  wire [`AWIDTH-1:0] a_addr_11_9_NC;
  wire [`AWIDTH-1:0] b_addr_11_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_9_to_11_10;

matmul_4x4_systolic u_matmul_4x4_systolic_11_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_9),
  .a_data(a_data_11_9_NC),
  .b_data(b_data_11_9_NC),
  .a_data_in(a_data_11_8_to_11_9),
  .b_data_in(b_data_10_9_to_11_9),
  .c_data_in(c_data_11_8_to_11_9),
  .c_data_out(c_data_11_9_to_11_10),
  .a_data_out(a_data_11_9_to_11_10),
  .b_data_out(b_data_11_9_to_12_9),
  .a_addr(a_addr_11_9_NC),
  .b_addr(b_addr_11_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 11_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_10_to_11_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_10_to_12_10;
  wire [`AWIDTH-1:0] a_addr_11_10_NC;
  wire [`AWIDTH-1:0] b_addr_11_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_10_to_11_11;

matmul_4x4_systolic u_matmul_4x4_systolic_11_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_10),
  .a_data(a_data_11_10_NC),
  .b_data(b_data_11_10_NC),
  .a_data_in(a_data_11_9_to_11_10),
  .b_data_in(b_data_10_10_to_11_10),
  .c_data_in(c_data_11_9_to_11_10),
  .c_data_out(c_data_11_10_to_11_11),
  .a_data_out(a_data_11_10_to_11_11),
  .b_data_out(b_data_11_10_to_12_10),
  .a_addr(a_addr_11_10_NC),
  .b_addr(b_addr_11_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 11_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_11_to_11_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_11_to_12_11;
  wire [`AWIDTH-1:0] a_addr_11_11_NC;
  wire [`AWIDTH-1:0] b_addr_11_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_11_to_11_12;

matmul_4x4_systolic u_matmul_4x4_systolic_11_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_11),
  .a_data(a_data_11_11_NC),
  .b_data(b_data_11_11_NC),
  .a_data_in(a_data_11_10_to_11_11),
  .b_data_in(b_data_10_11_to_11_11),
  .c_data_in(c_data_11_10_to_11_11),
  .c_data_out(c_data_11_11_to_11_12),
  .a_data_out(a_data_11_11_to_11_12),
  .b_data_out(b_data_11_11_to_12_11),
  .a_addr(a_addr_11_11_NC),
  .b_addr(b_addr_11_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 11_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_12_to_11_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_12_to_12_12;
  wire [`AWIDTH-1:0] a_addr_11_12_NC;
  wire [`AWIDTH-1:0] b_addr_11_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_12_to_11_13;

matmul_4x4_systolic u_matmul_4x4_systolic_11_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_12),
  .a_data(a_data_11_12_NC),
  .b_data(b_data_11_12_NC),
  .a_data_in(a_data_11_11_to_11_12),
  .b_data_in(b_data_10_12_to_11_12),
  .c_data_in(c_data_11_11_to_11_12),
  .c_data_out(c_data_11_12_to_11_13),
  .a_data_out(a_data_11_12_to_11_13),
  .b_data_out(b_data_11_12_to_12_12),
  .a_addr(a_addr_11_12_NC),
  .b_addr(b_addr_11_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 11_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_13_to_11_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_13_to_12_13;
  wire [`AWIDTH-1:0] a_addr_11_13_NC;
  wire [`AWIDTH-1:0] b_addr_11_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_13_to_11_14;

matmul_4x4_systolic u_matmul_4x4_systolic_11_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_13),
  .a_data(a_data_11_13_NC),
  .b_data(b_data_11_13_NC),
  .a_data_in(a_data_11_12_to_11_13),
  .b_data_in(b_data_10_13_to_11_13),
  .c_data_in(c_data_11_12_to_11_13),
  .c_data_out(c_data_11_13_to_11_14),
  .a_data_out(a_data_11_13_to_11_14),
  .b_data_out(b_data_11_13_to_12_13),
  .a_addr(a_addr_11_13_NC),
  .b_addr(b_addr_11_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 11_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_14_to_11_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_14_to_12_14;
  wire [`AWIDTH-1:0] a_addr_11_14_NC;
  wire [`AWIDTH-1:0] b_addr_11_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11_14_to_11_15;

matmul_4x4_systolic u_matmul_4x4_systolic_11_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_14),
  .a_data(a_data_11_14_NC),
  .b_data(b_data_11_14_NC),
  .a_data_in(a_data_11_13_to_11_14),
  .b_data_in(b_data_10_14_to_11_14),
  .c_data_in(c_data_11_13_to_11_14),
  .c_data_out(c_data_11_14_to_11_15),
  .a_data_out(a_data_11_14_to_11_15),
  .b_data_out(b_data_11_14_to_12_14),
  .a_addr(a_addr_11_14_NC),
  .b_addr(b_addr_11_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 11_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_15_to_11_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_15_to_12_15;
  wire [`AWIDTH-1:0] a_addr_11_15_NC;
  wire [`AWIDTH-1:0] b_addr_11_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_11_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11_15),
  .a_data(a_data_11_15_NC),
  .b_data(b_data_11_15_NC),
  .a_data_in(a_data_11_14_to_11_15),
  .b_data_in(b_data_10_15_to_11_15),
  .c_data_in(c_data_11_14_to_11_15),
  .c_data_out(c_data_row_11),
  .a_data_out(a_data_11_15_to_11_16),
  .b_data_out(b_data_11_15_to_12_15),
  .a_addr(a_addr_11_15_NC),
  .b_addr(b_addr_11_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd11),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 12_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_0_to_12_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_0_to_13_0;
  wire [`AWIDTH-1:0] b_addr_12_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_12_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_0_to_12_1;

matmul_4x4_systolic u_matmul_4x4_systolic_12_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_0),
  .a_data(a_data_12_0),
  .b_data(b_data_12_0_NC),
  .a_data_in(a_data_in_12_0_NC),
  .b_data_in(b_data_11_0_to_12_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_12_0_to_12_1),
  .a_data_out(a_data_12_0_to_12_1),
  .b_data_out(b_data_12_0_to_13_0),
  .a_addr(a_addr_12_0),
  .b_addr(b_addr_12_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 12_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_1_to_12_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_1_to_13_1;
  wire [`AWIDTH-1:0] a_addr_12_1_NC;
  wire [`AWIDTH-1:0] b_addr_12_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_1_to_12_2;

matmul_4x4_systolic u_matmul_4x4_systolic_12_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_1),
  .a_data(a_data_12_1_NC),
  .b_data(b_data_12_1_NC),
  .a_data_in(a_data_12_0_to_12_1),
  .b_data_in(b_data_11_1_to_12_1),
  .c_data_in(c_data_12_0_to_12_1),
  .c_data_out(c_data_12_1_to_12_2),
  .a_data_out(a_data_12_1_to_12_2),
  .b_data_out(b_data_12_1_to_13_1),
  .a_addr(a_addr_12_1_NC),
  .b_addr(b_addr_12_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 12_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_2_to_12_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_2_to_13_2;
  wire [`AWIDTH-1:0] a_addr_12_2_NC;
  wire [`AWIDTH-1:0] b_addr_12_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_2_to_12_3;

matmul_4x4_systolic u_matmul_4x4_systolic_12_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_2),
  .a_data(a_data_12_2_NC),
  .b_data(b_data_12_2_NC),
  .a_data_in(a_data_12_1_to_12_2),
  .b_data_in(b_data_11_2_to_12_2),
  .c_data_in(c_data_12_1_to_12_2),
  .c_data_out(c_data_12_2_to_12_3),
  .a_data_out(a_data_12_2_to_12_3),
  .b_data_out(b_data_12_2_to_13_2),
  .a_addr(a_addr_12_2_NC),
  .b_addr(b_addr_12_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 12_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_3_to_12_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_3_to_13_3;
  wire [`AWIDTH-1:0] a_addr_12_3_NC;
  wire [`AWIDTH-1:0] b_addr_12_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_3_to_12_4;

matmul_4x4_systolic u_matmul_4x4_systolic_12_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_3),
  .a_data(a_data_12_3_NC),
  .b_data(b_data_12_3_NC),
  .a_data_in(a_data_12_2_to_12_3),
  .b_data_in(b_data_11_3_to_12_3),
  .c_data_in(c_data_12_2_to_12_3),
  .c_data_out(c_data_12_3_to_12_4),
  .a_data_out(a_data_12_3_to_12_4),
  .b_data_out(b_data_12_3_to_13_3),
  .a_addr(a_addr_12_3_NC),
  .b_addr(b_addr_12_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 12_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_4_to_12_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_4_to_13_4;
  wire [`AWIDTH-1:0] a_addr_12_4_NC;
  wire [`AWIDTH-1:0] b_addr_12_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_4_to_12_5;

matmul_4x4_systolic u_matmul_4x4_systolic_12_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_4),
  .a_data(a_data_12_4_NC),
  .b_data(b_data_12_4_NC),
  .a_data_in(a_data_12_3_to_12_4),
  .b_data_in(b_data_11_4_to_12_4),
  .c_data_in(c_data_12_3_to_12_4),
  .c_data_out(c_data_12_4_to_12_5),
  .a_data_out(a_data_12_4_to_12_5),
  .b_data_out(b_data_12_4_to_13_4),
  .a_addr(a_addr_12_4_NC),
  .b_addr(b_addr_12_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 12_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_5_to_12_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_5_to_13_5;
  wire [`AWIDTH-1:0] a_addr_12_5_NC;
  wire [`AWIDTH-1:0] b_addr_12_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_5_to_12_6;

matmul_4x4_systolic u_matmul_4x4_systolic_12_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_5),
  .a_data(a_data_12_5_NC),
  .b_data(b_data_12_5_NC),
  .a_data_in(a_data_12_4_to_12_5),
  .b_data_in(b_data_11_5_to_12_5),
  .c_data_in(c_data_12_4_to_12_5),
  .c_data_out(c_data_12_5_to_12_6),
  .a_data_out(a_data_12_5_to_12_6),
  .b_data_out(b_data_12_5_to_13_5),
  .a_addr(a_addr_12_5_NC),
  .b_addr(b_addr_12_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 12_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_6_to_12_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_6_to_13_6;
  wire [`AWIDTH-1:0] a_addr_12_6_NC;
  wire [`AWIDTH-1:0] b_addr_12_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_6_to_12_7;

matmul_4x4_systolic u_matmul_4x4_systolic_12_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_6),
  .a_data(a_data_12_6_NC),
  .b_data(b_data_12_6_NC),
  .a_data_in(a_data_12_5_to_12_6),
  .b_data_in(b_data_11_6_to_12_6),
  .c_data_in(c_data_12_5_to_12_6),
  .c_data_out(c_data_12_6_to_12_7),
  .a_data_out(a_data_12_6_to_12_7),
  .b_data_out(b_data_12_6_to_13_6),
  .a_addr(a_addr_12_6_NC),
  .b_addr(b_addr_12_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 12_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_7_to_12_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_7_to_13_7;
  wire [`AWIDTH-1:0] a_addr_12_7_NC;
  wire [`AWIDTH-1:0] b_addr_12_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_7_to_12_8;

matmul_4x4_systolic u_matmul_4x4_systolic_12_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_7),
  .a_data(a_data_12_7_NC),
  .b_data(b_data_12_7_NC),
  .a_data_in(a_data_12_6_to_12_7),
  .b_data_in(b_data_11_7_to_12_7),
  .c_data_in(c_data_12_6_to_12_7),
  .c_data_out(c_data_12_7_to_12_8),
  .a_data_out(a_data_12_7_to_12_8),
  .b_data_out(b_data_12_7_to_13_7),
  .a_addr(a_addr_12_7_NC),
  .b_addr(b_addr_12_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 12_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_8_to_12_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_8_to_13_8;
  wire [`AWIDTH-1:0] a_addr_12_8_NC;
  wire [`AWIDTH-1:0] b_addr_12_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_8_to_12_9;

matmul_4x4_systolic u_matmul_4x4_systolic_12_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_8),
  .a_data(a_data_12_8_NC),
  .b_data(b_data_12_8_NC),
  .a_data_in(a_data_12_7_to_12_8),
  .b_data_in(b_data_11_8_to_12_8),
  .c_data_in(c_data_12_7_to_12_8),
  .c_data_out(c_data_12_8_to_12_9),
  .a_data_out(a_data_12_8_to_12_9),
  .b_data_out(b_data_12_8_to_13_8),
  .a_addr(a_addr_12_8_NC),
  .b_addr(b_addr_12_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 12_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_9_to_12_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_9_to_13_9;
  wire [`AWIDTH-1:0] a_addr_12_9_NC;
  wire [`AWIDTH-1:0] b_addr_12_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_9_to_12_10;

matmul_4x4_systolic u_matmul_4x4_systolic_12_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_9),
  .a_data(a_data_12_9_NC),
  .b_data(b_data_12_9_NC),
  .a_data_in(a_data_12_8_to_12_9),
  .b_data_in(b_data_11_9_to_12_9),
  .c_data_in(c_data_12_8_to_12_9),
  .c_data_out(c_data_12_9_to_12_10),
  .a_data_out(a_data_12_9_to_12_10),
  .b_data_out(b_data_12_9_to_13_9),
  .a_addr(a_addr_12_9_NC),
  .b_addr(b_addr_12_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 12_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_10_to_12_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_10_to_13_10;
  wire [`AWIDTH-1:0] a_addr_12_10_NC;
  wire [`AWIDTH-1:0] b_addr_12_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_10_to_12_11;

matmul_4x4_systolic u_matmul_4x4_systolic_12_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_10),
  .a_data(a_data_12_10_NC),
  .b_data(b_data_12_10_NC),
  .a_data_in(a_data_12_9_to_12_10),
  .b_data_in(b_data_11_10_to_12_10),
  .c_data_in(c_data_12_9_to_12_10),
  .c_data_out(c_data_12_10_to_12_11),
  .a_data_out(a_data_12_10_to_12_11),
  .b_data_out(b_data_12_10_to_13_10),
  .a_addr(a_addr_12_10_NC),
  .b_addr(b_addr_12_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 12_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_11_to_12_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_11_to_13_11;
  wire [`AWIDTH-1:0] a_addr_12_11_NC;
  wire [`AWIDTH-1:0] b_addr_12_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_11_to_12_12;

matmul_4x4_systolic u_matmul_4x4_systolic_12_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_11),
  .a_data(a_data_12_11_NC),
  .b_data(b_data_12_11_NC),
  .a_data_in(a_data_12_10_to_12_11),
  .b_data_in(b_data_11_11_to_12_11),
  .c_data_in(c_data_12_10_to_12_11),
  .c_data_out(c_data_12_11_to_12_12),
  .a_data_out(a_data_12_11_to_12_12),
  .b_data_out(b_data_12_11_to_13_11),
  .a_addr(a_addr_12_11_NC),
  .b_addr(b_addr_12_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 12_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_12_to_12_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_12_to_13_12;
  wire [`AWIDTH-1:0] a_addr_12_12_NC;
  wire [`AWIDTH-1:0] b_addr_12_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_12_to_12_13;

matmul_4x4_systolic u_matmul_4x4_systolic_12_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_12),
  .a_data(a_data_12_12_NC),
  .b_data(b_data_12_12_NC),
  .a_data_in(a_data_12_11_to_12_12),
  .b_data_in(b_data_11_12_to_12_12),
  .c_data_in(c_data_12_11_to_12_12),
  .c_data_out(c_data_12_12_to_12_13),
  .a_data_out(a_data_12_12_to_12_13),
  .b_data_out(b_data_12_12_to_13_12),
  .a_addr(a_addr_12_12_NC),
  .b_addr(b_addr_12_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 12_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_13_to_12_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_13_to_13_13;
  wire [`AWIDTH-1:0] a_addr_12_13_NC;
  wire [`AWIDTH-1:0] b_addr_12_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_13_to_12_14;

matmul_4x4_systolic u_matmul_4x4_systolic_12_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_13),
  .a_data(a_data_12_13_NC),
  .b_data(b_data_12_13_NC),
  .a_data_in(a_data_12_12_to_12_13),
  .b_data_in(b_data_11_13_to_12_13),
  .c_data_in(c_data_12_12_to_12_13),
  .c_data_out(c_data_12_13_to_12_14),
  .a_data_out(a_data_12_13_to_12_14),
  .b_data_out(b_data_12_13_to_13_13),
  .a_addr(a_addr_12_13_NC),
  .b_addr(b_addr_12_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 12_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_14_to_12_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_14_to_13_14;
  wire [`AWIDTH-1:0] a_addr_12_14_NC;
  wire [`AWIDTH-1:0] b_addr_12_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12_14_to_12_15;

matmul_4x4_systolic u_matmul_4x4_systolic_12_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_14),
  .a_data(a_data_12_14_NC),
  .b_data(b_data_12_14_NC),
  .a_data_in(a_data_12_13_to_12_14),
  .b_data_in(b_data_11_14_to_12_14),
  .c_data_in(c_data_12_13_to_12_14),
  .c_data_out(c_data_12_14_to_12_15),
  .a_data_out(a_data_12_14_to_12_15),
  .b_data_out(b_data_12_14_to_13_14),
  .a_addr(a_addr_12_14_NC),
  .b_addr(b_addr_12_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 12_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_15_to_12_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_15_to_13_15;
  wire [`AWIDTH-1:0] a_addr_12_15_NC;
  wire [`AWIDTH-1:0] b_addr_12_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_12_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12_15),
  .a_data(a_data_12_15_NC),
  .b_data(b_data_12_15_NC),
  .a_data_in(a_data_12_14_to_12_15),
  .b_data_in(b_data_11_15_to_12_15),
  .c_data_in(c_data_12_14_to_12_15),
  .c_data_out(c_data_row_12),
  .a_data_out(a_data_12_15_to_12_16),
  .b_data_out(b_data_12_15_to_13_15),
  .a_addr(a_addr_12_15_NC),
  .b_addr(b_addr_12_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd12),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 13_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_0_to_13_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_0_to_14_0;
  wire [`AWIDTH-1:0] b_addr_13_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_13_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_0_to_13_1;

matmul_4x4_systolic u_matmul_4x4_systolic_13_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_0),
  .a_data(a_data_13_0),
  .b_data(b_data_13_0_NC),
  .a_data_in(a_data_in_13_0_NC),
  .b_data_in(b_data_12_0_to_13_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_13_0_to_13_1),
  .a_data_out(a_data_13_0_to_13_1),
  .b_data_out(b_data_13_0_to_14_0),
  .a_addr(a_addr_13_0),
  .b_addr(b_addr_13_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 13_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_1_to_13_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_1_to_14_1;
  wire [`AWIDTH-1:0] a_addr_13_1_NC;
  wire [`AWIDTH-1:0] b_addr_13_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_1_to_13_2;

matmul_4x4_systolic u_matmul_4x4_systolic_13_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_1),
  .a_data(a_data_13_1_NC),
  .b_data(b_data_13_1_NC),
  .a_data_in(a_data_13_0_to_13_1),
  .b_data_in(b_data_12_1_to_13_1),
  .c_data_in(c_data_13_0_to_13_1),
  .c_data_out(c_data_13_1_to_13_2),
  .a_data_out(a_data_13_1_to_13_2),
  .b_data_out(b_data_13_1_to_14_1),
  .a_addr(a_addr_13_1_NC),
  .b_addr(b_addr_13_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 13_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_2_to_13_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_2_to_14_2;
  wire [`AWIDTH-1:0] a_addr_13_2_NC;
  wire [`AWIDTH-1:0] b_addr_13_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_2_to_13_3;

matmul_4x4_systolic u_matmul_4x4_systolic_13_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_2),
  .a_data(a_data_13_2_NC),
  .b_data(b_data_13_2_NC),
  .a_data_in(a_data_13_1_to_13_2),
  .b_data_in(b_data_12_2_to_13_2),
  .c_data_in(c_data_13_1_to_13_2),
  .c_data_out(c_data_13_2_to_13_3),
  .a_data_out(a_data_13_2_to_13_3),
  .b_data_out(b_data_13_2_to_14_2),
  .a_addr(a_addr_13_2_NC),
  .b_addr(b_addr_13_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 13_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_3_to_13_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_3_to_14_3;
  wire [`AWIDTH-1:0] a_addr_13_3_NC;
  wire [`AWIDTH-1:0] b_addr_13_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_3_to_13_4;

matmul_4x4_systolic u_matmul_4x4_systolic_13_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_3),
  .a_data(a_data_13_3_NC),
  .b_data(b_data_13_3_NC),
  .a_data_in(a_data_13_2_to_13_3),
  .b_data_in(b_data_12_3_to_13_3),
  .c_data_in(c_data_13_2_to_13_3),
  .c_data_out(c_data_13_3_to_13_4),
  .a_data_out(a_data_13_3_to_13_4),
  .b_data_out(b_data_13_3_to_14_3),
  .a_addr(a_addr_13_3_NC),
  .b_addr(b_addr_13_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 13_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_4_to_13_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_4_to_14_4;
  wire [`AWIDTH-1:0] a_addr_13_4_NC;
  wire [`AWIDTH-1:0] b_addr_13_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_4_to_13_5;

matmul_4x4_systolic u_matmul_4x4_systolic_13_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_4),
  .a_data(a_data_13_4_NC),
  .b_data(b_data_13_4_NC),
  .a_data_in(a_data_13_3_to_13_4),
  .b_data_in(b_data_12_4_to_13_4),
  .c_data_in(c_data_13_3_to_13_4),
  .c_data_out(c_data_13_4_to_13_5),
  .a_data_out(a_data_13_4_to_13_5),
  .b_data_out(b_data_13_4_to_14_4),
  .a_addr(a_addr_13_4_NC),
  .b_addr(b_addr_13_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 13_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_5_to_13_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_5_to_14_5;
  wire [`AWIDTH-1:0] a_addr_13_5_NC;
  wire [`AWIDTH-1:0] b_addr_13_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_5_to_13_6;

matmul_4x4_systolic u_matmul_4x4_systolic_13_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_5),
  .a_data(a_data_13_5_NC),
  .b_data(b_data_13_5_NC),
  .a_data_in(a_data_13_4_to_13_5),
  .b_data_in(b_data_12_5_to_13_5),
  .c_data_in(c_data_13_4_to_13_5),
  .c_data_out(c_data_13_5_to_13_6),
  .a_data_out(a_data_13_5_to_13_6),
  .b_data_out(b_data_13_5_to_14_5),
  .a_addr(a_addr_13_5_NC),
  .b_addr(b_addr_13_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 13_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_6_to_13_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_6_to_14_6;
  wire [`AWIDTH-1:0] a_addr_13_6_NC;
  wire [`AWIDTH-1:0] b_addr_13_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_6_to_13_7;

matmul_4x4_systolic u_matmul_4x4_systolic_13_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_6),
  .a_data(a_data_13_6_NC),
  .b_data(b_data_13_6_NC),
  .a_data_in(a_data_13_5_to_13_6),
  .b_data_in(b_data_12_6_to_13_6),
  .c_data_in(c_data_13_5_to_13_6),
  .c_data_out(c_data_13_6_to_13_7),
  .a_data_out(a_data_13_6_to_13_7),
  .b_data_out(b_data_13_6_to_14_6),
  .a_addr(a_addr_13_6_NC),
  .b_addr(b_addr_13_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 13_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_7_to_13_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_7_to_14_7;
  wire [`AWIDTH-1:0] a_addr_13_7_NC;
  wire [`AWIDTH-1:0] b_addr_13_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_7_to_13_8;

matmul_4x4_systolic u_matmul_4x4_systolic_13_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_7),
  .a_data(a_data_13_7_NC),
  .b_data(b_data_13_7_NC),
  .a_data_in(a_data_13_6_to_13_7),
  .b_data_in(b_data_12_7_to_13_7),
  .c_data_in(c_data_13_6_to_13_7),
  .c_data_out(c_data_13_7_to_13_8),
  .a_data_out(a_data_13_7_to_13_8),
  .b_data_out(b_data_13_7_to_14_7),
  .a_addr(a_addr_13_7_NC),
  .b_addr(b_addr_13_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 13_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_8_to_13_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_8_to_14_8;
  wire [`AWIDTH-1:0] a_addr_13_8_NC;
  wire [`AWIDTH-1:0] b_addr_13_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_8_to_13_9;

matmul_4x4_systolic u_matmul_4x4_systolic_13_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_8),
  .a_data(a_data_13_8_NC),
  .b_data(b_data_13_8_NC),
  .a_data_in(a_data_13_7_to_13_8),
  .b_data_in(b_data_12_8_to_13_8),
  .c_data_in(c_data_13_7_to_13_8),
  .c_data_out(c_data_13_8_to_13_9),
  .a_data_out(a_data_13_8_to_13_9),
  .b_data_out(b_data_13_8_to_14_8),
  .a_addr(a_addr_13_8_NC),
  .b_addr(b_addr_13_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 13_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_9_to_13_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_9_to_14_9;
  wire [`AWIDTH-1:0] a_addr_13_9_NC;
  wire [`AWIDTH-1:0] b_addr_13_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_9_to_13_10;

matmul_4x4_systolic u_matmul_4x4_systolic_13_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_9),
  .a_data(a_data_13_9_NC),
  .b_data(b_data_13_9_NC),
  .a_data_in(a_data_13_8_to_13_9),
  .b_data_in(b_data_12_9_to_13_9),
  .c_data_in(c_data_13_8_to_13_9),
  .c_data_out(c_data_13_9_to_13_10),
  .a_data_out(a_data_13_9_to_13_10),
  .b_data_out(b_data_13_9_to_14_9),
  .a_addr(a_addr_13_9_NC),
  .b_addr(b_addr_13_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 13_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_10_to_13_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_10_to_14_10;
  wire [`AWIDTH-1:0] a_addr_13_10_NC;
  wire [`AWIDTH-1:0] b_addr_13_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_10_to_13_11;

matmul_4x4_systolic u_matmul_4x4_systolic_13_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_10),
  .a_data(a_data_13_10_NC),
  .b_data(b_data_13_10_NC),
  .a_data_in(a_data_13_9_to_13_10),
  .b_data_in(b_data_12_10_to_13_10),
  .c_data_in(c_data_13_9_to_13_10),
  .c_data_out(c_data_13_10_to_13_11),
  .a_data_out(a_data_13_10_to_13_11),
  .b_data_out(b_data_13_10_to_14_10),
  .a_addr(a_addr_13_10_NC),
  .b_addr(b_addr_13_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 13_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_11_to_13_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_11_to_14_11;
  wire [`AWIDTH-1:0] a_addr_13_11_NC;
  wire [`AWIDTH-1:0] b_addr_13_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_11_to_13_12;

matmul_4x4_systolic u_matmul_4x4_systolic_13_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_11),
  .a_data(a_data_13_11_NC),
  .b_data(b_data_13_11_NC),
  .a_data_in(a_data_13_10_to_13_11),
  .b_data_in(b_data_12_11_to_13_11),
  .c_data_in(c_data_13_10_to_13_11),
  .c_data_out(c_data_13_11_to_13_12),
  .a_data_out(a_data_13_11_to_13_12),
  .b_data_out(b_data_13_11_to_14_11),
  .a_addr(a_addr_13_11_NC),
  .b_addr(b_addr_13_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 13_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_12_to_13_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_12_to_14_12;
  wire [`AWIDTH-1:0] a_addr_13_12_NC;
  wire [`AWIDTH-1:0] b_addr_13_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_12_to_13_13;

matmul_4x4_systolic u_matmul_4x4_systolic_13_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_12),
  .a_data(a_data_13_12_NC),
  .b_data(b_data_13_12_NC),
  .a_data_in(a_data_13_11_to_13_12),
  .b_data_in(b_data_12_12_to_13_12),
  .c_data_in(c_data_13_11_to_13_12),
  .c_data_out(c_data_13_12_to_13_13),
  .a_data_out(a_data_13_12_to_13_13),
  .b_data_out(b_data_13_12_to_14_12),
  .a_addr(a_addr_13_12_NC),
  .b_addr(b_addr_13_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 13_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_13_to_13_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_13_to_14_13;
  wire [`AWIDTH-1:0] a_addr_13_13_NC;
  wire [`AWIDTH-1:0] b_addr_13_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_13_to_13_14;

matmul_4x4_systolic u_matmul_4x4_systolic_13_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_13),
  .a_data(a_data_13_13_NC),
  .b_data(b_data_13_13_NC),
  .a_data_in(a_data_13_12_to_13_13),
  .b_data_in(b_data_12_13_to_13_13),
  .c_data_in(c_data_13_12_to_13_13),
  .c_data_out(c_data_13_13_to_13_14),
  .a_data_out(a_data_13_13_to_13_14),
  .b_data_out(b_data_13_13_to_14_13),
  .a_addr(a_addr_13_13_NC),
  .b_addr(b_addr_13_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 13_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_14_to_13_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_14_to_14_14;
  wire [`AWIDTH-1:0] a_addr_13_14_NC;
  wire [`AWIDTH-1:0] b_addr_13_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13_14_to_13_15;

matmul_4x4_systolic u_matmul_4x4_systolic_13_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_14),
  .a_data(a_data_13_14_NC),
  .b_data(b_data_13_14_NC),
  .a_data_in(a_data_13_13_to_13_14),
  .b_data_in(b_data_12_14_to_13_14),
  .c_data_in(c_data_13_13_to_13_14),
  .c_data_out(c_data_13_14_to_13_15),
  .a_data_out(a_data_13_14_to_13_15),
  .b_data_out(b_data_13_14_to_14_14),
  .a_addr(a_addr_13_14_NC),
  .b_addr(b_addr_13_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 13_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_15_to_13_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_15_to_14_15;
  wire [`AWIDTH-1:0] a_addr_13_15_NC;
  wire [`AWIDTH-1:0] b_addr_13_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_13_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13_15),
  .a_data(a_data_13_15_NC),
  .b_data(b_data_13_15_NC),
  .a_data_in(a_data_13_14_to_13_15),
  .b_data_in(b_data_12_15_to_13_15),
  .c_data_in(c_data_13_14_to_13_15),
  .c_data_out(c_data_row_13),
  .a_data_out(a_data_13_15_to_13_16),
  .b_data_out(b_data_13_15_to_14_15),
  .a_addr(a_addr_13_15_NC),
  .b_addr(b_addr_13_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd13),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 14_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_0_to_14_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_0_to_15_0;
  wire [`AWIDTH-1:0] b_addr_14_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_14_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_0_to_14_1;

matmul_4x4_systolic u_matmul_4x4_systolic_14_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_0),
  .a_data(a_data_14_0),
  .b_data(b_data_14_0_NC),
  .a_data_in(a_data_in_14_0_NC),
  .b_data_in(b_data_13_0_to_14_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_14_0_to_14_1),
  .a_data_out(a_data_14_0_to_14_1),
  .b_data_out(b_data_14_0_to_15_0),
  .a_addr(a_addr_14_0),
  .b_addr(b_addr_14_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 14_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_1_to_14_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_1_to_15_1;
  wire [`AWIDTH-1:0] a_addr_14_1_NC;
  wire [`AWIDTH-1:0] b_addr_14_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_1_to_14_2;

matmul_4x4_systolic u_matmul_4x4_systolic_14_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_1),
  .a_data(a_data_14_1_NC),
  .b_data(b_data_14_1_NC),
  .a_data_in(a_data_14_0_to_14_1),
  .b_data_in(b_data_13_1_to_14_1),
  .c_data_in(c_data_14_0_to_14_1),
  .c_data_out(c_data_14_1_to_14_2),
  .a_data_out(a_data_14_1_to_14_2),
  .b_data_out(b_data_14_1_to_15_1),
  .a_addr(a_addr_14_1_NC),
  .b_addr(b_addr_14_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 14_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_2_to_14_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_2_to_15_2;
  wire [`AWIDTH-1:0] a_addr_14_2_NC;
  wire [`AWIDTH-1:0] b_addr_14_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_2_to_14_3;

matmul_4x4_systolic u_matmul_4x4_systolic_14_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_2),
  .a_data(a_data_14_2_NC),
  .b_data(b_data_14_2_NC),
  .a_data_in(a_data_14_1_to_14_2),
  .b_data_in(b_data_13_2_to_14_2),
  .c_data_in(c_data_14_1_to_14_2),
  .c_data_out(c_data_14_2_to_14_3),
  .a_data_out(a_data_14_2_to_14_3),
  .b_data_out(b_data_14_2_to_15_2),
  .a_addr(a_addr_14_2_NC),
  .b_addr(b_addr_14_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 14_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_3_to_14_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_3_to_15_3;
  wire [`AWIDTH-1:0] a_addr_14_3_NC;
  wire [`AWIDTH-1:0] b_addr_14_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_3_to_14_4;

matmul_4x4_systolic u_matmul_4x4_systolic_14_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_3),
  .a_data(a_data_14_3_NC),
  .b_data(b_data_14_3_NC),
  .a_data_in(a_data_14_2_to_14_3),
  .b_data_in(b_data_13_3_to_14_3),
  .c_data_in(c_data_14_2_to_14_3),
  .c_data_out(c_data_14_3_to_14_4),
  .a_data_out(a_data_14_3_to_14_4),
  .b_data_out(b_data_14_3_to_15_3),
  .a_addr(a_addr_14_3_NC),
  .b_addr(b_addr_14_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 14_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_4_to_14_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_4_to_15_4;
  wire [`AWIDTH-1:0] a_addr_14_4_NC;
  wire [`AWIDTH-1:0] b_addr_14_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_4_to_14_5;

matmul_4x4_systolic u_matmul_4x4_systolic_14_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_4),
  .a_data(a_data_14_4_NC),
  .b_data(b_data_14_4_NC),
  .a_data_in(a_data_14_3_to_14_4),
  .b_data_in(b_data_13_4_to_14_4),
  .c_data_in(c_data_14_3_to_14_4),
  .c_data_out(c_data_14_4_to_14_5),
  .a_data_out(a_data_14_4_to_14_5),
  .b_data_out(b_data_14_4_to_15_4),
  .a_addr(a_addr_14_4_NC),
  .b_addr(b_addr_14_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 14_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_5_to_14_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_5_to_15_5;
  wire [`AWIDTH-1:0] a_addr_14_5_NC;
  wire [`AWIDTH-1:0] b_addr_14_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_5_to_14_6;

matmul_4x4_systolic u_matmul_4x4_systolic_14_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_5),
  .a_data(a_data_14_5_NC),
  .b_data(b_data_14_5_NC),
  .a_data_in(a_data_14_4_to_14_5),
  .b_data_in(b_data_13_5_to_14_5),
  .c_data_in(c_data_14_4_to_14_5),
  .c_data_out(c_data_14_5_to_14_6),
  .a_data_out(a_data_14_5_to_14_6),
  .b_data_out(b_data_14_5_to_15_5),
  .a_addr(a_addr_14_5_NC),
  .b_addr(b_addr_14_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 14_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_6_to_14_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_6_to_15_6;
  wire [`AWIDTH-1:0] a_addr_14_6_NC;
  wire [`AWIDTH-1:0] b_addr_14_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_6_to_14_7;

matmul_4x4_systolic u_matmul_4x4_systolic_14_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_6),
  .a_data(a_data_14_6_NC),
  .b_data(b_data_14_6_NC),
  .a_data_in(a_data_14_5_to_14_6),
  .b_data_in(b_data_13_6_to_14_6),
  .c_data_in(c_data_14_5_to_14_6),
  .c_data_out(c_data_14_6_to_14_7),
  .a_data_out(a_data_14_6_to_14_7),
  .b_data_out(b_data_14_6_to_15_6),
  .a_addr(a_addr_14_6_NC),
  .b_addr(b_addr_14_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 14_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_7_to_14_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_7_to_15_7;
  wire [`AWIDTH-1:0] a_addr_14_7_NC;
  wire [`AWIDTH-1:0] b_addr_14_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_7_to_14_8;

matmul_4x4_systolic u_matmul_4x4_systolic_14_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_7),
  .a_data(a_data_14_7_NC),
  .b_data(b_data_14_7_NC),
  .a_data_in(a_data_14_6_to_14_7),
  .b_data_in(b_data_13_7_to_14_7),
  .c_data_in(c_data_14_6_to_14_7),
  .c_data_out(c_data_14_7_to_14_8),
  .a_data_out(a_data_14_7_to_14_8),
  .b_data_out(b_data_14_7_to_15_7),
  .a_addr(a_addr_14_7_NC),
  .b_addr(b_addr_14_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 14_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_8_to_14_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_8_to_15_8;
  wire [`AWIDTH-1:0] a_addr_14_8_NC;
  wire [`AWIDTH-1:0] b_addr_14_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_8_to_14_9;

matmul_4x4_systolic u_matmul_4x4_systolic_14_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_8),
  .a_data(a_data_14_8_NC),
  .b_data(b_data_14_8_NC),
  .a_data_in(a_data_14_7_to_14_8),
  .b_data_in(b_data_13_8_to_14_8),
  .c_data_in(c_data_14_7_to_14_8),
  .c_data_out(c_data_14_8_to_14_9),
  .a_data_out(a_data_14_8_to_14_9),
  .b_data_out(b_data_14_8_to_15_8),
  .a_addr(a_addr_14_8_NC),
  .b_addr(b_addr_14_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 14_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_9_to_14_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_9_to_15_9;
  wire [`AWIDTH-1:0] a_addr_14_9_NC;
  wire [`AWIDTH-1:0] b_addr_14_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_9_to_14_10;

matmul_4x4_systolic u_matmul_4x4_systolic_14_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_9),
  .a_data(a_data_14_9_NC),
  .b_data(b_data_14_9_NC),
  .a_data_in(a_data_14_8_to_14_9),
  .b_data_in(b_data_13_9_to_14_9),
  .c_data_in(c_data_14_8_to_14_9),
  .c_data_out(c_data_14_9_to_14_10),
  .a_data_out(a_data_14_9_to_14_10),
  .b_data_out(b_data_14_9_to_15_9),
  .a_addr(a_addr_14_9_NC),
  .b_addr(b_addr_14_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 14_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_10_to_14_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_10_to_15_10;
  wire [`AWIDTH-1:0] a_addr_14_10_NC;
  wire [`AWIDTH-1:0] b_addr_14_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_10_to_14_11;

matmul_4x4_systolic u_matmul_4x4_systolic_14_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_10),
  .a_data(a_data_14_10_NC),
  .b_data(b_data_14_10_NC),
  .a_data_in(a_data_14_9_to_14_10),
  .b_data_in(b_data_13_10_to_14_10),
  .c_data_in(c_data_14_9_to_14_10),
  .c_data_out(c_data_14_10_to_14_11),
  .a_data_out(a_data_14_10_to_14_11),
  .b_data_out(b_data_14_10_to_15_10),
  .a_addr(a_addr_14_10_NC),
  .b_addr(b_addr_14_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 14_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_11_to_14_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_11_to_15_11;
  wire [`AWIDTH-1:0] a_addr_14_11_NC;
  wire [`AWIDTH-1:0] b_addr_14_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_11_to_14_12;

matmul_4x4_systolic u_matmul_4x4_systolic_14_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_11),
  .a_data(a_data_14_11_NC),
  .b_data(b_data_14_11_NC),
  .a_data_in(a_data_14_10_to_14_11),
  .b_data_in(b_data_13_11_to_14_11),
  .c_data_in(c_data_14_10_to_14_11),
  .c_data_out(c_data_14_11_to_14_12),
  .a_data_out(a_data_14_11_to_14_12),
  .b_data_out(b_data_14_11_to_15_11),
  .a_addr(a_addr_14_11_NC),
  .b_addr(b_addr_14_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 14_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_12_to_14_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_12_to_15_12;
  wire [`AWIDTH-1:0] a_addr_14_12_NC;
  wire [`AWIDTH-1:0] b_addr_14_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_12_to_14_13;

matmul_4x4_systolic u_matmul_4x4_systolic_14_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_12),
  .a_data(a_data_14_12_NC),
  .b_data(b_data_14_12_NC),
  .a_data_in(a_data_14_11_to_14_12),
  .b_data_in(b_data_13_12_to_14_12),
  .c_data_in(c_data_14_11_to_14_12),
  .c_data_out(c_data_14_12_to_14_13),
  .a_data_out(a_data_14_12_to_14_13),
  .b_data_out(b_data_14_12_to_15_12),
  .a_addr(a_addr_14_12_NC),
  .b_addr(b_addr_14_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 14_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_13_to_14_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_13_to_15_13;
  wire [`AWIDTH-1:0] a_addr_14_13_NC;
  wire [`AWIDTH-1:0] b_addr_14_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_13_to_14_14;

matmul_4x4_systolic u_matmul_4x4_systolic_14_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_13),
  .a_data(a_data_14_13_NC),
  .b_data(b_data_14_13_NC),
  .a_data_in(a_data_14_12_to_14_13),
  .b_data_in(b_data_13_13_to_14_13),
  .c_data_in(c_data_14_12_to_14_13),
  .c_data_out(c_data_14_13_to_14_14),
  .a_data_out(a_data_14_13_to_14_14),
  .b_data_out(b_data_14_13_to_15_13),
  .a_addr(a_addr_14_13_NC),
  .b_addr(b_addr_14_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 14_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_14_to_14_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_14_to_15_14;
  wire [`AWIDTH-1:0] a_addr_14_14_NC;
  wire [`AWIDTH-1:0] b_addr_14_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14_14_to_14_15;

matmul_4x4_systolic u_matmul_4x4_systolic_14_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_14),
  .a_data(a_data_14_14_NC),
  .b_data(b_data_14_14_NC),
  .a_data_in(a_data_14_13_to_14_14),
  .b_data_in(b_data_13_14_to_14_14),
  .c_data_in(c_data_14_13_to_14_14),
  .c_data_out(c_data_14_14_to_14_15),
  .a_data_out(a_data_14_14_to_14_15),
  .b_data_out(b_data_14_14_to_15_14),
  .a_addr(a_addr_14_14_NC),
  .b_addr(b_addr_14_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 14_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_15_to_14_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_15_to_15_15;
  wire [`AWIDTH-1:0] a_addr_14_15_NC;
  wire [`AWIDTH-1:0] b_addr_14_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_14_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14_15),
  .a_data(a_data_14_15_NC),
  .b_data(b_data_14_15_NC),
  .a_data_in(a_data_14_14_to_14_15),
  .b_data_in(b_data_13_15_to_14_15),
  .c_data_in(c_data_14_14_to_14_15),
  .c_data_out(c_data_row_14),
  .a_data_out(a_data_14_15_to_14_16),
  .b_data_out(b_data_14_15_to_15_15),
  .a_addr(a_addr_14_15_NC),
  .b_addr(b_addr_14_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd14),
  .b_loc(8'd15)
);

  /////////////////////////////////////////////////
  // Matmul 15_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_0_to_15_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_0_to_16_0;
  wire [`AWIDTH-1:0] b_addr_15_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_15_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_0_to_15_1;

matmul_4x4_systolic u_matmul_4x4_systolic_15_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_0),
  .a_data(a_data_15_0),
  .b_data(b_data_15_0_NC),
  .a_data_in(a_data_in_15_0_NC),
  .b_data_in(b_data_14_0_to_15_0),
  .c_data_in({`BB_MAT_MUL_SIZE*`DWIDTH{1'b0}}),
  .c_data_out(c_data_15_0_to_15_1),
  .a_data_out(a_data_15_0_to_15_1),
  .b_data_out(b_data_15_0_to_16_0),
  .a_addr(a_addr_15_0),
  .b_addr(b_addr_15_0_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 15_1
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_1_to_15_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_1_to_16_1;
  wire [`AWIDTH-1:0] a_addr_15_1_NC;
  wire [`AWIDTH-1:0] b_addr_15_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_1_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_1_to_15_2;

matmul_4x4_systolic u_matmul_4x4_systolic_15_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_1),
  .a_data(a_data_15_1_NC),
  .b_data(b_data_15_1_NC),
  .a_data_in(a_data_15_0_to_15_1),
  .b_data_in(b_data_14_1_to_15_1),
  .c_data_in(c_data_15_0_to_15_1),
  .c_data_out(c_data_15_1_to_15_2),
  .a_data_out(a_data_15_1_to_15_2),
  .b_data_out(b_data_15_1_to_16_1),
  .a_addr(a_addr_15_1_NC),
  .b_addr(b_addr_15_1_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 15_2
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_2_to_15_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_2_to_16_2;
  wire [`AWIDTH-1:0] a_addr_15_2_NC;
  wire [`AWIDTH-1:0] b_addr_15_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_2_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_2_to_15_3;

matmul_4x4_systolic u_matmul_4x4_systolic_15_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_2),
  .a_data(a_data_15_2_NC),
  .b_data(b_data_15_2_NC),
  .a_data_in(a_data_15_1_to_15_2),
  .b_data_in(b_data_14_2_to_15_2),
  .c_data_in(c_data_15_1_to_15_2),
  .c_data_out(c_data_15_2_to_15_3),
  .a_data_out(a_data_15_2_to_15_3),
  .b_data_out(b_data_15_2_to_16_2),
  .a_addr(a_addr_15_2_NC),
  .b_addr(b_addr_15_2_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 15_3
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_3_to_15_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_3_to_16_3;
  wire [`AWIDTH-1:0] a_addr_15_3_NC;
  wire [`AWIDTH-1:0] b_addr_15_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_3_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_3_to_15_4;

matmul_4x4_systolic u_matmul_4x4_systolic_15_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_3),
  .a_data(a_data_15_3_NC),
  .b_data(b_data_15_3_NC),
  .a_data_in(a_data_15_2_to_15_3),
  .b_data_in(b_data_14_3_to_15_3),
  .c_data_in(c_data_15_2_to_15_3),
  .c_data_out(c_data_15_3_to_15_4),
  .a_data_out(a_data_15_3_to_15_4),
  .b_data_out(b_data_15_3_to_16_3),
  .a_addr(a_addr_15_3_NC),
  .b_addr(b_addr_15_3_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 15_4
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_4_to_15_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_4_to_16_4;
  wire [`AWIDTH-1:0] a_addr_15_4_NC;
  wire [`AWIDTH-1:0] b_addr_15_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_4_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_4_to_15_5;

matmul_4x4_systolic u_matmul_4x4_systolic_15_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_4),
  .a_data(a_data_15_4_NC),
  .b_data(b_data_15_4_NC),
  .a_data_in(a_data_15_3_to_15_4),
  .b_data_in(b_data_14_4_to_15_4),
  .c_data_in(c_data_15_3_to_15_4),
  .c_data_out(c_data_15_4_to_15_5),
  .a_data_out(a_data_15_4_to_15_5),
  .b_data_out(b_data_15_4_to_16_4),
  .a_addr(a_addr_15_4_NC),
  .b_addr(b_addr_15_4_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 15_5
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_5_to_15_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_5_to_16_5;
  wire [`AWIDTH-1:0] a_addr_15_5_NC;
  wire [`AWIDTH-1:0] b_addr_15_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_5_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_5_to_15_6;

matmul_4x4_systolic u_matmul_4x4_systolic_15_5(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_5),
  .a_data(a_data_15_5_NC),
  .b_data(b_data_15_5_NC),
  .a_data_in(a_data_15_4_to_15_5),
  .b_data_in(b_data_14_5_to_15_5),
  .c_data_in(c_data_15_4_to_15_5),
  .c_data_out(c_data_15_5_to_15_6),
  .a_data_out(a_data_15_5_to_15_6),
  .b_data_out(b_data_15_5_to_16_5),
  .a_addr(a_addr_15_5_NC),
  .b_addr(b_addr_15_5_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 15_6
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_6_to_15_7;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_6_to_16_6;
  wire [`AWIDTH-1:0] a_addr_15_6_NC;
  wire [`AWIDTH-1:0] b_addr_15_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_6_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_6_to_15_7;

matmul_4x4_systolic u_matmul_4x4_systolic_15_6(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_6),
  .a_data(a_data_15_6_NC),
  .b_data(b_data_15_6_NC),
  .a_data_in(a_data_15_5_to_15_6),
  .b_data_in(b_data_14_6_to_15_6),
  .c_data_in(c_data_15_5_to_15_6),
  .c_data_out(c_data_15_6_to_15_7),
  .a_data_out(a_data_15_6_to_15_7),
  .b_data_out(b_data_15_6_to_16_6),
  .a_addr(a_addr_15_6_NC),
  .b_addr(b_addr_15_6_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 15_7
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_7_to_15_8;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_7_to_16_7;
  wire [`AWIDTH-1:0] a_addr_15_7_NC;
  wire [`AWIDTH-1:0] b_addr_15_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_7_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_7_to_15_8;

matmul_4x4_systolic u_matmul_4x4_systolic_15_7(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_7),
  .a_data(a_data_15_7_NC),
  .b_data(b_data_15_7_NC),
  .a_data_in(a_data_15_6_to_15_7),
  .b_data_in(b_data_14_7_to_15_7),
  .c_data_in(c_data_15_6_to_15_7),
  .c_data_out(c_data_15_7_to_15_8),
  .a_data_out(a_data_15_7_to_15_8),
  .b_data_out(b_data_15_7_to_16_7),
  .a_addr(a_addr_15_7_NC),
  .b_addr(b_addr_15_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 15_8
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_8_to_15_9;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_8_to_16_8;
  wire [`AWIDTH-1:0] a_addr_15_8_NC;
  wire [`AWIDTH-1:0] b_addr_15_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_8_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_8_to_15_9;

matmul_4x4_systolic u_matmul_4x4_systolic_15_8(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_8),
  .a_data(a_data_15_8_NC),
  .b_data(b_data_15_8_NC),
  .a_data_in(a_data_15_7_to_15_8),
  .b_data_in(b_data_14_8_to_15_8),
  .c_data_in(c_data_15_7_to_15_8),
  .c_data_out(c_data_15_8_to_15_9),
  .a_data_out(a_data_15_8_to_15_9),
  .b_data_out(b_data_15_8_to_16_8),
  .a_addr(a_addr_15_8_NC),
  .b_addr(b_addr_15_8_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd8)
);

  /////////////////////////////////////////////////
  // Matmul 15_9
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_9_to_15_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_9_to_16_9;
  wire [`AWIDTH-1:0] a_addr_15_9_NC;
  wire [`AWIDTH-1:0] b_addr_15_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_9_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_9_to_15_10;

matmul_4x4_systolic u_matmul_4x4_systolic_15_9(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_9),
  .a_data(a_data_15_9_NC),
  .b_data(b_data_15_9_NC),
  .a_data_in(a_data_15_8_to_15_9),
  .b_data_in(b_data_14_9_to_15_9),
  .c_data_in(c_data_15_8_to_15_9),
  .c_data_out(c_data_15_9_to_15_10),
  .a_data_out(a_data_15_9_to_15_10),
  .b_data_out(b_data_15_9_to_16_9),
  .a_addr(a_addr_15_9_NC),
  .b_addr(b_addr_15_9_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd9)
);

  /////////////////////////////////////////////////
  // Matmul 15_10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_10_to_15_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_10_to_16_10;
  wire [`AWIDTH-1:0] a_addr_15_10_NC;
  wire [`AWIDTH-1:0] b_addr_15_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_10_to_15_11;

matmul_4x4_systolic u_matmul_4x4_systolic_15_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_10),
  .a_data(a_data_15_10_NC),
  .b_data(b_data_15_10_NC),
  .a_data_in(a_data_15_9_to_15_10),
  .b_data_in(b_data_14_10_to_15_10),
  .c_data_in(c_data_15_9_to_15_10),
  .c_data_out(c_data_15_10_to_15_11),
  .a_data_out(a_data_15_10_to_15_11),
  .b_data_out(b_data_15_10_to_16_10),
  .a_addr(a_addr_15_10_NC),
  .b_addr(b_addr_15_10_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd10)
);

  /////////////////////////////////////////////////
  // Matmul 15_11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_11_to_15_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_11_to_16_11;
  wire [`AWIDTH-1:0] a_addr_15_11_NC;
  wire [`AWIDTH-1:0] b_addr_15_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_11_to_15_12;

matmul_4x4_systolic u_matmul_4x4_systolic_15_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_11),
  .a_data(a_data_15_11_NC),
  .b_data(b_data_15_11_NC),
  .a_data_in(a_data_15_10_to_15_11),
  .b_data_in(b_data_14_11_to_15_11),
  .c_data_in(c_data_15_10_to_15_11),
  .c_data_out(c_data_15_11_to_15_12),
  .a_data_out(a_data_15_11_to_15_12),
  .b_data_out(b_data_15_11_to_16_11),
  .a_addr(a_addr_15_11_NC),
  .b_addr(b_addr_15_11_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd11)
);

  /////////////////////////////////////////////////
  // Matmul 15_12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_12_to_15_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_12_to_16_12;
  wire [`AWIDTH-1:0] a_addr_15_12_NC;
  wire [`AWIDTH-1:0] b_addr_15_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_12_to_15_13;

matmul_4x4_systolic u_matmul_4x4_systolic_15_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_12),
  .a_data(a_data_15_12_NC),
  .b_data(b_data_15_12_NC),
  .a_data_in(a_data_15_11_to_15_12),
  .b_data_in(b_data_14_12_to_15_12),
  .c_data_in(c_data_15_11_to_15_12),
  .c_data_out(c_data_15_12_to_15_13),
  .a_data_out(a_data_15_12_to_15_13),
  .b_data_out(b_data_15_12_to_16_12),
  .a_addr(a_addr_15_12_NC),
  .b_addr(b_addr_15_12_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd12)
);

  /////////////////////////////////////////////////
  // Matmul 15_13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_13_to_15_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_13_to_16_13;
  wire [`AWIDTH-1:0] a_addr_15_13_NC;
  wire [`AWIDTH-1:0] b_addr_15_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_13_to_15_14;

matmul_4x4_systolic u_matmul_4x4_systolic_15_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_13),
  .a_data(a_data_15_13_NC),
  .b_data(b_data_15_13_NC),
  .a_data_in(a_data_15_12_to_15_13),
  .b_data_in(b_data_14_13_to_15_13),
  .c_data_in(c_data_15_12_to_15_13),
  .c_data_out(c_data_15_13_to_15_14),
  .a_data_out(a_data_15_13_to_15_14),
  .b_data_out(b_data_15_13_to_16_13),
  .a_addr(a_addr_15_13_NC),
  .b_addr(b_addr_15_13_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd13)
);

  /////////////////////////////////////////////////
  // Matmul 15_14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_14_to_15_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_14_to_16_14;
  wire [`AWIDTH-1:0] a_addr_15_14_NC;
  wire [`AWIDTH-1:0] b_addr_15_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15_14_to_15_15;

matmul_4x4_systolic u_matmul_4x4_systolic_15_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_14),
  .a_data(a_data_15_14_NC),
  .b_data(b_data_15_14_NC),
  .a_data_in(a_data_15_13_to_15_14),
  .b_data_in(b_data_14_14_to_15_14),
  .c_data_in(c_data_15_13_to_15_14),
  .c_data_out(c_data_15_14_to_15_15),
  .a_data_out(a_data_15_14_to_15_15),
  .b_data_out(b_data_15_14_to_16_14),
  .a_addr(a_addr_15_14_NC),
  .b_addr(b_addr_15_14_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd14)
);

  /////////////////////////////////////////////////
  // Matmul 15_15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_15_to_15_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_15_to_16_15;
  wire [`AWIDTH-1:0] a_addr_15_15_NC;
  wire [`AWIDTH-1:0] b_addr_15_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_15_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15_15),
  .a_data(a_data_15_15_NC),
  .b_data(b_data_15_15_NC),
  .a_data_in(a_data_15_14_to_15_15),
  .b_data_in(b_data_14_15_to_15_15),
  .c_data_in(c_data_15_14_to_15_15),
  .c_data_out(c_data_row_15),
  .a_data_out(a_data_15_15_to_15_16),
  .b_data_out(b_data_15_15_to_16_15),
  .a_addr(a_addr_15_15_NC),
  .b_addr(b_addr_15_15_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd15),
  .b_loc(8'd15)
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