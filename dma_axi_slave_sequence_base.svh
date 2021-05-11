`ifndef DMA_AXI_SLAVE_SEQUENCE_BASE_SVH
`define DMA_AXI_SLAVE_SEQUENCE_BASE_SVH
typedef sequence_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS(dma_axi_status),
  .REQ(axi_slave_item)
) dma_axi_slave_sequence_base_of_base;

virtual class dma_axi_slave_sequence_base extends axi_sequence_base #(
  .BASE(dma_axi_slave_sequence_base_of_base),
  .SEQUENCER(dma_axi_slave_sequencer)
);
  function new(string name="dma_axi_slave_sequence_base");
  	super.new(name);
  	set_automatic_phase_objection(1);
  endfunction : new

  virtual task get_request(
  	input axi_access_type access_type,
  	ref   axi_slave_item  request
  );
  	p_sequencer.get_request(access_type, request);
  endtask : get_request

  virtual task get_write_request(ref axi_slave_item request);
  	get_request(AXI_WRITE, request);
  endtask : get_write_request

  virtual task get_read_request(ref axi_slave_item request);
  	get_request(AXI_READ, request);
  endtask : get_read_request
endclass : dma_axi_slave_sequence_base
`endif