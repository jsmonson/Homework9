TOPLEVEL=test
VERILOG_FILES= package_test.sv factory_pkg.sv test_program.sv

.PHONY: TestGood
TestGood: factory
	vsim -c test -do "run -all" +TESTNAME=TestGood

.PHONY: TestBad
TestBad: factory
	vsim -c test -do "run -all" +TESTNAME=TestBad

.PHONY: Test_v3
Test_v3: factory
	vsim -c test -do "run -all" +TESTNAME=Test_v3

.PHONY: factory
factory: ${VERILOG_FILES} clean
	vlib work
	vmap work work
	vlog -mfcu -sv ${VERILOG_FILES}

clean:
	@rm -rf work transcript vsim.wlf