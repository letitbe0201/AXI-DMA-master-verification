`ifndef DMA_AXI_MEMORY_SVH
`define DMA_AXI_MEMORY_SVH
typedef memory_base #(
  .ADDRESS_WIDTH($bits(axi_address)),
  .DATA_WIDTH   ($bits(axi_data))
) dma_axi_memory_base;

class dma_axi_memory extends object_base #(
  .BASE          (dma_axi_memory_base),
  .CONFIGURATION (dma_axi_configuration),
  .STATUS        (dma_axi_status)
);
  function void set_configuration(configuration_base configuration);
  	super.set_configuration(configuration);
  	byte_width = this.configuration.data_width / 8;
  endfunction : set_configuration

  function new(string name="dma_axi_memory");
  	super.new(name);
  endfunction : new

  `uvm_object_utils(dma_axi_memory)
endclass : dma_axi_memory
`endif