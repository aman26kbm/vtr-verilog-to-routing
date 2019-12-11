`define EXPONENT 5
`define MANTISSA 10
`define SIGN 1
`define DWIDTH (`SIGN+`EXPONENT+`MANTISSA)
`define IEEE_COMPLIANCE 1
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
  output [`DWIDTH-1:0] c_out;
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
  wire [`DWIDTH-1:0] out_mult;
  wire [`DWIDTH-1:0] out_mult_temp;

  assign inp_a_mult = mode[1] ? a_in : a_in_flopped;
  assign inp_b_mult = mode[1] ? b_in : b_in_flopped;
  
  DW_fp_mult #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) u_mult (.a(inp_a_mult), .b(inp_b_mult), .rnd(3'b000), .z(out_mult_temp), .status());
  //DW02_mult #(`DWIDTH,`DWIDTH) u_mult(.A(inp_a_mult), .B(inp_b_mult), .TC(1'b1), .PRODUCT(out_mult_temp));

  //No downcasting required
  assign out_mult = out_mult_temp;

  wire [`DWIDTH-1:0] inp_a_adder;
  wire [`DWIDTH-1:0] inp_b_adder;
  wire [`DWIDTH-1:0] out_adder;
  reg [`DWIDTH-1:0] out_accumulator;
  reg [`DWIDTH-1:0] out_mult_reg;

  always @(posedge clk) begin
    if (reset) begin
      out_mult_reg <= 0;
    end else begin
      out_mult_reg <= out_mult;
    end
  end

  assign inp_a_adder = mode[0] ? a_in : out_mult_reg;
  assign inp_b_adder = mode[0] ? b_in : out_accumulator;

  DW_fp_add #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) u_add(.a(inp_a_adder), .b(inp_b_adder), .z(out_adder),     .rnd(3'b000),    .status());
  //DW01_add #(`DWIDTH) u_add(.A(inp_a_adder), .B(inp_b_adder), .CI(carry_in), .SUM(out_adder), .CO(carry_out));

  always @(posedge clk) begin 
    if (reset) begin
      out_accumulator <= 0;
    end else begin
      out_accumulator <= out_adder;
    end
  end

  assign c_out = mode[0] ? out_adder : (mode[1] ? out_mult : out_accumulator);

endmodule
