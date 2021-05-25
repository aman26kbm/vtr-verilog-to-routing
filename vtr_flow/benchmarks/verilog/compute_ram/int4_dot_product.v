`define COMPUTE_DWIDTH 4
`define NUM 8 
module compute_unit(
  input clk,
  input reset,
  input [`NUM*`COMPUTE_DWIDTH-1:0] inp,
  output [31:0] out
);

reg [`NUM*`COMPUTE_DWIDTH-1:0] input_reg;

always @(posedge clk) begin
    if (reset) begin
        input_reg <= 0;
    end 
    else begin
        input_reg <= inp;
    end    
end

wire [7:0] prod0;
wire [7:0] prod1;
wire [7:0] prod2;
wire [7:0] prod3;

assign prod0 = input_reg[7:4]   * input_reg[3:0];
assign prod1 = input_reg[15:12] * input_reg[11:8];
assign prod2 = input_reg[23:20] * input_reg[19:16];
assign prod3 = input_reg[31:28] * input_reg[27:24];

reg [7:0] prod0_reg;
reg [7:0] prod1_reg;
reg [7:0] prod2_reg;
reg [7:0] prod3_reg;

always @(posedge clk) begin
    if (reset) begin
        prod0_reg <= 0;
        prod1_reg <= 0;
        prod2_reg <= 0;
        prod3_reg <= 0;
    end 
    else begin
        prod0_reg <= prod0;
        prod1_reg <= prod1;
        prod2_reg <= prod2;
        prod3_reg <= prod3;
    end    
end

wire [31:0] add1;
wire [31:0] add2;

assign add1 = prod0_reg + prod1_reg;
assign add2 = prod2_reg + prod3_reg;

reg [31:0] add1_reg;
reg [31:0] add2_reg;

always @(posedge clk) begin
    if (reset) begin
        add1_reg <= 0;
        add2_reg <= 0;
    end 
    else begin
        add1_reg <= add1;
        add2_reg <= add2;
    end    
end

wire [31:0] add3;

assign add3 = add1_reg + add2_reg;

reg [31:0] add3_reg;

always @(posedge clk) begin
    if (reset) begin
        add3_reg <= 0;
    end 
    else begin
        add3_reg <= add3;
    end    
end

assign out = add3_reg;

endmodule
