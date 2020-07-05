`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:32:54 09/07/2012
// Design Name:   FPAddSub_LNCModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FBAddSub_LNCModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_LNCModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_LNCModule_tb;

	// Inputs
	reg [31:0] A;

	// Outputs
	wire [5:0] Z;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_LNCModule uut (
		.A(A), 
		.Z(Z)
	);

	initial begin
		// Initialize Inputs
		A = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 A = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
		#10 A = 32'b0100_0000_0000_0000_0000_0000_0000_0000;
		#10 A = 32'b0010_0000_0000_0011_0000_0000_0000_0000;
		#10 A = 32'b0001_0000_0000_0100_0100_0000_0000_0000;
		#10 A = 32'b0000_1000_0000_0000_0100_0000_0000_0000;
		#10 A = 32'b0000_0100_0000_0111_1000_0000_0000_0000;
		#10 A = 32'b0000_0010_0000_0000_1000_0000_0000_0000;
		#10 A = 32'b0000_0001_1111_0000_0000_0000_0001_0000;
		#10 A = 32'b0000_0000_1111_1111_1111_0000_0001_0000;
		#10 A = 32'b0000_0000_0111_0000_0100_0000_0000_0000;
		#10 A = 32'b0000_0000_0010_0000_0000_0000_0000_0000;
		#10 A = 32'b0000_0000_0001_0000_0000_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0100_0100_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0010_0001_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0001_0001_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_1000_1111_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0100_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0010_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_1000_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0100_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0010_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0001_0000_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_1000_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0010_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0000_1110;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
		#10 A = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
		#10 $finish;
	end
      
endmodule
