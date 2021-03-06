
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define BB_MAT_MUL_SIZE 4


//Design with memories
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

  reg enable_writing_to_mem_reg;
  reg enable_reading_from_mem_reg;
  reg [`AWIDTH-1:0] addr_pi_reg;
  always @(posedge clk) begin
    if (reset) begin
      enable_writing_to_mem_reg<= 0;
      enable_reading_from_mem_reg<= 0;
      addr_pi_reg <= 0;
    end else begin
      enable_writing_to_mem_reg<= enable_writing_to_mem;
      enable_reading_from_mem_reg<= enable_reading_from_mem;
      addr_pi_reg <= addr_pi;
    end
  end

  wire [4*`DWIDTH-1:0] a_data;
  wire [`AWIDTH-1:0] a_addr;
  wire [`AWIDTH-1:0] a_addr_muxed;

  reg [`AWIDTH-1:0] a_addr_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_reg <= 0;
    end else begin
      a_addr_reg <= a_addr;
    end
  end

  reg [`AWIDTH-1:0] a_addr_muxed_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_muxed_reg <= 0;
    end else begin
      a_addr_muxed_reg<= a_addr_muxed;
    end
  end
  assign a_addr_muxed = (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_reg;

  // BRAM matrix A 
  ram matrix_A (
    .addr0(a_addr_muxed_reg),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data), 
    .clk(clk));

  wire [4*`DWIDTH-1:0] b_data;
  wire [`AWIDTH-1:0] b_addr;
  wire [`AWIDTH-1:0] b_addr_muxed;

  reg [`AWIDTH-1:0] b_addr_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_reg <= 0;
    end else begin
      b_addr_reg <= b_addr;
    end
  end

  reg [`AWIDTH-1:0] b_addr_muxed_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_muxed_reg <= 0;
    end else begin
      b_addr_muxed_reg<= b_addr_muxed;
    end
  end

  assign b_addr_muxed = (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_reg;

  // BRAM matrix B
  ram matrix_B (
    .addr0(b_addr_muxed_reg),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data), 
    .clk(clk));

  reg [`AWIDTH-1:0] c_addr;
  wire [`AWIDTH-1:0] c_addr_muxed;
  assign c_addr_muxed = (enable_reading_from_mem_reg) ? addr_pi_reg : c_addr;

  reg [`AWIDTH-1:0] c_addr_muxed_reg;
  always @(posedge clk) begin
    if (reset) begin
      c_addr_muxed_reg <= 0;
    end else begin
      c_addr_muxed_reg<= c_addr_muxed;
    end
  end

  always @(posedge clk) begin
  if (reset || done_mat_mul) begin
    c_addr <= 0;
  end
  else if (start_mat_mul) begin
      c_addr <= c_addr+1;
  end
end

wire [4*`DWIDTH-1:0] c_data_out;
reg  [4*`DWIDTH-1:0] c_data_out_reg;

always @(posedge clk) begin
  if (reset) begin
    c_data_out_reg<= 0;
  end
  else if (start_mat_mul) begin
      c_data_out_reg<= c_data_out;
  end
end

  reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat;
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_temp;

  always @(posedge clk) begin
    if(reset) begin
      data_from_out_mat <= 0;
    end else begin
      data_from_out_mat <= data_from_out_mat_temp;
    end
  end


  // BRAM matrix C
  ram matrix_C (
    .addr0(c_addr_muxed_reg),
    .d0(c_data_out_reg),
    .we0(we_c),
    .q0(data_from_out_mat_temp),
    .clk(clk));

wire [4*`DWIDTH-1:0] a_data_out_NC;
wire [4*`DWIDTH-1:0] b_data_out_NC;
wire [4*`DWIDTH-1:0] a_data_in_NC;
wire [4*`DWIDTH-1:0] b_data_in_NC;

