`timescale 1ns/1ns
module matmul_tb;

reg clk;
reg reset;
reg we1;
reg we2;
reg start;
reg [15:0] data_pi;
reg [3:0] addr_pi;
//reg [15:0] data_out;

matrix_multiplication u_matul(
  .clk(clk), 
  .reset(reset), 
  .we1(we1), 
  .we2(we2), 
  .start(start), 
  .data_pi(data_pi), 
  .addr_pi(addr_pi), 
  .data_out(),
  .out_sel(),
  .done());

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

initial begin
  start = 0;
  we1 = 0;
  we2 = 0;
  #65;


//write first memory
  we1 = 1;
  we2 = 0;
  data_pi = 0;
  addr_pi = 0;
  @(posedge clk);
  repeat(16) begin
    #5;
    addr_pi = addr_pi + 1;
    data_pi = data_pi + 1;
    @(posedge clk);
  end
  @(posedge clk);

  we1 = 0;
  we2 = 0;
  @(posedge clk);

//write second memory
  we1 = 0;
  we2 = 1;
  data_pi = 0;
  addr_pi = 0;
  @(posedge clk);
  repeat(16) begin
    #5;
    addr_pi = addr_pi + 1;
    data_pi = data_pi + 1;
    @(posedge clk);
  end
  @(posedge clk);

  we1 = 0;
  we2 = 0;

  #25;
//start matrix multiplication process  
  start = 1;
  repeat(1000) begin
    @(posedge clk);
  end

  $finish;
end

initial begin
  $vcdpluson;
  $vcdplusmemon;
end

endmodule
