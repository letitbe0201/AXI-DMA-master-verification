`ifndef DMA_AXI_SLAVE_MONITOR_SV
`define DMA_AXI_SLAVE_MONITOR_SV
typedef reactive_monitor_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS       (dma_axi_status),
  .ITEM         (axi_item)
) dma_axi_slave_monitor_base;

virtual class dma_axi_slave_monitor extends axi_monitor_base #(
  .BASE(dma_axi_slave_monitor_base),
  .ITEM(axi_slave_item)
);
  task begin_address(axi_item item); // Send axi item to Read Monitor/Write Monitor
  	super.begin_address(item);
  	write_request(item);
  endtask : begin_address

  function void write_request(axi_item item);
  	super.write_request(item);
  endfunction : write_request

  function new(string name="dma_axi_slave_monitor", uvm_component par=null);
  	super.new(name, par);
  endfunction : new
endclass : dma_axi_slave_monitor

class dma_axi_slave_write_monitor extends dma_axi_slave_monitor;
  function new(string name="dma_axi_slave_write_monitor", uvm_component par=null);
  	super.new(name, par);
  	write_component = 1;
  endfunction : new
  `uvm_component_utils(dma_axi_slave_write_monitor)
endclass : dma_axi_slave_write_monitor

class dma_axi_slave_read_monitor extends dma_axi_slave_monitor;
  function new(string name="dma_axi_slave_read_monitor", uvm_component par=null);
  	super.new(name, par);
  	write_component = 0;
  endfunction : new
  `uvm_component_utils(dma_axi_slave_read_monitor)
endclass : dma_axi_slave_read_monitor
`endif