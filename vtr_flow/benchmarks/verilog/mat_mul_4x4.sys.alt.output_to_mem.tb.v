`timescale 1ns/1ns
module matmul_tb;

reg clk;
reg reset;
reg we1;
reg we2;
reg enable_writing_to_mem;
reg enable_reading_from_mem;
reg [15:0] data_pi;
reg [4:0] addr_pi;
//reg [15:0] data_out;
wire done_mat_mul;
wire [31:0] data_out;
reg [8:0] out_sel;
reg start;

/*
matmul_4x4_systolic u_matmul(
  .clk(clk), 
  .reset(reset), 
  .start_mat_mul(start),
  .done_mat_mul(),
  .a0(),
  .a1(),
  .a2(),
  .a3(),
  .b0(),
  .b1(),
  .b2(),
  .b3(),
  .matrixC00(),
  .matrixC01(),
  .matrixC02(),
  .matrixC03(),
  .matrixC10(),
  .matrixC11(),
  .matrixC12(),
  .matrixC13(),
  .matrixC20(),
  .matrixC21(),
  .matrixC22(),
  .matrixC23(),
  .matrixC30(),
  .matrixC31(),
  .matrixC32(),
  .matrixC33(),
  .a0_addr(),
  .a1_addr(),
  .a2_addr(),
  .a3_addr(),
  .b0_addr(),
  .b1_addr(),
  .b2_addr(),
  .b3_addr(),
  .final_mat_mul_size(16'd4),
  .a_loc(16'd0),
  .b_loc(16'd0)
);
*/

matrix_multiplication u_matul(
  .clk(clk), 
  .reset(reset), 
  .enable_writing_to_mem(enable_writing_to_mem), 
  .enable_reading_from_mem(enable_reading_from_mem), 
  .we_a(),
  .we_b(),
  .we_c(),
  .data_pi(), 
  .addr_pi(), 
  .data_from_out_mat(),
  .start_mat_mul(start),
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

initial begin
  start = 0;
  enable_writing_to_mem = 0;
  enable_reading_from_mem = 0;
  #115 start = 1;
  #1000;
  $finish;
end

initial begin
  force u_matul.matrix_A.ram[3:0] = '{64'h0005_0006_0007_0008, 64'h0000_0001_0003_0006, 64'h0001_0002_0003_0004, 64'h0009_0005_0003_0008};
  force u_matul.matrix_A.ram[127] = 64'h0;
  force u_matul.matrix_B.ram[3:0] = '{64'h0002_0003_0006_0009, 64'h0001_0003_0005_0003, 64'h0003_0004_0001_0000, 64'h0000_0003_0001_0001};
  force u_matul.matrix_B.ram[127] = 64'h0;
end

/*
reg [15:0] matA [15:0] = '{1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6};
reg [15:0] matB [15:0] = '{4,5,2,8,5,8,0,2,6,9,5,8,3,9,3,0};

initial begin
  enable_writing_to_mem = 0;
  we1 = 0;
  we2 = 0;
  data_pi = 0;
  addr_pi = 0;
  #65;

  enable_writing_to_mem = 1;

//write first memory
  for(int i=0; i<16; i++) begin
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
  for(int i=0; i<16; i++) begin
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

  for(int i=0; i<16; i++) begin
    out_sel = i;
    @(posedge clk);
  end

    @(posedge clk);

  $finish;
end
*/

initial begin
  $vcdpluson;
  $vcdplusmemon;
end

endmodule
