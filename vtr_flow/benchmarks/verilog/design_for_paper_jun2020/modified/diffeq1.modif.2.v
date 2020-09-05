module diffeq_paj_convert (Xinport, Yinport, Uinport, Aport, DXport, Xoutport, Youtport, Uoutport, clk, reset);
    input[31:0] Xinport; 
    input[31:0] Yinport; 
    input[31:0] Uinport; 
    input[31:0] Aport; 
    input[31:0] DXport; 
    input clk; 
    input reset; 
    output[31:0] Xoutport; 
    output[31:0] Youtport; 
    output[31:0] Uoutport; 
    reg[31:0] Xoutport;
    reg[31:0] Youtport;
    reg[31:0] Uoutport;

      reg[31:0] x_var; 
      reg[31:0] y_var; 
      reg[31:0] u_var; 
      wire[31:0] temp; 
      reg looping; 
 
assign temp = u_var * DXport;
//wire [63:0] out_temp;
//multiplier_32bit u_mult1(.a(u_var), .b(DXport), .out(out_temp));
//assign temp = out_temp[31:0];

//u_var <= (u_var - (temp * 3 * x_var)) - (DXport * 3 * y_var); 
//wire [63:0] out1;
//wire [31:0] const1;
//assign const = 32'd3;
//multiplier_32bit u_mult2(.a(temp), .b(const), .out(out1));
wire [63:0] out2;
//multiplier_32bit u_mult3(.a(out1[31:0]), .b(x_var), .out(out2));
assign out2 = temp * 3 * x_var;
wire [31:0] out5;
assign out5 = ~out2[31:0] + 1;

//wire [63:0] out3;
//multiplier_32bit u_mult4(.a(DXport), .b(const), .out(out3));
wire [63:0] out4;
//multiplier_32bit u_mult5(.a(out3[31:0]), .b(y_var), .out(out4));
assign out4 = DXport * 3 * y_var;
wire [31:0] out6;
assign out6 = ~out4[31:0] + 1;

