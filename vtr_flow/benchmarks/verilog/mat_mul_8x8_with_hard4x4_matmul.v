`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128

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

  reg [`DWIDTH-1:0] A00_matrixA00;
  reg [`DWIDTH-1:0] A00_matrixA01;
  reg [`DWIDTH-1:0] A00_matrixA02;
  reg [`DWIDTH-1:0] A00_matrixA03;
  reg [`DWIDTH-1:0] A00_matrixA10;
  reg [`DWIDTH-1:0] A00_matrixA11;
  reg [`DWIDTH-1:0] A00_matrixA12;
  reg [`DWIDTH-1:0] A00_matrixA13;
  reg [`DWIDTH-1:0] A00_matrixA20;
  reg [`DWIDTH-1:0] A00_matrixA21;
  reg [`DWIDTH-1:0] A00_matrixA22;
  reg [`DWIDTH-1:0] A00_matrixA23;
  reg [`DWIDTH-1:0] A00_matrixA30;
  reg [`DWIDTH-1:0] A00_matrixA31;
  reg [`DWIDTH-1:0] A00_matrixA32;
  reg [`DWIDTH-1:0] A00_matrixA33;

  reg [`DWIDTH-1:0] A01_matrixA00;
  reg [`DWIDTH-1:0] A01_matrixA01;
  reg [`DWIDTH-1:0] A01_matrixA02;
  reg [`DWIDTH-1:0] A01_matrixA03;
  reg [`DWIDTH-1:0] A01_matrixA10;
  reg [`DWIDTH-1:0] A01_matrixA11;
  reg [`DWIDTH-1:0] A01_matrixA12;
  reg [`DWIDTH-1:0] A01_matrixA13;
  reg [`DWIDTH-1:0] A01_matrixA20;
  reg [`DWIDTH-1:0] A01_matrixA21;
  reg [`DWIDTH-1:0] A01_matrixA22;
  reg [`DWIDTH-1:0] A01_matrixA23;
  reg [`DWIDTH-1:0] A01_matrixA30;
  reg [`DWIDTH-1:0] A01_matrixA31;
  reg [`DWIDTH-1:0] A01_matrixA32;
  reg [`DWIDTH-1:0] A01_matrixA33;

  reg [`DWIDTH-1:0] A10_matrixA00;
  reg [`DWIDTH-1:0] A10_matrixA01;
  reg [`DWIDTH-1:0] A10_matrixA02;
  reg [`DWIDTH-1:0] A10_matrixA03;
  reg [`DWIDTH-1:0] A10_matrixA10;
  reg [`DWIDTH-1:0] A10_matrixA11;
  reg [`DWIDTH-1:0] A10_matrixA12;
  reg [`DWIDTH-1:0] A10_matrixA13;
  reg [`DWIDTH-1:0] A10_matrixA20;
  reg [`DWIDTH-1:0] A10_matrixA21;
  reg [`DWIDTH-1:0] A10_matrixA22;
  reg [`DWIDTH-1:0] A10_matrixA23;
  reg [`DWIDTH-1:0] A10_matrixA30;
  reg [`DWIDTH-1:0] A10_matrixA31;
  reg [`DWIDTH-1:0] A10_matrixA32;
  reg [`DWIDTH-1:0] A10_matrixA33;

  reg [`DWIDTH-1:0] A11_matrixA00;
  reg [`DWIDTH-1:0] A11_matrixA01;
  reg [`DWIDTH-1:0] A11_matrixA02;
  reg [`DWIDTH-1:0] A11_matrixA03;
  reg [`DWIDTH-1:0] A11_matrixA10;
  reg [`DWIDTH-1:0] A11_matrixA11;
  reg [`DWIDTH-1:0] A11_matrixA12;
  reg [`DWIDTH-1:0] A11_matrixA13;
  reg [`DWIDTH-1:0] A11_matrixA20;
  reg [`DWIDTH-1:0] A11_matrixA21;
  reg [`DWIDTH-1:0] A11_matrixA22;
  reg [`DWIDTH-1:0] A11_matrixA23;
  reg [`DWIDTH-1:0] A11_matrixA30;
  reg [`DWIDTH-1:0] A11_matrixA31;
  reg [`DWIDTH-1:0] A11_matrixA32;
  reg [`DWIDTH-1:0] A11_matrixA33;

  reg [`DWIDTH-1:0] B00_matrixB00;
  reg [`DWIDTH-1:0] B00_matrixB01;
  reg [`DWIDTH-1:0] B00_matrixB02;
  reg [`DWIDTH-1:0] B00_matrixB03;
  reg [`DWIDTH-1:0] B00_matrixB10;
  reg [`DWIDTH-1:0] B00_matrixB11;
  reg [`DWIDTH-1:0] B00_matrixB12;
  reg [`DWIDTH-1:0] B00_matrixB13;
  reg [`DWIDTH-1:0] B00_matrixB20;
  reg [`DWIDTH-1:0] B00_matrixB21;
  reg [`DWIDTH-1:0] B00_matrixB22;
  reg [`DWIDTH-1:0] B00_matrixB23;
  reg [`DWIDTH-1:0] B00_matrixB30;
  reg [`DWIDTH-1:0] B00_matrixB31;
  reg [`DWIDTH-1:0] B00_matrixB32;
  reg [`DWIDTH-1:0] B00_matrixB33;

  reg [`DWIDTH-1:0] B01_matrixB00;
  reg [`DWIDTH-1:0] B01_matrixB01;
  reg [`DWIDTH-1:0] B01_matrixB02;
  reg [`DWIDTH-1:0] B01_matrixB03;
  reg [`DWIDTH-1:0] B01_matrixB10;
  reg [`DWIDTH-1:0] B01_matrixB11;
  reg [`DWIDTH-1:0] B01_matrixB12;
  reg [`DWIDTH-1:0] B01_matrixB13;
  reg [`DWIDTH-1:0] B01_matrixB20;
  reg [`DWIDTH-1:0] B01_matrixB21;
  reg [`DWIDTH-1:0] B01_matrixB22;
  reg [`DWIDTH-1:0] B01_matrixB23;
  reg [`DWIDTH-1:0] B01_matrixB30;
  reg [`DWIDTH-1:0] B01_matrixB31;
  reg [`DWIDTH-1:0] B01_matrixB32;
  reg [`DWIDTH-1:0] B01_matrixB33;

  reg [`DWIDTH-1:0] B10_matrixB00;
  reg [`DWIDTH-1:0] B10_matrixB01;
  reg [`DWIDTH-1:0] B10_matrixB02;
  reg [`DWIDTH-1:0] B10_matrixB03;
  reg [`DWIDTH-1:0] B10_matrixB10;
  reg [`DWIDTH-1:0] B10_matrixB11;
  reg [`DWIDTH-1:0] B10_matrixB12;
  reg [`DWIDTH-1:0] B10_matrixB13;
  reg [`DWIDTH-1:0] B10_matrixB20;
  reg [`DWIDTH-1:0] B10_matrixB21;
  reg [`DWIDTH-1:0] B10_matrixB22;
  reg [`DWIDTH-1:0] B10_matrixB23;
  reg [`DWIDTH-1:0] B10_matrixB30;
  reg [`DWIDTH-1:0] B10_matrixB31;
  reg [`DWIDTH-1:0] B10_matrixB32;
  reg [`DWIDTH-1:0] B10_matrixB33;

  reg [`DWIDTH-1:0] B11_matrixB00;
  reg [`DWIDTH-1:0] B11_matrixB01;
  reg [`DWIDTH-1:0] B11_matrixB02;
  reg [`DWIDTH-1:0] B11_matrixB03;
  reg [`DWIDTH-1:0] B11_matrixB10;
  reg [`DWIDTH-1:0] B11_matrixB11;
  reg [`DWIDTH-1:0] B11_matrixB12;
  reg [`DWIDTH-1:0] B11_matrixB13;
  reg [`DWIDTH-1:0] B11_matrixB20;
  reg [`DWIDTH-1:0] B11_matrixB21;
  reg [`DWIDTH-1:0] B11_matrixB22;
  reg [`DWIDTH-1:0] B11_matrixB23;
  reg [`DWIDTH-1:0] B11_matrixB30;
  reg [`DWIDTH-1:0] B11_matrixB31;
  reg [`DWIDTH-1:0] B11_matrixB32;
  reg [`DWIDTH-1:0] B11_matrixB33;

  wire [2*`DWIDTH-1:0] A00_B10_matrixC00;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC01;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC02;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC03;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC10;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC11;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC12;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC13;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC20;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC21;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC22;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC23;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC30;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC31;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC32;
  wire [2*`DWIDTH-1:0] A00_B10_matrixC33;

  wire [2*`DWIDTH-1:0] A01_B00_matrixC00;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC01;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC02;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC03;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC10;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC11;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC12;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC13;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC20;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC21;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC22;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC23;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC30;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC31;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC32;
  wire [2*`DWIDTH-1:0] A01_B00_matrixC33;

  wire [2*`DWIDTH-1:0] A00_B11_matrixC00;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC01;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC02;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC03;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC10;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC11;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC12;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC13;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC20;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC21;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC22;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC23;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC30;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC31;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC32;
  wire [2*`DWIDTH-1:0] A00_B11_matrixC33;

  wire [2*`DWIDTH-1:0] A01_B01_matrixC00;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC01;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC02;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC03;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC10;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC11;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC12;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC13;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC20;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC21;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC22;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC23;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC30;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC31;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC32;
  wire [2*`DWIDTH-1:0] A01_B01_matrixC33;

  wire [2*`DWIDTH-1:0] A10_B10_matrixC00;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC01;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC02;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC03;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC10;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC11;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC12;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC13;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC20;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC21;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC22;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC23;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC30;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC31;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC32;
  wire [2*`DWIDTH-1:0] A10_B10_matrixC33;

  wire [2*`DWIDTH-1:0] A11_B00_matrixC00;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC01;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC02;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC03;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC10;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC11;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC12;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC13;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC20;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC21;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC22;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC23;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC30;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC31;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC32;
  wire [2*`DWIDTH-1:0] A11_B00_matrixC33;

  wire [2*`DWIDTH-1:0] A10_B11_matrixC00;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC01;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC02;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC03;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC10;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC11;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC12;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC13;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC20;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC21;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC22;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC23;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC30;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC31;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC32;
  wire [2*`DWIDTH-1:0] A10_B11_matrixC33;

  wire [2*`DWIDTH-1:0] A11_B01_matrixC00;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC01;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC02;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC03;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC10;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC11;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC12;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC13;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC20;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC21;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC22;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC23;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC30;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC31;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC32;
  wire [2*`DWIDTH-1:0] A11_B01_matrixC33;

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


 wire [`DWIDTH-1:0] mat_A;
 wire [`DWIDTH-1:0] mat_B;
 wire [`AWIDTH-1:0] addr_mem;
 reg [`AWIDTH-1:0] addr_internal;
 wire we1_mem;
 wire we2_mem;
 reg [`DWIDTH-1:0] dummy1;
 reg [`DWIDTH-1:0] dummy2;

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
      if(addr_internal<65) begin  
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
            1 : begin A00_matrixA00 <= mat_A; B00_matrixB00 <= mat_B;end
            2 : begin A00_matrixA01 <= mat_A; B00_matrixB01 <= mat_B;end
            3 : begin A00_matrixA02 <= mat_A; B00_matrixB02 <= mat_B;end
            4 : begin A00_matrixA03 <= mat_A; B00_matrixB03 <= mat_B;end
            5 : begin A00_matrixA10 <= mat_A; B00_matrixB10 <= mat_B;end
            6 : begin A00_matrixA11 <= mat_A; B00_matrixB11 <= mat_B;end
            7 : begin A00_matrixA12 <= mat_A; B00_matrixB12 <= mat_B;end
            8 : begin A00_matrixA13 <= mat_A; B00_matrixB13 <= mat_B;end
            9 : begin A00_matrixA20 <= mat_A; B00_matrixB20 <= mat_B;end
           10 : begin A00_matrixA21 <= mat_A; B00_matrixB21 <= mat_B;end
           11 : begin A00_matrixA22 <= mat_A; B00_matrixB22 <= mat_B;end
           12 : begin A00_matrixA23 <= mat_A; B00_matrixB23 <= mat_B;end
           13 : begin A00_matrixA30 <= mat_A; B00_matrixB30 <= mat_B;end
           14 : begin A00_matrixA31 <= mat_A; B00_matrixB31 <= mat_B;end
           15 : begin A00_matrixA32 <= mat_A; B00_matrixB32 <= mat_B;end
           16 : begin A00_matrixA33 <= mat_A; B00_matrixB33 <= mat_B;end
           17 : begin A01_matrixA00 <= mat_A; B01_matrixB00 <= mat_B;end
           18 : begin A01_matrixA01 <= mat_A; B01_matrixB01 <= mat_B;end
           19 : begin A01_matrixA02 <= mat_A; B01_matrixB02 <= mat_B;end
           20 : begin A01_matrixA03 <= mat_A; B01_matrixB03 <= mat_B;end
           21 : begin A01_matrixA10 <= mat_A; B01_matrixB10 <= mat_B;end
           22 : begin A01_matrixA11 <= mat_A; B01_matrixB11 <= mat_B;end
           23 : begin A01_matrixA12 <= mat_A; B01_matrixB12 <= mat_B;end
           24 : begin A01_matrixA13 <= mat_A; B01_matrixB13 <= mat_B;end
           25 : begin A01_matrixA20 <= mat_A; B01_matrixB20 <= mat_B;end
           26 : begin A01_matrixA21 <= mat_A; B01_matrixB21 <= mat_B;end
           27 : begin A01_matrixA22 <= mat_A; B01_matrixB22 <= mat_B;end
           28 : begin A01_matrixA23 <= mat_A; B01_matrixB23 <= mat_B;end
           29 : begin A01_matrixA30 <= mat_A; B01_matrixB30 <= mat_B;end
           30 : begin A01_matrixA31 <= mat_A; B01_matrixB31 <= mat_B;end
           31 : begin A01_matrixA32 <= mat_A; B01_matrixB32 <= mat_B;end
           32 : begin A01_matrixA33 <= mat_A; B01_matrixB33 <= mat_B;end
           33 : begin A10_matrixA00 <= mat_A; B10_matrixB00 <= mat_B;end
           34 : begin A10_matrixA01 <= mat_A; B10_matrixB01 <= mat_B;end
           35 : begin A10_matrixA02 <= mat_A; B10_matrixB02 <= mat_B;end
           36 : begin A10_matrixA03 <= mat_A; B10_matrixB03 <= mat_B;end
           37 : begin A10_matrixA10 <= mat_A; B10_matrixB10 <= mat_B;end
           38 : begin A10_matrixA11 <= mat_A; B10_matrixB11 <= mat_B;end
           39 : begin A10_matrixA12 <= mat_A; B10_matrixB12 <= mat_B;end
           40 : begin A10_matrixA13 <= mat_A; B10_matrixB13 <= mat_B;end
           41 : begin A10_matrixA20 <= mat_A; B10_matrixB20 <= mat_B;end
           42 : begin A10_matrixA21 <= mat_A; B10_matrixB21 <= mat_B;end
           43 : begin A10_matrixA22 <= mat_A; B10_matrixB22 <= mat_B;end
           44 : begin A10_matrixA23 <= mat_A; B10_matrixB23 <= mat_B;end
           45 : begin A10_matrixA30 <= mat_A; B10_matrixB30 <= mat_B;end
           46 : begin A10_matrixA31 <= mat_A; B10_matrixB31 <= mat_B;end
           47 : begin A10_matrixA32 <= mat_A; B10_matrixB32 <= mat_B;end
           48 : begin A10_matrixA33 <= mat_A; B10_matrixB33 <= mat_B;end
           49 : begin A11_matrixA00 <= mat_A; B11_matrixB00 <= mat_B;end
           50 : begin A11_matrixA01 <= mat_A; B11_matrixB01 <= mat_B;end
           51 : begin A11_matrixA02 <= mat_A; B11_matrixB02 <= mat_B;end
           52 : begin A11_matrixA03 <= mat_A; B11_matrixB03 <= mat_B;end
           53 : begin A11_matrixA10 <= mat_A; B11_matrixB10 <= mat_B;end
           54 : begin A11_matrixA11 <= mat_A; B11_matrixB11 <= mat_B;end
           55 : begin A11_matrixA12 <= mat_A; B11_matrixB12 <= mat_B;end
           56 : begin A11_matrixA13 <= mat_A; B11_matrixB13 <= mat_B;end
           57 : begin A11_matrixA20 <= mat_A; B11_matrixB20 <= mat_B;end
           58 : begin A11_matrixA21 <= mat_A; B11_matrixB21 <= mat_B;end
           59 : begin A11_matrixA22 <= mat_A; B11_matrixB22 <= mat_B;end
           60 : begin A11_matrixA23 <= mat_A; B11_matrixB23 <= mat_B;end
           61 : begin A11_matrixA30 <= mat_A; B11_matrixB30 <= mat_B;end
           62 : begin A11_matrixA31 <= mat_A; B11_matrixB31 <= mat_B;end
           63 : begin A11_matrixA32 <= mat_A; B11_matrixB32 <= mat_B;end
           64 : begin A11_matrixA33 <= mat_A; B11_matrixB33 <= mat_B;end
           default: begin dummy1 <= mat_A; dummy2 <= mat_B; end
    	endcase
    end
  end


  wire A00_B10_done_mat_mul;
  wire A01_B00_done_mat_mul;
  wire A00_B11_done_mat_mul;
  wire A01_B01_done_mat_mul;
  wire A10_B10_done_mat_mul;
  wire A11_B00_done_mat_mul;
  wire A10_B11_done_mat_mul;
  wire A11_B01_done_mat_mul;
  wire start_mat_add;
  
  assign start_mat_add = 
    A00_B10_done_mat_mul &
    A01_B00_done_mat_mul &
    A00_B11_done_mat_mul &
    A01_B01_done_mat_mul &
    A10_B10_done_mat_mul &
    A11_B00_done_mat_mul &
    A10_B11_done_mat_mul &
    A11_B01_done_mat_mul;
  
  wire C00_done_mat_add;
  wire C01_done_mat_add;
  wire C10_done_mat_add;
  wire C11_done_mat_add;
  wire done_mat_mul;
  
  assign done_mat_mul = 
    C00_done_mat_add &
    C01_done_mat_add &
    C10_done_mat_add & 
    C11_done_mat_add;

  reg [2*`DWIDTH-1:0] data_out;

  //sending output to PO instead of memory
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

