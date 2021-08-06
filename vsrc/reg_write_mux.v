
`include "common.v"

module reg_write_mux(
    input   [`REG_BUS]  ALU_out,
    input   [`REG_BUS]  mem_read_data,
    input               mem2reg,

	output  [`REG_BUS]  reg_write_data      
);

    assign reg_write_data = mem2reg ?  mem_read_data : ALU_out;
    
endmodule
