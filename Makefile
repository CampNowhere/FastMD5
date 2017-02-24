all:
	nasm -felf64 fastmd5.asm -o fastmd5.o
	gcc test.c fastmd5.o -o test 
	
debug:
	nasm -felf64 -g fastmd5.asm -o fastmd5.o
	gcc -ggdb test.c fastmd5.o -o test 
