// ��������� ������� �� ������� 100 ��
void sys_timer_init() {

    IoWrite8(0x43, 0x34);
    IoWrite8(0x40, 0x9B);
    IoWrite8(0x40, 0x2E);   
    
}

// ��������� ���������� �������
void timer_ticker() {
    
    // brk;
    
}