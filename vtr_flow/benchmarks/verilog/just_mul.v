module just_mul(clk, reset,  i_multiplicand, i_multiplier, o_result);
  input clk;
  input reset;
  input [15:0] i_multiplicand;
  input [15:0] i_multiplier;
  output [31:0] o_result;

  reg [15:0] i_multiplicand_reg;
  reg [15:0] i_multiplier_reg;
  reg [31:0] o_result;
  wire [31:0] o_result_tmp;

  always @(posedge clk) begin 
    if (reset) begin
      o_result <= 0;
      i_multiplicand_reg <= 0;
      i_multiplier_reg <= 0;
    end else begin
      o_result <= o_result_tmp;
      i_multiplicand_reg <= i_multiplicand;
      i_multiplier_reg <= i_multiplier;
    end
  end  

  DW02_mult #(16,16) u_mult(.A(i_multiplicand_reg), .B(i_multiplier_reg), .TC(1'b0), .PRODUCT(o_result_tmp));

endmodule  
