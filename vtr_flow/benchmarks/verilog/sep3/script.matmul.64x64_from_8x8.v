`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define BB_MAT_MUL_SIZE 8


module matrix_multiplication(
  clk,
  reset_0,
  reset_1,
  reset_2,
  reset_3,
  reset_4,
  reset_5,
  reset_6,
  reset_7,
  reset_8,
  reset_9,
  reset_10,
  reset_11,
  reset_12,
  reset_13,
  reset_14,
  reset_15,
  enable_writing_to_mem,
  enable_reading_from_mem,
  data_pi,
  addr_pi,
  we_a,
  we_b,
  we_c,
  data_from_out_mat,
  start_mat_mul_0,
  start_mat_mul_1,
  start_mat_mul_2,
  start_mat_mul_3,
  start_mat_mul_4,
  start_mat_mul_5,
  start_mat_mul_6,
  start_mat_mul_7,
  start_mat_mul_8,
  start_mat_mul_9,
  start_mat_mul_10,
  start_mat_mul_11,
  start_mat_mul_12,
  start_mat_mul_13,
  start_mat_mul_14,
  start_mat_mul_15,
  done_mat_mul
);

  input clk;
  input enable_writing_to_mem;
  input enable_reading_from_mem;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input we_a;
  input we_b;
  input we_c;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  output done_mat_mul;



  input reset_0;
  input reset_1;
  input reset_2;
  input reset_3;
  input reset_4;
  input reset_5;
  input reset_6;
  input reset_7;
  input reset_8;
  input reset_9;
  input reset_10;
  input reset_11;
  input reset_12;
  input reset_13;
  input reset_14;
  input reset_15;
  input start_mat_mul_0;
  input start_mat_mul_1;
  input start_mat_mul_2;
  input start_mat_mul_3;
  input start_mat_mul_4;
  input start_mat_mul_5;
  input start_mat_mul_6;
  input start_mat_mul_7;
  input start_mat_mul_8;
  input start_mat_mul_9;
  input start_mat_mul_10;
  input start_mat_mul_11;
  input start_mat_mul_12;
  input start_mat_mul_13;
  input start_mat_mul_14;
  input start_mat_mul_15;
  reg enable_writing_to_mem_reg;
  reg enable_reading_from_mem_reg;
  reg [`AWIDTH-1:0] addr_pi_reg;
  always @(posedge clk) begin
    if(reset_0) begin
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

  wire [`AWIDTH-1:0] a_addr_0_0;
  wire [`AWIDTH-1:0] a_addr_1_0;
  wire [`AWIDTH-1:0] a_addr_2_0;
  wire [`AWIDTH-1:0] a_addr_3_0;
  wire [`AWIDTH-1:0] a_addr_4_0;
  wire [`AWIDTH-1:0] a_addr_5_0;
  wire [`AWIDTH-1:0] a_addr_6_0;
  wire [`AWIDTH-1:0] a_addr_7_0;

  wire [`AWIDTH-1:0] a_addr_muxed_0_0;
  wire [`AWIDTH-1:0] a_addr_muxed_1_0;
  wire [`AWIDTH-1:0] a_addr_muxed_2_0;
  wire [`AWIDTH-1:0] a_addr_muxed_3_0;
  wire [`AWIDTH-1:0] a_addr_muxed_4_0;
  wire [`AWIDTH-1:0] a_addr_muxed_5_0;
  wire [`AWIDTH-1:0] a_addr_muxed_6_0;
  wire [`AWIDTH-1:0] a_addr_muxed_7_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_5_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_6_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_7_0_reg;

  reg  [`AWIDTH-1:0] a_addr_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_5_0_reg;
  reg  [`AWIDTH-1:0] a_addr_6_0_reg;
  reg  [`AWIDTH-1:0] a_addr_7_0_reg;


  always @(posedge clk) begin
    if(reset_0) begin
      a_addr_0_0_reg <= 0;
      a_addr_1_0_reg <= 0;
      a_addr_2_0_reg <= 0;
      a_addr_3_0_reg <= 0;
      a_addr_4_0_reg <= 0;
      a_addr_5_0_reg <= 0;
      a_addr_6_0_reg <= 0;
      a_addr_7_0_reg <= 0;
      a_addr_muxed_0_0_reg <= 0;
      a_addr_muxed_1_0_reg <= 0;
      a_addr_muxed_2_0_reg <= 0;
      a_addr_muxed_3_0_reg <= 0;
      a_addr_muxed_4_0_reg <= 0;
      a_addr_muxed_5_0_reg <= 0;
      a_addr_muxed_6_0_reg <= 0;
      a_addr_muxed_7_0_reg <= 0;
    end else begin
      a_addr_0_0_reg <= a_addr_0_0;
      a_addr_1_0_reg <= a_addr_1_0;
      a_addr_2_0_reg <= a_addr_2_0;
      a_addr_3_0_reg <= a_addr_3_0;
      a_addr_4_0_reg <= a_addr_4_0;
      a_addr_5_0_reg <= a_addr_5_0;
      a_addr_6_0_reg <= a_addr_6_0;
      a_addr_7_0_reg <= a_addr_7_0;
      a_addr_muxed_0_0_reg <= a_addr_muxed_0_0;
      a_addr_muxed_1_0_reg <= a_addr_muxed_1_0;
      a_addr_muxed_2_0_reg <= a_addr_muxed_2_0;
      a_addr_muxed_3_0_reg <= a_addr_muxed_3_0;
      a_addr_muxed_4_0_reg <= a_addr_muxed_4_0;
      a_addr_muxed_5_0_reg <= a_addr_muxed_5_0;
      a_addr_muxed_6_0_reg <= a_addr_muxed_6_0;
      a_addr_muxed_7_0_reg <= a_addr_muxed_7_0;
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

  // BRAM matrix A 0_0
  ram matrix_A_0_0 (
    .addr0(a_addr_muxed_0_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_0_0),
    .clk(clk));

  // BRAM matrix A 1_0
  ram matrix_A_1_0 (
    .addr0(a_addr_muxed_1_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_1_0),
    .clk(clk));

  // BRAM matrix A 2_0
  ram matrix_A_2_0 (
    .addr0(a_addr_muxed_2_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_2_0),
    .clk(clk));

  // BRAM matrix A 3_0
  ram matrix_A_3_0 (
    .addr0(a_addr_muxed_3_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_3_0),
    .clk(clk));

  // BRAM matrix A 4_0
  ram matrix_A_4_0 (
    .addr0(a_addr_muxed_4_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_4_0),
    .clk(clk));

  // BRAM matrix A 5_0
  ram matrix_A_5_0 (
    .addr0(a_addr_muxed_5_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_5_0),
    .clk(clk));

  // BRAM matrix A 6_0
  ram matrix_A_6_0 (
    .addr0(a_addr_muxed_6_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_6_0),
    .clk(clk));

  // BRAM matrix A 7_0
  ram matrix_A_7_0 (
    .addr0(a_addr_muxed_7_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_7_0),
    .clk(clk));

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

  wire [`AWIDTH-1:0] b_addr_0_0;
  wire [`AWIDTH-1:0] b_addr_0_1;
  wire [`AWIDTH-1:0] b_addr_0_2;
  wire [`AWIDTH-1:0] b_addr_0_3;
  wire [`AWIDTH-1:0] b_addr_0_4;
  wire [`AWIDTH-1:0] b_addr_0_5;
  wire [`AWIDTH-1:0] b_addr_0_6;
  wire [`AWIDTH-1:0] b_addr_0_7;

  wire [`AWIDTH-1:0] b_addr_muxed_0_0;
  wire [`AWIDTH-1:0] b_addr_muxed_0_1;
  wire [`AWIDTH-1:0] b_addr_muxed_0_2;
  wire [`AWIDTH-1:0] b_addr_muxed_0_3;
  wire [`AWIDTH-1:0] b_addr_muxed_0_4;
  wire [`AWIDTH-1:0] b_addr_muxed_0_5;
  wire [`AWIDTH-1:0] b_addr_muxed_0_6;
  wire [`AWIDTH-1:0] b_addr_muxed_0_7;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_5_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_6_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_7_reg;

  reg  [`AWIDTH-1:0] b_addr_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_0_5_reg;
  reg  [`AWIDTH-1:0] b_addr_0_6_reg;
  reg  [`AWIDTH-1:0] b_addr_0_7_reg;



  always @(posedge clk) begin
    if(reset_0) begin
      b_addr_0_0_reg <= 0;
      b_addr_0_1_reg <= 0;
      b_addr_0_2_reg <= 0;
      b_addr_0_3_reg <= 0;
      b_addr_0_4_reg <= 0;
      b_addr_0_5_reg <= 0;
      b_addr_0_6_reg <= 0;
      b_addr_0_7_reg <= 0;
      b_addr_muxed_0_0_reg <= 0;
      b_addr_muxed_0_1_reg <= 0;
      b_addr_muxed_0_2_reg <= 0;
      b_addr_muxed_0_3_reg <= 0;
      b_addr_muxed_0_4_reg <= 0;
      b_addr_muxed_0_5_reg <= 0;
      b_addr_muxed_0_6_reg <= 0;
      b_addr_muxed_0_7_reg <= 0;
    end else begin
      b_addr_0_0_reg <= b_addr_0_0;
      b_addr_0_1_reg <= b_addr_0_1;
      b_addr_0_2_reg <= b_addr_0_2;
      b_addr_0_3_reg <= b_addr_0_3;
      b_addr_0_4_reg <= b_addr_0_4;
      b_addr_0_5_reg <= b_addr_0_5;
      b_addr_0_6_reg <= b_addr_0_6;
      b_addr_0_7_reg <= b_addr_0_7;
      b_addr_muxed_0_0_reg <= b_addr_muxed_0_0;
      b_addr_muxed_0_1_reg <= b_addr_muxed_0_1;
      b_addr_muxed_0_2_reg <= b_addr_muxed_0_2;
      b_addr_muxed_0_3_reg <= b_addr_muxed_0_3;
      b_addr_muxed_0_4_reg <= b_addr_muxed_0_4;
      b_addr_muxed_0_5_reg <= b_addr_muxed_0_5;
      b_addr_muxed_0_6_reg <= b_addr_muxed_0_6;
      b_addr_muxed_0_7_reg <= b_addr_muxed_0_7;
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

  // BRAM matrix B 0_0
  ram matrix_B_0_0 (
    .addr0(b_addr_muxed_0_0_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_0),
    .clk(clk));

  // BRAM matrix B 0_1
  ram matrix_B_0_1 (
    .addr0(b_addr_muxed_0_1_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_1),
    .clk(clk));

  // BRAM matrix B 0_2
  ram matrix_B_0_2 (
    .addr0(b_addr_muxed_0_2_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_2),
    .clk(clk));

  // BRAM matrix B 0_3
  ram matrix_B_0_3 (
    .addr0(b_addr_muxed_0_3_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_3),
    .clk(clk));

  // BRAM matrix B 0_4
  ram matrix_B_0_4 (
    .addr0(b_addr_muxed_0_4_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_4),
    .clk(clk));

  // BRAM matrix B 0_5
  ram matrix_B_0_5 (
    .addr0(b_addr_muxed_0_5_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_5),
    .clk(clk));

  // BRAM matrix B 0_6
  ram matrix_B_0_6 (
    .addr0(b_addr_muxed_0_6_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_6),
    .clk(clk));

  // BRAM matrix B 0_7
  ram matrix_B_0_7 (
    .addr0(b_addr_muxed_0_7_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_7),
    .clk(clk));

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
  reg  [`AWIDTH-1:0] c_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_5_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_6_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_7_reg;

  assign c_addr_muxed_0_0 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_1 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_2 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_3 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_4 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_5 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_6 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_7 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;

  always @(posedge clk) begin
    if(reset_0 || done_mat_mul) begin
      c_addr <= 0;
    end
    else if (start_mat_mul_0) begin
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_5;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_6;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_7;

///////////////// ORing the data ///////////////////
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_0;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_1;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_2;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_3;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_4;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_5;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_6;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_7;
  always @(posedge clk) begin
    if(reset_0) begin
      c_reg_0 <= 0;
      c_reg_1 <= 0;
      c_reg_2 <= 0;
      c_reg_3 <= 0;
      c_reg_4 <= 0;
      c_reg_5 <= 0;
      c_reg_6 <= 0;
      c_reg_7 <= 0;
    end else begin
      c_reg_0 <= data_from_out_mat_0_0;
      c_reg_1 <= c_reg_0 | data_from_out_mat_0_1;
      c_reg_2 <= c_reg_1 | data_from_out_mat_0_2;
      c_reg_3 <= c_reg_2 | data_from_out_mat_0_3;
      c_reg_4 <= c_reg_3 | data_from_out_mat_0_4;
      c_reg_5 <= c_reg_4 | data_from_out_mat_0_5;
      c_reg_6 <= c_reg_5 | data_from_out_mat_0_6;
      c_reg_7 <= c_reg_6 | data_from_out_mat_0_7;
      data_from_out_mat <= c_reg_7;
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
  always @(posedge clk) begin
    if(reset_0) begin
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
    end
  end

  //  BRAM matrix C row_0
  ram matrix_row_0 (
    .addr0(c_addr_muxed_0_0_reg),
    .d0(c_data_row_0_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_0),
    .clk(clk));

  //  BRAM matrix C row_1
  ram matrix_row_1 (
    .addr0(c_addr_muxed_0_1_reg),
    .d0(c_data_row_1_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_1),
    .clk(clk));

  //  BRAM matrix C row_2
  ram matrix_row_2 (
    .addr0(c_addr_muxed_0_2_reg),
    .d0(c_data_row_2_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_2),
    .clk(clk));

  //  BRAM matrix C row_3
  ram matrix_row_3 (
    .addr0(c_addr_muxed_0_3_reg),
    .d0(c_data_row_3_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_3),
    .clk(clk));

  //  BRAM matrix C row_4
  ram matrix_row_4 (
    .addr0(c_addr_muxed_0_4_reg),
    .d0(c_data_row_4_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_4),
    .clk(clk));

  //  BRAM matrix C row_5
  ram matrix_row_5 (
    .addr0(c_addr_muxed_0_5_reg),
    .d0(c_data_row_5_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_5),
    .clk(clk));

  //  BRAM matrix C row_6
  ram matrix_row_6 (
    .addr0(c_addr_muxed_0_6_reg),
    .d0(c_data_row_6_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_6),
    .clk(clk));

  //  BRAM matrix C row_7
  ram matrix_row_7 (
    .addr0(c_addr_muxed_0_7_reg),
    .d0(c_data_row_7_reg),
    .we0(we_c),
    .q0(data_from_out_mat_0_7),
    .clk(clk));

/////////////////////////////////////////////////
// The 64x64 matmul instantiation
/////////////////////////////////////////////////

matmul_64x64_systolic u_matmul_64x64_systolic (
  .clk(clk),
  .done_mat_mul(done_mat_mul),
  .reset_0(reset_0),
  .reset_1(reset_1),
  .reset_2(reset_2),
  .reset_3(reset_3),
  .reset_4(reset_4),
  .reset_5(reset_5),
  .reset_6(reset_6),
  .reset_7(reset_7),
  .reset_8(reset_8),
  .reset_9(reset_9),
  .reset_10(reset_10),
  .reset_11(reset_11),
  .reset_12(reset_12),
  .reset_13(reset_13),
  .reset_14(reset_14),
  .reset_15(reset_15),
  .start_mat_mul_0(start_mat_mul_0),
  .start_mat_mul_1(start_mat_mul_1),
  .start_mat_mul_2(start_mat_mul_2),
  .start_mat_mul_3(start_mat_mul_3),
  .start_mat_mul_4(start_mat_mul_4),
  .start_mat_mul_5(start_mat_mul_5),
  .start_mat_mul_6(start_mat_mul_6),
  .start_mat_mul_7(start_mat_mul_7),
  .start_mat_mul_8(start_mat_mul_8),
  .start_mat_mul_9(start_mat_mul_9),
  .start_mat_mul_10(start_mat_mul_10),
  .start_mat_mul_11(start_mat_mul_11),
  .start_mat_mul_12(start_mat_mul_12),
  .start_mat_mul_13(start_mat_mul_13),
  .start_mat_mul_14(start_mat_mul_14),
  .start_mat_mul_15(start_mat_mul_15),
  .a_data_0_0(a_data_0_0),
  .a_addr_0_0(a_addr_0_0),
  .b_data_0_0(b_data_0_0),
  .b_addr_0_0(b_addr_0_0),
  .a_data_1_0(a_data_1_0),
  .a_addr_1_0(a_addr_1_0),
  .b_data_0_1(b_data_0_1),
  .b_addr_0_1(b_addr_0_1),
  .a_data_2_0(a_data_2_0),
  .a_addr_2_0(a_addr_2_0),
  .b_data_0_2(b_data_0_2),
  .b_addr_0_2(b_addr_0_2),
  .a_data_3_0(a_data_3_0),
  .a_addr_3_0(a_addr_3_0),
  .b_data_0_3(b_data_0_3),
  .b_addr_0_3(b_addr_0_3),
  .a_data_4_0(a_data_4_0),
  .a_addr_4_0(a_addr_4_0),
  .b_data_0_4(b_data_0_4),
  .b_addr_0_4(b_addr_0_4),
  .a_data_5_0(a_data_5_0),
  .a_addr_5_0(a_addr_5_0),
  .b_data_0_5(b_data_0_5),
  .b_addr_0_5(b_addr_0_5),
  .a_data_6_0(a_data_6_0),
  .a_addr_6_0(a_addr_6_0),
  .b_data_0_6(b_data_0_6),
  .b_addr_0_6(b_addr_0_6),
  .a_data_7_0(a_data_7_0),
  .a_addr_7_0(a_addr_7_0),
  .b_data_0_7(b_data_0_7),
  .b_addr_0_7(b_addr_0_7),

  .c_data_row_0(c_data_row_0),
  .c_data_row_1(c_data_row_1),
  .c_data_row_2(c_data_row_2),
  .c_data_row_3(c_data_row_3),
  .c_data_row_4(c_data_row_4),
  .c_data_row_5(c_data_row_5),
  .c_data_row_6(c_data_row_6),
  .c_data_row_7(c_data_row_7)
);
endmodule


/////////////////////////////////////////////////
// The 64x64 matmul definition
/////////////////////////////////////////////////

module matmul_64x64_systolic(
  clk,
  done_mat_mul,
  reset_0,
  reset_1,
  reset_2,
  reset_3,
  reset_4,
  reset_5,
  reset_6,
  reset_7,
  reset_8,
  reset_9,
  reset_10,
  reset_11,
  reset_12,
  reset_13,
  reset_14,
  reset_15,
  start_mat_mul_0,
  start_mat_mul_1,
  start_mat_mul_2,
  start_mat_mul_3,
  start_mat_mul_4,
  start_mat_mul_5,
  start_mat_mul_6,
  start_mat_mul_7,
  start_mat_mul_8,
  start_mat_mul_9,
  start_mat_mul_10,
  start_mat_mul_11,
  start_mat_mul_12,
  start_mat_mul_13,
  start_mat_mul_14,
  start_mat_mul_15,
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

  c_data_row_0,
  c_data_row_1,
  c_data_row_2,
  c_data_row_3,
  c_data_row_4,
  c_data_row_5,
  c_data_row_6,
  c_data_row_7
);
  input clk;
  output done_mat_mul;

  input reset_0;
  input reset_1;
  input reset_2;
  input reset_3;
  input reset_4;
  input reset_5;
  input reset_6;
  input reset_7;
  input reset_8;
  input reset_9;
  input reset_10;
  input reset_11;
  input reset_12;
  input reset_13;
  input reset_14;
  input reset_15;
  input start_mat_mul_0;
  input start_mat_mul_1;
  input start_mat_mul_2;
  input start_mat_mul_3;
  input start_mat_mul_4;
  input start_mat_mul_5;
  input start_mat_mul_6;
  input start_mat_mul_7;
  input start_mat_mul_8;
  input start_mat_mul_9;
  input start_mat_mul_10;
  input start_mat_mul_11;
  input start_mat_mul_12;
  input start_mat_mul_13;
  input start_mat_mul_14;
  input start_mat_mul_15;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_5_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_6_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_7_0;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_5;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_6;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_7;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_5;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_6;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_7;

  output [`AWIDTH-1:0] a_addr_0_0;
  output [`AWIDTH-1:0] a_addr_1_0;
  output [`AWIDTH-1:0] a_addr_2_0;
  output [`AWIDTH-1:0] a_addr_3_0;
  output [`AWIDTH-1:0] a_addr_4_0;
  output [`AWIDTH-1:0] a_addr_5_0;
  output [`AWIDTH-1:0] a_addr_6_0;
  output [`AWIDTH-1:0] a_addr_7_0;

  output [`AWIDTH-1:0] b_addr_0_0;
  output [`AWIDTH-1:0] b_addr_0_1;
  output [`AWIDTH-1:0] b_addr_0_2;
  output [`AWIDTH-1:0] b_addr_0_3;
  output [`AWIDTH-1:0] b_addr_0_4;
  output [`AWIDTH-1:0] b_addr_0_5;
  output [`AWIDTH-1:0] b_addr_0_6;
  output [`AWIDTH-1:0] b_addr_0_7;

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
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;
  wire done_mat_mul_1_2;
  wire done_mat_mul_1_3;
  wire done_mat_mul_1_4;
  wire done_mat_mul_1_5;
  wire done_mat_mul_1_6;
  wire done_mat_mul_1_7;
  wire done_mat_mul_2_0;
  wire done_mat_mul_2_1;
  wire done_mat_mul_2_2;
  wire done_mat_mul_2_3;
  wire done_mat_mul_2_4;
  wire done_mat_mul_2_5;
  wire done_mat_mul_2_6;
  wire done_mat_mul_2_7;
  wire done_mat_mul_3_0;
  wire done_mat_mul_3_1;
  wire done_mat_mul_3_2;
  wire done_mat_mul_3_3;
  wire done_mat_mul_3_4;
  wire done_mat_mul_3_5;
  wire done_mat_mul_3_6;
  wire done_mat_mul_3_7;
  wire done_mat_mul_4_0;
  wire done_mat_mul_4_1;
  wire done_mat_mul_4_2;
  wire done_mat_mul_4_3;
  wire done_mat_mul_4_4;
  wire done_mat_mul_4_5;
  wire done_mat_mul_4_6;
  wire done_mat_mul_4_7;
  wire done_mat_mul_5_0;
  wire done_mat_mul_5_1;
  wire done_mat_mul_5_2;
  wire done_mat_mul_5_3;
  wire done_mat_mul_5_4;
  wire done_mat_mul_5_5;
  wire done_mat_mul_5_6;
  wire done_mat_mul_5_7;
  wire done_mat_mul_6_0;
  wire done_mat_mul_6_1;
  wire done_mat_mul_6_2;
  wire done_mat_mul_6_3;
  wire done_mat_mul_6_4;
  wire done_mat_mul_6_5;
  wire done_mat_mul_6_6;
  wire done_mat_mul_6_7;
  wire done_mat_mul_7_0;
  wire done_mat_mul_7_1;
  wire done_mat_mul_7_2;
  wire done_mat_mul_7_3;
  wire done_mat_mul_7_4;
  wire done_mat_mul_7_5;
  wire done_mat_mul_7_6;
  wire done_mat_mul_7_7;

  assign done_mat_mul =   done_mat_mul_0_0 &&
  done_mat_mul_0_1 &&
  done_mat_mul_0_2 &&
  done_mat_mul_0_3 &&
  done_mat_mul_0_4 &&
  done_mat_mul_0_5 &&
  done_mat_mul_0_6 &&
  done_mat_mul_0_7 &&
  done_mat_mul_1_0 &&
  done_mat_mul_1_1 &&
  done_mat_mul_1_2 &&
  done_mat_mul_1_3 &&
  done_mat_mul_1_4 &&
  done_mat_mul_1_5 &&
  done_mat_mul_1_6 &&
  done_mat_mul_1_7 &&
  done_mat_mul_2_0 &&
  done_mat_mul_2_1 &&
  done_mat_mul_2_2 &&
  done_mat_mul_2_3 &&
  done_mat_mul_2_4 &&
  done_mat_mul_2_5 &&
  done_mat_mul_2_6 &&
  done_mat_mul_2_7 &&
  done_mat_mul_3_0 &&
  done_mat_mul_3_1 &&
  done_mat_mul_3_2 &&
  done_mat_mul_3_3 &&
  done_mat_mul_3_4 &&
  done_mat_mul_3_5 &&
  done_mat_mul_3_6 &&
  done_mat_mul_3_7 &&
  done_mat_mul_4_0 &&
  done_mat_mul_4_1 &&
  done_mat_mul_4_2 &&
  done_mat_mul_4_3 &&
  done_mat_mul_4_4 &&
  done_mat_mul_4_5 &&
  done_mat_mul_4_6 &&
  done_mat_mul_4_7 &&
  done_mat_mul_5_0 &&
  done_mat_mul_5_1 &&
  done_mat_mul_5_2 &&
  done_mat_mul_5_3 &&
  done_mat_mul_5_4 &&
  done_mat_mul_5_5 &&
  done_mat_mul_5_6 &&
  done_mat_mul_5_7 &&
  done_mat_mul_6_0 &&
  done_mat_mul_6_1 &&
  done_mat_mul_6_2 &&
  done_mat_mul_6_3 &&
  done_mat_mul_6_4 &&
  done_mat_mul_6_5 &&
  done_mat_mul_6_6 &&
  done_mat_mul_6_7 &&
  done_mat_mul_7_0 &&
  done_mat_mul_7_1 &&
  done_mat_mul_7_2 &&
  done_mat_mul_7_3 &&
  done_mat_mul_7_4 &&
  done_mat_mul_7_5 &&
  done_mat_mul_7_6 &&
  done_mat_mul_7_7;

  /////////////////////////////////////////////////
  // Matmul 0_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_to_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_to_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0_to_0_1;

matmul_8x8_systolic u_matmul_8x8_systolic_0_0(
  .clk(clk),
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_1(
  .clk(clk),
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_2(
  .clk(clk),
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_3(
  .clk(clk),
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_4(
  .clk(clk),
  .reset(reset_1),
  .start_mat_mul(start_mat_mul_1),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_5(
  .clk(clk),
  .reset(reset_1),
  .start_mat_mul(start_mat_mul_1),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_6(
  .clk(clk),
  .reset(reset_1),
  .start_mat_mul(start_mat_mul_1),
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

matmul_8x8_systolic u_matmul_8x8_systolic_0_7(
  .clk(clk),
  .reset(reset_1),
  .start_mat_mul(start_mat_mul_1),
  .done_mat_mul(done_mat_mul_0_7),
  .a_data(a_data_0_7_NC),
  .b_data(b_data_0_7),
  .a_data_in(a_data_0_6_to_0_7),
  .b_data_in(b_data_in_0_7_NC),
  .c_data_in(c_data_0_6_to_0_7),
  .c_data_out(c_data_row_0),
  .a_data_out(a_data_0_7_to_0_8),
  .b_data_out(b_data_0_7_to_1_7),
  .a_addr(a_addr_0_7_NC),
  .b_addr(b_addr_0_7),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd0),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_0(
  .clk(clk),
  .reset(reset_2),
  .start_mat_mul(start_mat_mul_2),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_1(
  .clk(clk),
  .reset(reset_2),
  .start_mat_mul(start_mat_mul_2),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_2(
  .clk(clk),
  .reset(reset_2),
  .start_mat_mul(start_mat_mul_2),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_3(
  .clk(clk),
  .reset(reset_2),
  .start_mat_mul(start_mat_mul_2),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_4(
  .clk(clk),
  .reset(reset_3),
  .start_mat_mul(start_mat_mul_3),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_5(
  .clk(clk),
  .reset(reset_3),
  .start_mat_mul(start_mat_mul_3),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_6(
  .clk(clk),
  .reset(reset_3),
  .start_mat_mul(start_mat_mul_3),
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

matmul_8x8_systolic u_matmul_8x8_systolic_1_7(
  .clk(clk),
  .reset(reset_3),
  .start_mat_mul(start_mat_mul_3),
  .done_mat_mul(done_mat_mul_1_7),
  .a_data(a_data_1_7_NC),
  .b_data(b_data_1_7_NC),
  .a_data_in(a_data_1_6_to_1_7),
  .b_data_in(b_data_0_7_to_1_7),
  .c_data_in(c_data_1_6_to_1_7),
  .c_data_out(c_data_row_1),
  .a_data_out(a_data_1_7_to_1_8),
  .b_data_out(b_data_1_7_to_2_7),
  .a_addr(a_addr_1_7_NC),
  .b_addr(b_addr_1_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd1),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_0(
  .clk(clk),
  .reset(reset_4),
  .start_mat_mul(start_mat_mul_4),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_1(
  .clk(clk),
  .reset(reset_4),
  .start_mat_mul(start_mat_mul_4),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_2(
  .clk(clk),
  .reset(reset_4),
  .start_mat_mul(start_mat_mul_4),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_3(
  .clk(clk),
  .reset(reset_4),
  .start_mat_mul(start_mat_mul_4),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_4(
  .clk(clk),
  .reset(reset_5),
  .start_mat_mul(start_mat_mul_5),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_5(
  .clk(clk),
  .reset(reset_5),
  .start_mat_mul(start_mat_mul_5),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_6(
  .clk(clk),
  .reset(reset_5),
  .start_mat_mul(start_mat_mul_5),
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

matmul_8x8_systolic u_matmul_8x8_systolic_2_7(
  .clk(clk),
  .reset(reset_5),
  .start_mat_mul(start_mat_mul_5),
  .done_mat_mul(done_mat_mul_2_7),
  .a_data(a_data_2_7_NC),
  .b_data(b_data_2_7_NC),
  .a_data_in(a_data_2_6_to_2_7),
  .b_data_in(b_data_1_7_to_2_7),
  .c_data_in(c_data_2_6_to_2_7),
  .c_data_out(c_data_row_2),
  .a_data_out(a_data_2_7_to_2_8),
  .b_data_out(b_data_2_7_to_3_7),
  .a_addr(a_addr_2_7_NC),
  .b_addr(b_addr_2_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd2),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_0(
  .clk(clk),
  .reset(reset_6),
  .start_mat_mul(start_mat_mul_6),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_1(
  .clk(clk),
  .reset(reset_6),
  .start_mat_mul(start_mat_mul_6),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_2(
  .clk(clk),
  .reset(reset_6),
  .start_mat_mul(start_mat_mul_6),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_3(
  .clk(clk),
  .reset(reset_6),
  .start_mat_mul(start_mat_mul_6),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_4(
  .clk(clk),
  .reset(reset_7),
  .start_mat_mul(start_mat_mul_7),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_5(
  .clk(clk),
  .reset(reset_7),
  .start_mat_mul(start_mat_mul_7),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_6(
  .clk(clk),
  .reset(reset_7),
  .start_mat_mul(start_mat_mul_7),
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

matmul_8x8_systolic u_matmul_8x8_systolic_3_7(
  .clk(clk),
  .reset(reset_7),
  .start_mat_mul(start_mat_mul_7),
  .done_mat_mul(done_mat_mul_3_7),
  .a_data(a_data_3_7_NC),
  .b_data(b_data_3_7_NC),
  .a_data_in(a_data_3_6_to_3_7),
  .b_data_in(b_data_2_7_to_3_7),
  .c_data_in(c_data_3_6_to_3_7),
  .c_data_out(c_data_row_3),
  .a_data_out(a_data_3_7_to_3_8),
  .b_data_out(b_data_3_7_to_4_7),
  .a_addr(a_addr_3_7_NC),
  .b_addr(b_addr_3_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd3),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_0(
  .clk(clk),
  .reset(reset_8),
  .start_mat_mul(start_mat_mul_8),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_1(
  .clk(clk),
  .reset(reset_8),
  .start_mat_mul(start_mat_mul_8),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_2(
  .clk(clk),
  .reset(reset_8),
  .start_mat_mul(start_mat_mul_8),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_3(
  .clk(clk),
  .reset(reset_8),
  .start_mat_mul(start_mat_mul_8),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_4(
  .clk(clk),
  .reset(reset_9),
  .start_mat_mul(start_mat_mul_9),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_5(
  .clk(clk),
  .reset(reset_9),
  .start_mat_mul(start_mat_mul_9),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_6(
  .clk(clk),
  .reset(reset_9),
  .start_mat_mul(start_mat_mul_9),
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

matmul_8x8_systolic u_matmul_8x8_systolic_4_7(
  .clk(clk),
  .reset(reset_9),
  .start_mat_mul(start_mat_mul_9),
  .done_mat_mul(done_mat_mul_4_7),
  .a_data(a_data_4_7_NC),
  .b_data(b_data_4_7_NC),
  .a_data_in(a_data_4_6_to_4_7),
  .b_data_in(b_data_3_7_to_4_7),
  .c_data_in(c_data_4_6_to_4_7),
  .c_data_out(c_data_row_4),
  .a_data_out(a_data_4_7_to_4_8),
  .b_data_out(b_data_4_7_to_5_7),
  .a_addr(a_addr_4_7_NC),
  .b_addr(b_addr_4_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd4),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_0(
  .clk(clk),
  .reset(reset_10),
  .start_mat_mul(start_mat_mul_10),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_1(
  .clk(clk),
  .reset(reset_10),
  .start_mat_mul(start_mat_mul_10),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_2(
  .clk(clk),
  .reset(reset_10),
  .start_mat_mul(start_mat_mul_10),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_3(
  .clk(clk),
  .reset(reset_10),
  .start_mat_mul(start_mat_mul_10),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_4(
  .clk(clk),
  .reset(reset_11),
  .start_mat_mul(start_mat_mul_11),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_5(
  .clk(clk),
  .reset(reset_11),
  .start_mat_mul(start_mat_mul_11),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_6(
  .clk(clk),
  .reset(reset_11),
  .start_mat_mul(start_mat_mul_11),
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

matmul_8x8_systolic u_matmul_8x8_systolic_5_7(
  .clk(clk),
  .reset(reset_11),
  .start_mat_mul(start_mat_mul_11),
  .done_mat_mul(done_mat_mul_5_7),
  .a_data(a_data_5_7_NC),
  .b_data(b_data_5_7_NC),
  .a_data_in(a_data_5_6_to_5_7),
  .b_data_in(b_data_4_7_to_5_7),
  .c_data_in(c_data_5_6_to_5_7),
  .c_data_out(c_data_row_5),
  .a_data_out(a_data_5_7_to_5_8),
  .b_data_out(b_data_5_7_to_6_7),
  .a_addr(a_addr_5_7_NC),
  .b_addr(b_addr_5_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd5),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_0(
  .clk(clk),
  .reset(reset_12),
  .start_mat_mul(start_mat_mul_12),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_1(
  .clk(clk),
  .reset(reset_12),
  .start_mat_mul(start_mat_mul_12),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_2(
  .clk(clk),
  .reset(reset_12),
  .start_mat_mul(start_mat_mul_12),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_3(
  .clk(clk),
  .reset(reset_12),
  .start_mat_mul(start_mat_mul_12),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_4(
  .clk(clk),
  .reset(reset_13),
  .start_mat_mul(start_mat_mul_13),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_5(
  .clk(clk),
  .reset(reset_13),
  .start_mat_mul(start_mat_mul_13),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_6(
  .clk(clk),
  .reset(reset_13),
  .start_mat_mul(start_mat_mul_13),
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

matmul_8x8_systolic u_matmul_8x8_systolic_6_7(
  .clk(clk),
  .reset(reset_13),
  .start_mat_mul(start_mat_mul_13),
  .done_mat_mul(done_mat_mul_6_7),
  .a_data(a_data_6_7_NC),
  .b_data(b_data_6_7_NC),
  .a_data_in(a_data_6_6_to_6_7),
  .b_data_in(b_data_5_7_to_6_7),
  .c_data_in(c_data_6_6_to_6_7),
  .c_data_out(c_data_row_6),
  .a_data_out(a_data_6_7_to_6_8),
  .b_data_out(b_data_6_7_to_7_7),
  .a_addr(a_addr_6_7_NC),
  .b_addr(b_addr_6_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd6),
  .b_loc(8'd7)
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_0(
  .clk(clk),
  .reset(reset_14),
  .start_mat_mul(start_mat_mul_14),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_1(
  .clk(clk),
  .reset(reset_14),
  .start_mat_mul(start_mat_mul_14),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_2(
  .clk(clk),
  .reset(reset_14),
  .start_mat_mul(start_mat_mul_14),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_3(
  .clk(clk),
  .reset(reset_14),
  .start_mat_mul(start_mat_mul_14),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_4(
  .clk(clk),
  .reset(reset_15),
  .start_mat_mul(start_mat_mul_15),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_5(
  .clk(clk),
  .reset(reset_15),
  .start_mat_mul(start_mat_mul_15),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_6(
  .clk(clk),
  .reset(reset_15),
  .start_mat_mul(start_mat_mul_15),
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

matmul_8x8_systolic u_matmul_8x8_systolic_7_7(
  .clk(clk),
  .reset(reset_15),
  .start_mat_mul(start_mat_mul_15),
  .done_mat_mul(done_mat_mul_7_7),
  .a_data(a_data_7_7_NC),
  .b_data(b_data_7_7_NC),
  .a_data_in(a_data_7_6_to_7_7),
  .b_data_in(b_data_6_7_to_7_7),
  .c_data_in(c_data_7_6_to_7_7),
  .c_data_out(c_data_row_7),
  .a_data_out(a_data_7_7_to_7_8),
  .b_data_out(b_data_7_7_to_8_7),
  .a_addr(a_addr_7_7_NC),
  .b_addr(b_addr_7_7_NC),
  .final_mat_mul_size(8'd64),
  .a_loc(8'd7),
  .b_loc(8'd7)
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