`timescale 1ns/1ns

`define DWIDTH 16
`define AWIDTH 7
`define MEM_SIZE 128
`define NUM_ELEMENTS 64
module matmul_tb;

reg clk;
reg reset;
reg we1;
reg we2;
reg enable_writing_to_mem;
reg [`DWIDTH-1:0] data_pi;
reg [`AWIDTH-1:0] addr_pi;
//reg [15:0] data_out;
wire done_mat_mul;
wire [2*`DWIDTH-1:0] data_out;
reg [`AWIDTH-1:0] out_sel;

matrix_multiplication u_matul(
  .clk(clk), 
  .reset(reset), 
  .we1(we1), 
  .we2(we2), 
  .enable_writing_to_mem(enable_writing_to_mem), 
  .data_pi(data_pi), 
  .addr_pi(addr_pi), 
  .data_out(data_out),
  .out_sel(out_sel),
  .done_mat_mul(done_mat_mul));

initial begin
  clk = 0;
  forever begin
    #10 clk = ~clk;
  end
end

initial begin
  reset = 1;
  #55 reset = 0;
end

reg [`DWIDTH-1:0] matA [`NUM_ELEMENTS-1:0] = '{1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6};
reg [`DWIDTH-1:0] matB [`NUM_ELEMENTS-1:0] = '{4,5,2,8,5,8,0,2,6,9,5,8,3,9,3,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,4,5,2,8,5,8,0,2,6,9,5,8,3,9,3,0,4,5,2,8,5,8,0,2,6,9,5,8,3,9,3,0};

initial begin
  enable_writing_to_mem = 0;
  we1 = 0;
  we2 = 0;
  data_pi = 0;
  addr_pi = 0;
  #65;

  enable_writing_to_mem = 1;

//write first memory
  for(int i=0; i<`NUM_ELEMENTS; i++) begin
    we1 = 1;
    we2 = 0;
    addr_pi = i;
    data_pi = matA[i];
    @(posedge clk);
    #5;
  end

  we1 = 0;
  we2 = 0;
  data_pi = 0;
  addr_pi = 0;
  @(posedge clk);

//write second memory
  for(int i=0; i<`NUM_ELEMENTS; i++) begin
    we1 = 0;
    we2 = 1;
    addr_pi = i;
    data_pi = matB[i];
    @(posedge clk);
    #5;
  end

  we1 = 0;
  we2 = 0;

  #25;
//start matrix multiplication process  
  enable_writing_to_mem = 0;
  addr_pi = 0;
  while(1) begin
    @(posedge clk);
    if (done_mat_mul == 1) begin
        break;
    end
  end

  for(int i=0; i<`NUM_ELEMENTS; i++) begin
    out_sel = i;
    @(posedge clk);
  end

    @(posedge clk);

  $finish;
end

initial begin
  $vcdpluson;
  $vcdplusmemon;
end

endmodule
