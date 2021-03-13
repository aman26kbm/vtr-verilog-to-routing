module top(
input clk,
input reset,
input [8:0] a,
input [8:0] b,
input [8:0] c,
input [8:0] d,
input [8:0] e,
input [8:0] f,
input [8:0] g,
input [8:0] h,
input [8:0] i,
input [8:0] j,
input [8:0] k,
input [8:0] l,
input [8:0] m,
input [8:0] n,
input [8:0] o,
input [8:0] p,
output [63:0] result
);

wire [63:0] chainin_dsp_1;
wire [63:0] result_dsp_1;
wire [63:0] chainout_dsp_1;

wire [63:0] chainin_dsp_2;
wire [63:0] result_dsp_2;
wire [63:0] chainout_dsp_2;

assign chainin_dsp_1 = 64'b0;

wire [10:0] mode;
assign mode = 11'b1010_1010_011;

int_sop_4 u_dsp_1(
.clk(clk),
.reset(reset),
.mode_sigs(mode),
.ax(a),
.ay(b),
.bx(c),
.by(d),
.cx(e),
.cy(f),
.dx(g),
.dy(h),
.chainin(chainin_dsp_1),
.resulta(result_dsp_1),
.chainout(chainout_dsp_1));

assign chainin_dsp_2 = chainout_dsp_1;

int_sop_4 u_dsp_2(
.clk(clk),
.reset(reset),
.mode_sigs(mode),
.ax(i),
.ay(j),
.bx(k),
.by(l),
.cx(m),
.cy(n),
.dx(o),
.dy(p),
.chainin(chainin_dsp_2),
.resulta(result_dsp_2),
.chainout(chainout_dsp_2));

assign result = result_dsp_2;

endmodule
