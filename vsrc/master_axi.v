module master_axi #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line

    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    parameter integer C_M_AXI_BURST_LEN	= 16,
    // Thread ID Width
    parameter integer C_M_AXI_ID_WIDTH	= 1,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH	= 32,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH	= 32,
    // Width of User Write Address Bus
    /* verilator lint_off UNUSED */
    parameter integer C_M_AXI_AWUSER_WIDTH	= 0, 
    /* verilator lint_off UNUSED */
    // Width of User Read Address Bus
    parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
    // Width of User Write Data Bus
    parameter integer C_M_AXI_WUSER_WIDTH	= 0,
    // Width of User Read Data Bus
    parameter integer C_M_AXI_RUSER_WIDTH	= 0,
    // Width of User Response Bus
    parameter integer C_M_AXI_BUSER_WIDTH	= 0
)
(
    // Users to add ports here

    // User ports ends
    // Do not modify the ports beyond this line

    // // Initiate AXI transactions
    // input wire  INIT_AXI_TXN,
    // // Asserts when transaction is complete
    // output wire  TXN_DONE,
    // // Asserts when ERROR is detected
    // output reg  ERROR,


    // Global Clock Signal.
    input wire  M_AXI_ACLK,
    // Global Reset Singal. This Signal is Active Low
    input wire  M_AXI_ARESETn,

/*
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
    // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
    output wire  M_AXI_AWLOCK,
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
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
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
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
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
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
    // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
    input wire  M_AXI_BVALID,
    // Response ready. This signal indicates that the master
    // can accept a write response.
    output wire  M_AXI_BREADY,
    // <----- Write response channel
*/

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
    // output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,  
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
    /* verilator lint_off LITENDIAN */
    input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER, 
    /* verilator lint_off LITENDIAN */
    // Read valid. This signal indicates that the channel
    // is signaling the required read data.
    input wire  M_AXI_RVALID,
    // Read ready. This signal indicates that the master can
    // accept the read data and response information.
    output wire  M_AXI_RREADY
    // <----- Read data channel 
);
    parameter [1 : 0] MASTER_IDLE = 2'b00,
                      MASTER_FETCH = 2'b01;
    wire reset;
    reg [`INSTR_WIDTH - 1 : 0] instr;
    reg fetch_pulse;
    reg [`ADDR_WIDTH - 1: 0] axi_araddr;
    reg [`ADDR_WIDTH - 1: 0] pc;
    reg [2 : 0] axi_arsize;
    reg axi_arvalid;
    reg [1 : 0] master_state;
    reg axi_rready;
    reg last_rlast;
    reg instr_valid;

    // I/O Connections assignments
    assign reset = ~M_AXI_ARESETn;
    // Read Address (AR)
    assign M_AXI_ARID = 'b0;
    assign M_AXI_ARADDR	= axi_araddr;
    //Burst LENgth is number of transaction beats, minus 1
    /* verilator lint_off WIDTH */
	assign M_AXI_ARLEN	= C_M_AXI_BURST_LEN - 1;
    /* verilator lint_off WIDTH */
    assign M_AXI_ARSIZE = axi_arsize;
	assign M_AXI_ARBURST = `AxBURST_FIXED;
    assign M_AXI_ARCACHE = 4'b0010; //Normal Non-cacheable Non-bufferable
    assign M_AXI_ARPROT = fetch_pulse ? `ARPROT_INSTR : `ARPROT_DATA;
    assign M_AXI_ARQOS = 4'h0;
    assign M_AXI_ARREGION = 'b0;
    assign M_AXI_ARVALID = axi_arvalid;
    assign M_AXI_RREADY = axi_rready;

    ip_core ins_ip_core (
        .clk(M_AXI_ACLK),
        .reset(reset),
        .instr(instr),
        .instr_valid(instr_valid),

        .pc(pc),
        .fetch_pulse(fetch_pulse)
    );

    // axi_arsize
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_arsize <= 'b0; 
        else begin
            if (fetch_pulse) axi_arsize <= `AxSIZE_4B;
            else axi_arsize <= axi_arsize;
        end
    end

    // axi_araddr
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) axi_araddr <= 'b0; 
        else begin
            if (fetch_pulse == 1'b1) axi_araddr <= pc;
            else axi_araddr <= axi_araddr;
        end 
    end

    // axi_arvalid
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0)
            axi_arvalid <= 1'b0;
        else if (~axi_arvalid && fetch_pulse)
            axi_arvalid <= 1'b1;
        else if (M_AXI_ARREADY && axi_arvalid)
            axi_arvalid <= 1'b0;
        else
            axi_arvalid <= axi_arvalid;
    end

    // axi_rready
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 'b0) axi_rready <= 1'b0;
        else if(M_AXI_RVALID) begin
            if (M_AXI_RLAST && axi_rready) axi_rready <= 1'b0;
            else axi_rready <= 1'b1;
        end
    end

    // master_state
    always @ (posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETn == 1'b0) begin
            master_state <= MASTER_IDLE;
        end else begin
            case (master_state)
                MASTER_IDLE:
                    if (fetch_pulse == 1'b1) master_state <= MASTER_FETCH;
                    else master_state <= MASTER_IDLE;
                MASTER_FETCH: begin
                    last_rlast <= M_AXI_RLAST;
                    if (last_rlast && ~M_AXI_RLAST) master_state <= MASTER_IDLE;
                    else master_state <= MASTER_FETCH;
                end
                default:;
            endcase
        end
    end

    // instr_valid
    always @ (*) begin
        instr = M_AXI_RDATA;
        instr_valid = M_AXI_RVALID & master_state == MASTER_FETCH;
    end

endmodule
