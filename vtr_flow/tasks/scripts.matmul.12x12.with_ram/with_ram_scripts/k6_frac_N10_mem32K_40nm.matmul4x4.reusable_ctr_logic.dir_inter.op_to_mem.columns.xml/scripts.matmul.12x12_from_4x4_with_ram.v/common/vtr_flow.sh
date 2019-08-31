#!/bin/bash

VTR_RUNTIME_ESTIMATE_SECONDS=0
VTR_MEMORY_ESTIMATE_BYTES=0

VTR_RUNTIME_ESTIMATE_HUMAN_READABLE="0 seconds"
VTR_MEMORY_ESTIMATE_HUMAN_READABLE="0.00 MiB"

#We redirect all command output to both stdout and the log file with 'tee'.

#Begin I/O redirection
{

    /mnt/c/Users/zhigang/Desktop/LCA/VTR/vtr-verilog-to-routing/vtr_flow/scripts/run_vtr_flow.pl /mnt/c/Users/zhigang/Desktop/LCA/VTR/vtr-verilog-to-routing/vtr_flow/benchmarks/verilog/scripts/scripts.matmul.12x12_from_4x4_with_ram.v /mnt/c/Users/zhigang/Desktop/LCA/VTR/vtr-verilog-to-routing/vtr_flow/arch/timing/k6_frac_N10_mem32K_40nm.matmul4x4.reusable_ctr_logic.dir_inter.op_to_mem.columns.xml  -name 'scripts.matmul.12x12.with_ram: k6_frac_N10_mem32K_40nm.matmul4x4.reusable_ctr_logic.dir_inter.op_to_mem.columns.xml/scripts.matmul.12x12_from_4x4_with_ram.v/common'   -temp_dir . 

    #The IO redirection occurs in a sub-shell,
    #so we need to exit it with the correct code
    exit $?

} |& tee vtr_flow.out
#End I/O redirection

#We used a pipe to redirect IO.
#To get the correct exit status we need to exit with the
#status of the first element in the pipeline (i.e. the real
#command run above)
exit ${PIPESTATUS[0]}
