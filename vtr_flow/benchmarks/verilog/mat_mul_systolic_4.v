
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 5
`define MEM_SIZE 32

module matrix_multiplication(
  clk, 
  reset, 
  we1, 
  we2, 
  enable_writing_to_mem, 
  data_pi,
  addr_pi, 
  out_sel, 
  data_out, 
  done_mat_mul
);

  input clk;
  input reset;
  input we1;  
  input we2;  
  input enable_writing_to_mem;
  input [`DWIDTH-1:0] data_pi;
  input [`AWIDTH-1:0] addr_pi;
  input [`AWIDTH-1:0] out_sel;
  output [2*`DWIDTH-1:0] data_out;  
  output done_mat_mul;

  wire done_reading_mem;
  wire [`DWIDTH-1:0] matrixA00;
  wire [`DWIDTH-1:0] matrixA01;
  wire [`DWIDTH-1:0] matrixA02;
  wire [`DWIDTH-1:0] matrixA03;
  wire [`DWIDTH-1:0] matrixA10;
  wire [`DWIDTH-1:0] matrixA11;
  wire [`DWIDTH-1:0] matrixA12;
  wire [`DWIDTH-1:0] matrixA13;
  wire [`DWIDTH-1:0] matrixA20;
  wire [`DWIDTH-1:0] matrixA21;
  wire [`DWIDTH-1:0] matrixA22;
  wire [`DWIDTH-1:0] matrixA23;
  wire [`DWIDTH-1:0] matrixA30;
  wire [`DWIDTH-1:0] matrixA31;
  wire [`DWIDTH-1:0] matrixA32;
  wire [`DWIDTH-1:0] matrixA33;
  wire [`DWIDTH-1:0] matrixB00;
  wire [`DWIDTH-1:0] matrixB01;
  wire [`DWIDTH-1:0] matrixB02;
  wire [`DWIDTH-1:0] matrixB03;
  wire [`DWIDTH-1:0] matrixB10;
  wire [`DWIDTH-1:0] matrixB11;
  wire [`DWIDTH-1:0] matrixB12;
  wire [`DWIDTH-1:0] matrixB13;
  wire [`DWIDTH-1:0] matrixB20;
  wire [`DWIDTH-1:0] matrixB21;
  wire [`DWIDTH-1:0] matrixB22;
  wire [`DWIDTH-1:0] matrixB23;
  wire [`DWIDTH-1:0] matrixB30;
  wire [`DWIDTH-1:0] matrixB31;
  wire [`DWIDTH-1:0] matrixB32;
  wire [`DWIDTH-1:0] matrixB33;
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

  load_and_retrieve_inputs u_load_and_retrieve_inputs(
  .clk(clk), 
  .reset(reset), 
  .we1(we1), 
  .we2(we2), 
  .enable_writing_to_mem(enable_writing_to_mem), 
  .data_pi(data_pi), 
  .addr_pi(addr_pi), 
  .done_reading_mem(done_reading_mem),
  .matrixA00(matrixA00),
  .matrixA01(matrixA01),
  .matrixA02(matrixA02),
  .matrixA03(matrixA03),
  .matrixA10(matrixA10),
  .matrixA11(matrixA11),
  .matrixA12(matrixA12),
  .matrixA13(matrixA13),
  .matrixA20(matrixA20),
  .matrixA21(matrixA21),
  .matrixA22(matrixA22),
  .matrixA23(matrixA23),
  .matrixA30(matrixA30),
  .matrixA31(matrixA31),
  .matrixA32(matrixA32),
  .matrixA33(matrixA33),
  .matrixB00(matrixB00),
  .matrixB01(matrixB01),
  .matrixB02(matrixB02),
  .matrixB03(matrixB03),
  .matrixB10(matrixB10),
  .matrixB11(matrixB11),
  .matrixB12(matrixB12),
  .matrixB13(matrixB13),
  .matrixB20(matrixB20),
  .matrixB21(matrixB21),
  .matrixB22(matrixB22),
  .matrixB23(matrixB23),
  .matrixB30(matrixB30),
  .matrixB31(matrixB31),
  .matrixB32(matrixB32),
  .matrixB33(matrixB33)
  );
  
  matmul_4x4_systolic u_matmul_4x4_systolic(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(done_mat_mul),
  .matrixA00(matrixA00),
  .matrixA01(matrixA01),
  .matrixA02(matrixA02),
  .matrixA03(matrixA03),
  .matrixA10(matrixA10),
  .matrixA11(matrixA11),
  .matrixA12(matrixA12),
  .matrixA13(matrixA13),
  .matrixA20(matrixA20),
  .matrixA21(matrixA21),
  .matrixA22(matrixA22),
  .matrixA23(matrixA23),
  .matrixA30(matrixA30),
  .matrixA31(matrixA31),
  .matrixA32(matrixA32),
  .matrixA33(matrixA33),
  .matrixB00(matrixB00),
  .matrixB01(matrixB01),
  .matrixB02(matrixB02),
  .matrixB03(matrixB03),
  .matrixB10(matrixB10),
  .matrixB11(matrixB11),
  .matrixB12(matrixB12),
  .matrixB13(matrixB13),
  .matrixB20(matrixB20),
  .matrixB21(matrixB21),
  .matrixB22(matrixB22),
  .matrixB23(matrixB23),
  .matrixB30(matrixB30),
  .matrixB31(matrixB31),
  .matrixB32(matrixB32),
  .matrixB33(matrixB33),
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
  .matrixC33(matrixC33)
  );

  read_outputs u_read_outputs(
  .clk(clk),
  .reset(reset),
  .done_mat_mul(done_mat_mul),
  .out_sel(out_sel),
  .data_out(data_out),
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
  .matrixC33(matrixC33)
  );

endmodule


module load_and_retrieve_inputs(
 clk, 
 reset, 
 we1, 
 we2, 
 enable_writing_to_mem, 
 data_pi, 
 addr_pi, 
 done_reading_mem,
 matrixA00,
 matrixA01,
 matrixA02,
 matrixA03,
 matrixA10,
 matrixA11,
 matrixA12,
 matrixA13,
 matrixA20,
 matrixA21,
 matrixA22,
 matrixA23,
 matrixA30,
 matrixA31,
 matrixA32,
 matrixA33,
 matrixB00,
 matrixB01,
 matrixB02,
 matrixB03,
 matrixB10,
 matrixB11,
 matrixB12,
 matrixB13,
 matrixB20,
 matrixB21,
 matrixB22,
 matrixB23,
 matrixB30,
 matrixB31,
 matrixB32,
 matrixB33
);

 input clk;
 input reset;
 input we1;  
 input we2;  
 input enable_writing_to_mem;
 input [`DWIDTH-1:0] data_pi;
 input [`AWIDTH-1:0] addr_pi;
 output done_reading_mem;
 output [`DWIDTH-1:0] matrixA00;
 output [`DWIDTH-1:0] matrixA01;
 output [`DWIDTH-1:0] matrixA02;
 output [`DWIDTH-1:0] matrixA03;
 output [`DWIDTH-1:0] matrixA10;
 output [`DWIDTH-1:0] matrixA11;
 output [`DWIDTH-1:0] matrixA12;
 output [`DWIDTH-1:0] matrixA13;
 output [`DWIDTH-1:0] matrixA20;
 output [`DWIDTH-1:0] matrixA21;
 output [`DWIDTH-1:0] matrixA22;
 output [`DWIDTH-1:0] matrixA23;
 output [`DWIDTH-1:0] matrixA30;
 output [`DWIDTH-1:0] matrixA31;
 output [`DWIDTH-1:0] matrixA32;
 output [`DWIDTH-1:0] matrixA33;
 output [`DWIDTH-1:0] matrixB00;
 output [`DWIDTH-1:0] matrixB01;
 output [`DWIDTH-1:0] matrixB02;
 output [`DWIDTH-1:0] matrixB03;
 output [`DWIDTH-1:0] matrixB10;
 output [`DWIDTH-1:0] matrixB11;
 output [`DWIDTH-1:0] matrixB12;
 output [`DWIDTH-1:0] matrixB13;
 output [`DWIDTH-1:0] matrixB20;
 output [`DWIDTH-1:0] matrixB21;
 output [`DWIDTH-1:0] matrixB22;
 output [`DWIDTH-1:0] matrixB23;
 output [`DWIDTH-1:0] matrixB30;
 output [`DWIDTH-1:0] matrixB31;
 output [`DWIDTH-1:0] matrixB32;
 output [`DWIDTH-1:0] matrixB33;

  
 reg [`DWIDTH-1:0] matrixA00;
 reg [`DWIDTH-1:0] matrixA01;
 reg [`DWIDTH-1:0] matrixA02;
 reg [`DWIDTH-1:0] matrixA03;
 reg [`DWIDTH-1:0] matrixA10;
 reg [`DWIDTH-1:0] matrixA11;
 reg [`DWIDTH-1:0] matrixA12;
 reg [`DWIDTH-1:0] matrixA13;
 reg [`DWIDTH-1:0] matrixA20;
 reg [`DWIDTH-1:0] matrixA21;
 reg [`DWIDTH-1:0] matrixA22;
 reg [`DWIDTH-1:0] matrixA23;
 reg [`DWIDTH-1:0] matrixA30;
 reg [`DWIDTH-1:0] matrixA31;
 reg [`DWIDTH-1:0] matrixA32;
 reg [`DWIDTH-1:0] matrixA33;
 reg [`DWIDTH-1:0] matrixB00;
 reg [`DWIDTH-1:0] matrixB01;
 reg [`DWIDTH-1:0] matrixB02;
 reg [`DWIDTH-1:0] matrixB03;
 reg [`DWIDTH-1:0] matrixB10;
 reg [`DWIDTH-1:0] matrixB11;
 reg [`DWIDTH-1:0] matrixB12;
 reg [`DWIDTH-1:0] matrixB13;
 reg [`DWIDTH-1:0] matrixB20;
 reg [`DWIDTH-1:0] matrixB21;
 reg [`DWIDTH-1:0] matrixB22;
 reg [`DWIDTH-1:0] matrixB23;
 reg [`DWIDTH-1:0] matrixB30;
 reg [`DWIDTH-1:0] matrixB31;
 reg [`DWIDTH-1:0] matrixB32;
 reg [`DWIDTH-1:0] matrixB33;
 wire [`DWIDTH-1:0] mat_A;
 wire [`DWIDTH-1:0] mat_B;
 wire [`AWIDTH-1:0] addr_mem;
 reg [`AWIDTH-1:0] addr_internal;
 wire we1_mem;
 wire we2_mem;

  // BRAM matrix A  
  ram matrix_A_u (
    .addr0(addr_mem),
    .d0(data_pi), 
    .we0(we1_mem), 
    .q0(mat_A), 
    .clk(clk));
  
  // BRAM matrix B  
  ram matrix_B_u(
    .addr0(addr_mem),
    .d0(data_pi), 
    .we0(we2_mem), 
    .q0(mat_B), 
    .clk(clk));
  
  assign addr_mem = (enable_writing_to_mem) ? addr_pi : addr_internal;
  assign we1_mem  = (enable_writing_to_mem) ? we1 : 1'b0;
  assign we2_mem  = (enable_writing_to_mem) ? we2 : 1'b0;

  reg done_reading_mem;
          
  always @(posedge clk)  
  begin  
    if(reset) begin  
       addr_internal <= 0;  
       done_reading_mem <= 1'b0;
    end  
    else if (!enable_writing_to_mem) begin
      if(addr_internal<17) begin  
        addr_internal <= addr_internal + 1;
        done_reading_mem <= 1'b0;
      end else begin
        done_reading_mem <= 1'b1;
      end   
    end
  end  

  always @(posedge clk)
  begin
    if(!reset) begin  
    	case(addr_internal) 
            1 : begin matrixA00 <= mat_A; matrixB00 <= mat_B;end
            2 : begin matrixA01 <= mat_A; matrixB01 <= mat_B;end
            3 : begin matrixA02 <= mat_A; matrixB02 <= mat_B;end
            4 : begin matrixA03 <= mat_A; matrixB03 <= mat_B;end
            5 : begin matrixA10 <= mat_A; matrixB10 <= mat_B;end
            6 : begin matrixA11 <= mat_A; matrixB11 <= mat_B;end
            7 : begin matrixA12 <= mat_A; matrixB12 <= mat_B;end
            8 : begin matrixA13 <= mat_A; matrixB13 <= mat_B;end
            9 : begin matrixA20 <= mat_A; matrixB20 <= mat_B;end
           10 : begin matrixA21 <= mat_A; matrixB21 <= mat_B;end
           11 : begin matrixA22 <= mat_A; matrixB22 <= mat_B;end
           12 : begin matrixA23 <= mat_A; matrixB23 <= mat_B;end
           13 : begin matrixA30 <= mat_A; matrixB30 <= mat_B;end
           14 : begin matrixA31 <= mat_A; matrixB31 <= mat_B;end
           15 : begin matrixA32 <= mat_A; matrixB32 <= mat_B;end
           16 : begin matrixA33 <= mat_A; matrixB33 <= mat_B;end
           default: begin matrixA33 <= mat_A; matrixB33 <= mat_B; end
    	endcase
    end
  end
  
endmodule

module read_outputs(
  clk,
  reset,
  done_mat_mul,
  out_sel,
  data_out,
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
  matrixC33
);

  input clk;
  input reset;
  input done_mat_mul;
  input [`AWIDTH-1:0] out_sel;
  input [2*`DWIDTH-1:0] data_out;  
  input [2*`DWIDTH-1:0] matrixC00;
  input [2*`DWIDTH-1:0] matrixC01;
  input [2*`DWIDTH-1:0] matrixC02;
  input [2*`DWIDTH-1:0] matrixC03;
  input [2*`DWIDTH-1:0] matrixC10;
  input [2*`DWIDTH-1:0] matrixC11;
  input [2*`DWIDTH-1:0] matrixC12;
  input [2*`DWIDTH-1:0] matrixC13;
  input [2*`DWIDTH-1:0] matrixC20;
  input [2*`DWIDTH-1:0] matrixC21;
  input [2*`DWIDTH-1:0] matrixC22;
  input [2*`DWIDTH-1:0] matrixC23;
  input [2*`DWIDTH-1:0] matrixC30;
  input [2*`DWIDTH-1:0] matrixC31;
  input [2*`DWIDTH-1:0] matrixC32;
  input [2*`DWIDTH-1:0] matrixC33;

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
 matrixA00,
 matrixA01,
 matrixA02,
 matrixA03,
 matrixA10,
 matrixA11,
 matrixA12,
 matrixA13,
 matrixA20,
 matrixA21,
 matrixA22,
 matrixA23,
 matrixA30,
 matrixA31,
 matrixA32,
 matrixA33,
 matrixB00,
 matrixB01,
 matrixB02,
 matrixB03,
 matrixB10,
 matrixB11,
 matrixB12,
 matrixB13,
 matrixB20,
 matrixB21,
 matrixB22,
 matrixB23,
 matrixB30,
 matrixB31,
 matrixB32,
 matrixB33,
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
 matrixC33
);

 input clk;
 input reset;
 input start_mat_mul;
 output done_mat_mul;
 input [`DWIDTH-1:0] matrixA00;
 input [`DWIDTH-1:0] matrixA01;
 input [`DWIDTH-1:0] matrixA02;
 input [`DWIDTH-1:0] matrixA03;
 input [`DWIDTH-1:0] matrixA10;
 input [`DWIDTH-1:0] matrixA11;
 input [`DWIDTH-1:0] matrixA12;
 input [`DWIDTH-1:0] matrixA13;
 input [`DWIDTH-1:0] matrixA20;
 input [`DWIDTH-1:0] matrixA21;
 input [`DWIDTH-1:0] matrixA22;
 input [`DWIDTH-1:0] matrixA23;
 input [`DWIDTH-1:0] matrixA30;
 input [`DWIDTH-1:0] matrixA31;
 input [`DWIDTH-1:0] matrixA32;
 input [`DWIDTH-1:0] matrixA33;
 input [`DWIDTH-1:0] matrixB00;
 input [`DWIDTH-1:0] matrixB01;
 input [`DWIDTH-1:0] matrixB02;
 input [`DWIDTH-1:0] matrixB03;
 input [`DWIDTH-1:0] matrixB10;
 input [`DWIDTH-1:0] matrixB11;
 input [`DWIDTH-1:0] matrixB12;
 input [`DWIDTH-1:0] matrixB13;
 input [`DWIDTH-1:0] matrixB20;
 input [`DWIDTH-1:0] matrixB21;
 input [`DWIDTH-1:0] matrixB22;
 input [`DWIDTH-1:0] matrixB23;
 input [`DWIDTH-1:0] matrixB30;
 input [`DWIDTH-1:0] matrixB31;
 input [`DWIDTH-1:0] matrixB32;
 input [`DWIDTH-1:0] matrixB33;
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

reg [`DWIDTH-1:0] a0, a1, a2, a3;
reg [`DWIDTH-1:0] b0, b1, b2, b3;

reg [3:0] clk_cnt;
reg done_mat_mul;

always @(posedge clk) begin
  if (reset || ~start_mat_mul) begin
    done_mat_mul <= 0;
    clk_cnt <= 0;
    a0 <= 0;         b0 <= 0;        
    a1 <= 0;         b1 <= 0;        
    a2 <= 0;         b2 <= 0;        
    a3 <= 0;         b3 <= 0;
  end
  else if (clk_cnt == 11) begin
    done_mat_mul <= 1;
  end
  else begin
    clk_cnt <= clk_cnt + 1;
    if (clk_cnt == 1) begin
      a0 <= matrixA00; b0 <= matrixB00;
      a1 <= 0;         b1 <= 0;
      a2 <= 0;         b2 <= 0;
      a3 <= 0;         b3 <= 0;
    end 
    else if (clk_cnt == 2) begin
      a0 <= matrixA01; b0 <= matrixB10;
      a1 <= matrixA10; b1 <= matrixB01;
      a2 <= 0;         b2 <= 0;
      a3 <= 0;         b3 <= 0;
    end
    else if (clk_cnt == 3) begin
      a0 <= matrixA02; b0 <= matrixB20;
      a1 <= matrixA11; b1 <= matrixB11;
      a2 <= matrixA20; b2 <= matrixB02;
      a3 <= 0;         b3 <= 0;
    end
    else if (clk_cnt == 4) begin
      a0 <= matrixA03; b0 <= matrixB30;        
      a1 <= matrixA12; b1 <= matrixB21;
      a2 <= matrixA21; b2 <= matrixB12;
      a3 <= matrixA30; b3 <= matrixB03;
    end
    else if (clk_cnt == 5) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= matrixA13; b1 <= matrixB31;        
      a2 <= matrixA22; b2 <= matrixB22;
      a3 <= matrixA31; b3 <= matrixB13;
    end
    else if (clk_cnt == 6) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= matrixA23; b2 <= matrixB32;        
      a3 <= matrixA32; b3 <= matrixB23;
    end
    else if (clk_cnt == 7) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= matrixA33; b3 <= matrixB33;
    end
    else if (clk_cnt == 8) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
    end
    else if (clk_cnt == 9) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
    end
    else if (clk_cnt == 10) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
    end
  end
end


wire [`DWIDTH-1:0] a00to01, a01to02, a02to03, a03to04;
wire [`DWIDTH-1:0] a10to11, a11to12, a12to13, a13to14;
wire [`DWIDTH-1:0] a20to21, a21to22, a22to23, a23to24;
wire [`DWIDTH-1:0] a30to31, a31to32, a32to33, a33to34;
wire [`DWIDTH-1:0] b00to10, b10to20, b20to30, b30to40; 
wire [`DWIDTH-1:0] b01to11, b11to21, b21to31, b31to41;
wire [`DWIDTH-1:0] b02to12, b12to22, b22to32, b32to42;
wire [`DWIDTH-1:0] b03to13, b13to23, b23to33, b33to43;


processing_element pe00(.reset(reset), .clk(clk), .in_a(a0),      .in_b(b0),      .out_a(a00to01), .out_b(b00to10), .out_c(matrixC00));
processing_element pe01(.reset(reset), .clk(clk), .in_a(a00to01), .in_b(b1),      .out_a(a01to02), .out_b(b01to11), .out_c(matrixC01));
processing_element pe02(.reset(reset), .clk(clk), .in_a(a01to02), .in_b(b2),      .out_a(a02to03), .out_b(b02to12), .out_c(matrixC02));
processing_element pe03(.reset(reset), .clk(clk), .in_a(a02to03), .in_b(b3),      .out_a(a03to04), .out_b(b03to13), .out_c(matrixC03));

processing_element pe10(.reset(reset), .clk(clk), .in_a(a1),      .in_b(b00to10), .out_a(a10to11), .out_b(b10to20), .out_c(matrixC10));
processing_element pe11(.reset(reset), .clk(clk), .in_a(a10to11), .in_b(b01to11), .out_a(a11to12), .out_b(b11to21), .out_c(matrixC11));
processing_element pe12(.reset(reset), .clk(clk), .in_a(a11to12), .in_b(b02to12), .out_a(a12to13), .out_b(b12to22), .out_c(matrixC12));
processing_element pe13(.reset(reset), .clk(clk), .in_a(a12to13), .in_b(b03to13), .out_a(a13to14), .out_b(b13to23), .out_c(matrixC13));

processing_element pe20(.reset(reset), .clk(clk), .in_a(a2),      .in_b(b10to20), .out_a(a20to21), .out_b(b20to30), .out_c(matrixC20));
processing_element pe21(.reset(reset), .clk(clk), .in_a(a20to21), .in_b(b11to21), .out_a(a21to22), .out_b(b21to31), .out_c(matrixC21));
processing_element pe22(.reset(reset), .clk(clk), .in_a(a21to22), .in_b(b12to22), .out_a(a22to23), .out_b(b22to32), .out_c(matrixC22));
processing_element pe23(.reset(reset), .clk(clk), .in_a(a22to23), .in_b(b13to23), .out_a(a23to24), .out_b(b23to33), .out_c(matrixC23));

processing_element pe30(.reset(reset), .clk(clk), .in_a(a3),      .in_b(b20to30), .out_a(a30to31), .out_b(b30to40), .out_c(matrixC30));
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
input [`DWIDTH-1:0] d0;
input we0;
output [`DWIDTH-1:0] q0;
input clk;

reg [`DWIDTH-1:0] q0;
reg [`DWIDTH-1:0] ram[`MEM_SIZE-1:0];

always @(posedge clk)  
begin 
        if (we0) 
        begin 
            ram[addr0] <= d0; 
        end 
        q0 <= ram[addr0];
end

endmodule

