module ip_core # 
(

)
(
    input wire clk,
    input wire reset,
    input wire [`INSTR_WIDTH - 1: 0] instr,
    input wire instr_valid,
    
    output reg [`ADDR_WIDTH - 1: 0] pc,
    output wire fetch_pulse
);

    parameter [1 : 0] CPU_FETCH = 2'b00,
                      CPU_DEC_EXEC = 2'b01;
                    //   CPU_READ = 2'b10,
                    //   CPU_WRITE = 2'b11;
    wire [`ADDR_WIDTH - 1: 0] next_pc;
    reg [1 :0] cpu_state;
    reg next_pc_ena;
    reg last_reset;
    reg first_fetch_pulse;
    reg last_instr_valid;

    cpu_pc ins_cpu_pc (
        .clk (clk),
        .reset(reset),
        .next_pc(next_pc),
        .next_pc_ena(next_pc_ena),

        .pc(pc)
    );

    seq_pc ins_seq_pc (
        .cur_pc(pc),

        .pc_add_4(next_pc)
    );


    // cpu_state
    always @ (posedge clk) begin
        if (reset == 1'b1) begin
            cpu_state <= CPU_FETCH;
        end else begin
            case (cpu_state) 
                CPU_FETCH: begin
                    last_instr_valid <= instr_valid;
                    if (last_instr_valid & ~instr_valid) cpu_state <= CPU_DEC_EXEC;
                    else cpu_state <= CPU_FETCH;
                end
                default:;
            endcase
        end
    end

    // next_pc_ena
    always @ (posedge clk) begin
        if (reset == 1'b1) begin
            next_pc_ena <= `ENA_0;
        end else begin
            
        end
    end

    //first_fetch_pulse
    always @(posedge clk) begin
        last_reset <= reset;
        first_fetch_pulse <= last_reset & ~reset;
    end

    //fetch_pulse
    always @(*) begin
        if (reset) fetch_pulse = `ENA_0;
        assign fetch_pulse = first_fetch_pulse;
    end

    wire __unused;
    assign __unused = ~instr == 'b0 & instr_valid;

endmodule
