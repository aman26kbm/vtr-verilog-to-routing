`timescale 1ns / 1ps
// Prealign + Align + Shift 1 + Shift 2
module FPAddSub_a(
		A,
		B,
		operation,
		Opout,
		Sa,
		Sb,
		MaxAB,
		CExp,
		Shift,
		Mmax,
		InputExc,
		Mmin_3
		
		
	);
	
	// Input ports
	input [31:0] A ;										// Input A, a 32-bit floating point number
	input [31:0] B ;										// Input B, a 32-bit floating point number
	input operation ;
	
	//output ports
	output Opout;
	output Sa;
	output Sb;
	output MaxAB;
	output [7:0] CExp;
	output [4:0] Shift;
	output [22:0] Mmax;
	output [4:0] InputExc;
	output [23:0] Mmin_3;	
							
	wire [9:0] ShiftDet ;							
	wire [30:0] Aout ;
	wire [30:0] Bout ;
	

	// Internal signals									// If signal is high...
	wire ANaN ;												// A is a NaN (Not-a-Number)
	wire BNaN ;												// B is a NaN
	wire AInf ;												// A is infinity
	wire BInf ;												// B is infinity
	wire [7:0] DAB ;										// ExpA - ExpB					
	wire [7:0] DBA ;										// ExpB - ExpA	
	
	assign ANaN = &(A[30:23]) & |(A[22:0]) ;		// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(B[30:23]) & |(B[22:0]);		// All one exponent and not all zero mantissa - NaN
	assign AInf = &(A[30:23]) & ~|(A[22:0]) ;	// All one exponent and all zero mantissa - Infinity
	assign BInf = &(B[30:23]) & ~|(B[22:0]) ;	// All one exponent and all zero mantissa - Infinity
	
	// Put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	
	//assign DAB = (A[30:23] - B[30:23]) ;
	//assign DBA = (B[30:23] - A[30:23]) ;
	assign DAB = (A[30:23] + ~(B[30:23]) + 1) ;
	assign DBA = (B[30:23] + ~(A[30:23]) + 1) ;
	
	assign Sa = A[31] ;									// A's sign bit
	assign Sb = B[31] ;									// B's sign	bit
	assign ShiftDet = {DBA[4:0], DAB[4:0]} ;		// Shift data
	assign Opout = operation ;
	assign Aout = A[30:0] ;
	assign Bout = B[30:0] ;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Output ports
													// Number of steps to smaller mantissa shift right
	wire [22:0] Mmin_1 ;							// Smaller mantissa 
	
	// Internal signals
	//wire BOF ;										// Check for shifting overflow if B is larger
	//wire AOF ;										// Check for shifting overflow if A is larger
	
	assign MaxAB = (Aout[30:0] < Bout[30:0]) ;	
	//assign BOF = ShiftDet[9:5] < 25 ;		// Cannot shift more than 25 bits
	//assign AOF = ShiftDet[4:0] < 25 ;		// Cannot shift more than 25 bits
	
	// Determine final shift value
	//assign Shift = MaxAB ? (BOF ? ShiftDet[9:5] : 5'b11001) : (AOF ? ShiftDet[4:0] : 5'b11001) ;
	
	assign Shift = MaxAB ? ShiftDet[9:5] : ShiftDet[4:0] ;
	
	// Take out smaller mantissa and append shift space
	assign Mmin_1 = MaxAB ? Aout[22:0] : Bout[22:0] ; 
	
	// Take out larger mantissa	
	assign Mmax = MaxAB ? Bout[22:0]: Aout[22:0] ;	
	
	// Common exponent
	assign CExp = (MaxAB ? Bout[30:23] : Aout[30:23]) ;	

// Input ports
					// Smaller mantissa after 16|12|8|4 shift
	wire [2:0] Shift_1 ;						// Shift amount
	
	assign Shift_1 = Shift [4:2];

	wire [23:0] Mmin_2 ;						// The smaller mantissa
	
	// Internal signals
	reg	  [23:0]		Lvl1;
	reg	  [23:0]		Lvl2;
	wire    [47:0]    Stage1;	
	integer           i;                // Loop variable
	
	always @(*) begin						
		// Rotate by 16?
		Lvl1 <= Shift_1[2] ? {17'b00000000000000001, Mmin_1[22:16]} : {1'b1, Mmin_1}; 
	end
	
	assign Stage1 = {Lvl1, Lvl1};
	
	always @(*) begin    					// Rotate {0 | 4 | 8 | 12} bits
	  case (Shift_1[1:0])
			// Rotate by 0	
			2'b00:  Lvl2 <= Stage1[23:0];       			
			// Rotate by 4	
			2'b01:  begin for (i=0; i<=23; i=i+1) begin Lvl2[i] <= Stage1[i+4]; end Lvl2[23:19] <= 0; end
			// Rotate by 8
			2'b10:  begin for (i=0; i<=23; i=i+1) begin Lvl2[i] <= Stage1[i+8]; end Lvl2[23:15] <= 0; end
			// Rotate by 12	
			2'b11:  begin for (i=0; i<=23; i=i+1) begin Lvl2[i] <= Stage1[i+12]; end Lvl2[23:11] <= 0; end
	  endcase
	end
	
	// Assign output to next shift stage
	assign Mmin_2 = Lvl2;
								// Smaller mantissa after 16|12|8|4 shift
	wire [1:0] Shift_2 ;						// Shift amount
	
	assign Shift_2 =Shift  [1:0] ;
					// The smaller mantissa
	
	// Internal Signal
	reg	  [23:0]		Lvl3;
	wire    [47:0]    Stage2;	
	integer           j;               // Loop variable
	
	assign Stage2 = {Mmin_2, Mmin_2};

	always @(*) begin    // Rotate {0 | 1 | 2 | 3} bits
	  case (Shift_2[1:0])
			// Rotate by 0
			2'b00:  Lvl3 <= Stage2[23:0];   
			// Rotate by 1
			2'b01:  begin for (j=0; j<=23; j=j+1)  begin Lvl3[j] <= Stage2[j+1]; end Lvl3[23] <= 0; end 
			// Rotate by 2
			2'b10:  begin for (j=0; j<=23; j=j+1)  begin Lvl3[j] <= Stage2[j+2]; end Lvl3[23:22] <= 0; end 
			// Rotate by 3
			2'b11:  begin for (j=0; j<=23; j=j+1)  begin Lvl3[j] <= Stage2[j+3]; end Lvl3[23:21] <= 0; end 	  
	  endcase
	end
	
	// Assign output
	assign Mmin_3 = Lvl3;	

	
endmodule
`timescale 1ns / 1ps

