`define EXPONENT 5
`define MANTISSA 10
`define SIGN 1
`define DWIDTH (`SIGN+`EXPONENT+`MANTISSA)
`define IEEE_COMPLIANCE 1

module fpadder(
        clk,
        reset,
        ax,
        ay,
        result
        );

  input clk;
  input reset;
  input [`DWIDTH-1:0] ax;
  input [`DWIDTH-1:0] ay;
  output [`DWIDTH-1:0] result;


  FPAddSub u_add(.clk(clk), .rst(reset), .a(ax), .b(ay), .operation(1'b0), .result(result), .flags());



endmodule

