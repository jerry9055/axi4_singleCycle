OBJ_DIR = build
ELF_NAME = elf
#V_FILE = $(shell find vsrc/ -name "*.v")
V_FILE = vsrc/top.v
CPP_FILE = $(shell find cppsrc/  -name "*.cpp")

V_TOP ?= top

V_FLAG = --cc --exe --trace -Wall $(V_FILE) $(CPP_FILE) \
		--Mdir $(OBJ_DIR) -o $(ELF_NAME) \
		+incdir+vsrc --top-module $(V_TOP) \
		-LDFLAGS "-ldl -O0"

ifdef DIFF
V_FLAG += -CFLAGS "-D DIFF_TEST"
endif
DIFF_REF_SO = /home/lary/Documents/gitcode/oscpu/nemu/build/riscv64-nemu-interpreter-so


#############   BIN    ########
ifdef TEST
BIN = /home/lary/Documents/gitcode/ysyx/am-kernels/tests/cpu-tests/build/$(TEST)-riscv64-mycpu.bin			#am/cpu-test
endif
ifdef RVTEST
BIN = /home/lary/Documents/gitcode/ysyx/riscv-tests/build/$(RVTEST)-riscv64-mycpu.bin	#riscv-test
endif
# BIN ?= test.bin
# BIN ?= /home/lary/Documents/gitcode/ysyx/am-kernels/tests/am-tests/build/amtest-riscv64-mycpu.bin	#am/am-test
BIN ?= /home/lary/Documents/gitcode/ysyx/am-kernels/kernels/hello/build/hello-riscv64-mycpu.bin #hello


ARGS = --diff=$(DIFF_REF_SO) $(BIN)


.PHONY:
run:
	verilator $(V_FLAG) 
	make -C $(OBJ_DIR) -f V$(V_TOP).mk 
	./$(OBJ_DIR)/$(ELF_NAME) $(ARGS)

gdb:
	verilator $(V_FLAG) -CFLAGS "-ggdb3 -O0"
	make -C $(OBJ_DIR) -f V$(V_TOP).mk
	gdb -s $(OBJ_DIR)/$(ELF_NAME) --args ./$(OBJ_DIR)/$(ELF_NAME) $(ARGS)

clean:
	rm -rf $(OBJ_DIR) waves.vcd *.txt

