module cpu_pc(
    input wire clk,
    input wire reset,
    input wire [`DATA_WIDTH - 1 : 0] next_pc,

    output reg [`DATA_WIDTH - 1 : 0]  pc
);

    always @(posedge clk) begin
        if (reset == 1'b1) pc <= `PC_RESET;
        else pc <= next_pc;
    end

endmodule
