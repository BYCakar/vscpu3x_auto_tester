// Control space
`define CMD_REG                     16'b0000_0000_0000_0000
`define STATUS_REG                  16'b0000_0000_0000_0001
`define ERROR_REG                   16'b0000_0000_0000_0010
`define TEST_NUM_REG                16'b0000_0000_0000_0011
`define UART_TX_PROD_REG            16'b0000_0000_0000_0100
`define UART_TX_CONS_REG            16'b0000_0000_0000_0101
`define UART_RX_PROD_REG            16'b0000_0000_0000_0110
`define UART_RX_CONS_REG            16'b0000_0000_0000_0111
`define GPIO_PATTERN_REG            16'b0000_0000_0000_1000
`define PROG_CM_PROGLEN_REG         16'b0000_0000_0000_1001
`define PROG_CT_PROGLEN_REG         16'b0000_0000_0000_1010
`define PROG_A0_PROGLEN_REG         16'b0000_0000_0000_1011
`define MEMRW_DATALO_REG            16'b0000_0000_0000_1100
`define MEMRW_DATAHI_REG            16'b0000_0000_0000_1101
`define MEMRW_ADDR_REG              16'b0000_0000_0000_1110
`define SOFT_RESET_REG              16'b0000_0000_0000_1111

// UART space
`define UART_TX_BUFFER              16'b0000_0001_0???_????
`define UART_RX_BUFFER              16'b0000_0001_1???_????

// GPIO space
`define GPIO_INPUT_BUFFER           16'b0000_0010_0???_????
`define GPIO_OUTPUT_CHK_BUFFER      16'b0000_0010_1???_????
`define GPIO_OUTPUT_ACT_BUFFER      16'b0000_0011_0???_????
    
// PROGMEM space
`define PROGMEM_CM                  16'b0100_????_????_????
`define PROGMEM_CT                  16'b0101_????_????_????, 16'b0110_00??_????_????
`define PROGMEM_A0                  16'b0111_00??_????_????, 16'b0111_01??_????_????, 16'b0111_10??_????_????
`define PROGMEM_SHD                 16'b0111_1100_0???_????
`define PROGMEM_SHD_MASK            16'b0111_1111_1000_00??
    
// CHKMEM space
`define CHKMEM_CM                   16'b1000_????_????_????
`define CHKMEM_CT                   16'b1001_????_????_????, 16'b1010_00??_????_????
`define CHKMEM_A0                   16'b1011_00??_????_????, 16'b1011_01??_????_????, 16'b1011_10??_????_????
`define CHKMEM_SHD                  16'b1011_1100_0???_????
`define CHKMEM_CM_MASK              16'b1011_1110_0???_????
`define CHKMEM_CT_MASK              16'b1011_1110_1???_????, 16'b1011_1111_000?_????
`define CHKMEM_A0_MASK              16'b1011_1111_001?_????, 16'b1011_1111_010?_????, 16'b1011_1111_011?_????
`define CHKMEM_SHD_MASK             16'b1011_1111_1000_00??

// ACTMEM space
`define ACTMEM_CM                   16'b1100_????_????_????
`define ACTMEM_CT                   16'b1101_????_????_????, 16'b1110_00??_????_????
`define ACTMEM_A0                   16'b1111_00??_????_????, 16'b1111_01??_????_????, 16'b1111_10??_????_????
`define ACTMEM_SHD                  16'b1111_1100_0???_????

`define CHKMEM_CM_MISMATCH_REG      16'b1111_1111_1111_1100
`define CHKMEM_CT_MISMATCH_REG      16'b1111_1111_1111_1101
`define CHKMEM_A0_MISMATCH_REG      16'b1111_1111_1111_1110
`define CHKMEM_SHD_MISMATCH_REG     16'b1111_1111_1111_1111

