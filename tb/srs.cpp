#include "systemc.h"
#include "tlm.h"
using namespace tlm;
#include "uvmc.h"
using namespace uvmc;

#include "../model/trans.h"

#include "../model/adder.h"

int sc_main (int argc , char *argv[]) {

  refmod  refmod_i("refmod_i");

  uvmc_connect(refmod_i.in,"refmod_i.in");
  uvmc_connect(refmod_i.out,"refmod_i.out");

  sc_start();
  return 0;
}

