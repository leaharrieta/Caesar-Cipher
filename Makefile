project_4: cFunctions.o main.o caesar.o
	gcc -m64 -nostartfiles cFunctions.o main.o caesar.o -o project_4

cFunctions.o: cFunctions.c
	gcc -m64 -Wall -c cFunctions.c -o cFunctions.o

main.o: main.asm
	nasm -f elf64 main.asm -o main.o

caesar.o: caesar.asm
	nasm -f elf64 caesar.asm

clean: 
	rm -f main.o caesar.o cFunctions.o l

gdb:
	gdb ./project_4

run: 
	./project_4

val:
	valgrind ./project_4
