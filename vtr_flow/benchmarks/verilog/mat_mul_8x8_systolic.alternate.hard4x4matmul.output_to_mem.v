
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define MAT_MUL_SIZE 4

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
  input [4*`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input we_a;
  input we_b;
  input we_c;
  output [4*`DWIDTH-1:0] data_from_out_mat;
  input start_mat_mul;
  output done_mat_mul;

  wire done_mat_mul_00;
  wire done_mat_mul_01;
  wire done_mat_mul_10;
  wire done_mat_mul_11;

  assign done_mat_mul = done_mat_mul_00 && done_mat_mul_01 && done_mat_mul_10 && done_mat_mul_11;

  wire [4*`DWIDTH-1:0] a_data_C00;
  wire [4*`DWIDTH-1:0] a_data_C10;
  wire [`AWIDTH-1:0] a_addr_00_muxed;
  wire [`AWIDTH-1:0] a_addr_10_muxed;
  wire [`AWIDTH-1:0] a_addr_00;
  wire [`AWIDTH-1:0] a_addr_10;

  assign a_addr_00_muxed = (enable_writing_to_mem) ? addr_pi : a_addr_00;
  assign a_addr_10_muxed = (enable_writing_to_mem) ? addr_pi : a_addr_10;

  // BRAM matrix A 00
  // Will contain elements accessed/needed by C00 systolic matmul
  // a00-a07
  // a10-a17
  // a20-a27
  // a30-a37
  ram matrix_A_00 (
    .addr0(a_addr_00_muxed),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_C00), 
    .clk(clk));

  // BRAM matrix A 10
  // Will contain elements accessed/needed by C10 systolic matmul
  // a40-a47
  // a50-a57
  // a60-a67
  // a70-a77
  ram matrix_A_10 (
    .addr0(a_addr_10_muxed),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_C10), 
    .clk(clk));

  wire [4*`DWIDTH-1:0] b_data_C00;
  wire [4*`DWIDTH-1:0] b_data_C01;
  wire [`AWIDTH-1:0] b_addr_00_muxed;
  wire [`AWIDTH-1:0] b_addr_01_muxed;
  wire [`AWIDTH-1:0] b_addr_00;
  wire [`AWIDTH-1:0] b_addr_01;

  assign b_addr_00_muxed = (enable_writing_to_mem) ? addr_pi : b_addr_00;
  assign b_addr_01_muxed = (enable_writing_to_mem) ? addr_pi : b_addr_01;

  // BRAM matrix B 00
  // Will contain elements accessed/needed by C00 systolic matmul
  // b00-b70
  // b01-b71
  // b02-b72
  // b03-b73
  ram matrix_B_00 (
    .addr0(b_addr_00_muxed),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_C00), 
    .clk(clk));

  // BRAM matrix B 01
  // Will contain elements accessed/needed by C01 systolic matmul
  // b04-b74
  // b05-b75
  // b06-b76
  // b07-b77
  ram matrix_B_01 (
    .addr0(b_addr_01_muxed),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_C01), 
    .clk(clk));

  wire [`AWIDTH-1:0] c_addr_00;
  wire [`AWIDTH-1:0] c_addr_01;
  wire [`AWIDTH-1:0] c_addr_10;
  wire [`AWIDTH-1:0] c_addr_11;
  wire [`AWIDTH-1:0] c_addr_muxed_00;
  wire [`AWIDTH-1:0] c_addr_muxed_01;
  wire [`AWIDTH-1:0] c_addr_muxed_10;
  wire [`AWIDTH-1:0] c_addr_muxed_11;

  assign c_addr_muxed_00 = (enable_reading_from_mem) ? addr_pi : c_addr_00 ;
  assign c_addr_muxed_01 = (enable_reading_from_mem) ? addr_pi : c_addr_01 ;
  assign c_addr_muxed_10 = (enable_reading_from_mem) ? addr_pi : c_addr_10 ;
  assign c_addr_muxed_11 = (enable_reading_from_mem) ? addr_pi : c_addr_11 ;

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  wire [4*`DWIDTH-1:0] data_from_out_mat_00;
  wire [4*`DWIDTH-1:0] data_from_out_mat_01;
  wire [4*`DWIDTH-1:0] data_from_out_mat_10;
  wire [4*`DWIDTH-1:0] data_from_out_mat_11;
 
  assign data_from_out_mat = data_from_out_mat_00 | data_from_out_mat_01 | data_from_out_mat_10 | data_from_out_mat_11;

  // BRAM matrix C00
  ram matrix_C00 (
    .addr0(c_addr_muxed_00),
    .d0(c_data_00),
    .we0(we_c),
    .q0(data_from_out_mat_00),
    .clk(clk));

  // BRAM matrix C01
  ram matrix_C01 (
    .addr0(c_addr_muxed_01),
    .d0(c_data_01),
    .we0(we_c),
    .q0(data_from_out_mat_01),
    .clk(clk));

  // BRAM matrix C10
  ram matrix_C10 (
    .addr0(c_addr_muxed_10),
    .d0(c_data_10),
    .we0(we_c),
    .q0(data_from_out_mat_10),
    .clk(clk));

  // BRAM matrix C11
  ram matrix_C11 (
    .addr0(c_addr_muxed_11),
    .d0(c_data_11),
    .we0(we_c),
    .q0(data_from_out_mat_11),
    .clk(clk));

  wire [4*`DWIDTH-1:0] C00_to_C01_a_data;
  wire [4*`DWIDTH-1:0] C00_to_C10_b_data;
  
  matmul_4x4_systolic u_matmul_4x4_systolic_00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_00),
  .a_data(a_data_C00),
  .b_data(b_data_C00),
  .c_data(c_data_00),
  .a_data_out(C00_to_C01_a_data),
  .b_data_out(C00_to_C10_b_data),
  .a_addr(a_addr_00),
  .b_addr(b_addr_00),
  .c_addr(c_addr_00),
  .final_mat_mul_size(8'd8),
  .a_loc(8'd0),
  .b_loc(8'd0)
  );

  wire [4*`DWIDTH-1:0] C01_to_C02_a_data_NC;
  wire [4*`DWIDTH-1:0] C01_to_C11_b_data;
  wire [`AWIDTH-1:0] a_addr_01_NC;

  matmul_4x4_systolic u_matmul_4x4_systolic_01(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_01),
  .a_data(C00_to_C01_a_data),
  .b_data(b_data_C01),
  .c_data(c_data_01),
  .a_data_out(C01_to_C02_a_data_NC),
  .b_data_out(C01_to_C11_b_data),
  .a_addr(a_addr_01_NC),
  .b_addr(b_addr_01),
  .c_addr(c_addr_01),
  .final_mat_mul_size(8'd8),
  .a_loc(8'd0),
  .b_loc(8'd1)
  );

  wire [4*`DWIDTH-1:0] C10_to_C11_a_data;
  wire [4*`DWIDTH-1:0] C10_to_C20_b_data_NC;
  wire [`AWIDTH-1:0] b_addr_10_NC;

  matmul_4x4_systolic u_matmul_4x4_systolic_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10),
  .a_data(a_data_C10),
  .b_data(C00_to_C10_b_data),
  .c_data(c_data_10),
  .a_data_out(C10_to_C11_a_data),
  .b_data_out(C10_to_C20_b_data_NC),
  .a_addr(a_addr_10),
  .b_addr(b_addr_10_NC),
  .c_addr(c_addr_10),
  .final_mat_mul_size(8'd8),
  .a_loc(8'd1),
  .b_loc(8'd0)
  );

  wire [4*`DWIDTH-1:0] C11_to_C12_a_data_NC;
  wire [4*`DWIDTH-1:0] C11_to_C21_b_data_NC;
  wire [`AWIDTH-1:0] a_addr_11_NC;
  wire [`AWIDTH-1:0] b_addr_11_NC;

   matmul_4x4_systolic u_matmul_4x4_systolic_11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_11),
  .a_data(C10_to_C11_a_data),
  .b_data(C01_to_C11_b_data),
  .c_data(c_data_11),
  .a_data_out(C11_to_C12_a_data_NC),
  .b_data_out(C11_to_C21_b_data_NC),
  .a_addr(a_addr_11_NC),
  .b_addr(b_addr_11_NC),
  .c_addr(c_addr_11),
  .final_mat_mul_size(8'd8),
  .a_loc(8'd1),
  .b_loc(8'd1)
  );


endmodule  


module ram (addr0, d0, we0, q0,  clk);

input [`AWIDTH-1:0] addr0;
input [4*`DWIDTH-1:0] d0;
input we0;
output [4*`DWIDTH-1:0] q0;
input clk;

reg [4*`DWIDTH-1:0] q0;
reg [4*`DWIDTH-1:0] ram[`MEM_SIZE-1:0];

always @(posedge clk)  
begin 
        if (we0) 
        begin 
            ram[addr0] <= d0; 
        end 
        q0 <= ram[addr0];
end
endmodule


