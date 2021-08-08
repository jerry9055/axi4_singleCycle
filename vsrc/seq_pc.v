module seq_pc(
    input   [`DATA_WIDTH - 1 : 0]  cur_pc,
    
    output  [`DATA_WIDTH - 1 : 0]  pc_add_4
);

    assign pc_add_4 = cur_pc + 4;

endmodule
