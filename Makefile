all:
	nasm -felf64 fastmd5.asm -o fastmd5.o
	gcc fastmd5sum.c fastmd5.o -o fastmd5sum
	gcc test.c fastmd5.o -o test 
	
debug:
	nasm -felf64 -g fastmd5.asm -o fastmd5.o
	gcc -ggdb fastmd5sum.c fastmd5.o -o fastmd5sum
	gcc -ggdb test.c fastmd5.o -o test 
