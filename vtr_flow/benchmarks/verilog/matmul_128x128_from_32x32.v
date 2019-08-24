`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 14
`define MEM_SIZE 16384
`define MAT_MUL_SIZE 32


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
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input we_a;
  input we_b;
  input we_c;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  input start_mat_mul;
  output done_mat_mul;

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

  assign done_mat_mul = done_mat_mul_00 && 
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

  /////////////////////////////////////////////////////////////////
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  wire [`AWIDTH-1:0] a_addr_00;
  wire [`AWIDTH-1:0] a_addr_muxed_00;

  assign a_addr_muxed_00 = (enable_writing_to_mem) ? addr_pi : a_addr_00;

  // BRAM matrix A 00
  ram matrix_A_00 (
    .addr0(a_addr_muxed_00),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_00), 
    .clk(clk));

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10;
  wire [`AWIDTH-1:0] a_addr_10;
  wire [`AWIDTH-1:0] a_addr_muxed_10;

  assign a_addr_muxed_10 = (enable_writing_to_mem) ? addr_pi : a_addr_10;

  // BRAM matrix A 10
  ram matrix_A_10 (
    .addr0(a_addr_muxed_10),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_10), 
    .clk(clk));  

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20;
  wire [`AWIDTH-1:0] a_addr_20;
  wire [`AWIDTH-1:0] a_addr_muxed_20;

  assign a_addr_muxed_20 = (enable_writing_to_mem) ? addr_pi : a_addr_20;

  // BRAM matrix A 20
  ram matrix_A_20 (
    .addr0(a_addr_muxed_20),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_20), 
    .clk(clk));

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_30;
  wire [`AWIDTH-1:0] a_addr_30;
  wire [`AWIDTH-1:0] a_addr_muxed_30;

  assign a_addr_muxed_30 = (enable_writing_to_mem) ? addr_pi : a_addr_30;

  // BRAM matrix A 30
  ram matrix_A_30 (
    .addr0(a_addr_muxed_30),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_30), 
    .clk(clk));  


  /////////////////////////////////////////////////////////////////

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  wire [`AWIDTH-1:0] b_addr_00;
  wire [`AWIDTH-1:0] b_addr_muxed_00;

  assign b_addr_muxed_00 = (enable_writing_to_mem) ? addr_pi : b_addr_00;

  // BRAM matrix B 00
  ram matrix_B_00 (
    .addr0(b_addr_muxed_00),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_00), 
    .clk(clk));

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01;
  wire [`AWIDTH-1:0] b_addr_01;
  wire [`AWIDTH-1:0] b_addr_muxed_01;

  assign b_addr_muxed_01 = (enable_writing_to_mem) ? addr_pi : b_addr_01;

  // BRAM matrix B 01
  ram matrix_B_01 (
    .addr0(b_addr_muxed_01),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_01), 
    .clk(clk));

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02;
  wire [`AWIDTH-1:0] b_addr_02;
  wire [`AWIDTH-1:0] b_addr_muxed_02;

  assign b_addr_muxed_02 = (enable_writing_to_mem) ? addr_pi : b_addr_02;

  // BRAM matrix B 02
  ram matrix_B_02 (
    .addr0(b_addr_muxed_02),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_02), 
    .clk(clk));

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_03;
  wire [`AWIDTH-1:0] b_addr_03;
  wire [`AWIDTH-1:0] b_addr_muxed_03;

  assign b_addr_muxed_03 = (enable_writing_to_mem) ? addr_pi : b_addr_03;

  // BRAM matrix B 03
  ram matrix_B_03 (
    .addr0(b_addr_muxed_03),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_03), 
    .clk(clk));



  /////////////////////////////////////////////////////////////////


  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad2;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad3;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad4;
  assign data_from_out_mat = data_from_out_mat_quad1 | data_from_out_mat_quad2 | data_from_out_mat_quad3 | data_from_out_mat_quad4 ;

  wire [`AWIDTH-1:0] c_addr_00;
  wire [`AWIDTH-1:0] c_addr_01;
  wire [`AWIDTH-1:0] c_addr_10;
  wire [`AWIDTH-1:0] c_addr_11;
  wire [`AWIDTH-1:0] c_addr_muxed_quad1;
  assign c_addr_muxed_quad1 = (enable_reading_from_mem) ? addr_pi :  (c_addr_00|c_addr_01|c_addr_10|c_addr_11);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad1;
  assign c_data_quad1 = c_data_00 | c_data_01 | c_data_10 | c_data_11;

  // BRAM matrix C_quad1
  ram matrix_C_quad1 (
    .addr0(c_addr_muxed_quad1),
    .d0(c_data_quad1),
    .we0(we_c),
    .q0(data_from_out_mat_quad1),
    .clk(clk));


  wire [`AWIDTH-1:0] c_addr_02;
  wire [`AWIDTH-1:0] c_addr_03;
  wire [`AWIDTH-1:0] c_addr_12;
  wire [`AWIDTH-1:0] c_addr_13;
  wire [`AWIDTH-1:0] c_addr_muxed_quad2;
  assign c_addr_muxed_quad2 = (enable_reading_from_mem) ? addr_pi :  (c_addr_02|c_addr_03|c_addr_12|c_addr_13);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_03;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_13;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad2;
  assign c_data_quad2 = c_data_02 | c_data_03 | c_data_12 | c_data_13;

  // BRAM matrix C_quad2
  ram matrix_C_quad2 (
    .addr0(c_addr_muxed_quad2),
    .d0(c_data_quad2),
    .we0(we_c),
    .q0(data_from_out_mat_quad2),
    .clk(clk));



  wire [`AWIDTH-1:0] c_addr_20;
  wire [`AWIDTH-1:0] c_addr_21;
  wire [`AWIDTH-1:0] c_addr_30;
  wire [`AWIDTH-1:0] c_addr_31;
  wire [`AWIDTH-1:0] c_addr_muxed_quad3;
  assign c_addr_muxed_quad3 = (enable_reading_from_mem) ? addr_pi :  (c_addr_20|c_addr_21|c_addr_30|c_addr_31);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_30;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_31;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad3;
  assign c_data_quad3 = c_data_20 | c_data_21 | c_data_30 | c_data_31;

  // BRAM matrix C_quad3
  ram matrix_C_quad3 (
    .addr0(c_addr_muxed_quad3),
    .d0(c_data_quad3),
    .we0(we_c),
    .q0(data_from_out_mat_quad3),
    .clk(clk));



  wire [`AWIDTH-1:0] c_addr_22;
  wire [`AWIDTH-1:0] c_addr_23;
  wire [`AWIDTH-1:0] c_addr_32;
  wire [`AWIDTH-1:0] c_addr_33;
  wire [`AWIDTH-1:0] c_addr_muxed_quad4;
  assign c_addr_muxed_quad4 = (enable_reading_from_mem) ? addr_pi :  (c_addr_22|c_addr_23|c_addr_32|c_addr_33);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_23;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_32;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_33;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad4;
  assign c_data_quad4 = c_data_22 | c_data_23 | c_data_32 | c_data_33;

  // BRAM matrix C_quad4
  ram matrix_C_quad4 (
    .addr0(c_addr_muxed_quad4),
    .d0(c_data_quad4),
    .we0(we_c),
    .q0(data_from_out_mat_quad4),
    .clk(clk));


  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00_to_01;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00_to_10;


matmul_32x32_systolic u_matmul_32x32_00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_00),
  .a_data(a_data_00),
  .b_data(b_data_00),
  .c_data(c_data_00),
  .a_data_out(a_data_00_to_01),
  .b_data_out(b_data_00_to_10),
  .a_addr(a_addr_00),
  .b_addr(b_addr_00),
  .c_addr(c_addr_00),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_01_to_02;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01_to_11;
 wire [`AWIDTH-1:0] a_addr_01_NC;

