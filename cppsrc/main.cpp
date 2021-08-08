#include "Emulator.h"
Emulator* emulator;

int main(int argc, char** argv) {
  emulator = new Emulator(argc, argv);
  emulator->Run();
  emulator->Stop();  
  return 0;
}


