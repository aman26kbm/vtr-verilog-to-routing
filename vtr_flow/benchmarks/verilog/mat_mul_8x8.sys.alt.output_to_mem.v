
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
//`define MEM_SIZE 128
`define MAT_MUL_SIZE 8

module matmul_4x4_systolic(
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
