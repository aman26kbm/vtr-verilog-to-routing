
`timescale 1ns/1ns

module top(clk, reset, bin1, bin2, bin3, aout);

 input clk;
 input reset;
 input [3:0] bin1;
 input [3:0] bin2;
 input [3:0] bin3;
 output [3:0] aout;

 wire [3:0] aout_temp1;
 wire [3:0] aout_temp2;

myblock u_blk1(
 .clk(clk),
 .reset(reset),
 .b_data(bin1),
 .a_data_in(4'b0),
 .a_data_out(aout_temp1)
);
  

myblock u_blk2(
 .clk(clk),
 .reset(reset),
 .b_data(bin2),
 .a_data_in(aout_temp1),
 .a_data_out(aout_temp2)
);

myblock u_blk3(
 .clk(clk),
 .reset(reset),
 .b_data(bin3),
 .a_data_in(aout_temp2),
 .a_data_out(aout)
);

endmodule
