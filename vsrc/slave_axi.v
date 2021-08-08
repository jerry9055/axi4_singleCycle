import "DPI-C" function void ReadData(
    input   longint raddr,
    input   byte arsize,

    output  longint rdata,
    output  byte rresp
);

import "DPI-C" function void WriteData(
    input   longint waddr,
    input   byte awsize,
    input   longint wdata,

    output  byte bresp
);

module slave_axi # 
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line

    // Width of ID for for write address, write data, read address and read data
    parameter integer C_S_AXI_ID_WIDTH	= 1,
    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH	= 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH	= 6
)
(
    // Users to add ports here

    // User ports ends
    // Do not modify the ports beyond this line

    // Global Clock Signal
    input wire  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input wire  S_AXI_ARESETn,

    // Write Address Channel ----->
    // Write Address ID
    input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_AWID,
    // Write address
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    input wire [7 : 0] S_AXI_AWLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    input wire [2 : 0] S_AXI_AWSIZE,
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    input wire [1 : 0] S_AXI_AWBURST,
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    input wire [3 : 0] S_AXI_AWCACHE,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    input wire [2 : 0] S_AXI_AWPROT,
    // Quality of Service, QoS identifier sent for each
    // write transaction.
    input wire [3 : 0] S_AXI_AWQOS,
    // Region identifier. Permits a single physical interface
    // on a slave to be used for multiple logical interfaces.
    input wire [3 : 0] S_AXI_AWREGION,
    // Optional User-defined signal in the write address channel.
    // Generally, this specification recommends that the User signals are not used,
    // !!!! input wire [C_S_AXI_AWUSER_WIDTH-1 : 0] S_AXI_AWUSER, // !!!!!
    // Write address valid. This signal indicates that
    // the channel is signaling valid write address and
    // control information.
    input wire  S_AXI_AWVALID,
    // Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated
    // control signals.
    output wire  S_AXI_AWREADY,
    // <----- Write Address Channel 


    // Write Data Channel ----->
    // Write Data
    input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    // Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
    input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    // Write last. This signal indicates the last transfer
    // in a write burst.
    input wire  S_AXI_WLAST,
    // Optional User-defined signal in the write data channel.
    // Generally, this specification recommends that the User signals are not used,
    //!!! input wire [C_S_AXI_WUSER_WIDTH-1 : 0] S_AXI_WUSER, //!!!!
    // Write valid. This signal indicates that valid write
    // data and strobes are available.
    input wire  S_AXI_WVALID,
    // Write ready. This signal indicates that the slave
    // can accept the write data.
    output wire  S_AXI_WREADY,
    // <----- Write Data Channel


    // Write response channel ----->
    // Response ID tag. This signal is the ID tag of the
    // write response.
    output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_BID,
    // Write response. This signal indicates the status
    // of the write transaction.
    output wire [1 : 0] S_AXI_BRESP,
    // Optional User-defined signal in the write response channel.
    // Generally, this specification recommends that the User signals are not used,
    //!!!! output wire [C_S_AXI_BUSER_WIDTH-1 : 0] S_AXI_BUSER, //!!!!
    // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
    output wire  S_AXI_BVALID,
    // Response ready. This signal indicates that the master
    // can accept a write response.
    input wire  S_AXI_BREADY,
    // <----- Write response channel


    // Read address channel ----->
    // Read address ID. This signal is the identification
    // tag for the read address group of signals.
    input wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_ARID,
    // Read address. This signal indicates the initial
    // address of a read burst transaction.
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    input wire [7 : 0] S_AXI_ARLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    input wire [2 : 0] S_AXI_ARSIZE,
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    input wire [1 : 0] S_AXI_ARBURST,
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    input wire [3 : 0] S_AXI_ARCACHE,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    input wire [2 : 0] S_AXI_ARPROT,
    // Quality of Service, QoS identifier sent for each
    // read transaction.
    input wire [3 : 0] S_AXI_ARQOS,
    // Region identifier. Permits a single physical interface
    // on a slave to be used for multiple logical interfaces.
    input wire [3 : 0] S_AXI_ARREGION,
    // Optional User-defined signal in the read address channel.
    // Generally, this specification recommends that the User signals are not used.
    //!!!!! input wire [C_S_AXI_ARUSER_WIDTH-1 : 0] S_AXI_ARUSER, // !!!!!
    // Write address valid. This signal indicates that
    // the channel is signaling valid read address and
    // control information.
    input wire  S_AXI_ARVALID,
    // Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated
    // control signals.
    output wire  S_AXI_ARREADY,
    // <----- Read address channel


    // Read data channel ----->
    // Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
    output wire [C_S_AXI_ID_WIDTH-1 : 0] S_AXI_RID,
    // Read Data
    output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    // Read response. This signal indicates the status of
    // the read transfer.
    output wire [1 : 0] S_AXI_RRESP,
    // Read last. This signal indicates the last transfer
    // in a read burst.
    output wire  S_AXI_RLAST,
    // Optional User-defined signal in the read address channel.
    // Generally, this specification recommends that the User signals are not used.
    //!!!!!! output wire [C_S_AXI_RUSER_WIDTH-1 : 0] S_AXI_RUSER, //!!!!!!!!!
    // Read valid. This signal indicates that the channel
    // is signaling the required read data.
    output wire  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
    // accept the read data and response information.
    input wire  S_AXI_RREADY
    // <----- Read data channel
);
    reg axi_arready;
    wire [63 : 0] axi_rdata_cpp;
    wire [1 : 0] rresp_cpp;
    reg axi_rvalid;
    reg axi_awready;
    reg [`ADDR_WIDTH - 1: 0] axi_awaddr;
    reg [2 : 0] axi_awsize;
    reg axi_wready;
    reg axi_awid;
    reg axi_bvalid;
    reg [1: 0] axi_bresp;
    
    // AR
    assign S_AXI_ARREADY = axi_arready;
    // R
    assign S_AXI_RID = S_AXI_ARID;
    assign S_AXI_RDATA = axi_rdata_cpp;
    assign S_AXI_RRESP = rresp_cpp;
    assign S_AXI_RLAST = S_AXI_RVALID & S_AXI_RREADY;
    assign S_AXI_RVALID = axi_rvalid;
    // AW
    assign S_AXI_AWREADY = axi_awready;
    // W
    assign S_AXI_WREADY = axi_wready;
    // B
    assign S_AXI_BID = axi_awid;
    assign S_AXI_BVALID = axi_bvalid;
    assign S_AXI_BRESP = axi_bresp;

    // axi_bvalid
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETn == 1'b0) axi_bvalid <= `FALSE;
        begin
            if(S_AXI_WVALID & S_AXI_WREADY & S_AXI_WLAST & ~axi_bvalid) begin
                WriteData(
                    .waddr(axi_awaddr),
                    .awsize({5'b0, axi_awsize}),
                    .wdata(S_AXI_WDATA),

                    .bresp({6'b0, axi_bresp})
                );
                axi_bvalid <= `TRUE;
            end else if (axi_bvalid & S_AXI_BREADY) axi_bvalid <= `FALSE;
            else axi_bvalid <= axi_bvalid;
        end 
    end

    // axi_awid
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_AWVALID & S_AXI_AWREADY) axi_awid <= S_AXI_AWID;
        else axi_awid <= axi_awid;
    end

    // axi_wready
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETn == 1'b0) axi_wready <= `FALSE;
        else begin
            if (S_AXI_WVALID & ~axi_wready) axi_wready <= `TRUE;
            else axi_wready <= `FALSE;
        end
    end

    // axi_awsize
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_AWVALID) axi_awsize <= S_AXI_AWSIZE;
        else axi_awsize <= axi_awsize;
    end

    // axi_awaddr
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_AWVALID) axi_awaddr <= S_AXI_AWADDR;
        else axi_awaddr <= axi_awaddr;
    end

    // axi_awready
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETn == 1'b0) axi_awready <= `FALSE;
        else begin
            if (S_AXI_AWVALID & ~axi_awready) axi_awready <= `TRUE;
            else axi_awready <= `FALSE;
        end 
    end

    // axi_arready
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETn == 1'b0) axi_arready <= `FALSE;
        else begin
            if (S_AXI_ARVALID & ~axi_arready) axi_arready <= `TRUE;
            else axi_arready <= `FALSE;
        end
    end

    // axi_rvalid
    always @(posedge S_AXI_ACLK) begin    
        if (S_AXI_ARESETn == 1'b0) axi_rvalid <= `FALSE;
        else begin
            if (S_AXI_ARVALID & axi_arready) begin
                ReadData(
                    .raddr(S_AXI_ARADDR),
                    .arsize({5'b0, S_AXI_ARSIZE}),

                    .rdata(axi_rdata_cpp),
                    .rresp({6'b0, rresp_cpp})
                );  
                axi_rvalid <= `TRUE;
            end
            else if (S_AXI_RREADY & axi_rvalid) axi_rvalid <= `FALSE;
            else axi_rvalid <= axi_rvalid;
        end
    end

    wire __unused = 
    'b0 == S_AXI_ARBURST & 
    'b0 == S_AXI_ARLEN &
    'b0 == S_AXI_ARCACHE & 
    'b0 == S_AXI_ARPROT &
    'b0 == S_AXI_ARQOS &
    'b0 == S_AXI_ARREGION &
    'b0 == S_AXI_AWLEN &
    'b0 == S_AXI_AWBURST &
    'b0 == S_AXI_AWCACHE &
    'b0 == S_AXI_AWPROT &
    'b0 == S_AXI_AWQOS &
    'b0 == S_AXI_AWREGION &
    'b0 == S_AXI_WSTRB
    // 'b0 == &
    ;

endmodule
