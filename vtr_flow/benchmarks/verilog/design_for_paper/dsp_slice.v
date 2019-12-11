`define DWIDTH 16
module dsp_slice(
        clk,
        reset,
        a_in,
        b_in,
        carry_in,
        carry_out,
        c_out,
        mode
        );
  input clk;
  input reset;
  input [`DWIDTH-1:0] a_in;
  input [`DWIDTH-1:0] b_in;
  input carry_in;
  output carry_out;
  output [2*`DWIDTH-1:0] c_out;
  input [2:0] mode;  // 001 = adder, 010 = mul, 100 = mac


  reg [`DWIDTH-1:0] a_in_flopped;
  reg [`DWIDTH-1:0] b_in_flopped;

  always @(posedge clk) begin 
    if (reset) begin
      a_in_flopped <= 0;
      b_in_flopped <= 0;
    end else begin
      a_in_flopped <= a_in;
      b_in_flopped <= b_in;
    end
  end  

  wire [`DWIDTH-1:0] inp_a_mult;
  wire [`DWIDTH-1:0] inp_b_mult;
  wire [2*`DWIDTH-1:0] out_mult;

  assign inp_a_mult = mode[1] ? a_in : a_in_flopped;
  assign inp_b_mult = mode[1] ? b_in : b_in_flopped;
  
  DW02_mult #(16,16) u_mult(.A(inp_a_mult), .B(inp_b_mult), .TC(1'b0), .PRODUCT(out_mult));

  wire [2*`DWIDTH-1:0] inp_a_adder;
  wire [2*`DWIDTH-1:0] inp_b_adder;
  wire [2*`DWIDTH-1:0] out_adder;
  reg [2*`DWIDTH-1:0] out_accumulator;

  assign inp_a_adder = mode[0] ? {{`DWIDTH{1'b0}},a_in} : out_mult;
  assign inp_b_adder = mode[0] ? {{`DWIDTH{1'b0}},b_in} : out_accumulator;

  DW01_add #(32) u_add(.A(inp_a_adder), .B(inp_b_adder), .CI(carry_in), .SUM(out_adder), .CO(carry_out));

  always @(posedge clk) begin 
    if (reset) begin
      out_accumulator <= 0;
    end else begin
      out_accumulator <= out_adder;
    end
  end

  assign c_out = mode[0] ? out_adder : (mode[1] ? out_mult : out_accumulator);

endmodule