wire cout0;
wire cout1;
wire [31:0] out7;
wire [31:0] out8;
adder_32bit u_add1(.a(u_var), .b(out5), .cin(1'b0), .sumout(out7), .cout(cout0));
adder_32bit u_add2(.a(out7), .b(out6), .cin(cout0), .sumout(out8), .cout(cout1));

wire[31:0] out9;
wire[31:0] out10;
wire cout2;
wire cout3;
adder_32bit u_add3(.a(y_var), .b(temp), .cin(1'b0), .sumout(out9), .cout(cout2));
adder_32bit u_add4(.a(x_var), .b(DXport), .cin(1'b0), .sumout(out10), .cout(cout3));

    always @(posedge clk)
    begin
		if (reset == 1'b1)
		begin
			looping <= 1'b0;
			x_var <= 0;
         y_var <= 0;
         u_var <= 0;
		end
		else
          if (looping == 1'b0)
          begin
             x_var <= Xinport; 
             y_var <= Yinport; 
             u_var <= Uinport; 
             looping <= 1'b1; 
          end
          else if (x_var < Aport)
          begin
             //u_var <= (u_var - (temp * 3 * x_var)) - (DXport * 3 * y_var); 
             u_var <= out8;
             //y_var <= y_var + temp; 
             y_var <= out9;
             //x_var <= x_var + DXport; 
             x_var <= out10;
			looping <= looping;
          end
          else
          begin
             Xoutport <= x_var ; 
             Youtport <= y_var ; 
             Uoutport <= u_var ; 
             looping <= 1'b0; 
          end 
    end 

endmodule

module adder_32bit(
   input [31:0] a,
   input [31:0] b,
   input cin,
   output [31:0] sumout,
   output cout
);
  
   wire cout0;
   wire cout1;
   wire cout2;

   wire [7:0] sumout0;
   wire [7:0] sumout1;
   wire [7:0] sumout2;
   wire [7:0] sumout3;

   // These adders are 8 bit + 8 bit -> 8 bits
   dsp_adder u_add0(.a(a[7:0]),   .b(b[7:0]),   .cin(cin),   .sumout(sumout0),  .cout(cout0));
   dsp_adder u_add1(.a(a[15:8]),  .b(b[15:8]),  .cin(cout0), .sumout(sumout1),  .cout(cout1));
   dsp_adder u_add2(.a(a[23:16]), .b(b[23:16]), .cin(cout1), .sumout(sumout2), .cout(cout2));
   dsp_adder u_add3(.a(a[31:24]), .b(b[31:24]), .cin(cout2), .sumout(sumout3), .cout(cout));
   assign sumout = {sumout3, sumout2, sumout1, sumout0};

endmodule
/*
module adder_64bit(
   input [63:0] a,
   input [63:0] b,
   input cin,
   output [63:0] sumout,
   output cout
);
  
   wire cout0;
   wire [31:0] sumout0;
   wire [31:0] sumout1;

   adder_32bit u_add0(.a(a[31:0]),   .b(b[31:0]),   .cin(cin),   .sumout(sumout0),   .cout(cout0));
   adder_32bit u_add1(.a(a[63:32]),  .b(b[63:32]),  .cin(cout0), .sumout(sumout1),  .cout(cout));

   assign sumout = {sumout1, sumout0};

endmodule


module adder4_64bit(
   input [63:0] a,
   input [63:0] b,
   input [63:0] c,
   input [63:0] d,
   output [63:0] sumout
);
  
   wire cout0;
   wire cout1;
   wire cout2;

   wire [63:0] ab;
   wire [63:0] cd;
   adder_64bit u_add0(.a(a),   .b(b),   .cin(1'b0),   .sumout(ab),     .cout(cout0));
   adder_64bit u_add1(.a(c),   .b(d),   .cin(1'b0),   .sumout(cd),     .cout(cout1));
   adder_64bit u_add2(.a(ab),  .b(cd),  .cin(1'b0),   .sumout(sumout), .cout(cout2));

endmodule
*/
/*
module multiplier_32bit(
   input [31:0] a,
   input [31:0] b,
   output [63:0] out

);
   //These multipliers are 8 bit * 8 bit -> 16 bits
   wire [15:0] out_row0_mult0;
   wire [15:0] out_row0_mult1;
   wire [15:0] out_row0_mult2;
   wire [15:0] out_row0_mult3;
   dsp_multiply u_mult1(.a(a[7:0]),   .b(b[7:0]), .out(out_row0_mult0));
   dsp_multiply u_mult2(.a(a[15:8]),  .b(b[7:0]), .out(out_row0_mult1));
   dsp_multiply u_mult3(.a(a[23:16]), .b(b[7:0]), .out(out_row0_mult2));
   dsp_multiply u_mult4(.a(a[31:24]), .b(b[7:0]), .out(out_row0_mult3));

   wire [15:0] out_row1_mult0;
   wire [15:0] out_row1_mult1;
   wire [15:0] out_row1_mult2;
   wire [15:0] out_row1_mult3;
   dsp_multiply u_mult5(.a(a[7:0]),   .b(b[15:8]), .out(out_row1_mult0));
   dsp_multiply u_mult6(.a(a[15:8]),  .b(b[15:8]), .out(out_row1_mult1));
   dsp_multiply u_mult7(.a(a[23:16]), .b(b[15:8]), .out(out_row1_mult2));
   dsp_multiply u_mult8(.a(a[31:24]), .b(b[15:8]), .out(out_row1_mult3));

   wire [15:0] out_row2_mult0;
   wire [15:0] out_row2_mult1;
   wire [15:0] out_row2_mult2;
   wire [15:0] out_row2_mult3;
   dsp_multiply u_mult9(.a(a[7:0]),   .b(b[23:16]), .out(out_row2_mult0));
   dsp_multiply u_mult10(.a(a[15:8]),  .b(b[23:16]), .out(out_row2_mult1));
   dsp_multiply u_mult11(.a(a[23:16]), .b(b[23:16]), .out(out_row2_mult2));
   dsp_multiply u_mult12(.a(a[31:24]), .b(b[23:16]), .out(out_row2_mult3));

   wire [15:0] out_row3_mult0;
   wire [15:0] out_row3_mult1;
   wire [15:0] out_row3_mult2;
   wire [15:0] out_row3_mult3;
   dsp_multiply u_mult13(.a(a[7:0]),   .b(b[31:24]), .out(out_row3_mult0));
   dsp_multiply u_mult14(.a(a[15:8]),  .b(b[31:24]), .out(out_row3_mult1));
   dsp_multiply u_mult15(.a(a[23:16]), .b(b[31:24]), .out(out_row3_mult2));
   dsp_multiply u_mult16(.a(a[31:24]), .b(b[31:24]), .out(out_row3_mult3));

   wire [63:0] sum0;
   wire [63:0] sum1;
   wire [63:0] sum2;
   wire [63:0] sum3;

   //This needs to be optimized. I am being lazy right now and using all 64 bit adders.
   adder4_64bit u_add1(.a({48'b0, out_row0_mult0}),      .b({40'b0,out_row1_mult0,8'b0}),  .c({32'b0,out_row2_mult0,16'b0}), .d({24'b0,out_row3_mult0,24'b0}), .sumout(sum0));
   adder4_64bit u_add2(.a({40'b0,out_row0_mult1,8'b0}),  .b({32'b0,out_row1_mult1,16'b0}), .c({24'b0,out_row2_mult1,24'b0}), .d({16'b0,out_row3_mult1,32'b0}), .sumout(sum1));
   adder4_64bit u_add3(.a({32'b0,out_row0_mult0,16'b0}), .b({24'b0,out_row1_mult0,24'b0}), .c({16'b0,out_row2_mult0,32'b0}), .d({8'b0,out_row3_mult0,40'b0}), .sumout(sum2));
   adder4_64bit u_add4(.a({24'b0,out_row0_mult0,24'b0}), .b({16'b0,out_row1_mult0,32'b0}), .c({8'b0,out_row2_mult0,40'b0}),  .d({out_row3_mult0,48'b0}), .sumout(sum3));
   adder4_64bit u_add5(.a(sum0), .b(sum1), .c(sum2), .d(sum3), .sumout(out));

endmodule   
*/
/*
module dsp_adder(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sumout,
    output cout
);
endmodule

module dsp_multiply(
    input [7:0] a,
    input [7:0] b,
    output [15:0] out
);
endmodule
*/