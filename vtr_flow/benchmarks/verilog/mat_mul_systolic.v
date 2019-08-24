
`timescale 1ns/1ns
`define DWIDTH 16
`define AWIDTH 4
`define MEM_SIZE 16

module matrix_multiplication(clk, reset, we1, we2, start, data_pi, addr_pi, out_sel, data_out, done);
      input clk;
      input reset;
      input we1;  
      input we2;  
      input start;
      input [`DWIDTH-1:0] data_pi;
      input [`AWIDTH-1:0] addr_pi;
      input [`AWIDTH-1:0] out_sel;
      output [2*`DWIDTH-1:0] data_out;  
      output done;

 wire [`DWIDTH-1:0] mat_A;  
 wire [`DWIDTH-1:0] mat_B;  
 reg wen;  
 reg [`DWIDTH-1:0] data_in;  
 reg [`AWIDTH-1:0] addr;  
 reg [`AWIDTH-1:0] address;  
 reg [2*`DWIDTH-1:0] data_out;  
 reg [`DWIDTH-1:0] matrixA00;
 reg [`DWIDTH-1:0] matrixA01;
 reg [`DWIDTH-1:0] matrixA02;
 reg [`DWIDTH-1:0] matrixA10;
 reg [`DWIDTH-1:0] matrixA11;
 reg [`DWIDTH-1:0] matrixA12;
 reg [`DWIDTH-1:0] matrixA20;
 reg [`DWIDTH-1:0] matrixA21;
 reg [`DWIDTH-1:0] matrixA22;
 reg [`DWIDTH-1:0] matrixB00;
 reg [`DWIDTH-1:0] matrixB01;
 reg [`DWIDTH-1:0] matrixB02;
 reg [`DWIDTH-1:0] matrixB10;
 reg [`DWIDTH-1:0] matrixB11;
 reg [`DWIDTH-1:0] matrixB12;
 reg [`DWIDTH-1:0] matrixB20;
 reg [`DWIDTH-1:0] matrixB21;
 reg [`DWIDTH-1:0] matrixB22;
 wire [2*`DWIDTH-1:0] matrixC00;
 wire [2*`DWIDTH-1:0] matrixC01;
 wire [2*`DWIDTH-1:0] matrixC02;
 wire [2*`DWIDTH-1:0] matrixC10;
 wire [2*`DWIDTH-1:0] matrixC11;
 wire [2*`DWIDTH-1:0] matrixC12;
 wire [2*`DWIDTH-1:0] matrixC20;
 wire [2*`DWIDTH-1:0] matrixC21;
 wire [2*`DWIDTH-1:0] matrixC22;


reg [`AWIDTH-1:0] addr_pi_temp;
reg [`DWIDTH-1:0] data_pi_temp;

// BRAM matrix A  
ram matrix_A_u (
  .addr0(addr),
  .d0(data_pi_temp), 
  .we0(we1), 
  .q0(mat_A), 
  .clk(clk));

// BRAM matrix B  
ram matrix_B_u(
  .addr0(addr),
  .d0(data_pi_temp), 
  .we0(we2), 
  .q0(mat_B), 
  .clk(clk));

reg done_reading_mem;
        
always @(posedge clk)  
begin  
     if(reset) begin  
        addr <= 0;  
        done_reading_mem <= 1'b0;
     end  
     else if (!start) begin
        addr<= addr_pi;
        data_pi_temp <= data_pi;
        done_reading_mem <= 1'b0;
     end
     else begin  
        if(addr<9) begin  
          addr <= addr + 1;  
          done_reading_mem <= 1'b0;
        end else begin
          done_reading_mem <= 1'b1;
        end   

  	case(addr) 
          0 : begin matrixA00 <= mat_A; matrixB00 <= mat_B;end
          1 : begin matrixA01 <= mat_A; matrixB01 <= mat_B;end
          2 : begin matrixA02 <= mat_A; matrixB02 <= mat_B;end
          3 : begin matrixA10 <= mat_A; matrixB10 <= mat_B;end
          4 : begin matrixA11 <= mat_A; matrixB11 <= mat_B;end
          5 : begin matrixA12 <= mat_A; matrixB12 <= mat_B;end
          6 : begin matrixA20 <= mat_A; matrixB20 <= mat_B;end
          7 : begin matrixA21 <= mat_A; matrixB21 <= mat_B;end
          8 : begin matrixA22 <= mat_A; matrixB22 <= mat_B;end
  	endcase
     end  
end  

reg [`DWIDTH-1:0] a0, a1, a2;
reg [`DWIDTH-1:0] b0, b1, b2;

reg [3:0] clk_cnt;
reg done;
always @(posedge clk) begin
  if (reset || ~done_reading_mem) begin
    done <= 0;
    clk_cnt <= 0;
    a0 <= 0;         b0 <= 0;        
    a1 <= 0;         b1 <= 0;        
    a2 <= 0;         b2 <= 0;        
  end
  else if (clk_cnt == 8) begin
    done <= 1;
  end
  else begin
    clk_cnt <= clk_cnt + 1;
    if (clk_cnt == 1) begin
      a0 <= matrixA00; b0 <= matrixB00;
      a1 <= 0;         b1 <= 0;
      a2 <= 0;         b2 <= 0;
    end 
    else if (clk_cnt == 2) begin
      a0 <= matrixA01; b0 <= matrixB10;
      a1 <= matrixA10; b1 <= matrixB01;
      a2 <= 0;         b2 <= 0;
    end
    else if (clk_cnt == 3) begin
      a0 <= matrixA02; b0 <= matrixB20;
      a1 <= matrixA11; b1 <= matrixB11;
      a2 <= matrixA20; b2 <= matrixB02;
    end
    else if (clk_cnt == 4) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= matrixA12; b1 <= matrixB21;
      a2 <= matrixA21; b2 <= matrixB12;
    end
    else if (clk_cnt == 5) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= matrixA22; b2 <= matrixB22;
    end
    else if (clk_cnt == 6) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
    end
    else if (clk_cnt == 7) begin
      a0 <= 0;         b0 <= 0;        
      a1 <= 0;         b1 <= 0;        
      a2 <= 0;         b2 <= 0;        
    end
  end
end


wire [`DWIDTH-1:0] a00to01, a01to02, a02to03;
wire [`DWIDTH-1:0] a10to11, a11to12, a12to13;
wire [`DWIDTH-1:0] a20to21, a21to22, a22to23;
wire [`DWIDTH-1:0] b00to10, b10to20, b20to30; 
wire [`DWIDTH-1:0] b01to11, b11to21, b21to31;
wire [`DWIDTH-1:0] b02to12, b12to22, b22to32;


processing_element pe00(.reset(reset), .clk(clk), .in_a(a0),      .in_b(b0),      .out_a(a00to01), .out_b(b00to10), .out_c(matrixC00));
processing_element pe01(.reset(reset), .clk(clk), .in_a(a00to01), .in_b(b1),      .out_a(a01to02), .out_b(b01to11), .out_c(matrixC01));
processing_element pe02(.reset(reset), .clk(clk), .in_a(a01to02), .in_b(b2),      .out_a(a02to03), .out_b(b02to12), .out_c(matrixC02));
processing_element pe10(.reset(reset), .clk(clk), .in_a(a1),      .in_b(b00to10), .out_a(a10to11), .out_b(b10to20), .out_c(matrixC10));
processing_element pe11(.reset(reset), .clk(clk), .in_a(a10to11), .in_b(b01to11), .out_a(a11to12), .out_b(b11to21), .out_c(matrixC11));
processing_element pe12(.reset(reset), .clk(clk), .in_a(a11to12), .in_b(b02to12), .out_a(a12to13), .out_b(b12to22), .out_c(matrixC12));
processing_element pe20(.reset(reset), .clk(clk), .in_a(a2),      .in_b(b10to20), .out_a(a20to21), .out_b(b20to30), .out_c(matrixC20));
processing_element pe21(.reset(reset), .clk(clk), .in_a(a20to21), .in_b(b11to21), .out_a(a21to22), .out_b(b21to31), .out_c(matrixC21));
processing_element pe22(.reset(reset), .clk(clk), .in_a(a21to22), .in_b(b12to22), .out_a(a22to23), .out_b(b22to32), .out_c(matrixC22));

//sending output to PO instead of memory
always @(posedge clk)  
begin  
     if(reset) begin  
        data_out <= 0;
     end
     else if (done) begin
          case (out_sel)
  		     0 : data_out <= matrixC00;
  		     1 : data_out <= matrixC01;
  		     2 : data_out <= matrixC02;
  		     3 : data_out <= matrixC10;
  		     4 : data_out <= matrixC11;
  		     5 : data_out <= matrixC12;
  		     6 : data_out <= matrixC20;
  		     7 : data_out <= matrixC21;
  		     8 : data_out <= matrixC22;
                     default: data_out <= matrixC22;
  	     endcase 
        end
end
//always @(posedge clk)  
//begin  
//     if(reset) begin  
//          address <= 0;  
//          wen <= 0;  
//          end  
//     else begin  
//          address <= address + 1;  
//          if(address<`MEM_SIZE) begin  
//               wen <= 1;  
//  	     case (address)
//  		     0 : data_in <= matrixC0;
//  		     1 : data_in <= matrixC1;
//  		     2 : data_in <= matrixC2;
//  		     3 : data_in <= matrixC3;
//  		     4 : data_in <= matrixC4;
//  		     5 : data_in <= matrixC5;
//  		     6 : data_in <= matrixC6;
//  		     7 : data_in <= matrixC7;
//  		     8 : data_in <= matrixC8;
//  	     endcase 
//          end  
//          else  
//          begin  
//               wen <= 0;            
//          end  
//     end  
//end  
//
//// BRAM matrix C  
//ram matrix_out_u(
//  .addr0(address),
//  .d0(data_in), 
//  .we0(wen), 
//  .q0(data_out), 
//  .clk(clk));      

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
      out_a<=in_a+1;
      out_b<=in_b+1;
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