matmul_4x4_systolic A00_B10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A00_B10_done_mat_mul),
  .matrixA00(A00_matrixA00),
  .matrixA01(A00_matrixA01),
  .matrixA02(A00_matrixA02),
  .matrixA03(A00_matrixA03),
  .matrixA10(A00_matrixA10),
  .matrixA11(A00_matrixA11),
  .matrixA12(A00_matrixA12),
  .matrixA13(A00_matrixA13),
  .matrixA20(A00_matrixA20),
  .matrixA21(A00_matrixA21),
  .matrixA22(A00_matrixA22),
  .matrixA23(A00_matrixA23),
  .matrixA30(A00_matrixA30),
  .matrixA31(A00_matrixA31),
  .matrixA32(A00_matrixA32),
  .matrixA33(A00_matrixA33),
  .matrixB00(B10_matrixB00),
  .matrixB01(B10_matrixB01),
  .matrixB02(B10_matrixB02),
  .matrixB03(B10_matrixB03),
  .matrixB10(B10_matrixB10),
  .matrixB11(B10_matrixB11),
  .matrixB12(B10_matrixB12),
  .matrixB13(B10_matrixB13),
  .matrixB20(B10_matrixB20),
  .matrixB21(B10_matrixB21),
  .matrixB22(B10_matrixB22),
  .matrixB23(B10_matrixB23),
  .matrixB30(B10_matrixB30),
  .matrixB31(B10_matrixB31),
  .matrixB32(B10_matrixB32),
  .matrixB33(B10_matrixB33),
  .matrixC00(A00_B10_matrixC00),
  .matrixC01(A00_B10_matrixC01),
  .matrixC02(A00_B10_matrixC02),
  .matrixC03(A00_B10_matrixC03),
  .matrixC10(A00_B10_matrixC10),
  .matrixC11(A00_B10_matrixC11),
  .matrixC12(A00_B10_matrixC12),
  .matrixC13(A00_B10_matrixC13),
  .matrixC20(A00_B10_matrixC20),
  .matrixC21(A00_B10_matrixC21),
  .matrixC22(A00_B10_matrixC22),
  .matrixC23(A00_B10_matrixC23),
  .matrixC30(A00_B10_matrixC30),
  .matrixC31(A00_B10_matrixC31),
  .matrixC32(A00_B10_matrixC32),
  .matrixC33(A00_B10_matrixC33)
);

