module just_mac(clk, reset,  i_multiplicand, i_multiplier, i_add, o_result);
  input clk;
  input reset;
  input [15:0] i_multiplicand;
  input [15:0] i_multiplier;
  input [31:0] i_add;
  output [31:0] o_result;

  reg [15:0] i_multiplicand_reg;
  reg [15:0] i_multiplier_reg;
  reg [31:0] i_add_reg;
  reg [31:0] o_result;
  wire [31:0] o_result_tmp;

  always @(posedge clk) begin 
    if (reset) begin
      o_result <= 0;
      i_multiplicand_reg <= 0;
      i_multiplier_reg <= 0;
      i_add_reg <= 0;
    end else begin
      o_result <= o_result_tmp;
      i_multiplicand_reg <= i_multiplicand;
      i_multiplier_reg <= i_multiplier;
      i_add_reg <= i_add;
    end
  end  

  DW02_mac #(16,16) u_mult(.A(i_multiplicand_reg), .B(i_multiplier_reg), .C(i_add_reg), .TC(1'b0), .MAC(o_result_tmp));

endmodule  