// Bit position definitions
// CMD_REG BP defs
`define SET_PINMUX_BP 15
`define FETCH_ACTMEM_BP 4
`define FETCH_PROGMEM_BP 3
`define FORCE_STOP_BP 2
`define TEST_LOAD_RUN_BP 1
`define TEST_FAST_RUN_BP 0
// STATUS_REG BP defs
`define ERROR_FLAG_BP 15
`define MEMRW_DONE_BP 11
`define UART_RX_NEWDATA_BP 10
`define UART_TX_NEWDATA_BP 9
`define A0_RUNNING_BP 8
`define CT_RUNNING_BP 7
`define CM_RUNNING_BP 6
`define TEST_DONE_BP 5
`define TEST_RUNNING_BP 4
`define PROGMEM_LOADING_BP 3
`define ACTMEM_FETCHING_BP 2
`define PROGMEM_FETCHING_BP 1
`define PROGMODE_BP 0
// ERROR_REG BP defs
`define MEMRW_ERROR_BP 8
`define UART_RX_OVERFLOW_BP 7
`define UART_TX_OVERFLOW_BP 6
`define PROGRAM_ERROR_BP 5
`define GPIO_MISMATCH_BP 4
`define SHD_CHK_MISMATCH_BP 3
`define A0_CHK_MISMATCH_BP 2
`define CT_CHK_MISMATCH_BP 1
`define CM_CHK_MISMATCH_BP 0
// TEST_NUM_REG BP defs 
`define TESTNUM_MSB_BP 3
`define TESTNUM_LSB_BP 0
`define TESTNUM_BW (`TESTNUM_MSB_BP-`TESTNUM_LSB_BP+1) 
// UART_TX_PROD_REG BP defs 
`define UART_TX_PROD_MSB_BP 7
`define UART_TX_PROD_LSB_BP 0
`define UART_TX_PROD_BW (`UART_TX_PROD_MSB_BP-`UART_TX_PROD_LSB_BP+1) 
// UART_TX_CONS_REG BP defs 
`define UART_TX_CONS_MSB_BP 7
`define UART_TX_CONS_LSB_BP 0
`define UART_TX_CONS_BW (`UART_TX_CONS_MSB_BP-`UART_TX_CONS_LSB_BP+1) 
// UART_RX_PROD_REG BP defs 
`define UART_RX_PROD_MSB_BP 7
`define UART_RX_PROD_LSB_BP 0
`define UART_RX_PROD_BW (`UART_RX_PROD_MSB_BP-`UART_RX_PROD_LSB_BP+1) 
// UART_RX_CONS_REG BP defs 
`define UART_RX_CONS_MSB_BP 7
`define UART_RX_CONS_LSB_BP 0
`define UART_RX_CONS_BW (`UART_RX_CONS_MSB_BP-`UART_RX_CONS_LSB_BP+1) 
// GPIO_PATTERN_REG BP defs 
`define GPIO_MISMATCH_COUNT_MSB_BP 14
`define GPIO_MISMATCH_COUNT_LSB_BP 8 
`define GPIO_MISMATCH_COUNT_BW (`GPIO_MISMATCH_COUNT_MSB_BP-`GPIO_MISMATCH_COUNT_LSB_BP+1)
`define GPIO_PATTERN_LEN_MSB_BP 6
`define GPIO_PATTERN_LEN_LSB_BP 0
`define GPIO_PATTERN_LEN_BW (`GPIO_PATTERN_LEN_MSB_BP-`GPIO_PATTERN_LEN_LSB_BP+1)
// PROG_CM_PROGLEN_REG BP defs 
`define CM_PROGLEN_MSB_BP 10
`define CM_PROGLEN_LSB_BP 0 
`define CM_PROGLEN_BW (`CM_PROGLEN_MSB_BP-`CM_PROGLEN_LSB_BP+1)
// PROG_CT_PROGLEN_REG BP defs 
`define CT_PROGLEN_MSB_BP 11
`define CT_PROGLEN_LSB_BP 0 
`define CT_PROGLEN_BW (`CT_PROGLEN_MSB_BP-`CT_PROGLEN_LSB_BP+1)
// PROG_A0_PROGLEN_REG BP defs 
`define A0_PROGLEN_MSB_BP 10
`define A0_PROGLEN_LSB_BP 0 
`define A0_PROGLEN_BW (`A0_PROGLEN_MSB_BP-`A0_PROGLEN_LSB_BP+1)
// MEMRW_ADDR_REG BP defs:
`define MEMRW_VALID_BP 14 
`define MEMRW_WEN_BP 14 
`define MEMRW_SEL_MSB_BP 13
`define MEMRW_SEL_LSB_BP 12
`define MEMRW_SEL_BW (`MEMRW_SEL_MSB_BP-`MEMRW_SEL_LSB_BP+1)
`define MEMRW_ADDR_MSB_BP 11
`define MEMRW_ADDR_LSB_BP 0
`define MEMRW_ADDR_BW (`MEMRW_ADDR_MSB_BP-`MEMRW_ADDR_LSB_BP+1)
// SOFT_RESET_REG BP defs
`define SOFT_RESET_BP 0

// Memory select definitions
`define PROGSEL_IDLE 2'h0
`define PROGSEL_CM 2'h1
`define PROGSEL_CT 2'h2
`define PROGSEL_A0 2'h3
// Memory select mask. PLEASE UPDATE THIS FIELD IF YOU CHANGE PROGMEM OR CHECKMEM ADDRESS MAPPING
`define MEMSEL_CM 12'b0???_????_????
`define MEMSEL_CT 12'b0???_????_????, 12'b100?_????_????
`define MEMSEL_A0 12'b000?_????_????, 12'b001?_????_????, 12'b010?_????_????
`define MEMSEL_SHD 12'b1110_00??_???? 
`define MEMSEL_CM_MASK 12'b1111_00??_????
`define MEMSEL_CT_MASK 12'b1111_01??_????, 12'b1111_1000_????
`define MEMSEL_A0_MASK 12'b1111_1001_????, 12'b1111_1010_????, 12'b1111_1011_????
`define MEMSEL_SHD_MASK 12'b1111_1100_000?

`define MEMSEL_CM_START 12'h000
`define MEMSEL_CM_END 12'h7ff
`define MEMSEL_CT_START 12'h000
`define MEMSEL_CT_END 12'h9ff
`define MEMSEL_A0_START 12'h000
`define MEMSEL_A0_END 12'h5ff
`define MEMSEL_SHD_START 12'he00
`define MEMSEL_SHD_END 12'he3f
`define MEMSEL_CM_MASK_START 12'hf00
`define MEMSEL_CM_MASK_END 12'hf3f
`define MEMSEL_CT_MASK_START 12'hf40
`define MEMSEL_CT_MASK_END 12'he8f
`define MEMSEL_A0_MASK_START 12'hf90
`define MEMSEL_A0_MASK_END 12'hebf
`define MEMSEL_SHD_MASK_START 12'hfc0
`define MEMSEL_SHD_MASK_END 12'hfc1