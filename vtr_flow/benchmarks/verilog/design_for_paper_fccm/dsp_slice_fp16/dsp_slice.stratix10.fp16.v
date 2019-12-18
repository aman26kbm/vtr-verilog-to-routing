`define EXPONENT 5
`define MANTISSA 10
`define SIGN 1
`define DWIDTH (`SIGN+`EXPONENT+`MANTISSA)
`define IEEE_COMPLIANCE 1

module dsp_slice(
        clk,
        reset,
        ax,
        ay,
        az,
        carry_in,
        carry_out,
        result,
        multiply,
        accumulate
        );

  input clk;
  input reset;
  input [`DWIDTH-1:0] ax;
  input [`DWIDTH-1:0] ay;
  input [`DWIDTH-1:0] az;
  input carry_in;
  output carry_out;
  output [`DWIDTH-1:0] result;
  input multiply;
  input accumulate;

  //reg [`DWIDTH-1:0] ax_flopped;
  //reg [`DWIDTH-1:0] ay_flopped;
  //reg [`DWIDTH-1:0] az_flopped;

  //always @(posedge clk) begin 
  //  if (reset) begin
  //    ax_flopped <= 0;
  //    ay_flopped <= 0;
  //    az_flopped <= 0;
  //  end else begin
  //    ax_flopped <= ax;
  //    ay_flopped <= ay;
  //    az_flopped <= az;
  //  end
  //end  

  wire [`DWIDTH-1:0] inp_a_mult;
  wire [`DWIDTH-1:0] inp_b_mult;
  wire [`DWIDTH-1:0] out_mult;

  //assign inp_a_mult = ay_flopped;
  //assign inp_b_mult = az_flopped;
  assign inp_a_mult = ay;
  assign inp_b_mult = az;
  
  //DW_fp_mult #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) u_mult (.a(inp_a_mult), .b(inp_b_mult), .rnd(3'b000), .z(out_mult), .status());
  FPMult u_mult(.clk(clk), .rst(reset), .a(inp_a_mult), .b(inp_b_mult), .result(out_mult), .flags());

  //reg [`DWIDTH-1:0] out_mult_reg;

  //always @(posedge clk) begin
  //  if (reset) begin
  //    out_mult_reg <= 0;
  //  end else begin
  //    out_mult_reg <= out_mult;
  //  end
  //end

  wire [`DWIDTH-1:0] mux1_out;
  //assign mux1_out = accumulate ? out_mult_reg: ay_flopped;
  assign mux1_out = accumulate ? out_mult: ay;

  //reg [`DWIDTH-1:0] mux1_out_reg;
  //always @(posedge clk) begin
  //  if (reset) begin
  //    mux1_out_reg <= 0;
  //  end else begin
  //    mux1_out_reg <= mux1_out;
  //  end
  //end

  //reg [`DWIDTH-1:0] ax_flopped_reg;
  //always @(posedge clk) begin
  //  if (reset) begin
  //    ax_flopped_reg <= 0;
  //  end else begin
  //    ax_flopped_reg <= ax_flopped;
  //  end
  //end

  wire [`DWIDTH-1:0] mux2_out;
  reg [`DWIDTH-1:0] mux3_out_reg;
  assign mux2_out = accumulate ? mux3_out_reg : ax;

  wire [`DWIDTH-1:0] inp_a_adder;
  wire [`DWIDTH-1:0] inp_b_adder;
  wire [`DWIDTH-1:0] out_adder;

  assign inp_a_adder = mux2_out;
  assign inp_b_adder = mux1_out;

  //DW_fp_add #(`MANTISSA, `EXPONENT, `IEEE_COMPLIANCE) u_add(.a(inp_a_adder), .b(inp_b_adder), .z(out_adder),     .rnd(3'b000),    .status());
  FPAddSub u_add(.clk(clk), .rst(reset), .a(inp_a_adder), .b(inp_b_adder), .operation(1'b0), .result(out_adder), .flags());

  wire [`DWIDTH-1:0] mux3_out;
  //assign mux3_out = multiply ? out_mult_reg: out_adder;
  assign mux3_out = multiply ? out_mult: out_adder;

  always @(posedge clk) begin 
    if (reset) begin
      mux3_out_reg <= 0;
    end else begin
      mux3_out_reg <= mux3_out;
    end
  end

  assign result = mux3_out_reg;

endmodule
