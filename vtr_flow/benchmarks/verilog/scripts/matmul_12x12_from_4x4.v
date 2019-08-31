`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define MAT_MUL_SIZE 4
`define BB_MAT_MUL_SIZE `MAT_MUL_SIZE


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

  reg enable_writing_to_mem_reg;
  reg [`AWIDTH-1:0] addr_pi_reg;
  always @(posedge clk) begin
    if (reset) begin
      enable_writing_to_mem_reg<= 0;
      addr_pi_reg <= 0;
    end else begin
      enable_writing_to_mem_reg<= enable_writing_to_mem;
      addr_pi_reg <= addr_pi;
    end
  end

  /////////////////////////////////////////////////////////////////
  // BRAMs to store matrix A
  /////////////////////////////////////////////////////////////////
  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  wire [`AWIDTH-1:0] a_addr_00;
  wire [`AWIDTH-1:0] a_addr_muxed_00;

  reg [`AWIDTH-1:0] a_addr_00_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_00_reg <= 0;
    end else begin
      a_addr_00_reg <= a_addr_00;
    end
  end

  reg [`AWIDTH-1:0] a_addr_muxed_00_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_muxed_00_reg <= 0;
    end else begin
      a_addr_muxed_00_reg<= a_addr_muxed_00;
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

  reg [`AWIDTH-1:0] a_addr_10_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_10_reg <= 0;
    end else begin
      a_addr_10_reg <= a_addr_10;
    end
  end

  reg [`AWIDTH-1:0] a_addr_muxed_10_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_muxed_10_reg <= 0;
    end else begin
      a_addr_muxed_10_reg<= a_addr_muxed_10;
    end
  end


  assign a_addr_muxed_10= (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_10_reg;

  // BRAM matrix A 10
  ram matrix_A_10 (
    .addr0(a_addr_muxed_10_reg),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_10), 
    .clk(clk));  

 wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20;
  wire [`AWIDTH-1:0] a_addr_20;
  wire [`AWIDTH-1:0] a_addr_muxed_20;

  reg [`AWIDTH-1:0] a_addr_20_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_20_reg <= 0;
    end else begin
      a_addr_20_reg <= a_addr_20;
    end
  end

  reg [`AWIDTH-1:0] a_addr_muxed_20_reg;
  always @(posedge clk) begin
    if (reset) begin
      a_addr_muxed_20_reg <= 0;
    end else begin
      a_addr_muxed_20_reg<= a_addr_muxed_20;
    end
  end

  assign a_addr_muxed_20= (enable_writing_to_mem_reg) ? addr_pi_reg : a_addr_20_reg;

  // BRAM matrix A 20
  ram matrix_A_20 (
    .addr0(a_addr_muxed_20_reg),
    .d0(data_pi), 
    .we0(we_a), 
    .q0(a_data_20), 
    .clk(clk));



  /////////////////////////////////////////////////////////////////
  // BRAMs to store matrix B
  /////////////////////////////////////////////////////////////////

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  wire [`AWIDTH-1:0] b_addr_00;
  wire [`AWIDTH-1:0] b_addr_muxed_00;

  reg [`AWIDTH-1:0] b_addr_00_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_00_reg <= 0;
    end else begin
      b_addr_00_reg <= b_addr_00;
    end
  end

  reg [`AWIDTH-1:0] b_addr_muxed_00_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_muxed_00_reg <= 0;
    end else begin
      b_addr_muxed_00_reg<= b_addr_muxed_00;
    end
  end

  assign b_addr_muxed_00= (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_00_reg;

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

  reg [`AWIDTH-1:0] b_addr_01_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_01_reg <= 0;
    end else begin
      b_addr_01_reg <= b_addr_01;
    end
  end

  reg [`AWIDTH-1:0] b_addr_muxed_01_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_muxed_01_reg <= 0;
    end else begin
      b_addr_muxed_01_reg<= b_addr_muxed_01;
    end
  end

  assign b_addr_muxed_01= (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_01_reg;

  // BRAM matrix B 01
  ram matrix_B_01 (
    .addr0(b_addr_muxed_01_reg),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_01), 
    .clk(clk));

  wire [`BB_MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02;
  wire [`AWIDTH-1:0] b_addr_02;
  wire [`AWIDTH-1:0] b_addr_muxed_02;

  reg [`AWIDTH-1:0] b_addr_02_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_02_reg <= 0;
    end else begin
      b_addr_02_reg <= b_addr_02;
    end
  end

  reg [`AWIDTH-1:0] b_addr_muxed_02_reg;
  always @(posedge clk) begin
    if (reset) begin
      b_addr_muxed_02_reg <= 0;
    end else begin
      b_addr_muxed_02_reg<= b_addr_muxed_02;
    end
  end

  assign b_addr_muxed_02= (enable_writing_to_mem_reg) ? addr_pi_reg : b_addr_02_reg;

  // BRAM matrix B 02
  ram matrix_B_02 (
    .addr0(b_addr_muxed_02_reg),
    .d0(data_pi), 
    .we0(we_b), 
    .q0(b_data_02), 
    .clk(clk));


  /////////////////////////////////////////////////////////////////


  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad1;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad2;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad3;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] data_from_out_mat_quad4;
  assign data_from_out_mat = data_from_out_mat_quad1 | data_from_out_mat_quad2 | data_from_out_mat_quad3 | data_from_out_mat_quad4;

  /////////////////////////////////////////////////////////////////
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

  reg [`AWIDTH-1:0] c_addr_muxed_quad1_reg;
  reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad1_reg;
  always @(posedge clk) begin
    if (reset) begin
      c_addr_muxed_quad1_reg <= 0;
      c_data_quad1_reg <= 0;
    end else begin
      c_addr_muxed_quad1_reg <= c_addr_muxed_quad1;
      c_data_quad1_reg <= c_data_quad1;
    end
  end

  // BRAM matrix C_quad1
  ram matrix_C_quad1 (
    .addr0(c_addr_muxed_quad1_reg),
    .d0(c_data_quad1_reg),
    .we0(we_c),
    .q0(data_from_out_mat_quad1),
    .clk(clk));


  wire [`AWIDTH-1:0] c_addr_02;
  wire [`AWIDTH-1:0] c_addr_12;
  wire [`AWIDTH-1:0] c_addr_muxed_quad2;
  assign c_addr_muxed_quad2 = (enable_reading_from_mem) ? addr_pi :  (c_addr_02|c_addr_12);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad2;
  assign c_data_quad2 = c_data_02 | c_data_12 ;

  reg [`AWIDTH-1:0] c_addr_muxed_quad2_reg;
  reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad2_reg;
  always @(posedge clk) begin
    if (reset) begin
      c_addr_muxed_quad2_reg <= 0;
      c_data_quad2_reg <= 0;
    end else begin
      c_addr_muxed_quad2_reg <= c_addr_muxed_quad2;
      c_data_quad2_reg <= c_data_quad2;
    end
  end

  // BRAM matrix C_quad2
  ram matrix_C_quad2 (
    .addr0(c_addr_muxed_quad2_reg),
    .d0(c_data_quad2_reg),
    .we0(we_c),
    .q0(data_from_out_mat_quad2),
    .clk(clk));



  wire [`AWIDTH-1:0] c_addr_20;
  wire [`AWIDTH-1:0] c_addr_21;
  wire [`AWIDTH-1:0] c_addr_muxed_quad3;
  assign c_addr_muxed_quad3 = (enable_reading_from_mem) ? addr_pi :  (c_addr_20|c_addr_21);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad3;
  assign c_data_quad3 = c_data_20 | c_data_21;

  reg [`AWIDTH-1:0] c_addr_muxed_quad3_reg;
  reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad3_reg;
  always @(posedge clk) begin
    if (reset) begin
      c_addr_muxed_quad3_reg <= 0;
      c_data_quad3_reg <= 0;
    end else begin
      c_addr_muxed_quad3_reg <= c_addr_muxed_quad3;
      c_data_quad3_reg <= c_data_quad3;
    end
  end

  // BRAM matrix C_quad3
  ram matrix_C_quad3 (
    .addr0(c_addr_muxed_quad3_reg),
    .d0(c_data_quad3_reg),
    .we0(we_c),
    .q0(data_from_out_mat_quad3),
    .clk(clk));



  wire [`AWIDTH-1:0] c_addr_22;
  wire [`AWIDTH-1:0] c_addr_muxed_quad4;
  assign c_addr_muxed_quad4 = (enable_reading_from_mem) ? addr_pi :  (c_addr_22);

  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;
  wire [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad4;
  assign c_data_quad4 = c_data_22;

  reg [`AWIDTH-1:0] c_addr_muxed_quad4_reg;
  reg [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_quad4_reg;
  always @(posedge clk) begin
    if (reset) begin
      c_addr_muxed_quad4_reg <= 0;
      c_data_quad4_reg <= 0;
    end else begin
      c_addr_muxed_quad4_reg <= c_addr_muxed_quad4;
      c_data_quad4_reg <= c_data_quad4;
    end
  end

  // BRAM matrix C_quad4
  ram matrix_C_quad4 (
    .addr0(c_addr_muxed_quad4_reg),
    .d0(c_data_quad4_reg),
    .we0(we_c),
    .q0(data_from_out_mat_quad4),
    .clk(clk));


  /////////////////////////////////////////////////////////////////

matmul_12x12_systolic u_matmul_12x12_systolic (
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul),
  .a_data_00(a_data_00),
  .a_data_10(a_data_10),
  .a_data_20(a_data_20),
  
  .b_data_00(b_data_00),
  .b_data_01(b_data_01),
  .b_data_02(b_data_02),
  
  .c_data_00(c_data_00),
  .c_data_01(c_data_01),
  .c_data_02(c_data_02),
  .c_data_10(c_data_10),
  .c_data_11(c_data_11),
  .c_data_12(c_data_12),
  .c_data_20(c_data_20),
  .c_data_21(c_data_21),
  .c_data_22(c_data_22),
  
  .a_addr_00(a_addr_00),
  .a_addr_10(a_addr_10),
  .a_addr_20(a_addr_20),
  
  .b_addr_00(b_addr_00),
  .b_addr_01(b_addr_01),
  .b_addr_02(b_addr_02),
  
  .c_addr_00(c_addr_00),
  .c_addr_01(c_addr_01),
  .c_addr_02(c_addr_02),
  .c_addr_10(c_addr_10),
  .c_addr_11(c_addr_11),
  .c_addr_12(c_addr_12),
  .c_addr_20(c_addr_20),
  .c_addr_21(c_addr_21),
  .c_addr_22(c_addr_22)

);
endmodule


module matmul_12x12_systolic(
  clk,
  reset,
  start_mat_mul,
  done_mat_mul,
  a_data_00,
  a_data_10,
  a_data_20,
  
  b_data_00,
  b_data_01,
  b_data_02,
  
  c_data_00,
  c_data_01,
  c_data_02,
  c_data_10,
  c_data_11,
  c_data_12,
  c_data_20,
  c_data_21,
  c_data_22,
  
  a_addr_00,
  a_addr_10,
  a_addr_20,
  
  b_addr_00,
  b_addr_01,
  b_addr_02,
  
  c_addr_00,
  c_addr_01,
  c_addr_02,
  c_addr_10,
  c_addr_11,
  c_addr_12,
  c_addr_20,
  c_addr_21,
  c_addr_22
);
  input clk;
  input reset;
  input start_mat_mul;
  output done_mat_mul;
  
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00;
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10;
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20;
                                             
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00;
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01;
  input [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02;
    
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_00;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_01;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_02;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_10;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_11;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_12;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_20;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_21;
  output [`MAT_MUL_SIZE*`DWIDTH-1:0] c_data_22;

  output [`AWIDTH-1:0] a_addr_00;
  output [`AWIDTH-1:0] a_addr_10;
  output [`AWIDTH-1:0] a_addr_20;
                                
  output [`AWIDTH-1:0] b_addr_00;
  output [`AWIDTH-1:0] b_addr_01;
  output [`AWIDTH-1:0] b_addr_02;

  output [`AWIDTH-1:0] c_addr_00;
  output [`AWIDTH-1:0] c_addr_01;
  output [`AWIDTH-1:0] c_addr_02;
  output [`AWIDTH-1:0] c_addr_10;
  output [`AWIDTH-1:0] c_addr_11;
  output [`AWIDTH-1:0] c_addr_12;
  output [`AWIDTH-1:0] c_addr_20;
  output [`AWIDTH-1:0] c_addr_21;
  output [`AWIDTH-1:0] c_addr_22;

  wire done_mat_mul_00;
  wire done_mat_mul_01;
  wire done_mat_mul_02;
  wire done_mat_mul_10;
  wire done_mat_mul_11;
  wire done_mat_mul_12;
  wire done_mat_mul_20;
  wire done_mat_mul_21;
  wire done_mat_mul_22;

  assign done_mat_mul = done_mat_mul_00 && 
                        done_mat_mul_01 && 
                        done_mat_mul_02 && 
                        done_mat_mul_10 &&
                        done_mat_mul_11 &&
                        done_mat_mul_12 &&
                        done_mat_mul_20 &&
                        done_mat_mul_21 &&
                        done_mat_mul_22;

  ///////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00_to_01;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00_to_10;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_00_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_00_NC;


matmul_4x4_systolic u_matmul_4x4_00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_00),
  .a_data(a_data_00),
  .b_data(b_data_00),
  .a_data_in(a_data_00_NC),
  .b_data_in(b_data_00_NC),
  .c_data(c_data_00),
  .a_data_out(a_data_00_to_01),
  .b_data_out(b_data_00_to_10),
  .a_addr(a_addr_00),
  .b_addr(b_addr_00),
  .c_addr(c_addr_00),
  .final_mat_mul_size(8'd12),
  .a_loc(8'd0),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_01_to_02;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_01_to_11;
 wire [`AWIDTH-1:0] a_addr_01_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_01_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_01_NC;

matmul_4x4_systolic u_matmul_4x4_01(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd0),
  .b_loc(8'd1)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_to_11;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_to_20;
 wire [`AWIDTH-1:0] b_addr_10_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_10_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_10_NC;

matmul_4x4_systolic u_matmul_4x4_10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(start_mat_mul),
  .done_mat_mul(done_mat_mul_10),
  .a_data(a_data_10),
  .b_data(b_data_10_NC),
  .a_data_in(a_data_10_NC),
  .b_data_in(b_data_00_to_10),
  .c_data(c_data_10),
  .a_data_out(a_data_10_to_11),
  .b_data_out(b_data_10_to_20),
  .a_addr(a_addr_10),
  .b_addr(b_addr_10_NC),
  .c_addr(c_addr_10),
  .final_mat_mul_size(8'd12),
  .a_loc(8'd1),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_to_12;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_to_21;
 wire [`AWIDTH-1:0] a_addr_11_NC;
 wire [`AWIDTH-1:0] b_addr_11_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_11_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_11_NC;

matmul_4x4_systolic u_matmul_4x4_11(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd1),
  .b_loc(8'd1)
);

  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_02_to_03;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_02_to_12;
 wire [`AWIDTH-1:0] a_addr_02_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_02_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_in_02_NC;


matmul_4x4_systolic u_matmul_4x4_02(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd0),
  .b_loc(8'd2)
);


 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_to_13;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_to_22;
 wire [`AWIDTH-1:0] b_addr_12_NC;
 wire [`AWIDTH-1:0] a_addr_12_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_12_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_12_NC;

matmul_4x4_systolic u_matmul_4x4_12(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd1),
  .b_loc(8'd2)
);


  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_20_to_21;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_20_to_30;
 wire [`AWIDTH-1:0] b_addr_20_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_in_20_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_20_NC;


matmul_4x4_systolic u_matmul_4x4_20(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd2),
  .b_loc(8'd0)
);

 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_21_to_22;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_21_to_31;
 wire [`AWIDTH-1:0] a_addr_21_NC;
 wire [`AWIDTH-1:0] b_addr_21_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_21_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_21_NC;

matmul_4x4_systolic u_matmul_4x4_21(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd2),
  .b_loc(8'd1)
);


  /////////////////////////////////////////////////////////////////
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_22_to_23;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_22_to_32;
 wire [`AWIDTH-1:0] a_addr_22_NC;
 wire [`AWIDTH-1:0] b_addr_22_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] a_data_22_NC;
 wire [`MAT_MUL_SIZE*`DWIDTH-1:0] b_data_22_NC;


matmul_4x4_systolic u_matmul_4x4_22(
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
  .final_mat_mul_size(8'd12),
  .a_loc(8'd2),
  .b_loc(8'd2)
);


endmodule  


/*
module matmul_4x4_systolic(
 clk,
 reset,
 start_mat_mul,
 done_mat_mul,
 a_data,
 b_data,
 a_data_in, //Data values coming in from previous matmul - systolic connections
 b_data_in,
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
 input [4*`DWIDTH-1:0] a_data;
 input [4*`DWIDTH-1:0] b_data;
 input [4*`DWIDTH-1:0] a_data_in;
 input [4*`DWIDTH-1:0] b_data_in;
 output [4*`DWIDTH-1:0] c_data;
 output [4*`DWIDTH-1:0] a_data_out;
 output [4*`DWIDTH-1:0] b_data_out;
 output [`AWIDTH-1:0] a_addr;
 output [`AWIDTH-1:0] b_addr;
 output [`AWIDTH-1:0] c_addr;
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

assign a_data_out = {a33to34,a23to24,a13to14,a03to04};
assign b_data_out = {b33to43,b32to42,b31to41,b30to40};


//Reduce precision
wire [`DWIDTH-1:0] matrixC00_rp;
wire [`DWIDTH-1:0] matrixC01_rp;
wire [`DWIDTH-1:0] matrixC02_rp;
wire [`DWIDTH-1:0] matrixC03_rp;
wire [`DWIDTH-1:0] matrixC10_rp;
wire [`DWIDTH-1:0] matrixC11_rp;
wire [`DWIDTH-1:0] matrixC12_rp;
wire [`DWIDTH-1:0] matrixC13_rp;
wire [`DWIDTH-1:0] matrixC20_rp;
wire [`DWIDTH-1:0] matrixC21_rp;
wire [`DWIDTH-1:0] matrixC22_rp;
wire [`DWIDTH-1:0] matrixC23_rp;
wire [`DWIDTH-1:0] matrixC30_rp;
wire [`DWIDTH-1:0] matrixC31_rp;
wire [`DWIDTH-1:0] matrixC32_rp;
wire [`DWIDTH-1:0] matrixC33_rp;

assign matrixC00_rp = (|matrixC00[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC00[`DWIDTH-1:0];
assign matrixC01_rp = (|matrixC01[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC01[`DWIDTH-1:0];
assign matrixC02_rp = (|matrixC02[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC02[`DWIDTH-1:0];
assign matrixC03_rp = (|matrixC03[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC03[`DWIDTH-1:0];
assign matrixC10_rp = (|matrixC10[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC10[`DWIDTH-1:0];
assign matrixC11_rp = (|matrixC11[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC11[`DWIDTH-1:0];
assign matrixC12_rp = (|matrixC12[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC12[`DWIDTH-1:0];
assign matrixC13_rp = (|matrixC13[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC13[`DWIDTH-1:0];
assign matrixC20_rp = (|matrixC20[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC20[`DWIDTH-1:0];
assign matrixC21_rp = (|matrixC21[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC21[`DWIDTH-1:0];
assign matrixC22_rp = (|matrixC22[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC22[`DWIDTH-1:0];
assign matrixC23_rp = (|matrixC23[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC23[`DWIDTH-1:0];
assign matrixC30_rp = (|matrixC30[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC30[`DWIDTH-1:0];
assign matrixC31_rp = (|matrixC31[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC31[`DWIDTH-1:0];
assign matrixC32_rp = (|matrixC32[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC32[`DWIDTH-1:0];
assign matrixC33_rp = (|matrixC33[2*`DWIDTH-1:`DWIDTH] == 1'b1) ? {`DWIDTH{1'b1}} : matrixC33[`DWIDTH-1:0];

//Output logic
reg [`AWIDTH-1:0] c_addr;
reg [4*`DWIDTH-1:0] c_data;
always @(posedge clk) begin
  if (reset || ~start_mat_mul) begin
    c_addr <= `MEM_SIZE-1;//b_loc*16;
  end
  else if (done_mat_mul) begin
    c_addr <= `MEM_SIZE-1;
  end
  else if (clk_cnt > b_loc*`MAT_MUL_SIZE+final_mat_mul_size) begin
    c_addr <= c_addr + 1;
    if(c_addr == 0) begin
        c_data <= {16'b0, 16'b0, 16'b0, matrixC00_rp};
    end 
    else if (c_addr == 1) begin
        c_data <= {16'b0, 16'b0, matrixC10_rp, matrixC01_rp};
    end 
    else if (c_addr == 2) begin
        c_data <= {16'b0, matrixC20_rp, matrixC11_rp, matrixC02_rp};
    end 
    else if (c_addr == 3) begin
        c_data <= {matrixC30_rp, matrixC21_rp, matrixC12_rp, matrixC03_rp};
    end 
    else if (c_addr == 4) begin
        c_data <= {matrixC31_rp, matrixC22_rp, matrixC13_rp, 16'b0};
    end 
    else if (c_addr == 5) begin
        c_data <= {matrixC32_rp, matrixC23_rp, 16'b0, 16'b0};
    end 
    else if (c_addr == 6) begin
        c_data <= {matrixC33_rp, 16'b0, 16'b0, 16'b0};
    end
  end
end  

endmodule



module processing_element(reset, clk, in_a,in_b,out_a,out_b,out_c);

 input reset,clk;
 input  [`DWIDTH-1:0] in_a,in_b;
 output [2*`DWIDTH-1:0] out_c;
 output [`DWIDTH-1:0] out_a,out_b;

 reg [2*`DWIDTH-1:0] out_c;
 reg [`DWIDTH-1:0] out_a,out_b;

 wire [2*`DWIDTH-1:0] out_mac;

 
 //mac u_mac(in_a, in_b, out_c, out_mac);
 mac_block u_mac(.a(in_a), .b(in_b), .c(out_c), .out(out_mac));

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
*/
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
//multiply u_mult(.a(i_multiplicand), .b(i_multiplier), .out(o_result));
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

