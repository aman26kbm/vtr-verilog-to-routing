`define BRAM_DWIDTH 40
`define BRAM_AWIDTH 9
`define BRAM_DEPTH 512
`define COMPUTE_DWIDTH 8
`define COMPUTE_LATENCY 2

module system(
  input clk,
  input reset,
  input start,
  output done,
  input external,
  input bram_sel,
  input  [`BRAM_AWIDTH-1:0] bram_addr_ext,
  output [`BRAM_DWIDTH-1:0] bram_rdata_ext,
  input  [`BRAM_DWIDTH-1:0] bram_wdata_ext,
  input  bram_wren_ext,
  input [`BRAM_AWIDTH-1:0] bram_start_addr_for_inputs,
  input [`BRAM_AWIDTH-1:0] bram_start_addr_for_outputs
);

//addr mux
//one port on bram (a) is used by both external inputs and for writing results
//second port on bram (b) is used for reading inputs

wire [`BRAM_AWIDTH-1:0] bram_addr_a;
wire [`BRAM_AWIDTH-1:0] bram_addr_a_internal;
wire [`BRAM_AWIDTH-1:0] bram_addr_b;
wire [`BRAM_AWIDTH-1:0] bram_addr_b_internal;
wire [`BRAM_DWIDTH-1:0] bram_rdata_a;
wire [`BRAM_DWIDTH-1:0] bram_rdata_a_internal;
wire [`BRAM_DWIDTH-1:0] bram_rdata_b;
wire [`BRAM_DWIDTH-1:0] bram_rdata_b_internal;
wire [`BRAM_DWIDTH-1:0] bram_wdata_a;
wire [`BRAM_DWIDTH-1:0] bram_wdata_a_internal;
wire [`BRAM_DWIDTH-1:0] bram_wdata_b;
wire [`BRAM_DWIDTH-1:0] bram_wdata_b_internal;
wire bram_wren_a;
wire bram_wren_a_internal;
wire bram_wren_b;
wire bram_wren_b_internal;

wire [`COMPUTE_DWIDTH-1:0] input1;
wire [`COMPUTE_DWIDTH-1:0] input2;
wire [`COMPUTE_DWIDTH:0] out;

assign bram_wren_a = (external & bram_sel) ? bram_wren_ext : bram_wren_a_internal;
assign bram_wdata_a = (external & bram_sel) ? bram_wdata_ext : bram_wdata_a_internal;
assign bram_addr_a = (external & bram_sel) ? bram_addr_ext : bram_addr_a_internal;
assign bram_rdata_a_internal = bram_rdata_a;

assign bram_wren_b = (external & ~bram_sel) ? bram_wren_ext : bram_wren_b_internal;
assign bram_wdata_b = (external & ~bram_sel) ? bram_wdata_ext : bram_wdata_b_internal;
assign bram_addr_b = (external & ~bram_sel) ? bram_addr_ext : bram_addr_b_internal;
assign bram_wdata_b_internal = 0;
assign bram_wren_b_internal = 0;
assign bram_rdata_b_internal = bram_rdata_b;

assign bram_rdata_ext = bram_sel ? bram_rdata_a_internal : bram_rdata_b_internal;

//instantiate bram
dpram u_ram(
    .clk(clk),
    .address_a(bram_addr_a),
    .address_b(bram_addr_b),
    .wren_a(bram_wren_a),
    .wren_b(bram_wren_b),
    .data_a(bram_wdata_a),
    .data_b(bram_wdata_b),
    .out_a(bram_rdata_a),
    .out_b(bram_rdata_b)
    );


endmodule



module dpram (	
input clk,
input [`BRAM_AWIDTH-1:0] address_a,
input [`BRAM_AWIDTH-1:0] address_b,
input  wren_a,
input  wren_b,
input [`BRAM_DWIDTH-1:0] data_a,
input [`BRAM_DWIDTH-1:0] data_b,
output reg [`BRAM_DWIDTH-1:0] out_a,
output reg [`BRAM_DWIDTH-1:0] out_b
);


`ifdef VCS 

reg [`BRAM_DWIDTH-1:0] ram[`BRAM_DEPTH-1:0];

always @ (posedge clk) begin 
  if (wren_a) begin
      ram[address_a] <= data_a;
  end
  else begin
      out_a <= ram[address_a];
  end
end
  
always @ (posedge clk) begin 
  if (wren_b) begin
      ram[address_b] <= data_b;
  end 
  else begin
      out_b <= ram[address_b];
  end
end

`else

dual_port_ram u_dual_port_ram(
.addr1(address_a),
.we1(wren_a),
.data1(data_a),
.out1(out_a),
.addr2(address_b),
.we2(wren_b),
.data2(data_b),
.out2(out_b),
.clk(clk)
);

`endif

`ifdef VCS
initial begin
  $vcdpluson;
  $vcdplusmemon;
end
`endif

endmodule