module FpAddSub_b(
		Mmax,
		Mmin,
		Sa,
		Sb,
		MaxAB,
		OpMode,
		SumS_5,
		Shift,
		PSgn,
		Opr
);
	input [22:0] Mmax ;					// The larger mantissa
	input [23:0] Mmin ;					// The smaller mantissa
	input Sa ;								// Sign bit of larger number
	input Sb ;								// Sign bit of smaller number
	input MaxAB ;							// Indicates the larger number (0/A, 1/B)
	input OpMode ;							// Operation to be performed (0/Add, 1/Sub)
	
	// Output ports
	wire [32:0] Sum ;	
						// Output ports
	output [32:0] SumS_5 ;					// Mantissa after 16|0 shift
	output [4:0] Shift ;					// Shift amount				// The result of the operation
	output PSgn ;							// The sign for the result
	output Opr ;							// The effective (performed) operation

	assign Opr = (OpMode^Sa^Sb); 		// Resolve sign to determine operation

	// Perform effective operation
	assign Sum = (OpMode^Sa^Sb) ? ({1'b1, Mmax, 8'b00000000} - {Mmin, 8'b00000000}) : ({1'b1, Mmax, 8'b00000000} + {Mmin, 8'b00000000}) ;
	
	// Assign result sign
	assign PSgn = (MaxAB ? Sb : Sa) ;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// Determine normalization shift amount by finding leading nought
	assign Shift =  ( 
		Sum[32] ? 5'b00000 :	 
		Sum[31] ? 5'b00001 : 
		Sum[30] ? 5'b00010 : 
		Sum[29] ? 5'b00011 : 
		Sum[28] ? 5'b00100 : 
		Sum[27] ? 5'b00101 : 
		Sum[26] ? 5'b00110 : 
		Sum[25] ? 5'b00111 :
		Sum[24] ? 5'b01000 :
		Sum[23] ? 5'b01001 :
		Sum[22] ? 5'b01010 :
		Sum[21] ? 5'b01011 :
		Sum[20] ? 5'b01100 :
		Sum[19] ? 5'b01101 :
		Sum[18] ? 5'b01110 :
		Sum[17] ? 5'b01111 :
		Sum[16] ? 5'b10000 :
		Sum[15] ? 5'b10001 :
		Sum[14] ? 5'b10010 :
		Sum[13] ? 5'b10011 :
		Sum[12] ? 5'b10100 :
		Sum[11] ? 5'b10101 :
		Sum[10] ? 5'b10110 :
		Sum[9] ? 5'b10111 :
		Sum[8] ? 5'b11000 :
		Sum[7] ? 5'b11001 : 5'b11010
	);
	
	reg	  [32:0]		Lvl1;
	
	always @(*) begin
		// Rotate by 16?
		Lvl1 <= Shift[4] ? {Sum[16:0], 16'b0000000000000000} : Sum; 
	end
	
	// Assign outputs
	assign SumS_5 = Lvl1;	

endmodule




`timescale 1ns / 1ps

module FPAddSub_c(
		SumS_5,
		Shift,
		CExp,
		NormM,
		NormE,
		ZeroSum,
		NegE,
		R,
		S,
		FG
	);
	
	// Input ports
	input [32:0] SumS_5 ;						// Smaller mantissa after 16|12|8|4 shift
	
	input [4:0] Shift ;						// Shift amount
	
// Input ports
	
	input [7:0] CExp ;
	

	// Output ports
	output [22:0] NormM ;				// Normalized mantissa
	output [8:0] NormE ;					// Adjusted exponent
	output ZeroSum ;						// Zero flag
	output NegE ;							// Flag indicating negative exponent
	output R ;								// Round bit
	output S ;								// Final sticky bit
	output FG ;


	wire [3:0]Shift_1;
	assign Shift_1 = Shift [3:0];
	// Output ports
	wire [32:0] SumS_7 ;						// The smaller mantissa
	
	reg	  [32:0]		Lvl2;
	wire    [65:0]    Stage1;	
	reg	  [32:0]		Lvl3;
	wire    [65:0]    Stage2;	
	integer           i;               	// Loop variable
	
	assign Stage1 = {SumS_5, SumS_5};

	always @(*) begin    					// Rotate {0 | 4 | 8 | 12} bits
	  case (Shift[3:2])
			// Rotate by 0
			2'b00: Lvl2 <= Stage1[32:0];       		
			// Rotate by 4
			2'b01: begin for (i=65; i>=33; i=i-1) begin Lvl2[i-33] <= Stage1[i-4]; end Lvl2[3:0] <= 0; end
			// Rotate by 8
			2'b10: begin for (i=65; i>=33; i=i-1) begin Lvl2[i-33] <= Stage1[i-8]; end Lvl2[7:0] <= 0; end
			// Rotate by 12
			2'b11: begin for (i=65; i>=33; i=i-1) begin Lvl2[i-33] <= Stage1[i-12]; end Lvl2[11:0] <= 0; end
	  endcase
	end
	
	assign Stage2 = {Lvl2, Lvl2};

	always @(*) begin   				 		// Rotate {0 | 1 | 2 | 3} bits
	  case (Shift_1[1:0])
			// Rotate by 0
			2'b00:  Lvl3 <= Stage2[32:0];
			// Rotate by 1
			2'b01: begin for (i=65; i>=33; i=i-1) begin Lvl3[i-33] <= Stage2[i-1]; end Lvl3[0] <= 0; end 
			// Rotate by 2
			2'b10: begin for (i=65; i>=33; i=i-1) begin Lvl3[i-33] <= Stage2[i-2]; end Lvl3[1:0] <= 0; end
			// Rotate by 3
			2'b11: begin for (i=65; i>=33; i=i-1) begin Lvl3[i-33] <= Stage2[i-3]; end Lvl3[2:0] <= 0; end
	  endcase
	end
	
	// Assign outputs
	assign SumS_7 = Lvl3;						// Take out smaller mantissa



	
	// Internal signals
	wire MSBShift ;						// Flag indicating that a second shift is needed
	wire [8:0] ExpOF ;					// MSB set in sum indicates overflow
	wire [8:0] ExpOK ;					// MSB not set, no adjustment
	
	// Calculate normalized exponent and mantissa, check for all-zero sum
	assign MSBShift = SumS_7[32] ;		// Check MSB in unnormalized sum
	assign ZeroSum = ~|SumS_7 ;			// Check for all zero sum
	assign ExpOK = CExp - Shift ;		// Adjust exponent for new normalized mantissa
	assign NegE = ExpOK[8] ;			// Check for exponent overflow
	assign ExpOF = CExp - Shift + 1'b1 ;		// If MSB set, add one to exponent(x2)
	


	assign NormE = MSBShift ? ExpOF : ExpOK ;			// Check for exponent overflow
	assign NormM = SumS_7[31:9] ;		// The new, normalized mantissa
	
	// Also need to compute sticky and round bits for the rounding stage
	assign FG = SumS_7[8] ; 
	assign R = SumS_7[7] ;
	assign S = |SumS_7[6:0] ;		
	
endmodule
`timescale 1ns / 1ps

module FPAddSub_d(
		ZeroSum,
		NormE,
		NormM,
		R,
		S,
		G,
		Sa,
		Sb,
		Ctrl,
		MaxAB,
		NegE,
		InputExc,
		P,
		Flags 
    );

	// Input ports
	input ZeroSum ;					// Sum is zero
	input [8:0] NormE ;				// Normalized exponent
	input [22:0] NormM ;				// Normalized mantissa
	input R ;							// Round bit
	input S ;							// Sticky bit
	input G ;
	input Sa ;							// A's sign bit
	input Sb ;							// B's sign bit
	input Ctrl ;						// Control bit (operation)
	input MaxAB ;
	

	input NegE ;						// Negative exponent?
	input [4:0] InputExc ;					// Exceptions in inputs A and B

	// Output ports
	output [31:0] P ;					// Final result
	output [4:0] Flags ;				// Exception flags
	
	// 
	wire [31:0] Z ;					// Final result
	wire EOF ;
	
	// Internal signals
	wire [23:0] RoundUpM ;			// Rounded up sum with room for overflow
	wire [22:0] RoundM ;				// The final rounded sum
	wire [8:0] RoundE ;				// Rounded exponent (note extra bit due to poential overflow	)
	wire RoundUp ;						// Flag indicating that the sum should be rounded up
	wire ExpAdd ;						// May have to add 1 to compensate for overflow 
	wire RoundOF ;						// Rounding overflow
	wire FSgn;
	// The cases where we need to round upwards (= adding one) in Round to nearest, tie to even
	assign RoundUp = (G & ((R | S) | NormM[0])) ;
	
	// Note that in the other cases (rounding down), the sum is already 'rounded'
	assign RoundUpM = (NormM + 1) ;								// The sum, rounded up by 1
	assign RoundM = (RoundUp ? RoundUpM[22:0] : NormM) ; 	// Compute final mantissa	
	assign RoundOF = RoundUp & RoundUpM[23] ; 				// Check for overflow when rounding up

	// Calculate post-rounding exponent
	assign ExpAdd = (RoundOF ? 1'b1 : 1'b0) ; 				// Add 1 to exponent to compensate for overflow
	assign RoundE = ZeroSum ? 8'b00000000 : (NormE + ExpAdd) ; 							// Final exponent

	// If zero, need to determine sign according to rounding
	assign FSgn = (ZeroSum & (Sa ^ Sb)) | (ZeroSum ? (Sa & Sb & ~Ctrl) : ((~MaxAB & Sa) | ((Ctrl ^ Sb) & (MaxAB | Sa)))) ;

	// Assign final result
	assign Z = {FSgn, RoundE[7:0], RoundM[22:0]} ;
	
	// Indicate exponent overflow
	assign EOF = RoundE[8];

/////////////////////////////////////////////////////////////////////////////////////////////////////////



	
	// Internal signals
	wire Overflow ;					// Overflow flag
	wire Underflow ;					// Underflow flag
	wire DivideByZero ;				// Divide-by-Zero flag (always 0 in Add/Sub)
	wire Invalid ;						// Invalid inputs or result
	wire Inexact ;						// Result is inexact because of rounding
	
	// Exception flags
	
	// Result is too big to be represented
	assign Overflow = EOF | InputExc[1] | InputExc[0] ;
	
	// Result is too small to be represented
	assign Underflow = NegE & (R | S);
	
	// Infinite result computed exactly from finite operands
	assign DivideByZero = &(Z[30:23]) & ~|(Z[30:23]) & ~InputExc[1] & ~InputExc[0];
	
	// Invalid inputs or operation
	assign Invalid = |(InputExc[4:2]) ;
	
	// Inexact answer due to rounding, overflow or underflow
	assign Inexact = (R | S) | Overflow | Underflow;
	
	// Put pieces together to form final result
	assign P = Z ;
	
	// Collect exception flags	
	assign Flags = {Overflow, Underflow, DivideByZero, Invalid, Inexact} ; 	
	
endmodule
`timescale 1ns / 1ps
module FPAddSub_single(
		clk,
		rst,
		a,
		b,
		operation,
		result,
		flags
	);

// Clock and reset
	input clk ;										// Clock signal
	input rst ;										// Reset (active high, resets pipeline registers)
	
	// Input ports
	input [31:0] a ;								// Input A, a 32-bit floating point number
	input [31:0] b ;								// Input B, a 32-bit floating point number
	input operation ;								// Operation select signal
	
	// Output ports
	output [31:0] result ;						// Result of the operation
	output [4:0] flags ;							// Flags indicating exceptions according to IEEE754

	wire [68:0]pipe_1;
	wire [54:0]pipe_2;
	wire [45:0]pipe_3;


//internal module wires

//output ports
	wire Opout;
	wire Sa;
	wire Sb;
	wire MaxAB;
	wire [7:0] CExp;
	wire [4:0] Shift;
	wire [22:0] Mmax;
	wire [4:0] InputExc;
	wire [23:0] Mmin_3;

	wire [32:0] SumS_5 ;
	wire [4:0] Shift_1;							
	wire PSgn ;							
	wire Opr ;	
	
	wire [22:0] NormM ;				// Normalized mantissa
	wire [8:0] NormE ;					// Adjusted exponent
	wire ZeroSum ;						// Zero flag
	wire NegE ;							// Flag indicating negative exponent
	wire R ;								// Round bit
	wire S ;								// Final sticky bit
	wire FG ;

FPAddSub_a M1(a,b,operation,Opout,Sa,Sb,MaxAB,CExp,Shift,Mmax,InputExc,Mmin_3);

FpAddSub_b M2(pipe_1[51:29],pipe_1[23:0],pipe_1[67],pipe_1[66],pipe_1[65],pipe_1[68],SumS_5,Shift_1,PSgn,Opr);

FPAddSub_c M3(pipe_2[54:22],pipe_2[21:17],pipe_2[16:9],NormM,NormE,ZeroSum,NegE,R,S,FG);

FPAddSub_d M4(pipe_3[13],pipe_3[22:14],pipe_3[45:23],pipe_3[11],pipe_3[10],pipe_3[9],pipe_3[8],pipe_3[7],pipe_3[6],pipe_3[5],pipe_3[12],pipe_3[4:0],result,flags );


/*
pipe_1:
	[68] Opout;
	[67] Sa;
	[66] Sb;
	[65] MaxAB;
	[64:57] CExp;
	[56:52] Shift;
	[51:29] Mmax;
	[28:24] InputExc;
	[23:0] Mmin_3;	

*/

assign pipe_1 = {Opout,Sa,Sb,MaxAB,CExp,Shift,Mmax,InputExc,Mmin_3};

/*
pipe_2:
	[54:22]SumS_5;
	[21:17]Shift;
	[16:9]CExp;	
	[8]Sa;
	[7]Sb;
	[6]operation;
	[5]MaxAB;	
	[4:0]InputExc
*/

assign pipe_2 = {SumS_5,Shift_1,pipe_1[64:57], pipe_1[67], pipe_1[66], pipe_1[68], pipe_1[65], pipe_1[28:24] };

/*
pipe_3:
	[45:23] NormM ;				
	[22:14] NormE ;					
	[13]ZeroSum ;						
	[12]NegE ;							
	[11]R ;								
	[10]S ;								
	[9]FG ;
	[8]Sa;
	[7]Sb;
	[6]operation;
	[5]MaxAB;	
	[4:0]InputExc
*/

assign pipe_3 = {NormM,NormE,ZeroSum,NegE,R,S,FG, pipe_2[8], pipe_2[7], pipe_2[6], pipe_2[5], pipe_2[4:0] };


endmodule
`timescale 1ns / 1ps

module FPMult_b(
		a,
		b,
		MpC,
		Ea,
		Eb,
		Sa,
		Sb,
		Sp,
		NormE,
		NormM,
		GRS
    );

	// Input ports
	input [22:0] a ;
	input [16:0] b ;
	input [47:0] MpC ;
	input [7:0] Ea ;						// A's exponent
	input [7:0] Eb ;						// B's exponent
	input Sa ;								// A's sign
	input Sb ;								// B's sign
	
	// Output ports
	output Sp ;								// Product sign
	output [8:0] NormE ;													// Normalized exponent
	output [22:0] NormM ;												// Normalized mantissa
	output GRS ;
	
	wire [47:0] Mp ;
	
	assign Sp = (Sa ^ Sb) ;												// Equal signs give a positive product
	
	assign Mp = (MpC<<17) + ({7'b0000001, a[22:0]}*{1'b0, b[16:0]}) ;
	
	assign NormM = (Mp[47] ? Mp[46:24] : Mp[45:23]); // Check for overflow
	assign NormE = (Ea + Eb + Mp[47]);								// If so, increment exponent
	
	assign GRS = ((Mp[23]&(Mp[24]))|(|Mp[22:0])) ;
	
endmodule
`timescale 1ns / 1ps

module FPMult_c(
		NormM,
		NormE,
		Sp,
		GRS,
		InputExc,
		Z,
		Flags
    );

	// Input Ports
	input [22:0] NormM ;									// Normalized mantissa
	input [8:0] NormE ;									// Normalized exponent
	input Sp ;										// Product sign
	input GRS ;
	input [4:0] InputExc ;

	// Output Ports
	output [31:0] Z ;										// Final product
	output [4:0] Flags ;

	// Output Ports
	wire [8:0] RoundE ;
	wire [8:0] RoundEP ;
	wire [23:0] RoundM ;
	wire [23:0] RoundMP ; 
	
	assign RoundE = NormE - 127 ;
	assign RoundEP = NormE - 126 ;
	assign RoundM = NormM ;
	assign RoundMP = NormM + 1 ;
	
	// Internal Signals
	wire [8:0] FinalE ;									// Rounded exponent
	wire [23:0] FinalM;
	wire [23:0] PreShiftM;
	
	assign PreShiftM = GRS ? RoundMP : RoundM ;	// Round up if R and (G or S)
	
	// Post rounding normalization (potential one bit shift> use shifted mantissa if there is overflow)
	assign FinalM = (PreShiftM[23] ? {1'b0, PreShiftM[23:1]} : PreShiftM[23:0]) ;
	
	assign FinalE = (PreShiftM[23] ? RoundEP : RoundE) ; // Increment exponent if a shift was done
	
	assign Z = {Sp, FinalE[7:0], FinalM[22:0]} ;   // Putting the pieces together
	assign Flags = InputExc[4:0];

endmodule
module Multiplier_combined(
	input [36:0] IN1,
	input [36:0] IN2,
	output [73:0] OUT1,
	input mode
);
reg [8:0] mult1_a;
reg [8:0] mult1_b;
reg [9:0] mult2_a;
reg [8:0] mult2_b;
reg [8:0] mult3_a;
reg [8:0] mult3_b;
reg [9:0] mult4_a;
reg [8:0] mult4_b;
reg [8:0] mult5_a;
reg [8:0] mult5_b;
reg [9:0] mult6_a;
reg [8:0] mult6_b;
reg [8:0] mult7_a;
reg [8:0] mult7_b;
reg [9:0] mult8_a;
reg [8:0] mult8_b;
reg [8:0] mult9_a;
reg [8:0] mult9_b;

wire [17:0] mult1_c;
wire [18:0] mult2_c;
wire [17:0] mult3_c;
wire [18:0] mult4_c;
wire [17:0] mult5_c;
wire [18:0] mult6_c;
wire [17:0] mult7_c;
wire [18:0] mult8_c;
wire [17:0] mult9_c;

wire [36:0]temp1;
wire [36:0] temp2;
always @ (*) begin
//for 18*19 mode
if (mode == 1'b0) begin
mult1_a = IN1[8:0];
mult1_b = IN1 [27:19]; //1

mult2_a= IN1 [18:9];
mult2_b = IN1[27:19]; //2

mult3_a = IN1 [36:28];
mult3_b = IN1[8:0]; //1

mult4_a= IN1[18:9];
mult4_b= IN1[36:28]; //2

mult5_a = IN2[8:0];
mult5_b = IN2 [27:19]; //1

mult6_a= IN2 [18:9];
mult6_b = IN2[27:19]; //2

mult7_a = IN2 [36:28];
mult7_b = IN2[8:0]; //1

mult8_a= IN2[18:9];
mult8_b= IN2[36:28]; //2

end
//for 27*27 mode

else if (mode == 1'b1) begin
mult1_a = IN1[8:0];
mult1_b = IN2 [8:0];

mult2_a = IN1[8:0];
mult2_b = IN2 [17:9];

mult3_a = IN1[8:0];
mult3_b = IN2 [26:18];

mult4_a = IN1[17:9];
mult4_b = IN2 [8:0];

mult5_a = IN1[17:9];
mult5_b = IN2 [17:9];

mult6_a = IN1[17:9];
mult6_b = IN2 [26:18];

mult7_a = IN1[26:18];
mult7_b = IN2 [8:0];

mult8_a = IN1[26:18];
mult8_b = IN2 [17:9];

mult9_a = IN1[26:18];
mult9_b = IN2 [26:18];
end
end


multiplier_basic_1 M1( mult1_a, mult1_b, mult1_c);
multiplier_basic_2 M2( mult2_a, mult2_b, mult2_c);
multiplier_basic_1 M3( mult3_a, mult3_b, mult3_c);
multiplier_basic_2 M4( mult4_a, mult4_b, mult4_c);
multiplier_basic_1 M5( mult5_a, mult5_b, mult5_c);
multiplier_basic_2 M6( mult6_a, mult6_b, mult6_c);
multiplier_basic_1 M7( mult7_a, mult7_b, mult7_c);
multiplier_basic_2 M8( mult8_a, mult8_b, mult8_c);
multiplier_basic_1 M9( mult9_a, mult9_b, mult9_c);

assign temp1 = mult1_c + (mult2_c << 9) + (mult3_c << 9) + (mult4_c << 18);
assign temp2 = mult5_c + (mult6_c << 9) + (mult7_c << 9) + (mult8_c << 18);
assign OUT1 = mode ? (mult1_c + (mult2_c << 9) + (mult3_c << 18) + (mult4_c << 9) + (mult5_c << 18) + (mult6_c << 27) + (mult7_c << 18) + (mult8_c << 27) + (mult9_c << 36)) : {temp2, temp1};

endmodule

module multiplier_basic_1 (
	input [8:0] a,
	input [8:0] b,
	output [17:0] c
);

assign c = a*b;
endmodule

module multiplier_basic_2 (
	input [9:0] a,
	input [8:0] b,
	output [18:0] c
);
assign c = a*b;
endmodule
module pre_adder_combined(
	input [36:0] IN1,
	input [36:0] IN2,
	output [37:0] OUT1,
	input mode
);

reg [ 18 :0] add1_a;
reg [ 17 :0] add1_b;
reg [18:0]add2_a;
reg [17:0]add2_b;
wire [18:0]add1_c;
wire [18:0]add2_c;

always @(*) begin
if ( mode == 1'b0 ) begin
	add1_a = IN1[18:0]; //ay 19bit
	add1_b = IN1[36:19]; //az 18bit
	add2_a = IN2[18:0]; //by 19bit
	add2_b = IN2[36:19]; //bz 18bit
	end
else begin
	add1_a=IN1[18:0]; //ay first 19 bits
	add1_b={ IN2[7:0], IN1[36:27]}; //az first 19 bits
	
	add2_a= {10'b0, IN1[26:19]}; //ay last 8 bits
	add2_b= {10'b0, IN2[15:8]}; //az last 8 bits
	end
end

wire carry;
wire cout_1;

pre_adder_building u_add1(.a(add1_a), .b(add1_b), .cin(1'b0), .c(add1_c), .cout(cout_1));
assign carry = mode ? cout_1: 1'b0;
pre_adder_building u_add2(.a(add2_a), .b(add2_b), .cin(carry), .c(add2_c), .cout());

assign OUT1 = {add2_c, add1_c};

endmodule

module pre_adder_building(
	input [18:0] a,
	input [17:0] b,
	input cin,
	output [18:0] c,
	output cout
	);
assign {cout, c} = a + b + cin;
endmodule
`timescale 1ns / 1ps
//Includes the 2 fixed point modes and 1 FP32 mode
module dsp_slice_combined (
 	clk,
 	reset,
 	enable,
 	loadconst,
	accumulate,
	negate,
	sub,
	mode,
	mux9_select,
	internal_coeffa,
	internal_coeffb,
	stream,
	chainin,
	resulta,
	resultb,
	chainout
);
input clk;
input reset;
input enable;
input loadconst;
input accumulate;
input negate;
input sub;
input [1:0]mode;
input mux9_select;
input internal_coeffa;
input internal_coeffb;
input [115:0] stream;
input [63:0] chainin;
output [63:0] resulta;
output [36:0] resultb;
output [63:0] chainout;

reg loadconst_flopped_1;
reg accumulate_flopped_1;
reg negate_flopped_1;
reg sub_flopped_1;
reg [1:0]mode_flopped_1;
reg [115:0] stream_flopped_1;
reg mux9_select_flopped_1;
reg internal_coeffa_flopped_1;
reg internal_coeffb_flopped_1;

reg loadconst_flopped_2;
reg accumulate_flopped_2;
reg negate_flopped_2;
reg sub_flopped_2;
reg [1:0]mode_flopped_2;
reg [115:0] stream_flopped_2;
reg mux9_select_flopped_2;
reg internal_coeffa_flopped_2;
reg internal_coeffb_flopped_2;

reg loadconst_flopped_3;
reg accumulate_flopped_3;
reg negate_flopped_3;
reg sub_flopped_3;
reg [1:0]mode_flopped_3;
reg [115:0] stream_flopped_3;
reg mux9_select_flopped_3;
reg internal_coeffa_flopped_3;
reg internal_coeffb_flopped_3;

wire mux_select_1;
wire mux_select_2;

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_1 <= 0;
 accumulate_flopped_1 <= 0;
 negate_flopped_1 <= 0;
 sub_flopped_1 <= 0;
 mode_flopped_1 <= 0;
 stream_flopped_1 <= 0;
 mux9_select_flopped_1 <= 0;
 internal_coeffa_flopped_1 <= 0;
 internal_coeffb_flopped_1 <= 0;
end
else begin
 loadconst_flopped_1 <= loadconst;
 accumulate_flopped_1 <= accumulate;
 negate_flopped_1 <= negate;
 sub_flopped_1 <= sub;
 mode_flopped_1 <= mode;
 stream_flopped_1 <= stream;
 mux9_select_flopped_1 <= mux9_select;
  internal_coeffa_flopped_1 <= internal_coeffa;
 internal_coeffb_flopped_1 <= internal_coeffb;
end
end



wire [31:0] chainout_1;
wire [31:0] resulta_flopped;

wire [3:0]funct_flopped;
wire [31:0] ax_flopped;
wire [31:0] ay_flopped;
wire [31:0] az_flopped;

assign funct_flopped = stream_flopped_1[99:96];
assign ax_flopped = stream_flopped_1[31:0];
assign ay_flopped = stream_flopped_1[63:32];
assign az_flopped = stream_flopped_1[95:64];

wire mux1_select;
wire [1:0] mux2_select;
wire mux3_select;
wire mux5_select;

assign mux1_select = (funct_flopped[1] & funct_flopped[0] ) | (funct_flopped[3] & ~funct_flopped[1]) | (funct_flopped[2] & ~funct_flopped[0] );
assign mux2_select[1] = ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[1]) | ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[0]) | ( funct_flopped[3] & funct_flopped[1] & funct_flopped[0]);
assign mux2_select[0] = funct_flopped[2] | ( funct_flopped[3] & ~funct_flopped[1])  | (funct_flopped[1] & funct_flopped [0]);
assign mux3_select = (funct_flopped[3] & ~funct_flopped[1]) + (funct_flopped[2] & funct_flopped[1] & funct_flopped[0]);
assign mux5_select = funct_flopped[3] | (~funct_flopped[2] & funct_flopped[0]) | (funct_flopped[2] & ~funct_flopped[0])  | (funct_flopped[2] & ~funct_flopped[1]) ;

