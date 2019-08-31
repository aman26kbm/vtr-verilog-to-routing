`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define BB_MAT_MUL_SIZE 4


module matrix_multiplication(
  clk,
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
  input reset;
  input enable_writing_to_mem;
  input enable_reading_from_mem;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input we_a;
  input we_b;
  input we_c;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  input start_mat_mul;
  output done_mat_mul;



  reg enable_writing_to_mem_reg;
  reg [`AWIDTH-1:0] addr_pi_reg;
  always @(posedge clk) begin
    if (reset) begin
      enable_writing_to_mem_reg <= 0;
      addr_pi_reg <= 0;
    end else begin
      enable_writing_to_mem_reg <= enable_writing_to_mem;
      addr_pi_reg <= addr_pi;
    end
  end
/////////////////////////////////////////////////
// BRAMs to store matrix A
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  wire [`AWIDTH-1:0] a_addr_0_0;
  wire [`AWIDTH-1:0] a_addr_muxed_0_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_0_0_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_0_0_reg <= 0;
      a_addr_muxed_0_0_reg <= 0;
    end else begin
      a_addr_0_0_reg <= a_addr_0_0;
      a_addr_muxed_0_0_reg <= a_addr_muxed_0_0;
    end
  end
  assign a_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_0_0_reg;

  // BRAM matrix A 0_0
  ram matrix_A_0_0 (
    .addr0(a_addr_muxed_0_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_0_0),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;
  wire [`AWIDTH-1:0] a_addr_1_0;
  wire [`AWIDTH-1:0] a_addr_muxed_1_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_1_0_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_1_0_reg <= 0;
      a_addr_muxed_1_0_reg <= 0;
    end else begin
      a_addr_1_0_reg <= a_addr_1_0;
      a_addr_muxed_1_0_reg <= a_addr_muxed_1_0;
    end
  end
  assign a_addr_muxed_1_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_1_0_reg;

  // BRAM matrix A 1_0
  ram matrix_A_1_0 (
    .addr0(a_addr_muxed_1_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_1_0),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0;
  wire [`AWIDTH-1:0] a_addr_2_0;
  wire [`AWIDTH-1:0] a_addr_muxed_2_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_2_0_reg;
  reg  [`AWIDTH-1:0] a_addr_2_0_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_2_0_reg <= 0;
      a_addr_muxed_2_0_reg <= 0;
    end else begin
      a_addr_2_0_reg <= a_addr_2_0;
      a_addr_muxed_2_0_reg <= a_addr_muxed_2_0;
    end
  end
  assign a_addr_muxed_2_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_2_0_reg;

  // BRAM matrix A 2_0
  ram matrix_A_2_0 (
    .addr0(a_addr_muxed_2_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_2_0),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0;
  wire [`AWIDTH-1:0] a_addr_3_0;
  wire [`AWIDTH-1:0] a_addr_muxed_3_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_3_0_reg;
  reg  [`AWIDTH-1:0] a_addr_3_0_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_3_0_reg <= 0;
      a_addr_muxed_3_0_reg <= 0;
    end else begin
      a_addr_3_0_reg <= a_addr_3_0;
      a_addr_muxed_3_0_reg <= a_addr_muxed_3_0;
    end
  end
  assign a_addr_muxed_3_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_3_0_reg;

  // BRAM matrix A 3_0
  ram matrix_A_3_0 (
    .addr0(a_addr_muxed_3_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_3_0),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0;
  wire [`AWIDTH-1:0] a_addr_4_0;
  wire [`AWIDTH-1:0] a_addr_muxed_4_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_4_0_reg;
  reg  [`AWIDTH-1:0] a_addr_4_0_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_4_0_reg <= 0;
      a_addr_muxed_4_0_reg <= 0;
    end else begin
      a_addr_4_0_reg <= a_addr_4_0;
      a_addr_muxed_4_0_reg <= a_addr_muxed_4_0;
    end
  end
  assign a_addr_muxed_4_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_4_0_reg;

  // BRAM matrix A 4_0
  ram matrix_A_4_0 (
    .addr0(a_addr_muxed_4_0_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_4_0),
    .clk(clk));

/////////////////////////////////////////////////
// BRAMs to store matrix B
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  wire [`AWIDTH-1:0] b_addr_0_0;
  wire [`AWIDTH-1:0] b_addr_muxed_0_0;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_0_0_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_0_0_reg <= 0;
      b_addr_muxed_0_0_reg <= 0;
    end else begin
      b_addr_0_0_reg <= b_addr_0_0;
      b_addr_muxed_0_0_reg <= b_addr_muxed_0_0;
    end
  end
  assign b_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_0_reg;

  // BRAM matrix B 0_0
  ram matrix_B_0_0 (
    .addr0(b_addr_muxed_0_0_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_0),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  wire [`AWIDTH-1:0] b_addr_0_1;
  wire [`AWIDTH-1:0] b_addr_muxed_0_1;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_0_1_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_0_1_reg <= 0;
      b_addr_muxed_0_1_reg <= 0;
    end else begin
      b_addr_0_1_reg <= b_addr_0_1;
      b_addr_muxed_0_1_reg <= b_addr_muxed_0_1;
    end
  end
  assign b_addr_muxed_0_1 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_1_reg;

  // BRAM matrix B 0_1
  ram matrix_B_0_1 (
    .addr0(b_addr_muxed_0_1_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_1),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;
  wire [`AWIDTH-1:0] b_addr_0_2;
  wire [`AWIDTH-1:0] b_addr_muxed_0_2;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_2_reg;
  reg  [`AWIDTH-1:0] b_addr_0_2_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_0_2_reg <= 0;
      b_addr_muxed_0_2_reg <= 0;
    end else begin
      b_addr_0_2_reg <= b_addr_0_2;
      b_addr_muxed_0_2_reg <= b_addr_muxed_0_2;
    end
  end
  assign b_addr_muxed_0_2 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_2_reg;

  // BRAM matrix B 0_2
  ram matrix_B_0_2 (
    .addr0(b_addr_muxed_0_2_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_2),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3;
  wire [`AWIDTH-1:0] b_addr_0_3;
  wire [`AWIDTH-1:0] b_addr_muxed_0_3;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_3_reg;
  reg  [`AWIDTH-1:0] b_addr_0_3_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_0_3_reg <= 0;
      b_addr_muxed_0_3_reg <= 0;
    end else begin
      b_addr_0_3_reg <= b_addr_0_3;
      b_addr_muxed_0_3_reg <= b_addr_muxed_0_3;
    end
  end
  assign b_addr_muxed_0_3 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_3_reg;

  // BRAM matrix B 0_3
  ram matrix_B_0_3 (
    .addr0(b_addr_muxed_0_3_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_3),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4;
  wire [`AWIDTH-1:0] b_addr_0_4;
  wire [`AWIDTH-1:0] b_addr_muxed_0_4;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_4_reg;
  reg  [`AWIDTH-1:0] b_addr_0_4_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_0_4_reg <= 0;
      b_addr_muxed_0_4_reg <= 0;
    end else begin
      b_addr_0_4_reg <= b_addr_0_4;
      b_addr_muxed_0_4_reg <= b_addr_muxed_0_4;
    end
  end
  assign b_addr_muxed_0_4 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_4_reg;

  // BRAM matrix B 0_4
  ram matrix_B_0_4 (
    .addr0(b_addr_muxed_0_4_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_0_4),
    .clk(clk));

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  wire [`AWIDTH-1:0] c_addr_0_0;
  wire [`AWIDTH-1:0] c_addr_0_1;
  wire [`AWIDTH-1:0] c_addr_0_2;
  wire [`AWIDTH-1:0] c_addr_0_3;
  wire [`AWIDTH-1:0] c_addr_0_4;
  wire [`AWIDTH-1:0] c_addr_1_0;
  wire [`AWIDTH-1:0] c_addr_1_1;
  wire [`AWIDTH-1:0] c_addr_1_2;
  wire [`AWIDTH-1:0] c_addr_1_3;
  wire [`AWIDTH-1:0] c_addr_1_4;
  wire [`AWIDTH-1:0] c_addr_2_0;
  wire [`AWIDTH-1:0] c_addr_2_1;
  wire [`AWIDTH-1:0] c_addr_2_2;
  wire [`AWIDTH-1:0] c_addr_2_3;
  wire [`AWIDTH-1:0] c_addr_2_4;
  wire [`AWIDTH-1:0] c_addr_3_0;
  wire [`AWIDTH-1:0] c_addr_3_1;
  wire [`AWIDTH-1:0] c_addr_3_2;
  wire [`AWIDTH-1:0] c_addr_3_3;
  wire [`AWIDTH-1:0] c_addr_3_4;
  wire [`AWIDTH-1:0] c_addr_4_0;
  wire [`AWIDTH-1:0] c_addr_4_1;
  wire [`AWIDTH-1:0] c_addr_4_2;
  wire [`AWIDTH-1:0] c_addr_4_3;
  wire [`AWIDTH-1:0] c_addr_4_4;

  wire [`AWIDTH-1:0] c_addr_muxed_0_0;
  wire [`AWIDTH-1:0] c_addr_muxed_0_1;
  wire [`AWIDTH-1:0] c_addr_muxed_0_2;
  wire [`AWIDTH-1:0] c_addr_muxed_0_3;
  wire [`AWIDTH-1:0] c_addr_muxed_0_4;
  wire [`AWIDTH-1:0] c_addr_muxed_1_0;
  wire [`AWIDTH-1:0] c_addr_muxed_1_1;
  wire [`AWIDTH-1:0] c_addr_muxed_1_2;
  wire [`AWIDTH-1:0] c_addr_muxed_1_3;
  wire [`AWIDTH-1:0] c_addr_muxed_1_4;
  wire [`AWIDTH-1:0] c_addr_muxed_2_0;
  wire [`AWIDTH-1:0] c_addr_muxed_2_1;
  wire [`AWIDTH-1:0] c_addr_muxed_2_2;
  wire [`AWIDTH-1:0] c_addr_muxed_2_3;
  wire [`AWIDTH-1:0] c_addr_muxed_2_4;
  wire [`AWIDTH-1:0] c_addr_muxed_3_0;
  wire [`AWIDTH-1:0] c_addr_muxed_3_1;
  wire [`AWIDTH-1:0] c_addr_muxed_3_2;
  wire [`AWIDTH-1:0] c_addr_muxed_3_3;
  wire [`AWIDTH-1:0] c_addr_muxed_3_4;
  wire [`AWIDTH-1:0] c_addr_muxed_4_0;
  wire [`AWIDTH-1:0] c_addr_muxed_4_1;
  wire [`AWIDTH-1:0] c_addr_muxed_4_2;
  wire [`AWIDTH-1:0] c_addr_muxed_4_3;
  wire [`AWIDTH-1:0] c_addr_muxed_4_4;

  reg [`AWIDTH-1:0] c_addr_0_0_reg;
  reg [`AWIDTH-1:0] c_addr_0_1_reg;
  reg [`AWIDTH-1:0] c_addr_0_2_reg;
  reg [`AWIDTH-1:0] c_addr_0_3_reg;
  reg [`AWIDTH-1:0] c_addr_0_4_reg;
  reg [`AWIDTH-1:0] c_addr_1_0_reg;
  reg [`AWIDTH-1:0] c_addr_1_1_reg;
  reg [`AWIDTH-1:0] c_addr_1_2_reg;
  reg [`AWIDTH-1:0] c_addr_1_3_reg;
  reg [`AWIDTH-1:0] c_addr_1_4_reg;
  reg [`AWIDTH-1:0] c_addr_2_0_reg;
  reg [`AWIDTH-1:0] c_addr_2_1_reg;
  reg [`AWIDTH-1:0] c_addr_2_2_reg;
  reg [`AWIDTH-1:0] c_addr_2_3_reg;
  reg [`AWIDTH-1:0] c_addr_2_4_reg;
  reg [`AWIDTH-1:0] c_addr_3_0_reg;
  reg [`AWIDTH-1:0] c_addr_3_1_reg;
  reg [`AWIDTH-1:0] c_addr_3_2_reg;
  reg [`AWIDTH-1:0] c_addr_3_3_reg;
  reg [`AWIDTH-1:0] c_addr_3_4_reg;
  reg [`AWIDTH-1:0] c_addr_4_0_reg;
  reg [`AWIDTH-1:0] c_addr_4_1_reg;
  reg [`AWIDTH-1:0] c_addr_4_2_reg;
  reg [`AWIDTH-1:0] c_addr_4_3_reg;
  reg [`AWIDTH-1:0] c_addr_4_4_reg;

  reg [`AWIDTH-1:0] c_addr_muxed_0_0_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_0_1_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_0_2_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_0_3_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_0_4_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_1_0_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_1_1_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_1_2_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_1_3_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_1_4_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_2_0_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_2_1_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_2_2_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_2_3_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_2_4_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_3_0_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_3_1_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_3_2_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_3_3_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_3_4_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_4_0_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_4_1_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_4_2_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_4_3_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_4_4_reg;

  assign c_addr_muxed_0_0 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_0_0_reg;
  assign c_addr_muxed_0_1 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_0_1_reg;
  assign c_addr_muxed_0_2 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_0_2_reg;
  assign c_addr_muxed_0_3 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_0_3_reg;
  assign c_addr_muxed_0_4 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_0_4_reg;
  assign c_addr_muxed_1_0 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_1_0_reg;
  assign c_addr_muxed_1_1 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_1_1_reg;
  assign c_addr_muxed_1_2 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_1_2_reg;
  assign c_addr_muxed_1_3 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_1_3_reg;
  assign c_addr_muxed_1_4 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_1_4_reg;
  assign c_addr_muxed_2_0 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_2_0_reg;
  assign c_addr_muxed_2_1 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_2_1_reg;
  assign c_addr_muxed_2_2 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_2_2_reg;
  assign c_addr_muxed_2_3 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_2_3_reg;
  assign c_addr_muxed_2_4 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_2_4_reg;
  assign c_addr_muxed_3_0 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_3_0_reg;
  assign c_addr_muxed_3_1 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_3_1_reg;
  assign c_addr_muxed_3_2 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_3_2_reg;
  assign c_addr_muxed_3_3 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_3_3_reg;
  assign c_addr_muxed_3_4 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_3_4_reg;
  assign c_addr_muxed_4_0 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_4_0_reg;
  assign c_addr_muxed_4_1 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_4_1_reg;
  assign c_addr_muxed_4_2 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_4_2_reg;
  assign c_addr_muxed_4_3 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_4_3_reg;
  assign c_addr_muxed_4_4 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_4_4_reg;

  always @(posedge clk) begin
    if (reset) begin
      c_addr_0_0_reg <= 0;
      c_addr_0_1_reg <= 0;
      c_addr_0_2_reg <= 0;
      c_addr_0_3_reg <= 0;
      c_addr_0_4_reg <= 0;
      c_addr_1_0_reg <= 0;
      c_addr_1_1_reg <= 0;
      c_addr_1_2_reg <= 0;
      c_addr_1_3_reg <= 0;
      c_addr_1_4_reg <= 0;
      c_addr_2_0_reg <= 0;
      c_addr_2_1_reg <= 0;
      c_addr_2_2_reg <= 0;
      c_addr_2_3_reg <= 0;
      c_addr_2_4_reg <= 0;
      c_addr_3_0_reg <= 0;
      c_addr_3_1_reg <= 0;
      c_addr_3_2_reg <= 0;
      c_addr_3_3_reg <= 0;
      c_addr_3_4_reg <= 0;
      c_addr_4_0_reg <= 0;
      c_addr_4_1_reg <= 0;
      c_addr_4_2_reg <= 0;
      c_addr_4_3_reg <= 0;
      c_addr_4_4_reg <= 0;
       c_addr_muxed_0_0_reg <= 0;
       c_addr_muxed_0_1_reg <= 0;
       c_addr_muxed_0_2_reg <= 0;
       c_addr_muxed_0_3_reg <= 0;
       c_addr_muxed_0_4_reg <= 0;
       c_addr_muxed_1_0_reg <= 0;
       c_addr_muxed_1_1_reg <= 0;
       c_addr_muxed_1_2_reg <= 0;
       c_addr_muxed_1_3_reg <= 0;
       c_addr_muxed_1_4_reg <= 0;
       c_addr_muxed_2_0_reg <= 0;
       c_addr_muxed_2_1_reg <= 0;
       c_addr_muxed_2_2_reg <= 0;
       c_addr_muxed_2_3_reg <= 0;
       c_addr_muxed_2_4_reg <= 0;
       c_addr_muxed_3_0_reg <= 0;
       c_addr_muxed_3_1_reg <= 0;
       c_addr_muxed_3_2_reg <= 0;
       c_addr_muxed_3_3_reg <= 0;
       c_addr_muxed_3_4_reg <= 0;
       c_addr_muxed_4_0_reg <= 0;
       c_addr_muxed_4_1_reg <= 0;
       c_addr_muxed_4_2_reg <= 0;
       c_addr_muxed_4_3_reg <= 0;
       c_addr_muxed_4_4_reg <= 0;
    end else begin
      c_addr_0_0_reg <= c_addr_0_0;
      c_addr_0_1_reg <= c_addr_0_1;
      c_addr_0_2_reg <= c_addr_0_2;
      c_addr_0_3_reg <= c_addr_0_3;
      c_addr_0_4_reg <= c_addr_0_4;
      c_addr_1_0_reg <= c_addr_1_0;
      c_addr_1_1_reg <= c_addr_1_1;
      c_addr_1_2_reg <= c_addr_1_2;
      c_addr_1_3_reg <= c_addr_1_3;
      c_addr_1_4_reg <= c_addr_1_4;
      c_addr_2_0_reg <= c_addr_2_0;
      c_addr_2_1_reg <= c_addr_2_1;
      c_addr_2_2_reg <= c_addr_2_2;
      c_addr_2_3_reg <= c_addr_2_3;
      c_addr_2_4_reg <= c_addr_2_4;
      c_addr_3_0_reg <= c_addr_3_0;
      c_addr_3_1_reg <= c_addr_3_1;
      c_addr_3_2_reg <= c_addr_3_2;
      c_addr_3_3_reg <= c_addr_3_3;
      c_addr_3_4_reg <= c_addr_3_4;
      c_addr_4_0_reg <= c_addr_4_0;
      c_addr_4_1_reg <= c_addr_4_1;
      c_addr_4_2_reg <= c_addr_4_2;
      c_addr_4_3_reg <= c_addr_4_3;
      c_addr_4_4_reg <= c_addr_4_4;
      c_addr_muxed_0_0_reg <= c_addr_muxed_0_0;
      c_addr_muxed_0_1_reg <= c_addr_muxed_0_1;
      c_addr_muxed_0_2_reg <= c_addr_muxed_0_2;
      c_addr_muxed_0_3_reg <= c_addr_muxed_0_3;
      c_addr_muxed_0_4_reg <= c_addr_muxed_0_4;
      c_addr_muxed_1_0_reg <= c_addr_muxed_1_0;
      c_addr_muxed_1_1_reg <= c_addr_muxed_1_1;
      c_addr_muxed_1_2_reg <= c_addr_muxed_1_2;
      c_addr_muxed_1_3_reg <= c_addr_muxed_1_3;
      c_addr_muxed_1_4_reg <= c_addr_muxed_1_4;
      c_addr_muxed_2_0_reg <= c_addr_muxed_2_0;
      c_addr_muxed_2_1_reg <= c_addr_muxed_2_1;
      c_addr_muxed_2_2_reg <= c_addr_muxed_2_2;
      c_addr_muxed_2_3_reg <= c_addr_muxed_2_3;
      c_addr_muxed_2_4_reg <= c_addr_muxed_2_4;
      c_addr_muxed_3_0_reg <= c_addr_muxed_3_0;
      c_addr_muxed_3_1_reg <= c_addr_muxed_3_1;
      c_addr_muxed_3_2_reg <= c_addr_muxed_3_2;
      c_addr_muxed_3_3_reg <= c_addr_muxed_3_3;
      c_addr_muxed_3_4_reg <= c_addr_muxed_3_4;
      c_addr_muxed_4_0_reg <= c_addr_muxed_4_0;
      c_addr_muxed_4_1_reg <= c_addr_muxed_4_1;
      c_addr_muxed_4_2_reg <= c_addr_muxed_4_2;
      c_addr_muxed_4_3_reg <= c_addr_muxed_4_3;
      c_addr_muxed_4_4_reg <= c_addr_muxed_4_4;
    end
  end
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_1_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_1_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_1_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_1_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_2_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_2_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_2_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_2_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_2_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_3_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_3_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_3_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_3_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_3_4;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_4_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_4_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_4_2;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_4_3;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_4_4;

  assign data_from_out_mat =  data_from_out_mat_0_0 |
  data_from_out_mat_0_1 |
  data_from_out_mat_0_2 |
  data_from_out_mat_0_3 |
  data_from_out_mat_0_4 |
  data_from_out_mat_1_0 |
  data_from_out_mat_1_1 |
  data_from_out_mat_1_2 |
  data_from_out_mat_1_3 |
  data_from_out_mat_1_4 |
  data_from_out_mat_2_0 |
  data_from_out_mat_2_1 |
  data_from_out_mat_2_2 |
  data_from_out_mat_2_3 |
  data_from_out_mat_2_4 |
  data_from_out_mat_3_0 |
  data_from_out_mat_3_1 |
  data_from_out_mat_3_2 |
  data_from_out_mat_3_3 |
  data_from_out_mat_3_4 |
  data_from_out_mat_4_0 |
  data_from_out_mat_4_1 |
  data_from_out_mat_4_2 |
  data_from_out_mat_4_3 |
  data_from_out_mat_4_4 ;

  //  BRAM matrix C0_0
  ram matrix_c_0_0 (
    .addr0(c_addr_muxed_0_0_reg),
    .d0(c_data_0_0),
    .we0(we_c),
    .q0(data_from_out_mat_0_0),
    .clk(clk));

  //  BRAM matrix C0_1
  ram matrix_c_0_1 (
    .addr0(c_addr_muxed_0_1_reg),
    .d0(c_data_0_1),
    .we0(we_c),
    .q0(data_from_out_mat_0_1),
    .clk(clk));

  //  BRAM matrix C0_2
  ram matrix_c_0_2 (
    .addr0(c_addr_muxed_0_2_reg),
    .d0(c_data_0_2),
    .we0(we_c),
    .q0(data_from_out_mat_0_2),
    .clk(clk));

  //  BRAM matrix C0_3
  ram matrix_c_0_3 (
    .addr0(c_addr_muxed_0_3_reg),
    .d0(c_data_0_3),
    .we0(we_c),
    .q0(data_from_out_mat_0_3),
    .clk(clk));

  //  BRAM matrix C0_4
  ram matrix_c_0_4 (
    .addr0(c_addr_muxed_0_4_reg),
    .d0(c_data_0_4),
    .we0(we_c),
    .q0(data_from_out_mat_0_4),
    .clk(clk));

  //  BRAM matrix C1_0
  ram matrix_c_1_0 (
    .addr0(c_addr_muxed_1_0_reg),
    .d0(c_data_1_0),
    .we0(we_c),
    .q0(data_from_out_mat_1_0),
    .clk(clk));

  //  BRAM matrix C1_1
  ram matrix_c_1_1 (
    .addr0(c_addr_muxed_1_1_reg),
    .d0(c_data_1_1),
    .we0(we_c),
    .q0(data_from_out_mat_1_1),
    .clk(clk));

  //  BRAM matrix C1_2
  ram matrix_c_1_2 (
    .addr0(c_addr_muxed_1_2_reg),
    .d0(c_data_1_2),
    .we0(we_c),
    .q0(data_from_out_mat_1_2),
    .clk(clk));

  //  BRAM matrix C1_3
  ram matrix_c_1_3 (
    .addr0(c_addr_muxed_1_3_reg),
    .d0(c_data_1_3),
    .we0(we_c),
    .q0(data_from_out_mat_1_3),
    .clk(clk));

  //  BRAM matrix C1_4
  ram matrix_c_1_4 (
    .addr0(c_addr_muxed_1_4_reg),
    .d0(c_data_1_4),
    .we0(we_c),
    .q0(data_from_out_mat_1_4),
    .clk(clk));

  //  BRAM matrix C2_0
  ram matrix_c_2_0 (
    .addr0(c_addr_muxed_2_0_reg),
    .d0(c_data_2_0),
    .we0(we_c),
    .q0(data_from_out_mat_2_0),
    .clk(clk));

  //  BRAM matrix C2_1
  ram matrix_c_2_1 (
    .addr0(c_addr_muxed_2_1_reg),
    .d0(c_data_2_1),
    .we0(we_c),
    .q0(data_from_out_mat_2_1),
    .clk(clk));

  //  BRAM matrix C2_2
  ram matrix_c_2_2 (
    .addr0(c_addr_muxed_2_2_reg),
    .d0(c_data_2_2),
    .we0(we_c),
    .q0(data_from_out_mat_2_2),
    .clk(clk));

  //  BRAM matrix C2_3
  ram matrix_c_2_3 (
    .addr0(c_addr_muxed_2_3_reg),
    .d0(c_data_2_3),
    .we0(we_c),
    .q0(data_from_out_mat_2_3),
    .clk(clk));

  //  BRAM matrix C2_4
  ram matrix_c_2_4 (
    .addr0(c_addr_muxed_2_4_reg),
    .d0(c_data_2_4),
    .we0(we_c),
    .q0(data_from_out_mat_2_4),
    .clk(clk));

  //  BRAM matrix C3_0
  ram matrix_c_3_0 (
    .addr0(c_addr_muxed_3_0_reg),
    .d0(c_data_3_0),
    .we0(we_c),
    .q0(data_from_out_mat_3_0),
    .clk(clk));

  //  BRAM matrix C3_1
  ram matrix_c_3_1 (
    .addr0(c_addr_muxed_3_1_reg),
    .d0(c_data_3_1),
    .we0(we_c),
    .q0(data_from_out_mat_3_1),
    .clk(clk));

  //  BRAM matrix C3_2
  ram matrix_c_3_2 (
    .addr0(c_addr_muxed_3_2_reg),
    .d0(c_data_3_2),
    .we0(we_c),
    .q0(data_from_out_mat_3_2),
    .clk(clk));

  //  BRAM matrix C3_3
  ram matrix_c_3_3 (
    .addr0(c_addr_muxed_3_3_reg),
    .d0(c_data_3_3),
    .we0(we_c),
    .q0(data_from_out_mat_3_3),
    .clk(clk));

  //  BRAM matrix C3_4
  ram matrix_c_3_4 (
    .addr0(c_addr_muxed_3_4_reg),
    .d0(c_data_3_4),
    .we0(we_c),
    .q0(data_from_out_mat_3_4),
    .clk(clk));

  //  BRAM matrix C4_0
  ram matrix_c_4_0 (
    .addr0(c_addr_muxed_4_0_reg),
    .d0(c_data_4_0),
    .we0(we_c),
    .q0(data_from_out_mat_4_0),
    .clk(clk));

  //  BRAM matrix C4_1
  ram matrix_c_4_1 (
    .addr0(c_addr_muxed_4_1_reg),
    .d0(c_data_4_1),
    .we0(we_c),
    .q0(data_from_out_mat_4_1),
    .clk(clk));

  //  BRAM matrix C4_2
  ram matrix_c_4_2 (
    .addr0(c_addr_muxed_4_2_reg),
    .d0(c_data_4_2),
    .we0(we_c),
    .q0(data_from_out_mat_4_2),
    .clk(clk));

  //  BRAM matrix C4_3
  ram matrix_c_4_3 (
    .addr0(c_addr_muxed_4_3_reg),
    .d0(c_data_4_3),
    .we0(we_c),
    .q0(data_from_out_mat_4_3),
    .clk(clk));

  //  BRAM matrix C4_4
  ram matrix_c_4_4 (
    .addr0(c_addr_muxed_4_4_reg),
    .d0(c_data_4_4),
    .we0(we_c),
    .q0(data_from_out_mat_4_4),
    .clk(clk));

/////////////////////////////////////////////////
// The 20x20 matmul instantiation
/////////////////////////////////////////////////

matmul_20x20_systolic u_matmul_20x20_systolic (
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
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

  .c_data_0_0(c_data_0_0),
  .c_addr_0_0(c_addr_0_0),
  .c_data_0_1(c_data_0_1),
  .c_addr_0_1(c_addr_0_1),
  .c_data_0_2(c_data_0_2),
  .c_addr_0_2(c_addr_0_2),
  .c_data_0_3(c_data_0_3),
  .c_addr_0_3(c_addr_0_3),
  .c_data_0_4(c_data_0_4),
  .c_addr_0_4(c_addr_0_4),
  .c_data_1_0(c_data_1_0),
  .c_addr_1_0(c_addr_1_0),
  .c_data_1_1(c_data_1_1),
  .c_addr_1_1(c_addr_1_1),
  .c_data_1_2(c_data_1_2),
  .c_addr_1_2(c_addr_1_2),
  .c_data_1_3(c_data_1_3),
  .c_addr_1_3(c_addr_1_3),
  .c_data_1_4(c_data_1_4),
  .c_addr_1_4(c_addr_1_4),
  .c_data_2_0(c_data_2_0),
  .c_addr_2_0(c_addr_2_0),
  .c_data_2_1(c_data_2_1),
  .c_addr_2_1(c_addr_2_1),
  .c_data_2_2(c_data_2_2),
  .c_addr_2_2(c_addr_2_2),
  .c_data_2_3(c_data_2_3),
  .c_addr_2_3(c_addr_2_3),
  .c_data_2_4(c_data_2_4),
  .c_addr_2_4(c_addr_2_4),
  .c_data_3_0(c_data_3_0),
  .c_addr_3_0(c_addr_3_0),
  .c_data_3_1(c_data_3_1),
  .c_addr_3_1(c_addr_3_1),
  .c_data_3_2(c_data_3_2),
  .c_addr_3_2(c_addr_3_2),
  .c_data_3_3(c_data_3_3),
  .c_addr_3_3(c_addr_3_3),
  .c_data_3_4(c_data_3_4),
  .c_addr_3_4(c_addr_3_4),
  .c_data_4_0(c_data_4_0),
  .c_addr_4_0(c_addr_4_0),
  .c_data_4_1(c_data_4_1),
  .c_addr_4_1(c_addr_4_1),
  .c_data_4_2(c_data_4_2),
  .c_addr_4_2(c_addr_4_2),
  .c_data_4_3(c_data_4_3),
  .c_addr_4_3(c_addr_4_3),
  .c_data_4_4(c_data_4_4),
  .c_addr_4_4(c_addr_4_4)

);
endmodule


/////////////////////////////////////////////////
// The 20x20 matmul definition
/////////////////////////////////////////////////

module matmul_20x20_systolic(
  clk,
  reset,
  start_mat_mul,
  done_mat_mul,
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

  c_data_0_0,
  c_addr_0_0,
  c_data_0_1,
  c_addr_0_1,
  c_data_0_2,
  c_addr_0_2,
  c_data_0_3,
  c_addr_0_3,
  c_data_0_4,
  c_addr_0_4,
  c_data_1_0,
  c_addr_1_0,
  c_data_1_1,
  c_addr_1_1,
  c_data_1_2,
  c_addr_1_2,
  c_data_1_3,
  c_addr_1_3,
  c_data_1_4,
  c_addr_1_4,
  c_data_2_0,
  c_addr_2_0,
  c_data_2_1,
  c_addr_2_1,
  c_data_2_2,
  c_addr_2_2,
  c_data_2_3,
  c_addr_2_3,
  c_data_2_4,
  c_addr_2_4,
  c_data_3_0,
  c_addr_3_0,
  c_data_3_1,
  c_addr_3_1,
  c_data_3_2,
  c_addr_3_2,
  c_data_3_3,
  c_addr_3_3,
  c_data_3_4,
  c_addr_3_4,
  c_data_4_0,
  c_addr_4_0,
  c_data_4_1,
  c_addr_4_1,
  c_data_4_2,
  c_addr_4_2,
  c_data_4_3,
  c_addr_4_3,
  c_data_4_4,
  c_addr_4_4
);
  input clk;
  input reset;
  input start_mat_mul;
  output done_mat_mul;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_3;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_4;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_1_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_2_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_3_4;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_2;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_3;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_4_4;

  output [`AWIDTH-1:0] a_addr_0_0;
  output [`AWIDTH-1:0] a_addr_1_0;
  output [`AWIDTH-1:0] a_addr_2_0;
  output [`AWIDTH-1:0] a_addr_3_0;
  output [`AWIDTH-1:0] a_addr_4_0;

  output [`AWIDTH-1:0] b_addr_0_0;
  output [`AWIDTH-1:0] b_addr_0_1;
  output [`AWIDTH-1:0] b_addr_0_2;
  output [`AWIDTH-1:0] b_addr_0_3;
  output [`AWIDTH-1:0] b_addr_0_4;

  output [`AWIDTH-1:0] c_addr_0_0;
  output [`AWIDTH-1:0] c_addr_0_1;
  output [`AWIDTH-1:0] c_addr_0_2;
  output [`AWIDTH-1:0] c_addr_0_3;
  output [`AWIDTH-1:0] c_addr_0_4;
  output [`AWIDTH-1:0] c_addr_1_0;
  output [`AWIDTH-1:0] c_addr_1_1;
  output [`AWIDTH-1:0] c_addr_1_2;
  output [`AWIDTH-1:0] c_addr_1_3;
  output [`AWIDTH-1:0] c_addr_1_4;
  output [`AWIDTH-1:0] c_addr_2_0;
  output [`AWIDTH-1:0] c_addr_2_1;
  output [`AWIDTH-1:0] c_addr_2_2;
  output [`AWIDTH-1:0] c_addr_2_3;
  output [`AWIDTH-1:0] c_addr_2_4;
  output [`AWIDTH-1:0] c_addr_3_0;
  output [`AWIDTH-1:0] c_addr_3_1;
  output [`AWIDTH-1:0] c_addr_3_2;
  output [`AWIDTH-1:0] c_addr_3_3;
  output [`AWIDTH-1:0] c_addr_3_4;
  output [`AWIDTH-1:0] c_addr_4_0;
  output [`AWIDTH-1:0] c_addr_4_1;
  output [`AWIDTH-1:0] c_addr_4_2;
  output [`AWIDTH-1:0] c_addr_4_3;
  output [`AWIDTH-1:0] c_addr_4_4;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_0_0;
  wire done_mat_mul_0_1;
  wire done_mat_mul_0_2;
  wire done_mat_mul_0_3;
  wire done_mat_mul_0_4;
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;
  wire done_mat_mul_1_2;
  wire done_mat_mul_1_3;
  wire done_mat_mul_1_4;
  wire done_mat_mul_2_0;
  wire done_mat_mul_2_1;
  wire done_mat_mul_2_2;
  wire done_mat_mul_2_3;
  wire done_mat_mul_2_4;
  wire done_mat_mul_3_0;
  wire done_mat_mul_3_1;
  wire done_mat_mul_3_2;
  wire done_mat_mul_3_3;
  wire done_mat_mul_3_4;
  wire done_mat_mul_4_0;
  wire done_mat_mul_4_1;
  wire done_mat_mul_4_2;
  wire done_mat_mul_4_3;
  wire done_mat_mul_4_4;

  assign done_mat_mul =   done_mat_mul_0_0 &&
  done_mat_mul_0_1 &&
  done_mat_mul_0_2 &&
  done_mat_mul_0_3 &&
  done_mat_mul_0_4 &&
  done_mat_mul_1_0 &&
  done_mat_mul_1_1 &&
  done_mat_mul_1_2 &&
  done_mat_mul_1_3 &&
  done_mat_mul_1_4 &&
  done_mat_mul_2_0 &&
  done_mat_mul_2_1 &&
  done_mat_mul_2_2 &&
  done_mat_mul_2_3 &&
  done_mat_mul_2_4 &&
  done_mat_mul_3_0 &&
  done_mat_mul_3_1 &&
  done_mat_mul_3_2 &&
  done_mat_mul_3_3 &&
  done_mat_mul_3_4 &&
  done_mat_mul_4_0 &&
  done_mat_mul_4_1 &&
  done_mat_mul_4_2 &&
  done_mat_mul_4_3 &&
  done_mat_mul_4_4;

  /////////////////////////////////////////////////
  // Matmul 0_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_to_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_to_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_0_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_0_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_0),
  .a_data(a_data_0_0),
  .b_data(b_data_0_0),
  .a_data_in(a_data_in_0_0_NC),
  .b_data_in(b_data_in_0_0_NC),
  .c_data(c_data_0_0),
  .a_data_out(a_data_0_0_to_0_1),
  .b_data_out(b_data_0_0_to_1_0),
  .a_addr(a_addr_0_0),
  .b_addr(b_addr_0_0),
  .c_addr(c_addr_0_0),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_0_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_1),
  .a_data(a_data_0_1_NC),
  .b_data(b_data_0_1),
  .a_data_in(a_data_0_0_to_0_1),
  .b_data_in(b_data_in_0_1_NC),
  .c_data(c_data_0_1),
  .a_data_out(a_data_0_1_to_0_2),
  .b_data_out(b_data_0_1_to_1_1),
  .a_addr(a_addr_0_1_NC),
  .b_addr(b_addr_0_1),
  .c_addr(c_addr_0_1),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_0_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_2),
  .a_data(a_data_0_2_NC),
  .b_data(b_data_0_2),
  .a_data_in(a_data_0_1_to_0_2),
  .b_data_in(b_data_in_0_2_NC),
  .c_data(c_data_0_2),
  .a_data_out(a_data_0_2_to_0_3),
  .b_data_out(b_data_0_2_to_1_2),
  .a_addr(a_addr_0_2_NC),
  .b_addr(b_addr_0_2),
  .c_addr(c_addr_0_2),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_0_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_3),
  .a_data(a_data_0_3_NC),
  .b_data(b_data_0_3),
  .a_data_in(a_data_0_2_to_0_3),
  .b_data_in(b_data_in_0_3_NC),
  .c_data(c_data_0_3),
  .a_data_out(a_data_0_3_to_0_4),
  .b_data_out(b_data_0_3_to_1_3),
  .a_addr(a_addr_0_3_NC),
  .b_addr(b_addr_0_3),
  .c_addr(c_addr_0_3),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_0_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_4),
  .a_data(a_data_0_4_NC),
  .b_data(b_data_0_4),
  .a_data_in(a_data_0_3_to_0_4),
  .b_data_in(b_data_in_0_4_NC),
  .c_data(c_data_0_4),
  .a_data_out(a_data_0_4_to_0_5),
  .b_data_out(b_data_0_4_to_1_4),
  .a_addr(a_addr_0_4_NC),
  .b_addr(b_addr_0_4),
  .c_addr(c_addr_0_4),
  .final_mat_mul_size(8'd20),
  .a_loc(8'd0),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 1_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0_to_1_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_0_to_2_0;
  wire [`AWIDTH-1:0] b_addr_1_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_1_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_1_0_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_1_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_0),
  .a_data(a_data_1_0),
  .b_data(b_data_1_0_NC),
  .a_data_in(a_data_in_1_0_NC),
  .b_data_in(b_data_0_0_to_1_0),
  .c_data(c_data_1_0),
  .a_data_out(a_data_1_0_to_1_1),
  .b_data_out(b_data_1_0_to_2_0),
  .a_addr(a_addr_1_0),
  .b_addr(b_addr_1_0_NC),
  .c_addr(c_addr_1_0),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_1_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_1),
  .a_data(a_data_1_1_NC),
  .b_data(b_data_1_1_NC),
  .a_data_in(a_data_1_0_to_1_1),
  .b_data_in(b_data_0_1_to_1_1),
  .c_data(c_data_1_1),
  .a_data_out(a_data_1_1_to_1_2),
  .b_data_out(b_data_1_1_to_2_1),
  .a_addr(a_addr_1_1_NC),
  .b_addr(b_addr_1_1_NC),
  .c_addr(c_addr_1_1),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_1_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_2),
  .a_data(a_data_1_2_NC),
  .b_data(b_data_1_2_NC),
  .a_data_in(a_data_1_1_to_1_2),
  .b_data_in(b_data_0_2_to_1_2),
  .c_data(c_data_1_2),
  .a_data_out(a_data_1_2_to_1_3),
  .b_data_out(b_data_1_2_to_2_2),
  .a_addr(a_addr_1_2_NC),
  .b_addr(b_addr_1_2_NC),
  .c_addr(c_addr_1_2),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_1_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_3),
  .a_data(a_data_1_3_NC),
  .b_data(b_data_1_3_NC),
  .a_data_in(a_data_1_2_to_1_3),
  .b_data_in(b_data_0_3_to_1_3),
  .c_data(c_data_1_3),
  .a_data_out(a_data_1_3_to_1_4),
  .b_data_out(b_data_1_3_to_2_3),
  .a_addr(a_addr_1_3_NC),
  .b_addr(b_addr_1_3_NC),
  .c_addr(c_addr_1_3),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_1_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_4),
  .a_data(a_data_1_4_NC),
  .b_data(b_data_1_4_NC),
  .a_data_in(a_data_1_3_to_1_4),
  .b_data_in(b_data_0_4_to_1_4),
  .c_data(c_data_1_4),
  .a_data_out(a_data_1_4_to_1_5),
  .b_data_out(b_data_1_4_to_2_4),
  .a_addr(a_addr_1_4_NC),
  .b_addr(b_addr_1_4_NC),
  .c_addr(c_addr_1_4),
  .final_mat_mul_size(8'd20),
  .a_loc(8'd1),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 2_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0_to_2_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_0_to_3_0;
  wire [`AWIDTH-1:0] b_addr_2_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_2_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_2_0_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_2_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_0),
  .a_data(a_data_2_0),
  .b_data(b_data_2_0_NC),
  .a_data_in(a_data_in_2_0_NC),
  .b_data_in(b_data_1_0_to_2_0),
  .c_data(c_data_2_0),
  .a_data_out(a_data_2_0_to_2_1),
  .b_data_out(b_data_2_0_to_3_0),
  .a_addr(a_addr_2_0),
  .b_addr(b_addr_2_0_NC),
  .c_addr(c_addr_2_0),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_2_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_1),
  .a_data(a_data_2_1_NC),
  .b_data(b_data_2_1_NC),
  .a_data_in(a_data_2_0_to_2_1),
  .b_data_in(b_data_1_1_to_2_1),
  .c_data(c_data_2_1),
  .a_data_out(a_data_2_1_to_2_2),
  .b_data_out(b_data_2_1_to_3_1),
  .a_addr(a_addr_2_1_NC),
  .b_addr(b_addr_2_1_NC),
  .c_addr(c_addr_2_1),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_2_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_2),
  .a_data(a_data_2_2_NC),
  .b_data(b_data_2_2_NC),
  .a_data_in(a_data_2_1_to_2_2),
  .b_data_in(b_data_1_2_to_2_2),
  .c_data(c_data_2_2),
  .a_data_out(a_data_2_2_to_2_3),
  .b_data_out(b_data_2_2_to_3_2),
  .a_addr(a_addr_2_2_NC),
  .b_addr(b_addr_2_2_NC),
  .c_addr(c_addr_2_2),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_2_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_3),
  .a_data(a_data_2_3_NC),
  .b_data(b_data_2_3_NC),
  .a_data_in(a_data_2_2_to_2_3),
  .b_data_in(b_data_1_3_to_2_3),
  .c_data(c_data_2_3),
  .a_data_out(a_data_2_3_to_2_4),
  .b_data_out(b_data_2_3_to_3_3),
  .a_addr(a_addr_2_3_NC),
  .b_addr(b_addr_2_3_NC),
  .c_addr(c_addr_2_3),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_2_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_4),
  .a_data(a_data_2_4_NC),
  .b_data(b_data_2_4_NC),
  .a_data_in(a_data_2_3_to_2_4),
  .b_data_in(b_data_1_4_to_2_4),
  .c_data(c_data_2_4),
  .a_data_out(a_data_2_4_to_2_5),
  .b_data_out(b_data_2_4_to_3_4),
  .a_addr(a_addr_2_4_NC),
  .b_addr(b_addr_2_4_NC),
  .c_addr(c_addr_2_4),
  .final_mat_mul_size(8'd20),
  .a_loc(8'd2),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 3_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_3_0_to_3_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_0_to_4_0;
  wire [`AWIDTH-1:0] b_addr_3_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_3_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_3_0_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_3_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_0),
  .a_data(a_data_3_0),
  .b_data(b_data_3_0_NC),
  .a_data_in(a_data_in_3_0_NC),
  .b_data_in(b_data_2_0_to_3_0),
  .c_data(c_data_3_0),
  .a_data_out(a_data_3_0_to_3_1),
  .b_data_out(b_data_3_0_to_4_0),
  .a_addr(a_addr_3_0),
  .b_addr(b_addr_3_0_NC),
  .c_addr(c_addr_3_0),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_3_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_1),
  .a_data(a_data_3_1_NC),
  .b_data(b_data_3_1_NC),
  .a_data_in(a_data_3_0_to_3_1),
  .b_data_in(b_data_2_1_to_3_1),
  .c_data(c_data_3_1),
  .a_data_out(a_data_3_1_to_3_2),
  .b_data_out(b_data_3_1_to_4_1),
  .a_addr(a_addr_3_1_NC),
  .b_addr(b_addr_3_1_NC),
  .c_addr(c_addr_3_1),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_3_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_2),
  .a_data(a_data_3_2_NC),
  .b_data(b_data_3_2_NC),
  .a_data_in(a_data_3_1_to_3_2),
  .b_data_in(b_data_2_2_to_3_2),
  .c_data(c_data_3_2),
  .a_data_out(a_data_3_2_to_3_3),
  .b_data_out(b_data_3_2_to_4_2),
  .a_addr(a_addr_3_2_NC),
  .b_addr(b_addr_3_2_NC),
  .c_addr(c_addr_3_2),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_3_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_3),
  .a_data(a_data_3_3_NC),
  .b_data(b_data_3_3_NC),
  .a_data_in(a_data_3_2_to_3_3),
  .b_data_in(b_data_2_3_to_3_3),
  .c_data(c_data_3_3),
  .a_data_out(a_data_3_3_to_3_4),
  .b_data_out(b_data_3_3_to_4_3),
  .a_addr(a_addr_3_3_NC),
  .b_addr(b_addr_3_3_NC),
  .c_addr(c_addr_3_3),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_3_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_3_4),
  .a_data(a_data_3_4_NC),
  .b_data(b_data_3_4_NC),
  .a_data_in(a_data_3_3_to_3_4),
  .b_data_in(b_data_2_4_to_3_4),
  .c_data(c_data_3_4),
  .a_data_out(a_data_3_4_to_3_5),
  .b_data_out(b_data_3_4_to_4_4),
  .a_addr(a_addr_3_4_NC),
  .b_addr(b_addr_3_4_NC),
  .c_addr(c_addr_3_4),
  .final_mat_mul_size(8'd20),
  .a_loc(8'd3),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 4_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_4_0_to_4_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_0_to_5_0;
  wire [`AWIDTH-1:0] b_addr_4_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_4_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_4_0_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_4_0(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_0),
  .a_data(a_data_4_0),
  .b_data(b_data_4_0_NC),
  .a_data_in(a_data_in_4_0_NC),
  .b_data_in(b_data_3_0_to_4_0),
  .c_data(c_data_4_0),
  .a_data_out(a_data_4_0_to_4_1),
  .b_data_out(b_data_4_0_to_5_0),
  .a_addr(a_addr_4_0),
  .b_addr(b_addr_4_0_NC),
  .c_addr(c_addr_4_0),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_4_1(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_1),
  .a_data(a_data_4_1_NC),
  .b_data(b_data_4_1_NC),
  .a_data_in(a_data_4_0_to_4_1),
  .b_data_in(b_data_3_1_to_4_1),
  .c_data(c_data_4_1),
  .a_data_out(a_data_4_1_to_4_2),
  .b_data_out(b_data_4_1_to_5_1),
  .a_addr(a_addr_4_1_NC),
  .b_addr(b_addr_4_1_NC),
  .c_addr(c_addr_4_1),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_4_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_2),
  .a_data(a_data_4_2_NC),
  .b_data(b_data_4_2_NC),
  .a_data_in(a_data_4_1_to_4_2),
  .b_data_in(b_data_3_2_to_4_2),
  .c_data(c_data_4_2),
  .a_data_out(a_data_4_2_to_4_3),
  .b_data_out(b_data_4_2_to_5_2),
  .a_addr(a_addr_4_2_NC),
  .b_addr(b_addr_4_2_NC),
  .c_addr(c_addr_4_2),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_4_3(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_3),
  .a_data(a_data_4_3_NC),
  .b_data(b_data_4_3_NC),
  .a_data_in(a_data_4_2_to_4_3),
  .b_data_in(b_data_3_3_to_4_3),
  .c_data(c_data_4_3),
  .a_data_out(a_data_4_3_to_4_4),
  .b_data_out(b_data_4_3_to_5_3),
  .a_addr(a_addr_4_3_NC),
  .b_addr(b_addr_4_3_NC),
  .c_addr(c_addr_4_3),
  .final_mat_mul_size(8'd20),
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

matmul_4x4_systolic u_matmul_4x4_systolic_4_4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_4_4),
  .a_data(a_data_4_4_NC),
  .b_data(b_data_4_4_NC),
  .a_data_in(a_data_4_3_to_4_4),
  .b_data_in(b_data_3_4_to_4_4),
  .c_data(c_data_4_4),
  .a_data_out(a_data_4_4_to_4_5),
  .b_data_out(b_data_4_4_to_5_4),
  .a_addr(a_addr_4_4_NC),
  .b_addr(b_addr_4_4_NC),
  .c_addr(c_addr_4_4),
  .final_mat_mul_size(8'd20),
  .a_loc(8'd4),
  .b_loc(8'd4)
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