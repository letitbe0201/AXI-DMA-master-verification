`ifndef APB_CONFIG_AGENT_SV
`define APB_CONFIG_AGENT_SV
class apb_config_agent extends uvm_agent;
  `uvm_component_utils(apb_config_agent)
  dma_apb_config_vif intf;

  apb_config_sequencer sqr;
  apb_config_driver    drv;

  uvm_analysis_port #(apb_item) apb_port_ag;

  function new(string name="apb_config_agent", uvm_component par=null);
  	super.new(name, par);
  endfunction : new

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);

  	sqr = apb_config_sequencer::type_id::create("sqr", this);
  	drv = apb_config_driver::type_id::create("drv", this);
  	assert(uvm_config_db#(dma_apb_config_vif)::get(this, "", "intf_cof", intf))
  	else `uvm_fatal(get_full_name(), "CONFIG FAILED AT APB CONFIG AGENT.")

  	uvm_config_db#(dma_apb_config_vif)::set(this, "drv", "intf_cof", intf);

    apb_port_ag = new("apb_port_ag", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
  	drv.seq_item_port.connect(sqr.seq_item_export);
    drv.apb_port_dr.connect(apb_port_ag);
  endfunction : connect_phase
endclass : apb_config_agent
`endif