//final multiplier
wire [73:0] mult_out;

wire [31:0] mult_ip_a;
wire [31:0] mult_ip_b;
wire [31:0] mult_out_fp;
wire [4:0] mult_flags;
reg [31:0] mult_out_flopped_1;
reg [31:0] mult_out_flopped_2;

assign mult_ip_a = ay_flopped;
assign mult_ip_b = az_flopped;

	wire [31:0]a;
	wire [31:0]b;
	
	assign a= mult_ip_a;
	assign b= mult_ip_b;
	
	wire Sa ;										// A's sign
	wire Sb ;										// B's sign
	wire [7:0] Ea ;								// A's exponent
	wire [7:0] Eb ;								// B's exponent
	wire [47:0] Mp ;							// Mantissa product
	wire [4:0] InputExc ;						// Input numbers are exceptions

	wire Sp ;								// Product sign
	wire [8:0] NormE ;													// Normalized exponent
	wire [22:0] NormM ;												// Normalized mantissa
	wire GRS ;
	
	wire [110:0]pipe_1;
	wire [38:0]pipe_2;
	
	//FPMult_a M1 (a, b, Sa, Sb, Ea, Eb, Mp, InputExc) ;
	
	// Internal signals							// If signal is high...
	wire ANaN ;										// A is a signalling NaN
	wire BNaN ;										// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
	wire [47:0] PCOUT1 ;

	assign ANaN = &(a[30:23]) & |(a[30:23]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(b[30:23]) & |(b[22:0]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(a[30:23]) & ~|(a[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	assign BInf = &(b[30:23]) & ~|(b[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	//assign InputExc = {(ANaN | ANaN | BNaN |BNaN), ANaN, ANaN, BNaN,BNaN} ;
	
	// Take input numbers apart
	assign Sa = a[31] ;							// A's sign
	assign Sb = b[31] ;							// B's sign
	assign Ea = (a[30:23]);						// Store A's exponent in Ea, unless A is an exception
	assign Eb = (b[30:23]);						// Store B's exponent in Eb, unless B is an exception	
	
	
	assign Mp = mult_out[47:0];
	//assign Mp = ({7'b0000001, a[22:0]}*{12'b000000000001, b[22:17]}) ;
	FPMult_b M2 (pipe_1[110:88],pipe_1[87:71],pipe_1[52:5],pipe_1[68:61],pipe_1[60:53],pipe_1[70],pipe_1[69],Sp,NormE,NormM,GRS);
	FPMult_c M3 (pipe_2[22:0],pipe_2[31:23],pipe_2[32],pipe_2[33],pipe_2[38:34],mult_out_fp, );
	
	assign pipe_1 = {a[22:0], b[16:0], Sa, Sb, Ea[7:0], Eb[7:0], Mp[47:0], InputExc[4:0]} ;
	assign pipe_2 = {pipe_1[4:0], GRS ,Sp, NormE, NormM};

always @(posedge clk) begin
	if (reset) begin
    mult_out_flopped_1 <= 0;
    mult_out_flopped_2 <= 0;
  end else begin
    mult_out_flopped_1 <= mult_out_fp;
    mult_out_flopped_2 <= mult_out_flopped_1;
  end
end

wire [31:0] adder_ip_a;
wire [31:0] adder_ip_b;
wire [31:0] mux1_out;
reg [31:0] mux1_out_flopped_1;
reg [31:0] mux1_out_flopped_2;
reg [31:0] mux1_out_flopped_3;
wire [31:0] mux2_out;
wire [31:0] mux4_out;
wire [31:0] adder_out;
//wire [4:0] adder_flags;
wire operation;


assign operation = ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[0]) | ( ~funct_flopped[3] & ~funct_flopped[1] & ~funct_flopped[0])  | ( funct_flopped[3] & ~funct_flopped[1] & funct_flopped[0]);

assign mux1_out = mux1_select ? chainin: ax_flopped;

//Three flop stages at the input of the adder 
always @(posedge clk) begin
	if (reset) begin
    mux1_out_flopped_1 <= 0;
    mux1_out_flopped_2 <= 0;
    mux1_out_flopped_3 <= 0;
  end else begin
    mux1_out_flopped_1 <= mux1_out;
    mux1_out_flopped_2 <= mux1_out_flopped_1;
    mux1_out_flopped_3 <= mux1_out_flopped_2;
  end
end

assign mux4_out = accumulate ? resulta_flopped : mux1_out_flopped_3;
assign mux2_out= mux2_select[1] ? ( mux2_select[0] ? ax_flopped : ay_flopped) : ( mux2_select[0] ? mult_out_flopped_2 : 32'd0);

assign adder_ip_a = mux4_out;
assign adder_ip_b = mux2_out;

FPAddSub_single Adder ( clk, reset, adder_ip_a , adder_ip_b , operation, adder_out,  );

wire [31:0] mux3_out;
assign mux3_out = mux3_select ? ax_flopped : resulta_flopped;
assign chainout_1 = mux3_out;

wire [31:0] resulta_fp;
wire [31:0] mux5_out;

assign mux5_out = mux5_select ? adder_out : mult_out_flopped_2;
assign resulta_fp = mux5_out;

reg [31:0] resulta_flopped_1;

always @(posedge clk) begin
	if (reset) begin
		resulta_flopped_1 <= 0;
    	end else begin
		resulta_flopped_1 <= resulta_fp;
    	end
end

assign resulta_flopped = resulta_flopped_1;
//dsp_slice_fp32 (clk, enable, reset, stream_flopped_1[99:96], chainin[31:0], accumulate_flopped_1, stream_flopped_1[31:0], stream_flopped_1[63:32], stream_flopped_1[95:64], chainout_1, resulta_flopped );

//////////////////////////////////////////////////
always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_2 <= 0 ;
 accumulate_flopped_2 <= 0 ;
 negate_flopped_2 <= 0 ;
 sub_flopped_2 <= 0 ;
 mode_flopped_2 <= 0 ;
 stream_flopped_2 <= 0 ;
 mux9_select_flopped_2 <= 0;
 internal_coeffa_flopped_2 <= 0;
internal_coeffb_flopped_2 <= 0;
end
else begin
 loadconst_flopped_2 <= loadconst_flopped_1;
 accumulate_flopped_2 <= accumulate_flopped_1;
 negate_flopped_2 <= negate_flopped_1;
 sub_flopped_2 <= sub_flopped_1;
 mode_flopped_2 <= mode_flopped_1;
 stream_flopped_2 <= stream_flopped_1;
 mux9_select_flopped_2 <= mux9_select_flopped_1;
 internal_coeffa_flopped_2 <= internal_coeffa_flopped_1;
 internal_coeffb_flopped_2 <= internal_coeffb_flopped_1;
end
end

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_3 <= 0 ;
 accumulate_flopped_3 <= 0 ;
 negate_flopped_3 <= 0 ;
 sub_flopped_3 <= 0 ;
 mode_flopped_3 <= 0 ;
 stream_flopped_3 <= 0 ;
 mux9_select_flopped_3 <= 0;
internal_coeffa_flopped_3 <= 0;
internal_coeffb_flopped_3 <= 0;

end
else begin
 loadconst_flopped_3 <= loadconst_flopped_2;
 accumulate_flopped_3 <= accumulate_flopped_2;
 negate_flopped_3 <= negate_flopped_2;
 sub_flopped_3 <= sub_flopped_2;
 mode_flopped_3 <= mode_flopped_2;
 stream_flopped_3 <= stream_flopped_2;
mux9_select_flopped_3 <= mux9_select_flopped_2;
internal_coeffa_flopped_3 <= internal_coeffa_flopped_2;
internal_coeffb_flopped_3 <= internal_coeffb_flopped_2;
end
end

//preadder
wire [37:0] preadder_out; //preadder_out = adder2, adder1 for 18/19 mode and its the entire output for 27 bit mode (0 extended to 38 bits)
pre_adder_combined preadder( .IN1 (stream_flopped_3 [36:0]), .IN2 (stream_flopped_3 [73:37]), .OUT1 (preadder_out), .mode (mode_flopped_3[0]));

//internal coeffbank
reg [17:0]coeffbank_a [0:7];
initial begin
coeffbank_a[0] <= 18'h1111;  coeffbank_a[1] <= 18'h2222; coeffbank_a[2] <= 18'h3333; coeffbank_a[3] <= 18'h4444;
coeffbank_a[4] <= 18'h5555;  coeffbank_a[5] <= 18'h6666; coeffbank_a[6] <= 18'h7777; coeffbank_a[7] <= 18'h8888; 
end

reg [17:0]coeffbank_b [0:7];
initial begin
coeffbank_b[0] <= 18'h1111;  coeffbank_b[1] <= 18'h2222; coeffbank_b[2] <= 18'h3333; coeffbank_b[3] <= 18'h4444;
coeffbank_b[4] <= 18'h5555;  coeffbank_b[5] <= 18'h6666; coeffbank_b[6] <= 18'h7777; coeffbank_b[7] <= 18'h8888; 
end

//multiplier
reg [36:0] mult_ip_1;
reg [36:0] mult_ip_2;

//define these as inputs later
assign mux_select_1= internal_coeffa_flopped_3;
assign mux_select_2= internal_coeffb_flopped_3;

reg mode_bit;

always @ (*) begin
if (mode_flopped_1[1] == 1'b1) begin
mult_ip_1 = {5'b00001, a[22:0]};
mult_ip_2 = {12'b000000000001, b[22:17]};
mode_bit =1'b1;
end

else if (mode_flopped_3[0] ==1'b0) begin
mult_ip_1 =  mux_select_1 ? { coeffbank_a[stream_flopped_3[112:110]], preadder_out[18:0]}: {stream_flopped_3[91:74] , preadder_out[18:0]};
mult_ip_2 =  mux_select_2 ? { coeffbank_b[stream_flopped_3[115:113]], preadder_out[37:19]}: {stream_flopped_3[109:92] , preadder_out[37:19]};
 mode_bit =1'b0;
end

else if (mode_flopped_3[0] == 1'b1) begin
mult_ip_1 = {9'b0, preadder_out[27:0] } ;
mult_ip_2 = mux_select_1 ? { 10'b0, coeffbank_b[stream_flopped_3[115:113]][8:0], coeffbank_a[stream_flopped_3[112:110]] } : {10'b0, stream_flopped_3[79:53]};
 mode_bit =1'b1;
end
end

Multiplier_combined multiplier( mult_ip_1, mult_ip_2 ,mult_out, mode_bit); //mult_out= {mult2 out , mult1 out} for 18/19 bit mode, for 27 bit mode, it's just one mult output

reg [53:0] temp_signal;
always @ (*) begin
if (mode_flopped_3[0] ==1'b0) begin 
temp_signal = sub_flopped_3 ?  mult_out[36:0] - mult_out[73:37] : mult_out[36:0] + mult_out[73:37] ;
end
else if (mode_flopped_3[0] ==1'b1) begin 
temp_signal =  mult_out [53:0];
end
end

wire [63:0]negate_out;
assign negate_out = negate_flopped_3 ? ~temp_signal + 1: temp_signal;


/*
//27*27////////////////////////////////////////////////
module chainout_add_acc(accumulate, loadconst, negate, data_1, chainin, data_2, data_out);
input accumulate;
input loadconst;
input negate;
input [63 : 0]data_1;
input [63 : 0]chainin;
input [53 : 0]data_2;
output [63 : 0]data_out;
assign data_out = accumulate ? data_1 + data_2 : ( loadconst ? data_1 : ( negate ? data_2 + chainin : data_2 ));
endmodule 

assign mux6_out = accumulate_flopped_3 ? double_acc_flopped : ( loadconst_flopped_3 ? constant_flopped_3 : 64'd0 );
chainout_add_acc M4 (accumulate_flopped_3, loadconst_flopped_3, negate_flopped_3, mux6_out, chainin, inverse_out, chainout_add_acc_out );


//18*19///////////////////////////////////////////////////////////////////////////////
module chainout_add_acc(accumulate, negate, data_1, chainin, data_2, data_out);
input accumulate;
input negate;
input [73 : 0]data_1;
input [63 : 0]chainin;
input [37 : 0]data_2;
output [73 : 0]data_out;
assign data_out = accumulate ? data_1 + data_2 : ( negate ? data_2 + chainin : data_1 );
endmodule

////////////
reg [37:0]double_acc_flopped;
wire[73:0] mux10_out;
assign mux10_out = accumulate_flopped_3 ? double_acc_flopped: ( loadconst_flopped_3 ? constant_flopped_3 : 32'd0 );

wire [73:0]add_acc_out;
chainout_add_acc M7(accumulate_flopped_3, negate_flopped_3, mux10_out, chainin, inverse_out, add_acc_out);
/////////

*/
// negate_out : 64 bits
// chainin : 64 bits
// mux10_out: resulta size - 64 bits
// constant: 64 bits
// out data: 64 bits 

wire [63:0]data_out;
reg [63:0] constant;
wire [63:0] mux10_out;
reg [63:0]double_acc_flopped;

initial begin
constant <= 64'h1234567887654321;
end

assign mux10_out = accumulate_flopped_3 ? double_acc_flopped: ( loadconst_flopped_3 ? constant : 64'd0 );
assign data_out = accumulate_flopped_3 ? negate_out + mux10_out : ( loadconst_flopped_3 ? mux10_out : ( negate_flopped_3 ? negate_out + chainin : negate_out ));

wire[99:0] mux9_out;
assign mux9_out = mux9_select_flopped_3 ? {36'd0, data_out} : { mult_out[72:37] ,28'd0, mult_out[35:0]};

reg [99:0] output_register_bank;
//output register bank
always @(posedge clk) begin
	if (reset) begin
		output_register_bank <= 0;
		double_acc_flopped <= 0;
    	end else begin
      		output_register_bank<=mux9_out;
		double_acc_flopped <= mux9_out[63:0];
    	end
end

assign resulta = mode_flopped_3[1] ? resulta_flopped : output_register_bank [63:0];
assign resultb = mode_flopped_3[1] ? 37'b0 : output_register_bank [99:64];
assign chainout= mode_flopped_3[1] ? chainout_1 : output_register_bank [63:0];

endmodule
