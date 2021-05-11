`ifndef DMA_AXI_PKG_SV
`define DMA_AXI_PKG_SV
  `include "axi_data_types_pkg.sv"
  `include "dma_axi_if.sv"
  `include "dma_apb_config_if.sv"

  package dma_axi_pkg;
    import uvm_pkg::*;
    import axi_data_types_pkg::*;

    `include "uvm_macros.svh"

    typedef virtual dma_axi_if        dma_axi_vif;
    typedef virtual dma_apb_config_if dma_apb_config_vif;

    `include "empty_configuration.svh"
    `include "empty_status.svh"
    `include "delay_configuration.svh"
    `include "dma_axi_configuration.svh"
    `include "dma_axi_status.svh"
    `include "component_proxy.svh"

    `include "object_base.svh"
    `include "sequence_item_base.svh"
    `include "axi_item.svh"
    `include "axi_payload.svh"
    `include "component_base.svh"
    
    `include "axi_component_base.svh"
    `include "item_subscriber.svh"
    `include "sequencer_base.svh"
    `include "axi_sequencer_base.svh"
    `include "dma_axi_master_sequencer.sv"

    `include "dma_axi_slave_sequencer.svh"

    `include "sequence_base.svh"
    `include "axi_sequence_base.svh"
    `include "dma_axi_master_sequence_base.sv"
    `include "dma_axi_master_access_sequence.sv"
    `include "dma_axi_master_read_sequence.sv"
    `include "dma_axi_master_write_sequence.sv"

    `include "dma_axi_slave_sequence_base.svh"
    `include "dma_axi_slave_default_sequence.sv"

    `include "axi_driver_base.svh"
    `include "dma_axi_master_driver.sv"
    `include "dma_axi_slave_driver.sv"

    `include "memory_base.svh"
    `include "dma_axi_memory.svh"

    `include "monitor_base.svh"
    `include "reactive_monitor_base.svh"
    `include "axi_monitor_base.svh"

    `include "dma_axi_slave_monitor.sv"
    `include "dma_axi_slave_data_monitor.sv"
    `include "dma_axi_master_monitor.sv"

    `include "apb_item.svh"
    `include "scoreboard_base.sv"
    `include "dma_axi_sb.sv"

    `include "axi_agent_base.svh"
    `include "dma_axi_master_agent.sv"
    `include "dma_axi_slave_agent.sv"
  endpackage : dma_axi_pkg
`endif
