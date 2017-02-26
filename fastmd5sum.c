#include "fastmd5.h"
#include <string.h>
#include <stdio.h>

int main(int argc, char ** argv)
{
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
  FILE *fp;
  fp = fopen(argv[1], "rb");
  if(fp == NULL)
  {
    printf("Unable to open %s!\n", argv[1]);
    return -1;
  }
  unsigned int msglen;
  unsigned int blocks;
  unsigned int blocks_processed = 0;
  unsigned int rem;
  int i;
  fseek(fp, 0L, SEEK_END);
  msglen = ftell(fp);
  rewind(fp);
  blocks = msglen / 64;
  rem = msglen % 64;
  char buffer[64];
  memset(buffer, 0, 64);
  char digest[16];
  int read;
  uint64_t msglen_bits = msglen << 3;
  memcpy(&buffer[56], &msglen_bits, 8);
  while(1)
  {
    read = fread(buffer, 64,1,fp);
    if(blocks_processed == blocks)
    {
      if(rem == 0)
      {
        //md5_block(new, buffer);
        memset(buffer, 0, 64);
        buffer[0] = (uint8_t) 0x80;
        memcpy(&buffer[56], &msglen_bits, 8);
        md5_block(new, buffer);
      }
      else if(rem < 56)
      {
        buffer[rem] = (uint8_t) 0x80;
        for(i = rem + 1; i < 64; i++)
        {
          buffer[i] = (uint8_t) 0;
          memcpy(&buffer[56], &msglen_bits, 8);
        }
        md5_block(new, buffer);
      }
      else
      {
        buffer[rem] = (uint8_t) 0x80;
        for(i = rem+1; i < 64; i++)
        {
          buffer[i] = (uint8_t) 0;
          memcpy(&buffer[56], &msglen_bits, 8);
        }
        md5_block(new, buffer);
        memset(buffer, 0, 64);
        memcpy(&buffer[56], &msglen_bits, 8);
        md5_block(new, buffer);
      }
      break;
    }
    else
    {
      md5_block(new, buffer);
    }
    blocks_processed++;
  }
  memcpy(digest, new, 16);
  for(i = 0; i < 16; i++)
  {
    printf("%02x", digest[i] & 0xFF);
  }
  printf("\n");
  return 0;
}