matmul_4x4_systolic A01_B00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A01_B00_done_mat_mul),
  .matrixA00(A01_matrixA00),
  .matrixA01(A01_matrixA01),
  .matrixA02(A01_matrixA02),
  .matrixA03(A01_matrixA03),
  .matrixA10(A01_matrixA10),
  .matrixA11(A01_matrixA11),
  .matrixA12(A01_matrixA12),
  .matrixA13(A01_matrixA13),
  .matrixA20(A01_matrixA20),
  .matrixA21(A01_matrixA21),
  .matrixA22(A01_matrixA22),
  .matrixA23(A01_matrixA23),
  .matrixA30(A01_matrixA30),
  .matrixA31(A01_matrixA31),
  .matrixA32(A01_matrixA32),
  .matrixA33(A01_matrixA33),
  .matrixB00(B00_matrixB00),
  .matrixB01(B00_matrixB01),
  .matrixB02(B00_matrixB02),
  .matrixB03(B00_matrixB03),
  .matrixB10(B00_matrixB10),
  .matrixB11(B00_matrixB11),
  .matrixB12(B00_matrixB12),
  .matrixB13(B00_matrixB13),
  .matrixB20(B00_matrixB20),
  .matrixB21(B00_matrixB21),
  .matrixB22(B00_matrixB22),
  .matrixB23(B00_matrixB23),
  .matrixB30(B00_matrixB30),
  .matrixB31(B00_matrixB31),
  .matrixB32(B00_matrixB32),
  .matrixB33(B00_matrixB33),
  .matrixC00(A01_B00_matrixC00),
  .matrixC01(A01_B00_matrixC01),
  .matrixC02(A01_B00_matrixC02),
  .matrixC03(A01_B00_matrixC03),
  .matrixC10(A01_B00_matrixC10),
  .matrixC11(A01_B00_matrixC11),
  .matrixC12(A01_B00_matrixC12),
  .matrixC13(A01_B00_matrixC13),
  .matrixC20(A01_B00_matrixC20),
  .matrixC21(A01_B00_matrixC21),
  .matrixC22(A01_B00_matrixC22),
  .matrixC23(A01_B00_matrixC23),
  .matrixC30(A01_B00_matrixC30),
  .matrixC31(A01_B00_matrixC31),
  .matrixC32(A01_B00_matrixC32),
  .matrixC33(A01_B00_matrixC33)
);

