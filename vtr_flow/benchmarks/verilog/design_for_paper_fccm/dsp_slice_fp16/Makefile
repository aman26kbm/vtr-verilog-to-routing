export VCS_HOME /usr/local/packages/synopsys_2018/vcs-mx/O-2018.09-SP1
#export VCS_HOME /home/tools/vcs/mx-2017.12-SP1-1

all: compile run

compile:
	$(VCS_HOME)/bin/vcs -full64 \
	dsp_slice.stratix10.fp16.v \
	-sverilog \
	-debug_access+all \
	-timescale=1ns/1ps \
	-y /home/projects/ljohn/aarora1/vtr_aman/vtr-verilog-to-routing/vtr_flow/benchmarks/verilog/design_for_paper_fccm/fpmult_add/DSP48E1-FP/src/FPMult \
	-v /home/projects/ljohn/aarora1/vtr_aman/vtr-verilog-to-routing/vtr_flow/benchmarks/verilog/design_for_paper_fccm/fpmult_add/DSP48E1-FP/src/FPMult \
	-y /home/projects/ljohn/aarora1/vtr_aman/vtr-verilog-to-routing/vtr_flow/benchmarks/verilog/design_for_paper_fccm/fpmult_add/DSP48E1-FP/src/FP_AddSub \
	-v /home/projects/ljohn/aarora1/vtr_aman/vtr-verilog-to-routing/vtr_flow/benchmarks/verilog/design_for_paper_fccm/fpmult_add/DSP48E1-FP/src/FP_AddSub \
  -y /misc/linuxws/packages/synopsys_2018/syn/O-2018.06-SP5/dw/sim_ver \
  -v /misc/linuxws/packages/synopsys_2018/syn/O-2018.06-SP5/dw/sim_ver \
	+libext+.v

#-y /home/tools/synopsys/syn_2017.09/dw/sim_ver \
#-v /home/tools/synopsys/syn_2017.09/dw/sim_ver \

run:
	./simv

waves:
	$(VCS_HOME)/bin/dve -vpd vcdplus.vpd

clean:
	\rm -rf csrc DVEFiles simv.daidir simv ucli.key vcdplus.vpd *.syn *.pvl *.mr *.svf command.log

synth:
	design_vision -64bit -f synth.cmd.fp16
