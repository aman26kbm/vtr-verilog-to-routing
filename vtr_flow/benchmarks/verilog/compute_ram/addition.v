/*
`define DWIDTH 4
`define NUM 3

module int4_additions(
    input [`NUM*`DWIDTH-1:0] in1,
    input [`NUM*`DWIDTH-1:0] in2,
    output [`NUM*(`DWIDTH+1)-1:0] out
);

genvar i;
generate
    for (i=0; i<`NUM; i=i+1) begin
        assign out[(i*(`DWIDTH+1)) +: `DWIDTH] = in1[i*`DWIDTH +: `DWIDTH] + in2[i*`DWIDTH +: `DWIDTH];
    end
endgenerate

endmodule
*/
/*
`define COMPUTE_DWIDTH 8
`define COMPUTE_LATENCY 2
module compute_unit(
  input clk,
  input reset,
  input [`COMPUTE_DWIDTH-1:0] input1,
  input [`COMPUTE_DWIDTH-1:0] input2,
  output reg [`COMPUTE_DWIDTH:0] out
);

reg [`COMPUTE_DWIDTH-1:0] input1_reg;
reg [`COMPUTE_DWIDTH-1:0] input2_reg;

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
        input1_reg <= 0;
        input2_reg <= 0;
    end 
    else begin
        input1_reg <= input1;
        input2_reg <= input2;
        out <= input1_reg + input2_reg;
    end    
end

endmodule
*/

module compute_unit(
  input clk,
  input reset,
  input [23:0] input1,
  input [23:0] input2,
  output reg [26:0] out
);

reg [23:0] input1_reg;
reg [23:0] input2_reg;

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
        input1_reg <= 0;
        input2_reg <= 0;
    end 
    else begin
        input1_reg <= input1;
        input2_reg <= input2;
        out[8:0] <= input1_reg[7:0] + input2_reg[7:0];
        out[17:9] <= input1_reg[15:8] + input2_reg[15:8];
        out[26:18] <= input1_reg[23:16] + input2_reg[23:16];
    end    
end

endmodule