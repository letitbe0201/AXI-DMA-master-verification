`ifndef DMA_AXI_STATUS_SVH
`define DMA_AXI_STATUS_SVH
typedef class dma_axi_memory;

class dma_axi_status extends status_base;
  dma_axi_memory memory;

  function new(string name="dma_axi_status");
  	super.new(name);
  endfunction : new
  `uvm_object_utils(dma_axi_status)
endclass : dma_axi_status
`endif