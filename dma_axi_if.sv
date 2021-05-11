`ifndef DMA_AXI_IF_SV
`define DMA_AXI_IF_SV
interface dma_axi_if (
  input clk,
  input rst
);
  import axi_data_types_pkg::*;

  axi_id           awid;
  axi_address      awaddr;
  axi_burst_length awlen;
  axi_burst_size   awsize;
  bit              awvalid;
  bit              awready;
  bit              awack;
//  axi_id awburst;

  axi_id     wid;
  axi_data   wdata;
  axi_strobe wstrb;
  bit        wlast;
  bit        wvalid;
  bit        wready;
  bit        wack;

  axi_id       bid;
  axi_response bresp;
  bit          bvalid;
  bit          bready;
  bit          back;

  axi_id           arid;
  axi_address      araddr;
  axi_burst_length arlen;
  axi_burst_size   arsize;
  bit              arvalid;
  bit              arready;
  bit              arack;
//  axi_id arburst;

  axi_id       rid;
  axi_data     rdata;
  axi_response rresp;
  bit          rlast;
  bit          rvalid;
  bit          rready;
  bit          rack;

  assign awack = (awvalid && awready) ? '1 : '0;
  assign wack  = (wvalid  &&  wready) ? '1 : '0;
  assign back  = (bvalid  &&  bready) ? '1 : '0;
  assign arack = (arvalid && arready) ? '1 : '0;
  assign rack  = (rvalid  && rready) ? '1 : '0;

  clocking master_cb @(posedge clk);
    output awid;
    output awaddr;
    output awlen;
    output awsize;
    output awvalid;
    input  awready;
    input  awack;
//    output awburst;
    output wid;
    output wdata;
    output wstrb;
    output wlast;
    output wvalid;
    input  wready;
    input  wack;
    input  bid;
    input  bresp;
    input  bvalid;
    output bready;
    input  back;
    output arid;
    output araddr;
    output arlen;
    output arsize;
    output arvalid;
    input  arready;
    input  arack;
//   output arqos;
//   output arburst;
    input  rid;
    input  rdata;
    input  rresp;
    input  rlast;
    input  rvalid;
    output rready;
    input  rack;
  endclocking

  clocking slave_cb @(posedge clk);
    input  awid;
    input  awaddr;
    input  awlen;
    input  awsize;
    input  awvalid;
    output awready;
    input  awack;
//    input awburst;
    input  wid;
    input  wdata;
    input  wstrb;
    input  wlast;
    input  wvalid;
    output wready;
    input  wack;
    output bid;
    output bresp;
    output bvalid;
    input  bready;
    input  back;
    input  arid;
    input  araddr;
    input  arlen;
    input  arsize;
    input  arvalid;
    output arready;
    input  arack;
//   input arqos;
//   input arburst;
    output rid;
    output rdata;
    output rresp;
    output rlast;
    output rvalid;
    input  rready;
    input  rack;
  endclocking

  clocking monitor_cb @(posedge clk);
    input awid;
    input awaddr;
    input awlen;
    input awsize;
    input awvalid;
    input awready;
    input awack;
//    input awburst;
    input wid;
    input wdata;
    input wstrb;
    input wlast;
    input wvalid;
    input wready;
    input wack;
    input bid;
    input bresp;
    input bvalid;
    input bready;
    input back;
    input arid;
    input araddr;
    input arlen;
    input arsize;
    input arvalid;
    input arready;
    input arack;
//   input arqos;
//   input arburst;
    input  rid;
    input  rdata;
    input  rresp;
    input  rlast;
    input  rvalid;
    input rready;
    input  rack;
  endclocking
endinterface : dma_axi_if
`endif
