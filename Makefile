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

DIFF_REF_SO = /home/ly/single/gitcode/oscpu/nemu/build/riscv64-nemu-interpreter-so

ifdef TEST
BIN = /home/ly/single/gitcode/ysyx/am-kernels/tests/cpu-tests/build/$(TEST)-riscv64-mycpu.bin			#am/cpu-test
endif

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

