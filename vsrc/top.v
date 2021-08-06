`include "common.v"

module top #
(
    parameter integer AXI_ID_WIDTH = 1
) (
    input wire clk,
    input wire reset,

    // for diffTest --->
    output wire [`REG_BUS] pc,
    output wire [`REG_BUS] gpr [`GPR_NUM - 1: 0],
    output wire fetch_pulse, 
    // <--- for diffTest 
    output wire [`REG_BUS] mcycle,
    output wire unknown_op
);
    // user
    wire reset_n;
    // AR
    wire [AXI_ID_WIDTH - 1: 0] axi_arid;
    wire [`ADDR_WIDTH - 1: 0] axi_araddr;
    wire [7 : 0] axi_arlen;
    wire [2 : 0] axi_arsize;
    wire [1 : 0] axi_arburst;
    wire [3 : 0] axi_arcache;
    wire [2 : 0] axi_arprot;
    wire [3 : 0] axi_arqos;
    wire [3 : 0] axi_arregion;
    wire axi_arvalid;
    wire axi_arready;
    // R
    wire [AXI_ID_WIDTH - 1: 0] axi_rid;
    wire [`DATA_WIDTH - 1: 0] axi_rdata;
    wire [1 : 0] axi_rresp;
    wire axi_rlast;
    wire axi_rvalid;
    wire axi_rready;
    // AW
    wire [AXI_ID_WIDTH - 1 : 0] axi_awid;
    wire [`ADDR_WIDTH - 1: 0] axi_awaddr;
    wire [7 : 0] axi_awlen;
    wire [2 : 0] axi_awsize;
    wire [1 : 0] axi_awburst;
    wire [3 : 0] axi_awcache;
    wire [2 : 0] axi_awprot;
    wire [3 : 0] axi_awqos;
    wire [3 : 0] axi_awregion;
    wire axi_awvalid;
    wire axi_awready;
    // W
    wire [`REG_BUS] axi_wdata;
    wire [(`DATA_WIDTH / 8) - 1 : 0] axi_wstrb;
    wire axi_wlast;
    wire axi_wvalid;
    wire axi_wready;
    // B
    wire [AXI_ID_WIDTH - 1 : 0] axi_bid;
    wire [1 : 0] axi_bresp;
    wire axi_bvalid;
    wire axi_bready;

    assign reset_n = ~reset;

    master_axi #(
        .C_M_AXI_ID_WIDTH(AXI_ID_WIDTH),
        .C_M_AXI_DATA_WIDTH(`DATA_WIDTH),
        .C_M_AXI_ADDR_WIDTH(`ADDR_WIDTH),
    ) ins_master_axi(
        //user
        .unknown_op(unknown_op),
        .gpr(gpr),
        .mcycle(mcycle),
        .pc(pc),
        .fetch_pulse(fetch_pulse),

        //global
        .M_AXI_ACLK(clk),
        .M_AXI_ARESETn(reset_n),

        //read address channel
        .M_AXI_ARID(axi_arid),
        .M_AXI_ARADDR(axi_araddr),
        .M_AXI_ARLEN(axi_arlen),
        .M_AXI_ARSIZE(axi_arsize),
        .M_AXI_ARBURST(axi_arburst),
        .M_AXI_ARCACHE(axi_arcache),
        .M_AXI_ARPROT(axi_arprot),
        .M_AXI_ARQOS(axi_arqos),
        .M_AXI_ARREGION(axi_arregion),
        .M_AXI_ARVALID(axi_arvalid),
        .M_AXI_ARREADY(axi_arready),

        //read data channel
        .M_AXI_RID(axi_rid),
        .M_AXI_RDATA(axi_rdata),
        .M_AXI_RRESP(axi_rresp),
        .M_AXI_RLAST(axi_rlast),
        .M_AXI_RVALID(axi_rvalid),
        .M_AXI_RREADY(axi_rready),

        //write address channel
        .M_AXI_AWID(axi_awid),
        .M_AXI_AWADDR(axi_awaddr),
        .M_AXI_AWLEN(axi_awlen),
        .M_AXI_AWSIZE(axi_awsize),
        .M_AXI_AWBURST(axi_awburst),
        .M_AXI_AWCACHE(axi_awcache),
        .M_AXI_AWPROT(axi_awprot),
        .M_AXI_AWQOS(axi_awqos),
        .M_AXI_AWREGION(axi_awregion),
        .M_AXI_AWVALID(axi_awvalid),
        .M_AXI_AWREADY(axi_awready),

        //write data channel
        .M_AXI_WDATA(axi_wdata),
        .M_AXI_WSTRB(axi_wstrb),
        .M_AXI_WLAST(axi_wlast),
        .M_AXI_WVALID(axi_wvalid),
        .M_AXI_WREADY(axi_wready),

        //write response
        .M_AXI_BID(axi_bid),
        .M_AXI_BRESP(axi_bresp),
        .M_AXI_BVALID(axi_bvalid),
        .M_AXI_BREADY(axi_bready)
    );

    slave_axi # (
        .C_S_AXI_ID_WIDTH(AXI_ID_WIDTH),
        .C_S_AXI_DATA_WIDTH(`DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(`ADDR_WIDTH)
    ) ins_slave_axi (
        //global
        .S_AXI_ACLK(clk),
        .S_AXI_ARESETn(reset_n),

        //read address channel
        .S_AXI_ARID(axi_arid),
        .S_AXI_ARADDR(axi_araddr),
        .S_AXI_ARLEN(axi_arlen),
        .S_AXI_ARSIZE(axi_arsize),
        .S_AXI_ARBURST(axi_arburst),
        .S_AXI_ARCACHE(axi_arcache),
        .S_AXI_ARPROT(axi_arprot),
        .S_AXI_ARQOS(axi_arqos),
        .S_AXI_ARREGION(axi_arregion),
        .S_AXI_ARVALID(axi_arvalid),
        .S_AXI_ARREADY(axi_arready),

        //read data channel
        .S_AXI_RID(axi_rid),
        .S_AXI_RDATA(axi_rdata),
        .S_AXI_RRESP(axi_rresp),
        .S_AXI_RLAST(axi_rlast),
        .S_AXI_RVALID(axi_rvalid),
        .S_AXI_RREADY(axi_rready),

        //write address channel
        .S_AXI_AWID(axi_awid),
        .S_AXI_AWADDR(axi_awaddr),
        .S_AXI_AWLEN(axi_awlen),
        .S_AXI_AWSIZE(axi_awsize),
        .S_AXI_AWBURST(axi_awburst),
        .S_AXI_AWCACHE(axi_awcache),
        .S_AXI_AWPROT(axi_awprot),
        .S_AXI_AWQOS(axi_awqos),
        .S_AXI_AWREGION(axi_awregion),
        .S_AXI_AWVALID(axi_awvalid),
        .S_AXI_AWREADY(axi_awready),   

        //write data channel
        .S_AXI_WDATA(axi_wdata),
        .S_AXI_WSTRB(axi_wstrb),
        .S_AXI_WLAST(axi_wlast),
        .S_AXI_WVALID(axi_wvalid),
        .S_AXI_WREADY(axi_wready),
    
        //write response
        .S_AXI_BID(axi_bid),
        .S_AXI_BRESP(axi_bresp),
        .S_AXI_BVALID(axi_bvalid),
        .S_AXI_BREADY(axi_bready)
    );

endmodule
