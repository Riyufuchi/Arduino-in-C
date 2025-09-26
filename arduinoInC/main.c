#include "src/sos/sos.h"

int main(void)
{
  sos_init();
  while (1)
    sos_task();
  return 0;
}
