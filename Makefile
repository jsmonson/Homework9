TOPLEVEL=test
VERILOG_FILES= factory_pkg.sv test_program.sv 

questa_gui: 
	vlib work
	vmap work work
	vlog -mfcu -sv ${VERILOG_FILES}
	vsim -novopt -coverage -msgmode both -displaymsgmode both -do "view wave;do wave.do;run -all" ${TOPLEVEL}

questa_batch: ${VERILOG_FILES} clean
	vlib work
	vmap work work
	vlog -mfcu -sv ${VERILOG_FILES}
	vsim -c test -do "run -all" +TESTNAME=xyz

clean:
	@rm -rf work transcript vsim.wlf