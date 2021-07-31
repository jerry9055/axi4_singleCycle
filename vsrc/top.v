`include "common.v"

module top #
(
    parameter integer AXI_ID_WIDTH = 1,
    // parameter integer AXI_ARUSER_WIDTH = 0,
    parameter integer AXI_RUSER_WIDTH = 0
) (
    input wire clk,
    input wire reset,

    output wire [AXI_ID_WIDTH - 1: 0] axi_arid,
    output wire [`ADDR_WIDTH - 1: 0] axi_araddr,
    output wire [7 : 0] axi_arlen,
    output wire [2 : 0] axi_arsize,
    output wire [1 : 0] axi_arburst,
    output wire [3 : 0] axi_arcache,
    output wire [2 : 0] axi_arprot,
    output wire [3 : 0] aix_arqos,
    output wire [3 : 0] aix_arregion,
    // output wire [AXI_ARUSER_WIDTH - 1: 0] axi_aruser,
    output wire axi_arvalid,
    input wire  axi_arready,
    input wire [AXI_ID_WIDTH - 1: 0] axi_rid,
    input wire [`DATA_WIDTH - 1: 0] axi_rdata,
    input wire [1 : 0] axi_rresp,
    input wire axi_rlast,
    /* verilator lint_off LITENDIAN */
    input wire [AXI_RUSER_WIDTH - 1: 0] axi_ruser,
    /* verilator lint_off LITENDIAN */
    input wire axi_rvalid,
    output wire axi_rready
);
    wire reset_n;

    assign reset_n = ~reset;

    master_axi #(
        .C_M_AXI_BURST_LEN(1),
        .C_M_AXI_ID_WIDTH(AXI_ID_WIDTH),
        .C_M_AXI_DATA_WIDTH(`DATA_WIDTH),
        .C_M_AXI_ADDR_WIDTH(`ADDR_WIDTH),
        // .C_M_AXI_ARUSER_WIDTH(AXI_ARUSER_WIDTH),
        .C_M_AXI_RUSER_WIDTH(AXI_RUSER_WIDTH) 
    ) ins_master_aix(
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
        .M_AXI_ARQOS(aix_arqos),
        .M_AXI_ARREGION(aix_arregion),
        // .M_AXI_ARUSER(axi_aruser),
        .M_AXI_ARVALID(axi_arvalid),
        .M_AXI_ARREADY(axi_arready),

        //read data channel
        .M_AXI_RID(axi_rid),
        .M_AXI_RDATA(axi_rdata),
        .M_AXI_RRESP(axi_rresp),
        .M_AXI_RLAST(axi_rlast),
        .M_AXI_RUSER(axi_ruser),
        .M_AXI_RVALID(axi_rvalid),
        .M_AXI_RREADY(axi_rready)
    );

endmodule
