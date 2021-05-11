`ifndef AXI_AGENT_BASE_SVH
`define AXI_AGENT_BASE_SVH
virtual class axi_agent_base #(
  type WRITE_MONITOR = uvm_monitor,
  type READ_MONITOR  = uvm_monitor,
  type SEQUENCER     = uvm_sequencer,
  type DRIVER        = uvm_driver
)extends component_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS(dma_axi_status),
  .BASE(uvm_agent)
);
  virtual function void active_agent();
  	is_active = UVM_ACTIVE;
  endfunction : active_agent
  virtual function void passive_agent();
  	is_active = UVM_PASSIVE;
  endfunction : passive_agent
  virtual function bit is_active_agent();
  	return (is_active == UVM_ACTIVE) ? 1 : 0;
  endfunction : is_active_agent
  virtual function bit is_passive_agent();
  	return (is_active == UVM_PASSIVE) ? 1 : 0;
  endfunction : is_passive_agent

  function void apply_config_settings(bit verbose=0);
  	super.apply_config_settings(verbose);
  	apply_agent_mode();
  endfunction : apply_config_settings
  protected virtual function void apply_agent_mode();
  endfunction : apply_agent_mode

  uvm_analysis_port #(axi_item) item_port;
  SEQUENCER                     sequencer;
  protected WRITE_MONITOR       write_monitor;
  protected READ_MONITOR        read_monitor;
  protected DRIVER              driver;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	item_port = new("item_port", this);
  	if (is_active_agent) begin
  	  sequencer = SEQUENCER::type_id::create("sequencer", this);
  	  sequencer.set_context(configuration, status);
  	end
  	write_monitor = WRITE_MONITOR::type_id::create("write_monitor", this);
  	write_monitor.set_context(configuration, status);
  	read_monitor  = READ_MONITOR::type_id::create("read_monitor", this);
  	read_monitor.set_context(configuration, status);
  	if (is_active_agent) begin
  	  driver = DRIVER::type_id::create("driver", this);
  	  driver.set_context(configuration, status);
  	end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
  	write_monitor.item_port.connect(item_port);
  	if (is_active_agent()) begin
  	  write_monitor.address_item_port.connect(sequencer.address_item_export);
  	  write_monitor.request_item_port.connect(sequencer.request_item_export);
  	  write_monitor.response_item_port.connect(sequencer.response_item_export);
  	  write_monitor.item_port.connect(sequencer.item_export);
    end
    read_monitor.item_port.connect(item_port);
  	if (is_active_agent()) begin
  	  read_monitor.address_item_port.connect(sequencer.address_item_export);
  	  read_monitor.request_item_port.connect(sequencer.request_item_export);
  	  read_monitor.response_item_port.connect(sequencer.response_item_export);
  	  read_monitor.item_port.connect(sequencer.item_export);
    end
    if (is_active_agent()) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end   
  endfunction : connect_phase

  function new(string name="axi_agent_base", uvm_component parent=null);
  	super.new(name, parent);
  endfunction : new 
endclass : axi_agent_base
`endif