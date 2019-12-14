`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    22:01:03 09/20/2012 
// Module Name:    FPMult_RoundModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_ExceptionModule(
			RoundM,
			RoundE,
			Sgn,
			P
    );

	// Input ports
	input [`MANTISSA-1:0] RoundM ;							// Rounded mantissa
	input [`EXPONENT:0] RoundE ;								// Rounded exponent
	input Sgn ;											// Final sign
	
	// Output ports
	output [`DWIDTH-1:0] P ;									// The product
	
	// Add error checking here
	
	assign P = {Sgn, RoundE[`EXPONENT-1:0], RoundM} ;   // Putting the pieces together
	
endmodule
