extern "C"
{
  #include "src/sos/sos.h"
}

void setup()
{
  sos_init();
}

void loop()
{
  sos_task();
}
