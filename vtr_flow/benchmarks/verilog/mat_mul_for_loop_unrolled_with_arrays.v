module mmult3x3
   (input  wire[(9*18)-1:0] AI,
    input  wire[(9*18)-1:0] BI,
    output wire[(9*18)-1:0] CO);

   wire[17:0]A[1:3][1:3];
   wire[17:0]B[1:3][1:3];
   wire[17:0]C[1:3][1:3];

	//i=1, j=1
            assign A[1][1] = AI[(((1-1)*3 + (1-1)) * 18)+17 -:18];
            assign B[1][1] = BI[(((1-1)*3 + (1-1)) * 18)+17 -:18];
            assign CO[(((1-1)*3 + (1-1)) * 18)+17 -:18] = C[1][1];

	//i=1, j=2
            assign A[1][2] = AI[(((1-1)*3 + (2-1)) * 18)+17 -:18];
            assign B[1][2] = BI[(((1-1)*3 + (2-1)) * 18)+17 -:18];
            assign CO[(((1-1)*3 + (2-1)) * 18)+17 -:18] = C[1][2];

	//i=1, j=3
            assign A[1][3] = AI[(((1-1)*3 + (3-1)) * 18)+17 -:18];
            assign B[1][3] = BI[(((1-1)*3 + (3-1)) * 18)+17 -:18];
            assign CO[(((1-1)*3 + (3-1)) * 18)+17 -:18] = C[1][3];

	//i=2, j=1
            assign A[2][1] = AI[(((2-1)*3 + (1-1)) * 18)+17 -:18];
            assign B[2][1] = BI[(((2-1)*3 + (1-1)) * 18)+17 -:18];
            assign CO[(((2-1)*3 + (1-1)) * 18)+17 -:18] = C[2][1];

	//i=2, j=2
            assign A[2][2] = AI[(((2-1)*3 + (2-1)) * 18)+17 -:18];
            assign B[2][2] = BI[(((2-1)*3 + (2-1)) * 18)+17 -:18];
            assign CO[(((2-1)*3 + (2-1)) * 18)+17 -:18] = C[2][2];

	//2=2, j=3
            assign A[2][3] = AI[(((2-1)*3 + (3-1)) * 18)+17 -:18];
            assign B[2][3] = BI[(((2-1)*3 + (3-1)) * 18)+17 -:18];
            assign CO[(((2-1)*3 + (3-1)) * 18)+17 -:18] = C[2][3];	    

	//3=3, j=1
            assign A[3][1] = AI[(((3-1)*3 + (1-1)) * 18)+17 -:18];
            assign B[3][1] = BI[(((3-1)*3 + (1-1)) * 18)+17 -:18];
            assign CO[(((3-1)*3 + (1-1)) * 18)+17 -:18] = C[3][1];

	//3=3, j=2
            assign A[3][2] = AI[(((3-1)*3 + (2-1)) * 18)+17 -:18];
            assign B[3][2] = BI[(((3-1)*3 + (2-1)) * 18)+17 -:18];
            assign CO[(((3-1)*3 + (2-1)) * 18)+17 -:18] = C[3][2];

	//3=3, j=3
            assign A[3][3] = AI[(((3-1)*3 + (3-1)) * 18)+17 -:18];
            assign B[3][3] = BI[(((3-1)*3 + (3-1)) * 18)+17 -:18];
            assign CO[(((3-1)*3 + (3-1)) * 18)+17 -:18] = C[3][3];	    

   // this is the bit that matters - everything else just works around shortcomings 
   // in the language:
            assign C[1][1] = A[1][1]*B[1][1] + A[1][2]*B[2][1] + A[1][3]*B[3][1];
            assign C[1][2] = A[1][1]*B[1][2] + A[1][2]*B[2][2] + A[1][3]*B[3][2];
            assign C[1][3] = A[1][1]*B[1][3] + A[1][2]*B[2][3] + A[1][3]*B[3][3];
            assign C[2][1] = A[2][1]*B[1][1] + A[2][2]*B[2][1] + A[2][3]*B[3][1];
            assign C[2][2] = A[2][1]*B[1][2] + A[2][2]*B[2][2] + A[2][3]*B[3][2];
            assign C[2][3] = A[2][1]*B[1][3] + A[2][2]*B[2][3] + A[2][3]*B[3][3];
            assign C[3][1] = A[3][1]*B[1][1] + A[3][2]*B[2][1] + A[3][3]*B[3][1];
            assign C[3][2] = A[3][1]*B[1][2] + A[3][2]*B[2][2] + A[3][3]*B[3][2];
            assign C[3][3] = A[3][1]*B[1][3] + A[3][2]*B[2][3] + A[3][3]*B[3][3];
endmodule

