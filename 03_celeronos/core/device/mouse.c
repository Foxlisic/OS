void isr_ps2mouse();

int     mouse_x = 320;
int     mouse_y = 240;

// ������ ����
u8 mouse_icon[8] = { 
    0b10000000,
    0b11000000,
    0b11100000,
    0b11110000,
    0b11100000,
    0b10100000,
    0b00110000,
    0b00010000
};

// �������� "��������" ����
void mouse_hide(int mx, int my) {
    
    int i, j;
    int y = my;
    for (i = 0; i < 8; i++) {
        
        int x = mx;
        for (j = 0; j < 4; j++) {
            
            // ���� ���������
            if (x >= mouse_x && x < mouse_x + 4 && 
                y >= mouse_y && y < mouse_y + 8 && 
                (mouse_icon[y - mouse_y] & (0x80 >> (mouse_x - x)))
            ) {

                x++;
                continue;
            }
            
            IoWrite16(VGA_GC_INDEX, 0x0008 | (0x8000 >> (x & 7))); 
            flush_write(y*80 + (x >> 3), *((u8*)0x1A0000 + y*640 + x));
            x++;       
        }
        y++;
    }    
}

// ���������� ������
void mouse_show() {
    
    int i, j;
   
    int y = mouse_y;
    for (i = 0; i < 8; i++) {
        
        u8 mask = mouse_icon[i];
        int x = mouse_x;
        for (j = 0; j < 4; j++) {
            
            if ((mask & 0x80) && (x >= 0 && x < 640 && y >= 0 && y < 480)) {
                
                IoWrite16(VGA_GC_INDEX, 0x0008 | (0x8000 >> (x & 7))); 
                flush_write(y*80 + (x >> 3), 15);
                
            }
            
            x++;
            mask <<= 1;            
        }
        y++;
    }   
}

// �������� ������� ��� ������
void mouse_wait(u8 is_command_signal) {
    u32 timeout = 100000;
    
    if (is_command_signal) {
    
        // Command Signal
        while (timeout--) if ((IoRead8(0x64) & 2) == 0) return;

    } else {
    
        // Data
        while (timeout--) if ((IoRead8(0x64) & 1) == 1) return;
    }
}

// �������� ������ � ����
void mouse_write(u8 wrt) {
    // ������� ����, ��� �� ���� �������
    mouse_wait(1); IoWrite8(0x64, 0xD4); 
    
    // ��������� ������
    mouse_wait(1); IoWrite8(0x60, wrt);     
}

// ��������� ������ �� ����
u8 mouse_read() {
    mouse_wait(0); 
    return IoRead8(0x60);
}

// ������������� PS/2 ����
void mouse_install() {
    u8 status; 

    // �������� auxiliary mouse device
    mouse_wait(1); IoWrite8(0x64, 0xA8);

    // �������� ����������
    mouse_wait(1); IoWrite8(0x64, 0x20);
    mouse_wait(0); status = (IoRead8(0x60) | 2);    
    mouse_wait(1); IoWrite8(0x64, 0x60);    
    mouse_wait(1); IoWrite8(0x60, status);

    // ��������� ���� ��������� �� ���������
    mouse_write(0xF6); mouse_read();  // Acknowledge F6

    // ��������� ����
    mouse_write(0xF4); mouse_read();  // Acknowledge
}

// �������� ���������� ���� �� irq-12
void ps2_handler() {
    char mb[3];
    
    int old_x = mouse_x,
        old_y = mouse_y;

    // ������� �� ������ 3-� ����
    mouse_wait(1); IoWrite8(0x64, 0xAD);
 
    // ������
    mb[0] = mouse_read();
    mb[1] = mouse_read();
    mb[2] = mouse_read();
    
    // ��������
    mouse_x += (char)mb[1];
    mouse_y -= (char)mb[2];
    
    // �����������
    if (mouse_x < 0) mouse_x = 0;
    if (mouse_y < 0) mouse_y = 0;
    if (mouse_x > 639) mouse_x = 639;
    if (mouse_y > 479) mouse_y = 479;
    
    // �������� ������ ������������ ����
    mouse_hide(old_x, old_y);
    mouse_hide(mouse_x, mouse_y);

    // �������� ���� �� ����� �����
    mouse_show();   
}