`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define BB_MAT_MUL_SIZE 16


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
  always @(posedge clk) begin
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

  wire [`AWIDTH-1:0] a_addr_0_0;
  wire [`AWIDTH-1:0] a_addr_1_0;
  wire [`AWIDTH-1:0] a_addr_2_0;

  wire [`AWIDTH-1:0] a_addr_muxed_0_0;
  wire [`AWIDTH-1:0] a_addr_muxed_1_0;
  wire [`AWIDTH-1:0] a_addr_muxed_2_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_2_0_reg;

  reg  [`AWIDTH-1:0] a_addr_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_1_0_reg;
  reg  [`AWIDTH-1:0] a_addr_2_0_reg;


  always @(posedge clk) begin
    if(reset) begin
      a_addr_0_0_reg <= 0;
      a_addr_1_0_reg <= 0;
      a_addr_2_0_reg <= 0;
      a_addr_muxed_0_0_reg <= 0;
      a_addr_muxed_1_0_reg <= 0;
      a_addr_muxed_2_0_reg <= 0;
    end else begin
      a_addr_0_0_reg <= a_addr_0_0;
      a_addr_1_0_reg <= a_addr_1_0;
      a_addr_2_0_reg <= a_addr_2_0;
      a_addr_muxed_0_0_reg <= a_addr_muxed_0_0;
      a_addr_muxed_1_0_reg <= a_addr_muxed_1_0;
      a_addr_muxed_2_0_reg <= a_addr_muxed_2_0;
    end
  end

  assign a_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_0_0_reg;
  assign a_addr_muxed_1_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_1_0_reg;
  assign a_addr_muxed_2_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_2_0_reg;

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

/////////////////////////////////////////////////
// BRAMs to store matrix B
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;

  wire [`AWIDTH-1:0] b_addr_0_0;
  wire [`AWIDTH-1:0] b_addr_0_1;
  wire [`AWIDTH-1:0] b_addr_0_2;

  wire [`AWIDTH-1:0] b_addr_muxed_0_0;
  wire [`AWIDTH-1:0] b_addr_muxed_0_1;
  wire [`AWIDTH-1:0] b_addr_muxed_0_2;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_2_reg;

  reg  [`AWIDTH-1:0] b_addr_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_0_1_reg;
  reg  [`AWIDTH-1:0] b_addr_0_2_reg;



  always @(posedge clk) begin
    if(reset) begin
      b_addr_0_0_reg <= 0;
      b_addr_0_1_reg <= 0;
      b_addr_0_2_reg <= 0;
      b_addr_muxed_0_0_reg <= 0;
      b_addr_muxed_0_1_reg <= 0;
      b_addr_muxed_0_2_reg <= 0;
    end else begin
      b_addr_0_0_reg <= b_addr_0_0;
      b_addr_0_1_reg <= b_addr_0_1;
      b_addr_0_2_reg <= b_addr_0_2;
      b_addr_muxed_0_0_reg <= b_addr_muxed_0_0;
      b_addr_muxed_0_1_reg <= b_addr_muxed_0_1;
      b_addr_muxed_0_2_reg <= b_addr_muxed_0_2;
    end
  end

  assign b_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_0_reg;
  assign b_addr_muxed_0_1 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_1_reg;
  assign b_addr_muxed_0_2 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_2_reg;

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

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  reg [`AWIDTH-1:0] c_addr;

  wire [`AWIDTH-1:0] c_addr_muxed_0_0;
  wire [`AWIDTH-1:0] c_addr_muxed_0_1;
  wire [`AWIDTH-1:0] c_addr_muxed_0_2;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_1_reg;
  reg  [`AWIDTH-1:0] c_addr_muxed_0_2_reg;

  assign c_addr_muxed_0_0 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_1 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;
  assign c_addr_muxed_0_2 = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;

  always @(posedge clk) begin
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2;

///////////////// ORing the data ///////////////////

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_1;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_2_reg;

  always @(posedge clk) begin
    if(reset) begin
      data_from_out_mat_0_0_reg <= 0;
      data_from_out_mat_0_1_reg <= 0;
      data_from_out_mat_0_2_reg <= 0;
    end else begin
      data_from_out_mat_0_0_reg <= data_from_out_mat_0_0;
      data_from_out_mat_0_1_reg <= data_from_out_mat_0_1;
      data_from_out_mat_0_2_reg <= data_from_out_mat_0_2;
    end
  end

  always @(posedge clk) begin
    if(reset) begin
      data_from_out_mat <= 0;
      c_reg_1 <= 0;
    end else begin
      c_reg_1 <= data_from_out_mat_0_0_reg | data_from_out_mat_0_1_reg;
      data_from_out_mat <= c_reg_1 | data_from_out_mat_0_2_reg;
    end
  end

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1_reg;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2_reg;
  always @(posedge clk) begin
    if(reset) begin
      c_data_row_0_reg <= 0;
      c_addr_muxed_0_0_reg <= 0;
      c_data_row_1_reg <= 0;
      c_addr_muxed_0_1_reg <= 0;
      c_data_row_2_reg <= 0;
      c_addr_muxed_0_2_reg <= 0;
    end else begin
      c_data_row_0_reg <= c_data_row_0;
      c_addr_muxed_0_0_reg <= c_addr_muxed_0_0;
      c_data_row_1_reg <= c_data_row_1;
      c_addr_muxed_0_1_reg <= c_addr_muxed_0_1;
      c_data_row_2_reg <= c_data_row_2;
      c_addr_muxed_0_2_reg <= c_addr_muxed_0_2;
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

