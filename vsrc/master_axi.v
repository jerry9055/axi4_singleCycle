module master_axi #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line

    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    // parameter integer C_M_AXI_BURST_LEN	= 16,   //maximum number of FIXED mode
    // Thread ID Width
    parameter integer C_M_AXI_ID_WIDTH	= 1,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH	= 32,
    // Width of Data Bus
    parameter longint C_M_AXI_DATA_WIDTH	= 32
    // Width of User Write Address Bus
    // parameter integer C_M_AXI_AWUSER_WIDTH	= 0, 
    // Width of User Read Address Bus
    // parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
    // Width of User Write Data Bus
    // parameter integer C_M_AXI_WUSER_WIDTH	= 0,
    // Width of User Response Bus
    // parameter integer C_M_AXI_BUSER_WIDTH	= 0
)
(
    // Users to add ports here
    output wire unknown_op,
    output wire [`REG_BUS] gpr [`GPR_NUM - 1 : 0],
    output wire [`REG_BUS] mcycle,
    output wire [`REG_BUS] pc,
    output wire fetch_pulse,
    // User ports ends
    // Do not modify the ports beyond this line

    // Global Clock Signal.
    input wire  M_AXI_ACLK,
    // Global Reset Singal. This Signal is Active Low
    input wire  M_AXI_ARESETn,


    // Write Address Channel ----->
    // Master Interface Write Address ID
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
    // Master Interface Write Address
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    output wire [7 : 0] M_AXI_AWLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    output wire [2 : 0] M_AXI_AWSIZE,
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    output wire [1 : 0] M_AXI_AWBURST,
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    output wire [3 : 0] M_AXI_AWCACHE,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    output wire [2 : 0] M_AXI_AWPROT,
    // Quality of Service, QoS identifier sent for each write transaction.
    output wire [3 : 0] M_AXI_AWQOS,
    // Region identifier. Permits a single physical interface on a slave to be used for 
    // multiple logical interfaces.
    output wire [3 : 0] M_AXI_AWREGION,
    // Optional User-defined signal in the write address channel.
    // Generally, this specification recommends that the User signals are not used,
    // !!!!!!! output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER, // !!!!!!!
    // Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
    output wire  M_AXI_AWVALID,
    // Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
    input wire  M_AXI_AWREADY,
    // <----- Write Address Channel


    // Write Data Channel ----->
    // Master Interface Write Data.
    output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
    // Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
    output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
    // Write last. This signal indicates the last transfer in a write burst.
    output wire  M_AXI_WLAST,
    // Optional User-defined signal in the write data channel.
    // Generally, this specification recommends that the User signals are not used,
    //!!!!! output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER, //!!!!!!!
    // Write valid. This signal indicates that valid write
    // data and strobes are available
    output wire  M_AXI_WVALID,
    // Write ready. This signal indicates that the slave
    // can accept the write data.
    input wire  M_AXI_WREADY,
    // <----- Write Data Channel 


    // Write response channel ----->
    // Master Interface Write Response.
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
    // Write response. This signal indicates the status of the write transaction.
    input wire [1 : 0] M_AXI_BRESP,
    // Optional User-defined signal in the write response channel
    // Generally, this specification recommends that the User signals are not used,
    //!!!! input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER, //!!!!
    // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
    input wire  M_AXI_BVALID,
    // Response ready. This signal indicates that the master
    // can accept a write response.
    output wire  M_AXI_BREADY,
    // <----- Write response channel


    // Read address channel ----->
    // Master Interface Read Address.
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
    // Read address. This signal indicates the initial
    // address of a read burst transaction.
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    output wire [7 : 0] M_AXI_ARLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    output wire [2 : 0] M_AXI_ARSIZE,
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    output wire [1 : 0] M_AXI_ARBURST,
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    output wire [3 : 0] M_AXI_ARCACHE,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    output wire [2 : 0] M_AXI_ARPROT,
    // Quality of Service, QoS identifier sent for each read transaction
    output wire [3 : 0] M_AXI_ARQOS,
    // Region identifier. Permits a single physical interface on a slave to be used for multiple 
    // logical interfaces.
    output wire [3 : 0] M_AXI_ARREGION,
    // Optional User-defined signal in the read address channel.
    // Generally, this specification recommends that the User signals are not used.
    //!!!!!!!!! output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,  ///!!!!!!!!
    // Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
    output wire  M_AXI_ARVALID,
    // Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
    input wire  M_AXI_ARREADY,
    // <----- Read address channel 


    // Read data channel -----> 
    // Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
    // Master Read Data
    input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
    // Read response. This signal indicates the status of the read transfer
    input wire [1 : 0] M_AXI_RRESP,
    // Read last. This signal indicates the last transfer in a read burst
    input wire  M_AXI_RLAST,
    // Optional User-defined signal in the read address channel.
    // Generally, this specification recommends that the User signals are not used.
    //!!!! input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,  //!!!!!!!
    // Read valid. This signal indicates that the channel
    // is signaling the required read data.
    input wire  M_AXI_RVALID,
    // Read ready. This signal indicates that the master can
    // accept the read data and response information.
    output wire  M_AXI_RREADY
    // <----- Read data channel 
);

    parameter [1 : 0] MASTER_IDLE = 2'd0,
                      MASTER_FETCH = 2'd1,
                      MASTER_MEM = 2'd2;
    wire reset;
    reg [`INSTR_WIDTH - 1 : 0] instr;
    reg [`ADDR_WIDTH - 1: 0] axi_araddr;
    reg [7 : 0] axi_burst_size;
    reg [2 : 0] axi_arsize;
    reg [2 : 0] axi_arprot;
    reg axi_arvalid;
    reg [1 : 0] master_state;
    reg axi_rready;
    reg last_rlast;
    reg instr_valid;
    wire [`REG_BUS] mem_read_data;
    wire mem_read;
    wire mem_write;
    wire [`REG_BUS] mem_visit_addr;
    wire [`OP_WIDTH_BUS] op_width;
    reg [`ADDR_WIDTH - 1: 0] axi_awaddr;
    reg [2 : 0] axi_awsize;
    reg axi_awvalid;
    wire [`REG_BUS] mem_write_data;
    reg [`REG_BUS] axi_wdata;
    reg [C_M_AXI_DATA_WIDTH/8-1 : 0] axi_wstrb;
    reg axi_wvalid;
    reg axi_bready;
    reg mem_visit_end;

    // I/O Connections assignments
    assign reset = ~M_AXI_ARESETn;
    // Address Read (AR)
    assign M_AXI_ARID = 'b0;
    assign M_AXI_ARADDR	= axi_araddr;
	assign M_AXI_ARLEN	= axi_burst_size - 1;   //Burst LENgth is number of transaction beats, minus 1
    assign M_AXI_ARSIZE = axi_arsize;
	assign M_AXI_ARBURST = `AxBURST_FIXED;
    assign M_AXI_ARCACHE = 4'b0010; //Normal Non-cacheable Non-bufferable
    assign M_AXI_ARPROT = axi_arprot;
    assign M_AXI_ARQOS = 4'h0;
    assign M_AXI_ARREGION = 'b0;
    assign M_AXI_ARVALID = axi_arvalid;
    // Read Data (R)
    assign M_AXI_RREADY = axi_rready;
    // Address Write (AW)
    assign M_AXI_AWID = 'b0;
    assign M_AXI_AWADDR = axi_awaddr;
    assign M_AXI_AWLEN = axi_burst_size - 1; //Burst LENgth is number of transaction beats, minus 1. And here May Change later
    assign M_AXI_AWSIZE = axi_awsize;
    assign M_AXI_AWBURST = `AxBURST_FIXED;
    assign M_AXI_AWCACHE = 4'b0010; //Normal Non-cacheable Non-bufferable
    assign M_AXI_AWPROT = `ARPROT_DATA;
    assign M_AXI_AWQOS = 4'h0;
    assign M_AXI_AWREGION = 'b0;
    assign M_AXI_AWVALID = axi_awvalid;
    // Write data (W)
    assign M_AXI_WDATA = axi_wdata;
    assign M_AXI_WSTRB = axi_wstrb;
    assign M_AXI_WLAST = M_AXI_WREADY & M_AXI_WVALID;
    assign M_AXI_WVALID = axi_wvalid;
    // Write response (B)
    assign M_AXI_BREADY = axi_bready;

    // user
    assign mem_read_data = (master_state == MASTER_MEM & mem_visit_end) ? M_AXI_RDATA : `ZERO_WORD;
    assign mem_visit_end = (M_AXI_BVALID & M_AXI_BREADY) | (master_state == MASTER_MEM & M_AXI_RVALID & M_AXI_RREADY);
    assign instr_valid = M_AXI_RVALID & M_AXI_RREADY & master_state == MASTER_FETCH & M_AXI_RRESP == `xRESP_OK;    
    assign instr = M_AXI_RDATA[`INSTR_WIDTH - 1 : 0];

    // axi_bready
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_bready <= `FALSE;
        else begin
            if (~axi_bready & M_AXI_BVALID) axi_bready <= `TRUE;
            else axi_bready <= `FALSE;
        end
    end

    // axi_wvalid
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_wvalid <= `FALSE;
        else begin
            if (M_AXI_AWVALID & M_AXI_AWREADY) axi_wvalid <= `TRUE;
            else if (M_AXI_WREADY & axi_wvalid) axi_wvalid <= `FALSE;
            else axi_wvalid <= axi_wvalid;
        end
    end

    // axi_wstrb
    always @(*) begin
        axi_wstrb = {axi_awaddr % (C_M_AXI_DATA_WIDTH / 8)}[7:0];
        case (M_AXI_AWSIZE)
            `AxSIZE_1B: axi_wstrb = 8'b1        << axi_wstrb;
            `AxSIZE_2B: axi_wstrb = 8'b11       << axi_wstrb;
            `AxSIZE_4B: axi_wstrb = 8'b1111     << axi_wstrb;
            `AxSIZE_8B: axi_wstrb = 8'b11111111 << axi_wstrb;
            default:;
        endcase
    end 

    // axi_wdata
    always @(posedge M_AXI_ACLK) begin
        if (mem_write) axi_wdata <= mem_write_data;
        else axi_wdata <= axi_wdata;
    end

    // axi_awvalid
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0)
            axi_awvalid <= `FALSE;
        else if (~axi_awvalid & mem_write) 
            axi_awvalid <= `TRUE;
        else if (M_AXI_AWREADY & axi_awvalid)
            axi_awvalid <= `FALSE;
        else 
            axi_awvalid <= axi_awvalid;
    end

    // axi_awsize
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_awsize <= 'b0;
        else begin
            if (mem_write) begin
                case (op_width) 
                    `OP_WIDTH_1_MEM: axi_awsize <= `AxSIZE_1B;
                    `OP_WIDTH_2_MEM: axi_awsize <= `AxSIZE_2B;
                    `OP_WIDTH_4_MEM: axi_awsize <= `AxSIZE_4B;
                    `OP_WIDTH_8_MEM: axi_awsize <= `AxSIZE_8B;
                    default:;
                endcase
            end else axi_awsize <= axi_awsize;
        end
    end

    // axi_awaddr
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_awaddr <= 'b0;
        if (mem_write) axi_awaddr <= mem_visit_addr;
        else axi_awaddr <= axi_awaddr;
    end

    // axi_araddr
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_araddr <= 'b0; 
        else begin
            if (fetch_pulse) axi_araddr <= pc;
            else if (mem_read) axi_araddr <= mem_visit_addr;
            else axi_araddr <= axi_araddr;
        end 
    end

    // axi_burst_size
    assign axi_burst_size = 1;  //now burst size should be 1,may change later

    // axi_arsize
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_arsize <= 'b0; 
        else begin
            if (fetch_pulse) axi_arsize <= `AxSIZE_4B;
            else if (mem_read) begin
                case (op_width)
                    `OP_WIDTH_1_MEM: axi_arsize <= `AxSIZE_1B;
                    `OP_WIDTH_2_MEM: axi_arsize <= `AxSIZE_2B;
                    `OP_WIDTH_4_MEM: axi_arsize <= `AxSIZE_4B;
                    `OP_WIDTH_8_MEM: axi_arsize <= `AxSIZE_8B;
                    default:;
                endcase 
            end 
            else axi_arsize <= axi_arsize;
        end
    end

    // axi_arprot
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_arprot <= `ARPROT_DATA;
        else begin
            if ( fetch_pulse) axi_arprot <= `ARPROT_INSTR;
            else if (mem_read)  axi_arprot <= `ARPROT_DATA;
            else axi_arprot <= axi_arprot;
        end
    end

    // axi_arvalid
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0)
            axi_arvalid <= `FALSE;
        else if (~axi_arvalid & (fetch_pulse | mem_read) )
            axi_arvalid <= `TRUE;
        else if (M_AXI_ARREADY & axi_arvalid)
            axi_arvalid <= `FALSE;
        else
            axi_arvalid <= axi_arvalid;
    end

    // axi_rready
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 'b0) axi_rready <= `FALSE;
        else begin
            if(M_AXI_RVALID & ~axi_rready) axi_rready <= `TRUE;
            else axi_rready <= `FALSE;
        end 
    end

    // master_state
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) begin
            master_state <= MASTER_IDLE;
        end else begin
            case (master_state)
                MASTER_IDLE:
                    if (fetch_pulse) master_state <= MASTER_FETCH;
                    else master_state <= MASTER_IDLE;
                MASTER_FETCH: begin
                    last_rlast <= M_AXI_RLAST;
                    if (~last_rlast && M_AXI_RLAST) begin
                        if (mem_read | mem_write) master_state <= MASTER_MEM;
                        else master_state <= MASTER_IDLE;
                    end 
                    else master_state <= MASTER_FETCH;
                end
                MASTER_MEM: begin
                    if (mem_visit_end) master_state <= MASTER_IDLE;
                    else master_state <= MASTER_MEM;
                end
                default:;
            endcase
        end
    end


    ip_core ins_ip_core (
        .clk(M_AXI_ACLK),
        .reset(reset),
        .instr(instr),
        .instr_valid(instr_valid),
        .mem_read_data(mem_read_data),
        .mem_visit_end(mem_visit_end),

        .pc(pc),
        .fetch_pulse(fetch_pulse),
        .unknown_op(unknown_op),
        .gpr(gpr),
        .mcycle(mcycle),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_visit_addr(mem_visit_addr),
        .op_width(op_width),
        .mem_write_data(mem_write_data)
    );

    wire __unused =
        M_AXI_RDATA == 'b0 & 
        M_AXI_RID == 'b0 &
        'b0 == op_width &
        'b0 == mem_write &
        'b0 == mem_visit_addr &
        'b0 == M_AXI_BID &
        'b0 == M_AXI_BRESP
        // 'b0 == &
        ;

endmodule
