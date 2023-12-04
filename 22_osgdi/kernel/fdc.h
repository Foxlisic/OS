enum FloppyRegisters {

    STATUS_REGISTER_A                = 0x3F0, // read-only
    STATUS_REGISTER_B                = 0x3F1, // read-only
    DIGITAL_OUTPUT_REGISTER          = 0x3F2,
    TAPE_DRIVE_REGISTER              = 0x3F3,
    MAIN_STATUS_REGISTER             = 0x3F4, // read-only
    DATARATE_SELECT_REGISTER         = 0x3F4, // write-only
    DATA_FIFO                        = 0x3F5,
    DIGITAL_INPUT_REGISTER           = 0x3F7, // read-only
    CONFIGURATION_CONTROL_REGISTER   = 0x3F7  // write-only
};

enum FloppyStatus {

    FDC_STATUS_NONE     = 0x0,
    FDC_STATUS_SEEK     = 0x1,
    FDC_STATUS_RW       = 0x2,
    FDC_STATUS_SENSEI   = 0x3,
};

enum FloppyCommands {

    READ_TRACK =                 2,  // generates IRQ6
    SPECIFY =                    3,  // * set drive parameters
    SENSE_DRIVE_STATUS =         4,
    WRITE_DATA =                 5,  // * write to the disk
    READ_DATA =                  6,  // * read from the disk
    RECALIBRATE =                7,  // * seek to cylinder 0
    SENSE_INTERRUPT =            8,  // * ack IRQ6, get status of last command
    WRITE_DELETED_DATA =         9,
    READ_ID =                    10, // generates IRQ6
    READ_DELETED_DATA =          12,
    FORMAT_TRACK =               13, // *
    DUMPREG =                    14,
    SEEK =                       15, // * seek both heads to cylinder X
    VERSION =                    16, // * used during initialization, once
    SCAN_EQUAL =                 17,
    PERPENDICULAR_MODE =         18, // * used during initialization, once, maybe
    CONFIGURE =                  19, // * set controller parameters
    LOCK =                       20, // * protect controller params from a reset
    VERIFY =                     22,
    SCAN_LOW_OR_EQUAL =          25,
    SCAN_HIGH_OR_EQUAL =         29
};

// Информация о FDC
struct FDC_DEVICE {
    
    // Параметры
    byte    enabled;            // Устройство присутствует
    byte    motor;              // Мотор включен
    dword   timem;              // Время включения мотора
    
    // Запрошенные параметры CHS
    byte    r_cyl;
    byte    r_head;
    byte    r_sec;

    // Результат
    byte    st0;
    byte    st1;
    byte    st2;
    byte    cyl;
    byte    head_end;
    byte    head_start;
    byte    error;

    // Для IRQ
    byte    status;
    volatile byte irq_ready;
};

struct FDC_DEVICE fdc;