matmul_32x32_systolic u_matmul_32x32_01(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_01),
  .a_data(a_data_00_to_01),
  .b_data(b_data_01),
  .c_data(c_data_01),
  .a_data_out(a_data_01_to_02),
  .b_data_out(b_data_01_to_11),
  .a_addr(a_addr_01_NC),
  .b_addr(b_addr_01),
  .c_addr(c_addr_01),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd0),
  .b_loc(8'd1)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_to_11;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_to_20;
 wire [`AWIDTH-1:0] b_addr_10_NC;

matmul_32x32_systolic u_matmul_32x32_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10),
  .a_data(a_data_10),
  .b_data(b_data_00_to_10),
  .c_data(c_data_10),
  .a_data_out(a_data_10_to_11),
  .b_data_out(b_data_10_to_20),
  .a_addr(a_addr_10),
  .b_addr(b_addr_10_NC),
  .c_addr(c_addr_10),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd1),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_to_12;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_to_21;
 wire [`AWIDTH-1:0] a_addr_11_NC;
 wire [`AWIDTH-1:0] b_addr_11_NC;

matmul_32x32_systolic u_matmul_32x32_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11),
  .a_data(a_data_10_to_11),
  .b_data(b_data_01_to_11),
  .c_data(c_data_11),
  .a_data_out(a_data_11_to_12),
  .b_data_out(b_data_11_to_21),
  .a_addr(a_addr_11_NC),
  .b_addr(b_addr_11_NC),
  .c_addr(c_addr_11),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd1),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_02_to_03;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02_to_12;
 wire [`AWIDTH-1:0] a_addr_02_NC;


matmul_32x32_systolic u_matmul_32x32_02(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_02),
  .a_data(a_data_01_to_02),
  .b_data(b_data_02),
  .c_data(c_data_02),
  .a_data_out(a_data_02_to_03),
  .b_data_out(b_data_02_to_12),
  .a_addr(a_addr_02_NC),
  .b_addr(b_addr_02),
  .c_addr(c_addr_02),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd0),
  .b_loc(8'd2)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_03_to_04_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_03_to_13;
 wire [`AWIDTH-1:0] a_addr_03_NC;

matmul_32x32_systolic u_matmul_32x32_03(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_03),
  .a_data(a_data_02_to_03),
  .b_data(b_data_03),
  .c_data(c_data_03),
  .a_data_out(a_data_03_to_04_NC),
  .b_data_out(b_data_03_to_13),
  .a_addr(a_addr_03_NC),
  .b_addr(b_addr_03),
  .c_addr(c_addr_03),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd0),
  .b_loc(8'd3)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_to_13;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_to_22;
 wire [`AWIDTH-1:0] b_addr_12_NC;
 wire [`AWIDTH-1:0] a_addr_12_NC;

matmul_32x32_systolic u_matmul_32x32_12(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_12),
  .a_data(a_data_11_to_12),
  .b_data(b_data_02_to_12),
  .c_data(c_data_12),
  .a_data_out(a_data_12_to_13),
  .b_data_out(b_data_12_to_22),
  .a_addr(a_addr_12_NC),
  .b_addr(b_addr_12_NC),
  .c_addr(c_addr_12),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd1),
  .b_loc(8'd2)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_13_to_14_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_13_to_23;
 wire [`AWIDTH-1:0] a_addr_13_NC;
 wire [`AWIDTH-1:0] b_addr_13_NC;

matmul_32x32_systolic u_matmul_32x32_13(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_13),
  .a_data(a_data_12_to_13),
  .b_data(b_data_03_to_13),
  .c_data(c_data_13),
  .a_data_out(a_data_13_to_14_NC),
  .b_data_out(b_data_13_to_23),
  .a_addr(a_addr_13_NC),
  .b_addr(b_addr_13_NC),
  .c_addr(c_addr_13),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd1),
  .b_loc(8'd3)
);

  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20_to_21;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_20_to_30;
 wire [`AWIDTH-1:0] b_addr_20_NC;


matmul_32x32_systolic u_matmul_32x32_20(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_20),
  .a_data(a_data_20),
  .b_data(b_data_10_to_20),
  .c_data(c_data_20),
  .a_data_out(a_data_20_to_21),
  .b_data_out(b_data_20_to_30),
  .a_addr(a_addr_20),
  .b_addr(b_addr_20_NC),
  .c_addr(c_addr_20),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd2),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_21_to_22;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_21_to_31;
 wire [`AWIDTH-1:0] a_addr_21_NC;
 wire [`AWIDTH-1:0] b_addr_21_NC;

