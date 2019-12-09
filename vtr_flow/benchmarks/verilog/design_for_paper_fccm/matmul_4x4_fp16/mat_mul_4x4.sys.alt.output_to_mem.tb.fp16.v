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

// int
//  A           B        Output       Output in hex
// 8 4 6 8   1 1 3 0   98 90 82 34    62 5A 52 22
// 3 3 3 7   0 1 4 3   75 63 51 26    4B 3F 33 1A
// 5 2 1 6   3 5 3 1   62 48 44 19    3E 30 2C 13
// 9 1 0 5   9 6 3 2   54 40 46 13    36 28 2E 0D
//
//
// float point
//  A   
//[[ 8.203125    0.30004883 -7.30078125  3.0390625 ]
// [ 3.30078125  1.55957031 -5.19921875  1.11035156]
// [-5.1015625   9.203125   -1.09960938  2.11914062]
// [ 9.          3.33984375  0.20996094 -0.31005859]]
// B
//[[  1.20019531  -3.           4.1015625   -0.5       ]
// [ -3.40039062  -4.12109375  11.203125    -0.25      ]
// [  1.00976562  -5.01953125  19.296875     0.625     ]
// [  4.69921875   2.30078125  20.40625      1.23046875]]
// Output
//[[  15.734375     17.796875    -41.84375      -5.        ]
// [  -1.37402344   12.3203125   -46.65625      -3.92382812]
// [ -28.5625      -12.2265625   104.1875        2.16992188]
// [  -1.79980469  -42.53125      72.0625       -5.5859375 ]]
//  
//  Calculate using: https://oletus.github.io/float16-simulator.js/
//  Binary
//  A
//  0100100000011010 0011010011001101 1100011101001101 0100001000010100
//  0100001010011010 0011111000111100 1100010100110011 0011110001110000
//  

initial begin
  force u_matul.matrix_A.ram[3:0] = '{64'h0005_0006_0007_0008, 64'h0000_0001_0003_0006, 64'h0001_0002_0003_0004, 64'h0009_0005_0003_0008};
  force u_matul.matrix_A.ram[127] = 64'h0;
  force u_matul.matrix_B.ram[3:0] = '{64'h0002_0003_0006_0009, 64'h0001_0003_0005_0003, 64'h0003_0004_0001_0000, 64'h0000_0003_0001_0001};
  force u_matul.matrix_B.ram[127] = 64'h0;
end
/*
initial begin
  //A is stored in row major format
  force u_matul.matrix_A_00.ram[7:0] = '{64'h0005_0001_0007_0008,  //37 27 17 07
                                         64'h0000_0001_0003_0006,  //36 26 16 06
                                         64'h0001_0001_0003_0004,  //35 25 15 05
                                         64'h0009_0001_0003_0008,  //34 24 14 04
                                         64'h0005_0001_0007_0002,  //33 23 13 03
                                         64'h0000_0001_0003_0002,  //32 22 12 02
                                         64'h0001_0002_0003_0002,  //31 21 11 01
                                         64'h0009_0005_0003_0002}; //30 20 10 00
  force u_matul.matrix_A_00.ram[127] = 64'h0;                      
  force u_matul.matrix_A_10.ram[7:0] = '{64'h0004_0006_0007_0007,  //77 67 57 47 
                                         64'h0004_0001_0003_0007,  //76 66 56 46 
                                         64'h0004_0002_0003_0007,  //74 64 54 44 
                                         64'h0009_0005_0003_0008,  //74 64 54 44
                                         64'h0005_0006_0000_0008,  //73 63 53 43
                                         64'h0003_0001_0000_0006,  //72 62 52 42
                                         64'h0003_0002_0000_0004,  //71 61 51 41
                                         64'h0003_0005_0000_0008}; //70 60 50 40
  force u_matul.matrix_A_10.ram[127] = 64'h0;
  //B is stored in col major format
  force u_matul.matrix_B_00.ram[7:0] = '{64'h0002_0003_0006_0009,  //73 72 71 70
                                         64'h0001_0005_0005_0001,  //63 62 61 60
                                         64'h0003_0005_0001_0001,  //53 52 51 50
                                         64'h0000_0005_0001_0001,  //43 42 41 40
                                         64'h0003_0005_0006_0001,  //33 32 31 30
                                         64'h0003_0005_0005_0003,  //23 22 21 20
                                         64'h0003_0005_0001_0000,  //13 12 11 10
                                         64'h0003_0003_0001_0001}; //03 02 01 00
  force u_matul.matrix_B_00.ram[127] = 64'h0;                                   
  force u_matul.matrix_B_01.ram[7:0] = '{64'h0000_0003_0006_0005,  //77 76 75 74 
                                         64'h0001_0003_0000_0003,  //67 66 65 64
                                         64'h0003_0002_0000_0005,  //57 56 55 54
                                         64'h0000_0002_0001_0001,  //47 46 45 44 
                                         64'h0002_0002_0006_0009,  //37 36 35 34
                                         64'h0001_0003_0005_0005,  //27 26 25 24
                                         64'h0004_0004_0001_0000,  //17 16 15 14
                                         64'h0000_0003_0001_0005}; //07 06 05 04
  force u_matul.matrix_B_01.ram[127] = 64'h0;
end
*/
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
