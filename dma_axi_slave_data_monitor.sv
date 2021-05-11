`ifndef DMA_AXI_SLAVE_DATA_MONITOR
`define DMA_AXI_SLAVE_DATA_MONITOR
class dma_axi_slave_data_monitor extends component_base #(
  .BASE          (uvm_subscriber #(axi_item)),
  .CONFIGURATION (dma_axi_configuration),
  .STATUS        (dma_axi_status)
);
  protected dma_axi_memory memory;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	if (status.memory == null) begin
  	  status.memory = dma_axi_memory::type_id::create("memory");
  	  status.memory.set_context(configuration, status);
  	end
  	memory = status.memory;
  endfunction : build_phase

  function void write(axi_item t);
  	foreach (t.data[i]) begin
  	  memory.put(t.data[i], t.strobe[i], t.burst_size, t.address, i);
  	end
  endfunction : write

  function new(string name="dma_axi_slave_data_monitor", uvm_component par=null);
  	super.new(name, par);
  endfunction : new

  `uvm_component_utils(dma_axi_slave_data_monitor)
endclass : dma_axi_slave_data_monitor
`endif