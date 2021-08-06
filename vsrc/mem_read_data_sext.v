module mem_read_data_sext (
    input wire [`REG_BUS] mem_read_data,
    input wire [`INSTR_BUS] instr,

    output wire [`REG_BUS] out
);

    reg  [`OP_WIDTH_BUS]    op_width_reg;
    wire [`REG_BUS]         sext_data;
    wire [`FUN3_BUS]        fun3;
    wire [`OP_CODE_BUS]     op_code;

    assign out = sext_data; 
    assign fun3 = instr[`FUN3_BUS];
    assign op_code = instr[`OP_CODE_BUS];

    always @(*) begin
        case({fun3, op_code})
            10'b000_0000011/*lb*/: op_width_reg = `OP_WIDTH_1_REG;
            10'b001_0000011/*lh*/: op_width_reg = `OP_WIDTH_2_REG;
            10'b010_0000011/*lw*/: op_width_reg = `OP_WIDTH_4_REG;
            10'b011_0000011/*ld*/: op_width_reg = `OP_WIDTH_8_REG;
            default: op_width_reg = `OP_WIDTH_8_REG;
        endcase
    end

    sign_extend ins_sext_add(
        .in         (mem_read_data),
        .op_width   (op_width_reg),

        .out        (sext_data)
    );

    wire __unused = 'b0 == instr;

endmodule