matmul_4x4_systolic A00_B11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A00_B11_done_mat_mul),
  .matrixA00(A00_matrixA00),
  .matrixA01(A00_matrixA01),
  .matrixA02(A00_matrixA02),
  .matrixA03(A00_matrixA03),
  .matrixA10(A00_matrixA10),
  .matrixA11(A00_matrixA11),
  .matrixA12(A00_matrixA12),
  .matrixA13(A00_matrixA13),
  .matrixA20(A00_matrixA20),
  .matrixA21(A00_matrixA21),
  .matrixA22(A00_matrixA22),
  .matrixA23(A00_matrixA23),
  .matrixA30(A00_matrixA30),
  .matrixA31(A00_matrixA31),
  .matrixA32(A00_matrixA32),
  .matrixA33(A00_matrixA33),
  .matrixB00(B11_matrixB00),
  .matrixB01(B11_matrixB01),
  .matrixB02(B11_matrixB02),
  .matrixB03(B11_matrixB03),
  .matrixB10(B11_matrixB10),
  .matrixB11(B11_matrixB11),
  .matrixB12(B11_matrixB12),
  .matrixB13(B11_matrixB13),
  .matrixB20(B11_matrixB20),
  .matrixB21(B11_matrixB21),
  .matrixB22(B11_matrixB22),
  .matrixB23(B11_matrixB23),
  .matrixB30(B11_matrixB30),
  .matrixB31(B11_matrixB31),
  .matrixB32(B11_matrixB32),
  .matrixB33(B11_matrixB33),
  .matrixC00(A00_B11_matrixC00),
  .matrixC01(A00_B11_matrixC01),
  .matrixC02(A00_B11_matrixC02),
  .matrixC03(A00_B11_matrixC03),
  .matrixC10(A00_B11_matrixC10),
  .matrixC11(A00_B11_matrixC11),
  .matrixC12(A00_B11_matrixC12),
  .matrixC13(A00_B11_matrixC13),
  .matrixC20(A00_B11_matrixC20),
  .matrixC21(A00_B11_matrixC21),
  .matrixC22(A00_B11_matrixC22),
  .matrixC23(A00_B11_matrixC23),
  .matrixC30(A00_B11_matrixC30),
  .matrixC31(A00_B11_matrixC31),
  .matrixC32(A00_B11_matrixC32),
  .matrixC33(A00_B11_matrixC33)
);

