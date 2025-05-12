COVERAGE=0
ITR=15
TOP=ahb_tb_top
ifeq ($(COVERAGE),1)
	cmp=-coveropt 3 +cover +acc +incdir+../ENV +incdir+../TEST ../RTL/design.sv ../TEST/ahb_pkg.sv ../TOP/testbench.sv
else
	cmp=+incdir+../ENV +incdir+../TEST ../RTL/design.sv ../TEST/ahb_pkg.sv ../TOP/testbench.sv
endif
compile:
	vlib work
	vlog $(cmp)

sim_gui:
	@echo "Running with test $(TEST)"
	vsim -voptargs=+acc $(TOP) $(TEST)

sim_cov:
	@echo "Running coverage with test $(TEST)"
	vsim -coverage $(TOP)  -c -do "coverage save -onexit -directive -cvg -codeall cover.ucdb;run -all; exit;" +iter=$(ITR) $(TEST)

reg_sim:
	mkdir -p log
	mkdir -p cover
	echo "regression run!!"
	vsim -coverage $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall cover/reset_test.ucdb;run -all; exit;" +iter=$(ITR) +RESET_TEST -l log/RESET_TEST.log
	vsim -coverage $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall cover/write_test.ucdb;run -all; exit;" +iter=$(ITR) +WRITE_TEST -l log/WRITE_TEST.log
	vsim -coverage $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall cover/read_test.ucdb;run -all; exit;" +iter=$(ITR) +READ_TEST -l log/READ_TEST.log
	vsim -coverage $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall cover/sim_rw_test.ucdb;run -all; exit;" +iter=$(ITR) +SIM_RW_TEST -l log/SIM_RW_TEST.log
	vsim -coverage $(TOP) -c -do "coverage save -onexit -directive -cvg -codeall cover/back2back_test.ucdb;run -all; exit;" +iter=$(ITR) +BACK2BACK_TEST -l log/BACK2BACK_TEST.log

vcover:
	vcover merge ram_cover.ucdb cover/reset_test.ucdb cover/read_test.ucdb cover/write_test.ucdb cover/sim_rw_test.ucdb cover/back2back_test.ucdb
	vcover report -details -html -htmldir ram_cover_report ram_cover.ucdb
