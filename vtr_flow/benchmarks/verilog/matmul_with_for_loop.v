//Module for calculating Res = A*B
//Where A,B and C are 2 by 2 matrices.
module Mat_mult(A,B,Res,clk);

    //input and output ports.
    //The size 32 bits which is 2*2=4 elements,each of which is 8 bits wide.    
    input [31:0] A;
    input [31:0] B;
    output [31:0] Res;
    input clk;
    //internal variables    
    reg [31:0] Res;
    reg [7:0] A1 [1:0][1:0];
    reg [7:0] B1 [1:0][1:0];
    reg [7:0] Res1 [1:0][1:0]; 
    integer i,j,k;

    always @(posedge clk)
    begin
    //Initialize the matrices-convert 1 D to 3D arrays
        {A1[0][0],A1[0][1],A1[1][0],A1[1][1]} = A;
        {B1[0][0],B1[0][1],B1[1][0],B1[1][1]} = B;
        i = 0;
        j = 0;
        k = 0;
        {Res1[0][0],Res1[0][1],Res1[1][0],Res1[1][1]} = 32'd0; //initialize to zeros.
        //Matrix multiplication
        for(i=0;i < 2;i=i+1)
            for(j=0;j < 2;j=j+1)
                for(k=0;k < 2;k=k+1)
                    Res1[i][j] <= Res1[i][j] + (A1[i][k] * B1[k][j]);
        //final output assignment - 3D array to 1D array conversion.            
        Res <= {Res1[0][0],Res1[0][1],Res1[1][0],Res1[1][1]};            
    end 

endmodule

