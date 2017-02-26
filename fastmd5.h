#include <stdint.h>
#include <stdlib.h>
typedef struct /*__attribute__((__packed__))*/
{
  uint32_t a0;
  uint32_t b0;
  uint32_t c0;
  uint32_t d0;
  uint32_t F;
  uint32_t g;
  uint32_t dTemp;
} md5state;

int md5_init(md5state * st)
{
  st->a0     = 0x67452301;
  st->b0     = 0xefcdab89;
  st->c0     = 0x98badcfe; 
  st->d0     = 0x10325476;
  st->dTemp  = 0xFFFFFFFF;
  return 1;
}

int md5_block(md5state * st, char * buffer);

