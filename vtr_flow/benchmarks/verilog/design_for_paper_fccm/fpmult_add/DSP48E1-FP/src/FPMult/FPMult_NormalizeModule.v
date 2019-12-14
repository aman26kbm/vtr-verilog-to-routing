`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    12:47:06 09/20/2012 
// Module Name:    FPMult_NormalizeModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_NormalizeModule(
		NormM,
		NormE,
		RoundE,
		RoundEP,
		RoundM,
		RoundMP
    );

	// Input Ports
	input [`MANTISSA-1:0] NormM ;									// Normalized mantissa
	input [`EXPONENT:0] NormE ;									// Normalized exponent

	// Output Ports
	output [`EXPONENT-1:0] RoundE ;
	output [`EXPONENT-1:0] RoundEP ;
	output [`MANTISSA-1:0] RoundM ;
	output [`MANTISSA-1:0] RoundMP ; 
	
	assign RoundE = NormE - 15 ;
	assign RoundEP = NormE - 14 ;
	assign RoundM = NormM ;
	assign RoundMP = NormM + 1 ;

endmodule
