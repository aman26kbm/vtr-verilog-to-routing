
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 9
`define MEM_SIZE 512

//A is stored in column major order
//B is stored in row major order
//
// Matrix:
// 00 01 02 03 
// 10 11 12 13
// 20 21 22 23
// 30 31 32 33
//
// Row major:
// Addresses ->  0  1  2  3  4  5  6  7  8  9...
// Elements  -> 00 01 02 03 10 11 12 13 20 21...
//
// Col major:
// Addresses ->  0  1  2  3  4  5  6  7  8  9...
// Elements  -> 00 10 20 30 01 11 21 31 02 12...


//Assume MEM_SIZE-1 element of each matrix has data=0

module matrix_multiplication(
  clk, 
  reset, 
  enable_writing_to_mem, 
  data_pi,
  addr_pi, 
  we_a,
  we_b,
  out_sel, 
  data_out, 
  start_mat_mul,
  done_mat_mul
);

  input clk;
  input reset;
  input enable_writing_to_mem;
  input [4*`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input we_a;
  input we_b;
  input [`AWIDTH-1:0] out_sel;
  output [2*`DWIDTH-1:0] data_out;  
  input start_mat_mul;
  output done_mat_mul;

  wire [2*`DWIDTH-1:0] matrixC00;
  wire [2*`DWIDTH-1:0] matrixC01;
  wire [2*`DWIDTH-1:0] matrixC02;
  wire [2*`DWIDTH-1:0] matrixC03;
  wire [2*`DWIDTH-1:0] matrixC10;
  wire [2*`DWIDTH-1:0] matrixC11;
  wire [2*`DWIDTH-1:0] matrixC12;
  wire [2*`DWIDTH-1:0] matrixC13;
  wire [2*`DWIDTH-1:0] matrixC20;
  wire [2*`DWIDTH-1:0] matrixC21;
  wire [2*`DWIDTH-1:0] matrixC22;
  wire [2*`DWIDTH-1:0] matrixC23;
  wire [2*`DWIDTH-1:0] matrixC30;
  wire [2*`DWIDTH-1:0] matrixC31;
  wire [2*`DWIDTH-1:0] matrixC32;
  wire [2*`DWIDTH-1:0] matrixC33;

 wire [`AWIDTH-1:0] a_addr_muxed;
 wire [`AWIDTH-1:0] b_addr_muxed;

 wire [`AWIDTH-1:0] a_addr;
 wire [`AWIDTH-1:0] b_addr;

 wire [4*`DWIDTH-1:0] a_data;
 wire [4*`DWIDTH-1:0] b_data;


  // BRAM matrix A row0
  ram matrix_A_u (
    .addr0(a_addr_muxed),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data), 
    .clk(clk));

  // BRAM matrix B row0
  ram matrix_B_u (
    .addr0(b_addr_muxed),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data), 
    .clk(clk));

  assign a_addr_muxed = (enable_writing_to_mem) ? addr_pi : a_addr;
  assign b_addr_muxed = (enable_writing_to_mem) ? addr_pi : b_addr;
  
  matmul_4x4_systolic u_matmul_4x4_systolic(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
  .a_data(a_data),
  .b_data(b_data),
  .matrixC00(matrixC00),
  .matrixC01(matrixC01),
  .matrixC02(matrixC02),
  .matrixC03(matrixC03),
  .matrixC10(matrixC10),
  .matrixC11(matrixC11),
  .matrixC12(matrixC12),
  .matrixC13(matrixC13),
  .matrixC20(matrixC20),
  .matrixC21(matrixC21),
  .matrixC22(matrixC22),
  .matrixC23(matrixC23),
  .matrixC30(matrixC30),
  .matrixC31(matrixC31),
  .matrixC32(matrixC32),
  .matrixC33(matrixC33),
  .a_addr(a_addr),
  .b_addr(b_addr),
  .final_mat_mul_size(16'd4),
  .a_loc(16'd0),
  .b_loc(16'd0)
  );

          
  reg [2*`DWIDTH-1:0] data_out;

  //sending output to PO instead of memory
  always @(posedge clk)  
  begin  
     if(reset) begin  
       data_out <= 0;
     end
     else if (done_mat_mul) begin
       case (out_sel)
         0 : data_out <= matrixC00;
         1 : data_out <= matrixC01;
         2 : data_out <= matrixC02;
         3 : data_out <= matrixC03;
         4 : data_out <= matrixC10;
         5 : data_out <= matrixC11;
         6 : data_out <= matrixC12;
         7 : data_out <= matrixC13;
         8 : data_out <= matrixC20;
         9 : data_out <= matrixC21;
        10 : data_out <= matrixC22;
        11 : data_out <= matrixC23;
        12 : data_out <= matrixC30;
        13 : data_out <= matrixC31;
        14 : data_out <= matrixC32;
        15 : data_out <= matrixC33;
        default: data_out <= matrixC33;
      endcase 
    end
  end
endmodule


module matmul_4x4_systolic(
 clk,
 reset,
 start_mat_mul,
 done_mat_mul,
 a_data,
 b_data,
 matrixC00,
 matrixC01,
 matrixC02,
 matrixC03,
 matrixC10,
 matrixC11,
 matrixC12,
 matrixC13,
 matrixC20,
 matrixC21,
 matrixC22,
 matrixC23,
 matrixC30,
 matrixC31,
 matrixC32,
 matrixC33,
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
 output [2*`DWIDTH-1:0] matrixC00;
 output [2*`DWIDTH-1:0] matrixC01;
 output [2*`DWIDTH-1:0] matrixC02;
 output [2*`DWIDTH-1:0] matrixC03;
 output [2*`DWIDTH-1:0] matrixC10;
 output [2*`DWIDTH-1:0] matrixC11;
 output [2*`DWIDTH-1:0] matrixC12;
 output [2*`DWIDTH-1:0] matrixC13;
 output [2*`DWIDTH-1:0] matrixC20;
 output [2*`DWIDTH-1:0] matrixC21;
 output [2*`DWIDTH-1:0] matrixC22;
 output [2*`DWIDTH-1:0] matrixC23;
 output [2*`DWIDTH-1:0] matrixC30;
 output [2*`DWIDTH-1:0] matrixC31;
 output [2*`DWIDTH-1:0] matrixC32;
 output [2*`DWIDTH-1:0] matrixC33;
 output [`AWIDTH-1:0] a_addr;
 output [`AWIDTH-1:0] b_addr;
 input [15:0] final_mat_mul_size;
 input [15:0] a_loc;
 input [15:0] b_loc;

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
  if (reset || ~start_mat_mul || clk_cnt==0) begin
    a_addr <= `MEM_SIZE-1;//a_loc*16;
  end
  else if ((clk_cnt > final_mat_mul_size) || (done_mat_mul == 1)) begin
    a_addr <= `MEM_SIZE-1; 
  end
  else if (clk_cnt <= final_mat_mul_size) begin
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
  if (reset || ~start_mat_mul || clk_cnt==0) begin
    b_addr <= `MEM_SIZE-1;//b_loc*16;
  end
  else if ((clk_cnt > final_mat_mul_size) || (done_mat_mul == 1)) begin
    b_addr <= `MEM_SIZE-1;
  end
  else if (clk_cnt <= final_mat_mul_size) begin
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

assign a0 = a0_data;
assign a1 = a1_data_delayed_1;
assign a2 = a2_data_delayed_2;
assign a3 = a3_data_delayed_3;

assign b0 = b0_data;
assign b1 = b1_data_delayed_1;
assign b2 = b2_data_delayed_2;
assign b3 = b3_data_delayed_3;

wire [`DWIDTH-1:0] a00to01, a01to02, a02to03, a03to04;
wire [`DWIDTH-1:0] a10to11, a11to12, a12to13, a13to14;
wire [`DWIDTH-1:0] a20to21, a21to22, a22to23, a23to24;
wire [`DWIDTH-1:0] a30to31, a31to32, a32to33, a33to34;
wire [`DWIDTH-1:0] b00to10, b10to20, b20to30, b30to40; 
wire [`DWIDTH-1:0] b01to11, b11to21, b21to31, b31to41;
wire [`DWIDTH-1:0] b02to12, b12to22, b22to32, b32to42;
wire [`DWIDTH-1:0] b03to13, b13to23, b23to33, b33to43;


processing_element pe00(.reset(reset), .clk(clk), .in_a(a0),  .in_b(b0),  .out_a(a00to01), .out_b(b00to10), .out_c(matrixC00));
processing_element pe01(.reset(reset), .clk(clk), .in_a(a00to01), .in_b(b1),  .out_a(a01to02), .out_b(b01to11), .out_c(matrixC01));
processing_element pe02(.reset(reset), .clk(clk), .in_a(a01to02), .in_b(b2),  .out_a(a02to03), .out_b(b02to12), .out_c(matrixC02));
processing_element pe03(.reset(reset), .clk(clk), .in_a(a02to03), .in_b(b3),  .out_a(a03to04), .out_b(b03to13), .out_c(matrixC03));

processing_element pe10(.reset(reset), .clk(clk), .in_a(a1),  .in_b(b00to10), .out_a(a10to11), .out_b(b10to20), .out_c(matrixC10));
processing_element pe11(.reset(reset), .clk(clk), .in_a(a10to11), .in_b(b01to11), .out_a(a11to12), .out_b(b11to21), .out_c(matrixC11));
processing_element pe12(.reset(reset), .clk(clk), .in_a(a11to12), .in_b(b02to12), .out_a(a12to13), .out_b(b12to22), .out_c(matrixC12));
processing_element pe13(.reset(reset), .clk(clk), .in_a(a12to13), .in_b(b03to13), .out_a(a13to14), .out_b(b13to23), .out_c(matrixC13));

processing_element pe20(.reset(reset), .clk(clk), .in_a(a2),  .in_b(b10to20), .out_a(a20to21), .out_b(b20to30), .out_c(matrixC20));
processing_element pe21(.reset(reset), .clk(clk), .in_a(a20to21), .in_b(b11to21), .out_a(a21to22), .out_b(b21to31), .out_c(matrixC21));
processing_element pe22(.reset(reset), .clk(clk), .in_a(a21to22), .in_b(b12to22), .out_a(a22to23), .out_b(b22to32), .out_c(matrixC22));
processing_element pe23(.reset(reset), .clk(clk), .in_a(a22to23), .in_b(b13to23), .out_a(a23to24), .out_b(b23to33), .out_c(matrixC23));

processing_element pe30(.reset(reset), .clk(clk), .in_a(a3),  .in_b(b20to30), .out_a(a30to31), .out_b(b30to40), .out_c(matrixC30));
processing_element pe31(.reset(reset), .clk(clk), .in_a(a30to31), .in_b(b21to31), .out_a(a31to32), .out_b(b31to41), .out_c(matrixC31));
processing_element pe32(.reset(reset), .clk(clk), .in_a(a31to32), .in_b(b22to32), .out_a(a32to33), .out_b(b32to42), .out_c(matrixC32));
processing_element pe33(.reset(reset), .clk(clk), .in_a(a32to33), .in_b(b23to33), .out_a(a33to34), .out_b(b33to43), .out_c(matrixC33));

endmodule



module processing_element(reset, clk, in_a,in_b,out_a,out_b,out_c);

 input reset,clk;
 input  [`DWIDTH-1:0] in_a,in_b;
 output [2*`DWIDTH-1:0] out_c;
 output [`DWIDTH-1:0] out_a,out_b;

 reg [2*`DWIDTH-1:0] out_c;
 reg [`DWIDTH-1:0] out_a,out_b;

 wire [2*`DWIDTH-1:0] out_mac;

 
 mac u_mac(in_a, in_b, out_c, out_mac);

 always @(posedge clk)begin
    if(reset) begin
      out_a<=0;
      out_b<=0;
      out_c<=0;
    end
    else begin  
      out_c<=out_mac;
      out_a<=in_a;
      out_b<=in_b;
    end
 end
 
endmodule

module mac(mul0, mul1, add, out);
input [`DWIDTH-1:0] mul0;
input [`DWIDTH-1:0] mul1;
input [2*`DWIDTH-1:0] add;
output [2*`DWIDTH-1:0] out;

wire [2*`DWIDTH-1:0] tmp;
qmult mult_u1(mul0, mul1, tmp);
qadd add_u1(tmp, add, out);

endmodule


module qmult(i_multiplicand,i_multiplier,o_result);
input [`DWIDTH-1:0] i_multiplicand;
input [`DWIDTH-1:0] i_multiplier;
output [2*`DWIDTH-1:0] o_result;

//assign o_result = i_multiplicand * i_multiplier;
multiply u_mult(.a(i_multiplicand), .b(i_multiplier), .out(o_result));
//DW02_mult #(16,16) u_mult(.A(i_multiplicand), .B(i_multiplier), .TC(1'b0), .PRODUCT(o_result));

endmodule

module qadd(a,b,c);
input [2*`DWIDTH-1:0] a;
input [2*`DWIDTH-1:0] b;
output [2*`DWIDTH-1:0] c;

assign c = a + b;
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

