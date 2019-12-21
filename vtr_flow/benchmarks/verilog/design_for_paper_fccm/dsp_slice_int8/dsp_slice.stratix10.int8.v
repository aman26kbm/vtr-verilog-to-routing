`define DWIDTH 8

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

  reg [`DWIDTH-1:0] ax_flopped;
  reg [`DWIDTH-1:0] ay_flopped;
  reg [`DWIDTH-1:0] az_flopped;

  always @(posedge clk) begin 
    if (reset) begin
      ax_flopped <= 0;
      ay_flopped <= 0;
      az_flopped <= 0;
    end else begin
      ax_flopped <= ax;
      ay_flopped <= ay;
      az_flopped <= az;
    end
  end  

  wire [`DWIDTH-1:0] inp_a_mult;
  wire [`DWIDTH-1:0] inp_b_mult;
  wire [`DWIDTH-1:0] out_mult;
  wire [2*`DWIDTH-1:0] out_mult_temp;

  assign inp_a_mult = ay_flopped;
  assign inp_b_mult = az_flopped;
  
  DW02_mult #(`DWIDTH,`DWIDTH) u_mult(.A(inp_a_mult), .B(inp_b_mult), .TC(1'b1), .PRODUCT(out_mult_temp));
  //assign out_mult_temp = inp_a_mult * inp_b_mult;

  reg [2*`DWIDTH-1:0] out_mult_temp_reg;

  always @(posedge clk) begin
    if (reset) begin
      out_mult_temp_reg <= 0;
    end else begin
      out_mult_temp_reg <= out_mult_temp;
    end
  end

  //down cast the result of multiplication
  assign out_mult = 
    (out_mult_temp_reg[2*`DWIDTH-1] == 0) ?  //positive number
        (
           (|(out_mult_temp_reg[2*`DWIDTH-2 : `DWIDTH-1])) ?  //is any bit from 14:7 is 1, that means overlfow
             {out_mult_temp_reg[2*`DWIDTH-1] , {(`DWIDTH-1){1'b1}}} : //sign bit and then all 1s
             {out_mult_temp_reg[2*`DWIDTH-1] , out_mult_temp_reg[`DWIDTH-2:0]} 
        )
        : //negative number
        (
           (|(out_mult_temp_reg[2*`DWIDTH-2 : `DWIDTH-1])) ?  //is any bit from 14:7 is 0, that means overlfow
             {out_mult_temp_reg[2*`DWIDTH-1] , out_mult_temp_reg[`DWIDTH-2:0]} :
             {out_mult_temp_reg[2*`DWIDTH-1] , {(`DWIDTH-1){1'b0}}} //sign bit and then all 0s
        );



  wire [`DWIDTH-1:0] mux1_out;
  assign mux1_out = accumulate ? out_mult: ay_flopped;

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
  assign mux2_out = accumulate ? mux3_out_reg : ax_flopped;

  wire [`DWIDTH-1:0] inp_a_adder;
  wire [`DWIDTH-1:0] inp_b_adder;
  wire [`DWIDTH-1:0] out_adder;

  assign inp_a_adder = mux2_out;
  assign inp_b_adder = mux1_out;

  DW01_add #(`DWIDTH) u_add(.A(inp_a_adder), .B(inp_b_adder), .CI(carry_in), .SUM(out_adder), .CO(carry_out));
  //assign out_adder = inp_a_adder * inp_b_adder;

  wire [`DWIDTH-1:0] mux3_out;
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
