all: boot.exe boot
boot:
	fasm boot.asm
	boot.exe
boot.exe: boot.c
	g++ boot.c -o boot.exe
