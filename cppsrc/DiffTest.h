#include <stdint.h>

typedef struct {
  union {
    uint64_t _64;
  } gpr[32];

  uint64_t pc;
  uint64_t mstatus, mcause, mepc;
  uint64_t sstatus, scause, sepc;

  uint8_t mode;

  bool amo;
  int mem_exception;

  // for LR/SC
  uint64_t lr_addr;

  bool INTR;
  
} CPU_state;

#define FMT_WORD "0x%016lX"
#define FMT_HALF_WORD "0x%08lX"