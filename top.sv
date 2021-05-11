`timescale 1ns/1ps
`include "axi_data_types_pkg.sv"
`include "dma_axi_pkg.sv"
`include "test_pkg.sv"
`include "dma_axi32.v"
`include "sample_delay.sv"

module top();
  import uvm_pkg::*;
  import axi_data_types_pkg::*;
  import dma_axi_pkg::*;
  import test_pkg::*;

  /*CLOCK & RESET*/
  bit clk = 0;
  initial begin
    repeat(100000) begin
      #5 clk = 1;
      #5 clk = 0;
    end
    $display("[TOP] RAN OUT OF CLOCK.");
  end

  bit reset = 0; ////
  initial begin
    repeat(20) @(posedge clk);
    reset = 1;
  end
  /*CLOCK & RESET*/

  /*INTERFACE*/
  dma_axi_if dut_intf(clk, reset);
  dma_axi_if delay_intf(clk, reset);
  dma_apb_config_if config_intf(clk, reset);
  /*INTERFACE*/
  
  /*DUT*/
  dma_axi32 dut(clk, (~reset), config_intf.scan_en, config_intf.idle, config_intf.INT, config_intf.periph_tx_req, config_intf.periph_tx_clr, config_intf.periph_rx_req, config_intf.periph_rx_clr, config_intf.pclken, config_intf.psel, config_intf.penable, config_intf.paddr, config_intf.pwrite, config_intf.pwdata, config_intf.prdata, config_intf.pslverr, config_intf.pready, dut_intf.awid, dut_intf.awaddr, dut_intf.awlen, dut_intf.awsize, dut_intf.awvalid, dut_intf.awready, dut_intf.wid, dut_intf.wdata, dut_intf.wstrb, dut_intf.wlast, dut_intf.wvalid, dut_intf.wready, dut_intf.bid, dut_intf.bresp, dut_intf.bvalid, dut_intf.bready, dut_intf.arid, dut_intf.araddr, dut_intf.arlen, dut_intf.arsize, dut_intf.arvalid, dut_intf.arready, dut_intf.rid, dut_intf.rdata, dut_intf.rresp, dut_intf.rlast, dut_intf.rvalid, dut_intf.rready);
  /*DUT*/

  initial begin
    uvm_config_db #(dma_axi_vif)       ::set(null, "", "vif", dut_intf);
    uvm_config_db #(dma_axi_vif)       ::set(null, "", "vif2", delay_intf);
    uvm_config_db #(dma_apb_config_vif)::set(null, "", "intf_cof", config_intf);

    run_test("sample_test");
  end

  initial begin
    $dumpfile("top.vcd");
    $dumpvars(9, top);
  end
 
endmodule : top
