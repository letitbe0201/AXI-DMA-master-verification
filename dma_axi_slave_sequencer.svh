`ifndef DMA_AXI_SLAVE_SEQUENCER_SVH
`define DMA_AXI_SLAVE_SEQUENCER_SVH
typedef sequencer_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS       (dma_axi_status),
  .REQ(axi_slave_item)
) dma_axi_slave_sequencer_base;

class dma_axi_slave_sequencer extends axi_sequencer_base #(
  .BASE(dma_axi_slave_sequencer_base)
);
  uvm_analysis_imp #(
    axi_item, dma_axi_slave_sequencer
  ) request_export;

  protected axi_item_subscriber write_request_waiter;
  protected axi_item_subscriber read_request_waiter;
  protected axi_item_subscriber request_waiter[axi_access_type];

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);

  	request_export = new("request_export", this);

  	write_request_waiter = new("write_request_waiter", this);
  	read_request_waiter  = new("read_request_waiter", this);

  	request_waiter[AXI_WRITE] = write_request_waiter;
  	request_waiter[AXI_READ]  = read_request_waiter;
  endfunction : build_phase

  virtual function void write(axi_item request);
  	request_waiter[request.access_type].write(request);
  endfunction : write

  virtual task get_request(
    input axi_access_type access_type,
    ref   axi_slave_item  request
  );
  	axi_item item;
  	request_waiter[access_type].get_item(item);
  	void'($cast(request, item));
  endtask : get_request

  function new(string name="dma_axi_slave_sequencer", uvm_component par=null);
  	super.new(name, par);
  endfunction : new

  `uvm_component_utils(dma_axi_slave_sequencer)
endclass : dma_axi_slave_sequencer
`endif