matmul_4x4_systolic A01_B01(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A01_B01_done_mat_mul),
  .matrixA00(A01_matrixA00),
  .matrixA01(A01_matrixA01),
  .matrixA02(A01_matrixA02),
  .matrixA03(A01_matrixA03),
  .matrixA10(A01_matrixA10),
  .matrixA11(A01_matrixA11),
  .matrixA12(A01_matrixA12),
  .matrixA13(A01_matrixA13),
  .matrixA20(A01_matrixA20),
  .matrixA21(A01_matrixA21),
  .matrixA22(A01_matrixA22),
  .matrixA23(A01_matrixA23),
  .matrixA30(A01_matrixA30),
  .matrixA31(A01_matrixA31),
  .matrixA32(A01_matrixA32),
  .matrixA33(A01_matrixA33),
  .matrixB00(B01_matrixB00),
  .matrixB01(B01_matrixB01),
  .matrixB02(B01_matrixB02),
  .matrixB03(B01_matrixB03),
  .matrixB10(B01_matrixB10),
  .matrixB11(B01_matrixB11),
  .matrixB12(B01_matrixB12),
  .matrixB13(B01_matrixB13),
  .matrixB20(B01_matrixB20),
  .matrixB21(B01_matrixB21),
  .matrixB22(B01_matrixB22),
  .matrixB23(B01_matrixB23),
  .matrixB30(B01_matrixB30),
  .matrixB31(B01_matrixB31),
  .matrixB32(B01_matrixB32),
  .matrixB33(B01_matrixB33),
  .matrixC00(A01_B01_matrixC00),
  .matrixC01(A01_B01_matrixC01),
  .matrixC02(A01_B01_matrixC02),
  .matrixC03(A01_B01_matrixC03),
  .matrixC10(A01_B01_matrixC10),
  .matrixC11(A01_B01_matrixC11),
  .matrixC12(A01_B01_matrixC12),
  .matrixC13(A01_B01_matrixC13),
  .matrixC20(A01_B01_matrixC20),
  .matrixC21(A01_B01_matrixC21),
  .matrixC22(A01_B01_matrixC22),
  .matrixC23(A01_B01_matrixC23),
  .matrixC30(A01_B01_matrixC30),
  .matrixC31(A01_B01_matrixC31),
  .matrixC32(A01_B01_matrixC32),
  .matrixC33(A01_B01_matrixC33)
);

matmul_4x4_systolic A10_B10(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A10_B10_done_mat_mul),
  .matrixA00(A10_matrixA00),
  .matrixA01(A10_matrixA01),
  .matrixA02(A10_matrixA02),
  .matrixA03(A10_matrixA03),
  .matrixA10(A10_matrixA10),
  .matrixA11(A10_matrixA11),
  .matrixA12(A10_matrixA12),
  .matrixA13(A10_matrixA13),
  .matrixA20(A10_matrixA20),
  .matrixA21(A10_matrixA21),
  .matrixA22(A10_matrixA22),
  .matrixA23(A10_matrixA23),
  .matrixA30(A10_matrixA30),
  .matrixA31(A10_matrixA31),
  .matrixA32(A10_matrixA32),
  .matrixA33(A10_matrixA33),
  .matrixB00(B10_matrixB00),
  .matrixB01(B10_matrixB01),
  .matrixB02(B10_matrixB02),
  .matrixB03(B10_matrixB03),
  .matrixB10(B10_matrixB10),
  .matrixB11(B10_matrixB11),
  .matrixB12(B10_matrixB12),
  .matrixB13(B10_matrixB13),
  .matrixB20(B10_matrixB20),
  .matrixB21(B10_matrixB21),
  .matrixB22(B10_matrixB22),
  .matrixB23(B10_matrixB23),
  .matrixB30(B10_matrixB30),
  .matrixB31(B10_matrixB31),
  .matrixB32(B10_matrixB32),
  .matrixB33(B10_matrixB33),
  .matrixC00(A10_B10_matrixC00),
  .matrixC01(A10_B10_matrixC01),
  .matrixC02(A10_B10_matrixC02),
  .matrixC03(A10_B10_matrixC03),
  .matrixC10(A10_B10_matrixC10),
  .matrixC11(A10_B10_matrixC11),
  .matrixC12(A10_B10_matrixC12),
  .matrixC13(A10_B10_matrixC13),
  .matrixC20(A10_B10_matrixC20),
  .matrixC21(A10_B10_matrixC21),
  .matrixC22(A10_B10_matrixC22),
  .matrixC23(A10_B10_matrixC23),
  .matrixC30(A10_B10_matrixC30),
  .matrixC31(A10_B10_matrixC31),
  .matrixC32(A10_B10_matrixC32),
  .matrixC33(A10_B10_matrixC33)
);

matmul_4x4_systolic A11_B00(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A11_B00_done_mat_mul),
  .matrixA00(A11_matrixA00),
  .matrixA01(A11_matrixA01),
  .matrixA02(A11_matrixA02),
  .matrixA03(A11_matrixA03),
  .matrixA10(A11_matrixA10),
  .matrixA11(A11_matrixA11),
  .matrixA12(A11_matrixA12),
  .matrixA13(A11_matrixA13),
  .matrixA20(A11_matrixA20),
  .matrixA21(A11_matrixA21),
  .matrixA22(A11_matrixA22),
  .matrixA23(A11_matrixA23),
  .matrixA30(A11_matrixA30),
  .matrixA31(A11_matrixA31),
  .matrixA32(A11_matrixA32),
  .matrixA33(A11_matrixA33),
  .matrixB00(B00_matrixB00),
  .matrixB01(B00_matrixB01),
  .matrixB02(B00_matrixB02),
  .matrixB03(B00_matrixB03),
  .matrixB10(B00_matrixB10),
  .matrixB11(B00_matrixB11),
  .matrixB12(B00_matrixB12),
  .matrixB13(B00_matrixB13),
  .matrixB20(B00_matrixB20),
  .matrixB21(B00_matrixB21),
  .matrixB22(B00_matrixB22),
  .matrixB23(B00_matrixB23),
  .matrixB30(B00_matrixB30),
  .matrixB31(B00_matrixB31),
  .matrixB32(B00_matrixB32),
  .matrixB33(B00_matrixB33),
  .matrixC00(A11_B00_matrixC00),
  .matrixC01(A11_B00_matrixC01),
  .matrixC02(A11_B00_matrixC02),
  .matrixC03(A11_B00_matrixC03),
  .matrixC10(A11_B00_matrixC10),
  .matrixC11(A11_B00_matrixC11),
  .matrixC12(A11_B00_matrixC12),
  .matrixC13(A11_B00_matrixC13),
  .matrixC20(A11_B00_matrixC20),
  .matrixC21(A11_B00_matrixC21),
  .matrixC22(A11_B00_matrixC22),
  .matrixC23(A11_B00_matrixC23),
  .matrixC30(A11_B00_matrixC30),
  .matrixC31(A11_B00_matrixC31),
  .matrixC32(A11_B00_matrixC32),
  .matrixC33(A11_B00_matrixC33)
);

