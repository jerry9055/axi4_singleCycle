//num
`define ZERO_WORD       64'h0
`define PC_RESET        64'h8000_0000
`define DATA_WIDTH      64
`define ADDR_WIDTH      64
`define INSTR_WIDTH     32
`define ENA_1           1'b1
`define ENA_0           1'b0
`define AxBURST_FIXED   2'b00
`define ARPROT_INSTR    3'b001
`define ARPROT_DATA     3'b000
`define xRESP_OK        2'b00
`define TRUE            1'b1
`define TRUE_64         {{63{1'b0}}, `TRUE}
`define FALSE           1'b0
`define GPR_NUM         32
`define ZERO_REG_ADDR   5'b00000

// ALU_INx_TYPE
`define ALU_IN1_REG     1'd0
`define ALU_IN1_PC      1'd1
`define ALU_IN2_REG     2'd0
`define ALU_IN2_SIMM    2'd1
`define ALU_IN2_4       2'd2

//branch type
`define BRANCH_NULL     4'd0
`define BRANCH_JAL      4'd1
`define BRANCH_JALR     4'd2
`define BRANCH_BEQ      4'd3
`define BRANCH_BNE      4'd4
`define BRANCH_BGE      4'd5
`define BRANCH_BLT      4'd6
`define BRANCH_BGEU     4'd7
`define BRANCH_BLTU     4'd8

//op width
`define OP_WIDTH_1_MEM  3'd0
`define OP_WIDTH_2_MEM  3'd1
`define OP_WIDTH_4_MEM  3'd2
`define OP_WIDTH_8_MEM  3'd3
`define OP_WIDTH_1_REG  3'd4
`define OP_WIDTH_2_REG  3'd5
`define OP_WIDTH_4_REG  3'd6
`define OP_WIDTH_8_REG  3'd7

//bus
`define REG_BUS         63: 0
`define INSTR_BUS       31: 0
`define OP_CODE_BUS     6 : 0
`define RD_BUS          11: 7
`define FUN3_BUS        14:12
`define R1_BUS          19:15
`define R2_BUS          24:20
`define FUN7_BUS        31:25
`define REG_ADDR_BUS    4 : 0        
`define INSTR_TYPE_BUS  2 : 0
`define ALUOP_BUS       4 : 0
`define ALU_IN2_BUS     1 : 0
`define BRANCH_TYPE_BUS 3 : 0  
`define OP_WIDTH_BUS    2 : 0

//instr type
`define NULL_TYPE   3'd0
`define R_TYPE      3'd1
`define I_TYPE      3'd2
`define S_TYPE      3'd3
`define B_TYPE      3'd4
`define U_TYPE      3'd5
`define J_TYPE      3'd6

//ALUOP
`define ALUOP_NULL  5'd0
`define ALUOP_ADD   5'd1
`define ALUOP_SUB   5'd2
`define ALUOP_UL    5'd3
`define ALUOP_SRAI  5'd4
`define ALUOP_AND   5'd5
`define ALUOP_SLLW  5'd6
`define ALUOP_XOR   5'd7
`define ALUOP_OR    5'd8
`define ALUOP_SLLI  5'd9
`define ALUOP_SRL   5'd10
`define ALUOP_GEU   5'd11
`define ALUOP_LTU   5'd12
`define ALUOP_MV2   5'd13
`define ALUOP_SLT   5'd14
`define ALUOP_SRAW  5'd15
`define ALUOP_SRLIW 5'd16
`define ALUOP_SRLW  5'd17
`define ALUOP_SLL   5'd18
`define ALUOP_SRA   5'd19

//AxSIZE
`define AxSIZE_1B       3'b000
`define AxSIZE_2B       3'b001
`define AxSIZE_4B       3'b010
`define AxSIZE_8B       3'b011
