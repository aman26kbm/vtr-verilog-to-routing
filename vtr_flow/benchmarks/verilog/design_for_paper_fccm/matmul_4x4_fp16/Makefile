export VCS_HOME /home/tools/vcs/mx-2017.12-SP1-1

all: compile run

compile:
	$(VCS_HOME)/bin/vcs \
	4x4_from_4x4_regular_fpga.fp16.v \
	mat_mul_4x4.sys.alt.output_to_mem.tb.fp16.v \
	-sverilog \
	-debug_access+all \
	-y /home/tools/synopsys/syn_2017.09/dw/sim_ver \
	-v /home/tools/synopsys/syn_2017.09/dw/sim_ver \
	+libext+.v


run:
	./simv

waves:
	$(VCS_HOME)/bin/dve -vpd vcdplus.vpd

clean:
	\rm -rf csrc DVEFiles simv.daidir simv ucli.key vcdplus.vpd *.syn *.pvl *.mr *.svf command.log

