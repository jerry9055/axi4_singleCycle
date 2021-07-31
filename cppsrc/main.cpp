#include <iostream>
#include <getopt.h>
#include "verilated.h"
#include "Vtop.h"
// #undef VM_TRACE
#ifdef VM_TRACE
#include "verilated_vcd_c.h"
VerilatedVcdC *fp;
#endif 

#define PMEM_SIZE (128 * 1024 * 1024)
//assume that img has loaded into memory
uint8_t my_pmem[PMEM_SIZE] = { 0 };

Vtop* top;
static uint64_t time_main = 0;
static char *img_file = NULL;
static char *log_file = NULL;
static char *diff_so_file = NULL;
static size_t img_size = 0;
static void Record(int t);
static void Init(int, char **);
static void Parse_args(int, char **);
static void Reset();
static void Release();
static void LoadImg(char*);

using namespace std;
int main(int argc, char** argv) {
  Init(argc, argv);

  cout << "[Simulation START]" << endl;
  Reset();
  for (int i = 0 ; i < 10; i ++) {
      top->clk = 0;
      top->eval();
      Record(time_main ++);

      top->clk = 1;
      top->eval();
      Record(time_main ++);
  }
  Release();
  cout << "[Simulation END] " << time_main << " time steps" << endl;
  return 0;
}

void Record(int t){
  #ifdef VM_TRACE
  if (fp)
  {
      fp->dump(t);
  }
  #endif
}

static void Init(int argc, char **argv) {
  Parse_args(argc, argv);
  
  if (img_file) LoadImg(img_file);
  else {
      cout << "[" << __FILE__ << ":" << __LINE__ << "] Lack of img_file" << endl;
      exit(0);
  }

  Verilated::commandArgs(argc, argv);
  top = new Vtop;
  if (!top) {
    cout << "Vtop miss" << endl;
    exit(1);
  }

  #ifdef VM_TRACE
  Verilated::traceEverOn(true);
  fp = new VerilatedVcdC;
  if (!fp) exit(1);
  top->trace(fp, 99);
  fp->open("waves.vcd");
  cout << "[TRACE ON] wave save in file : waves.vcd" << endl;
  #endif
}

static void Parse_args(int argc, char *argv[]) {
  const struct option table[] = {
    {"log"      , required_argument, NULL, 'l'},
    {"diff"     , required_argument, NULL, 'd'},
    {"help"     , no_argument      , NULL, 'h'},
    {0          , 0                , NULL,  0 },
  };
  int o;
  while ( (o = getopt_long(argc, argv, "-bhl:d:", table, NULL)) != -1) {
    switch (o) {
      case 'l': log_file = optarg; break;
      case 'd': diff_so_file = optarg; break;
      case 1:
        if (img_file != NULL) cout << "too much argument '" << optarg << "', ignored" << endl;
        else img_file = optarg;
        break;
      default:
        cout << "Usage: " << argv[0] << "[OPTION...] IMAGE" << endl;
        cout << "\t-l,--log=FILE           output log to FILE" << endl;
        cout << "\t-d,--diff=REF_SO        run DiffTest with reference REF_SO" << endl;
        exit(0);
    }
  }
}

static void Reset() {
  top->clk = 0;
  top->reset = 1;
  top->eval();
  top->clk = 1;
  top->reset = 1;
  top->eval();
  Record(time_main ++);
  top->clk = 0;
  top->eval();
  Record(time_main ++);
  top->reset = 0;
  top->clk = 1;
  top->eval();
  Record(time_main ++);
}

static void Release() {
  Record(time_main);

  #ifdef VM_TRACE
  if (fp)
  {
      fp->close();
      delete fp;
      fp = NULL;
  }
  #endif
  delete top;
  top = NULL;
}

static void LoadImg(char* file) {
  if (file == NULL) {
      cout << "[" << __FILE__ << ":" << __LINE__ <<"] LoadImg empty" << endl;
      exit(0);
  }

  FILE* fp = fopen(file, "r");
  if (!fp) {
      cout << "[" << __FILE__ << ":" << __LINE__ <<"] LoadImg fail" << endl;
      exit(0);
  }

  fseek(fp, 0, SEEK_END);
  img_size = ftell(fp);
  fseek(fp, 0, SEEK_SET);
  size_t ret = fread(my_pmem, img_size, 1, fp);
  fclose(fp);
  fp = NULL;
  if (!ret) {
    cout << "[LoadImg fail] fread error" << endl;
    exit(0);
  } else {
    cout << "[LoadImg succeed] Img: " << file << endl;
  }
}
