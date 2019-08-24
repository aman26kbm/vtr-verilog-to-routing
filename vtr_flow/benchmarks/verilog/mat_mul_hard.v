`define ADDR_SIZE 9 
`define DATA_SIZE 64

module top(clk,
start,
done_matmul,
done_act,
finalOut
);

input clk;
input start;
output done_matmul;
output done_act;

output [`DATA_SIZE-1:0] finalOut;
wire [`DATA_SIZE-1:0] finalOutC;
wire [`DATA_SIZE-1:0] finalOutD;

wire [`ADDR_SIZE-1:0] out_addrA;
wire out_renA;
wire [`DATA_SIZE-1:0] in_dataA;

wire [`ADDR_SIZE-1:0] out_addrB;
wire out_renB;
wire [`DATA_SIZE-1:0] in_dataB;

wire [`ADDR_SIZE-1:0] out_addrC;
wire out_wenC;
wire [`DATA_SIZE-1:0] out_dataC;

wire [`ADDR_SIZE-1:0] out_addrD;
wire out_wenD;
wire [`DATA_SIZE-1:0] out_dataD;

wire [`ADDR_SIZE-1:0] out_addrE;
wire out_renE;
wire [`DATA_SIZE-1:0] in_dataE;



//Matrix multiplier
mat_mul u_mat_mul(
.clk(clk),
.start(start),
.done(done_matmul),

.out_addrA(out_addrA),
.out_renA(out_renA),
.in_dataA(in_dataA),

.out_addrB(out_addrB),
.out_renB(out_renB),
.in_dataB(in_dataB),

.out_addrC(out_addrC),
.out_wenC(out_wenC),
.out_dataC(out_dataC)
);

wire wen_matA; 
assign wen_matA = ~out_renA;
wire wen_matB;
assign wen_matB = ~out_renB;

//Single port RAM - Matrix A
single_port_ram u_ramA(
.clk(clk),
.we(wen_matA),
.addr(out_addrA),
.data(32'h00000000),
.out(in_dataA)
);

//Single port RAM - Matrix B
single_port_ram u_ramB(
.clk(clk),
.we(wen_matB),
.addr(out_addrB),
.data(32'h00000000),
.out(in_dataB)
);

//Single port RAM - Matrix C
single_port_ram u_ramC(
.clk(clk),
.we(out_wenC),
.addr(out_addrC),
.data(out_dataC),
.out(finalOutC)
);

wire wen_matE; 
assign wen_matE = ~out_renE;

//Single port RAM - Matrix E
single_port_ram u_ramE(
.clk(clk),
.we(wen_matE),
.addr(out_addrE),
.data(32'h00000000),
.out(in_dataE)
);

activations u_act(
.clk(clk),
.start(start),
.done(done_act),
.mode(2'b00),
.in_dataI(in_dataE),
.out_addrI(out_addrE),
.out_renI(out_renE),
.out_addrO(out_addrD),
.out_wenO(out_wenD),
.out_dataO(out_dataD)
);

//Single port RAM - Outputs of activations
single_port_ram u_ramD(
.clk(clk),
.we(out_wenD),
.addr(out_addrD),
.data(out_dataD),
.out(finalOutD)
);

assign finalOut = finalOutC | finalOutD;


endmodule
