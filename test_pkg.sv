`ifndef TEST_PKG_SV
`define TEST_PKG_SV
package test_pkg;
  import uvm_pkg::*;
  import axi_data_types_pkg::*;
  import dma_axi_pkg::*;

  `include "uvm_macros.svh"
  `include "tue_sequence_defines.svh"

  `include "apb_item.svh"
  `include "ral_reg.sv"
  `include "dma_apb_reg_model.sv"
  `include "dma_ral_adapter.sv"
  `include "dma_apb_config_seq.sv"

  `include "apb_config_sequencer.sv"
  `include "apb_config_driver.sv"
  `include "apb_config_agent.sv"

  `include "sample_test_configuration.svh"
  `include "sample_test_read_write_sequence.sv"
  `include "sample_test.sv"
endpackage
`endif