`ifndef AXI_SEQUENCE_BASE_SVH
`define AXI_SEQUENCE_BASE_SVH
class axi_sequence_base #(
  type BASE      = uvm_sequence,
  type SEQUENCER = uvm_sequencer
) extends BASE;
  `uvm_declare_p_sequencer(SEQUENCER)
  function new(string name="axi_sequence_base");
  	super.new(name);
  endfunction : new
endclass : axi_sequence_base
`endif