matmul_4x4_systolic A10_B11(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A10_B11_done_mat_mul),
  .matrixA00(A10_matrixA00),
  .matrixA01(A10_matrixA01),
  .matrixA02(A10_matrixA02),
  .matrixA03(A10_matrixA03),
  .matrixA10(A10_matrixA10),
  .matrixA11(A10_matrixA11),
  .matrixA12(A10_matrixA12),
  .matrixA13(A10_matrixA13),
  .matrixA20(A10_matrixA20),
  .matrixA21(A10_matrixA21),
  .matrixA22(A10_matrixA22),
  .matrixA23(A10_matrixA23),
  .matrixA30(A10_matrixA30),
  .matrixA31(A10_matrixA31),
  .matrixA32(A10_matrixA32),
  .matrixA33(A10_matrixA33),
  .matrixB00(B11_matrixB00),
  .matrixB01(B11_matrixB01),
  .matrixB02(B11_matrixB02),
  .matrixB03(B11_matrixB03),
  .matrixB10(B11_matrixB10),
  .matrixB11(B11_matrixB11),
  .matrixB12(B11_matrixB12),
  .matrixB13(B11_matrixB13),
  .matrixB20(B11_matrixB20),
  .matrixB21(B11_matrixB21),
  .matrixB22(B11_matrixB22),
  .matrixB23(B11_matrixB23),
  .matrixB30(B11_matrixB30),
  .matrixB31(B11_matrixB31),
  .matrixB32(B11_matrixB32),
  .matrixB33(B11_matrixB33),
  .matrixC00(A10_B11_matrixC00),
  .matrixC01(A10_B11_matrixC01),
  .matrixC02(A10_B11_matrixC02),
  .matrixC03(A10_B11_matrixC03),
  .matrixC10(A10_B11_matrixC10),
  .matrixC11(A10_B11_matrixC11),
  .matrixC12(A10_B11_matrixC12),
  .matrixC13(A10_B11_matrixC13),
  .matrixC20(A10_B11_matrixC20),
  .matrixC21(A10_B11_matrixC21),
  .matrixC22(A10_B11_matrixC22),
  .matrixC23(A10_B11_matrixC23),
  .matrixC30(A10_B11_matrixC30),
  .matrixC31(A10_B11_matrixC31),
  .matrixC32(A10_B11_matrixC32),
  .matrixC33(A10_B11_matrixC33)
);

matmul_4x4_systolic A11_B01(
  .clk(clk),
  .reset(reset),
  .start_mat_mul(done_reading_mem),
  .done_mat_mul(A11_B01_done_mat_mul),
  .matrixA00(A11_matrixA00),
  .matrixA01(A11_matrixA01),
  .matrixA02(A11_matrixA02),
  .matrixA03(A11_matrixA03),
  .matrixA10(A11_matrixA10),
  .matrixA11(A11_matrixA11),
  .matrixA12(A11_matrixA12),
  .matrixA13(A11_matrixA13),
  .matrixA20(A11_matrixA20),
  .matrixA21(A11_matrixA21),
  .matrixA22(A11_matrixA22),
  .matrixA23(A11_matrixA23),
  .matrixA30(A11_matrixA30),
  .matrixA31(A11_matrixA31),
  .matrixA32(A11_matrixA32),
  .matrixA33(A11_matrixA33),
  .matrixB00(B01_matrixB00),
  .matrixB01(B01_matrixB01),
  .matrixB02(B01_matrixB02),
  .matrixB03(B01_matrixB03),
  .matrixB10(B01_matrixB10),
  .matrixB11(B01_matrixB11),
  .matrixB12(B01_matrixB12),
  .matrixB13(B01_matrixB13),
  .matrixB20(B01_matrixB20),
  .matrixB21(B01_matrixB21),
  .matrixB22(B01_matrixB22),
  .matrixB23(B01_matrixB23),
  .matrixB30(B01_matrixB30),
  .matrixB31(B01_matrixB31),
  .matrixB32(B01_matrixB32),
  .matrixB33(B01_matrixB33),
  .matrixC00(A11_B01_matrixC00),
  .matrixC01(A11_B01_matrixC01),
  .matrixC02(A11_B01_matrixC02),
  .matrixC03(A11_B01_matrixC03),
  .matrixC10(A11_B01_matrixC10),
  .matrixC11(A11_B01_matrixC11),
  .matrixC12(A11_B01_matrixC12),
  .matrixC13(A11_B01_matrixC13),
  .matrixC20(A11_B01_matrixC20),
  .matrixC21(A11_B01_matrixC21),
  .matrixC22(A11_B01_matrixC22),
  .matrixC23(A11_B01_matrixC23),
  .matrixC30(A11_B01_matrixC30),
  .matrixC31(A11_B01_matrixC31),
  .matrixC32(A11_B01_matrixC32),
  .matrixC33(A11_B01_matrixC33)
);

matrix_add_4x4 u_matadd_C00(
.clk(clk),
.reset(reset),
.start_mat_add(start_mat_add),
.done_mat_add(C00_done_mat_add),
.matrixA00(A00_B10_matrixC00),
.matrixA01(A00_B10_matrixC01),
.matrixA02(A00_B10_matrixC02),
.matrixA03(A00_B10_matrixC03),
.matrixA10(A00_B10_matrixC10),
.matrixA11(A00_B10_matrixC11),
.matrixA12(A00_B10_matrixC12),
.matrixA13(A00_B10_matrixC13),
.matrixA20(A00_B10_matrixC20),
.matrixA21(A00_B10_matrixC21),
.matrixA22(A00_B10_matrixC22),
.matrixA23(A00_B10_matrixC23),
.matrixA30(A00_B10_matrixC30),
.matrixA31(A00_B10_matrixC31),
.matrixA32(A00_B10_matrixC32),
.matrixA33(A00_B10_matrixC33),
.matrixB00(A01_B00_matrixC00),
.matrixB01(A01_B00_matrixC01),
.matrixB02(A01_B00_matrixC02),
.matrixB03(A01_B00_matrixC03),
.matrixB10(A01_B00_matrixC10),
.matrixB11(A01_B00_matrixC11),
.matrixB12(A01_B00_matrixC12),
.matrixB13(A01_B00_matrixC13),
.matrixB20(A01_B00_matrixC20),
.matrixB21(A01_B00_matrixC21),
.matrixB22(A01_B00_matrixC22),
.matrixB23(A01_B00_matrixC23),
.matrixB30(A01_B00_matrixC30),
.matrixB31(A01_B00_matrixC31),
.matrixB32(A01_B00_matrixC32),
.matrixB33(A01_B00_matrixC33),
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
.matrixC33(C00_matrixC33)
);

