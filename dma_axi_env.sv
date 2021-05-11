`ifndef DMA_AXI_ENV_SV
`define DMA_AXI_ENV_SV
class dma_axi_env extends uvm_env;
  `uvm_component_utils(dma_axi_env)	
  virtual dma_axi_if intf;
  virtual dma_axi_config_if config_intf;

  dma_axi_master_agent master_agent;

  function new(string name="dma_axi_env", uvm_component par=null);
    super.new(name, par);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent = dma_axi_master_agent::type_id::create("master_agent", this);

    if (!uvm_config_db #(virtual dma_axi_if)::get(this, "", "intf_axi", intf))
      `uvm_fatal("DMA AXI ENV", "ERROR IN AXI INTERFACE CONFIG.");
    if (!uvm_config_db #(virtual dma_axi_config_if)::get(this, "", "intf_cof", config_intf))
      `uvm_fatal("DMA AXI ENV", "ERROR IN AXI INTERFACE(configuration) CONFIG.");
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase
endclass : dma_axi_env
`endif
