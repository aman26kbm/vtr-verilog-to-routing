clean:
	rm -rf *.mr *.pvl *.syn command.log default.svf filenames.log

synth:
	design_vision -64bit -f synth.cmd.4x4

synth_reduced_freq:
	design_vision -64bit -f synth.cmd.4x4.reduced_freq
