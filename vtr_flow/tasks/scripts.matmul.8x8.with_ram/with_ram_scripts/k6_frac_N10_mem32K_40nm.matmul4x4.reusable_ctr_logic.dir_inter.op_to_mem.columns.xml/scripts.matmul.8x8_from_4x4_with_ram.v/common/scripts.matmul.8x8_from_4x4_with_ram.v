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

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  wire [`AWIDTH-1:0] c_addr_00;
  wire [`AWIDTH-1:0] c_addr_01;
  wire [`AWIDTH-1:0] c_addr_10;
  wire [`AWIDTH-1:0] c_addr_11;

  wire [`AWIDTH-1:0] c_addr_muxed_00;
  wire [`AWIDTH-1:0] c_addr_muxed_01;
  wire [`AWIDTH-1:0] c_addr_muxed_10;
  wire [`AWIDTH-1:0] c_addr_muxed_11;

  reg [`AWIDTH-1:0] c_addr_00_reg;
  reg [`AWIDTH-1:0] c_addr_01_reg;
  reg [`AWIDTH-1:0] c_addr_10_reg;
  reg [`AWIDTH-1:0] c_addr_11_reg;

  reg [`AWIDTH-1:0] c_addr_muxed_00_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_01_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_10_reg;
  reg [`AWIDTH-1:0] c_addr_muxed_11_reg;

  assign c_addr_muxed_00 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_00_reg;
  assign c_addr_muxed_01 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_01_reg;
  assign c_addr_muxed_10 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_10_reg;
  assign c_addr_muxed_11 = (enable_reading_from_mem) ? addr_pi_reg : c_addr_11_reg;

  always @(posedge clk) begin
    if (reset) begin
      c_addr_00_reg <= 0;
      c_addr_01_reg <= 0;
      c_addr_10_reg <= 0;
      c_addr_11_reg <= 0;
       c_addr_muxed_00_reg <= 0;
       c_addr_muxed_01_reg <= 0;
       c_addr_muxed_10_reg <= 0;
       c_addr_muxed_11_reg <= 0;
    end else begin
      c_addr_00_reg <= c_addr_00;
      c_addr_01_reg <= c_addr_01;
      c_addr_10_reg <= c_addr_10;
      c_addr_11_reg <= c_addr_11;
      c_addr_muxed_00_reg <= c_addr_muxed_00;
      c_addr_muxed_01_reg <= c_addr_muxed_01;
      c_addr_muxed_10_reg <= c_addr_muxed_10;
      c_addr_muxed_11_reg <= c_addr_muxed_11;
    end
  end
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_00;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_01;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_10;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_11;

  assign data_from_out_mat =  data_from_out_mat_00 |
  data_from_out_mat_01 |
  data_from_out_mat_10 |
  data_from_out_mat_11 ;

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

/////////////////////////////////////////////////
// The 8x8 matmul instantiation
/////////////////////////////////////////////////

matmul_8x8_systolic u_matmul_8x8_systolic (
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

  .c_data_00(c_data_00),
  .c_addr_00(c_addr_00),
  .c_data_01(c_data_01),
  .c_addr_01(c_addr_01),
  .c_data_10(c_data_10),
  .c_addr_10(c_addr_10),
  .c_data_11(c_data_11),
  .c_addr_11(c_addr_11)

);
endmodule


/////////////////////////////////////////////////
// The 8x8 matmul definition
/////////////////////////////////////////////////

module matmul_8x8_systolic(
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

  c_data_00,
  c_addr_00,
  c_data_01,
  c_addr_01,
  c_data_10,
  c_addr_10,
  c_data_11,
  c_addr_11
);
  input clk;
  input reset;
  input start_mat_mul;
  output done_mat_mul;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;

  output [`AWIDTH-1:0] a_addr_00;
  output [`AWIDTH-1:0] a_addr_10;

  output [`AWIDTH-1:0] b_addr_00;
  output [`AWIDTH-1:0] b_addr_01;

  output [`AWIDTH-1:0] c_addr_00;
  output [`AWIDTH-1:0] c_addr_01;
  output [`AWIDTH-1:0] c_addr_10;
  output [`AWIDTH-1:0] c_addr_11;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_00;
  wire done_mat_mul_01;
  wire done_mat_mul_10;
  wire done_mat_mul_11;

  assign done_mat_mul =   done_mat_mul_00 &&
  done_mat_mul_01 &&
  done_mat_mul_10 &&
  done_mat_mul_11;

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
  .final_mat_mul_size(8'd8),
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
  .final_mat_mul_size(8'd8),
  .a_loc(8'd0),
  .b_loc(8'd1)
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
  .final_mat_mul_size(8'd8),
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
  .final_mat_mul_size(8'd8),
  .a_loc(8'd1),
  .b_loc(8'd1)
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