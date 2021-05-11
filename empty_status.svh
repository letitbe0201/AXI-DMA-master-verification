`ifndef EMPTY_STATUS_SVH
`define EMPTY_STATUS_SVH
virtual class status_base extends uvm_object;
  function new(string name="status_base");
  	super.new(name);
  endfunction : new
endclass : status_base

class empty_status extends status_base;
  function new(string name="empty_status");
  	super.new(name);
  endfunction : new

  `uvm_object_utils(empty_status)
endclass : empty_status
`endif