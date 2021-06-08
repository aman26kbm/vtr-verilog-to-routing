/*
 * tiny_darknet_like.small design including complex dsp definition
*/

`define complex_dsp
module td_fused_top_Block_entry_proc_proc392 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        tmp,
        ap_return
);

`include "./generic_circuits/tiny_darknet_like.small.v"
