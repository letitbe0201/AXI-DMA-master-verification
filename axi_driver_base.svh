`ifndef AXI_DRIVER_BASE_SVH
`define AXI_DRIVER_BASE_SVH
class axi_sub_driver_base #(
  type ITEM = uvm_sequence_item
) extends component_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS(dma_axi_status)
);
  protected axi_item item_buffer[$];
  protected uvm_driver #(ITEM) root_driver;

  function new(string name="axi_sub_driver_base", uvm_component parent=null);
  	super.new(name, parent);
  	void'($cast(root_driver, parent));
  endfunction : new 

  virtual task put_request(axi_item request);
    item_buffer.push_back(request);
  endtask : put_request

  virtual task put_response(axi_item response);
  	ITEM item;
  	void'($cast(item, response));
  	root_driver.seq_item_port.put(item);
  endtask : put_response
endclass : axi_sub_driver_base

class axi_driver_base #(
  type ITEM         = uvm_sequence_item,
  type WRITE_DRIVER = uvm_component,
  type READ_DRIVER  = uvm_component
)extends component_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS(dma_axi_status),
  .BASE(uvm_driver #(ITEM))
);
  protected WRITE_DRIVER write_driver;
  protected READ_DRIVER  read_driver;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);

  	write_driver = WRITE_DRIVER::type_id::create("write_driver", this);
  	write_driver.set_context(configuration, status);
  	read_driver  = READ_DRIVER::type_id::create("read_driver", this);
  	read_driver.set_context(configuration, status);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
  	ITEM item;
  	forever begin
  	  seq_item_port.get(item);
  	  if (item.is_write()) begin
  	    write_driver.put_request(item);
      end
  	  else
  	  	read_driver.put_request(item);
  	end
  endtask : run_phase

  function new(string name="axi_driver_base", uvm_component parent=null);
  	super.new(name, parent);
  endfunction : new
endclass : axi_driver_base
`endif