#include <stdint.h>
#include <stddef.h>
#include <stdio.h>

#define PMEM_SIZE (128 * 1024 * 1024)
#define PMEM_BASE 0x80000000
typedef uint64_t word;

class Mem {
    public:
        Mem(char*);
        ~Mem();
        bool InMem(uint64_t);
        word ReadMem(uint64_t, int);
        void* GetMemAddr(uint64_t);
        size_t GetImgSize();
        void SetMem(uint64_t, uint64_t, int);
    private:
        uint8_t* __pmem;//assume that img has loaded into memory
        size_t __imgSize;
        char* __imgFile;

        void CreatePmem();
        FILE* SetImgfile(char*);
        void LoadImgfile(FILE*);
};