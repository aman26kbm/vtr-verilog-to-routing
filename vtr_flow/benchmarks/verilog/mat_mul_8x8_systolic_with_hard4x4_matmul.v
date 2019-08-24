`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128

//C = A * B
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

  //Elements of input matrix A
  //Divided into 4 quadrants - A00,A01,A10,A11
  //Each quadrant has 16 elements (4x4 matrix)

  //Elements of quadrant 00
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

  //Elements of quadrant 01
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

  //Elements of quadrant 10
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

  //Elements of quadrant 11
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

  //Elements of input matrix B
  //Divided into 4 quadrants - B00,B01,B10,B11
  //Each quadrant has 16 elements (4x4 matrix)

  //Elements of quadrant 00
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

  //Elements of quadrant 01
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

  //Elements of quadrant 10
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

  //Elements of quadrant 11
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
 
  //Read input matrices into flops
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

//Control logic for the systolic 8x8 multiplier
reg [`DWIDTH-1:0] a0, a1, a2, a3, a4, a5, a6, a7;
reg [`DWIDTH-1:0] b0, b1, b2, b3, b4, b5, b6, b7;


//Renaming signals - The control logic uses names 00..07,71,70, etc
//The naming above divides signals into quadrants.

wire [`DWIDTH-1:0] matrixA00;
wire [`DWIDTH-1:0] matrixA01;
wire [`DWIDTH-1:0] matrixA02;
wire [`DWIDTH-1:0] matrixA03;
wire [`DWIDTH-1:0] matrixA04;
wire [`DWIDTH-1:0] matrixA05;
wire [`DWIDTH-1:0] matrixA06;
wire [`DWIDTH-1:0] matrixA07;

wire [`DWIDTH-1:0] matrixA10;
wire [`DWIDTH-1:0] matrixA11;
wire [`DWIDTH-1:0] matrixA12;
wire [`DWIDTH-1:0] matrixA13;
wire [`DWIDTH-1:0] matrixA14;
wire [`DWIDTH-1:0] matrixA15;
wire [`DWIDTH-1:0] matrixA16;
wire [`DWIDTH-1:0] matrixA17;

wire [`DWIDTH-1:0] matrixA20;
wire [`DWIDTH-1:0] matrixA21;
wire [`DWIDTH-1:0] matrixA22;
wire [`DWIDTH-1:0] matrixA23;
wire [`DWIDTH-1:0] matrixA24;
wire [`DWIDTH-1:0] matrixA25;
wire [`DWIDTH-1:0] matrixA26;
wire [`DWIDTH-1:0] matrixA27;

wire [`DWIDTH-1:0] matrixA30;
wire [`DWIDTH-1:0] matrixA31;
wire [`DWIDTH-1:0] matrixA32;
wire [`DWIDTH-1:0] matrixA33;
wire [`DWIDTH-1:0] matrixA34;
wire [`DWIDTH-1:0] matrixA35;
wire [`DWIDTH-1:0] matrixA36;
wire [`DWIDTH-1:0] matrixA37;

wire [`DWIDTH-1:0] matrixA40;
wire [`DWIDTH-1:0] matrixA41;
wire [`DWIDTH-1:0] matrixA42;
wire [`DWIDTH-1:0] matrixA43;
wire [`DWIDTH-1:0] matrixA44;
wire [`DWIDTH-1:0] matrixA45;
wire [`DWIDTH-1:0] matrixA46;
wire [`DWIDTH-1:0] matrixA47;

wire [`DWIDTH-1:0] matrixA50;
wire [`DWIDTH-1:0] matrixA51;
wire [`DWIDTH-1:0] matrixA52;
wire [`DWIDTH-1:0] matrixA53;
wire [`DWIDTH-1:0] matrixA54;
wire [`DWIDTH-1:0] matrixA55;
wire [`DWIDTH-1:0] matrixA56;
wire [`DWIDTH-1:0] matrixA57;

wire [`DWIDTH-1:0] matrixA60;
wire [`DWIDTH-1:0] matrixA61;
wire [`DWIDTH-1:0] matrixA62;
wire [`DWIDTH-1:0] matrixA63;
wire [`DWIDTH-1:0] matrixA64;
wire [`DWIDTH-1:0] matrixA65;
wire [`DWIDTH-1:0] matrixA66;
wire [`DWIDTH-1:0] matrixA67;

wire [`DWIDTH-1:0] matrixA70;
wire [`DWIDTH-1:0] matrixA71;
wire [`DWIDTH-1:0] matrixA72;
wire [`DWIDTH-1:0] matrixA73;
wire [`DWIDTH-1:0] matrixA74;
wire [`DWIDTH-1:0] matrixA75;
wire [`DWIDTH-1:0] matrixA76;
wire [`DWIDTH-1:0] matrixA77;

wire [`DWIDTH-1:0] matrixB00;
wire [`DWIDTH-1:0] matrixB01;
wire [`DWIDTH-1:0] matrixB02;
wire [`DWIDTH-1:0] matrixB03;
wire [`DWIDTH-1:0] matrixB04;
wire [`DWIDTH-1:0] matrixB05;
wire [`DWIDTH-1:0] matrixB06;
wire [`DWIDTH-1:0] matrixB07;

wire [`DWIDTH-1:0] matrixB10;
wire [`DWIDTH-1:0] matrixB11;
wire [`DWIDTH-1:0] matrixB12;
wire [`DWIDTH-1:0] matrixB13;
wire [`DWIDTH-1:0] matrixB14;
wire [`DWIDTH-1:0] matrixB15;
wire [`DWIDTH-1:0] matrixB16;
wire [`DWIDTH-1:0] matrixB17;

wire [`DWIDTH-1:0] matrixB20;
wire [`DWIDTH-1:0] matrixB21;
wire [`DWIDTH-1:0] matrixB22;
wire [`DWIDTH-1:0] matrixB23;
wire [`DWIDTH-1:0] matrixB24;
wire [`DWIDTH-1:0] matrixB25;
wire [`DWIDTH-1:0] matrixB26;
wire [`DWIDTH-1:0] matrixB27;

wire [`DWIDTH-1:0] matrixB30;
wire [`DWIDTH-1:0] matrixB31;
wire [`DWIDTH-1:0] matrixB32;
wire [`DWIDTH-1:0] matrixB33;
wire [`DWIDTH-1:0] matrixB34;
wire [`DWIDTH-1:0] matrixB35;
wire [`DWIDTH-1:0] matrixB36;
wire [`DWIDTH-1:0] matrixB37;

wire [`DWIDTH-1:0] matrixB40;
wire [`DWIDTH-1:0] matrixB41;
wire [`DWIDTH-1:0] matrixB42;
wire [`DWIDTH-1:0] matrixB43;
wire [`DWIDTH-1:0] matrixB44;
wire [`DWIDTH-1:0] matrixB45;
wire [`DWIDTH-1:0] matrixB46;
wire [`DWIDTH-1:0] matrixB47;

wire [`DWIDTH-1:0] matrixB50;
wire [`DWIDTH-1:0] matrixB51;
wire [`DWIDTH-1:0] matrixB52;
wire [`DWIDTH-1:0] matrixB53;
wire [`DWIDTH-1:0] matrixB54;
wire [`DWIDTH-1:0] matrixB55;
wire [`DWIDTH-1:0] matrixB56;
wire [`DWIDTH-1:0] matrixB57;

wire [`DWIDTH-1:0] matrixB60;
wire [`DWIDTH-1:0] matrixB61;
wire [`DWIDTH-1:0] matrixB62;
wire [`DWIDTH-1:0] matrixB63;
wire [`DWIDTH-1:0] matrixB64;
wire [`DWIDTH-1:0] matrixB65;
wire [`DWIDTH-1:0] matrixB66;
wire [`DWIDTH-1:0] matrixB67;

wire [`DWIDTH-1:0] matrixB70;
wire [`DWIDTH-1:0] matrixB71;
wire [`DWIDTH-1:0] matrixB72;
wire [`DWIDTH-1:0] matrixB73;
wire [`DWIDTH-1:0] matrixB74;
wire [`DWIDTH-1:0] matrixB75;
wire [`DWIDTH-1:0] matrixB76;
wire [`DWIDTH-1:0] matrixB77;



assign matrixA00 = A00_matrixA00;
assign matrixA01 = A00_matrixA01;
assign matrixA02 = A00_matrixA02;
assign matrixA03 = A00_matrixA03;
assign matrixA04 = A01_matrixA00;
assign matrixA05 = A01_matrixA01;
assign matrixA06 = A01_matrixA02;
assign matrixA07 = A01_matrixA03;

assign matrixA10 = A00_matrixA10;
assign matrixA11 = A00_matrixA11;
assign matrixA12 = A00_matrixA12;
assign matrixA13 = A00_matrixA13;
assign matrixA14 = A01_matrixA10;
assign matrixA15 = A01_matrixA11;
assign matrixA16 = A01_matrixA12;
assign matrixA17 = A01_matrixA13;

assign matrixA20 = A00_matrixA20;
assign matrixA21 = A00_matrixA21;
assign matrixA22 = A00_matrixA22;
assign matrixA23 = A00_matrixA23;
assign matrixA24 = A01_matrixA20;
assign matrixA25 = A01_matrixA21;
assign matrixA26 = A01_matrixA22;
assign matrixA27 = A01_matrixA23;

assign matrixA30 = A00_matrixA30;
assign matrixA31 = A00_matrixA31;
assign matrixA32 = A00_matrixA32;
assign matrixA33 = A00_matrixA33;
assign matrixA34 = A01_matrixA30;
assign matrixA35 = A01_matrixA31;
assign matrixA36 = A01_matrixA32;
assign matrixA37 = A01_matrixA33;

assign matrixA40 = A10_matrixA00;
assign matrixA41 = A10_matrixA01;
assign matrixA42 = A10_matrixA02;
assign matrixA43 = A10_matrixA03;
assign matrixA44 = A11_matrixA00;
assign matrixA45 = A11_matrixA01;
assign matrixA46 = A11_matrixA02;
assign matrixA47 = A11_matrixA03;

assign matrixA50 = A10_matrixA10;
assign matrixA51 = A10_matrixA11;
assign matrixA52 = A10_matrixA12;
assign matrixA53 = A10_matrixA13;
assign matrixA54 = A11_matrixA10;
assign matrixA55 = A11_matrixA11;
assign matrixA56 = A11_matrixA12;
assign matrixA57 = A11_matrixA13;

assign matrixA60 = A10_matrixA20;
assign matrixA61 = A10_matrixA21;
assign matrixA62 = A10_matrixA22;
assign matrixA63 = A10_matrixA23;
assign matrixA64 = A11_matrixA20;
assign matrixA65 = A11_matrixA21;
assign matrixA66 = A11_matrixA22;
assign matrixA67 = A11_matrixA23;

assign matrixA70 = A10_matrixA30;
assign matrixA71 = A10_matrixA31;
assign matrixA72 = A10_matrixA32;
assign matrixA73 = A10_matrixA33;
assign matrixA74 = A11_matrixA30;
assign matrixA75 = A11_matrixA31;
assign matrixA76 = A11_matrixA32;
assign matrixA77 = A11_matrixA33;

assign matrixB00 = B00_matrixB00;
assign matrixB01 = B00_matrixB01;
assign matrixB02 = B00_matrixB02;
assign matrixB03 = B00_matrixB03;
assign matrixB04 = B01_matrixB00;
assign matrixB05 = B01_matrixB01;
assign matrixB06 = B01_matrixB02;
assign matrixB07 = B01_matrixB03;

assign matrixB10 = B00_matrixB10;
assign matrixB11 = B00_matrixB11;
assign matrixB12 = B00_matrixB12;
assign matrixB13 = B00_matrixB13;
assign matrixB14 = B01_matrixB10;
assign matrixB15 = B01_matrixB11;
assign matrixB16 = B01_matrixB12;
assign matrixB17 = B01_matrixB13;

assign matrixB20 = B00_matrixB20;
assign matrixB21 = B00_matrixB21;
assign matrixB22 = B00_matrixB22;
assign matrixB23 = B00_matrixB23;
assign matrixB24 = B01_matrixB20;
assign matrixB25 = B01_matrixB21;
assign matrixB26 = B01_matrixB22;
assign matrixB27 = B01_matrixB23;

assign matrixB30 = B00_matrixB30;
assign matrixB31 = B00_matrixB31;
assign matrixB32 = B00_matrixB32;
assign matrixB33 = B00_matrixB33;
assign matrixB34 = B01_matrixB30;
assign matrixB35 = B01_matrixB31;
assign matrixB36 = B01_matrixB32;
assign matrixB37 = B01_matrixB33;

assign matrixB40 = B10_matrixB00;
assign matrixB41 = B10_matrixB01;
assign matrixB42 = B10_matrixB02;
assign matrixB43 = B10_matrixB03;
assign matrixB44 = B11_matrixB00;
assign matrixB45 = B11_matrixB01;
assign matrixB46 = B11_matrixB02;
assign matrixB47 = B11_matrixB03;

assign matrixB50 = B10_matrixB10;
assign matrixB51 = B10_matrixB11;
assign matrixB52 = B10_matrixB12;
assign matrixB53 = B10_matrixB13;
assign matrixB54 = B11_matrixB10;
assign matrixB55 = B11_matrixB11;
assign matrixB56 = B11_matrixB12;
assign matrixB57 = B11_matrixB13;

assign matrixB60 = B10_matrixB20;
assign matrixB61 = B10_matrixB21;
assign matrixB62 = B10_matrixB22;
assign matrixB63 = B10_matrixB23;
assign matrixB64 = B11_matrixB20;
assign matrixB65 = B11_matrixB21;
assign matrixB66 = B11_matrixB22;
assign matrixB67 = B11_matrixB23;

assign matrixB70 = B10_matrixB30;
assign matrixB71 = B10_matrixB31;
assign matrixB72 = B10_matrixB32;
assign matrixB73 = B10_matrixB33;
assign matrixB74 = B11_matrixB30;
assign matrixB75 = B11_matrixB31;
assign matrixB76 = B11_matrixB32;
assign matrixB77 = B11_matrixB33;


reg [4:0] clk_cnt;
reg done_mat_mul;

always @(posedge clk) begin
  if (reset || ~done_reading_mem) begin
    done_mat_mul <= 0;
    clk_cnt <= 0;
    a0 <= 0;         b0 <= 0;        
    a1 <= 0;         b1 <= 0;        
    a2 <= 0;         b2 <= 0;        
    a3 <= 0;         b3 <= 0;
    a4 <= 0;         b4 <= 0;        
    a5 <= 0;         b5 <= 0;        
    a6 <= 0;         b6 <= 0;        
    a7 <= 0;         b7 <= 0;
  end
  else if (clk_cnt == 23) begin
    done_mat_mul <= 1;
  end
  else begin
    clk_cnt <= clk_cnt + 1;
    if ((clk_cnt == 1) || (clk_cnt >15)) begin
      a0 <= matrixA00; b0 <= matrixB00;
      a1 <= 0;         b1 <= 0;
      a2 <= 0;         b2 <= 0;
      a3 <= 0;         b3 <= 0;
      a4 <= 0;         b4 <= 0;        
      a5 <= 0;         b5 <= 0;        
      a6 <= 0;         b6 <= 0;        
      a7 <= 0;         b7 <= 0;
    end 
    else if (clk_cnt == 2) begin
      a0 <= matrixA01; b0 <= matrixB10;
      a1 <= matrixA10; b1 <= matrixB01;
      a2 <= 0;         b2 <= 0;
      a3 <= 0;         b3 <= 0;
      a4 <= 0;         b4 <= 0;        
      a5 <= 0;         b5 <= 0;        
      a6 <= 0;         b6 <= 0;        
      a7 <= 0;         b7 <= 0;
    end
    else if (clk_cnt == 3) begin
      a0 <= matrixA02; b0 <= matrixB20;
      a1 <= matrixA11; b1 <= matrixB11;
      a2 <= matrixA20; b2 <= matrixB02;
      a3 <= 0;         b3 <= 0;
      a4 <= 0;         b4 <= 0;        
      a5 <= 0;         b5 <= 0;        
      a6 <= 0;         b6 <= 0;        
      a7 <= 0;         b7 <= 0;
    end
    else if (clk_cnt == 4) begin
      a0 <= matrixA03; b0 <= matrixB30;        
      a1 <= matrixA12; b1 <= matrixB21;
      a2 <= matrixA21; b2 <= matrixB12;
      a3 <= matrixA30; b3 <= matrixB03;
      a4 <= 0;         b4 <= 0;        
      a5 <= 0;         b5 <= 0;        
      a6 <= 0;         b6 <= 0;        
      a7 <= 0;         b7 <= 0;
    end
    else if (clk_cnt == 5) begin
      a0 <= matrixA04; b0 <= matrixB40;
      a1 <= matrixA13; b1 <= matrixB31;        
      a2 <= matrixA22; b2 <= matrixB22;
      a3 <= matrixA31; b3 <= matrixB13;
      a4 <= matrixA40; b4 <= matrixB04;
      a5 <= 0;         b5 <= 0;        
      a6 <= 0;         b6 <= 0;        
      a7 <= 0;         b7 <= 0;
    end
    else if (clk_cnt == 6) begin
      a0 <= matrixA05; b0 <= matrixB50;
      a1 <= matrixA14; b1 <= matrixB41;
      a2 <= matrixA23; b2 <= matrixB32;        
      a3 <= matrixA32; b3 <= matrixB23;
      a4 <= matrixA41; b4 <= matrixB14;
      a5 <= matrixA50; b5 <= matrixB05;
      a6 <= 0;         b6 <= 0;        
      a7 <= 0;         b7 <= 0;
    end
    else if (clk_cnt == 7) begin
      a0 <= matrixA06; b0 <= matrixB60; 
      a1 <= matrixA15; b1 <= matrixB51; 
      a2 <= matrixA24; b2 <= matrixB42; 
      a3 <= matrixA33; b3 <= matrixB33;
      a4 <= matrixA42; b4 <= matrixB24; 
      a5 <= matrixA51; b5 <= matrixB15; 
      a6 <= matrixA60; b6 <= matrixB06; 
      a7 <= 0;         b7 <= 0;
    end
    else if (clk_cnt == 8) begin
      a0 <= matrixA07; b0 <= matrixB70;        
      a1 <= matrixA16; b1 <= matrixB61;        
      a2 <= matrixA25; b2 <= matrixB52;        
      a3 <= matrixA34; b3 <= matrixB43;
      a4 <= matrixA43; b4 <= matrixB34;        
      a5 <= matrixA52; b5 <= matrixB25;        
      a6 <= matrixA61; b6 <= matrixB16;        
      a7 <= matrixA70; b7 <= matrixB07;
    end
    else if (clk_cnt == 9) begin
      a0 <= 0;                 b0 <= 0;        
      a1 <= matrixA17;         b1 <= matrixB71;        
      a2 <= matrixA26;         b2 <= matrixB62;        
      a3 <= matrixA35;         b3 <= matrixB53;
      a4 <= matrixA44;         b4 <= matrixB44;        
      a5 <= matrixA53;         b5 <= matrixB35;        
      a6 <= matrixA62;         b6 <= matrixB26;        
      a7 <= matrixA71;         b7 <= matrixB17;
    end
    else if (clk_cnt == 10) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= matrixA27; b2 <= matrixB72;        
      a3 <= matrixA36; b3 <= matrixB63;
      a4 <= matrixA45; b4 <= matrixB54;        
      a5 <= matrixA54; b5 <= matrixB45;        
      a6 <= matrixA63; b6 <= matrixB36;        
      a7 <= matrixA72; b7 <= matrixB27;
    end
    else if (clk_cnt == 11) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= matrixA37; b3 <= matrixB73;
      a4 <= matrixA46; b4 <= matrixB64;        
      a5 <= matrixA55; b5 <= matrixB55;        
      a6 <= matrixA64; b6 <= matrixB46;        
      a7 <= matrixA73; b7 <= matrixB37;
    end
    else if (clk_cnt == 12) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
      a4 <= matrixA47; b4 <= matrixA74;        
      a5 <= matrixA56; b5 <= matrixA65;        
      a6 <= matrixA65; b6 <= matrixA56;        
      a7 <= matrixA74; b7 <= matrixA47;
    end
    else if (clk_cnt == 13) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
      a4 <= 0;         b4 <= 0;        
      a5 <= matrixA57; b5 <= matrixB75;        
      a6 <= matrixA66; b6 <= matrixB66;        
      a7 <= matrixA75; b7 <= matrixB57;
    end
    else if (clk_cnt == 14) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
      a4 <= 0;         b4 <= 0;        
      a5 <= 0;         b5 <= 0;        
      a6 <= matrixA67; b6 <= matrixB76;        
      a7 <= matrixA76; b7 <= matrixB67;
    end
    else if (clk_cnt == 15) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
      a3 <= 0;         b3 <= 0;
      a4 <= 0;         b4 <= 0;        
      a5 <= 0;         b5 <= 0;        
      a6 <= 0;         b6 <= 0;        
      a7 <= matrixA77; b7 <= matrixB77;
    end
  end
end

//Wires for connections between the 4x4 systolic multipliers
wire [`DWIDTH-1:0] C00_to_C01_a0;
wire [`DWIDTH-1:0] C00_to_C01_a1;
wire [`DWIDTH-1:0] C00_to_C01_a2;
wire [`DWIDTH-1:0] C00_to_C01_a3;
wire [`DWIDTH-1:0] C00_to_C10_b0;
wire [`DWIDTH-1:0] C00_to_C10_b1;
wire [`DWIDTH-1:0] C00_to_C10_b2;
wire [`DWIDTH-1:0] C00_to_C10_b3;
wire [`DWIDTH-1:0] C10_to_C11_a0;
wire [`DWIDTH-1:0] C10_to_C11_a1;
wire [`DWIDTH-1:0] C10_to_C11_a2;
wire [`DWIDTH-1:0] C10_to_C11_a3;
wire [`DWIDTH-1:0] C01_to_C11_b0;
wire [`DWIDTH-1:0] C01_to_C11_b1;
wire [`DWIDTH-1:0] C01_to_C11_b2;
wire [`DWIDTH-1:0] C01_to_C11_b3;
wire [`DWIDTH-1:0] dummy_NC1;
wire [`DWIDTH-1:0] dummy_NC2;
wire [`DWIDTH-1:0] dummy_NC3;
wire [`DWIDTH-1:0] dummy_NC4;
wire [`DWIDTH-1:0] dummy_NC5;
wire [`DWIDTH-1:0] dummy_NC6;
wire [`DWIDTH-1:0] dummy_NC7;
wire [`DWIDTH-1:0] dummy_NC8;
wire [`DWIDTH-1:0] dummy_NC9;
wire [`DWIDTH-1:0] dummy_NC10;
wire [`DWIDTH-1:0] dummy_NC11;
wire [`DWIDTH-1:0] dummy_NC12;
wire [`DWIDTH-1:0] dummy_NC13;
wire [`DWIDTH-1:0] dummy_NC14;
wire [`DWIDTH-1:0] dummy_NC15;
wire [`DWIDTH-1:0] dummy_NC16;

//Instances of 4x4 systolic matrix multipliers.
//Actually, they are just the PEs and connections between them.
//The control logic of the systolic multiplier is not instantiated.
matmul_4x4_systolic_pes u_matmul_4x4_C00 (
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
 .a03to04(C00_to_C01_a0),
 .a13to14(C00_to_C01_a1),
 .a23to24(C00_to_C01_a2),
 .a33to34(C00_to_C01_a3),
 .b30to40(C00_to_C10_b0),
 .b31to41(C00_to_C10_b1),
 .b32to42(C00_to_C10_b2),
 .b33to43(C00_to_C10_b3),
 .pe00_result(C00_matrixC00),
 .pe01_result(C00_matrixC01),
 .pe02_result(C00_matrixC02),
 .pe03_result(C00_matrixC03),
 .pe10_result(C00_matrixC10),
 .pe11_result(C00_matrixC11),
 .pe12_result(C00_matrixC12),
 .pe13_result(C00_matrixC13),
 .pe20_result(C00_matrixC20),
 .pe21_result(C00_matrixC21),
 .pe22_result(C00_matrixC22),
 .pe23_result(C00_matrixC23),
 .pe30_result(C00_matrixC30),
 .pe31_result(C00_matrixC31),
 .pe32_result(C00_matrixC32),
 .pe33_result(C00_matrixC33)
);

matmul_4x4_systolic_pes u_matmul_4x4_C01 (
 .clk(clk),
 .reset(reset),
 .a0(C00_to_C01_a0), 
 .a1(C00_to_C01_a1), 
 .a2(C00_to_C01_a2),
 .a3(C00_to_C01_a3),
 .b0(b4),
 .b1(b5),
 .b2(b6),
 .b3(b7),
 .a03to04(dummy_NC1),//Leave NC
 .a13to14(dummy_NC2),//Leave NC
 .a23to24(dummy_NC3),//Leave NC
 .a33to34(dummy_NC4),//Leave NC
 .b30to40(C01_to_C11_b0),
 .b31to41(C01_to_C11_b1),
 .b32to42(C01_to_C11_b2),
 .b33to43(C01_to_C11_b3),
 .pe00_result(C01_matrixC00),
 .pe01_result(C01_matrixC01),
 .pe02_result(C01_matrixC02),
 .pe03_result(C01_matrixC03),
 .pe10_result(C01_matrixC10),
 .pe11_result(C01_matrixC11),
 .pe12_result(C01_matrixC12),
 .pe13_result(C01_matrixC13),
 .pe20_result(C01_matrixC20),
 .pe21_result(C01_matrixC21),
 .pe22_result(C01_matrixC22),
 .pe23_result(C01_matrixC23),
 .pe30_result(C01_matrixC30),
 .pe31_result(C01_matrixC31),
 .pe32_result(C01_matrixC32),
 .pe33_result(C01_matrixC33)
);

matmul_4x4_systolic_pes u_matmul_4x4_C10 (
 .clk(clk),
 .reset(reset),
 .a0(a4), 
 .a1(a5), 
 .a2(a6),
 .a3(a7),
 .b0(C00_to_C10_b0),
 .b1(C00_to_C10_b1),
 .b2(C00_to_C10_b2),
 .b3(C00_to_C10_b3),
 .a03to04(C10_to_C11_a0),
 .a13to14(C10_to_C11_a1),
 .a23to24(C10_to_C11_a2),
 .a33to34(C10_to_C11_a3),
 .b30to40(dummy_NC5),//Leave NC
 .b31to41(dummy_NC6),//Leave NC
 .b32to42(dummy_NC7),//Leave NC
 .b33to43(dummy_NC8),//Leave NC
 .pe00_result(C10_matrixC00),
 .pe01_result(C10_matrixC01),
 .pe02_result(C10_matrixC02),
 .pe03_result(C10_matrixC03),
 .pe10_result(C10_matrixC10),
 .pe11_result(C10_matrixC11),
 .pe12_result(C10_matrixC12),
 .pe13_result(C10_matrixC13),
 .pe20_result(C10_matrixC20),
 .pe21_result(C10_matrixC21),
 .pe22_result(C10_matrixC22),
 .pe23_result(C10_matrixC23),
 .pe30_result(C10_matrixC30),
 .pe31_result(C10_matrixC31),
 .pe32_result(C10_matrixC32),
 .pe33_result(C10_matrixC33)
);

matmul_4x4_systolic_pes u_matmul_4x4_C11 (
 .clk(clk),
 .reset(reset),
 .a0(C10_to_C11_a0), 
 .a1(C10_to_C11_a1), 
 .a2(C10_to_C11_a2),
 .a3(C10_to_C11_a3),
 .b0(C01_to_C11_b0),
 .b1(C01_to_C11_b1),
 .b2(C01_to_C11_b2),
 .b3(C01_to_C11_b3),
 .a03to04(dummy_NC9),//Leave NC
 .a13to14(dummy_NC10),//Leave NC
 .a23to24(dummy_NC11),//Leave NC
 .a33to34(dummy_NC12),//Leave NC
 .b30to40(dummy_NC13),//Leave NC
 .b31to41(dummy_NC14),//Leave NC
 .b32to42(dummy_NC15),//Leave NC
 .b33to43(dummy_NC16),//Leave NC
 .pe00_result(C11_matrixC00),
 .pe01_result(C11_matrixC01),
 .pe02_result(C11_matrixC02),
 .pe03_result(C11_matrixC03),
 .pe10_result(C11_matrixC10),
 .pe11_result(C11_matrixC11),
 .pe12_result(C11_matrixC12),
 .pe13_result(C11_matrixC13),
 .pe20_result(C11_matrixC20),
 .pe21_result(C11_matrixC21),
 .pe22_result(C11_matrixC22),
 .pe23_result(C11_matrixC23),
 .pe30_result(C11_matrixC30),
 .pe31_result(C11_matrixC31),
 .pe32_result(C11_matrixC32),
 .pe33_result(C11_matrixC33)
);
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