matrix_add_4x4 u_matadd_C01(
.clk(clk),
.reset(reset),
.start_mat_add(start_mat_add),
.done_mat_add(C01_done_mat_add),
.matrixA00(A00_B11_matrixC00),
.matrixA01(A00_B11_matrixC01),
.matrixA02(A00_B11_matrixC02),
.matrixA03(A00_B11_matrixC03),
.matrixA10(A00_B11_matrixC10),
.matrixA11(A00_B11_matrixC11),
.matrixA12(A00_B11_matrixC12),
.matrixA13(A00_B11_matrixC13),
.matrixA20(A00_B11_matrixC20),
.matrixA21(A00_B11_matrixC21),
.matrixA22(A00_B11_matrixC22),
.matrixA23(A00_B11_matrixC23),
.matrixA30(A00_B11_matrixC30),
.matrixA31(A00_B11_matrixC31),
.matrixA32(A00_B11_matrixC32),
.matrixA33(A00_B11_matrixC33),
.matrixB00(A01_B01_matrixC00),
.matrixB01(A01_B01_matrixC01),
.matrixB02(A01_B01_matrixC02),
.matrixB03(A01_B01_matrixC03),
.matrixB10(A01_B01_matrixC10),
.matrixB11(A01_B01_matrixC11),
.matrixB12(A01_B01_matrixC12),
.matrixB13(A01_B01_matrixC13),
.matrixB20(A01_B01_matrixC20),
.matrixB21(A01_B01_matrixC21),
.matrixB22(A01_B01_matrixC22),
.matrixB23(A01_B01_matrixC23),
.matrixB30(A01_B01_matrixC30),
.matrixB31(A01_B01_matrixC31),
.matrixB32(A01_B01_matrixC32),
.matrixB33(A01_B01_matrixC33),
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
.matrixC33(C01_matrixC33)
);
 
matrix_add_4x4 u_matadd_C10(
.clk(clk),
.reset(reset),
.start_mat_add(start_mat_add),
.done_mat_add(C10_done_mat_add),
.matrixA00(A10_B10_matrixC00),
.matrixA01(A10_B10_matrixC01),
.matrixA02(A10_B10_matrixC02),
.matrixA03(A10_B10_matrixC03),
.matrixA10(A10_B10_matrixC10),
.matrixA11(A10_B10_matrixC11),
.matrixA12(A10_B10_matrixC12),
.matrixA13(A10_B10_matrixC13),
.matrixA20(A10_B10_matrixC20),
.matrixA21(A10_B10_matrixC21),
.matrixA22(A10_B10_matrixC22),
.matrixA23(A10_B10_matrixC23),
.matrixA30(A10_B10_matrixC30),
.matrixA31(A10_B10_matrixC31),
.matrixA32(A10_B10_matrixC32),
.matrixA33(A10_B10_matrixC33),
.matrixB00(A11_B00_matrixC00),
.matrixB01(A11_B00_matrixC01),
.matrixB02(A11_B00_matrixC02),
.matrixB03(A11_B00_matrixC03),
.matrixB10(A11_B00_matrixC10),
.matrixB11(A11_B00_matrixC11),
.matrixB12(A11_B00_matrixC12),
.matrixB13(A11_B00_matrixC13),
.matrixB20(A11_B00_matrixC20),
.matrixB21(A11_B00_matrixC21),
.matrixB22(A11_B00_matrixC22),
.matrixB23(A11_B00_matrixC23),
.matrixB30(A11_B00_matrixC30),
.matrixB31(A11_B00_matrixC31),
.matrixB32(A11_B00_matrixC32),
.matrixB33(A11_B00_matrixC33),
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
.matrixC33(C10_matrixC33)
);

matrix_add_4x4 u_matadd_C11(
.clk(clk),
.reset(reset),
.start_mat_add(start_mat_add),
.done_mat_add(C11_done_mat_add),
.matrixA00(A10_B11_matrixC00),
.matrixA01(A10_B11_matrixC01),
.matrixA02(A10_B11_matrixC02),
.matrixA03(A10_B11_matrixC03),
.matrixA10(A10_B11_matrixC10),
.matrixA11(A10_B11_matrixC11),
.matrixA12(A10_B11_matrixC12),
.matrixA13(A10_B11_matrixC13),
.matrixA20(A10_B11_matrixC20),
.matrixA21(A10_B11_matrixC21),
.matrixA22(A10_B11_matrixC22),
.matrixA23(A10_B11_matrixC23),
.matrixA30(A10_B11_matrixC30),
.matrixA31(A10_B11_matrixC31),
.matrixA32(A10_B11_matrixC32),
.matrixA33(A10_B11_matrixC33),
.matrixB00(A11_B01_matrixC00),
.matrixB01(A11_B01_matrixC01),
.matrixB02(A11_B01_matrixC02),
.matrixB03(A11_B01_matrixC03),
.matrixB10(A11_B01_matrixC10),
.matrixB11(A11_B01_matrixC11),
.matrixB12(A11_B01_matrixC12),
.matrixB13(A11_B01_matrixC13),
.matrixB20(A11_B01_matrixC20),
.matrixB21(A11_B01_matrixC21),
.matrixB22(A11_B01_matrixC22),
.matrixB23(A11_B01_matrixC23),
.matrixB30(A11_B01_matrixC30),
.matrixB31(A11_B01_matrixC31),
.matrixB32(A11_B01_matrixC32),
.matrixB33(A11_B01_matrixC33),
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
.matrixC33(C11_matrixC33)
);

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