/////////////////////////////////////////////////
// The 48x48 matmul instantiation
/////////////////////////////////////////////////

matmul_48x48_systolic u_matmul_48x48_systolic (
  .clk(clk),
  .done_mat_mul(done_mat_mul),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
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

  .c_data_row_0(c_data_row_0),
  .c_data_row_1(c_data_row_1),
  .c_data_row_2(c_data_row_2)
);
endmodule


/////////////////////////////////////////////////
// The 48x48 matmul definition
/////////////////////////////////////////////////

module matmul_48x48_systolic(
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

  c_data_row_0,
  c_data_row_1,
  c_data_row_2
);
  input clk;
  output done_mat_mul;

  input reset;
  input start_mat_mul;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_2_0;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_2;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_2;

  output [`AWIDTH-1:0] a_addr_0_0;
  output [`AWIDTH-1:0] a_addr_1_0;
  output [`AWIDTH-1:0] a_addr_2_0;

  output [`AWIDTH-1:0] b_addr_0_0;
  output [`AWIDTH-1:0] b_addr_0_1;
  output [`AWIDTH-1:0] b_addr_0_2;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_0_0;
  wire done_mat_mul_0_1;
  wire done_mat_mul_0_2;
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;
  wire done_mat_mul_1_2;
  wire done_mat_mul_2_0;
  wire done_mat_mul_2_1;
  wire done_mat_mul_2_2;

  assign done_mat_mul = done_mat_mul_0_0;

  /////////////////////////////////////////////////
  // Matmul 0_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_to_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_to_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0_to_0_1;

matmul_16x16_systolic u_matmul_16x16_systolic_0_0(
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
  .final_mat_mul_size(8'd48),
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

matmul_16x16_systolic u_matmul_16x16_systolic_0_1(
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
  .final_mat_mul_size(8'd48),
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

matmul_16x16_systolic u_matmul_16x16_systolic_0_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_0_2),
  .a_data(a_data_0_2_NC),
  .b_data(b_data_0_2),
  .a_data_in(a_data_0_1_to_0_2),
  .b_data_in(b_data_in_0_2_NC),
  .c_data_in(c_data_0_1_to_0_2),
  .c_data_out(c_data_row_0),
  .a_data_out(a_data_0_2_to_0_3),
  .b_data_out(b_data_0_2_to_1_2),
  .a_addr(a_addr_0_2_NC),
  .b_addr(b_addr_0_2),
  .final_mat_mul_size(8'd48),
  .a_loc(8'd0),
  .b_loc(8'd2)
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

matmul_16x16_systolic u_matmul_16x16_systolic_1_0(
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
  .final_mat_mul_size(8'd48),
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

matmul_16x16_systolic u_matmul_16x16_systolic_1_1(
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
  .final_mat_mul_size(8'd48),
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

matmul_16x16_systolic u_matmul_16x16_systolic_1_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_1_2),
  .a_data(a_data_1_2_NC),
  .b_data(b_data_1_2_NC),
  .a_data_in(a_data_1_1_to_1_2),
  .b_data_in(b_data_0_2_to_1_2),
  .c_data_in(c_data_1_1_to_1_2),
  .c_data_out(c_data_row_1),
  .a_data_out(a_data_1_2_to_1_3),
  .b_data_out(b_data_1_2_to_2_2),
  .a_addr(a_addr_1_2_NC),
  .b_addr(b_addr_1_2_NC),
  .final_mat_mul_size(8'd48),
  .a_loc(8'd1),
  .b_loc(8'd2)
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

matmul_16x16_systolic u_matmul_16x16_systolic_2_0(
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
  .final_mat_mul_size(8'd48),
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

matmul_16x16_systolic u_matmul_16x16_systolic_2_1(
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
  .final_mat_mul_size(8'd48),
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

matmul_16x16_systolic u_matmul_16x16_systolic_2_2(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_2_2),
  .a_data(a_data_2_2_NC),
  .b_data(b_data_2_2_NC),
  .a_data_in(a_data_2_1_to_2_2),
  .b_data_in(b_data_1_2_to_2_2),
  .c_data_in(c_data_2_1_to_2_2),
  .c_data_out(c_data_row_2),
  .a_data_out(a_data_2_2_to_2_3),
  .b_data_out(b_data_2_2_to_3_2),
  .a_addr(a_addr_2_2_NC),
  .b_addr(b_addr_2_2_NC),
  .final_mat_mul_size(8'd48),
  .a_loc(8'd2),
  .b_loc(8'd2)
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