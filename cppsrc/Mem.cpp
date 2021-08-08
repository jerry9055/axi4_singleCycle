#include "Mem.h"
#include <iostream>
#include <string.h>
#include <assert.h>

using namespace std;

Mem::Mem(char* imgFile) {
    this->__imgFile = NULL;
    this->__imgSize = 0;
    this->__pmem = NULL;

    FILE* fp = this->SetImgfile(imgFile);
    this->CreatePmem();
    this->LoadImgfile(fp);
    
    cout << "[Memory active]" << endl;
}

Mem::~Mem() {
    delete __pmem;
    __pmem = NULL;
    this->__imgSize = 0;
    this->__imgFile = NULL;
    cout << "[Memory releases]" << endl;
}

bool Mem::InMem(uint64_t addr) {
    return PMEM_BASE <= addr && addr <= PMEM_BASE + PMEM_SIZE;
}

word Mem::ReadMem(uint64_t addr, int len) {
    void *p = this->__pmem + addr - PMEM_BASE;
    switch (len) {
        case 1: return *(uint8_t  *)p;
        case 2: return *(uint16_t *)p;
        case 4: return *(uint32_t *)p;
        case 8: return *(uint64_t *)p;
        default: assert(0);
    }
}

void* Mem::GetMemAddr(uint64_t addr) {
    return this->__pmem + addr;
}

size_t Mem::GetImgSize() {
    return this->__imgSize;
}

void Mem::CreatePmem() {
    if (this->__pmem == NULL) {
        this->__pmem = (uint8_t*) calloc(PMEM_SIZE, sizeof(uint8_t));
    }
}

FILE* Mem::SetImgfile(char* imgFile) {
    if (imgFile == NULL) {
        cout << "[" << __FILE__ << ":" << __LINE__ <<"] LoadImg empty" << endl;
        exit(0);
    }

    FILE* fp = fopen(imgFile, "r");
    if (!fp) {
        cout << "[" << __FILE__ << ":" << __LINE__ <<"] LoadImg fail" << endl;
        exit(0);
    }

    this->__imgFile = imgFile;
    return fp;
}

void Mem::LoadImgfile(FILE* fp) {
    assert(fp != NULL);

    fseek(fp, 0, SEEK_END);
    this->__imgSize = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    size_t ret = fread(this->__pmem, this->__imgSize, 1, fp);
    fclose(fp);
    fp = NULL;
    if (!ret) {
        cout << "[LoadImg fail] fread error" << endl;
        exit(0);
    } else {
        cout << "[LoadImg succeed] Img: " << __imgFile << endl;
    }
}

void Mem::SetMem(uint64_t addr, uint64_t data, int len) {
    void *p = __pmem + addr - PMEM_BASE;
    switch (len) {
        case 1: *(uint8_t  *)p = data; return;
        case 2: *(uint16_t *)p = data; return;
        case 4: *(uint32_t *)p = data; return;
        case 8: *(uint64_t *)p = data; return;
        default: assert(0);
    }
}