module ip_core # 
(

)
(
    input wire clk,
    input wire reset,
    input wire [`INSTR_BUS] instr,
    input wire instr_valid,
    input wire [`REG_BUS] mem_read_data,
    input wire mem_visit_end,

    output reg [`REG_BUS] pc,
    output wire fetch_pulse,
    output wire unknown_op,
    output wire [`REG_BUS] gpr[`GPR_NUM - 1 : 0],
    output wire [`REG_BUS] mcycle,
    output wire mem_read,
    output wire mem_write,
    output wire [`REG_BUS] mem_visit_addr,
    output wire [`OP_WIDTH_BUS] op_width,
    output wire [`REG_BUS] mem_write_data
);

    wire [`REG_BUS] next_pc;
    reg next_pc_ena;
    reg last_reset;
    reg first_fetch_pulse;
    wire [`BRANCH_TYPE_BUS]  branch;
    wire mem2reg;
    wire reg_write;
    wire ALU_in1_type;
    wire [`ALU_IN2_BUS] ALU_in2_type;
    wire [`ALUOP_BUS] ALU_OP;
    wire [`INSTR_TYPE_BUS] instr_type;
    wire [`REG_BUS] reg_write_data;
    wire [`REG_BUS] r1_data;
    wire [`REG_BUS] r2_data;
    wire [`REG_BUS] ALU_out;
    wire [`REG_BUS] ALU_in1;
    wire [`REG_BUS] ALU_in2;
    wire [`REG_BUS] simm;
    reg [`REG_BUS] last_pc;
    wire [`REG_BUS] seq_pc;
    wire [`REG_BUS] jmp_pc;
    reg reg_write_ena;
    reg mem_read_ff;
    reg [`RD_BUS] rd_ff;
    wire stall;
    reg mem2reg_ff;
    reg [`INSTR_BUS] instr_ff;
    wire [`REG_BUS] sext_mem_read_data;

    assign next_pc_ena =  (instr_valid & stall == `FALSE) | mem_visit_end;
    assign mem_visit_addr = ALU_out;
    assign mem_write_data = r2_data;
    assign reg_write_ena = (reg_write & ~mem_read & ~mem_write) | (mem_read_ff & mem_visit_end);    

    // instr_ff
    always @(posedge clk) begin
      if (instr_valid) instr_ff <= instr;
      else instr_ff <= instr_ff;
    end

    // mem2reg_ff
    always @(posedge clk) begin
      if (reset == 1'b1 | fetch_pulse == 1'b1) mem2reg_ff <= `ENA_0;
      else if (mem2reg) mem2reg_ff <= `ENA_1;
      else mem2reg_ff <= mem2reg_ff;
    end

    // rd_ff
    always @(posedge clk) begin
      if (mem_read_ff) rd_ff <= rd_ff;
      else rd_ff <= instr[`RD_BUS];
    end

    // mem_read_ff
    always @(posedge clk) begin
      if (reset == 1'b1 | fetch_pulse == 1'b1) mem_read_ff <= `ENA_0;
      else if (mem_read) mem_read_ff <= `ENA_1;
      else mem_read_ff <= mem_read_ff;
    end

    //first_fetch_pulse , last_pc
    always @(posedge clk) begin
      last_pc <= pc;
      last_reset <= reset;
      first_fetch_pulse <= last_reset & ~reset;
    end

    //fetch_pulse
    always @(*) begin
      if (reset) fetch_pulse = `ENA_0;
      assign fetch_pulse = first_fetch_pulse | (~reset & (last_pc != pc) );
    end

    cpu_pc ins_cpu_pc (
      .clk (clk),
      .reset(reset),
      .next_pc(next_pc_ena ? next_pc : pc),

      .pc(pc)
    );

    seq_pc ins_seq_pc (
      .cur_pc(pc),

      .pc_add_4(seq_pc)
    );

    control ins_control(
      .instr_valid(instr_valid),
      .instr(instr),

      .branch(branch),
      .mem_read(mem_read),
      .mem2reg(mem2reg),
      .mem_write(mem_write),
      .reg_write(reg_write),
      .ALU_OP(ALU_OP),
      .ALU_in1_type(ALU_in1_type),
      .ALU_in2_type(ALU_in2_type),
      .unknown_op(unknown_op),
      .instr_type(instr_type),
      .stall(stall),
      .op_width(op_width)
    ) ;

    mem_read_data_sext ins_mem_read_data_sext(
      .mem_read_data(mem_read_data),
      .instr(instr_ff),

      .out(sext_mem_read_data)
    );

    reg_write_mux ins_reg_write_mux (
      .ALU_out(ALU_out),
      .mem_read_data(sext_mem_read_data),
      .mem2reg(mem2reg_ff),

      .reg_write_data(reg_write_data)
    );

    registers ins_registers (
      .clk(clk),
      .rst(reset),
      .r1_addr(instr[`R1_BUS]),
      .r2_addr(instr[`R2_BUS]),
      .reg_write_ena(reg_write_ena),
      .write_addr(rd_ff),
      .write_data(reg_write_data),

      .r1_data(r1_data),
      .r2_data(r2_data),
      .mcycle(mcycle),
      .gpr(gpr)
    );

    ALU_in1_mux ins_ALU_in1_mux(
      .reg_read1(r1_data),
      .pc(pc),
      .sel(ALU_in1_type),

      .ALU_in1(ALU_in1)
    );

    simm_gen ins_simm_gen(
      .instr(instr[31: 7]),
      .instr_type(instr_type),

      .simm(simm)
    );

    ALU_in2_mux ins_ALU_in2_mux(
      .reg_read2(r2_data),
      .simm(simm),
      .sel(ALU_in2_type),

      .ALU_in2(ALU_in2)
    );

    ALU ins_ALU (
      .in1(ALU_in1),
      .in2(ALU_in2),
  	  .op(ALU_OP),
      .op_width(op_width),

      .out(ALU_out)
    );

    jmp_pc_gen ins_jmp_pc_gen (
      .pc(pc),
      .simm(simm),
      .r1_data(r1_data),
      .branch(branch),
      .ALU_out(ALU_out),

      .jmp_pc(jmp_pc)
    );

    next_pc_mux ins_next_pc_mux (
      .seq_pc(seq_pc),
      .jmp_pc(jmp_pc),
      .branch(branch),

      .next_pc(next_pc)
    );

    // wire __unused;
    // assign __unused = 
      
     
endmodule
