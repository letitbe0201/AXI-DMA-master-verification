`ifndef APB_CONFIG_SEQUENCER_SV
`define APB_CONFIG_SEQUENCER_SV
class apb_config_sequencer extends uvm_sequencer #(apb_item);
  `uvm_component_utils(apb_config_sequencer)
  function new(string name="apb_config_sequencer", uvm_component par=null);
  	super.new(name, par);
  endfunction : new
endclass : apb_config_sequencer
`endif