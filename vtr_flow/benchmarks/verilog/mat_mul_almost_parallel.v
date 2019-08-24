
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
 reg [`DWIDTH-1:0] matrixA0;
 reg [`DWIDTH-1:0] matrixA1;
 reg [`DWIDTH-1:0] matrixA2;
 reg [`DWIDTH-1:0] matrixA3;
 reg [`DWIDTH-1:0] matrixA4;
 reg [`DWIDTH-1:0] matrixA5;
 reg [`DWIDTH-1:0] matrixA6;
 reg [`DWIDTH-1:0] matrixA7;
 reg [`DWIDTH-1:0] matrixA8;
 reg [`DWIDTH-1:0] matrixB0;
 reg [`DWIDTH-1:0] matrixB1;
 reg [`DWIDTH-1:0] matrixB2;
 reg [`DWIDTH-1:0] matrixB3;
 reg [`DWIDTH-1:0] matrixB4;
 reg [`DWIDTH-1:0] matrixB5;
 reg [`DWIDTH-1:0] matrixB6;
 reg [`DWIDTH-1:0] matrixB7;
 reg [`DWIDTH-1:0] matrixB8;
 wire [2*`DWIDTH-1:0] matrixC0;
 wire [2*`DWIDTH-1:0] matrixC1;
 wire [2*`DWIDTH-1:0] matrixC2;
 wire [2*`DWIDTH-1:0] matrixC3;
 wire [2*`DWIDTH-1:0] matrixC4;
 wire [2*`DWIDTH-1:0] matrixC5;
 wire [2*`DWIDTH-1:0] matrixC6;
 wire [2*`DWIDTH-1:0] matrixC7;
 wire [2*`DWIDTH-1:0] matrixC8;


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
  	    	0 : begin matrixA0 <= mat_A; matrixB0 <= mat_B;end
  	    	1 : begin matrixA1 <= mat_A; matrixB1 <= mat_B;end
  	    	2 : begin matrixA2 <= mat_A; matrixB2 <= mat_B;end
  	    	3 : begin matrixA3 <= mat_A; matrixB3 <= mat_B;end
  	    	4 : begin matrixA4 <= mat_A; matrixB4 <= mat_B;end
  	    	5 : begin matrixA5 <= mat_A; matrixB5 <= mat_B;end
  	    	6 : begin matrixA6 <= mat_A; matrixB6 <= mat_B;end
  	    	7 : begin matrixA7 <= mat_A; matrixB7 <= mat_B;end
  	    	8 : begin matrixA8 <= mat_A; matrixB8 <= mat_B;end
  	    endcase
     end  
end  

//always @(posedge clk)  
//begin  
//     if(reset) begin  
//  	   matrixC0 <= 0;
//  	   matrixC1 <= 0;
//  	   matrixC2 <= 0;
//  	   matrixC3 <= 0;
//  	   matrixC4 <= 0;
//  	   matrixC5 <= 0;
//  	   matrixC6 <= 0;
//  	   matrixC7 <= 0;
//  	   matrixC8 <= 0;
//     end
//     else begin
//  	   matrixC0 <= matrixA0*matrixB0 + matrixA1*matrixB3 + matrixA2*matrixB6;
//  	   matrixC1 <= matrixA0*matrixB1 + matrixA1*matrixB4 + matrixA2*matrixB7;
//  	   matrixC2 <= matrixA0*matrixB2 + matrixA1*matrixB5 + matrixA2*matrixB8;
//  	   matrixC3 <= matrixA3*matrixB0 + matrixA4*matrixB3 + matrixA5*matrixB6;
//  	   matrixC4 <= matrixA3*matrixB1 + matrixA4*matrixB4 + matrixA5*matrixB7;
//  	   matrixC5 <= matrixA3*matrixB2 + matrixA4*matrixB5 + matrixA5*matrixB8;
//  	   matrixC6 <= matrixA6*matrixB0 + matrixA7*matrixB3 + matrixA8*matrixB6;
//  	   matrixC7 <= matrixA6*matrixB0 + matrixA7*matrixB3 + matrixA8*matrixB6;
//  	   matrixC8 <= matrixA6*matrixB0 + matrixA7*matrixB3 + matrixA8*matrixB6;
//     end
//end


//calc_one_element c0(matrixC0 , matrixA0,matrixB0 , matrixA1,matrixB3 , matrixA2,matrixB6);
//calc_one_element c1(matrixC1 , matrixA0,matrixB1 , matrixA1,matrixB4 , matrixA2,matrixB7);
//calc_one_element c2(matrixC2 , matrixA0,matrixB2 , matrixA1,matrixB5 , matrixA2,matrixB8);
//calc_one_element c3(matrixC3 , matrixA3,matrixB0 , matrixA4,matrixB3 , matrixA5,matrixB6);
//calc_one_element c4(matrixC4 , matrixA3,matrixB1 , matrixA4,matrixB4 , matrixA5,matrixB7);
//calc_one_element c5(matrixC5 , matrixA3,matrixB2 , matrixA4,matrixB5 , matrixA5,matrixB8);
//calc_one_element c6(matrixC6 , matrixA6,matrixB0 , matrixA7,matrixB3 , matrixA8,matrixB6);
//calc_one_element c7(matrixC7 , matrixA6,matrixB0 , matrixA7,matrixB3 , matrixA8,matrixB6);
//calc_one_element c8(matrixC8 , matrixA6,matrixB0 , matrixA7,matrixB3 , matrixA8,matrixB6);

reg [1:0] clk_cnt;
reg done;
always @(posedge clk) begin
  if (reset || ~done_reading_mem) begin
    done <= 0;
    clk_cnt <= 0;
  end
  else if (clk_cnt == 3) begin
    done <= 1;
  end
  else begin
    clk_cnt <= clk_cnt + 1;
  end
end

calc_one_element_ser c0(reset, clk, clk_cnt, matrixC0, matrixA0, matrixB0, matrixA1, matrixB3, matrixA2, matrixB6);
calc_one_element_ser c1(reset, clk, clk_cnt, matrixC1, matrixA0, matrixB1, matrixA1, matrixB4, matrixA2, matrixB7);
calc_one_element_ser c2(reset, clk, clk_cnt, matrixC2, matrixA0, matrixB2, matrixA1, matrixB5, matrixA2, matrixB8);
calc_one_element_ser c3(reset, clk, clk_cnt, matrixC3, matrixA3, matrixB0, matrixA4, matrixB3, matrixA5, matrixB6);
calc_one_element_ser c4(reset, clk, clk_cnt, matrixC4, matrixA3, matrixB1, matrixA4, matrixB4, matrixA5, matrixB7);
calc_one_element_ser c5(reset, clk, clk_cnt, matrixC5, matrixA3, matrixB2, matrixA4, matrixB5, matrixA5, matrixB8);
calc_one_element_ser c6(reset, clk, clk_cnt, matrixC6, matrixA6, matrixB0, matrixA7, matrixB3, matrixA8, matrixB6);
calc_one_element_ser c7(reset, clk, clk_cnt, matrixC7, matrixA6, matrixB1, matrixA7, matrixB4, matrixA8, matrixB7);
calc_one_element_ser c8(reset, clk, clk_cnt, matrixC8, matrixA6, matrixB2, matrixA7, matrixB5, matrixA8, matrixB8);

//sending output to PO instead of memory
always @(posedge clk)  
begin  
     if(reset) begin  
        data_out <= 0;
     end
     else if (done) begin
          case (out_sel)
  		     0 : data_out <= matrixC0;
  		     1 : data_out <= matrixC1;
  		     2 : data_out <= matrixC2;
  		     3 : data_out <= matrixC3;
  		     4 : data_out <= matrixC4;
  		     5 : data_out <= matrixC5;
  		     6 : data_out <= matrixC6;
  		     7 : data_out <= matrixC7;
  		     8 : data_out <= matrixC8;
                     default: data_out <= matrixC8;
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


//module calc_one_element(out, a0, b0, a1, b1, a2, b2);
//input [`DWIDTH-1:0] a0;
//input [`DWIDTH-1:0] b0;
//input [`DWIDTH-1:0] a1;
//input [`DWIDTH-1:0] b1;
//input [`DWIDTH-1:0] a2;
//input [`DWIDTH-1:0] b2;
//output [2*`DWIDTH-1:0] out;
//
//wire [2*`DWIDTH-1:0] tmp1, tmp2, tmp3, tmp5;
//qmult mult_u1(a0, b0, tmp1);
//qmult mult_u2(a1, b1, tmp2);
//qmult mult_u3(a2, b2, tmp3);
//qadd add_u1(tmp1, tmp2, tmp5);
//qadd add_u2(tmp5, tmp3, out);
//
//endmodule

