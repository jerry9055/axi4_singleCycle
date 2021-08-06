
`include "common.v"

module ALU(
    input       [`REG_BUS]      in1,
    input       [`REG_BUS]      in2,
    input       [`ALUOP_BUS]    op,
    input       [`OP_WIDTH_BUS] op_width,

    output  reg [`REG_BUS]      out
);

    wire [`REG_BUS] op_add;
    wire [`REG_BUS] op_sub;
    wire [`REG_BUS] op_ul;
    reg  [`REG_BUS] op_srai;
    wire [`REG_BUS] op_and;
    reg  [`REG_BUS] op_sllw;
    wire [`REG_BUS] op_xor;
    wire [`REG_BUS] op_or;
    reg  [`REG_BUS] op_slli;
    reg  [`REG_BUS] op_srl;
    wire [`REG_BUS] op_geu;
    wire [`REG_BUS] op_ltu;
    wire [`REG_BUS] op_slt;
    reg  [`REG_BUS] op_sraw;
    reg  [`REG_BUS] op_srlw;
    wire [`REG_BUS] op_sll;
    reg  [`REG_BUS] op_sra;
    reg  [`REG_BUS] op_srliw;

    assign op_add = in1 + in2;
    assign op_sub = in1 - in2;
    assign op_ul  = { {63{1'b0}}, in1 < in2 };
    reg [5:0] shamt_srai;
    always @(*) begin
        shamt_srai = in2[5: 0];
        op_srai = in1 >> shamt_srai;
        for (integer i = 0; i < shamt_srai; i++) begin
          op_srai[63-i] = in1[63] | op_srai[63-i];
        end
    end
    assign op_and = in1 & in2;
    reg  [4: 0] sllw_r2;
    always@(*) begin
        sllw_r2 = in2[4: 0];
        op_sllw = in1 << sllw_r2;
    end
    assign op_xor = in1 ^ in2;
    assign op_or = in1 | in2;
    reg [5:0] shamt_sll;
    always @(*) begin
        shamt_sll = in2[5: 0];
        op_slli = in1 << shamt_sll;
    end
    assign op_srl = in1 >> in2[5:0];
    assign op_geu = { {63{1'b0}}, in1 >= in2 };
    assign op_ltu = { {63{1'b0}}, in1 < in2 };
    assign op_slt = { {63{1'b0}}, $signed(in1) < $signed(in2) };
    reg [31: 0] sraw_in1;
    always @(*) begin
        sraw_in1 = in1[31:0];
        sraw_in1 = sraw_in1 >> in2[4:0];
        for (integer k = 0; k < in2[4:0]; k++) begin
            sraw_in1[31 - k] = in1[31] | sraw_in1[31 - k];
        end
        op_sraw = { {32{in1[31]}}, sraw_in1 };
    end
    reg [31:0] srlw_in1;
    always @(*) begin
        srlw_in1 = in1[31:0];
        srlw_in1 = srlw_in1 >> in2[4:0];
        op_srlw = { {32{srlw_in1[31]}}, srlw_in1};
    end
    assign op_sll = in1 << in2[5:0];
    always @(*) begin
        op_sra = in1 >> in2[5:0];
        for (integer j = 0; j < in2[5:0]; j++) begin
            op_sra[63 - j] = in1[63] | op_sra[63 - j];
        end
    end
    reg [31:0] srliw_in1;
    always @(*) begin
        srliw_in1 = in1[31:0];
        srliw_in1 = srliw_in1 >> in2[5 :0];
        op_srliw = { {32{srliw_in1[31]}}, srliw_in1 };
    end

    wire [`REG_BUS] sext_add;
    sign_extend ins_sext_add(
        .in         (op_add),
        .op_width   (op_width),

        .out        (sext_add)
    );

    wire [`REG_BUS] sext_sllw;
    sign_extend ins_sext_sllw(
        .in         (op_sllw),
        .op_width   (op_width),

        .out        (sext_sllw)
    );

    wire [`REG_BUS] sext_slli;
    sign_extend ins_sext_slli(
        .in         (op_slli),
        .op_width   (op_width),

        .out        (sext_slli)
    );

    wire [`REG_BUS] sext_sub;
    sign_extend ins_sext_sub(
        .in         (op_sub),
        .op_width   (op_width),

        .out        (sext_sub)
    );

    always @(*) begin
        case(op) 
            `ALUOP_ADD:     out = sext_add;
            `ALUOP_SUB:     out = sext_sub;
            `ALUOP_UL:      out = op_ul;        
            `ALUOP_SRAI:    out = op_srai;
            `ALUOP_AND:     out = op_and;
            `ALUOP_SLLW:    out = sext_sllw;
            `ALUOP_XOR:     out = op_xor;
            `ALUOP_OR:      out = op_or;
            `ALUOP_SLLI:    out = sext_slli;
            `ALUOP_SRL:     out = op_srl;
            `ALUOP_GEU:     out = op_geu;
            `ALUOP_LTU:     out = op_ltu;
            `ALUOP_MV2:     out = in2;
            `ALUOP_SLT:     out = op_slt;
            `ALUOP_SRAW:    out = op_sraw;
            `ALUOP_SRLW:    out = op_srlw;
            `ALUOP_SRLIW:   out = op_srliw;
            `ALUOP_SLL:     out = op_sll;
            `ALUOP_SRA:     out = op_sra;
            default:        out = `ZERO_WORD;
        endcase
    end
    
endmodule
