#include "memory.h"

unsigned long sgdt() {
    
    unsigned long sgdt;
    
    // ������ � long ������ �� GDT
    __asm__ __volatile__("sgdt %0" : "=m" (sgdt) : : "memory"); 

    // ��������� ������ GDT
    return sgdt >> 16;   
}

// ������� ����� ������� GDT � ��������� ��
void memory_create_new_gdt() {

    u32 i;
    u32* gdt = (u32*)GDT_LOCATION;    
    
    // ������� GDT
    for (i = 0; i <= 65534; i += 2) {
        
        gdt[i  ] = 0x00000000; 
        gdt[i+1] = 0x00000000;
    }
   
    // ������� �������� ���������    
    gdt[2] = 0x0000FFFF; gdt[3] = 0x00CF9800; // 0008 CODE 4Gb 0-Ring
    gdt[4] = 0x0000FFFF; gdt[5] = 0x00CF9200; // 0010 DATA 4Gb 0-Ring
    gdt[6] = 0x08000067; gdt[7] = 0x00408B00; // 0018 TSS � 0x0800 (Busy) https://pdos.csail.mit.edu/6.828/2011/readings/i386/fig7-2.gif
	
	// ������ IOBP Offset $800 + $64 (��. ./core.asm)
	*((u16*)0x00000864) = 104;

    *(u16*)GDT_REFTMP       = 0xffff;       // ����� ����� ����� ��� GDT
    *(u32*)(GDT_REFTMP + 2) = GDT_LOCATION; // ����� �����
    
    // ��������� ����� ������� GDT
    __asm__ __volatile__("lgdt (%0)" :: "d"(GDT_REFTMP));
}

// �������� ������� PDBR, ������������� �������
void enable_paging() {
        
    u32 i;
    u32 cr0;
    
    // ������� PDBR
    for (i = 0; i < 4096; i++) {
        *((u32*)PDBR + i) = 0;
    }
    
    // U/S=1, Present=1. ������������� ���������.
    for (i = 0; i < MEMORY_CAPACITY; i++) {
        *((u32*)PDBR + i) = (CATALOG_4MB + i*4096) | 0x3;
    }    

    // �������� ������� 1 � 1 (������ ������ 4 ���������)
    for (i = 0; i < 1024 * MEMORY_CAPACITY; i++) {
        *((u32*)CATALOG_4MB + i) = (i * 4096) | 0x03;        
    }

    // �������� ������ CR3 � ��������� ����� CR0 ���������
    asm volatile ("mov %0, %%cr3" : : "r"(PDBR));
    asm volatile ("mov %%cr0, %0" : "=r"(cr0));
    asm volatile ("mov %0, %%cr0" : : "r"(cr0 | 0x80000000) );
    asm volatile ("jmp 1f" "\n" "1:");    
}
