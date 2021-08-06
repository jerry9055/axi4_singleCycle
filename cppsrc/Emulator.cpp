#include <stddef.h>
#include <assert.h>
#include <iostream>
#include <iomanip>
#include <getopt.h>
#include <dlfcn.h>
#include "Emulator.h"
#include "DiffTest.h"
#include "AXI4.h"

using namespace std;

#define MAX(a,b) ((a) > (b) ? (a) : (b))
#define MIN(a,b) ((a) < (b) ? (a) : (b))

static uint64_t time_record_beg = 0;
static uint64_t time_record_end = 0;

Emulator::Emulator(int argc, char** argv) {
    assert(argv != NULL && argc > 1);
    this->__time_main = 0;
    this->__log_file = NULL;
    this->__ref_so_file = NULL;
    this->__mem = NULL;
    this->__top = NULL;
    #ifdef VM_TRACE
    this->__fp = NULL;
    #endif
    this->__diffCheck = true;
    ref_difftest_memcpy_from_dut = NULL;
    ref_difftest_getregs = NULL;
    ref_difftest_setregs = NULL;
    ref_difftest_exec = NULL;

    Verilated::commandArgs(argc, argv);
    this->ParseArgs(argc, argv);
    this->CreateMem(NULL);
    this->CreateVtop();
    this->CreateVcd();
    this->InitDiffTest();

    cout << "[Emulator active]" << endl;
}

Emulator::~Emulator() {    
    this->ReleaseMem();
    this->ReleaseVcd();
    this->ReleaseVtop();
}

void Emulator::Run() {
    assert(__top);

    this->Reset();
    // for (int i = 0; i < 60000; i++) {
    while (1) {
        __top->clk = 0;
        __top->eval();
        Record(__time_main ++);

        __top->clk = 1;
        __top->eval();
        Record(__time_main ++);

        if (__top->fetch_pulse) {
            __diffCheck = DiffTestCheck();
            if (__diffCheck == false) break;
        }
        if (__top->unknown_op == true) break;
        if (__top->rresp != e_xResp_OKAY) break;
        if (__top->bresp != e_xResp_OKAY) break;
    }
}

void Emulator::ParseArgs(int argc, char** argv) {
    const struct option table[] = {
    {"log"      , required_argument, NULL, 'l'},
    {"diff"     , required_argument, NULL, 'd'},
    {"help"     , no_argument      , NULL, 'h'},
    {0          , 0                , NULL,  0 },
  };
  int o;
  while ( (o = getopt_long(argc, argv, "-bhl:d:", table, NULL)) != -1) {
    switch (o) {
      case 'l': this->__log_file = optarg; break;
      case 'd': this->__ref_so_file = optarg; break;
      case 1:
        if (this->__mem != NULL) cout << "too much argument '" << optarg << "', ignored" << endl;
        else this->CreateMem(optarg);
        break;
      default:
        cout << "Usage: " << argv[0] << "[OPTION...] IMAGE" << endl;
        cout << "\t-l,--log=FILE           output log to FILE" << endl;
        cout << "\t-d,--diff=REF_SO        run DiffTest with reference REF_SO" << endl;
        exit(0);
    }
  }
}

void Emulator::CreateMem(char* imgfile) {
    if (this->__mem == NULL) {
        this->__mem = new Mem(imgfile);
    }
}

//this function should execute after CreateVtop()
void Emulator::CreateVcd() {
    if (this->__top) {
        #ifdef VM_TRACE
        if (this->__fp == NULL) {            
            Verilated::traceEverOn(true);
            this->__fp = new VerilatedVcdC;
            if (!this->__fp) exit(1);
            this->__top->trace(this->__fp, 99);
            this->__fp->open("waves.vcd");
            cout << "[TRACE ON] wave save in file : waves.vcd" << endl;
        }
        #endif
    } else {
        cout << "Please Create Vtop first" << endl;
        exit(1);
    }
}

void Emulator::CreateVtop() {
    if (this->__top == NULL) {
        this->__top = new Vtop;
        cout << "[Vtop active]" << endl;
    }
}

Mem* Emulator::GetMem() {
    return this->__mem;
}

void Emulator::Reset() {
    assert(__top);

    __top->clk = 0;
    __top->reset = 1;
    __top->eval();
    __top->clk = 1;
    __top->reset = 1;
    __top->eval();
    Record(__time_main ++);
    __top->clk = 0;
    __top->eval();
    Record(__time_main ++);
    __top->reset = 0;
    __top->clk = 1;
    __top->eval();
    Record(__time_main ++);
}

void Emulator::Record(uint64_t t) {
    #ifdef VM_TRACE    
    if (__fp) {
        if (time_record_beg <= t && t <= time_record_end) {
            __fp->dump(t);
        }
    }
    #endif
}

void Emulator::ReleaseMem() {
    if (this->__mem) {
        delete this->__mem;
        this->__mem = NULL;
    }
}