matmul_4x4_systolic u_matmul_4x4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
  .a_data(a_data),
  .b_data(b_data),
  .a_data_in(a_data_in_NC),
  .b_data_in(b_data_in_NC),
  .c_data_in(64'b0),
  .c_data_out(c_data_out),
  .a_data_out(a_data_out_NC),
  .b_data_out(b_data_out_NC),
  .a_addr(a_addr),
  .b_addr(b_addr),
  .final_mat_mul_size(8'd4),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

endmodule  

/*
//Design without memories
module matrix_multiplication(
 clk,
 reset,
 start_mat_mul,
 done_mat_mul,
 a_data,
 b_data,
 a_data_in, //Data values coming in from previous matmul - systolic connections
 b_data_in,
 c_data_in,
 c_data_out,
 a_data_out,
 b_data_out,
 a_addr,
 b_addr
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

matmul_4x4_systolic u_matmul_4x4(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
  .a_data(a_data),
  .b_data(b_data),
  .a_data_in(a_data_in),
  .b_data_in(b_data_in),
  .c_data_in(c_data_in),
  .c_data_out(c_data_out),
  .a_data_out(a_data_out),
  .b_data_out(b_data_out),
  .a_addr(a_addr),
  .b_addr(b_addr),
  .final_mat_mul_size(8'd4),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

endmodule
*/

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
  else if (clk_cnt == 4*final_mat_mul_size-2+4) begin
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
  else if (clk_cnt >= a_loc*`BB_MAT_MUL_SIZE+final_mat_mul_size) begin
    a_addr <= `MEM_SIZE-1; 
  end
  else if ((clk_cnt >= a_loc*`BB_MAT_MUL_SIZE) && (clk_cnt < a_loc*`BB_MAT_MUL_SIZE+final_mat_mul_size)) begin
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
  else if (clk_cnt >= b_loc*`BB_MAT_MUL_SIZE+final_mat_mul_size) begin
    b_addr <= `MEM_SIZE-1;
  end
  else if ((clk_cnt >= b_loc*`BB_MAT_MUL_SIZE) && (clk_cnt < b_loc*`BB_MAT_MUL_SIZE+final_mat_mul_size)) begin
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

wire [`DWIDTH-1:0] cin_row0;
wire [`DWIDTH-1:0] cin_row1;
wire [`DWIDTH-1:0] cin_row2;
wire [`DWIDTH-1:0] cin_row3;
reg [4*`DWIDTH-1:0] row0_shift_reg;
reg [4*`DWIDTH-1:0] row1_shift_reg;
reg [4*`DWIDTH-1:0] row2_shift_reg;
reg [4*`DWIDTH-1:0] row3_shift_reg;
wire row0_latch_en;
wire row1_latch_en;
wire row2_latch_en;
wire row3_latch_en;

wire [`DWIDTH-1:0] matrixC00;
wire [`DWIDTH-1:0] matrixC01;
wire [`DWIDTH-1:0] matrixC02;
wire [`DWIDTH-1:0] matrixC03;
wire [`DWIDTH-1:0] matrixC10;
wire [`DWIDTH-1:0] matrixC11;
wire [`DWIDTH-1:0] matrixC12;
wire [`DWIDTH-1:0] matrixC13;
wire [`DWIDTH-1:0] matrixC20;
wire [`DWIDTH-1:0] matrixC21;
wire [`DWIDTH-1:0] matrixC22;
wire [`DWIDTH-1:0] matrixC23;
wire [`DWIDTH-1:0] matrixC30;
wire [`DWIDTH-1:0] matrixC31;
wire [`DWIDTH-1:0] matrixC32;
wire [`DWIDTH-1:0] matrixC33;

assign cin_row0 = c_data_in[`DWIDTH-1:0];
assign cin_row1 = c_data_in[2*`DWIDTH-1:`DWIDTH];
assign cin_row2 = c_data_in[3*`DWIDTH-1:2*`DWIDTH];
assign cin_row3 = c_data_in[4*`DWIDTH-1:3*`DWIDTH];

assign row0_latch_en = (clk_cnt==(`BB_MAT_MUL_SIZE + (a_loc+b_loc) * `BB_MAT_MUL_SIZE + 7));
assign row1_latch_en = (clk_cnt==(`BB_MAT_MUL_SIZE + (a_loc+b_loc) * `BB_MAT_MUL_SIZE + 8));
assign row2_latch_en = (clk_cnt==(`BB_MAT_MUL_SIZE + (a_loc+b_loc) * `BB_MAT_MUL_SIZE + 9));
assign row3_latch_en = (clk_cnt==(`BB_MAT_MUL_SIZE + (a_loc+b_loc) * `BB_MAT_MUL_SIZE + 10));

always @(posedge clk) begin
  if (reset) begin
      row0_shift_reg <= 0;
  end else if (row0_latch_en) begin
      row0_shift_reg <= {matrixC03, matrixC02, matrixC01, matrixC00};
  end else begin    
      row0_shift_reg <= {cin_row0, row0_shift_reg[63:16]};
  end
end    

always @(posedge clk) begin
  if (reset) begin
      row1_shift_reg <= 0;
  end else if (row1_latch_en) begin
      row1_shift_reg <= {matrixC13, matrixC12, matrixC11, matrixC10};
  end else begin    
      row1_shift_reg <= {cin_row1, row1_shift_reg[63:16]};
  end
end

always @(posedge clk) begin
  if (reset) begin
      row2_shift_reg <= 0;
  end else if (row2_latch_en) begin
      row2_shift_reg <= {matrixC23, matrixC22, matrixC21, matrixC20};
  end else begin    
      row2_shift_reg <= {cin_row2, row2_shift_reg[63:16]};
  end
end

always @(posedge clk) begin
  if (reset) begin
      row3_shift_reg <= 0;
  end else if (row3_latch_en) begin
      row3_shift_reg <= {matrixC33, matrixC32, matrixC31, matrixC30};
  end else begin    
      row3_shift_reg <= {cin_row3, row3_shift_reg[63:16]};
  end
end

processing_element pe00(.reset(reset), .clk(clk), .in_a(a0),      .in_b(b0),  .out_a(a00to01), .out_b(b00to10), .out_c(matrixC00),     .start_mat_mul(start_mat_mul));
processing_element pe01(.reset(reset), .clk(clk), .in_a(a00to01), .in_b(b1),  .out_a(a01to02), .out_b(b01to11), .out_c(matrixC01),     .start_mat_mul(start_mat_mul));
processing_element pe02(.reset(reset), .clk(clk), .in_a(a01to02), .in_b(b2),  .out_a(a02to03), .out_b(b02to12), .out_c(matrixC02),     .start_mat_mul(start_mat_mul));
processing_element pe03(.reset(reset), .clk(clk), .in_a(a02to03), .in_b(b3),  .out_a(a03to04), .out_b(b03to13), .out_c(matrixC03),     .start_mat_mul(start_mat_mul));
                                                                                                                                    
processing_element pe10(.reset(reset), .clk(clk), .in_a(a1),      .in_b(b00to10), .out_a(a10to11), .out_b(b10to20), .out_c(matrixC10), .start_mat_mul(start_mat_mul));
processing_element pe11(.reset(reset), .clk(clk), .in_a(a10to11), .in_b(b01to11), .out_a(a11to12), .out_b(b11to21), .out_c(matrixC11), .start_mat_mul(start_mat_mul));
processing_element pe12(.reset(reset), .clk(clk), .in_a(a11to12), .in_b(b02to12), .out_a(a12to13), .out_b(b12to22), .out_c(matrixC12), .start_mat_mul(start_mat_mul));
processing_element pe13(.reset(reset), .clk(clk), .in_a(a12to13), .in_b(b03to13), .out_a(a13to14), .out_b(b13to23), .out_c(matrixC13), .start_mat_mul(start_mat_mul));
                                                                                                                                   
processing_element pe20(.reset(reset), .clk(clk), .in_a(a2),      .in_b(b10to20), .out_a(a20to21), .out_b(b20to30), .out_c(matrixC20), .start_mat_mul(start_mat_mul));
processing_element pe21(.reset(reset), .clk(clk), .in_a(a20to21), .in_b(b11to21), .out_a(a21to22), .out_b(b21to31), .out_c(matrixC21), .start_mat_mul(start_mat_mul));
processing_element pe22(.reset(reset), .clk(clk), .in_a(a21to22), .in_b(b12to22), .out_a(a22to23), .out_b(b22to32), .out_c(matrixC22), .start_mat_mul(start_mat_mul));
processing_element pe23(.reset(reset), .clk(clk), .in_a(a22to23), .in_b(b13to23), .out_a(a23to24), .out_b(b23to33), .out_c(matrixC23), .start_mat_mul(start_mat_mul));
                                                                                                                                  
processing_element pe30(.reset(reset), .clk(clk), .in_a(a3),      .in_b(b20to30), .out_a(a30to31), .out_b(b30to40), .out_c(matrixC30), .start_mat_mul(start_mat_mul));
processing_element pe31(.reset(reset), .clk(clk), .in_a(a30to31), .in_b(b21to31), .out_a(a31to32), .out_b(b31to41), .out_c(matrixC31), .start_mat_mul(start_mat_mul));
processing_element pe32(.reset(reset), .clk(clk), .in_a(a31to32), .in_b(b22to32), .out_a(a32to33), .out_b(b32to42), .out_c(matrixC32), .start_mat_mul(start_mat_mul));
processing_element pe33(.reset(reset), .clk(clk), .in_a(a32to33), .in_b(b23to33), .out_a(a33to34), .out_b(b33to43), .out_c(matrixC33), .start_mat_mul(start_mat_mul));

assign a_data_out = {a33to34,a23to24,a13to14,a03to04};
assign b_data_out = {b33to43,b32to42,b31to41,b30to40};
assign c_data_out = {row3_shift_reg[15:0], row2_shift_reg[15:0], row1_shift_reg[15:0], row0_shift_reg[15:0]};
endmodule



module processing_element(
 reset, 
 clk, 
 in_a,
 in_b, 
 out_a, 
 out_b, 
 out_c,
 start_mat_mul
 );

 input reset;
 input clk;
 input  [`DWIDTH-1:0] in_a;
 input  [`DWIDTH-1:0] in_b;
 output [`DWIDTH-1:0] out_a;
 output [`DWIDTH-1:0] out_b;
 output [`DWIDTH-1:0] out_c;  //reduced precision
 input start_mat_mul;

 reg [`DWIDTH-1:0] out_a;
 reg [`DWIDTH-1:0] out_b;
 wire [`DWIDTH-1:0] out_c;

 wire [2*`DWIDTH-1:0] out_mac;

 assign out_c = (|out_mac[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : out_mac[`DWIDTH-1:0];

 mac_block u_mac(.a(in_a), .b(in_b), .out(out_mac), .start_mat_mul(start_mat_mul), .reset(reset), .clk(clk));

 always @(posedge clk)begin
    if(reset) begin
      out_a<=0;
      out_b<=0;
    end
    else begin  
      out_a<=in_a;
      out_b<=in_b;
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
//assign o_result = i_multiplicand * i_multiplier;
////multiply u_mult(.a(i_multiplicand), .b(i_multiplier), .out(o_result));
////DW02_mult #(16,16) u_mult(.A(i_multiplicand), .B(i_multiplier), .TC(1'b0), .PRODUCT(o_result));
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



module ram (addr0, d0, we0, q0,  clk);

input [`AWIDTH-1:0] addr0;
input [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] d0;
input we0;
output [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] q0;
input clk;

//reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] q0;
//reg [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] ram[`MEM_SIZE-1:0];
//
//always @(posedge clk)  
//begin 
//        if (we0) 
//        begin 
//            ram[addr0] <= d0; 
//        end 
//        q0 <= ram[addr0];
//end

single_port_ram u_single_port_ram(
  .data(d0),
  .we(we0),
  .addr(addr0),
  .clk(clk),
  .out(q0)
);
endmodule

