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

//instantiate control logic
control_logic u_ctrl(
  .clk(clk),
  .reset(reset),
  .start(start),
  .done(done),
  .bram_start_addr_for_inputs(bram_start_addr_for_inputs),
  .bram_addr_for_inputs(bram_addr_b_internal),
  .bram_data_inputs(bram_rdata_b_internal),
  .bram_start_addr_for_outputs(bram_start_addr_for_outputs),
  .bram_addr_for_outputs(bram_addr_a_internal),
  .bram_data_outputs(bram_wdata_a_internal),
  .bram_we(bram_wren_a_internal),
  .input1(input1),
  .input2(input2),
  .out(out)
);

//instantiate cu
compute_unit u_cu(
    .clk(clk),
    .reset(reset),
    .input1(input1),
    .input2(input2),
    .out(out)
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

module control_logic(
  input clk,
  input reset,
  input start,
  output reg done,
  
  //bram interface
  input  [`BRAM_AWIDTH-1:0] bram_start_addr_for_inputs,
  output reg [`BRAM_AWIDTH-1:0] bram_addr_for_inputs,
  input  [`BRAM_DWIDTH-1:0] bram_data_inputs,
  input  [`BRAM_AWIDTH-1:0] bram_start_addr_for_outputs,
  output reg [`BRAM_AWIDTH-1:0] bram_addr_for_outputs,
  output [`BRAM_DWIDTH-1:0] bram_data_outputs,
  output reg bram_we,
  
  //interface with adder/multiplier
  output [`COMPUTE_DWIDTH-1:0] input1,
  output [`COMPUTE_DWIDTH-1:0] input2,
  input  [`COMPUTE_DWIDTH-1:0] out
);

reg [9:0] clk_cnt;
wire [9:0] clk_cnt_for_done;
assign clk_cnt_for_done = 512;

always @(posedge clk) begin
  if (reset || ~start) begin
    clk_cnt <= 0;
    done <= 0;
  end
  else if (clk_cnt == clk_cnt_for_done) begin
    done <= 1;
    clk_cnt <= clk_cnt + 1;
  end
  else if (done == 0) begin
    clk_cnt <= clk_cnt + 1;
  end    
  else begin
    done <= 0;
    clk_cnt <= clk_cnt + 1;
  end
end

//Reading inputs from BRAM
always @(posedge clk) begin
  if ((reset || ~start)) begin
    bram_addr_for_inputs <= bram_start_addr_for_inputs;
  end
  else begin
    bram_addr_for_inputs <= bram_addr_for_inputs + 1;
  end
end  

wire [`COMPUTE_DWIDTH-1:0] input1_internal;
wire [`COMPUTE_DWIDTH-1:0] input2_internal;
reg  [`COMPUTE_DWIDTH-1:0] out_internal;

assign input1 = bram_data_inputs[7:0];
assign input2 = bram_data_inputs[15:8];

//Writing results to BRAM
always @(posedge clk) begin
  if ((reset || ~start || (clk_cnt < `COMPUTE_LATENCY))) begin
    bram_addr_for_outputs <= bram_start_addr_for_outputs;
    bram_we <= 1'b0;
  end
  else begin
    bram_addr_for_outputs <= bram_addr_for_outputs + 1;
    bram_we <= 1'b1;
  end
end  

assign bram_data_outputs = {16'b0, out, 16'b0};

endmodule

module compute_unit(
  input clk,
  input reset,
  input [`COMPUTE_DWIDTH-1:0] input1,
  input [`COMPUTE_DWIDTH-1:0] input2,
  output reg [`COMPUTE_DWIDTH-1:0] out
);

reg [`COMPUTE_DWIDTH-1:0] input1_reg;
reg [`COMPUTE_DWIDTH-1:0] input2_reg;
wire [`COMPUTE_DWIDTH-1:0] out_from_dsp_mult;

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
        input1_reg <= 0;
        input2_reg <= 0;
    end 
    else begin
        input1_reg <= input1;
        input2_reg <= input2;
        out <= out_from_dsp_mult;
    end    
end

multiply_fp u_add(.a(input1_reg), .b(input2_reg), .out(out_from_dsp_mult));

endmodule