void Emulator::ReleaseVtop() {
    if (this->__top) {
        delete this->__top;
        this->__top = NULL;
    }
}

// this function should execute before ReleaseVtop()
void Emulator::ReleaseVcd() {
    #ifdef VM_TRACE
    if (this->__fp) {
        this->__fp->close();
        delete this->__fp;
        this->__fp = NULL;
    }
    #endif
}

void Emulator::Stop() {
    this->ShowStopState();
    this->~Emulator();
    cout << "[Emulator releases] Emulate " << dec << __time_main <<" time steps "<< endl;
    #ifdef VM_TRACE
    if (__time_main > time_record_beg && time_record_beg != time_record_end) 
        cout << "[Trace] Record between time " << dec << time_record_beg << " and " << MIN(time_record_end, __time_main) << endl;
    #endif
}

void Emulator::ShowStopState() {
    assert(__top);
    uint64_t instr = GetMem()->ReadMem(__top->pc, 4);
    if (__top->unknown_op) {
        if (instr == 0x6B) {
            #ifdef DIFF_TEST
            ref_difftest_exec(1);
            #endif
        } else {
            cout << "[Emulate Abort] Unknown op at Dut.pc = 0x" << hex << setw(8) << setfill('0') << setiosflags(ios::uppercase) << __top->pc 
            << ", Instruction = 0x" << setw(8) << instr << endl;
        }
    } else if (__diffCheck == false) {
        cout << "[Emulate Abort] DiffTEST tells reason " << endl;
    } else if (__top->rresp != e_xResp_OKAY | __top->bresp != e_xResp_OKAY) {
        cout << "[Emulate Abort] Memory tells reason at pc = 0x" << __top->pc << ", Instruction = 0x" << setw(8) << setfill('0') << __mem->ReadMem(__top->pc, 4) << endl;
    } else {
        cout << "[Emulate Stop] Reasonable" << endl;
    }
}

void Emulator::InitDiffTest() {
    #ifndef DIFF_TEST
    return;
    #endif

    assert(__ref_so_file != NULL);

    void *handle;
    handle = dlopen(__ref_so_file, RTLD_LAZY | RTLD_DEEPBIND);
    if (!handle) {
        fprintf(stderr, "%s\n", dlerror());
        exit(EXIT_FAILURE);
    }

    ref_difftest_memcpy_from_dut = (void (*)(uint64_t, void*, size_t))dlsym(handle, "difftest_memcpy_from_dut");
    assert(ref_difftest_memcpy_from_dut);

    ref_difftest_getregs = (void (*)(void*)) dlsym(handle, "difftest_getregs");
    assert(ref_difftest_getregs);

    ref_difftest_setregs = (void (*) (const void*)) dlsym(handle, "difftest_setregs");
    assert(ref_difftest_setregs);

    ref_difftest_exec = (void (*)(u_int64_t)) dlsym(handle, "difftest_exec");
    assert(ref_difftest_exec);

    void (*ref_difftest_init)(void) = (void (*) (void)) dlsym(handle, "difftest_init");
    assert(ref_difftest_init);

    ref_difftest_init();
    // this four bytes overwrites an extra empty instruction,but in main loop the instruction should not work
    ref_difftest_memcpy_from_dut(PMEM_BASE, __mem->GetMemAddr(0), __mem->GetImgSize() + 4 );  

    cout << "[DIFFTEST ON] Ref: " << __ref_so_file << endl;
}

bool Emulator::DiffTestCheck() {
    #ifndef DIFF_TEST
    return true;
    #endif

    static CPU_state ref = { 0 };
    ref_difftest_getregs(&ref);
    uint64_t last_pc = ref.pc;
    ref_difftest_exec(1);
    ref_difftest_getregs(&ref);
    for (int i = 0; i < 32; i++) {
        if (__top->gpr[i] != ref.gpr[i]._64) {
            printf("[DiffTest] dut.gpr[%d] = " FMT_WORD ", ref.gpr[%d] = " FMT_WORD ", dut.pc = " FMT_WORD ", ref.pc = " FMT_WORD "\n", 
                                 i,    __top->gpr[i], i,    ref.gpr[i]._64,    __top->pc,      ref.pc);
            printf("[DiffTest] Error should occur at PC = " FMT_HALF_WORD ", Instruction = " FMT_HALF_WORD "\n", last_pc, __mem->ReadMem(last_pc, 4));
            return false;
        }
    }

     if (__top->pc != ref.pc) {
        cout << hex << setw(8) << "[DiffTest] dut.pc = 0x" << __top->pc << ", ref.pc = 0x" << ref.pc << endl;
        cout << "[DiffTest] Error should occur at PC = 0x" << last_pc << ", Instruction = 0x" << setw(8) << setfill('0') << __mem->ReadMem(last_pc, 4) << endl;
        return false;
    }

    return true;
}