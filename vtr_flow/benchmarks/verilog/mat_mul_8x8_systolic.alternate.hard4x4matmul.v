
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define MAT_MUL_SIZE 4

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

  //Elements of output matrix C
  //Divided into 4 quadrants - C00,C01,C10,C11
  //Each quadrant has 16 elements (4x4 matrix)

  //Elements of quadrant 00
  wire [2*`DWIDTH-1:0] C00_matrixC00;
  wire [2*`DWIDTH-1:0] C00_matrixC01;
  wire [2*`DWIDTH-1:0] C00_matrixC02;
  wire [2*`DWIDTH-1:0] C00_matrixC03;
  wire [2*`DWIDTH-1:0] C00_matrixC10;
  wire [2*`DWIDTH-1:0] C00_matrixC11;
  wire [2*`DWIDTH-1:0] C00_matrixC12;
  wire [2*`DWIDTH-1:0] C00_matrixC13;
  wire [2*`DWIDTH-1:0] C00_matrixC20;
  wire [2*`DWIDTH-1:0] C00_matrixC21;
  wire [2*`DWIDTH-1:0] C00_matrixC22;
  wire [2*`DWIDTH-1:0] C00_matrixC23;
  wire [2*`DWIDTH-1:0] C00_matrixC30;
  wire [2*`DWIDTH-1:0] C00_matrixC31;
  wire [2*`DWIDTH-1:0] C00_matrixC32;
  wire [2*`DWIDTH-1:0] C00_matrixC33;

  //Elements of quadrant 01
  wire [2*`DWIDTH-1:0] C01_matrixC00;
  wire [2*`DWIDTH-1:0] C01_matrixC01;
  wire [2*`DWIDTH-1:0] C01_matrixC02;
  wire [2*`DWIDTH-1:0] C01_matrixC03;
  wire [2*`DWIDTH-1:0] C01_matrixC10;
  wire [2*`DWIDTH-1:0] C01_matrixC11;
  wire [2*`DWIDTH-1:0] C01_matrixC12;
  wire [2*`DWIDTH-1:0] C01_matrixC13;
  wire [2*`DWIDTH-1:0] C01_matrixC20;
  wire [2*`DWIDTH-1:0] C01_matrixC21;
  wire [2*`DWIDTH-1:0] C01_matrixC22;
  wire [2*`DWIDTH-1:0] C01_matrixC23;
  wire [2*`DWIDTH-1:0] C01_matrixC30;
  wire [2*`DWIDTH-1:0] C01_matrixC31;
  wire [2*`DWIDTH-1:0] C01_matrixC32;
  wire [2*`DWIDTH-1:0] C01_matrixC33;

  //Elements of quadrant 10
  wire [2*`DWIDTH-1:0] C10_matrixC00;
  wire [2*`DWIDTH-1:0] C10_matrixC01;
  wire [2*`DWIDTH-1:0] C10_matrixC02;
  wire [2*`DWIDTH-1:0] C10_matrixC03;
  wire [2*`DWIDTH-1:0] C10_matrixC10;
  wire [2*`DWIDTH-1:0] C10_matrixC11;
  wire [2*`DWIDTH-1:0] C10_matrixC12;
  wire [2*`DWIDTH-1:0] C10_matrixC13;
  wire [2*`DWIDTH-1:0] C10_matrixC20;
  wire [2*`DWIDTH-1:0] C10_matrixC21;
  wire [2*`DWIDTH-1:0] C10_matrixC22;
  wire [2*`DWIDTH-1:0] C10_matrixC23;
  wire [2*`DWIDTH-1:0] C10_matrixC30;
  wire [2*`DWIDTH-1:0] C10_matrixC31;
  wire [2*`DWIDTH-1:0] C10_matrixC32;
  wire [2*`DWIDTH-1:0] C10_matrixC33;

  //Elements of quadrant 11
  wire [2*`DWIDTH-1:0] C11_matrixC00;
  wire [2*`DWIDTH-1:0] C11_matrixC01;
  wire [2*`DWIDTH-1:0] C11_matrixC02;
  wire [2*`DWIDTH-1:0] C11_matrixC03;
  wire [2*`DWIDTH-1:0] C11_matrixC10;
  wire [2*`DWIDTH-1:0] C11_matrixC11;
  wire [2*`DWIDTH-1:0] C11_matrixC12;
  wire [2*`DWIDTH-1:0] C11_matrixC13;
  wire [2*`DWIDTH-1:0] C11_matrixC20;
  wire [2*`DWIDTH-1:0] C11_matrixC21;
  wire [2*`DWIDTH-1:0] C11_matrixC22;
  wire [2*`DWIDTH-1:0] C11_matrixC23;
  wire [2*`DWIDTH-1:0] C11_matrixC30;
  wire [2*`DWIDTH-1:0] C11_matrixC31;
  wire [2*`DWIDTH-1:0] C11_matrixC32;
  wire [2*`DWIDTH-1:0] C11_matrixC33;

  wire [4*`DWIDTH-1:0] C00_to_C01_a_data;
  wire [4*`DWIDTH-1:0] C00_to_C10_b_data;
  
  matmul_4x4_systolic u_matmul_4x4_systolic_00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_00),
  .a_data(a_data_C00),
  .b_data(b_data_C00),
  .a_data_out(C00_to_C01_a_data),
  .b_data_out(C00_to_C10_b_data),
  .matrixC00(C00_matrixC00),
  .matrixC01(C00_matrixC01),
  .matrixC02(C00_matrixC02),
  .matrixC03(C00_matrixC03),
  .matrixC10(C00_matrixC10),
  .matrixC11(C00_matrixC11),
  .matrixC12(C00_matrixC12),
  .matrixC13(C00_matrixC13),
  .matrixC20(C00_matrixC20),
  .matrixC21(C00_matrixC21),
  .matrixC22(C00_matrixC22),
  .matrixC23(C00_matrixC23),
  .matrixC30(C00_matrixC30),
  .matrixC31(C00_matrixC31),
  .matrixC32(C00_matrixC32),
  .matrixC33(C00_matrixC33),
  .a_addr(a_addr_00),
  .b_addr(b_addr_00),
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
  .a_data_out(C01_to_C02_a_data_NC),
  .b_data_out(C01_to_C11_b_data),
  .matrixC00(C01_matrixC00),
  .matrixC01(C01_matrixC01),
  .matrixC02(C01_matrixC02),
  .matrixC03(C01_matrixC03),
  .matrixC10(C01_matrixC10),
  .matrixC11(C01_matrixC11),
  .matrixC12(C01_matrixC12),
  .matrixC13(C01_matrixC13),
  .matrixC20(C01_matrixC20),
  .matrixC21(C01_matrixC21),
  .matrixC22(C01_matrixC22),
  .matrixC23(C01_matrixC23),
  .matrixC30(C01_matrixC30),
  .matrixC31(C01_matrixC31),
  .matrixC32(C01_matrixC32),
  .matrixC33(C01_matrixC33),
  .a_addr(a_addr_01_NC),
  .b_addr(b_addr_01),
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
  .a_data_out(C10_to_C11_a_data),
  .b_data_out(C10_to_C20_b_data_NC),
  .matrixC00(C10_matrixC00),
  .matrixC01(C10_matrixC01),
  .matrixC02(C10_matrixC02),
  .matrixC03(C10_matrixC03),
  .matrixC10(C10_matrixC10),
  .matrixC11(C10_matrixC11),
  .matrixC12(C10_matrixC12),
  .matrixC13(C10_matrixC13),
  .matrixC20(C10_matrixC20),
  .matrixC21(C10_matrixC21),
  .matrixC22(C10_matrixC22),
  .matrixC23(C10_matrixC23),
  .matrixC30(C10_matrixC30),
  .matrixC31(C10_matrixC31),
  .matrixC32(C10_matrixC32),
  .matrixC33(C10_matrixC33),
  .a_addr(a_addr_10),
  .b_addr(b_addr_10_NC),
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
  .a_data_out(C11_to_C12_a_data_NC),
  .b_data_out(C11_to_C21_b_data_NC),
  .matrixC00(C11_matrixC00),
  .matrixC01(C11_matrixC01),
  .matrixC02(C11_matrixC02),
  .matrixC03(C11_matrixC03),
  .matrixC10(C11_matrixC10),
  .matrixC11(C11_matrixC11),
  .matrixC12(C11_matrixC12),
  .matrixC13(C11_matrixC13),
  .matrixC20(C11_matrixC20),
  .matrixC21(C11_matrixC21),
  .matrixC22(C11_matrixC22),
  .matrixC23(C11_matrixC23),
  .matrixC30(C11_matrixC30),
  .matrixC31(C11_matrixC31),
  .matrixC32(C11_matrixC32),
  .matrixC33(C11_matrixC33),
  .a_addr(a_addr_11_NC),
  .b_addr(b_addr_11_NC),
  .final_mat_mul_size(8'd8),
  .a_loc(8'd1),
  .b_loc(8'd1)
  );

  reg [2*`DWIDTH-1:0] data_out;

  //sending elemnts of output matrix to PO instead of memory
  always @(posedge clk)  
  begin  
     if(reset) begin  
       data_out <= 0;
     end
     else if (done_mat_mul) begin
       case (out_sel)
         0 : data_out <= C00_matrixC00;
         1 : data_out <= C00_matrixC01;
         2 : data_out <= C00_matrixC02;
         3 : data_out <= C00_matrixC03;
         4 : data_out <= C00_matrixC10;
         5 : data_out <= C00_matrixC11;
         6 : data_out <= C00_matrixC12;
         7 : data_out <= C00_matrixC13;
         8 : data_out <= C00_matrixC20;
         9 : data_out <= C00_matrixC21;
        10 : data_out <= C00_matrixC22;
        11 : data_out <= C00_matrixC23;
        12 : data_out <= C00_matrixC30;
        13 : data_out <= C00_matrixC31;
        14 : data_out <= C00_matrixC32;
        15 : data_out <= C00_matrixC33;
        16 : data_out <= C01_matrixC00;
        17 : data_out <= C01_matrixC01;
        18 : data_out <= C01_matrixC02;
        19 : data_out <= C01_matrixC03;
        20 : data_out <= C01_matrixC10;
        21 : data_out <= C01_matrixC11;
        22 : data_out <= C01_matrixC12;
        23 : data_out <= C01_matrixC13;
        24 : data_out <= C01_matrixC20;
        25 : data_out <= C01_matrixC21;
        26 : data_out <= C01_matrixC22;
        27 : data_out <= C01_matrixC23;
        28 : data_out <= C01_matrixC30;
        29 : data_out <= C01_matrixC31;
        30 : data_out <= C01_matrixC32;
        31 : data_out <= C01_matrixC33;
        32 : data_out <= C10_matrixC00;
        33 : data_out <= C10_matrixC01;
        34 : data_out <= C10_matrixC02;
        35 : data_out <= C10_matrixC03;
        36 : data_out <= C10_matrixC10;
        37 : data_out <= C10_matrixC11;
        38 : data_out <= C10_matrixC12;
        39 : data_out <= C10_matrixC13;
        40 : data_out <= C10_matrixC20;
        41 : data_out <= C10_matrixC21;
        42 : data_out <= C10_matrixC22;
        43 : data_out <= C10_matrixC23;
        44 : data_out <= C10_matrixC30;
        45 : data_out <= C10_matrixC31;
        46 : data_out <= C10_matrixC32;
        47 : data_out <= C10_matrixC33;
        48 : data_out <= C11_matrixC00;
        49 : data_out <= C11_matrixC01;
        50 : data_out <= C11_matrixC02;
        51 : data_out <= C11_matrixC03;
        52 : data_out <= C11_matrixC10;
        53 : data_out <= C11_matrixC11;
        54 : data_out <= C11_matrixC12;
        55 : data_out <= C11_matrixC13;
        56 : data_out <= C11_matrixC20;
        57 : data_out <= C11_matrixC21;
        58 : data_out <= C11_matrixC22;
        59 : data_out <= C11_matrixC23;
        60 : data_out <= C11_matrixC30;
        61 : data_out <= C11_matrixC31;
        62 : data_out <= C11_matrixC32;
        63 : data_out <= C11_matrixC33;
        default: data_out <= C11_matrixC33;
      endcase 
    end
  end

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


