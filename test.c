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
  md5_digest(new, buffer, digest, msglen);
  int i;
  for(i = 0; i < 16; i++)
  {
    printf("%02x", digest[i] & 0xFF);
  }
  printf("\n");
  return 0;
}

