
`include "common.v"

module sign_extend(
    input       [`REG_BUS]      in,
    input       [`OP_WIDTH_BUS] op_width,

    output  reg [`REG_BUS]      out
);

    wire [`REG_BUS] width_1;
    wire [`REG_BUS] width_2;
    wire [`REG_BUS] width_4;
    
    assign width_1 = in & 64'hff;
    assign width_2 = in & 64'hffff;
    assign width_4 = in & 64'hffffffff;
    
    always@ (*) begin
        case (op_width)
            `OP_WIDTH_1_REG:    out = { {56{width_1[ 7]}}, width_1[7 : 0] };
            `OP_WIDTH_2_REG:    out = { {48{width_2[15]}}, width_2[15: 0] };
            `OP_WIDTH_4_REG:    out = { {32{width_4[31]}}, width_4[31: 0] };
            `OP_WIDTH_8_REG:    out = in;
            default:            out = in;
        endcase
    end

    reg [`REG_BUS] __unused_ = width_1 & width_2 & width_4;

endmodule
