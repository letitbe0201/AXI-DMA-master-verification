`ifndef CONFIGURATION_BASE
`define CONFIGURATION_BASE
virtual class configuration_base extends uvm_object;
  function new(string name="configuration_base");
  	super.new(name);
  endfunction : new
endclass : configuration_base
`endif

`ifndef EMPTY_CONFIGURATION_SVH
`define EMPTY_CONFIGURATION_SVH
class empty_configuration extends uvm_object;
  `uvm_object_utils(empty_configuration)
  function new(string name="empty_configuration");
  	super.new(name);
  endfunction : new
endclass : empty_configuration
`endif