`ifndef DMA_AXI_SLAVE_AGENT_SV
`define DMA_AXI_SLAVE_AGENT_SV
typedef axi_agent_base #(
  .WRITE_MONITOR(dma_axi_slave_write_monitor),
  .READ_MONITOR(dma_axi_slave_read_monitor),
  .SEQUENCER(dma_axi_slave_sequencer),
  .DRIVER(dma_axi_slave_driver)
) dma_axi_slave_agent_base;

class dma_axi_slave_agent extends dma_axi_slave_agent_base;
  dma_axi_slave_data_monitor data_monitor;
  `uvm_component_utils(dma_axi_slave_agent)

  uvm_analysis_port #(axi_item) sb_port_ag;
  
  function new(string name="dma_axi_slave_agent", uvm_component par=null);
    super.new(name, par);	
  endfunction : new

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	data_monitor = dma_axi_slave_data_monitor::type_id::create("data_monitor", this);
    data_monitor.set_context(configuration, status);

    sb_port_ag = new("sb_port_ag", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
  	write_monitor.request_item_port.connect(data_monitor.analysis_export);
  	if (is_active_agent()) begin
  	  write_monitor.request_port.connect(sequencer.request_export);
  	  read_monitor.request_port.connect(sequencer.request_export);

      write_monitor.sb_port_monitor.connect(sb_port_ag);
      read_monitor.sb_port_monitor.connect(sb_port_ag);
  	end
  endfunction : connect_phase
endclass : dma_axi_slave_agent
`endif