matmul_32x32_systolic u_matmul_32x32_21(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_21),
  .a_data(a_data_20_to_21),
  .b_data(b_data_11_to_21),
  .c_data(c_data_21),
  .a_data_out(a_data_21_to_22),
  .b_data_out(b_data_21_to_31),
  .a_addr(a_addr_21_NC),
  .b_addr(b_addr_21_NC),
  .c_addr(c_addr_21),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd2),
  .b_loc(8'd1)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_30_to_31;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_30_to_40_NC;
 wire [`AWIDTH-1:0] b_addr_30_NC;

matmul_32x32_systolic u_matmul_32x32_30(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_30),
  .a_data(a_data_30),
  .b_data(b_data_20_to_30),
  .c_data(c_data_30),
  .a_data_out(a_data_30_to_31),
  .b_data_out(b_data_30_to_40_NC),
  .a_addr(a_addr_30),
  .b_addr(b_addr_30_NC),
  .c_addr(c_addr_30),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd3),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_31_to_32;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_31_to_41_NC;
 wire [`AWIDTH-1:0] a_addr_31_NC;
 wire [`AWIDTH-1:0] b_addr_31_NC;

matmul_32x32_systolic u_matmul_32x32_31(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_31),
  .a_data(a_data_30_to_31),
  .b_data(b_data_21_to_31),
  .c_data(c_data_31),
  .a_data_out(a_data_31_to_32),
  .b_data_out(b_data_31_to_41_NC),
  .a_addr(a_addr_31_NC),
  .b_addr(b_addr_31_NC),
  .c_addr(c_addr_31),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd3),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_22_to_23;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_22_to_32;
 wire [`AWIDTH-1:0] a_addr_22_NC;
 wire [`AWIDTH-1:0] b_addr_22_NC;


matmul_32x32_systolic u_matmul_32x32_22(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_22),
  .a_data(a_data_21_to_22),
  .b_data(b_data_12_to_22),
  .c_data(c_data_22),
  .a_data_out(a_data_22_to_23),
  .b_data_out(b_data_22_to_32),
  .a_addr(a_addr_22_NC),
  .b_addr(b_addr_22_NC),
  .c_addr(c_addr_22),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd2),
  .b_loc(8'd2)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_23_to_24_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_23_to_33;
 wire [`AWIDTH-1:0] a_addr_23_NC;
 wire [`AWIDTH-1:0] b_addr_23_NC;

matmul_32x32_systolic u_matmul_32x32_23(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_23),
  .a_data(a_data_22_to_23),
  .b_data(b_data_13_to_23),
  .c_data(c_data_23),
  .a_data_out(a_data_23_to_24_NC),
  .b_data_out(b_data_23_to_33),
  .a_addr(a_addr_23_NC),
  .b_addr(b_addr_23_NC),
  .c_addr(c_addr_23),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd2),
  .b_loc(8'd3)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_32_to_33;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_32_to_42_NC;
 wire [`AWIDTH-1:0] b_addr_32_NC;
 wire [`AWIDTH-1:0] a_addr_32_NC;

matmul_32x32_systolic u_matmul_32x32_32(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_32),
  .a_data(a_data_31_to_32),
  .b_data(b_data_22_to_32),
  .c_data(c_data_32),
  .a_data_out(a_data_32_to_33),
  .b_data_out(b_data_32_to_42_NC),
  .a_addr(a_addr_32_NC),
  .b_addr(b_addr_32_NC),
  .c_addr(c_addr_32),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd3),
  .b_loc(8'd2)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_33_to_34_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_33_to_43_NC;
 wire [`AWIDTH-1:0] a_addr_33_NC;
 wire [`AWIDTH-1:0] b_addr_33_NC;

matmul_32x32_systolic u_matmul_32x32_33(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_33),
  .a_data(a_data_32_to_33),
  .b_data(b_data_23_to_33),
  .c_data(c_data_33),
  .a_data_out(a_data_33_to_34_NC),
  .b_data_out(b_data_33_to_43_NC),
  .a_addr(a_addr_33_NC),
  .b_addr(b_addr_33_NC),
  .c_addr(c_addr_33),
  .final_mat_mul_size(8'd128),
  .a_loc(8'd3),
  .b_loc(8'd3)
);


endmodule  


/*
module matmul_32x32_systolic(
 clk,
 reset,
 start_mat_mul,
 done_mat_mul,
 a_data,
 b_data,
 c_data,
 a_data_out,
 b_data_out,
 a_addr,
 b_addr,
 c_addr,
 final_mat_mul_size,
 a_loc,
 b_loc
);

 input clk;
 input reset;
 input start_mat_mul;
 output done_mat_mul;
 input  [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data;
 input  [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data;
 output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data;
 output [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_out;
 output [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_out;
 output [`AWIDTH-1:0] a_addr;
 output [`AWIDTH-1:0] b_addr;
 output [`AWIDTH-1:0] c_addr;
 input [7:0] final_mat_mul_size;
 input [7:0] a_loc;
 input [7:0] b_loc;
endmodule
*/

module ram (addr0, d0, we0, q0,  clk);

input [`AWIDTH-1:0] addr0;
input [`MAT_MUL_SIZE*`DWIDTH-1:0] d0;
input we0;
output [`MAT_MUL_SIZE*`DWIDTH-1:0] q0;
input clk;

reg [`MAT_MUL_SIZE*`DWIDTH-1:0] q0;
reg [`MAT_MUL_SIZE*`DWIDTH-1:0] ram[`MEM_SIZE-1:0];

always @(posedge clk)  
begin 
        if (we0) 
        begin 
            ram[addr0] <= d0; 
        end 
        q0 <= ram[addr0];
end
endmodule
