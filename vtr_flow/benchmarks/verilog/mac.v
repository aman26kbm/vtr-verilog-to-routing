module mac(a,b,c,d, clk, reset);
  input [15:0] a;
  input [15:0] b;
  input [15:0] c;
  output [15:0] d;
  input clk;
  input reset;

  reg [15:0] d;

  wire [15:0] temp1;
  wire [15:0] temp2;
  assign temp1 = a + b;
  assign temp2 = temp1;

  always @(posedge clk) begin
    if (reset) begin
      d <= 0;
    end else begin 
      d <= temp2;
    end
  end
endmodule