wire [`DWIDTH-1:0] a03to04_NC;
wire [`DWIDTH-1:0] a13to14_NC;
wire [`DWIDTH-1:0] a23to24_NC;
wire [`DWIDTH-1:0] a33to34_NC;
wire [`DWIDTH-1:0] b30to40_NC;
wire [`DWIDTH-1:0] b31to41_NC;
wire [`DWIDTH-1:0] b32to42_NC;
wire [`DWIDTH-1:0] b33to43_NC;

matmul_4x4_systolic_pes u_matmul_4x4_pes (
 .clk(clk),
 .reset(reset),
 .a0(a0), 
 .a1(a1), 
 .a2(a2),
 .a3(a3),
 .b0(b0),
 .b1(b1),
 .b2(b2),
 .b3(b3),
 .a03to04(a03to04_NC),//Leave NC
 .a13to14(a13to14_NC),//Leave NC
 .a23to24(a23to24_NC),//Leave NC
 .a33to34(a33to34_NC),//Leave NC
 .b30to40(b30to40_NC),//Leave NC
 .b31to41(b31to41_NC),//Leave NC
 .b32to42(b32to42_NC),//Leave NC
 .b33to43(b33to43_NC),//Leave NC
 .pe00_result(matrixC00),
 .pe01_result(matrixC01),
 .pe02_result(matrixC02),
 .pe03_result(matrixC03),
 .pe10_result(matrixC10),
 .pe11_result(matrixC11),
 .pe12_result(matrixC12),
 .pe13_result(matrixC13),
 .pe20_result(matrixC20),
 .pe21_result(matrixC21),
 .pe22_result(matrixC22),
 .pe23_result(matrixC23),
 .pe30_result(matrixC30),
 .pe31_result(matrixC31),
 .pe32_result(matrixC32),
 .pe33_result(matrixC33)
);


endmodule 

module matrix_add_4x4(
 clk,
 reset,
 start_mat_add,
 done_mat_add,
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
 input start_mat_add;
 output done_mat_add;
 input [2*`DWIDTH-1:0] matrixA00;
 input [2*`DWIDTH-1:0] matrixA01;
 input [2*`DWIDTH-1:0] matrixA02;
 input [2*`DWIDTH-1:0] matrixA03;
 input [2*`DWIDTH-1:0] matrixA10;
 input [2*`DWIDTH-1:0] matrixA11;
 input [2*`DWIDTH-1:0] matrixA12;
 input [2*`DWIDTH-1:0] matrixA13;
 input [2*`DWIDTH-1:0] matrixA20;
 input [2*`DWIDTH-1:0] matrixA21;
 input [2*`DWIDTH-1:0] matrixA22;
 input [2*`DWIDTH-1:0] matrixA23;
 input [2*`DWIDTH-1:0] matrixA30;
 input [2*`DWIDTH-1:0] matrixA31;
 input [2*`DWIDTH-1:0] matrixA32;
 input [2*`DWIDTH-1:0] matrixA33;
 input [2*`DWIDTH-1:0] matrixB00;
 input [2*`DWIDTH-1:0] matrixB01;
 input [2*`DWIDTH-1:0] matrixB02;
 input [2*`DWIDTH-1:0] matrixB03;
 input [2*`DWIDTH-1:0] matrixB10;
 input [2*`DWIDTH-1:0] matrixB11;
 input [2*`DWIDTH-1:0] matrixB12;
 input [2*`DWIDTH-1:0] matrixB13;
 input [2*`DWIDTH-1:0] matrixB20;
 input [2*`DWIDTH-1:0] matrixB21;
 input [2*`DWIDTH-1:0] matrixB22;
 input [2*`DWIDTH-1:0] matrixB23;
 input [2*`DWIDTH-1:0] matrixB30;
 input [2*`DWIDTH-1:0] matrixB31;
 input [2*`DWIDTH-1:0] matrixB32;
 input [2*`DWIDTH-1:0] matrixB33;
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

 reg [2*`DWIDTH-1:0] matrixC00;
 reg [2*`DWIDTH-1:0] matrixC01;
 reg [2*`DWIDTH-1:0] matrixC02;
 reg [2*`DWIDTH-1:0] matrixC03;
 reg [2*`DWIDTH-1:0] matrixC10;
 reg [2*`DWIDTH-1:0] matrixC11;
 reg [2*`DWIDTH-1:0] matrixC12;
 reg [2*`DWIDTH-1:0] matrixC13;
 reg [2*`DWIDTH-1:0] matrixC20;
 reg [2*`DWIDTH-1:0] matrixC21;
 reg [2*`DWIDTH-1:0] matrixC22;
 reg [2*`DWIDTH-1:0] matrixC23;
 reg [2*`DWIDTH-1:0] matrixC30;
 reg [2*`DWIDTH-1:0] matrixC31;
 reg [2*`DWIDTH-1:0] matrixC32;
 reg [2*`DWIDTH-1:0] matrixC33;

 reg done_mat_add;

 always @(posedge clk) begin
   if (reset || ~start_mat_add) begin
     done_mat_add <= 0;
     matrixC00 <= 0;
     matrixC01 <= 0;
     matrixC02 <= 0;
     matrixC03 <= 0;
     matrixC10 <= 0;
     matrixC11 <= 0;
     matrixC12 <= 0;
     matrixC13 <= 0;
     matrixC20 <= 0;
     matrixC21 <= 0;
     matrixC22 <= 0;
     matrixC23 <= 0;
     matrixC30 <= 0;
     matrixC31 <= 0;
     matrixC32 <= 0;
     matrixC33 <= 0;
   end
   else begin
     matrixC00 <= matrixA00 + matrixB00;
     matrixC01 <= matrixA01 + matrixB01;
     matrixC02 <= matrixA02 + matrixB02;
     matrixC03 <= matrixA03 + matrixB03;
     matrixC10 <= matrixA10 + matrixB10;
     matrixC11 <= matrixA11 + matrixB11;
     matrixC12 <= matrixA12 + matrixB12;
     matrixC13 <= matrixA13 + matrixB13;
     matrixC20 <= matrixA20 + matrixB20;
     matrixC21 <= matrixA21 + matrixB21;
     matrixC22 <= matrixA22 + matrixB22;
     matrixC23 <= matrixA23 + matrixB23;
     matrixC30 <= matrixA30 + matrixB30;
     matrixC31 <= matrixA31 + matrixB31;
     matrixC32 <= matrixA32 + matrixB32;
     matrixC33 <= matrixA33 + matrixB33;
     done_mat_add <= 1;
   end
 end

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

