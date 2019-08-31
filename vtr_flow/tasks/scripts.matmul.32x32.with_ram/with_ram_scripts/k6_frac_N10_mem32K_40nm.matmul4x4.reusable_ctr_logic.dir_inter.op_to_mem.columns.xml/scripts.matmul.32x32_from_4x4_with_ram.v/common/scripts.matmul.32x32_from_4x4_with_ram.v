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

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_40;
  wire [`AWIDTH-1:0] a_addr_40;
  wire [`AWIDTH-1:0] a_addr_muxed_40;

  reg  [`AWIDTH-1:0] a_addr_muxed_40_reg;
  reg  [`AWIDTH-1:0] a_addr_40_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_40_reg <= 0;
      a_addr_muxed_40_reg <= 0;
    end else begin
      a_addr_40_reg <= a_addr_40;
      a_addr_muxed_40_reg <= a_addr_muxed_40;
    end
  end
  assign a_addr_muxed_40 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_40_reg;

  // BRAM matrix A 40
  ram matrix_A_40 (
    .addr0(a_addr_muxed_40_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_40),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_50;
  wire [`AWIDTH-1:0] a_addr_50;
  wire [`AWIDTH-1:0] a_addr_muxed_50;

  reg  [`AWIDTH-1:0] a_addr_muxed_50_reg;
  reg  [`AWIDTH-1:0] a_addr_50_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_50_reg <= 0;
      a_addr_muxed_50_reg <= 0;
    end else begin
      a_addr_50_reg <= a_addr_50;
      a_addr_muxed_50_reg <= a_addr_muxed_50;
    end
  end
  assign a_addr_muxed_50 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_50_reg;

  // BRAM matrix A 50
  ram matrix_A_50 (
    .addr0(a_addr_muxed_50_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_50),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_60;
  wire [`AWIDTH-1:0] a_addr_60;
  wire [`AWIDTH-1:0] a_addr_muxed_60;

  reg  [`AWIDTH-1:0] a_addr_muxed_60_reg;
  reg  [`AWIDTH-1:0] a_addr_60_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_60_reg <= 0;
      a_addr_muxed_60_reg <= 0;
    end else begin
      a_addr_60_reg <= a_addr_60;
      a_addr_muxed_60_reg <= a_addr_muxed_60;
    end
  end
  assign a_addr_muxed_60 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_60_reg;

  // BRAM matrix A 60
  ram matrix_A_60 (
    .addr0(a_addr_muxed_60_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_60),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_70;
  wire [`AWIDTH-1:0] a_addr_70;
  wire [`AWIDTH-1:0] a_addr_muxed_70;

  reg  [`AWIDTH-1:0] a_addr_muxed_70_reg;
  reg  [`AWIDTH-1:0] a_addr_70_reg;
  always @(posedge clk) begin
    if(reset) begin
      a_addr_70_reg <= 0;
      a_addr_muxed_70_reg <= 0;
    end else begin
      a_addr_70_reg <= a_addr_70;
      a_addr_muxed_70_reg <= a_addr_muxed_70;
    end
  end
  assign a_addr_muxed_70 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_70_reg;

  // BRAM matrix A 70
  ram matrix_A_70 (
    .addr0(a_addr_muxed_70_reg),
    .d0(data_pi),
    .we0(we_a),
    .q0(a_data_70),
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

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_04;
  wire [`AWIDTH-1:0] b_addr_04;
  wire [`AWIDTH-1:0] b_addr_muxed_04;

  reg  [`AWIDTH-1:0] b_addr_muxed_04_reg;
  reg  [`AWIDTH-1:0] b_addr_04_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_04_reg <= 0;
      b_addr_muxed_04_reg <= 0;
    end else begin
      b_addr_04_reg <= b_addr_04;
      b_addr_muxed_04_reg <= b_addr_muxed_04;
    end
  end
  assign b_addr_muxed_04 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_04_reg;

  // BRAM matrix B 04
  ram matrix_B_04 (
    .addr0(b_addr_muxed_04_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_04),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_05;
  wire [`AWIDTH-1:0] b_addr_05;
  wire [`AWIDTH-1:0] b_addr_muxed_05;

  reg  [`AWIDTH-1:0] b_addr_muxed_05_reg;
  reg  [`AWIDTH-1:0] b_addr_05_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_05_reg <= 0;
      b_addr_muxed_05_reg <= 0;
    end else begin
      b_addr_05_reg <= b_addr_05;
      b_addr_muxed_05_reg <= b_addr_muxed_05;
    end
  end
  assign b_addr_muxed_05 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_05_reg;

  // BRAM matrix B 05
  ram matrix_B_05 (
    .addr0(b_addr_muxed_05_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_05),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_06;
  wire [`AWIDTH-1:0] b_addr_06;
  wire [`AWIDTH-1:0] b_addr_muxed_06;

  reg  [`AWIDTH-1:0] b_addr_muxed_06_reg;
  reg  [`AWIDTH-1:0] b_addr_06_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_06_reg <= 0;
      b_addr_muxed_06_reg <= 0;
    end else begin
      b_addr_06_reg <= b_addr_06;
      b_addr_muxed_06_reg <= b_addr_muxed_06;
    end
  end
  assign b_addr_muxed_06 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_06_reg;

  // BRAM matrix B 06
  ram matrix_B_06 (
    .addr0(b_addr_muxed_06_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_06),
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_07;
  wire [`AWIDTH-1:0] b_addr_07;
  wire [`AWIDTH-1:0] b_addr_muxed_07;

  reg  [`AWIDTH-1:0] b_addr_muxed_07_reg;
  reg  [`AWIDTH-1:0] b_addr_07_reg;
  always @(posedge clk) begin
    if(reset) begin
      b_addr_07_reg <= 0;
      b_addr_muxed_07_reg <= 0;
    end else begin
      b_addr_07_reg <= b_addr_07;
      b_addr_muxed_07_reg <= b_addr_muxed_07;
    end
  end
  assign b_addr_muxed_07 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_07_reg;

  // BRAM matrix B 07
  ram matrix_B_07 (
    .addr0(b_addr_muxed_07_reg),
    .d0(data_pi),
    .we0(we_b),
    .q0(b_data_07),
    .clk(clk));

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  wire [`AWIDTH-1:0] c_addr_00;
  wire [`AWIDTH-1:0] c_addr_01;
  wire [`AWIDTH-1:0] c_addr_02;
  wire [`AWIDTH-1:0] c_addr_03;
  wire [`AWIDTH-1:0] c_addr_04;
  wire [`AWIDTH-1:0] c_addr_05;
  wire [`AWIDTH-1:0] c_addr_06;
  wire [`AWIDTH-1:0] c_addr_07;
  wire [`AWIDTH-1:0] c_addr_10;
  wire [`AWIDTH-1:0] c_addr_11;
  wire [`AWIDTH-1:0] c_addr_12;
  wire [`AWIDTH-1:0] c_addr_13;
  wire [`AWIDTH-1:0] c_addr_14;
  wire [`AWIDTH-1:0] c_addr_15;
  wire [`AWIDTH-1:0] c_addr_16;
  wire [`AWIDTH-1:0] c_addr_17;
  wire [`AWIDTH-1:0] c_addr_20;
  wire [`AWIDTH-1:0] c_addr_21;
  wire [`AWIDTH-1:0] c_addr_22;
  wire [`AWIDTH-1:0] c_addr_23;
  wire [`AWIDTH-1:0] c_addr_24;
  wire [`AWIDTH-1:0] c_addr_25;
  wire [`AWIDTH-1:0] c_addr_26;
  wire [`AWIDTH-1:0] c_addr_27;
  wire [`AWIDTH-1:0] c_addr_30;
  wire [`AWIDTH-1:0] c_addr_31;
  wire [`AWIDTH-1:0] c_addr_32;
  wire [`AWIDTH-1:0] c_addr_33;
  wire [`AWIDTH-1:0] c_addr_34;
  wire [`AWIDTH-1:0] c_addr_35;
  wire [`AWIDTH-1:0] c_addr_36;
  wire [`AWIDTH-1:0] c_addr_37;
  wire [`AWIDTH-1:0] c_addr_40;
  wire [`AWIDTH-1:0] c_addr_41;
  wire [`AWIDTH-1:0] c_addr_42;
  wire [`AWIDTH-1:0] c_addr_43;
  wire [`AWIDTH-1:0] c_addr_44;
  wire [`AWIDTH-1:0] c_addr_45;
  wire [`AWIDTH-1:0] c_addr_46;
  wire [`AWIDTH-1:0] c_addr_47;
  wire [`AWIDTH-1:0] c_addr_50;
  wire [`AWIDTH-1:0] c_addr_51;
  wire [`AWIDTH-1:0] c_addr_52;
  wire [`AWIDTH-1:0] c_addr_53;
  wire [`AWIDTH-1:0] c_addr_54;
  wire [`AWIDTH-1:0] c_addr_55;
  wire [`AWIDTH-1:0] c_addr_56;
  wire [`AWIDTH-1:0] c_addr_57;
  wire [`AWIDTH-1:0] c_addr_60;
  wire [`AWIDTH-1:0] c_addr_61;
  wire [`AWIDTH-1:0] c_addr_62;
  wire [`AWIDTH-1:0] c_addr_63;
  wire [`AWIDTH-1:0] c_addr_64;
  wire [`AWIDTH-1:0] c_addr_65;
  wire [`AWIDTH-1:0] c_addr_66;
  wire [`AWIDTH-1:0] c_addr_67;
  wire [`AWIDTH-1:0] c_addr_70;
  wire [`AWIDTH-1:0] c_addr_71;
  wire [`AWIDTH-1:0] c_addr_72;
  wire [`AWIDTH-1:0] c_addr_73;
  wire [`AWIDTH-1:0] c_addr_74;
  wire [`AWIDTH-1:0] c_addr_75;
  wire [`AWIDTH-1:0] c_addr_76;
  wire [`AWIDTH-1:0] c_addr_77;

  wire [`AWIDTH-1:0] c_addr_muxed_00;
  wire [`AWIDTH-1:0] c_addr_muxed_01;
  wire [`AWIDTH-1:0] c_addr_muxed_02;
  wire [`AWIDTH-1:0] c_addr_muxed_03;
  wire [`AWIDTH-1:0] c_addr_muxed_04;
  wire [`AWIDTH-1:0] c_addr_muxed_05;
  wire [`AWIDTH-1:0] c_addr_muxed_06;
  wire [`AWIDTH-1:0] c_addr_muxed_07;
  wire [`AWIDTH-1:0] c_addr_muxed_10;
  wire [`AWIDTH-1:0] c_addr_muxed_11;
  wire [`AWIDTH-1:0] c_addr_muxed_12;
  wire [`AWIDTH-1:0] c_addr_muxed_13;
  wire [`AWIDTH-1:0] c_addr_muxed_14;
  wire [`AWIDTH-1:0] c_addr_muxed_15;
  wire [`AWIDTH-1:0] c_addr_muxed_16;
  wire [`AWIDTH-1:0] c_addr_muxed_17;
  wire [`AWIDTH-1:0] c_addr_muxed_20;
  wire [`AWIDTH-1:0] c_addr_muxed_21;
  wire [`AWIDTH-1:0] c_addr_muxed_22;
  wire [`AWIDTH-1:0] c_addr_muxed_23;
  wire [`AWIDTH-1:0] c_addr_muxed_24;
  wire [`AWIDTH-1:0] c_addr_muxed_25;
  wire [`AWIDTH-1:0] c_addr_muxed_26;
  wire [`AWIDTH-1:0] c_addr_muxed_27;
  wire [`AWIDTH-1:0] c_addr_muxed_30;
  wire [`AWIDTH-1:0] c_addr_muxed_31;
  wire [`AWIDTH-1:0] c_addr_muxed_32;
  wire [`AWIDTH-1:0] c_addr_muxed_33;
  wire [`AWIDTH-1:0] c_addr_muxed_34;
  wire [`AWIDTH-1:0] c_addr_muxed_35;
  wire [`AWIDTH-1:0] c_addr_muxed_36;
  wire [`AWIDTH-1:0] c_addr_muxed_37;
  wire [`AWIDTH-1:0] c_addr_muxed_40;
  wire [`AWIDTH-1:0] c_addr_muxed_41;
  wire [`AWIDTH-1:0] c_addr_muxed_42;
  wire [`AWIDTH-1:0] c_addr_muxed_43;
  wire [`AWIDTH-1:0] c_addr_muxed_44;
  wire [`AWIDTH-1:0] c_addr_muxed_45;
  wire [`AWIDTH-1:0] c_addr_muxed_46;
  wire [`AWIDTH-1:0] c_addr_muxed_47;
  wire [`AWIDTH-1:0] c_addr_muxed_50;
  wire [`AWIDTH-1:0] c_addr_muxed_51;
  wire [`AWIDTH-1:0] c_addr_muxed_52;
  wire [`AWIDTH-1:0] c_addr_muxed_53;
  wire [`AWIDTH-1:0] c_addr_muxed_54;
  wire [`AWIDTH-1:0] c_addr_muxed_55;
  wire [`AWIDTH-1:0] c_addr_muxed_56;
  wire [`AWIDTH-1:0] c_addr_muxed_57;
  wire [`AWIDTH-1:0] c_addr_muxed_60;
  wire [`AWIDTH-1:0] c_addr_muxed_61;
  wire [`AWIDTH-1:0] c_addr_muxed_62;
  wire [`AWIDTH-1:0] c_addr_muxed_63;
  wire [`AWIDTH-1:0] c_addr_muxed_64;
  wire [`AWIDTH-1:0] c_addr_muxed_65;
  wire [`AWIDTH-1:0] c_addr_muxed_66;
  wire [`AWIDTH-1:0] c_addr_muxed_67;
  wire [`AWIDTH-1:0] c_addr_muxed_70;
  wire [`AWIDTH-1:0] c_addr_muxed_71;
  wire [`AWIDTH-1:0] c_addr_muxed_72;
  wire [`AWIDTH-1:0] c_addr_muxed_73;
  wire [`AWIDTH-1:0] c_addr_muxed_74;
  wire [`AWIDTH-1:0] c_addr_muxed_75;
  wire [`AWIDTH-1:0] c_addr_muxed_76;
  wire [`AWIDTH-1:0] c_addr_muxed_77;

  reg [`AWIDTH-1:0] c_addr_00_reg;
  reg [`AWIDTH-1:0] c_addr_01_reg;
  reg [`AWIDTH-1:0] c_addr_02_reg;
  reg [`AWIDTH-1:0] c_addr_03_reg;
  reg [`AWIDTH-1:0] c_addr_04_reg;
  reg [`AWIDTH-1:0] c_addr_05_reg;
  reg [`AWIDTH-1:0] c_addr_06_reg;
  reg [`AWIDTH-1:0] c_addr_07_reg;
  reg [`AWIDTH-1:0] c_addr_10_reg;
  reg [`AWIDTH-1:0] c_addr_11_reg;
  reg [`AWIDTH-1:0] c_addr_12_reg;
  reg [`AWIDTH-1:0] c_addr_13_reg;
  reg [`AWIDTH-1:0] c_addr_14_reg;
  reg [`AWIDTH-1:0] c_addr_15_reg;
  reg [`AWIDTH-1:0] c_addr_16_reg;
  reg [`AWIDTH-1:0] c_addr_17_reg;
  reg [`AWIDTH-1:0] c_addr_20_reg;
  reg [`AWIDTH-1:0] c_addr_21_reg;
  reg [`AWIDTH-1:0] c_addr_22_reg;
  reg [`AWIDTH-1:0] c_addr_23_reg;
  reg [`AWIDTH-1:0] c_addr_24_reg;
  reg [`AWIDTH-1:0] c_addr_25_reg;
  reg [`AWIDTH-1:0] c_addr_26_reg;
  reg [`AWIDTH-1:0] c_addr_27_reg;
  reg [`AWIDTH-1:0] c_addr_30_reg;
  reg [`AWIDTH-1:0] c_addr_31_reg;
  reg [`AWIDTH-1:0] c_addr_32_reg;
  reg [`AWIDTH-1:0] c_addr_33_reg;
  reg [`AWIDTH-1:0] c_addr_34_reg;
  reg [`AWIDTH-1:0] c_addr_35_reg;
  reg [`AWIDTH-1:0] c_addr_36_reg;
  reg [`AWIDTH-1:0] c_addr_37_reg;
  reg [`AWIDTH-1:0] c_addr_40_reg;
  reg [`AWIDTH-1:0] c_addr_41_reg;
  reg [`AWIDTH-1:0] c_addr_42_reg;
  reg [`AWIDTH-1:0] c_addr_43_reg;
  reg [`AWIDTH-1:0] c_addr_44_reg;
  reg [`AWIDTH-1:0] c_addr_45_reg;
  reg [`AWIDTH-1:0] c_addr_46_reg;
  reg [`AWIDTH-1:0] c_addr_47_reg;
  reg [`AWIDTH-1:0] c_addr_50_reg;
  reg [`AWIDTH-1:0] c_addr_51_reg;
  reg [`AWIDTH-1:0] c_addr_52_reg;
  reg [`AWIDTH-1:0] c_addr_53_reg;
  reg [`AWIDTH-1:0] c_addr_54_reg;
  reg [`AWIDTH-1:0] c_addr_55_reg;
  reg [`AWIDTH-1:0] c_addr_56_reg;
  reg [`AWIDTH-1:0] c_addr_57_reg;
  reg [`AWIDTH-1:0] c_addr_60_reg;
  reg [`AWIDTH-1:0] c_addr_61_reg;
  reg [`AWIDTH-1:0] c_addr_62_reg;
  reg [`AWIDTH-1:0] c_addr_63_reg;
  reg [`AWIDTH-1:0] c_addr_64_reg;
  reg [`AWIDTH-1:0] c_addr_65_reg;
  reg [`AWIDTH-1:0] c_addr_66_reg;
  reg [`AWIDTH-1:0] c_addr_67_reg;
  reg [`AWIDTH-1:0] c_addr_70_reg;
  reg [`AWIDTH-1:0] c_addr_71_reg;
  reg [`AWIDTH-1:0] c_addr_72_reg;
  reg [`AWIDTH-1:0] c_addr_73_reg;
  reg [`AWIDTH-1:0] c_addr_74_reg;
  reg [`AWIDTH-1:0] c_addr_75_reg;
  reg [`AWIDTH-1:0] c_addr_76_reg;
  reg [`AWIDTH-1:0] c_addr_77_reg;

  reg [`AWIDTH-1:0] c_addr_muxed_00_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_01_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_02_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_03_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_04_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_05_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_06_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_07_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_10_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_11_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_12_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_13_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_14_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_15_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_16_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_17_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_20_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_21_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_22_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_23_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_24_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_25_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_26_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_27_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_30_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_31_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_32_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_33_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_34_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_35_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_36_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_37_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_40_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_41_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_42_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_43_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_44_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_45_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_46_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_47_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_50_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_51_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_52_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_53_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_54_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_55_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_56_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_57_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_60_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_61_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_62_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_63_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_64_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_65_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_66_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_67_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_70_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_71_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_72_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_73_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_74_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_75_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_76_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_77_reg;

  assign c_addr_muxed_00 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_00_reg;
  assign c_addr_muxed_01 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_01_reg;
  assign c_addr_muxed_02 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_02_reg;
  assign c_addr_muxed_03 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_03_reg;
  assign c_addr_muxed_04 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_04_reg;
  assign c_addr_muxed_05 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_05_reg;
  assign c_addr_muxed_06 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_06_reg;
  assign c_addr_muxed_07 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_07_reg;
  assign c_addr_muxed_10 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_10_reg;
  assign c_addr_muxed_11 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_11_reg;
  assign c_addr_muxed_12 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_12_reg;
  assign c_addr_muxed_13 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_13_reg;
  assign c_addr_muxed_14 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_14_reg;
  assign c_addr_muxed_15 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_15_reg;
  assign c_addr_muxed_16 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_16_reg;
  assign c_addr_muxed_17 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_17_reg;
  assign c_addr_muxed_20 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_20_reg;
  assign c_addr_muxed_21 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_21_reg;
  assign c_addr_muxed_22 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_22_reg;
  assign c_addr_muxed_23 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_23_reg;
  assign c_addr_muxed_24 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_24_reg;
  assign c_addr_muxed_25 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_25_reg;
  assign c_addr_muxed_26 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_26_reg;
  assign c_addr_muxed_27 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_27_reg;
  assign c_addr_muxed_30 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_30_reg;
  assign c_addr_muxed_31 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_31_reg;
  assign c_addr_muxed_32 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_32_reg;
  assign c_addr_muxed_33 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_33_reg;
  assign c_addr_muxed_34 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_34_reg;
  assign c_addr_muxed_35 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_35_reg;
  assign c_addr_muxed_36 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_36_reg;
  assign c_addr_muxed_37 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_37_reg;
  assign c_addr_muxed_40 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_40_reg;
  assign c_addr_muxed_41 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_41_reg;
  assign c_addr_muxed_42 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_42_reg;
  assign c_addr_muxed_43 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_43_reg;
  assign c_addr_muxed_44 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_44_reg;
  assign c_addr_muxed_45 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_45_reg;
  assign c_addr_muxed_46 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_46_reg;
  assign c_addr_muxed_47 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_47_reg;
  assign c_addr_muxed_50 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_50_reg;
  assign c_addr_muxed_51 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_51_reg;
  assign c_addr_muxed_52 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_52_reg;
  assign c_addr_muxed_53 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_53_reg;
  assign c_addr_muxed_54 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_54_reg;
  assign c_addr_muxed_55 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_55_reg;
  assign c_addr_muxed_56 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_56_reg;
  assign c_addr_muxed_57 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_57_reg;
  assign c_addr_muxed_60 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_60_reg;
  assign c_addr_muxed_61 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_61_reg;
  assign c_addr_muxed_62 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_62_reg;
  assign c_addr_muxed_63 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_63_reg;
  assign c_addr_muxed_64 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_64_reg;
  assign c_addr_muxed_65 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_65_reg;
  assign c_addr_muxed_66 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_66_reg;
  assign c_addr_muxed_67 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_67_reg;
  assign c_addr_muxed_70 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_70_reg;
  assign c_addr_muxed_71 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_71_reg;
  assign c_addr_muxed_72 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_72_reg;
  assign c_addr_muxed_73 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_73_reg;
  assign c_addr_muxed_74 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_74_reg;
  assign c_addr_muxed_75 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_75_reg;
  assign c_addr_muxed_76 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_76_reg;
  assign c_addr_muxed_77 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_77_reg;

  always @(posedge clk) begin
    if (reset) begin
      c_addr_00_reg <= 0;
      c_addr_01_reg <= 0;
      c_addr_02_reg <= 0;
      c_addr_03_reg <= 0;
      c_addr_04_reg <= 0;
      c_addr_05_reg <= 0;
      c_addr_06_reg <= 0;
      c_addr_07_reg <= 0;
      c_addr_10_reg <= 0;
      c_addr_11_reg <= 0;
      c_addr_12_reg <= 0;
      c_addr_13_reg <= 0;
      c_addr_14_reg <= 0;
      c_addr_15_reg <= 0;
      c_addr_16_reg <= 0;
      c_addr_17_reg <= 0;
      c_addr_20_reg <= 0;
      c_addr_21_reg <= 0;
      c_addr_22_reg <= 0;
      c_addr_23_reg <= 0;
      c_addr_24_reg <= 0;
      c_addr_25_reg <= 0;
      c_addr_26_reg <= 0;
      c_addr_27_reg <= 0;
      c_addr_30_reg <= 0;
      c_addr_31_reg <= 0;
      c_addr_32_reg <= 0;
      c_addr_33_reg <= 0;
      c_addr_34_reg <= 0;
      c_addr_35_reg <= 0;
      c_addr_36_reg <= 0;
      c_addr_37_reg <= 0;
      c_addr_40_reg <= 0;
      c_addr_41_reg <= 0;
      c_addr_42_reg <= 0;
      c_addr_43_reg <= 0;
      c_addr_44_reg <= 0;
      c_addr_45_reg <= 0;
      c_addr_46_reg <= 0;
      c_addr_47_reg <= 0;
      c_addr_50_reg <= 0;
      c_addr_51_reg <= 0;
      c_addr_52_reg <= 0;
      c_addr_53_reg <= 0;
      c_addr_54_reg <= 0;
      c_addr_55_reg <= 0;
      c_addr_56_reg <= 0;
      c_addr_57_reg <= 0;
      c_addr_60_reg <= 0;
      c_addr_61_reg <= 0;
      c_addr_62_reg <= 0;
      c_addr_63_reg <= 0;
      c_addr_64_reg <= 0;
      c_addr_65_reg <= 0;
      c_addr_66_reg <= 0;
      c_addr_67_reg <= 0;
      c_addr_70_reg <= 0;
      c_addr_71_reg <= 0;
      c_addr_72_reg <= 0;
      c_addr_73_reg <= 0;
      c_addr_74_reg <= 0;
      c_addr_75_reg <= 0;
      c_addr_76_reg <= 0;
      c_addr_77_reg <= 0;
       c_addr_muxed_00_reg <= 0;
       c_addr_muxed_01_reg <= 0;
       c_addr_muxed_02_reg <= 0;
       c_addr_muxed_03_reg <= 0;
       c_addr_muxed_04_reg <= 0;
       c_addr_muxed_05_reg <= 0;
       c_addr_muxed_06_reg <= 0;
       c_addr_muxed_07_reg <= 0;
       c_addr_muxed_10_reg <= 0;
       c_addr_muxed_11_reg <= 0;
       c_addr_muxed_12_reg <= 0;
       c_addr_muxed_13_reg <= 0;
       c_addr_muxed_14_reg <= 0;
       c_addr_muxed_15_reg <= 0;
       c_addr_muxed_16_reg <= 0;
       c_addr_muxed_17_reg <= 0;
       c_addr_muxed_20_reg <= 0;
       c_addr_muxed_21_reg <= 0;
       c_addr_muxed_22_reg <= 0;
       c_addr_muxed_23_reg <= 0;
       c_addr_muxed_24_reg <= 0;
       c_addr_muxed_25_reg <= 0;
       c_addr_muxed_26_reg <= 0;
       c_addr_muxed_27_reg <= 0;
       c_addr_muxed_30_reg <= 0;
       c_addr_muxed_31_reg <= 0;
       c_addr_muxed_32_reg <= 0;
       c_addr_muxed_33_reg <= 0;
       c_addr_muxed_34_reg <= 0;
       c_addr_muxed_35_reg <= 0;
       c_addr_muxed_36_reg <= 0;
       c_addr_muxed_37_reg <= 0;
       c_addr_muxed_40_reg <= 0;
       c_addr_muxed_41_reg <= 0;
       c_addr_muxed_42_reg <= 0;
       c_addr_muxed_43_reg <= 0;
       c_addr_muxed_44_reg <= 0;
       c_addr_muxed_45_reg <= 0;
       c_addr_muxed_46_reg <= 0;
       c_addr_muxed_47_reg <= 0;
       c_addr_muxed_50_reg <= 0;
       c_addr_muxed_51_reg <= 0;
       c_addr_muxed_52_reg <= 0;
       c_addr_muxed_53_reg <= 0;
       c_addr_muxed_54_reg <= 0;
       c_addr_muxed_55_reg <= 0;
       c_addr_muxed_56_reg <= 0;
       c_addr_muxed_57_reg <= 0;
       c_addr_muxed_60_reg <= 0;
       c_addr_muxed_61_reg <= 0;
       c_addr_muxed_62_reg <= 0;
       c_addr_muxed_63_reg <= 0;
       c_addr_muxed_64_reg <= 0;
       c_addr_muxed_65_reg <= 0;
       c_addr_muxed_66_reg <= 0;
       c_addr_muxed_67_reg <= 0;
       c_addr_muxed_70_reg <= 0;
       c_addr_muxed_71_reg <= 0;
       c_addr_muxed_72_reg <= 0;
       c_addr_muxed_73_reg <= 0;
       c_addr_muxed_74_reg <= 0;
       c_addr_muxed_75_reg <= 0;
       c_addr_muxed_76_reg <= 0;
       c_addr_muxed_77_reg <= 0;
    end else begin
      c_addr_00_reg <= c_addr_00;
      c_addr_01_reg <= c_addr_01;
      c_addr_02_reg <= c_addr_02;
      c_addr_03_reg <= c_addr_03;
      c_addr_04_reg <= c_addr_04;
      c_addr_05_reg <= c_addr_05;
      c_addr_06_reg <= c_addr_06;
      c_addr_07_reg <= c_addr_07;
      c_addr_10_reg <= c_addr_10;
      c_addr_11_reg <= c_addr_11;
      c_addr_12_reg <= c_addr_12;
      c_addr_13_reg <= c_addr_13;
      c_addr_14_reg <= c_addr_14;
      c_addr_15_reg <= c_addr_15;
      c_addr_16_reg <= c_addr_16;
      c_addr_17_reg <= c_addr_17;
      c_addr_20_reg <= c_addr_20;
      c_addr_21_reg <= c_addr_21;
      c_addr_22_reg <= c_addr_22;
      c_addr_23_reg <= c_addr_23;
      c_addr_24_reg <= c_addr_24;
      c_addr_25_reg <= c_addr_25;
      c_addr_26_reg <= c_addr_26;
      c_addr_27_reg <= c_addr_27;
      c_addr_30_reg <= c_addr_30;
      c_addr_31_reg <= c_addr_31;
      c_addr_32_reg <= c_addr_32;
      c_addr_33_reg <= c_addr_33;
      c_addr_34_reg <= c_addr_34;
      c_addr_35_reg <= c_addr_35;
      c_addr_36_reg <= c_addr_36;
      c_addr_37_reg <= c_addr_37;
      c_addr_40_reg <= c_addr_40;
      c_addr_41_reg <= c_addr_41;
      c_addr_42_reg <= c_addr_42;
      c_addr_43_reg <= c_addr_43;
      c_addr_44_reg <= c_addr_44;
      c_addr_45_reg <= c_addr_45;
      c_addr_46_reg <= c_addr_46;
      c_addr_47_reg <= c_addr_47;
      c_addr_50_reg <= c_addr_50;
      c_addr_51_reg <= c_addr_51;
      c_addr_52_reg <= c_addr_52;
      c_addr_53_reg <= c_addr_53;
      c_addr_54_reg <= c_addr_54;
      c_addr_55_reg <= c_addr_55;
      c_addr_56_reg <= c_addr_56;
      c_addr_57_reg <= c_addr_57;
      c_addr_60_reg <= c_addr_60;
      c_addr_61_reg <= c_addr_61;
      c_addr_62_reg <= c_addr_62;
      c_addr_63_reg <= c_addr_63;
      c_addr_64_reg <= c_addr_64;
      c_addr_65_reg <= c_addr_65;
      c_addr_66_reg <= c_addr_66;
      c_addr_67_reg <= c_addr_67;
      c_addr_70_reg <= c_addr_70;
      c_addr_71_reg <= c_addr_71;
      c_addr_72_reg <= c_addr_72;
      c_addr_73_reg <= c_addr_73;
      c_addr_74_reg <= c_addr_74;
      c_addr_75_reg <= c_addr_75;
      c_addr_76_reg <= c_addr_76;
      c_addr_77_reg <= c_addr_77;
      c_addr_muxed_00_reg <= c_addr_muxed_00;
      c_addr_muxed_01_reg <= c_addr_muxed_01;
      c_addr_muxed_02_reg <= c_addr_muxed_02;
      c_addr_muxed_03_reg <= c_addr_muxed_03;
      c_addr_muxed_04_reg <= c_addr_muxed_04;
      c_addr_muxed_05_reg <= c_addr_muxed_05;
      c_addr_muxed_06_reg <= c_addr_muxed_06;
      c_addr_muxed_07_reg <= c_addr_muxed_07;
      c_addr_muxed_10_reg <= c_addr_muxed_10;
      c_addr_muxed_11_reg <= c_addr_muxed_11;
      c_addr_muxed_12_reg <= c_addr_muxed_12;
      c_addr_muxed_13_reg <= c_addr_muxed_13;
      c_addr_muxed_14_reg <= c_addr_muxed_14;
      c_addr_muxed_15_reg <= c_addr_muxed_15;
      c_addr_muxed_16_reg <= c_addr_muxed_16;
      c_addr_muxed_17_reg <= c_addr_muxed_17;
      c_addr_muxed_20_reg <= c_addr_muxed_20;
      c_addr_muxed_21_reg <= c_addr_muxed_21;
      c_addr_muxed_22_reg <= c_addr_muxed_22;
      c_addr_muxed_23_reg <= c_addr_muxed_23;
      c_addr_muxed_24_reg <= c_addr_muxed_24;
      c_addr_muxed_25_reg <= c_addr_muxed_25;
      c_addr_muxed_26_reg <= c_addr_muxed_26;
      c_addr_muxed_27_reg <= c_addr_muxed_27;
      c_addr_muxed_30_reg <= c_addr_muxed_30;
      c_addr_muxed_31_reg <= c_addr_muxed_31;
      c_addr_muxed_32_reg <= c_addr_muxed_32;
      c_addr_muxed_33_reg <= c_addr_muxed_33;
      c_addr_muxed_34_reg <= c_addr_muxed_34;
      c_addr_muxed_35_reg <= c_addr_muxed_35;
      c_addr_muxed_36_reg <= c_addr_muxed_36;
      c_addr_muxed_37_reg <= c_addr_muxed_37;
      c_addr_muxed_40_reg <= c_addr_muxed_40;
      c_addr_muxed_41_reg <= c_addr_muxed_41;
      c_addr_muxed_42_reg <= c_addr_muxed_42;
      c_addr_muxed_43_reg <= c_addr_muxed_43;
      c_addr_muxed_44_reg <= c_addr_muxed_44;
      c_addr_muxed_45_reg <= c_addr_muxed_45;
      c_addr_muxed_46_reg <= c_addr_muxed_46;
      c_addr_muxed_47_reg <= c_addr_muxed_47;
      c_addr_muxed_50_reg <= c_addr_muxed_50;
      c_addr_muxed_51_reg <= c_addr_muxed_51;
      c_addr_muxed_52_reg <= c_addr_muxed_52;
      c_addr_muxed_53_reg <= c_addr_muxed_53;
      c_addr_muxed_54_reg <= c_addr_muxed_54;
      c_addr_muxed_55_reg <= c_addr_muxed_55;
      c_addr_muxed_56_reg <= c_addr_muxed_56;
      c_addr_muxed_57_reg <= c_addr_muxed_57;
      c_addr_muxed_60_reg <= c_addr_muxed_60;
      c_addr_muxed_61_reg <= c_addr_muxed_61;
      c_addr_muxed_62_reg <= c_addr_muxed_62;
      c_addr_muxed_63_reg <= c_addr_muxed_63;
      c_addr_muxed_64_reg <= c_addr_muxed_64;
      c_addr_muxed_65_reg <= c_addr_muxed_65;
      c_addr_muxed_66_reg <= c_addr_muxed_66;
      c_addr_muxed_67_reg <= c_addr_muxed_67;
      c_addr_muxed_70_reg <= c_addr_muxed_70;
      c_addr_muxed_71_reg <= c_addr_muxed_71;
      c_addr_muxed_72_reg <= c_addr_muxed_72;
      c_addr_muxed_73_reg <= c_addr_muxed_73;
      c_addr_muxed_74_reg <= c_addr_muxed_74;
      c_addr_muxed_75_reg <= c_addr_muxed_75;
      c_addr_muxed_76_reg <= c_addr_muxed_76;
      c_addr_muxed_77_reg <= c_addr_muxed_77;
    end
  end
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_03;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_04;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_05;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_06;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_07;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_17;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_23;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_24;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_25;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_26;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_27;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_30;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_31;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_32;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_33;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_34;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_35;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_36;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_37;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_40;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_41;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_42;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_43;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_44;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_45;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_46;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_47;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_50;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_51;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_52;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_53;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_54;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_55;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_56;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_57;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_60;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_61;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_62;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_63;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_64;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_65;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_66;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_67;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_70;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_71;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_72;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_73;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_74;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_75;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_76;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_77;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_00;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_02;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_03;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_04;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_05;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_06;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_07;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_12;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_13;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_14;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_17;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_20;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_21;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_22;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_23;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_24;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_25;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_26;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_27;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_30;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_31;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_32;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_33;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_34;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_35;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_36;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_37;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_40;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_41;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_42;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_43;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_44;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_45;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_46;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_47;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_50;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_51;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_52;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_53;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_54;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_55;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_56;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_57;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_60;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_61;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_62;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_63;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_64;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_65;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_66;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_67;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_70;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_71;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_72;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_73;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_74;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_75;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_76;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_77;

  assign data_from_out_mat =  data_from_out_mat_00 |
  data_from_out_mat_01 |
  data_from_out_mat_02 |
  data_from_out_mat_03 |
  data_from_out_mat_04 |
  data_from_out_mat_05 |
  data_from_out_mat_06 |
  data_from_out_mat_07 |
  data_from_out_mat_10 |
  data_from_out_mat_11 |
  data_from_out_mat_12 |
  data_from_out_mat_13 |
  data_from_out_mat_14 |
  data_from_out_mat_15 |
  data_from_out_mat_16 |
  data_from_out_mat_17 |
  data_from_out_mat_20 |
  data_from_out_mat_21 |
  data_from_out_mat_22 |
  data_from_out_mat_23 |
  data_from_out_mat_24 |
  data_from_out_mat_25 |
  data_from_out_mat_26 |
  data_from_out_mat_27 |
  data_from_out_mat_30 |
  data_from_out_mat_31 |
  data_from_out_mat_32 |
  data_from_out_mat_33 |
  data_from_out_mat_34 |
  data_from_out_mat_35 |
  data_from_out_mat_36 |
  data_from_out_mat_37 |
  data_from_out_mat_40 |
  data_from_out_mat_41 |
  data_from_out_mat_42 |
  data_from_out_mat_43 |
  data_from_out_mat_44 |
  data_from_out_mat_45 |
  data_from_out_mat_46 |
  data_from_out_mat_47 |
  data_from_out_mat_50 |
  data_from_out_mat_51 |
  data_from_out_mat_52 |
  data_from_out_mat_53 |
  data_from_out_mat_54 |
  data_from_out_mat_55 |
  data_from_out_mat_56 |
  data_from_out_mat_57 |
  data_from_out_mat_60 |
  data_from_out_mat_61 |
  data_from_out_mat_62 |
  data_from_out_mat_63 |
  data_from_out_mat_64 |
  data_from_out_mat_65 |
  data_from_out_mat_66 |
  data_from_out_mat_67 |
  data_from_out_mat_70 |
  data_from_out_mat_71 |
  data_from_out_mat_72 |
  data_from_out_mat_73 |
  data_from_out_mat_74 |
  data_from_out_mat_75 |
  data_from_out_mat_76 |
  data_from_out_mat_77 ;

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

  //  BRAM matrix C04
  ram matrix_c_04 (
    .addr0(c_addr_muxed_04_reg),
    .d0(c_data_04),
    .we0(we_c),
    .q0(data_from_out_mat_04),
    .clk(clk));

  //  BRAM matrix C05
  ram matrix_c_05 (
    .addr0(c_addr_muxed_05_reg),
    .d0(c_data_05),
    .we0(we_c),
    .q0(data_from_out_mat_05),
    .clk(clk));

  //  BRAM matrix C06
  ram matrix_c_06 (
    .addr0(c_addr_muxed_06_reg),
    .d0(c_data_06),
    .we0(we_c),
    .q0(data_from_out_mat_06),
    .clk(clk));

  //  BRAM matrix C07
  ram matrix_c_07 (
    .addr0(c_addr_muxed_07_reg),
    .d0(c_data_07),
    .we0(we_c),
    .q0(data_from_out_mat_07),
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

  //  BRAM matrix C14
  ram matrix_c_14 (
    .addr0(c_addr_muxed_14_reg),
    .d0(c_data_14),
    .we0(we_c),
    .q0(data_from_out_mat_14),
    .clk(clk));

  //  BRAM matrix C15
  ram matrix_c_15 (
    .addr0(c_addr_muxed_15_reg),
    .d0(c_data_15),
    .we0(we_c),
    .q0(data_from_out_mat_15),
    .clk(clk));

  //  BRAM matrix C16
  ram matrix_c_16 (
    .addr0(c_addr_muxed_16_reg),
    .d0(c_data_16),
    .we0(we_c),
    .q0(data_from_out_mat_16),
    .clk(clk));

  //  BRAM matrix C17
  ram matrix_c_17 (
    .addr0(c_addr_muxed_17_reg),
    .d0(c_data_17),
    .we0(we_c),
    .q0(data_from_out_mat_17),
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

  //  BRAM matrix C24
  ram matrix_c_24 (
    .addr0(c_addr_muxed_24_reg),
    .d0(c_data_24),
    .we0(we_c),
    .q0(data_from_out_mat_24),
    .clk(clk));

  //  BRAM matrix C25
  ram matrix_c_25 (
    .addr0(c_addr_muxed_25_reg),
    .d0(c_data_25),
    .we0(we_c),
    .q0(data_from_out_mat_25),
    .clk(clk));

  //  BRAM matrix C26
  ram matrix_c_26 (
    .addr0(c_addr_muxed_26_reg),
    .d0(c_data_26),
    .we0(we_c),
    .q0(data_from_out_mat_26),
    .clk(clk));

  //  BRAM matrix C27
  ram matrix_c_27 (
    .addr0(c_addr_muxed_27_reg),
    .d0(c_data_27),
    .we0(we_c),
    .q0(data_from_out_mat_27),
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

  //  BRAM matrix C34
  ram matrix_c_34 (
    .addr0(c_addr_muxed_34_reg),
    .d0(c_data_34),
    .we0(we_c),
    .q0(data_from_out_mat_34),
    .clk(clk));

  //  BRAM matrix C35
  ram matrix_c_35 (
    .addr0(c_addr_muxed_35_reg),
    .d0(c_data_35),
    .we0(we_c),
    .q0(data_from_out_mat_35),
    .clk(clk));

  //  BRAM matrix C36
  ram matrix_c_36 (
    .addr0(c_addr_muxed_36_reg),
    .d0(c_data_36),
    .we0(we_c),
    .q0(data_from_out_mat_36),
    .clk(clk));

  //  BRAM matrix C37
  ram matrix_c_37 (
    .addr0(c_addr_muxed_37_reg),
    .d0(c_data_37),
    .we0(we_c),
    .q0(data_from_out_mat_37),
    .clk(clk));

  //  BRAM matrix C40
  ram matrix_c_40 (
    .addr0(c_addr_muxed_40_reg),
    .d0(c_data_40),
    .we0(we_c),
    .q0(data_from_out_mat_40),
    .clk(clk));

  //  BRAM matrix C41
  ram matrix_c_41 (
    .addr0(c_addr_muxed_41_reg),
    .d0(c_data_41),
    .we0(we_c),
    .q0(data_from_out_mat_41),
    .clk(clk));

  //  BRAM matrix C42
  ram matrix_c_42 (
    .addr0(c_addr_muxed_42_reg),
    .d0(c_data_42),
    .we0(we_c),
    .q0(data_from_out_mat_42),
    .clk(clk));

  //  BRAM matrix C43
  ram matrix_c_43 (
    .addr0(c_addr_muxed_43_reg),
    .d0(c_data_43),
    .we0(we_c),
    .q0(data_from_out_mat_43),
    .clk(clk));

  //  BRAM matrix C44
  ram matrix_c_44 (
    .addr0(c_addr_muxed_44_reg),
    .d0(c_data_44),
    .we0(we_c),
    .q0(data_from_out_mat_44),
    .clk(clk));

  //  BRAM matrix C45
  ram matrix_c_45 (
    .addr0(c_addr_muxed_45_reg),
    .d0(c_data_45),
    .we0(we_c),
    .q0(data_from_out_mat_45),
    .clk(clk));

  //  BRAM matrix C46
  ram matrix_c_46 (
    .addr0(c_addr_muxed_46_reg),
    .d0(c_data_46),
    .we0(we_c),
    .q0(data_from_out_mat_46),
    .clk(clk));

  //  BRAM matrix C47
  ram matrix_c_47 (
    .addr0(c_addr_muxed_47_reg),
    .d0(c_data_47),
    .we0(we_c),
    .q0(data_from_out_mat_47),
    .clk(clk));

  //  BRAM matrix C50
  ram matrix_c_50 (
    .addr0(c_addr_muxed_50_reg),
    .d0(c_data_50),
    .we0(we_c),
    .q0(data_from_out_mat_50),
    .clk(clk));

  //  BRAM matrix C51
  ram matrix_c_51 (
    .addr0(c_addr_muxed_51_reg),
    .d0(c_data_51),
    .we0(we_c),
    .q0(data_from_out_mat_51),
    .clk(clk));

  //  BRAM matrix C52
  ram matrix_c_52 (
    .addr0(c_addr_muxed_52_reg),
    .d0(c_data_52),
    .we0(we_c),
    .q0(data_from_out_mat_52),
    .clk(clk));

  //  BRAM matrix C53
  ram matrix_c_53 (
    .addr0(c_addr_muxed_53_reg),
    .d0(c_data_53),
    .we0(we_c),
    .q0(data_from_out_mat_53),
    .clk(clk));

  //  BRAM matrix C54
  ram matrix_c_54 (
    .addr0(c_addr_muxed_54_reg),
    .d0(c_data_54),
    .we0(we_c),
    .q0(data_from_out_mat_54),
    .clk(clk));

  //  BRAM matrix C55
  ram matrix_c_55 (
    .addr0(c_addr_muxed_55_reg),
    .d0(c_data_55),
    .we0(we_c),
    .q0(data_from_out_mat_55),
    .clk(clk));

  //  BRAM matrix C56
  ram matrix_c_56 (
    .addr0(c_addr_muxed_56_reg),
    .d0(c_data_56),
    .we0(we_c),
    .q0(data_from_out_mat_56),
    .clk(clk));

  //  BRAM matrix C57
  ram matrix_c_57 (
    .addr0(c_addr_muxed_57_reg),
    .d0(c_data_57),
    .we0(we_c),
    .q0(data_from_out_mat_57),
    .clk(clk));

  //  BRAM matrix C60
  ram matrix_c_60 (
    .addr0(c_addr_muxed_60_reg),
    .d0(c_data_60),
    .we0(we_c),
    .q0(data_from_out_mat_60),
    .clk(clk));

  //  BRAM matrix C61
  ram matrix_c_61 (
    .addr0(c_addr_muxed_61_reg),
    .d0(c_data_61),
    .we0(we_c),
    .q0(data_from_out_mat_61),
    .clk(clk));

  //  BRAM matrix C62
  ram matrix_c_62 (
    .addr0(c_addr_muxed_62_reg),
    .d0(c_data_62),
    .we0(we_c),
    .q0(data_from_out_mat_62),
    .clk(clk));

  //  BRAM matrix C63
  ram matrix_c_63 (
    .addr0(c_addr_muxed_63_reg),
    .d0(c_data_63),
    .we0(we_c),
    .q0(data_from_out_mat_63),
    .clk(clk));

  //  BRAM matrix C64
  ram matrix_c_64 (
    .addr0(c_addr_muxed_64_reg),
    .d0(c_data_64),
    .we0(we_c),
    .q0(data_from_out_mat_64),
    .clk(clk));

  //  BRAM matrix C65
  ram matrix_c_65 (
    .addr0(c_addr_muxed_65_reg),
    .d0(c_data_65),
    .we0(we_c),
    .q0(data_from_out_mat_65),
    .clk(clk));

  //  BRAM matrix C66
  ram matrix_c_66 (
    .addr0(c_addr_muxed_66_reg),
    .d0(c_data_66),
    .we0(we_c),
    .q0(data_from_out_mat_66),
    .clk(clk));

  //  BRAM matrix C67
  ram matrix_c_67 (
    .addr0(c_addr_muxed_67_reg),
    .d0(c_data_67),
    .we0(we_c),
    .q0(data_from_out_mat_67),
    .clk(clk));

  //  BRAM matrix C70
  ram matrix_c_70 (
    .addr0(c_addr_muxed_70_reg),
    .d0(c_data_70),
    .we0(we_c),
    .q0(data_from_out_mat_70),
    .clk(clk));

  //  BRAM matrix C71
  ram matrix_c_71 (
    .addr0(c_addr_muxed_71_reg),
    .d0(c_data_71),
    .we0(we_c),
    .q0(data_from_out_mat_71),
    .clk(clk));

  //  BRAM matrix C72
  ram matrix_c_72 (
    .addr0(c_addr_muxed_72_reg),
    .d0(c_data_72),
    .we0(we_c),
    .q0(data_from_out_mat_72),
    .clk(clk));

  //  BRAM matrix C73
  ram matrix_c_73 (
    .addr0(c_addr_muxed_73_reg),
    .d0(c_data_73),
    .we0(we_c),
    .q0(data_from_out_mat_73),
    .clk(clk));

  //  BRAM matrix C74
  ram matrix_c_74 (
    .addr0(c_addr_muxed_74_reg),
    .d0(c_data_74),
    .we0(we_c),
    .q0(data_from_out_mat_74),
    .clk(clk));

  //  BRAM matrix C75
  ram matrix_c_75 (
    .addr0(c_addr_muxed_75_reg),
    .d0(c_data_75),
    .we0(we_c),
    .q0(data_from_out_mat_75),
    .clk(clk));

  //  BRAM matrix C76
  ram matrix_c_76 (
    .addr0(c_addr_muxed_76_reg),
    .d0(c_data_76),
    .we0(we_c),
    .q0(data_from_out_mat_76),
    .clk(clk));

  //  BRAM matrix C77
  ram matrix_c_77 (
    .addr0(c_addr_muxed_77_reg),
    .d0(c_data_77),
    .we0(we_c),
    .q0(data_from_out_mat_77),
    .clk(clk));

/////////////////////////////////////////////////
// The 32x32 matmul instantiation
/////////////////////////////////////////////////

matmul_32x32_systolic u_matmul_32x32_systolic (
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
  .a_data_40(a_data_40),
  .a_addr_40(a_addr_40),
  .b_data_04(b_data_04),
  .b_addr_04(b_addr_04),
  .a_data_50(a_data_50),
  .a_addr_50(a_addr_50),
  .b_data_05(b_data_05),
  .b_addr_05(b_addr_05),
  .a_data_60(a_data_60),
  .a_addr_60(a_addr_60),
  .b_data_06(b_data_06),
  .b_addr_06(b_addr_06),
  .a_data_70(a_data_70),
  .a_addr_70(a_addr_70),
  .b_data_07(b_data_07),
  .b_addr_07(b_addr_07),

  .c_data_00(c_data_00),
  .c_addr_00(c_addr_00),
  .c_data_01(c_data_01),
  .c_addr_01(c_addr_01),
  .c_data_02(c_data_02),
  .c_addr_02(c_addr_02),
  .c_data_03(c_data_03),
  .c_addr_03(c_addr_03),
  .c_data_04(c_data_04),
  .c_addr_04(c_addr_04),
  .c_data_05(c_data_05),
  .c_addr_05(c_addr_05),
  .c_data_06(c_data_06),
  .c_addr_06(c_addr_06),
  .c_data_07(c_data_07),
  .c_addr_07(c_addr_07),
  .c_data_10(c_data_10),
  .c_addr_10(c_addr_10),
  .c_data_11(c_data_11),
  .c_addr_11(c_addr_11),
  .c_data_12(c_data_12),
  .c_addr_12(c_addr_12),
  .c_data_13(c_data_13),
  .c_addr_13(c_addr_13),
  .c_data_14(c_data_14),
  .c_addr_14(c_addr_14),
  .c_data_15(c_data_15),
  .c_addr_15(c_addr_15),
  .c_data_16(c_data_16),
  .c_addr_16(c_addr_16),
  .c_data_17(c_data_17),
  .c_addr_17(c_addr_17),
  .c_data_20(c_data_20),
  .c_addr_20(c_addr_20),
  .c_data_21(c_data_21),
  .c_addr_21(c_addr_21),
  .c_data_22(c_data_22),
  .c_addr_22(c_addr_22),
  .c_data_23(c_data_23),
  .c_addr_23(c_addr_23),
  .c_data_24(c_data_24),
  .c_addr_24(c_addr_24),
  .c_data_25(c_data_25),
  .c_addr_25(c_addr_25),
  .c_data_26(c_data_26),
  .c_addr_26(c_addr_26),
  .c_data_27(c_data_27),
  .c_addr_27(c_addr_27),
  .c_data_30(c_data_30),
  .c_addr_30(c_addr_30),
  .c_data_31(c_data_31),
  .c_addr_31(c_addr_31),
  .c_data_32(c_data_32),
  .c_addr_32(c_addr_32),
  .c_data_33(c_data_33),
  .c_addr_33(c_addr_33),
  .c_data_34(c_data_34),
  .c_addr_34(c_addr_34),
  .c_data_35(c_data_35),
  .c_addr_35(c_addr_35),
  .c_data_36(c_data_36),
  .c_addr_36(c_addr_36),
  .c_data_37(c_data_37),
  .c_addr_37(c_addr_37),
  .c_data_40(c_data_40),
  .c_addr_40(c_addr_40),
  .c_data_41(c_data_41),
  .c_addr_41(c_addr_41),
  .c_data_42(c_data_42),
  .c_addr_42(c_addr_42),
  .c_data_43(c_data_43),
  .c_addr_43(c_addr_43),
  .c_data_44(c_data_44),
  .c_addr_44(c_addr_44),
  .c_data_45(c_data_45),
  .c_addr_45(c_addr_45),
  .c_data_46(c_data_46),
  .c_addr_46(c_addr_46),
  .c_data_47(c_data_47),
  .c_addr_47(c_addr_47),
  .c_data_50(c_data_50),
  .c_addr_50(c_addr_50),
  .c_data_51(c_data_51),
  .c_addr_51(c_addr_51),
  .c_data_52(c_data_52),
  .c_addr_52(c_addr_52),
  .c_data_53(c_data_53),
  .c_addr_53(c_addr_53),
  .c_data_54(c_data_54),
  .c_addr_54(c_addr_54),
  .c_data_55(c_data_55),
  .c_addr_55(c_addr_55),
  .c_data_56(c_data_56),
  .c_addr_56(c_addr_56),
  .c_data_57(c_data_57),
  .c_addr_57(c_addr_57),
  .c_data_60(c_data_60),
  .c_addr_60(c_addr_60),
  .c_data_61(c_data_61),
  .c_addr_61(c_addr_61),
  .c_data_62(c_data_62),
  .c_addr_62(c_addr_62),
  .c_data_63(c_data_63),
  .c_addr_63(c_addr_63),
  .c_data_64(c_data_64),
  .c_addr_64(c_addr_64),
  .c_data_65(c_data_65),
  .c_addr_65(c_addr_65),
  .c_data_66(c_data_66),
  .c_addr_66(c_addr_66),
  .c_data_67(c_data_67),
  .c_addr_67(c_addr_67),
  .c_data_70(c_data_70),
  .c_addr_70(c_addr_70),
  .c_data_71(c_data_71),
  .c_addr_71(c_addr_71),
  .c_data_72(c_data_72),
  .c_addr_72(c_addr_72),
  .c_data_73(c_data_73),
  .c_addr_73(c_addr_73),
  .c_data_74(c_data_74),
  .c_addr_74(c_addr_74),
  .c_data_75(c_data_75),
  .c_addr_75(c_addr_75),
  .c_data_76(c_data_76),
  .c_addr_76(c_addr_76),
  .c_data_77(c_data_77),
  .c_addr_77(c_addr_77)

);
endmodule


/////////////////////////////////////////////////
// The 32x32 matmul definition
/////////////////////////////////////////////////

module matmul_32x32_systolic(
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
  a_data_40,
  a_addr_40,
  b_data_04,
  b_addr_04,
  a_data_50,
  a_addr_50,
  b_data_05,
  b_addr_05,
  a_data_60,
  a_addr_60,
  b_data_06,
  b_addr_06,
  a_data_70,
  a_addr_70,
  b_data_07,
  b_addr_07,

  c_data_00,
  c_addr_00,
  c_data_01,
  c_addr_01,
  c_data_02,
  c_addr_02,
  c_data_03,
  c_addr_03,
  c_data_04,
  c_addr_04,
  c_data_05,
  c_addr_05,
  c_data_06,
  c_addr_06,
  c_data_07,
  c_addr_07,
  c_data_10,
  c_addr_10,
  c_data_11,
  c_addr_11,
  c_data_12,
  c_addr_12,
  c_data_13,
  c_addr_13,
  c_data_14,
  c_addr_14,
  c_data_15,
  c_addr_15,
  c_data_16,
  c_addr_16,
  c_data_17,
  c_addr_17,
  c_data_20,
  c_addr_20,
  c_data_21,
  c_addr_21,
  c_data_22,
  c_addr_22,
  c_data_23,
  c_addr_23,
  c_data_24,
  c_addr_24,
  c_data_25,
  c_addr_25,
  c_data_26,
  c_addr_26,
  c_data_27,
  c_addr_27,
  c_data_30,
  c_addr_30,
  c_data_31,
  c_addr_31,
  c_data_32,
  c_addr_32,
  c_data_33,
  c_addr_33,
  c_data_34,
  c_addr_34,
  c_data_35,
  c_addr_35,
  c_data_36,
  c_addr_36,
  c_data_37,
  c_addr_37,
  c_data_40,
  c_addr_40,
  c_data_41,
  c_addr_41,
  c_data_42,
  c_addr_42,
  c_data_43,
  c_addr_43,
  c_data_44,
  c_addr_44,
  c_data_45,
  c_addr_45,
  c_data_46,
  c_addr_46,
  c_data_47,
  c_addr_47,
  c_data_50,
  c_addr_50,
  c_data_51,
  c_addr_51,
  c_data_52,
  c_addr_52,
  c_data_53,
  c_addr_53,
  c_data_54,
  c_addr_54,
  c_data_55,
  c_addr_55,
  c_data_56,
  c_addr_56,
  c_data_57,
  c_addr_57,
  c_data_60,
  c_addr_60,
  c_data_61,
  c_addr_61,
  c_data_62,
  c_addr_62,
  c_data_63,
  c_addr_63,
  c_data_64,
  c_addr_64,
  c_data_65,
  c_addr_65,
  c_data_66,
  c_addr_66,
  c_data_67,
  c_addr_67,
  c_data_70,
  c_addr_70,
  c_data_71,
  c_addr_71,
  c_data_72,
  c_addr_72,
  c_data_73,
  c_addr_73,
  c_data_74,
  c_addr_74,
  c_data_75,
  c_addr_75,
  c_data_76,
  c_addr_76,
  c_data_77,
  c_addr_77
);
  input clk;
  input reset;
  input start_mat_mul;
  output done_mat_mul;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_30;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_40;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_50;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_60;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_70;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_03;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_04;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_05;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_06;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_07;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_03;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_04;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_05;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_06;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_07;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_14;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_15;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_16;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_17;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_23;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_24;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_25;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_26;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_27;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_30;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_31;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_32;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_33;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_34;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_35;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_36;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_37;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_40;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_41;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_42;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_43;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_44;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_45;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_46;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_47;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_50;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_51;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_52;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_53;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_54;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_55;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_56;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_57;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_60;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_61;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_62;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_63;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_64;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_65;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_66;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_67;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_70;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_71;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_72;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_73;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_74;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_75;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_76;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_77;

  output [`AWIDTH-1:0] a_addr_00;
  output [`AWIDTH-1:0] a_addr_10;
  output [`AWIDTH-1:0] a_addr_20;
  output [`AWIDTH-1:0] a_addr_30;
  output [`AWIDTH-1:0] a_addr_40;
  output [`AWIDTH-1:0] a_addr_50;
  output [`AWIDTH-1:0] a_addr_60;
  output [`AWIDTH-1:0] a_addr_70;

  output [`AWIDTH-1:0] b_addr_00;
  output [`AWIDTH-1:0] b_addr_01;
  output [`AWIDTH-1:0] b_addr_02;
  output [`AWIDTH-1:0] b_addr_03;
  output [`AWIDTH-1:0] b_addr_04;
  output [`AWIDTH-1:0] b_addr_05;
  output [`AWIDTH-1:0] b_addr_06;
  output [`AWIDTH-1:0] b_addr_07;

  output [`AWIDTH-1:0] c_addr_00;
  output [`AWIDTH-1:0] c_addr_01;
  output [`AWIDTH-1:0] c_addr_02;
  output [`AWIDTH-1:0] c_addr_03;
  output [`AWIDTH-1:0] c_addr_04;
  output [`AWIDTH-1:0] c_addr_05;
  output [`AWIDTH-1:0] c_addr_06;
  output [`AWIDTH-1:0] c_addr_07;
  output [`AWIDTH-1:0] c_addr_10;
  output [`AWIDTH-1:0] c_addr_11;
  output [`AWIDTH-1:0] c_addr_12;
  output [`AWIDTH-1:0] c_addr_13;
  output [`AWIDTH-1:0] c_addr_14;
  output [`AWIDTH-1:0] c_addr_15;
  output [`AWIDTH-1:0] c_addr_16;
  output [`AWIDTH-1:0] c_addr_17;
  output [`AWIDTH-1:0] c_addr_20;
  output [`AWIDTH-1:0] c_addr_21;
  output [`AWIDTH-1:0] c_addr_22;
  output [`AWIDTH-1:0] c_addr_23;
  output [`AWIDTH-1:0] c_addr_24;
  output [`AWIDTH-1:0] c_addr_25;
  output [`AWIDTH-1:0] c_addr_26;
  output [`AWIDTH-1:0] c_addr_27;
  output [`AWIDTH-1:0] c_addr_30;
  output [`AWIDTH-1:0] c_addr_31;
  output [`AWIDTH-1:0] c_addr_32;
  output [`AWIDTH-1:0] c_addr_33;
  output [`AWIDTH-1:0] c_addr_34;
  output [`AWIDTH-1:0] c_addr_35;
  output [`AWIDTH-1:0] c_addr_36;
  output [`AWIDTH-1:0] c_addr_37;
  output [`AWIDTH-1:0] c_addr_40;
  output [`AWIDTH-1:0] c_addr_41;
  output [`AWIDTH-1:0] c_addr_42;
  output [`AWIDTH-1:0] c_addr_43;
  output [`AWIDTH-1:0] c_addr_44;
  output [`AWIDTH-1:0] c_addr_45;
  output [`AWIDTH-1:0] c_addr_46;
  output [`AWIDTH-1:0] c_addr_47;
  output [`AWIDTH-1:0] c_addr_50;
  output [`AWIDTH-1:0] c_addr_51;
  output [`AWIDTH-1:0] c_addr_52;
  output [`AWIDTH-1:0] c_addr_53;
  output [`AWIDTH-1:0] c_addr_54;
  output [`AWIDTH-1:0] c_addr_55;
  output [`AWIDTH-1:0] c_addr_56;
  output [`AWIDTH-1:0] c_addr_57;
  output [`AWIDTH-1:0] c_addr_60;
  output [`AWIDTH-1:0] c_addr_61;
  output [`AWIDTH-1:0] c_addr_62;
  output [`AWIDTH-1:0] c_addr_63;
  output [`AWIDTH-1:0] c_addr_64;
  output [`AWIDTH-1:0] c_addr_65;
  output [`AWIDTH-1:0] c_addr_66;
  output [`AWIDTH-1:0] c_addr_67;
  output [`AWIDTH-1:0] c_addr_70;
  output [`AWIDTH-1:0] c_addr_71;
  output [`AWIDTH-1:0] c_addr_72;
  output [`AWIDTH-1:0] c_addr_73;
  output [`AWIDTH-1:0] c_addr_74;
  output [`AWIDTH-1:0] c_addr_75;
  output [`AWIDTH-1:0] c_addr_76;
  output [`AWIDTH-1:0] c_addr_77;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_00;
  wire done_mat_mul_01;
  wire done_mat_mul_02;
  wire done_mat_mul_03;
  wire done_mat_mul_04;
  wire done_mat_mul_05;
  wire done_mat_mul_06;
  wire done_mat_mul_07;
  wire done_mat_mul_10;
  wire done_mat_mul_11;
  wire done_mat_mul_12;
  wire done_mat_mul_13;
  wire done_mat_mul_14;
  wire done_mat_mul_15;
  wire done_mat_mul_16;
  wire done_mat_mul_17;
  wire done_mat_mul_20;
  wire done_mat_mul_21;
  wire done_mat_mul_22;
  wire done_mat_mul_23;
  wire done_mat_mul_24;
  wire done_mat_mul_25;
  wire done_mat_mul_26;
  wire done_mat_mul_27;
  wire done_mat_mul_30;
  wire done_mat_mul_31;
  wire done_mat_mul_32;
  wire done_mat_mul_33;
  wire done_mat_mul_34;
  wire done_mat_mul_35;
  wire done_mat_mul_36;
  wire done_mat_mul_37;
  wire done_mat_mul_40;
  wire done_mat_mul_41;
  wire done_mat_mul_42;
  wire done_mat_mul_43;
  wire done_mat_mul_44;
  wire done_mat_mul_45;
  wire done_mat_mul_46;
  wire done_mat_mul_47;
  wire done_mat_mul_50;
  wire done_mat_mul_51;
  wire done_mat_mul_52;
  wire done_mat_mul_53;
  wire done_mat_mul_54;
  wire done_mat_mul_55;
  wire done_mat_mul_56;
  wire done_mat_mul_57;
  wire done_mat_mul_60;
  wire done_mat_mul_61;
  wire done_mat_mul_62;
  wire done_mat_mul_63;
  wire done_mat_mul_64;
  wire done_mat_mul_65;
  wire done_mat_mul_66;
  wire done_mat_mul_67;
  wire done_mat_mul_70;
  wire done_mat_mul_71;
  wire done_mat_mul_72;
  wire done_mat_mul_73;
  wire done_mat_mul_74;
  wire done_mat_mul_75;
  wire done_mat_mul_76;
  wire done_mat_mul_77;

  assign done_mat_mul =   done_mat_mul_00 &&
  done_mat_mul_01 &&
  done_mat_mul_02 &&
  done_mat_mul_03 &&
  done_mat_mul_04 &&
  done_mat_mul_05 &&
  done_mat_mul_06 &&
  done_mat_mul_07 &&
  done_mat_mul_10 &&
  done_mat_mul_11 &&
  done_mat_mul_12 &&
  done_mat_mul_13 &&
  done_mat_mul_14 &&
  done_mat_mul_15 &&
  done_mat_mul_16 &&
  done_mat_mul_17 &&
  done_mat_mul_20 &&
  done_mat_mul_21 &&
  done_mat_mul_22 &&
  done_mat_mul_23 &&
  done_mat_mul_24 &&
  done_mat_mul_25 &&
  done_mat_mul_26 &&
  done_mat_mul_27 &&
  done_mat_mul_30 &&
  done_mat_mul_31 &&
  done_mat_mul_32 &&
  done_mat_mul_33 &&
  done_mat_mul_34 &&
  done_mat_mul_35 &&
  done_mat_mul_36 &&
  done_mat_mul_37 &&
  done_mat_mul_40 &&
  done_mat_mul_41 &&
  done_mat_mul_42 &&
  done_mat_mul_43 &&
  done_mat_mul_44 &&
  done_mat_mul_45 &&
  done_mat_mul_46 &&
  done_mat_mul_47 &&
  done_mat_mul_50 &&
  done_mat_mul_51 &&
  done_mat_mul_52 &&
  done_mat_mul_53 &&
  done_mat_mul_54 &&
  done_mat_mul_55 &&
  done_mat_mul_56 &&
  done_mat_mul_57 &&
  done_mat_mul_60 &&
  done_mat_mul_61 &&
  done_mat_mul_62 &&
  done_mat_mul_63 &&
  done_mat_mul_64 &&
  done_mat_mul_65 &&
  done_mat_mul_66 &&
  done_mat_mul_67 &&
  done_mat_mul_70 &&
  done_mat_mul_71 &&
  done_mat_mul_72 &&
  done_mat_mul_73 &&
  done_mat_mul_74 &&
  done_mat_mul_75 &&
  done_mat_mul_76 &&
  done_mat_mul_77;

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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
  .a_loc(8'd0),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 04
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_04_to_05;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_04_to_14;
  wire [`AWIDTH-1:0] a_addr_04_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_04_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_04_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_04(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_04),
  .a_data(a_data_04_NC),
  .b_data(b_data_04),
  .a_data_in(a_data_03_to_04),
  .b_data_in(b_data_in_04_NC),
  .c_data(c_data_04),
  .a_data_out(a_data_04_to_05),
  .b_data_out(b_data_04_to_14),
  .a_addr(a_addr_04_NC),
  .b_addr(b_addr_04),
  .c_addr(c_addr_04),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd0),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 05
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_05_to_06;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_05_to_15;
  wire [`AWIDTH-1:0] a_addr_05_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_05_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_05_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_05(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_05),
  .a_data(a_data_05_NC),
  .b_data(b_data_05),
  .a_data_in(a_data_04_to_05),
  .b_data_in(b_data_in_05_NC),
  .c_data(c_data_05),
  .a_data_out(a_data_05_to_06),
  .b_data_out(b_data_05_to_15),
  .a_addr(a_addr_05_NC),
  .b_addr(b_addr_05),
  .c_addr(c_addr_05),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd0),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 06
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_06_to_07;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_06_to_16;
  wire [`AWIDTH-1:0] a_addr_06_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_06_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_06_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_06(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_06),
  .a_data(a_data_06_NC),
  .b_data(b_data_06),
  .a_data_in(a_data_05_to_06),
  .b_data_in(b_data_in_06_NC),
  .c_data(c_data_06),
  .a_data_out(a_data_06_to_07),
  .b_data_out(b_data_06_to_16),
  .a_addr(a_addr_06_NC),
  .b_addr(b_addr_06),
  .c_addr(c_addr_06),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd0),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 07
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_07_to_08;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_07_to_17;
  wire [`AWIDTH-1:0] a_addr_07_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_07_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_07_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_07(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_07),
  .a_data(a_data_07_NC),
  .b_data(b_data_07),
  .a_data_in(a_data_06_to_07),
  .b_data_in(b_data_in_07_NC),
  .c_data(c_data_07),
  .a_data_out(a_data_07_to_08),
  .b_data_out(b_data_07_to_17),
  .a_addr(a_addr_07_NC),
  .b_addr(b_addr_07),
  .c_addr(c_addr_07),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd0),
  .b_loc(8'd7)
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
  .a_loc(8'd1),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 14
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_to_15;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_to_24;
  wire [`AWIDTH-1:0] a_addr_14_NC;
  wire [`AWIDTH-1:0] b_addr_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_14_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_14_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_14(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_14),
  .a_data(a_data_14_NC),
  .b_data(b_data_14_NC),
  .a_data_in(a_data_13_to_14),
  .b_data_in(b_data_04_to_14),
  .c_data(c_data_14),
  .a_data_out(a_data_14_to_15),
  .b_data_out(b_data_14_to_24),
  .a_addr(a_addr_14_NC),
  .b_addr(b_addr_14_NC),
  .c_addr(c_addr_14),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd1),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 15
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_to_16;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_to_25;
  wire [`AWIDTH-1:0] a_addr_15_NC;
  wire [`AWIDTH-1:0] b_addr_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_15_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_15_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_15(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_15),
  .a_data(a_data_15_NC),
  .b_data(b_data_15_NC),
  .a_data_in(a_data_14_to_15),
  .b_data_in(b_data_05_to_15),
  .c_data(c_data_15),
  .a_data_out(a_data_15_to_16),
  .b_data_out(b_data_15_to_25),
  .a_addr(a_addr_15_NC),
  .b_addr(b_addr_15_NC),
  .c_addr(c_addr_15),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd1),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 16
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_16_to_17;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_16_to_26;
  wire [`AWIDTH-1:0] a_addr_16_NC;
  wire [`AWIDTH-1:0] b_addr_16_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_16_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_16_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_16(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_16),
  .a_data(a_data_16_NC),
  .b_data(b_data_16_NC),
  .a_data_in(a_data_15_to_16),
  .b_data_in(b_data_06_to_16),
  .c_data(c_data_16),
  .a_data_out(a_data_16_to_17),
  .b_data_out(b_data_16_to_26),
  .a_addr(a_addr_16_NC),
  .b_addr(b_addr_16_NC),
  .c_addr(c_addr_16),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd1),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 17
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_17_to_18;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_17_to_27;
  wire [`AWIDTH-1:0] a_addr_17_NC;
  wire [`AWIDTH-1:0] b_addr_17_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_17_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_17_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_17(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_17),
  .a_data(a_data_17_NC),
  .b_data(b_data_17_NC),
  .a_data_in(a_data_16_to_17),
  .b_data_in(b_data_07_to_17),
  .c_data(c_data_17),
  .a_data_out(a_data_17_to_18),
  .b_data_out(b_data_17_to_27),
  .a_addr(a_addr_17_NC),
  .b_addr(b_addr_17_NC),
  .c_addr(c_addr_17),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd1),
  .b_loc(8'd7)
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
  .a_loc(8'd2),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 24
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_24_to_25;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_24_to_34;
  wire [`AWIDTH-1:0] a_addr_24_NC;
  wire [`AWIDTH-1:0] b_addr_24_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_24_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_24_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_24(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_24),
  .a_data(a_data_24_NC),
  .b_data(b_data_24_NC),
  .a_data_in(a_data_23_to_24),
  .b_data_in(b_data_14_to_24),
  .c_data(c_data_24),
  .a_data_out(a_data_24_to_25),
  .b_data_out(b_data_24_to_34),
  .a_addr(a_addr_24_NC),
  .b_addr(b_addr_24_NC),
  .c_addr(c_addr_24),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd2),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 25
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_25_to_26;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_25_to_35;
  wire [`AWIDTH-1:0] a_addr_25_NC;
  wire [`AWIDTH-1:0] b_addr_25_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_25_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_25_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_25(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_25),
  .a_data(a_data_25_NC),
  .b_data(b_data_25_NC),
  .a_data_in(a_data_24_to_25),
  .b_data_in(b_data_15_to_25),
  .c_data(c_data_25),
  .a_data_out(a_data_25_to_26),
  .b_data_out(b_data_25_to_35),
  .a_addr(a_addr_25_NC),
  .b_addr(b_addr_25_NC),
  .c_addr(c_addr_25),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd2),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 26
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_26_to_27;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_26_to_36;
  wire [`AWIDTH-1:0] a_addr_26_NC;
  wire [`AWIDTH-1:0] b_addr_26_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_26_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_26_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_26(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_26),
  .a_data(a_data_26_NC),
  .b_data(b_data_26_NC),
  .a_data_in(a_data_25_to_26),
  .b_data_in(b_data_16_to_26),
  .c_data(c_data_26),
  .a_data_out(a_data_26_to_27),
  .b_data_out(b_data_26_to_36),
  .a_addr(a_addr_26_NC),
  .b_addr(b_addr_26_NC),
  .c_addr(c_addr_26),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd2),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 27
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_27_to_28;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_27_to_37;
  wire [`AWIDTH-1:0] a_addr_27_NC;
  wire [`AWIDTH-1:0] b_addr_27_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_27_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_27_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_27(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_27),
  .a_data(a_data_27_NC),
  .b_data(b_data_27_NC),
  .a_data_in(a_data_26_to_27),
  .b_data_in(b_data_17_to_27),
  .c_data(c_data_27),
  .a_data_out(a_data_27_to_28),
  .b_data_out(b_data_27_to_37),
  .a_addr(a_addr_27_NC),
  .b_addr(b_addr_27_NC),
  .c_addr(c_addr_27),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd2),
  .b_loc(8'd7)
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
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
  .final_mat_mul_size(8'd32),
  .a_loc(8'd3),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 34
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_34_to_35;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_34_to_44;
  wire [`AWIDTH-1:0] a_addr_34_NC;
  wire [`AWIDTH-1:0] b_addr_34_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_34_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_34_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_34(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_34),
  .a_data(a_data_34_NC),
  .b_data(b_data_34_NC),
  .a_data_in(a_data_33_to_34),
  .b_data_in(b_data_24_to_34),
  .c_data(c_data_34),
  .a_data_out(a_data_34_to_35),
  .b_data_out(b_data_34_to_44),
  .a_addr(a_addr_34_NC),
  .b_addr(b_addr_34_NC),
  .c_addr(c_addr_34),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd3),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 35
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_35_to_36;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_35_to_45;
  wire [`AWIDTH-1:0] a_addr_35_NC;
  wire [`AWIDTH-1:0] b_addr_35_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_35_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_35_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_35(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_35),
  .a_data(a_data_35_NC),
  .b_data(b_data_35_NC),
  .a_data_in(a_data_34_to_35),
  .b_data_in(b_data_25_to_35),
  .c_data(c_data_35),
  .a_data_out(a_data_35_to_36),
  .b_data_out(b_data_35_to_45),
  .a_addr(a_addr_35_NC),
  .b_addr(b_addr_35_NC),
  .c_addr(c_addr_35),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd3),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 36
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_36_to_37;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_36_to_46;
  wire [`AWIDTH-1:0] a_addr_36_NC;
  wire [`AWIDTH-1:0] b_addr_36_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_36_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_36_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_36(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_36),
  .a_data(a_data_36_NC),
  .b_data(b_data_36_NC),
  .a_data_in(a_data_35_to_36),
  .b_data_in(b_data_26_to_36),
  .c_data(c_data_36),
  .a_data_out(a_data_36_to_37),
  .b_data_out(b_data_36_to_46),
  .a_addr(a_addr_36_NC),
  .b_addr(b_addr_36_NC),
  .c_addr(c_addr_36),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd3),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 37
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_37_to_38;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_37_to_47;
  wire [`AWIDTH-1:0] a_addr_37_NC;
  wire [`AWIDTH-1:0] b_addr_37_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_37_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_37_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_37(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_37),
  .a_data(a_data_37_NC),
  .b_data(b_data_37_NC),
  .a_data_in(a_data_36_to_37),
  .b_data_in(b_data_27_to_37),
  .c_data(c_data_37),
  .a_data_out(a_data_37_to_38),
  .b_data_out(b_data_37_to_47),
  .a_addr(a_addr_37_NC),
  .b_addr(b_addr_37_NC),
  .c_addr(c_addr_37),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd3),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 40
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_40_to_41;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_40_to_50;
  wire [`AWIDTH-1:0] b_addr_40_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_40_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_40_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_40(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_40),
  .a_data(a_data_40),
  .b_data(b_data_40_NC),
  .a_data_in(a_data_in_40_NC),
  .b_data_in(b_data_30_to_40),
  .c_data(c_data_40),
  .a_data_out(a_data_40_to_41),
  .b_data_out(b_data_40_to_50),
  .a_addr(a_addr_40),
  .b_addr(b_addr_40_NC),
  .c_addr(c_addr_40),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 41
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_41_to_42;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_41_to_51;
  wire [`AWIDTH-1:0] a_addr_41_NC;
  wire [`AWIDTH-1:0] b_addr_41_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_41_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_41_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_41(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_41),
  .a_data(a_data_41_NC),
  .b_data(b_data_41_NC),
  .a_data_in(a_data_40_to_41),
  .b_data_in(b_data_31_to_41),
  .c_data(c_data_41),
  .a_data_out(a_data_41_to_42),
  .b_data_out(b_data_41_to_51),
  .a_addr(a_addr_41_NC),
  .b_addr(b_addr_41_NC),
  .c_addr(c_addr_41),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 42
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_42_to_43;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_42_to_52;
  wire [`AWIDTH-1:0] a_addr_42_NC;
  wire [`AWIDTH-1:0] b_addr_42_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_42_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_42_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_42(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_42),
  .a_data(a_data_42_NC),
  .b_data(b_data_42_NC),
  .a_data_in(a_data_41_to_42),
  .b_data_in(b_data_32_to_42),
  .c_data(c_data_42),
  .a_data_out(a_data_42_to_43),
  .b_data_out(b_data_42_to_52),
  .a_addr(a_addr_42_NC),
  .b_addr(b_addr_42_NC),
  .c_addr(c_addr_42),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 43
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_43_to_44;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_43_to_53;
  wire [`AWIDTH-1:0] a_addr_43_NC;
  wire [`AWIDTH-1:0] b_addr_43_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_43_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_43_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_43(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_43),
  .a_data(a_data_43_NC),
  .b_data(b_data_43_NC),
  .a_data_in(a_data_42_to_43),
  .b_data_in(b_data_33_to_43),
  .c_data(c_data_43),
  .a_data_out(a_data_43_to_44),
  .b_data_out(b_data_43_to_53),
  .a_addr(a_addr_43_NC),
  .b_addr(b_addr_43_NC),
  .c_addr(c_addr_43),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 44
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_44_to_45;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_44_to_54;
  wire [`AWIDTH-1:0] a_addr_44_NC;
  wire [`AWIDTH-1:0] b_addr_44_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_44_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_44_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_44(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_44),
  .a_data(a_data_44_NC),
  .b_data(b_data_44_NC),
  .a_data_in(a_data_43_to_44),
  .b_data_in(b_data_34_to_44),
  .c_data(c_data_44),
  .a_data_out(a_data_44_to_45),
  .b_data_out(b_data_44_to_54),
  .a_addr(a_addr_44_NC),
  .b_addr(b_addr_44_NC),
  .c_addr(c_addr_44),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 45
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_45_to_46;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_45_to_55;
  wire [`AWIDTH-1:0] a_addr_45_NC;
  wire [`AWIDTH-1:0] b_addr_45_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_45_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_45_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_45(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_45),
  .a_data(a_data_45_NC),
  .b_data(b_data_45_NC),
  .a_data_in(a_data_44_to_45),
  .b_data_in(b_data_35_to_45),
  .c_data(c_data_45),
  .a_data_out(a_data_45_to_46),
  .b_data_out(b_data_45_to_55),
  .a_addr(a_addr_45_NC),
  .b_addr(b_addr_45_NC),
  .c_addr(c_addr_45),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 46
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_46_to_47;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_46_to_56;
  wire [`AWIDTH-1:0] a_addr_46_NC;
  wire [`AWIDTH-1:0] b_addr_46_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_46_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_46_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_46(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_46),
  .a_data(a_data_46_NC),
  .b_data(b_data_46_NC),
  .a_data_in(a_data_45_to_46),
  .b_data_in(b_data_36_to_46),
  .c_data(c_data_46),
  .a_data_out(a_data_46_to_47),
  .b_data_out(b_data_46_to_56),
  .a_addr(a_addr_46_NC),
  .b_addr(b_addr_46_NC),
  .c_addr(c_addr_46),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 47
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_47_to_48;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_47_to_57;
  wire [`AWIDTH-1:0] a_addr_47_NC;
  wire [`AWIDTH-1:0] b_addr_47_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_47_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_47_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_47(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_47),
  .a_data(a_data_47_NC),
  .b_data(b_data_47_NC),
  .a_data_in(a_data_46_to_47),
  .b_data_in(b_data_37_to_47),
  .c_data(c_data_47),
  .a_data_out(a_data_47_to_48),
  .b_data_out(b_data_47_to_57),
  .a_addr(a_addr_47_NC),
  .b_addr(b_addr_47_NC),
  .c_addr(c_addr_47),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd4),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 50
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_50_to_51;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_50_to_60;
  wire [`AWIDTH-1:0] b_addr_50_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_50_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_50_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_50(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_50),
  .a_data(a_data_50),
  .b_data(b_data_50_NC),
  .a_data_in(a_data_in_50_NC),
  .b_data_in(b_data_40_to_50),
  .c_data(c_data_50),
  .a_data_out(a_data_50_to_51),
  .b_data_out(b_data_50_to_60),
  .a_addr(a_addr_50),
  .b_addr(b_addr_50_NC),
  .c_addr(c_addr_50),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 51
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_51_to_52;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_51_to_61;
  wire [`AWIDTH-1:0] a_addr_51_NC;
  wire [`AWIDTH-1:0] b_addr_51_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_51_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_51_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_51(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_51),
  .a_data(a_data_51_NC),
  .b_data(b_data_51_NC),
  .a_data_in(a_data_50_to_51),
  .b_data_in(b_data_41_to_51),
  .c_data(c_data_51),
  .a_data_out(a_data_51_to_52),
  .b_data_out(b_data_51_to_61),
  .a_addr(a_addr_51_NC),
  .b_addr(b_addr_51_NC),
  .c_addr(c_addr_51),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 52
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_52_to_53;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_52_to_62;
  wire [`AWIDTH-1:0] a_addr_52_NC;
  wire [`AWIDTH-1:0] b_addr_52_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_52_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_52_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_52(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_52),
  .a_data(a_data_52_NC),
  .b_data(b_data_52_NC),
  .a_data_in(a_data_51_to_52),
  .b_data_in(b_data_42_to_52),
  .c_data(c_data_52),
  .a_data_out(a_data_52_to_53),
  .b_data_out(b_data_52_to_62),
  .a_addr(a_addr_52_NC),
  .b_addr(b_addr_52_NC),
  .c_addr(c_addr_52),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 53
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_53_to_54;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_53_to_63;
  wire [`AWIDTH-1:0] a_addr_53_NC;
  wire [`AWIDTH-1:0] b_addr_53_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_53_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_53_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_53(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_53),
  .a_data(a_data_53_NC),
  .b_data(b_data_53_NC),
  .a_data_in(a_data_52_to_53),
  .b_data_in(b_data_43_to_53),
  .c_data(c_data_53),
  .a_data_out(a_data_53_to_54),
  .b_data_out(b_data_53_to_63),
  .a_addr(a_addr_53_NC),
  .b_addr(b_addr_53_NC),
  .c_addr(c_addr_53),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 54
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_54_to_55;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_54_to_64;
  wire [`AWIDTH-1:0] a_addr_54_NC;
  wire [`AWIDTH-1:0] b_addr_54_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_54_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_54_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_54(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_54),
  .a_data(a_data_54_NC),
  .b_data(b_data_54_NC),
  .a_data_in(a_data_53_to_54),
  .b_data_in(b_data_44_to_54),
  .c_data(c_data_54),
  .a_data_out(a_data_54_to_55),
  .b_data_out(b_data_54_to_64),
  .a_addr(a_addr_54_NC),
  .b_addr(b_addr_54_NC),
  .c_addr(c_addr_54),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 55
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_55_to_56;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_55_to_65;
  wire [`AWIDTH-1:0] a_addr_55_NC;
  wire [`AWIDTH-1:0] b_addr_55_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_55_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_55_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_55(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_55),
  .a_data(a_data_55_NC),
  .b_data(b_data_55_NC),
  .a_data_in(a_data_54_to_55),
  .b_data_in(b_data_45_to_55),
  .c_data(c_data_55),
  .a_data_out(a_data_55_to_56),
  .b_data_out(b_data_55_to_65),
  .a_addr(a_addr_55_NC),
  .b_addr(b_addr_55_NC),
  .c_addr(c_addr_55),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 56
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_56_to_57;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_56_to_66;
  wire [`AWIDTH-1:0] a_addr_56_NC;
  wire [`AWIDTH-1:0] b_addr_56_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_56_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_56_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_56(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_56),
  .a_data(a_data_56_NC),
  .b_data(b_data_56_NC),
  .a_data_in(a_data_55_to_56),
  .b_data_in(b_data_46_to_56),
  .c_data(c_data_56),
  .a_data_out(a_data_56_to_57),
  .b_data_out(b_data_56_to_66),
  .a_addr(a_addr_56_NC),
  .b_addr(b_addr_56_NC),
  .c_addr(c_addr_56),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 57
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_57_to_58;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_57_to_67;
  wire [`AWIDTH-1:0] a_addr_57_NC;
  wire [`AWIDTH-1:0] b_addr_57_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_57_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_57_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_57(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_57),
  .a_data(a_data_57_NC),
  .b_data(b_data_57_NC),
  .a_data_in(a_data_56_to_57),
  .b_data_in(b_data_47_to_57),
  .c_data(c_data_57),
  .a_data_out(a_data_57_to_58),
  .b_data_out(b_data_57_to_67),
  .a_addr(a_addr_57_NC),
  .b_addr(b_addr_57_NC),
  .c_addr(c_addr_57),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd5),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 60
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_60_to_61;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_60_to_70;
  wire [`AWIDTH-1:0] b_addr_60_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_60_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_60_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_60(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_60),
  .a_data(a_data_60),
  .b_data(b_data_60_NC),
  .a_data_in(a_data_in_60_NC),
  .b_data_in(b_data_50_to_60),
  .c_data(c_data_60),
  .a_data_out(a_data_60_to_61),
  .b_data_out(b_data_60_to_70),
  .a_addr(a_addr_60),
  .b_addr(b_addr_60_NC),
  .c_addr(c_addr_60),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 61
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_61_to_62;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_61_to_71;
  wire [`AWIDTH-1:0] a_addr_61_NC;
  wire [`AWIDTH-1:0] b_addr_61_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_61_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_61_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_61(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_61),
  .a_data(a_data_61_NC),
  .b_data(b_data_61_NC),
  .a_data_in(a_data_60_to_61),
  .b_data_in(b_data_51_to_61),
  .c_data(c_data_61),
  .a_data_out(a_data_61_to_62),
  .b_data_out(b_data_61_to_71),
  .a_addr(a_addr_61_NC),
  .b_addr(b_addr_61_NC),
  .c_addr(c_addr_61),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 62
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_62_to_63;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_62_to_72;
  wire [`AWIDTH-1:0] a_addr_62_NC;
  wire [`AWIDTH-1:0] b_addr_62_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_62_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_62_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_62(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_62),
  .a_data(a_data_62_NC),
  .b_data(b_data_62_NC),
  .a_data_in(a_data_61_to_62),
  .b_data_in(b_data_52_to_62),
  .c_data(c_data_62),
  .a_data_out(a_data_62_to_63),
  .b_data_out(b_data_62_to_72),
  .a_addr(a_addr_62_NC),
  .b_addr(b_addr_62_NC),
  .c_addr(c_addr_62),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 63
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_63_to_64;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_63_to_73;
  wire [`AWIDTH-1:0] a_addr_63_NC;
  wire [`AWIDTH-1:0] b_addr_63_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_63_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_63_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_63(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_63),
  .a_data(a_data_63_NC),
  .b_data(b_data_63_NC),
  .a_data_in(a_data_62_to_63),
  .b_data_in(b_data_53_to_63),
  .c_data(c_data_63),
  .a_data_out(a_data_63_to_64),
  .b_data_out(b_data_63_to_73),
  .a_addr(a_addr_63_NC),
  .b_addr(b_addr_63_NC),
  .c_addr(c_addr_63),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 64
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_64_to_65;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_64_to_74;
  wire [`AWIDTH-1:0] a_addr_64_NC;
  wire [`AWIDTH-1:0] b_addr_64_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_64_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_64_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_64(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_64),
  .a_data(a_data_64_NC),
  .b_data(b_data_64_NC),
  .a_data_in(a_data_63_to_64),
  .b_data_in(b_data_54_to_64),
  .c_data(c_data_64),
  .a_data_out(a_data_64_to_65),
  .b_data_out(b_data_64_to_74),
  .a_addr(a_addr_64_NC),
  .b_addr(b_addr_64_NC),
  .c_addr(c_addr_64),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 65
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_65_to_66;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_65_to_75;
  wire [`AWIDTH-1:0] a_addr_65_NC;
  wire [`AWIDTH-1:0] b_addr_65_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_65_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_65_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_65(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_65),
  .a_data(a_data_65_NC),
  .b_data(b_data_65_NC),
  .a_data_in(a_data_64_to_65),
  .b_data_in(b_data_55_to_65),
  .c_data(c_data_65),
  .a_data_out(a_data_65_to_66),
  .b_data_out(b_data_65_to_75),
  .a_addr(a_addr_65_NC),
  .b_addr(b_addr_65_NC),
  .c_addr(c_addr_65),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 66
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_66_to_67;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_66_to_76;
  wire [`AWIDTH-1:0] a_addr_66_NC;
  wire [`AWIDTH-1:0] b_addr_66_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_66_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_66_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_66(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_66),
  .a_data(a_data_66_NC),
  .b_data(b_data_66_NC),
  .a_data_in(a_data_65_to_66),
  .b_data_in(b_data_56_to_66),
  .c_data(c_data_66),
  .a_data_out(a_data_66_to_67),
  .b_data_out(b_data_66_to_76),
  .a_addr(a_addr_66_NC),
  .b_addr(b_addr_66_NC),
  .c_addr(c_addr_66),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 67
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_67_to_68;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_67_to_77;
  wire [`AWIDTH-1:0] a_addr_67_NC;
  wire [`AWIDTH-1:0] b_addr_67_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_67_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_67_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_67(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_67),
  .a_data(a_data_67_NC),
  .b_data(b_data_67_NC),
  .a_data_in(a_data_66_to_67),
  .b_data_in(b_data_57_to_67),
  .c_data(c_data_67),
  .a_data_out(a_data_67_to_68),
  .b_data_out(b_data_67_to_77),
  .a_addr(a_addr_67_NC),
  .b_addr(b_addr_67_NC),
  .c_addr(c_addr_67),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd6),
  .b_loc(8'd7)
);

  /////////////////////////////////////////////////
  // Matmul 70
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_70_to_71;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_70_to_80;
  wire [`AWIDTH-1:0] b_addr_70_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_70_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_70_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_70(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_70),
  .a_data(a_data_70),
  .b_data(b_data_70_NC),
  .a_data_in(a_data_in_70_NC),
  .b_data_in(b_data_60_to_70),
  .c_data(c_data_70),
  .a_data_out(a_data_70_to_71),
  .b_data_out(b_data_70_to_80),
  .a_addr(a_addr_70),
  .b_addr(b_addr_70_NC),
  .c_addr(c_addr_70),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd0)
);

  /////////////////////////////////////////////////
  // Matmul 71
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_71_to_72;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_71_to_81;
  wire [`AWIDTH-1:0] a_addr_71_NC;
  wire [`AWIDTH-1:0] b_addr_71_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_71_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_71_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_71(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_71),
  .a_data(a_data_71_NC),
  .b_data(b_data_71_NC),
  .a_data_in(a_data_70_to_71),
  .b_data_in(b_data_61_to_71),
  .c_data(c_data_71),
  .a_data_out(a_data_71_to_72),
  .b_data_out(b_data_71_to_81),
  .a_addr(a_addr_71_NC),
  .b_addr(b_addr_71_NC),
  .c_addr(c_addr_71),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////
  // Matmul 72
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_72_to_73;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_72_to_82;
  wire [`AWIDTH-1:0] a_addr_72_NC;
  wire [`AWIDTH-1:0] b_addr_72_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_72_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_72_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_72(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_72),
  .a_data(a_data_72_NC),
  .b_data(b_data_72_NC),
  .a_data_in(a_data_71_to_72),
  .b_data_in(b_data_62_to_72),
  .c_data(c_data_72),
  .a_data_out(a_data_72_to_73),
  .b_data_out(b_data_72_to_82),
  .a_addr(a_addr_72_NC),
  .b_addr(b_addr_72_NC),
  .c_addr(c_addr_72),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd2)
);

  /////////////////////////////////////////////////
  // Matmul 73
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_73_to_74;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_73_to_83;
  wire [`AWIDTH-1:0] a_addr_73_NC;
  wire [`AWIDTH-1:0] b_addr_73_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_73_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_73_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_73(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_73),
  .a_data(a_data_73_NC),
  .b_data(b_data_73_NC),
  .a_data_in(a_data_72_to_73),
  .b_data_in(b_data_63_to_73),
  .c_data(c_data_73),
  .a_data_out(a_data_73_to_74),
  .b_data_out(b_data_73_to_83),
  .a_addr(a_addr_73_NC),
  .b_addr(b_addr_73_NC),
  .c_addr(c_addr_73),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////
  // Matmul 74
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_74_to_75;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_74_to_84;
  wire [`AWIDTH-1:0] a_addr_74_NC;
  wire [`AWIDTH-1:0] b_addr_74_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_74_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_74_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_74(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_74),
  .a_data(a_data_74_NC),
  .b_data(b_data_74_NC),
  .a_data_in(a_data_73_to_74),
  .b_data_in(b_data_64_to_74),
  .c_data(c_data_74),
  .a_data_out(a_data_74_to_75),
  .b_data_out(b_data_74_to_84),
  .a_addr(a_addr_74_NC),
  .b_addr(b_addr_74_NC),
  .c_addr(c_addr_74),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd4)
);

  /////////////////////////////////////////////////
  // Matmul 75
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_75_to_76;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_75_to_85;
  wire [`AWIDTH-1:0] a_addr_75_NC;
  wire [`AWIDTH-1:0] b_addr_75_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_75_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_75_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_75(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_75),
  .a_data(a_data_75_NC),
  .b_data(b_data_75_NC),
  .a_data_in(a_data_74_to_75),
  .b_data_in(b_data_65_to_75),
  .c_data(c_data_75),
  .a_data_out(a_data_75_to_76),
  .b_data_out(b_data_75_to_85),
  .a_addr(a_addr_75_NC),
  .b_addr(b_addr_75_NC),
  .c_addr(c_addr_75),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd5)
);

  /////////////////////////////////////////////////
  // Matmul 76
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_76_to_77;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_76_to_86;
  wire [`AWIDTH-1:0] a_addr_76_NC;
  wire [`AWIDTH-1:0] b_addr_76_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_76_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_76_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_76(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_76),
  .a_data(a_data_76_NC),
  .b_data(b_data_76_NC),
  .a_data_in(a_data_75_to_76),
  .b_data_in(b_data_66_to_76),
  .c_data(c_data_76),
  .a_data_out(a_data_76_to_77),
  .b_data_out(b_data_76_to_86),
  .a_addr(a_addr_76_NC),
  .b_addr(b_addr_76_NC),
  .c_addr(c_addr_76),
  .final_mat_mul_size(8'd32),
  .a_loc(8'd7),
  .b_loc(8'd6)
);

  /////////////////////////////////////////////////
  // Matmul 77
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_77_to_78;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_77_to_87;
  wire [`AWIDTH-1:0] a_addr_77_NC;
  wire [`AWIDTH-1:0] b_addr_77_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_77_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_77_NC;

matmul_4x4_systolic u_matmul_4x4_systolic_77(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_77),
  .a_data(a_data_77_NC),
  .b_data(b_data_77_NC),
  .a_data_in(a_data_76_to_77),
  .b_data_in(b_data_67_to_77),
  .c_data(c_data_77),
  .a_data_out(a_data_77_to_78),
  .b_data_out(b_data_77_to_87),
  .a_addr(a_addr_77_NC),
  .b_addr(b_addr_77_NC),
  .c_addr(c_addr_77),
  .final_mat_mul_size(8'd32),
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