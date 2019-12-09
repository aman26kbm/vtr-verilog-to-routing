`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:15 10/16/2012 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_PreAlignModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 The pre-alignment module is responsible for taking the inputs
//							apart, checking the parts for exceptions and feeding them to
//							the alignment module.
//
//////////////////////////////////////////////////////////////////////////////////

 module FPMult_PrepModule (
		clk,
		rst,
		a,
		b,
		Sa,
		Sb,
		Ea,
		Eb,
		Mp,
		InputExc
	);
	
	// Input ports
	input clk ;
	input rst ;
	input [`DWIDTH-1:0] a ;								// Input A, a 32-bit floating point number
	input [`DWIDTH-1:0] b ;								// Input B, a 32-bit floating point number
	
	// Output ports
	output Sa ;										// A's sign
	output Sb ;										// B's sign
	output [`EXPONENT-1:0] Ea ;								// A's exponent
	output [`EXPONENT-1:0] Eb ;								// B's exponent
	output [2*`ACTUAL_MANTISSA-1:0] Mp ;							// Mantissa product
	output [4:0] InputExc ;						// Input numbers are exceptions
	
	// Internal signals							// If signal is high...
	wire ANaN ;										// A is a signalling NaN
	wire BNaN ;										// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
    wire [`MANTISSA-1:0] Ma;
    wire [`MANTISSA-1:0] Mb;
	
	assign ANaN = &(a[`EXPONENT_MSB:`EXPONENT_LSB]) &  |(a[`EXPONENT_MSB:`EXPONENT_LSB]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(b[`EXPONENT_MSB:`EXPONENT_LSB]) &  |(b[`MANTISSA_MSB:`MANTISSA_LSB]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(a[`EXPONENT_MSB:`EXPONENT_LSB]) & ~|(a[`EXPONENT_MSB:`EXPONENT_LSB]) ;		// All one exponent and all zero mantissa - Infinity
	assign BInf = &(b[`EXPONENT_MSB:`EXPONENT_LSB]) & ~|(b[`EXPONENT_MSB:`EXPONENT_LSB]) ;		// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	//assign InputExc = {(ANaN | ANaN | BNaN |BNaN), ANaN, ANaN, BNaN,BNaN} ;
	
	// Take input numbers apart
	assign Sa = a[`SIGN_LOC] ;							// A's sign
	assign Sb = b[`SIGN_LOC] ;							// B's sign
	assign Ea = a[`EXPONENT_MSB:`EXPONENT_LSB];						// Store A's exponent in Ea, unless A is an exception
	assign Eb = b[`EXPONENT_MSB:`EXPONENT_LSB];						// Store B's exponent in Eb, unless B is an exception	
    assign Ma = a[`MANTISSA_MSB:`MANTISSA_LSB];
    assign Mb = b[`MANTISSA_MSB:`MANTISSA_LSB];
	
	//assign Mp = ({7'b0000001, a[22:0]}*{12'b0000000000001, b[22:17]}) ;
    //We multiply part of the mantissa here
    //Full mantissa of A
    //Bits MANTISSA_MUL_SPLIT_MSB:MANTISSA_MUL_SPLIT_LSB of B
    wire [`ACTUAL_MANTISSA-1:0] inp_A;
    wire [`ACTUAL_MANTISSA-1:0] inp_B;
    inp_A = {1'b1, Ma};
    inp_B = {{(`MANTISSA-(`MANTISSA_MUL_SPLIT_MSB-`MANTISSA_MUL_SPLIT_LSB+1)){1'b0}}, 1'b1, Mb[`MANTISSA_MUL_SPLIT_MSB:`MANTISSA_MUL_SPLIT_LSB]};
    DW02_mult #(`ACTUAL_MANTISSA,`ACTUAL_MANTISSA) u_mult(.A(inp_A), .B(inp_B), .TC(1'b0), .PRODUCT(Mp));
endmodule
