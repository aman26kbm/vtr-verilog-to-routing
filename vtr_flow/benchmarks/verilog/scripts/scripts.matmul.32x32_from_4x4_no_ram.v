`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define BB_MAT_MUL_SIZE 4


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

