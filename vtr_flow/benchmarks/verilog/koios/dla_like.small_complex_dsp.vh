/*
 * dla_like.small design including complex dsp definition
*/

`define complex_dsp
module DLA (
	input clk,
	input i_reset,
	input [15:0] i_ddr_0_0,
	output o_dummy_out_0_0,
	input [15:0] i_ddr_0_1,
	output o_dummy_out_0_1,
	input [15:0] i_ddr_1_0,
	output o_dummy_out_1_0,
	input [15:0] i_ddr_1_1,
	output o_dummy_out_1_1,
	input [15:0] i_ddr_2_0,
	output o_dummy_out_2_0,
	input [15:0] i_ddr_2_1,
	output o_dummy_out_2_1,
	input [15:0] i_ddr_3_0,
	output o_dummy_out_3_0,
	input [15:0] i_ddr_3_1,
	output o_dummy_out_3_1,
	input [15:0] i_ddr_4_0,
	output o_dummy_out_4_0,
	input [15:0] i_ddr_4_1,
	output o_dummy_out_4_1,
	input [15:0] i_ddr_5_0,
	output o_dummy_out_5_0,
	input [15:0] i_ddr_5_1,
	output o_dummy_out_5_1,
	output o_valid
);

`include "./generic_circuits/dla_like.small.v"
