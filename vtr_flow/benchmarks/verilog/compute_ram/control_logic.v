`define BRAM_DWIDTH 40
`define BRAM_AWIDTH 9
`define COMPUTE_DWIDTH 8
`define COMPUTE_LATENCY 2

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
  input  [`COMPUTE_DWIDTH:0] out
);

reg [7:0] clk_cnt;
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

assign bram_data_outputs = {out, 16'b0};

endmodule