module calc_one_element_ser(reset, clk, clk_cnt, out, a0, b0, a1, b1, a2, b2);
input [`DWIDTH-1:0] a0;
input [`DWIDTH-1:0] b0;
input [`DWIDTH-1:0] a1;
input [`DWIDTH-1:0] b1;
input [`DWIDTH-1:0] a2;
input [`DWIDTH-1:0] b2;
output [2*`DWIDTH-1:0] out;
input reset;
input clk;
input [1:0] clk_cnt;

reg [`DWIDTH-1:0] mul0;
reg [`DWIDTH-1:0] mul1;
reg [2*`DWIDTH-1:0] add;
reg [2*`DWIDTH-1:0] out;
wire [2*`DWIDTH-1:0] out_mac;

always @(posedge clk) begin
  if (reset) begin
    mul0 <= 0;
    mul1 <= 0;
    add  <= 0;
  end
  else if (clk_cnt == 0) begin
    mul0 <= a0;
    mul1 <= b0;
    add  <= 0;
  end
  else if (clk_cnt == 1) begin
    mul0 <= a1;
    mul1 <= b1;
    add  <= out_mac;
  end
  else if (clk_cnt == 2) begin
    mul0 <= a2;
    mul1 <= b2;
    add  <= out_mac;
  end 
  else if (clk_cnt == 3) begin
    out <= out_mac;
  end
end

mac u_mac(mul0, mul1, add, out_mac);

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

//module mat_mul(a,b,acc,out,clk);
//input [`DWIDTH-1:0] a;
//input [`DWIDTH-1:0] b;
//input [31:0] acc;
//output [31:0] out;
//input clk;
//
//reg [7:0] out_temp0;
//reg [7:0] out_temp1;
//reg [7:0] out_temp2;
//reg [7:0] out_temp3;
//reg [31:0] in_temp;
//
//ram ram(.addr0(addr),
//       	.ce0(1'b1), 
//	.d0(datain), 
//	.we0(we), 
//	.q0(dataout), 
//	.clk(clk));
//
//always @(posedge clk) begin
//    in_temp <= a*b + acc;
//end
//always @(posedge clk) begin
//    out_temp0 <= in_temp[7:0];
//    out_temp1 <= in_temp[15:8];
//    out_temp2 <= in_temp[23:16];
//    out_temp3 <= in_temp[31:24];
//end    
//
//assign out[7:0]   = out_temp0;
//assign out[15:8]  = out_temp1;
//assign out[23:16] = out_temp2;
//assign out[31:24] = out_temp3;
//
//endmodule
