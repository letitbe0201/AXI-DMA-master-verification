`ifndef REACTIVE_MONITOR_BASE_SVH
`define REACTIVE_MONITOR_BASE_SVH
virtual class reactive_monitor_base #(
  type CONFIGURATION = configuration_base,
  type STATUS        = status_base,
  type ITEM          = uvm_sequence_item,
  type ITEM_HANDLE   = ITEM,
  type REQUEST       = ITEM
) extends monitor_base #(
  CONFIGURATION, STATUS, ITEM, ITEM_HANDLE
);
  uvm_analysis_port #(REQUEST) request_port;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	request_port = new("request_port", this);
  endfunction : build_phase

  function void write_request(uvm_object request);
  	REQUEST r;
  	if ($cast(r, request)) begin
  	  request_port.write(r);
  	end
  	else begin
  	  `uvm_fatal(get_name(), "ERROR CASTING REQUEST OBJECT.")
  	end
  endfunction : write_request

  function new(string name, uvm_component par=null);
  	super.new(name, par);
  endfunction : new
endclass : reactive_monitor_base
`endif