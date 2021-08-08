
`include "common.v"

module simm_gen (
    input   [31: 7]             instr,
    input   [`INSTR_TYPE_BUS]   instr_type,

    output  reg [`REG_BUS]      simm
);

    always@(*) begin
      case(instr_type)
        `I_TYPE: simm = { { 52{instr[31]} }, instr[31:20] };      
        `S_TYPE: simm = { { 52{instr[31]} }, instr[31:25], instr[11:7] };
        `B_TYPE: simm = { { 51{instr[31]} }, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
        `U_TYPE: simm = { { 32{instr[31]} }, instr[31:12], 12'h000 };
        `J_TYPE: simm = { { 43{instr[31]} }, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0 };
        `R_TYPE: simm = `ZERO_WORD;
        default: simm = `ZERO_WORD;
      endcase
    end

endmodule
