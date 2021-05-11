`ifndef DMA_APB_CONFIG_IF_SV
`define DMA_APB_CONFIG_IF_SV
interface dma_apb_config_if(input clk, input rst);
  bit scan_en;
  bit idle;
  bit INT;
  bit [31:1] periph_tx_req;
  bit [31:1] periph_tx_clr;
  bit [31:1] periph_rx_req;
  bit [31:1] periph_rx_clr;
  bit pclken;
  bit psel;
  bit penable;
  bit [12:0] paddr;
  bit pwrite;
  bit [31:0] pwdata;
  bit [31:0] prdata;
  bit pslverr;
  bit pready;
  
  clocking config_cb @(posedge clk);
    input  scan_en;
    output idle;
    output INT;
    input  periph_tx_req;
    output periph_tx_clr;
    input  periph_rx_req;
    output periph_rx_clr;
    input  pclken;
    input  psel;
    input  penable;
    input  paddr;
    input  pwrite;
    input  pwdata;
    output prdata;
    output pslverr;
    output pready;
  endclocking

  clocking monitor @(posedge clk);
    input scan_en;
    input idle;
    input INT;
    input periph_tx_req;
    input periph_tx_clr;
    input periph_rx_req;
    input periph_rx_clr;
    input pclken;
    input psel;
    input penable;
    input paddr;
    input pwrite;
    input pwdata;
    input prdata;
    input pslverr;
    input pready;
  endclocking
endinterface : dma_apb_config_if
`endif
