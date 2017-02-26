#include "fastmd5.h"
#include <string.h>
#include <stdio.h>

int main(int argc, char ** argv)
{
  char * teststr = argv[1];
  md5state * new; 
  new = (md5state *) malloc(sizeof(md5state));
  if(new == NULL)
  {
    printf("Unable to initialize md5 state struct!\n");
    return -1;
  }
  int ok;
  ok = md5_init(new);
  if(!ok)
  {
    printf("md5_init failed for some reason\n");
    return -1;
  }
  uint64_t msglen = strlen(teststr);
  char buffer[64];
  memset(buffer, 0, 64);
  memcpy(buffer, teststr, msglen);
  char digest[16];
  buffer[msglen] = (uint8_t) 0x80;
  uint64_t msglen_bits = msglen << 3;
  memcpy(&buffer[56], &msglen_bits, 8);
  md5_block(new, buffer);
  memcpy(digest, new, 16);
  int i;
  for(i = 0; i < 16; i++)
  {
    printf("%02x", digest[i] & 0xFF);
  }
  printf("\n");
  return 0;
}

