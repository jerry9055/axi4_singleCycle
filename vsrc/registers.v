
`include "common.v"

module registers(
    input                       clk,
    input   	            	rst,
    //read		
    input   	[`R1_BUS]   	r1_addr,
    input   	[`R2_BUS]   	r2_addr,
    //write	
    input   	                reg_write_ena,
    input   	[`REG_ADDR_BUS] write_addr,
    input   	[`REG_BUS]      write_data,

    output  reg	[`REG_BUS]      r1_data,
    output  reg [`REG_BUS]      r2_data,
    output  reg [`REG_BUS]      mcycle,
    output  reg [`REG_BUS]      gpr[`GPR_NUM - 1: 0]   //for diff_test
);

    integer i ;

    always @(*) begin
        if (!rst) begin
          r1_data = gpr[r1_addr];
          r2_data = gpr[r2_addr];
        end else begin
            r1_data = `ZERO_WORD;
            r2_data = `ZERO_WORD;
            for (i = 0; i < `GPR_NUM; i++)
                gpr[i] = `ZERO_WORD;
        end
    end
    
    always @(posedge clk) begin
        if (reg_write_ena && write_addr != `ZERO_REG_ADDR) gpr[write_addr] <= write_data;
        mcycle <= rst ? `ZERO_WORD : mcycle + 1;
    end

endmodule
