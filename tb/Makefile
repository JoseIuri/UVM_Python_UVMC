RTL_SRC = ../rtl/
MODEL_SRC = ../model/

IF = input_if.sv \
	output_if.sv
RTL =  ../rtl/adder.sv \


REFMOD = ../model/adder.cpp
PKGS = ./my_pkg.sv 

SEED = 100
COVER = 100
TRANSA = 5000

RUN_ARGS_COMMON = -access +r -input shm.tcl \
          +uvm_set_config_int=*,recording_detail,1 -coverage all -covoverwrite

PY3_COPTS=-I/usr/include/python3.6m
PY3_LOPTS=-lboost_python3 -lboost_system -lpython3.6m
PY3_OPTS=$(PY3_COPTS) $(PY3_LOPTS)

XCELIUM_UVMC_OPTS= -64bit -Wcxx -fPIC -dpi -g -sysc -scsynceverydelta on -tlm2 \
-DSC_INCLUDE_DYNAMIC_PROCESSES -DINCA -define INCA \
-uvm -access +r +uvm_set_config_int="*",recording_detail,1 \
-incdir $(UVMC_HOME)/src/connect/sv $(UVMC_HOME)/src/connect/sv/uvmc_pkg.sv \
-I$(XCELIUMHOME)/tools/systemc/include/tlm2/tlm_utils \
-I$(UVMC_HOME)/src/connect/sc \
$(UVMC_HOME)/src/connect/sc/uvmc.cpp -sc_main -I$(UVMC_HOME)/src/connect/sc

sim:
	@xrun $(XCELIUM_UVMC_OPTS) +incdir+$(RTL_SRC) $(IF) $(RTL) $(PKGS) top.sv -sv_lib test.so \
	+UVM_TESTNAME=simple_test -covtest simple_test-$(SEED) -svseed $(SEED)  \
	-defparam top.min_cover=$(COVER) -defparam top.min_transa=$(TRANSA) $(RUN_ARGS_COMMON) $(RUN_ARGS)

clean:
	@rm -rf INCA_libs waves.shm rtlsim/* *.history *.log rtlsim/* *.key mdv.log imc.log imc.key ncvlog_*.err *.trn *.dsn .simvision/ xcelium.d simv.daidir *.so *.o *.err

rebuild: clean sim

view_waves:
	simvision waves.shm &

view_cover:
	imc &