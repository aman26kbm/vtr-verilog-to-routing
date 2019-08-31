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

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  wire [`AWIDTH-1:0] a_addr_00;
  wire [`AWIDTH-1:0] a_addr_muxed_00;

  reg  [`AWIDTH-1:0] a_addr_muxed_00_reg;
  reg  [`AWIDTH-1:0] a_addr_00_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_00_reg <= 0;
      a_addr_muxed_00_reg <= 0;
    end else begin
      a_addr_00_reg <= a_addr_00;
      a_addr_muxed_00_reg <= a_addr_muxed_00;
    end
  end
  assign a_addr_muxed_00 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_00_reg;

  // BRAM matrix A 00
  ram matrix_A_00 (
    .addr0(a_addr_muxed_00_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_00),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10;
  wire [`AWIDTH-1:0] a_addr_10;
  wire [`AWIDTH-1:0] a_addr_muxed_10;

  reg  [`AWIDTH-1:0] a_addr_muxed_10_reg;
  reg  [`AWIDTH-1:0] a_addr_10_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_10_reg <= 0;
      a_addr_muxed_10_reg <= 0;
    end else begin
      a_addr_10_reg <= a_addr_10;
      a_addr_muxed_10_reg <= a_addr_muxed_10;
    end
  end
  assign a_addr_muxed_10 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_10_reg;

  // BRAM matrix A 10
  ram matrix_A_10 (
    .addr0(a_addr_muxed_10_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_10),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20;
  wire [`AWIDTH-1:0] a_addr_20;
  wire [`AWIDTH-1:0] a_addr_muxed_20;

  reg  [`AWIDTH-1:0] a_addr_muxed_20_reg;
  reg  [`AWIDTH-1:0] a_addr_20_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_20_reg <= 0;
      a_addr_muxed_20_reg <= 0;
    end else begin
      a_addr_20_reg <= a_addr_20;
      a_addr_muxed_20_reg <= a_addr_muxed_20;
    end
  end
  assign a_addr_muxed_20 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_20_reg;

  // BRAM matrix A 20
  ram matrix_A_20 (
    .addr0(a_addr_muxed_20_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_20),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_30;
  wire [`AWIDTH-1:0] a_addr_30;
  wire [`AWIDTH-1:0] a_addr_muxed_30;

  reg  [`AWIDTH-1:0] a_addr_muxed_30_reg;
  reg  [`AWIDTH-1:0] a_addr_30_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_30_reg <= 0;
      a_addr_muxed_30_reg <= 0;
    end else begin
      a_addr_30_reg <= a_addr_30;
      a_addr_muxed_30_reg <= a_addr_muxed_30;
    end
  end
  assign a_addr_muxed_30 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_30_reg;

  // BRAM matrix A 30
  ram matrix_A_30 (
    .addr0(a_addr_muxed_30_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_30),
    .clk(clk));

/////////////////////////////////////////////////
// BRAMs to store matrix B
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  wire [`AWIDTH-1:0] b_addr_00;
  wire [`AWIDTH-1:0] b_addr_muxed_00;

  reg  [`AWIDTH-1:0] b_addr_muxed_00_reg;
  reg  [`AWIDTH-1:0] b_addr_00_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_00_reg <= 0;
      b_addr_muxed_00_reg <= 0;
    end else begin
      b_addr_00_reg <= b_addr_00;
      b_addr_muxed_00_reg <= b_addr_muxed_00;
    end
  end
  assign b_addr_muxed_00 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_00_reg;

  // BRAM matrix B 00
  ram matrix_B_00 (
    .addr0(b_addr_muxed_00_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_00),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01;
  wire [`AWIDTH-1:0] b_addr_01;
  wire [`AWIDTH-1:0] b_addr_muxed_01;

  reg  [`AWIDTH-1:0] b_addr_muxed_01_reg;
  reg  [`AWIDTH-1:0] b_addr_01_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_01_reg <= 0;
      b_addr_muxed_01_reg <= 0;
    end else begin
      b_addr_01_reg <= b_addr_01;
      b_addr_muxed_01_reg <= b_addr_muxed_01;
    end
  end
  assign b_addr_muxed_01 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_01_reg;

  // BRAM matrix B 01
  ram matrix_B_01 (
    .addr0(b_addr_muxed_01_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_01),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02;
  wire [`AWIDTH-1:0] b_addr_02;
  wire [`AWIDTH-1:0] b_addr_muxed_02;

  reg  [`AWIDTH-1:0] b_addr_muxed_02_reg;
  reg  [`AWIDTH-1:0] b_addr_02_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_02_reg <= 0;
      b_addr_muxed_02_reg <= 0;
    end else begin
      b_addr_02_reg <= b_addr_02;
      b_addr_muxed_02_reg <= b_addr_muxed_02;
    end
  end
  assign b_addr_muxed_02 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_02_reg;

  // BRAM matrix B 02
  ram matrix_B_02 (
    .addr0(b_addr_muxed_02_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_02),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_03;
  wire [`AWIDTH-1:0] b_addr_03;
  wire [`AWIDTH-1:0] b_addr_muxed_03;

  reg  [`AWIDTH-1:0] b_addr_muxed_03_reg;
  reg  [`AWIDTH-1:0] b_addr_03_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_03_reg <= 0;
      b_addr_muxed_03_reg <= 0;
    end else begin
      b_addr_03_reg <= b_addr_03;
      b_addr_muxed_03_reg <= b_addr_muxed_03;
    end
  end
  assign b_addr_muxed_03 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_03_reg;

  // BRAM matrix B 03
  ram matrix_B_03 (
    .addr0(b_addr_muxed_03_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_03),
    .clk(clk));

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  wire [`AWIDTH-1:0] c_addr_00;
  wire [`AWIDTH-1:0] c_addr_01;
  wire [`AWIDTH-1:0] c_addr_02;
  wire [`AWIDTH-1:0] c_addr_03;
  wire [`AWIDTH-1:0] c_addr_10;
  wire [`AWIDTH-1:0] c_addr_11;
  wire [`AWIDTH-1:0] c_addr_12;
  wire [`AWIDTH-1:0] c_addr_13;
  wire [`AWIDTH-1:0] c_addr_20;
  wire [`AWIDTH-1:0] c_addr_21;
  wire [`AWIDTH-1:0] c_addr_22;
  wire [`AWIDTH-1:0] c_addr_23;
  wire [`AWIDTH-1:0] c_addr_30;
  wire [`AWIDTH-1:0] c_addr_31;
  wire [`AWIDTH-1:0] c_addr_32;
  wire [`AWIDTH-1:0] c_addr_33;

  wire [`AWIDTH-1:0] c_addr_muxed_00;
  wire [`AWIDTH-1:0] c_addr_muxed_01;
  wire [`AWIDTH-1:0] c_addr_muxed_02;
  wire [`AWIDTH-1:0] c_addr_muxed_03;
  wire [`AWIDTH-1:0] c_addr_muxed_10;
  wire [`AWIDTH-1:0] c_addr_muxed_11;
  wire [`AWIDTH-1:0] c_addr_muxed_12;
  wire [`AWIDTH-1:0] c_addr_muxed_13;
  wire [`AWIDTH-1:0] c_addr_muxed_20;
  wire [`AWIDTH-1:0] c_addr_muxed_21;
  wire [`AWIDTH-1:0] c_addr_muxed_22;
  wire [`AWIDTH-1:0] c_addr_muxed_23;
  wire [`AWIDTH-1:0] c_addr_muxed_30;
  wire [`AWIDTH-1:0] c_addr_muxed_31;
  wire [`AWIDTH-1:0] c_addr_muxed_32;
  wire [`AWIDTH-1:0] c_addr_muxed_33;

  reg [`AWIDTH-1:0] c_addr_00_reg;
  reg [`AWIDTH-1:0] c_addr_01_reg;
  reg [`AWIDTH-1:0] c_addr_02_reg;
  reg [`AWIDTH-1:0] c_addr_03_reg;
  reg [`AWIDTH-1:0] c_addr_10_reg;
  reg [`AWIDTH-1:0] c_addr_11_reg;
  reg [`AWIDTH-1:0] c_addr_12_reg;
  reg [`AWIDTH-1:0] c_addr_13_reg;
  reg [`AWIDTH-1:0] c_addr_20_reg;
  reg [`AWIDTH-1:0] c_addr_21_reg;
  reg [`AWIDTH-1:0] c_addr_22_reg;
  reg [`AWIDTH-1:0] c_addr_23_reg;
  reg [`AWIDTH-1:0] c_addr_30_reg;
  reg [`AWIDTH-1:0] c_addr_31_reg;
  reg [`AWIDTH-1:0] c_addr_32_reg;
  reg [`AWIDTH-1:0] c_addr_33_reg;

  reg [`AWIDTH-1:0] c_addr_muxed_00_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_01_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_02_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_03_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_10_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_11_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_12_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_13_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_20_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_21_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_22_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_23_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_30_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_31_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_32_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_33_reg;

  assign c_addr_muxed_00 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_00_reg;
  assign c_addr_muxed_01 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_01_reg;
  assign c_addr_muxed_02 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_02_reg;
  assign c_addr_muxed_03 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_03_reg;
  assign c_addr_muxed_10 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_10_reg;
  assign c_addr_muxed_11 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_11_reg;
  assign c_addr_muxed_12 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_12_reg;
  assign c_addr_muxed_13 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_13_reg;
  assign c_addr_muxed_20 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_20_reg;
  assign c_addr_muxed_21 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_21_reg;
  assign c_addr_muxed_22 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_22_reg;
  assign c_addr_muxed_23 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_23_reg;
  assign c_addr_muxed_30 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_30_reg;
  assign c_addr_muxed_31 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_31_reg;
  assign c_addr_muxed_32 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_32_reg;
  assign c_addr_muxed_33 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_33_reg;

  always @(posedge clk) begin
    if (reset) begin
      c_addr_00_reg <= 0;
      c_addr_01_reg <= 0;
      c_addr_02_reg <= 0;
      c_addr_03_reg <= 0;
      c_addr_10_reg <= 0;
      c_addr_11_reg <= 0;
      c_addr_12_reg <= 0;
      c_addr_13_reg <= 0;
      c_addr_20_reg <= 0;
      c_addr_21_reg <= 0;
      c_addr_22_reg <= 0;
      c_addr_23_reg <= 0;
      c_addr_30_reg <= 0;
      c_addr_31_reg <= 0;
      c_addr_32_reg <= 0;
      c_addr_33_reg <= 0;
       c_addr_muxed_00_reg <= 0;
       c_addr_muxed_01_reg <= 0;
       c_addr_muxed_02_reg <= 0;
       c_addr_muxed_03_reg <= 0;
       c_addr_muxed_10_reg <= 0;
       c_addr_muxed_11_reg <= 0;
       c_addr_muxed_12_reg <= 0;
       c_addr_muxed_13_reg <= 0;
       c_addr_muxed_20_reg <= 0;
       c_addr_muxed_21_reg <= 0;
       c_addr_muxed_22_reg <= 0;
       c_addr_muxed_23_reg <= 0;
       c_addr_muxed_30_reg <= 0;
       c_addr_muxed_31_reg <= 0;
       c_addr_muxed_32_reg <= 0;
       c_addr_muxed_33_reg <= 0;
    end else begin
      c_addr_00_reg <= c_addr_00;
      c_addr_01_reg <= c_addr_01;
      c_addr_02_reg <= c_addr_02;
      c_addr_03_reg <= c_addr_03;
      c_addr_10_reg <= c_addr_10;
      c_addr_11_reg <= c_addr_11;
      c_addr_12_reg <= c_addr_12;
      c_addr_13_reg <= c_addr_13;
      c_addr_20_reg <= c_addr_20;
      c_addr_21_reg <= c_addr_21;
      c_addr_22_reg <= c_addr_22;
      c_addr_23_reg <= c_addr_23;
      c_addr_30_reg <= c_addr_30;
      c_addr_31_reg <= c_addr_31;
      c_addr_32_reg <= c_addr_32;
      c_addr_33_reg <= c_addr_33;
      c_addr_muxed_00_reg <= c_addr_muxed_00;
      c_addr_muxed_01_reg <= c_addr_muxed_01;
      c_addr_muxed_02_reg <= c_addr_muxed_02;
      c_addr_muxed_03_reg <= c_addr_muxed_03;
      c_addr_muxed_10_reg <= c_addr_muxed_10;
      c_addr_muxed_11_reg <= c_addr_muxed_11;
      c_addr_muxed_12_reg <= c_addr_muxed_12;
      c_addr_muxed_13_reg <= c_addr_muxed_13;
      c_addr_muxed_20_reg <= c_addr_muxed_20;
      c_addr_muxed_21_reg <= c_addr_muxed_21;
      c_addr_muxed_22_reg <= c_addr_muxed_22;
      c_addr_muxed_23_reg <= c_addr_muxed_23;
      c_addr_muxed_30_reg <= c_addr_muxed_30;
      c_addr_muxed_31_reg <= c_addr_muxed_31;
      c_addr_muxed_32_reg <= c_addr_muxed_32;
      c_addr_muxed_33_reg <= c_addr_muxed_33;
    end
  end
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_03;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_23;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_30;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_31;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_32;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_33;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_00;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_02;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_03;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_20;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_21;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_22;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_23;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_30;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_31;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_32;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_33;

  assign data_from_out_mat =  data_from_out_mat_00 |
  data_from_out_mat_01 |
  data_from_out_mat_02 |
  data_from_out_mat_03 |
  data_from_out_mat_10 |
  data_from_out_mat_11 |
  data_from_out_mat_12 |
  data_from_out_mat_13 |
  data_from_out_mat_20 |
  data_from_out_mat_21 |
  data_from_out_mat_22 |
  data_from_out_mat_23 |
  data_from_out_mat_30 |
  data_from_out_mat_31 |
  data_from_out_mat_32 |
  data_from_out_mat_33 ;

  //  BRAM matrix C00
  ram matrix_c_00 (
    .addr0(c_addr_muxed_00_reg),
    .d0(c_data_00),
    .we0(we_c),
    .q0(data_from_out_mat_00),
    .clk(clk));

  //  BRAM matrix C01
  ram matrix_c_01 (
    .addr0(c_addr_muxed_01_reg),
    .d0(c_data_01),
    .we0(we_c),
    .q0(data_from_out_mat_01),
    .clk(clk));

  //  BRAM matrix C02
  ram matrix_c_02 (
    .addr0(c_addr_muxed_02_reg),
    .d0(c_data_02),
    .we0(we_c),
    .q0(data_from_out_mat_02),
    .clk(clk));

  //  BRAM matrix C03
  ram matrix_c_03 (
    .addr0(c_addr_muxed_03_reg),
    .d0(c_data_03),
    .we0(we_c),
    .q0(data_from_out_mat_03),
    .clk(clk));

  //  BRAM matrix C10
  ram matrix_c_10 (
    .addr0(c_addr_muxed_10_reg),
    .d0(c_data_10),
    .we0(we_c),
    .q0(data_from_out_mat_10),
    .clk(clk));

  //  BRAM matrix C11
  ram matrix_c_11 (
    .addr0(c_addr_muxed_11_reg),
    .d0(c_data_11),
    .we0(we_c),
    .q0(data_from_out_mat_11),
    .clk(clk));

  //  BRAM matrix C12
  ram matrix_c_12 (
    .addr0(c_addr_muxed_12_reg),
    .d0(c_data_12),
    .we0(we_c),
    .q0(data_from_out_mat_12),
    .clk(clk));

  //  BRAM matrix C13
  ram matrix_c_13 (
    .addr0(c_addr_muxed_13_reg),
    .d0(c_data_13),
    .we0(we_c),
    .q0(data_from_out_mat_13),
    .clk(clk));

  //  BRAM matrix C20
  ram matrix_c_20 (
    .addr0(c_addr_muxed_20_reg),
    .d0(c_data_20),
    .we0(we_c),
    .q0(data_from_out_mat_20),
    .clk(clk));

  //  BRAM matrix C21
  ram matrix_c_21 (
    .addr0(c_addr_muxed_21_reg),
    .d0(c_data_21),
    .we0(we_c),
    .q0(data_from_out_mat_21),
    .clk(clk));

  //  BRAM matrix C22
  ram matrix_c_22 (
    .addr0(c_addr_muxed_22_reg),
    .d0(c_data_22),
    .we0(we_c),
    .q0(data_from_out_mat_22),
    .clk(clk));

  //  BRAM matrix C23
  ram matrix_c_23 (
    .addr0(c_addr_muxed_23_reg),
    .d0(c_data_23),
    .we0(we_c),
    .q0(data_from_out_mat_23),
    .clk(clk));

  //  BRAM matrix C30
  ram matrix_c_30 (
    .addr0(c_addr_muxed_30_reg),
    .d0(c_data_30),
    .we0(we_c),
    .q0(data_from_out_mat_30),
    .clk(clk));

  //  BRAM matrix C31
  ram matrix_c_31 (
    .addr0(c_addr_muxed_31_reg),
    .d0(c_data_31),
    .we0(we_c),
    .q0(data_from_out_mat_31),
    .clk(clk));

  //  BRAM matrix C32
  ram matrix_c_32 (
    .addr0(c_addr_muxed_32_reg),
    .d0(c_data_32),
    .we0(we_c),
    .q0(data_from_out_mat_32),
    .clk(clk));

  //  BRAM matrix C33
  ram matrix_c_33 (
    .addr0(c_addr_muxed_33_reg),
    .d0(c_data_33),
    .we0(we_c),
    .q0(data_from_out_mat_33),
    .clk(clk));

/////////////////////////////////////////////////
// The 16x16 matmul instantiation
/////////////////////////////////////////////////

matmul_16x16_systolic u_matmul_16x16_systolic (
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
  .a_data_00(a_data_00),
  .a_addr_00(a_addr_00),
  .b_data_00(b_data_00),
  .b_addr_00(b_addr_00),
  .a_data_10(a_data_10),
  .a_addr_10(a_addr_10),
  .b_data_01(b_data_01),
  .b_addr_01(b_addr_01),
  .a_data_20(a_data_20),
  .a_addr_20(a_addr_20),
  .b_data_02(b_data_02),
  .b_addr_02(b_addr_02),
  .a_data_30(a_data_30),
  .a_addr_30(a_addr_30),
  .b_data_03(b_data_03),
  .b_addr_03(b_addr_03),

  .c_data_00(c_data_00),
  .c_addr_00(c_addr_00),
  .c_data_01(c_data_01),
  .c_addr_01(c_addr_01),
  .c_data_02(c_data_02),
  .c_addr_02(c_addr_02),
  .c_data_03(c_data_03),
  .c_addr_03(c_addr_03),
  .c_data_10(c_data_10),
  .c_addr_10(c_addr_10),
  .c_data_11(c_data_11),
  .c_addr_11(c_addr_11),
  .c_data_12(c_data_12),
  .c_addr_12(c_addr_12),
  .c_data_13(c_data_13),
  .c_addr_13(c_addr_13),
  .c_data_20(c_data_20),
  .c_addr_20(c_addr_20),
  .c_data_21(c_data_21),
  .c_addr_21(c_addr_21),
  .c_data_22(c_data_22),
  .c_addr_22(c_addr_22),
  .c_data_23(c_data_23),
  .c_addr_23(c_addr_23),
  .c_data_30(c_data_30),
  .c_addr_30(c_addr_30),
  .c_data_31(c_data_31),
  .c_addr_31(c_addr_31),
  .c_data_32(c_data_32),
  .c_addr_32(c_addr_32),
  .c_data_33(c_data_33),
  .c_addr_33(c_addr_33)

);
endmodule


/////////////////////////////////////////////////
// The 16x16 matmul definition
/////////////////////////////////////////////////

module matmul_16x16_systolic(
  clk,
  reset,
  start_mat_mul,
  done_mat_mul,
  a_data_00,
  a_addr_00,
  b_data_00,
  b_addr_00,
  a_data_10,
  a_addr_10,
  b_data_01,
  b_addr_01,
  a_data_20,
  a_addr_20,
  b_data_02,
  b_addr_02,
  a_data_30,
  a_addr_30,
  b_data_03,
  b_addr_03,

  c_data_00,
  c_addr_00,
  c_data_01,
  c_addr_01,
  c_data_02,
  c_addr_02,
  c_data_03,
  c_addr_03,
  c_data_10,
  c_addr_10,
  c_data_11,
  c_addr_11,
  c_data_12,
  c_addr_12,
  c_data_13,
  c_addr_13,
  c_data_20,
  c_addr_20,
  c_data_21,
  c_addr_21,
  c_data_22,
  c_addr_22,
  c_data_23,
  c_addr_23,
  c_data_30,
  c_addr_30,
  c_data_31,
  c_addr_31,
  c_data_32,
  c_addr_32,
  c_data_33,
  c_addr_33
);
  input clk;
  input reset;
  input start_mat_mul;
  output done_mat_mul;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_30;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_03;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_03;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_23;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_30;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_31;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_32;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_33;

  output [`AWIDTH-1:0] a_addr_00;
  output [`AWIDTH-1:0] a_addr_10;
  output [`AWIDTH-1:0] a_addr_20;
  output [`AWIDTH-1:0] a_addr_30;

  output [`AWIDTH-1:0] b_addr_00;
  output [`AWIDTH-1:0] b_addr_01;
  output [`AWIDTH-1:0] b_addr_02;
  output [`AWIDTH-1:0] b_addr_03;

  output [`AWIDTH-1:0] c_addr_00;
  output [`AWIDTH-1:0] c_addr_01;
  output [`AWIDTH-1:0] c_addr_02;
  output [`AWIDTH-1:0] c_addr_03;
  output [`AWIDTH-1:0] c_addr_10;
  output [`AWIDTH-1:0] c_addr_11;
  output [`AWIDTH-1:0] c_addr_12;
  output [`AWIDTH-1:0] c_addr_13;
  output [`AWIDTH-1:0] c_addr_20;
  output [`AWIDTH-1:0] c_addr_21;
  output [`AWIDTH-1:0] c_addr_22;
  output [`AWIDTH-1:0] c_addr_23;
  output [`AWIDTH-1:0] c_addr_30;
  output [`AWIDTH-1:0] c_addr_31;
  output [`AWIDTH-1:0] c_addr_32;
  output [`AWIDTH-1:0] c_addr_33;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_00;
  wire done_mat_mul_01;
  wire done_mat_mul_02;
  wire done_mat_mul_03;
  wire done_mat_mul_10;
  wire done_mat_mul_11;
  wire done_mat_mul_12;
  wire done_mat_mul_13;
  wire done_mat_mul_20;
  wire done_mat_mul_21;
  wire done_mat_mul_22;
  wire done_mat_mul_23;
  wire done_mat_mul_30;
  wire done_mat_mul_31;
  wire done_mat_mul_32;
  wire done_mat_mul_33;

  assign done_mat_mul =   done_mat_mul_00 &&
  done_mat_mul_01 &&
  done_mat_mul_02 &&
  done_mat_mul_03 &&
  done_mat_mul_10 &&
  done_mat_mul_11 &&
  done_mat_mul_12 &&
  done_mat_mul_13 &&
  done_mat_mul_20 &&
  done_mat_mul_21 &&
  done_mat_mul_22 &&
  done_mat_mul_23 &&
  done_mat_mul_30 &&
  done_mat_mul_31 &&
  done_mat_mul_32 &&
  done_mat_mul_33;

  /////////////////////////////////////////////////
  // Matmul 00
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00_to_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00_to_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_00_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_00_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_00),
  .a_data(a_data_00),
  .b_data(b_data_00),
  .a_data_in(a_data_in_00_NC),
  .b_data_in(b_data_in_00_NC),
  .c_data(c_data_00),
  .a_data_out(a_data_00_to_01),
  .b_data_out(b_data_00_to_10),
  .a_addr(a_addr_00),
  .b_addr(b_addr_00),
  .c_addr(c_addr_00),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 01
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_01_to_02;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01_to_11;
  wire [`AWIDTH-1:0] a_addr_01_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_01_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_01_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_01(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_01),
  .a_data(a_data_01_NC),
  .b_data(b_data_01),
  .a_data_in(a_data_00_to_01),
  .b_data_in(b_data_in_01_NC),
  .c_data(c_data_01),
  .a_data_out(a_data_01_to_02),
  .b_data_out(b_data_01_to_11),
  .a_addr(a_addr_01_NC),
  .b_addr(b_addr_01),
  .c_addr(c_addr_01),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd0),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 02
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_02_to_03;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02_to_12;
  wire [`AWIDTH-1:0] a_addr_02_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_02_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_02_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_02(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_02),
  .a_data(a_data_02_NC),
  .b_data(b_data_02),
  .a_data_in(a_data_01_to_02),
  .b_data_in(b_data_in_02_NC),
  .c_data(c_data_02),
  .a_data_out(a_data_02_to_03),
  .b_data_out(b_data_02_to_12),
  .a_addr(a_addr_02_NC),
  .b_addr(b_addr_02),
  .c_addr(c_addr_02),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd0),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 03
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_03_to_04;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_03_to_13;
  wire [`AWIDTH-1:0] a_addr_03_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_03_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_03_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_03(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_03),
  .a_data(a_data_03_NC),
  .b_data(b_data_03),
  .a_data_in(a_data_02_to_03),
  .b_data_in(b_data_in_03_NC),
  .c_data(c_data_03),
  .a_data_out(a_data_03_to_04),
  .b_data_out(b_data_03_to_13),
  .a_addr(a_addr_03_NC),
  .b_addr(b_addr_03),
  .c_addr(c_addr_03),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd0),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 10
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_to_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_to_20;
  wire [`AWIDTH-1:0] b_addr_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_10_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10),
  .a_data(a_data_10),
  .b_data(b_data_10_NC),
  .a_data_in(a_data_in_10_NC),
  .b_data_in(b_data_00_to_10),
  .c_data(c_data_10),
  .a_data_out(a_data_10_to_11),
  .b_data_out(b_data_10_to_20),
  .a_addr(a_addr_10),
  .b_addr(b_addr_10_NC),
  .c_addr(c_addr_10),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd1),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 11
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_to_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_to_21;
  wire [`AWIDTH-1:0] a_addr_11_NC;
  wire [`AWIDTH-1:0] b_addr_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11),
  .a_data(a_data_11_NC),
  .b_data(b_data_11_NC),
  .a_data_in(a_data_10_to_11),
  .b_data_in(b_data_01_to_11),
  .c_data(c_data_11),
  .a_data_out(a_data_11_to_12),
  .b_data_out(b_data_11_to_21),
  .a_addr(a_addr_11_NC),
  .b_addr(b_addr_11_NC),
  .c_addr(c_addr_11),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd1),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 12
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_to_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_to_22;
  wire [`AWIDTH-1:0] a_addr_12_NC;
  wire [`AWIDTH-1:0] b_addr_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12),
  .a_data(a_data_12_NC),
  .b_data(b_data_12_NC),
  .a_data_in(a_data_11_to_12),
  .b_data_in(b_data_02_to_12),
  .c_data(c_data_12),
  .a_data_out(a_data_12_to_13),
  .b_data_out(b_data_12_to_22),
  .a_addr(a_addr_12_NC),
  .b_addr(b_addr_12_NC),
  .c_addr(c_addr_12),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd1),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 13
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_to_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_to_23;
  wire [`AWIDTH-1:0] a_addr_13_NC;
  wire [`AWIDTH-1:0] b_addr_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13),
  .a_data(a_data_13_NC),
  .b_data(b_data_13_NC),
  .a_data_in(a_data_12_to_13),
  .b_data_in(b_data_03_to_13),
  .c_data(c_data_13),
  .a_data_out(a_data_13_to_14),
  .b_data_out(b_data_13_to_23),
  .a_addr(a_addr_13_NC),
  .b_addr(b_addr_13_NC),
  .c_addr(c_addr_13),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd1),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 20
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20_to_21;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_20_to_30;
  wire [`AWIDTH-1:0] b_addr_20_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_20_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_20_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_20(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_20),
  .a_data(a_data_20),
  .b_data(b_data_20_NC),
  .a_data_in(a_data_in_20_NC),
  .b_data_in(b_data_10_to_20),
  .c_data(c_data_20),
  .a_data_out(a_data_20_to_21),
  .b_data_out(b_data_20_to_30),
  .a_addr(a_addr_20),
  .b_addr(b_addr_20_NC),
  .c_addr(c_addr_20),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd2),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 21
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_21_to_22;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_21_to_31;
  wire [`AWIDTH-1:0] a_addr_21_NC;
  wire [`AWIDTH-1:0] b_addr_21_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_21_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_21_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_21(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_21),
  .a_data(a_data_21_NC),
  .b_data(b_data_21_NC),
  .a_data_in(a_data_20_to_21),
  .b_data_in(b_data_11_to_21),
  .c_data(c_data_21),
  .a_data_out(a_data_21_to_22),
  .b_data_out(b_data_21_to_31),
  .a_addr(a_addr_21_NC),
  .b_addr(b_addr_21_NC),
  .c_addr(c_addr_21),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd2),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 22
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_22_to_23;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_22_to_32;
  wire [`AWIDTH-1:0] a_addr_22_NC;
  wire [`AWIDTH-1:0] b_addr_22_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_22_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_22_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_22(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_22),
  .a_data(a_data_22_NC),
  .b_data(b_data_22_NC),
  .a_data_in(a_data_21_to_22),
  .b_data_in(b_data_12_to_22),
  .c_data(c_data_22),
  .a_data_out(a_data_22_to_23),
  .b_data_out(b_data_22_to_32),
  .a_addr(a_addr_22_NC),
  .b_addr(b_addr_22_NC),
  .c_addr(c_addr_22),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd2),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 23
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_23_to_24;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_23_to_33;
  wire [`AWIDTH-1:0] a_addr_23_NC;
  wire [`AWIDTH-1:0] b_addr_23_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_23_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_23_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_23(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_23),
  .a_data(a_data_23_NC),
  .b_data(b_data_23_NC),
  .a_data_in(a_data_22_to_23),
  .b_data_in(b_data_13_to_23),
  .c_data(c_data_23),
  .a_data_out(a_data_23_to_24),
  .b_data_out(b_data_23_to_33),
  .a_addr(a_addr_23_NC),
  .b_addr(b_addr_23_NC),
  .c_addr(c_addr_23),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd2),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 30
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_30_to_31;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_30_to_40;
  wire [`AWIDTH-1:0] b_addr_30_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_30_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_30_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_30(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_30),
  .a_data(a_data_30),
  .b_data(b_data_30_NC),
  .a_data_in(a_data_in_30_NC),
  .b_data_in(b_data_20_to_30),
  .c_data(c_data_30),
  .a_data_out(a_data_30_to_31),
  .b_data_out(b_data_30_to_40),
  .a_addr(a_addr_30),
  .b_addr(b_addr_30_NC),
  .c_addr(c_addr_30),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd3),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 31
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_31_to_32;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_31_to_41;
  wire [`AWIDTH-1:0] a_addr_31_NC;
  wire [`AWIDTH-1:0] b_addr_31_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_31_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_31_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_31(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_31),
  .a_data(a_data_31_NC),
  .b_data(b_data_31_NC),
  .a_data_in(a_data_30_to_31),
  .b_data_in(b_data_21_to_31),
  .c_data(c_data_31),
  .a_data_out(a_data_31_to_32),
  .b_data_out(b_data_31_to_41),
  .a_addr(a_addr_31_NC),
  .b_addr(b_addr_31_NC),
  .c_addr(c_addr_31),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd3),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 32
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_32_to_33;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_32_to_42;
  wire [`AWIDTH-1:0] a_addr_32_NC;
  wire [`AWIDTH-1:0] b_addr_32_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_32_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_32_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_32(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_32),
  .a_data(a_data_32_NC),
  .b_data(b_data_32_NC),
  .a_data_in(a_data_31_to_32),
  .b_data_in(b_data_22_to_32),
  .c_data(c_data_32),
  .a_data_out(a_data_32_to_33),
  .b_data_out(b_data_32_to_42),
  .a_addr(a_addr_32_NC),
  .b_addr(b_addr_32_NC),
  .c_addr(c_addr_32),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd3),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 33
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_33_to_34;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_33_to_43;
  wire [`AWIDTH-1:0] a_addr_33_NC;
  wire [`AWIDTH-1:0] b_addr_33_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_33_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_33_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_33(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_33),
  .a_data(a_data_33_NC),
  .b_data(b_data_33_NC),
  .a_data_in(a_data_32_to_33),
  .b_data_in(b_data_23_to_33),
  .c_data(c_data_33),
  .a_data_out(a_data_33_to_34),
  .b_data_out(b_data_33_to_43),
  .a_addr(a_addr_33_NC),
  .b_addr(b_addr_33_NC),
  .c_addr(c_addr_33),
  .final_mat_mul_size(8'd16),
  .a_loc(8'd3),
  .b_loc(8'd3)
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