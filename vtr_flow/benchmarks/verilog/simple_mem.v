module ram (addr0, d0, we0, q0,  clk);

parameter DWIDTH = 16;
parameter AWIDTH = 10;
parameter MEM_SIZE = 1024;

input [AWIDTH-1:0] addr0;
input [DWIDTH-1:0] d0;
input we0;
output [DWIDTH-1:0] q0;
input clk;

//reg [DWIDTH-1:0] q0;
reg [DWIDTH-1:0] ram[MEM_SIZE-1:0];


always @(posedge clk)  
begin 
        if (we0) 
        begin 
            ram[addr0] <= d0; 
	end
end
assign q0 = ram[addr0];

endmodule

module top(clk, wen, data_in, data_out, address);
      input clk;
      input reset;
      input wen;
      input [15:0] data_in;
      input [9:0] address;
      output [15:0] data_out;  
      ram matrix_out_u(
      	.addr0(address),
	.d0(data_in), 
	.we0(wen), 
	.q0(data_out), 
	.clk(clk));      
endmodule
