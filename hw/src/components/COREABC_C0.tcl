# Exporting Component Description of COREABC_C0 to TCL
# Family: PolarFire
# Part Number: MPF200T-1FCG784E
# Create and Configure the core component COREABC_C0
create_and_configure_core -core_vlnv Actel:DirectCore:COREABC:$COREABCver -component_name {COREABC_C0} -params {\
"ABCCODE:    IOWRT 0x0
    APBWRT DAT 0 0x28C 0x1C000
    APBWRT DAT 0 0x290 0x10C 
    APBWRT DAT 0 0x2C0 0x8
    APBWRT DAT 0 0x2CC 0x1C000

    APBREAD 0 0x28C
    APBREAD 0 0x290
    APBREAD 0 0x2C0
    APBREAD 0 0x2CC
    IOWRT 0x1

    HALT  "  \
"ACT_CALIBRATIONDATA:true"  \
"APB_AWIDTH:10"  \
"APB_DWIDTH:32"  \
"APB_SDEPTH:2"  \
"APB_TIMEOUT_COUNT:80"  \
"CODEHEXDUMP:"  \
"CODEHEXDUMP2:"  \
"DEBUG:true"  \
"EN_ACM:false"  \
"EN_ADD:true"  \
"EN_ALURAM:false"  \
"EN_AND:true"  \
"EN_CALL:true"  \
"EN_DATAM:2"  \
"EN_INC:true"  \
"EN_INDIRECT:false"  \
"EN_INT:0"  \
"EN_IOREAD:true"  \
"EN_IOWRT:true"  \
"EN_MULT:0"  \
"EN_OR:true"  \
"EN_PUSH:true"  \
"EN_RAM:true"  \
"EN_RAM_ECC:false"  \
"EN_SHL:true"  \
"EN_SHR:true"  \
"EN_XOR:true"  \
"HI_REL:false"  \
"ICWIDTH:5"  \
"IFWIDTH:0"  \
"IIWIDTH:1"  \
"IMEM_APB_ACCESS:0"  \
"INITDATAWIDTH:32"  \
"INITWIDTH:11"  \
"INSMODE:0"  \
"INVALID_STACK_ACC:true"  \
"IOWIDTH:1"  \
"ISRADDR:1"  \
"MAX_NVMDWIDTH:32"  \
"STWIDTH:4"  \
"TESTMODE:0"  \
"UNIQ_STRING:COREABC_C0_COREABC_C0_0"  \
"UNIQ_STRING_LENGTH:23"  \
"VERILOGCODE:"  \
"VERILOGVARS:"  \
"ZRWIDTH:0"   }
# Exporting Component Description of COREABC_C0 to TCL done
