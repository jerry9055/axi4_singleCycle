#include <stdint.h>
#include "Mem.h"
#include "verilated.h"
#include "Vtop.h"
#include "verilated_vcd_c.h"

// #undef VM_TRACE

class Emulator {
    public:
        Emulator(int, char**);
        ~Emulator();
        void Run();
        void Record(uint64_t);
        Mem* GetMem();
        void Stop();
    private:
        uint64_t __time_main;
        char* __log_file;
        char* __ref_so_file;
        Mem* __mem;
        Vtop* __top;
        #ifdef VM_TRACE
        VerilatedVcdC* __fp;
        #endif
        bool __diffCheck;

        void ParseArgs(int, char**);
        void CreateMem(char*);
        void CreateVtop();
        void CreateVcd();
        void Reset();
        void ReleaseMem();
        void ReleaseVtop();
        void ReleaseVcd();
        void ShowStopState();
        void InitDiffTest();
        void (*ref_difftest_memcpy_from_dut) (uint64_t, void*, size_t);
        void (*ref_difftest_getregs) (void*);
        void (*ref_difftest_setregs) (const void*);
        void (*ref_difftest_exec) (uint64_t);
        bool DiffTestCheck();
};