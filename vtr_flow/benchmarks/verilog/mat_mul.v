
`define DWIDTH 16
`define AWIDTH 4
`define MEM_SIZE 16

module matrix_multiply_teOg_ram (addr0, d0, we0, q0,  clk);

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

/*
module qmult(i_multiplicand,i_multiplier,o_result);
input [`DWIDTH-1:0] i_multiplicand;
input [`DWIDTH-1:0] i_multiplier;
output [`DWIDTH-1:0] o_result;

assign o_result = i_multiplicand * i_multiplier;

endmodule

module qadd(a,b,c);
input [`DWIDTH-1:0] a;
input [`DWIDTH-1:0] b;
output [`DWIDTH-1:0] c;

assign c = a + b;
endmodule
*/

module matrix_multiplication(clk, reset, we1, we2, start, data_pi, addr_pi, data_out);
      input clk;
      input reset;
      input we1;  
      input we2;  
      input start;
      input [`DWIDTH-1:0] data_pi;
      input [`AWIDTH-1:0] addr_pi;
      output [`DWIDTH-1:0] data_out;  

 wire [`DWIDTH-1:0] mat_A;  
 wire [`DWIDTH-1:0] mat_B;  
 reg wen;  
 reg [`DWIDTH-1:0] data_in;  
 reg [`AWIDTH-1:0] addr;  
 reg [`AWIDTH-1:0] address;  
 reg [`DWIDTH-1:0] matrixA0;
 reg [`DWIDTH-1:0] matrixA1;
 reg [`DWIDTH-1:0] matrixA2;
 reg [`DWIDTH-1:0] matrixA3;
 reg [`DWIDTH-1:0] matrixA4;
 reg [`DWIDTH-1:0] matrixA5;
 reg [`DWIDTH-1:0] matrixA6;
 reg [`DWIDTH-1:0] matrixA7;
 reg [`DWIDTH-1:0] matrixA8;
 reg [`DWIDTH-1:0] matrixA9;
 reg [`DWIDTH-1:0] matrixB0;
 reg [`DWIDTH-1:0] matrixB1;
 reg [`DWIDTH-1:0] matrixB2;
 reg [`DWIDTH-1:0] matrixB3;
 reg [`DWIDTH-1:0] matrixB4;
 reg [`DWIDTH-1:0] matrixB5;
 reg [`DWIDTH-1:0] matrixB6;
 reg [`DWIDTH-1:0] matrixB7;
 reg [`DWIDTH-1:0] matrixB8;
 reg [`DWIDTH-1:0] matrixC0;
 reg [`DWIDTH-1:0] matrixC1;
 reg [`DWIDTH-1:0] matrixC2;
 reg [`DWIDTH-1:0] matrixC3;
 reg [`DWIDTH-1:0] matrixC4;
 reg [`DWIDTH-1:0] matrixC5;
 reg [`DWIDTH-1:0] matrixC6;
 reg [`DWIDTH-1:0] matrixC7;
 reg [`DWIDTH-1:0] matrixC8;


reg [`AWIDTH-1:0] addr_pi_temp;
reg [`DWIDTH-1:0] data_pi_temp;

// BRAM matrix A  
matrix_multiply_teOg_ram matrix_A_u (
  .addr0(addr),
  .d0(data_pi_temp), 
  .we0(we1), 
  .q0(mat_A), 
  .clk(clk));

// BRAM matrix B  
matrix_multiply_teOg_ram matrix_B_u(
  .addr0(addr),
  .d0(data_pi_temp), 
  .we0(we2), 
  .q0(mat_B), 
  .clk(clk));
        
always @(posedge clk)  
begin  
     if(reset) begin  
        addr <= 0;  
     end  
     else if (!start) begin
        addr<= addr_pi;
        data_pi_temp <= data_pi;
     end
     else begin  
          if(addr<`MEM_SIZE)   
          addr <= addr + 1;  
          else  
          addr <= addr;  

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

always @(posedge clk)  
begin  
     if(reset) begin  
  	   matrixC0 <= 0;
  	   matrixC1 <= 0;
  	   matrixC2 <= 0;
  	   matrixC3 <= 0;
  	   matrixC4 <= 0;
  	   matrixC5 <= 0;
  	   matrixC6 <= 0;
  	   matrixC7 <= 0;
  	   matrixC8 <= 0;
     end
     else begin
  	   matrixC0 <= matrixA0*matrixB0 + matrixA1*matrixB3 + matrixA2*matrixB6;
  	   matrixC1 <= matrixA0*matrixB1 + matrixA1*matrixB4 + matrixA2*matrixB7;
  	   matrixC2 <= matrixA0*matrixB2 + matrixA1*matrixB5 + matrixA2*matrixB8;
  	   matrixC3 <= matrixA3*matrixB0 + matrixA4*matrixB3 + matrixA5*matrixB6;
  	   matrixC4 <= matrixA3*matrixB1 + matrixA4*matrixB4 + matrixA5*matrixB7;
  	   matrixC5 <= matrixA3*matrixB2 + matrixA4*matrixB5 + matrixA5*matrixB8;
  	   matrixC6 <= matrixA6*matrixB0 + matrixA7*matrixB3 + matrixA8*matrixB6;
  	   matrixC7 <= matrixA6*matrixB0 + matrixA7*matrixB3 + matrixA8*matrixB6;
  	   matrixC8 <= matrixA6*matrixB0 + matrixA7*matrixB3 + matrixA8*matrixB6;
     end
end



always @(posedge clk)  
begin  
     if(reset) begin  
          address <= 0;  
          wen <= 0;  
          end  
     else begin  
          address <= address + 1;  
          if(address<`MEM_SIZE) begin  
               wen <= 1;  
  	     case (address)
  		     0 : data_in <= matrixC0;
  		     1 : data_in <= matrixC1;
  		     2 : data_in <= matrixC2;
  		     3 : data_in <= matrixC3;
  		     4 : data_in <= matrixC4;
  		     5 : data_in <= matrixC5;
  		     6 : data_in <= matrixC6;
  		     7 : data_in <= matrixC7;
  		     8 : data_in <= matrixC8;
  	     endcase 
          end  
          else  
          begin  
               wen <= 0;            
          end  
     end  
end  

// BRAM matrix C  
matrix_multiply_teOg_ram matrix_out_u(
  .addr0(address),
  .d0(data_in), 
  .we0(wen), 
  .q0(data_out), 
  .clk(clk));      

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
//matrix_multiply_teOg_ram ram(.addr0(addr),
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
