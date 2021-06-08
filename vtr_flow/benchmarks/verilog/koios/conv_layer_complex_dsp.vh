/*
 * conv_layer_hls design including complex dsp definition
*/

`define complex_dsp
module dpram ( 

    clk, 

    address_a, 

    address_b, 

    wren_a, 

    wren_b, 

    data_a, 

    data_b, 

    out_a, 

    out_b 

); 

`include "./generic_circuits/conv_layer_hls.v"
