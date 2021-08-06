#include <assert.h>
#include "AXI4.h"
#include "Emulator.h"
#include <iostream>
#include <iomanip>

using namespace std;

extern Emulator* emulator;
extern "C" void ReadData(uint64_t raddr, uint8_t arsize, uint64_t* rdata, uint8_t* rresp) {
    assert (emulator);
    Mem *mem = emulator->GetMem();
    assert(mem);

    if (mem->InMem(raddr)) {
        int len = 0;
        switch (arsize) {
            case e_AxSize_1B:    len = 1;    break;
            case e_AxSize_2B:    len = 2;    break;
            case e_AxSize_4B:    len = 4;    break;
            case e_AxSize_8B:    len = 8;    break;
            default: assert (0);
        }
        *rdata = mem->ReadMem(raddr, len);
        *rresp = e_xResp_OKAY;
    } else {
        *rdata = 0;
        *rresp = e_xResp_DECERR;
        cout << "[Memory Warning] Cannot access memory at address 0x"
        << setw(8) << hex << setfill('0') << setiosflags(ios::uppercase) << raddr << endl;
    }  
}

extern "C" void WriteData(uint64_t waddr, uint8_t awsize, uint64_t wdata, uint8_t* bresp) {
    assert (emulator);
    Mem *mem = emulator->GetMem();
    assert(mem);

    if (mem->InMem(waddr)) {
        int len = 0;
        switch (awsize) {
            case e_AxSize_1B:    len = 1;    break;
            case e_AxSize_2B:    len = 2;    break;
            case e_AxSize_4B:    len = 4;    break;
            case e_AxSize_8B:    len = 8;    break;
            default: assert (0);
        }
        mem->SetMem(waddr, wdata, len);
        *bresp = e_xResp_OKAY;
    } else {
        *bresp = e_xResp_DECERR;
        cout << "[Memory Warning] Cannot access memory at address 0x" 
        << setw(8) << hex << setfill('0') << setiosflags(ios::uppercase) << waddr << endl;
    }
}