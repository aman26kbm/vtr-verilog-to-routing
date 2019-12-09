`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    12:39:21 09/20/2012 
// Module Name:    FPMult_ExecuteModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_ExecuteModule(
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
	input [`MANTISSA-1:0] a ;
	input [`MANTISSA_MUL_SPLIT_LSB-1:0] b ;
	input [2*`ACTUAL_MANTISSA-1:0] MpC ;
	input [`EXPONENT-1:0] Ea ;						// A's exponent
	input [`EXPONENT-1:0] Eb ;						// B's exponent
	input Sa ;								// A's sign
	input Sb ;								// B's sign
	
	// Output ports
	output Sp ;								// Product sign
	output [`EXPONENT:0] NormE ;													// Normalized exponent
	output [`MANTISSA-1:0] NormM ;												// Normalized mantissa
	output GRS ;
	
	wire [2*`ACTUAL_MANTISSA-1:0] Mp ;
	wire [2*`ACTUAL_MANTISSA-1:0] Mp_temp ;
	
	assign Sp = (Sa ^ Sb) ;												// Equal signs give a positive product
	

    
    wire [`ACTUAL_MANTISSA-1:0] inp_a;
    wire [`ACTUAL_MANTISSA-1:0] inp_b;
    inp_a = {1'b1, a}
    inp_b = {{(`MANTISSA-`MANTISSA_MUL_SPLIT_LSB){1'b0}}, 1'b0, b};
    DW02_mult #(`ACTUAL_MANTISSA,`ACTUAL_MANTISSA) u_mult(.A(inp_a), .B(inp_b), .TC(1'b0), .PRODUCT(Mp_temp));
    DW01_add #(2*`ACTUAL_MANTISSA) u_add(.A(Mp_temp), .B(MpC<<`MANTISSA_MUL_SPLIT_LSB), .CI(1'b0), .SUM(Mp), .CO());

	//assign Mp = (MpC<<`MANTISSA_MUL_SPLIT_LSB) + ({7'b0000001, a[22:0]}*{1'b0, b[16:0]}) ;
	
	assign NormM = (Mp[2*`ACTUAL_MANTISSA-1] ? Mp[2*`MANTISSA_MSB+2:`MANTISSA_MSB+2] : Mp[2*`MANTISSA_MSB+1:`MANTISSA_MSB+1]); // Check for overflow
	assign NormE = (Ea + Eb + Mp[2*`ACTUAL_MANTISSA-1]);								// If so, increment exponent
	
	assign GRS = ((Mp[`MANTISSA_MSB+1]&(Mp[`MANTISSA_MSB+2]))|(|Mp[`MANTISSA_MSB:`MANTISSA_LSB])) ;
	
endmodule
