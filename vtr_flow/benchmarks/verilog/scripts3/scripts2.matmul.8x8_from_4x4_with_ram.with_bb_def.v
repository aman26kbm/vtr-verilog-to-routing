`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define BB_MAT_MUL_SIZE 4
`define MAT_MUL_SIZE 4


module matrix_multiplication(
  clk,
  reset_0,
  enable_writing_to_mem,
  enable_reading_from_mem,
  data_pi,
  addr_pi,
  we_a,
  we_b,
  we_c,
  data_from_out_mat,
  start_mat_mul_0,
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
  input start_mat_mul_0;
  reg enable_writing_to_mem_reg;
  reg [`AWIDTH-1:0] addr_pi_reg;
  always @(posedge clk) begin
    if(reset_0) begin
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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;

  wire [`AWIDTH-1:0] a_addr_0_0;
  wire [`AWIDTH-1:0] a_addr_1_0;

  wire [`AWIDTH-1:0] a_addr_muxed_0_0;
  wire [`AWIDTH-1:0] a_addr_muxed_1_0;

  reg  [`AWIDTH-1:0] a_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_muxed_1_0_reg;

  reg  [`AWIDTH-1:0] a_addr_0_0_reg;
  reg  [`AWIDTH-1:0] a_addr_1_0_reg;


  always @(posedge clk) begin
    if(reset_0) begin
      a_addr_0_0_reg <= 0;
      a_addr_1_0_reg <= 0;
      a_addr_muxed_0_0_reg <= 0;
      a_addr_muxed_1_0_reg <= 0;
    end else begin
      a_addr_0_0_reg <= a_addr_0_0;
      a_addr_1_0_reg <= a_addr_1_0;
      a_addr_muxed_0_0_reg <= a_addr_muxed_0_0;
      a_addr_muxed_1_0_reg <= a_addr_muxed_1_0;
    end
  end

  assign a_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_0_0_reg;
  assign a_addr_muxed_1_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_1_0_reg;

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

/////////////////////////////////////////////////
// BRAMs to store matrix B
/////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;

  wire [`AWIDTH-1:0] b_addr_0_0;
  wire [`AWIDTH-1:0] b_addr_0_1;

  wire [`AWIDTH-1:0] b_addr_muxed_0_0;
  wire [`AWIDTH-1:0] b_addr_muxed_0_1;

  reg  [`AWIDTH-1:0] b_addr_muxed_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_muxed_0_1_reg;

  reg  [`AWIDTH-1:0] b_addr_0_0_reg;
  reg  [`AWIDTH-1:0] b_addr_0_1_reg;



  always @(posedge clk) begin
    if(reset_0) begin
      b_addr_0_0_reg <= 0;
      b_addr_0_1_reg <= 0;
      b_addr_muxed_0_0_reg <= 0;
      b_addr_muxed_0_1_reg <= 0;
    end else begin
      b_addr_0_0_reg <= b_addr_0_0;
      b_addr_0_1_reg <= b_addr_0_1;
      b_addr_muxed_0_0_reg <= b_addr_muxed_0_0;
      b_addr_muxed_0_1_reg <= b_addr_muxed_0_1;
    end
  end

  assign b_addr_muxed_0_0 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_0_reg;
  assign b_addr_muxed_0_1 = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_0_1_reg;

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

/////////////////////////////////////////////////
// BRAMs to store matrix C
/////////////////////////////////////////////////

  reg [`AWIDTH-1:0] c_addr;

  wire [`AWIDTH-1:0] c_addr_muxed_0_0;
  wire [`AWIDTH-1:0] c_addr_muxed_0_1;

  assign c_addr_muxed_0_0 = (enable_reading_from_mem) ? addr_pi : c_addr;
  assign c_addr_muxed_0_1 = (enable_reading_from_mem) ? addr_pi : c_addr;

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
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_0_1;

///////////////// ORing the data ///////////////////
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_0;
  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_reg_1;
  always @(posedge clk) begin
    if(reset_0) begin
      c_reg_0 <= 0;
      c_reg_1 <= 0;
    end else begin
      c_reg_0 <= data_from_out_mat_0_0;
      c_reg_1 <= c_reg_0 | data_from_out_mat_0_1;
      data_from_out_mat <= c_reg_1;
    end
  end

  //  BRAM matrix C row_0
  ram matrix_row_0 (
    .addr0(c_addr_muxed_0_0),
    .d0(c_data_row_0),
    .we0(we_c),
    .q0(data_from_out_mat_0_0),
    .clk(clk));

  //  BRAM matrix C row_1
  ram matrix_row_1 (
    .addr0(c_addr_muxed_0_1),
    .d0(c_data_row_1),
    .we0(we_c),
    .q0(data_from_out_mat_0_1),
    .clk(clk));

/////////////////////////////////////////////////
// The 8x8 matmul instantiation
/////////////////////////////////////////////////

matmul_8x8_systolic u_matmul_8x8_systolic (
  .clk(clk),
  .done_mat_mul(done_mat_mul),
  .reset_0(reset_0),
  .start_mat_mul_0(start_mat_mul_0),
  .a_data_0_0(a_data_0_0),
  .a_addr_0_0(a_addr_0_0),
  .b_data_0_0(b_data_0_0),
  .b_addr_0_0(b_addr_0_0),
  .a_data_1_0(a_data_1_0),
  .a_addr_1_0(a_addr_1_0),
  .b_data_0_1(b_data_0_1),
  .b_addr_0_1(b_addr_0_1),

  .c_data_row_0(c_data_row_0),
  .c_data_row_1(c_data_row_1)
);
endmodule


/////////////////////////////////////////////////
// The 8x8 matmul definition
/////////////////////////////////////////////////

module matmul_8x8_systolic(
  clk,
  done_mat_mul,
  reset_0,
  start_mat_mul_0,
  a_data_0_0,
  a_addr_0_0,
  b_data_0_0,
  b_addr_0_0,
  a_data_1_0,
  a_addr_1_0,
  b_data_0_1,
  b_addr_0_1,

  c_data_row_0,
  c_data_row_1
);
  input clk;
  output done_mat_mul;

  input reset_0;
  input start_mat_mul_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_1_0;

  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0;
  input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_1;

  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_0;
  output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_row_1;

  output [`AWIDTH-1:0] a_addr_0_0;
  output [`AWIDTH-1:0] a_addr_1_0;

  output [`AWIDTH-1:0] b_addr_0_0;
  output [`AWIDTH-1:0] b_addr_0_1;

  /////////////////////////////////////////////////
  // ORing all done signals
  /////////////////////////////////////////////////
  wire done_mat_mul_0_0;
  wire done_mat_mul_0_1;
  wire done_mat_mul_1_0;
  wire done_mat_mul_1_1;

  assign done_mat_mul =   done_mat_mul_0_0 &&
  done_mat_mul_0_1 &&
  done_mat_mul_1_0 &&
  done_mat_mul_1_1;

  /////////////////////////////////////////////////
  // Matmul 0_0
  /////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_0_0_to_0_1;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_0_0_to_1_0;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_0_0_NC;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] c_data_0_0_to_0_1;

matmul_4x4_systolic u_matmul_4x4_systolic_0_0(
  .clk(clk),
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
  .done_mat_mul(done_mat_mul_0_0),
  .a_data(a_data_0_0),
  .b_data(b_data_0_0),
  .a_data_in(a_data_in_0_0_NC),
  .b_data_in(b_data_in_0_0_NC),
  .c_data_in(64'b0),
  .c_data_out(c_data_0_0_to_0_1),
  .a_data_out(a_data_0_0_to_0_1),
  .b_data_out(b_data_0_0_to_1_0),
  .a_addr(a_addr_0_0),
  .b_addr(b_addr_0_0),
  .final_mat_mul_size(8'd8),
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
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
  .done_mat_mul(done_mat_mul_0_1),
  .a_data(a_data_0_1_NC),
  .b_data(b_data_0_1),
  .a_data_in(a_data_0_0_to_0_1),
  .b_data_in(b_data_in_0_1_NC),
  .c_data_in(c_data_0_0_to_0_1),
  .c_data_out(c_data_row_0),
  .a_data_out(a_data_0_1_to_0_2),
  .b_data_out(b_data_0_1_to_1_1),
  .a_addr(a_addr_0_1_NC),
  .b_addr(b_addr_0_1),
  .final_mat_mul_size(8'd8),
  .a_loc(8'd0),
  .b_loc(8'd1)
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

matmul_4x4_systolic u_matmul_4x4_systolic_1_0(
  .clk(clk),
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
  .done_mat_mul(done_mat_mul_1_0),
  .a_data(a_data_1_0),
  .b_data(b_data_1_0_NC),
  .a_data_in(a_data_in_1_0_NC),
  .b_data_in(b_data_0_0_to_1_0),
  .c_data_in(64'b0),
  .c_data_out(c_data_1_0_to_1_1),
  .a_data_out(a_data_1_0_to_1_1),
  .b_data_out(b_data_1_0_to_2_0),
  .a_addr(a_addr_1_0),
  .b_addr(b_addr_1_0_NC),
  .final_mat_mul_size(8'd8),
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
  .reset(reset_0),
  .start_mat_mul(start_mat_mul_0),
  .done_mat_mul(done_mat_mul_1_1),
  .a_data(a_data_1_1_NC),
  .b_data(b_data_1_1_NC),
  .a_data_in(a_data_1_0_to_1_1),
  .b_data_in(b_data_0_1_to_1_1),
  .c_data_in(c_data_1_0_to_1_1),
  .c_data_out(c_data_row_1),
  .a_data_out(a_data_1_1_to_1_2),
  .b_data_out(b_data_1_1_to_2_1),
  .a_addr(a_addr_1_1_NC),
  .b_addr(b_addr_1_1_NC),
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

module matmul_4x4_systolic(
 clk,
 reset,
 start_mat_mul,
 done_mat_mul,
 a_data,
 b_data,
 a_data_in, //Data values coming in from previous matmul - systolic connections
 b_data_in,
 c_data_in, //Data values coming in from previous matmul - systolic shifting
 c_data_out, //Data values going out to next matmul - systolic shifting
 a_data_out,
 b_data_out,
 a_addr,
 b_addr,
 final_mat_mul_size,
 a_loc,
 b_loc
);

 input clk;
 input reset;
 input start_mat_mul;
 output done_mat_mul;
 input [4*`DWIDTH-1:0] a_data;
 input [4*`DWIDTH-1:0] b_data;
 input [4*`DWIDTH-1:0] a_data_in;
 input [4*`DWIDTH-1:0] b_data_in;
 input [4*`DWIDTH-1:0] c_data_in;
 output [4*`DWIDTH-1:0] c_data_out;
 output [4*`DWIDTH-1:0] a_data_out;
 output [4*`DWIDTH-1:0] b_data_out;
 output [`AWIDTH-1:0] a_addr;
 output [`AWIDTH-1:0] b_addr;
 input [7:0] final_mat_mul_size;
 input [7:0] a_loc;
 input [7:0] b_loc;

reg done_mat_mul;

reg [15:0] clk_cnt;
always @(posedge clk) begin
  if (reset || ~start_mat_mul) begin
    clk_cnt <= 0;
    done_mat_mul <= 0;
  end
  else if (clk_cnt == 3*final_mat_mul_size-2+2) begin
      done_mat_mul <= 1;
  end
  else if (done_mat_mul == 0) begin
      clk_cnt <= clk_cnt + 1;
  end    
end
 
reg [`AWIDTH-1:0] a_addr;
always @(posedge clk) begin
  if (reset || ~start_mat_mul) begin
    a_addr <= `MEM_SIZE-1;//a_loc*16;
  end
  else if (clk_cnt >= a_loc*`MAT_MUL_SIZE+final_mat_mul_size) begin
    a_addr <= `MEM_SIZE-1; 
  end
  else if ((clk_cnt >= a_loc*`MAT_MUL_SIZE) && (clk_cnt < a_loc*`MAT_MUL_SIZE+final_mat_mul_size)) begin
    a_addr <= a_addr + 1;
  end
end  

wire [`DWIDTH-1:0] a0_data;
wire [`DWIDTH-1:0] a1_data;
wire [`DWIDTH-1:0] a2_data;
wire [`DWIDTH-1:0] a3_data;
assign a0_data = a_data[`DWIDTH-1:0];
assign a1_data = a_data[2*`DWIDTH-1:`DWIDTH];
assign a2_data = a_data[3*`DWIDTH-1:2*`DWIDTH];
assign a3_data = a_data[4*`DWIDTH-1:3*`DWIDTH];

wire [`DWIDTH-1:0] a0_data_in;
wire [`DWIDTH-1:0] a1_data_in;
wire [`DWIDTH-1:0] a2_data_in;
wire [`DWIDTH-1:0] a3_data_in;
assign a0_data_in = a_data_in[`DWIDTH-1:0];
assign a1_data_in = a_data_in[2*`DWIDTH-1:`DWIDTH];
assign a2_data_in = a_data_in[3*`DWIDTH-1:2*`DWIDTH];
assign a3_data_in = a_data_in[4*`DWIDTH-1:3*`DWIDTH];

reg [`DWIDTH-1:0] a1_data_delayed_1;
reg [`DWIDTH-1:0] a2_data_delayed_1;
reg [`DWIDTH-1:0] a2_data_delayed_2;
reg [`DWIDTH-1:0] a3_data_delayed_1;
reg [`DWIDTH-1:0] a3_data_delayed_2;
reg [`DWIDTH-1:0] a3_data_delayed_3;
always @(posedge clk) begin
  if (reset || ~start_mat_mul || clk_cnt==0) begin
    a1_data_delayed_1 <= 0;
    a2_data_delayed_1 <= 0;
    a2_data_delayed_2 <= 0;
    a3_data_delayed_1 <= 0;
    a3_data_delayed_2 <= 0;
    a3_data_delayed_3 <= 0;
  end
  else begin
    a1_data_delayed_1 <= a1_data;
    a2_data_delayed_1 <= a2_data;
    a2_data_delayed_2 <= a2_data_delayed_1;
    a3_data_delayed_1 <= a3_data;
    a3_data_delayed_2 <= a3_data_delayed_1;
    a3_data_delayed_3 <= a3_data_delayed_2;
  end
end

reg [`AWIDTH-1:0] b_addr;
always @(posedge clk) begin
  if (reset || ~start_mat_mul) begin
    b_addr <= `MEM_SIZE-1;//b_loc*16;
  end
  else if (clk_cnt >= b_loc*`MAT_MUL_SIZE+final_mat_mul_size) begin
    b_addr <= `MEM_SIZE-1;
  end
  else if ((clk_cnt >= b_loc*`MAT_MUL_SIZE) && (clk_cnt < b_loc*`MAT_MUL_SIZE+final_mat_mul_size)) begin
    b_addr <= b_addr + 1;
  end
end  

wire [`DWIDTH-1:0] b0_data;
wire [`DWIDTH-1:0] b1_data;
wire [`DWIDTH-1:0] b2_data;
wire [`DWIDTH-1:0] b3_data;
assign b0_data = b_data[`DWIDTH-1:0];
assign b1_data = b_data[2*`DWIDTH-1:`DWIDTH];
assign b2_data = b_data[3*`DWIDTH-1:2*`DWIDTH];
assign b3_data = b_data[4*`DWIDTH-1:3*`DWIDTH];

wire [`DWIDTH-1:0] b0_data_in;
wire [`DWIDTH-1:0] b1_data_in;
wire [`DWIDTH-1:0] b2_data_in;
wire [`DWIDTH-1:0] b3_data_in;
assign b0_data_in = b_data_in[`DWIDTH-1:0];
assign b1_data_in = b_data_in[2*`DWIDTH-1:`DWIDTH];
assign b2_data_in = b_data_in[3*`DWIDTH-1:2*`DWIDTH];
assign b3_data_in = b_data_in[4*`DWIDTH-1:3*`DWIDTH];

reg [`DWIDTH-1:0] b1_data_delayed_1;
reg [`DWIDTH-1:0] b2_data_delayed_1;
reg [`DWIDTH-1:0] b2_data_delayed_2;
reg [`DWIDTH-1:0] b3_data_delayed_1;
reg [`DWIDTH-1:0] b3_data_delayed_2;
reg [`DWIDTH-1:0] b3_data_delayed_3;
always @(posedge clk) begin
  if (reset || ~start_mat_mul || clk_cnt==0) begin
    b1_data_delayed_1 <= 0;
    b2_data_delayed_1 <= 0;
    b2_data_delayed_2 <= 0;
    b3_data_delayed_1 <= 0;
    b3_data_delayed_2 <= 0;
    b3_data_delayed_3 <= 0;
  end
  else begin
    b1_data_delayed_1 <= b1_data;
    b2_data_delayed_1 <= b2_data;
    b2_data_delayed_2 <= b2_data_delayed_1;
    b3_data_delayed_1 <= b3_data;
    b3_data_delayed_2 <= b3_data_delayed_1;
    b3_data_delayed_3 <= b3_data_delayed_2;
  end
end


wire [`DWIDTH-1:0] a0;
wire [`DWIDTH-1:0] a1;
wire [`DWIDTH-1:0] a2;
wire [`DWIDTH-1:0] a3;
wire [`DWIDTH-1:0] b0;
wire [`DWIDTH-1:0] b1;
wire [`DWIDTH-1:0] b2;
wire [`DWIDTH-1:0] b3;

//If b_loc is 0, that means this matmul block is on the top-row of the
//final large matmul. In that case, b will take inputs from mem.
//If b_loc != 0, that means this matmul block is not on the top-row of the
//final large matmul. In that case, b will take inputs from the matmul on top
//of this one.
assign a0 = (b_loc==0) ? a0_data           : a0_data_in;
assign a1 = (b_loc==0) ? a1_data_delayed_1 : a1_data_in;
assign a2 = (b_loc==0) ? a2_data_delayed_2 : a2_data_in;
assign a3 = (b_loc==0) ? a3_data_delayed_3 : a3_data_in;

//If a_loc is 0, that means this matmul block is on the left-col of the
//final large matmul. In that case, a will take inputs from mem.
//If a_loc != 0, that means this matmul block is not on the left-col of the
//final large matmul. In that case, a will take inputs from the matmul on left
//of this one.
assign b0 = (a_loc==0) ? b0_data           : b0_data_in;
assign b1 = (a_loc==0) ? b1_data_delayed_1 : b1_data_in;
assign b2 = (a_loc==0) ? b2_data_delayed_2 : b2_data_in;
assign b3 = (a_loc==0) ? b3_data_delayed_3 : b3_data_in;

wire [`DWIDTH-1:0] a00to01, a01to02, a02to03, a03to04;
wire [`DWIDTH-1:0] a10to11, a11to12, a12to13, a13to14;
wire [`DWIDTH-1:0] a20to21, a21to22, a22to23, a23to24;
wire [`DWIDTH-1:0] a30to31, a31to32, a32to33, a33to34;

wire [`DWIDTH-1:0] b00to10, b10to20, b20to30, b30to40; 
wire [`DWIDTH-1:0] b01to11, b11to21, b21to31, b31to41;
wire [`DWIDTH-1:0] b02to12, b12to22, b22to32, b32to42;
wire [`DWIDTH-1:0] b03to13, b13to23, b23to33, b33to43;

wire [`DWIDTH-1:0] c01to00, c02to01, c03to02, cin_row0, cout_row0;
wire [`DWIDTH-1:0] c11to10, c12to11, c13to12, cin_row1, cout_row1;
wire [`DWIDTH-1:0] c21to20, c22to21, c23to22, cin_row2, cout_row2;
wire [`DWIDTH-1:0] c31to30, c32to31, c33to32, cin_row3, cout_row3;

assign cin_row0 = c_data_in[`DWIDTH-1:0];
assign cin_row1 = c_data_in[2*`DWIDTH-1:`DWIDTH];
assign cin_row2 = c_data_in[3*`DWIDTH-1:2*`DWIDTH];
assign cin_row3 = c_data_in[4*`DWIDTH-1:3*`DWIDTH];

wire pe00_sel;
wire pe01_sel;
wire pe02_sel;
wire pe03_sel;
wire pe10_sel;
wire pe11_sel;
wire pe12_sel;
wire pe13_sel;
wire pe20_sel;
wire pe21_sel;
wire pe22_sel;
wire pe23_sel;
wire pe30_sel;
wire pe31_sel;
wire pe32_sel;
wire pe33_sel;

assign pe00_sel = (clk_cnt==final_mat_mul_size+2);
assign pe01_sel = (clk_cnt==final_mat_mul_size+3);
assign pe02_sel = (clk_cnt==final_mat_mul_size+4);
assign pe03_sel = (clk_cnt==final_mat_mul_size+5);
assign pe10_sel = (clk_cnt==final_mat_mul_size+3);
assign pe11_sel = (clk_cnt==final_mat_mul_size+4);
assign pe12_sel = (clk_cnt==final_mat_mul_size+5);
assign pe13_sel = (clk_cnt==final_mat_mul_size+6);
assign pe20_sel = (clk_cnt==final_mat_mul_size+4);
assign pe21_sel = (clk_cnt==final_mat_mul_size+5);
assign pe22_sel = (clk_cnt==final_mat_mul_size+6);
assign pe23_sel = (clk_cnt==final_mat_mul_size+7);
assign pe30_sel = (clk_cnt==final_mat_mul_size+5);
assign pe31_sel = (clk_cnt==final_mat_mul_size+6);
assign pe32_sel = (clk_cnt==final_mat_mul_size+7);
assign pe33_sel = (clk_cnt==final_mat_mul_size+8);

processing_element pe00(.reset(reset), .clk(clk), .in_a(a0),      .in_b(b0),      .in_c(c01to00),   .select(pe00_sel),  .out_a(a00to01), .out_b(b00to10), .out_c(cout_row0));
processing_element pe01(.reset(reset), .clk(clk), .in_a(a00to01), .in_b(b1),      .in_c(c02to01),   .select(pe01_sel),  .out_a(a01to02), .out_b(b01to11), .out_c(c01to00));
processing_element pe02(.reset(reset), .clk(clk), .in_a(a01to02), .in_b(b2),      .in_c(c03to02),   .select(pe02_sel),  .out_a(a02to03), .out_b(b02to12), .out_c(c02to01));
processing_element pe03(.reset(reset), .clk(clk), .in_a(a02to03), .in_b(b3),      .in_c(cin_row0),  .select(pe03_sel),  .out_a(a03to04), .out_b(b03to13), .out_c(c03to02));
                                                                                                                
processing_element pe10(.reset(reset), .clk(clk), .in_a(a1),      .in_b(b00to10), .in_c(c11to10),   .select(pe10_sel),  .out_a(a10to11), .out_b(b10to20), .out_c(cout_row1));
processing_element pe11(.reset(reset), .clk(clk), .in_a(a10to11), .in_b(b01to11), .in_c(c12to11),   .select(pe11_sel),  .out_a(a11to12), .out_b(b11to21), .out_c(c11to10));
processing_element pe12(.reset(reset), .clk(clk), .in_a(a11to12), .in_b(b02to12), .in_c(c13to12),   .select(pe12_sel),  .out_a(a12to13), .out_b(b12to22), .out_c(c12to11));
processing_element pe13(.reset(reset), .clk(clk), .in_a(a12to13), .in_b(b03to13), .in_c(cin_row1),  .select(pe13_sel),  .out_a(a13to14), .out_b(b13to23), .out_c(c13to12));
                                                                                                                
processing_element pe20(.reset(reset), .clk(clk), .in_a(a2),      .in_b(b10to20), .in_c(c21to20),   .select(pe20_sel),  .out_a(a20to21), .out_b(b20to30), .out_c(cout_row2));
processing_element pe21(.reset(reset), .clk(clk), .in_a(a20to21), .in_b(b11to21), .in_c(c22to21),   .select(pe21_sel),  .out_a(a21to22), .out_b(b21to31), .out_c(c21to20));
processing_element pe22(.reset(reset), .clk(clk), .in_a(a21to22), .in_b(b12to22), .in_c(c23to22),   .select(pe22_sel),  .out_a(a22to23), .out_b(b22to32), .out_c(c22to21));
processing_element pe23(.reset(reset), .clk(clk), .in_a(a22to23), .in_b(b13to23), .in_c(cin_row2),  .select(pe23_sel),  .out_a(a23to24), .out_b(b23to33), .out_c(c23to22));
                                                                                                                
processing_element pe30(.reset(reset), .clk(clk), .in_a(a3),      .in_b(b20to30), .in_c(c31to30),   .select(pe30_sel),  .out_a(a30to31), .out_b(b30to40), .out_c(cout_row3));
processing_element pe31(.reset(reset), .clk(clk), .in_a(a30to31), .in_b(b21to31), .in_c(c32to31),   .select(pe31_sel),  .out_a(a31to32), .out_b(b31to41), .out_c(c31to30));
processing_element pe32(.reset(reset), .clk(clk), .in_a(a31to32), .in_b(b22to32), .in_c(c33to32),   .select(pe32_sel),  .out_a(a32to33), .out_b(b32to42), .out_c(c32to31));
processing_element pe33(.reset(reset), .clk(clk), .in_a(a32to33), .in_b(b23to33), .in_c(cin_row3),  .select(pe33_sel),  .out_a(a33to34), .out_b(b33to43), .out_c(c33to32));

assign a_data_out = {a33to34,a23to24,a13to14,a03to04};
assign b_data_out = {b33to43,b32to42,b31to41,b30to40};
assign c_data_out = {cout_row3, cout_row2, cout_row1, cout_row0};
endmodule



module processing_element(
 reset, 
 clk, 
 in_a,
 in_b, 
 in_c,
 select,
 out_a, 
 out_b, 
 out_c
 );

 input reset;
 input clk;
 input  [`DWIDTH-1:0] in_a;
 input  [`DWIDTH-1:0] in_b;
 input  [`DWIDTH-1:0] in_c;
 input  select; //if select=1, then this PEs output is sent on out_c,
                // otherwise in_c is sent out
 output [`DWIDTH-1:0] out_a;
 output [`DWIDTH-1:0] out_b;
 output [`DWIDTH-1:0] out_c;  //reduced precision

 reg [2*`DWIDTH-1:0] out_c_full_precision;
 wire [`DWIDTH-1:0] out_c_red_precision;
 wire [`DWIDTH-1:0] out_c_mux;
 reg [`DWIDTH-1:0] out_a;
 reg [`DWIDTH-1:0] out_b;
 //reg [`DWIDTH-1:0] out_c;
 wire [`DWIDTH-1:0] out_c;
 assign out_c = out_c_mux;

 wire [2*`DWIDTH-1:0] out_mac;

 assign out_c_red_precision = (|out_c_full_precision[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : out_c_full_precision[`DWIDTH-1:0];
 assign out_c_mux = select ? out_c_red_precision : in_c;
 
 mac_block u_mac(.a(in_a), .b(in_b), .c(out_c_full_precision), .out(out_mac));
 //mac u_mac(.mul0(in_a), .mul1(in_b), .add(out_c_full_precision), .out(out_mac));

 always @(posedge clk)begin
    if(reset) begin
      out_a<=0;
      out_b<=0;
      out_c_full_precision<=0;
      //out_c<=0;
    end
    else begin  
      out_a<=in_a;
      out_b<=in_b;
      out_c_full_precision<=out_mac;
      //out_c<=out_c_mux;
    end
 end
 
endmodule

//module mac(mul0, mul1, add, out);
//input [`DWIDTH-1:0] mul0;
//input [`DWIDTH-1:0] mul1;
//input [2*`DWIDTH-1:0] add;
//output [2*`DWIDTH-1:0] out;
//
//wire [2*`DWIDTH-1:0] tmp;
//qmult mult_u1(mul0, mul1, tmp);
//qadd add_u1(tmp, add, out);
//
//endmodule
//
//
//module qmult(i_multiplicand,i_multiplier,o_result);
//input [`DWIDTH-1:0] i_multiplicand;
//input [`DWIDTH-1:0] i_multiplier;
//output [2*`DWIDTH-1:0] o_result;
//
////assign o_result = i_multiplicand * i_multiplier;
////multiply u_mult(.a(i_multiplicand), .b(i_multiplier), .out(o_result));
//DW02_mult #(16,16) u_mult(.A(i_multiplicand), .B(i_multiplier), .TC(1'b0), .PRODUCT(o_result));
//
//endmodule
//
//module qadd(a,b,c);
//input [2*`DWIDTH-1:0] a;
//input [2*`DWIDTH-1:0] b;
//output [2*`DWIDTH-1:0] c;
//
//assign c = a + b;
//endmodule


