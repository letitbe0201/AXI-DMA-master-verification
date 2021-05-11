`ifndef SEQUENCE_ITEM_BASE_SVH
`define SEQUENCE_ITEM_BASE_SVH
class sequence_item_base #(
  type BASE                = uvm_sequence_item,
  type CONFIGURATION       = empty_configuration,
  type STATUS              = empty_status,
  type PROXY_CONFIGURATION = CONFIGURATION,
  type PROXY_STATUS        = STATUS
) extends object_base #(
  BASE, CONFIGURATION, STATUS
);
  typedef component_proxy_base #(
    PROXY_CONFIGURATION, PROXY_STATUS
  ) proxy;

  function void set_sequencer(uvm_sequencer_base sequencer);
  	proxy component_proxy;
  	super.set_sequencer(sequencer);
  	component_proxy = proxy::get(sequencer);
  	if (component_proxy != null) begin
  	  set_context(component_proxy.get_configuration(), component_proxy.get_status());
  	end
  endfunction : set_sequencer

  function uvm_event get_event(string name);
  	uvm_event_pool event_pool = get_event_pool();
  	return event_pool.get(name);
  endfunction : get_event

  function bit began();
  	uvm_event event_handle = get_event("begin");
  	return event_handle.is_on();
  endfunction : began

  function bit ended();
  	uvm_event event_handle = get_event("end");
  	return event_handle.is_on();
  endfunction : ended

  task wait_for_beginning(bit delta = 0);
  	uvm_event begin_event = get_event("begin");
  	begin_event.wait_on(delta);
  endtask : wait_for_beginning

  task wait_for_ending(bit delta = 0);
  	uvm_event begin_event = get_event("end");
  	begin_event.wait_on(delta);
  endtask : wait_for_ending

  function new(string name="sequence_item_base");
  	super.new(name);
  endfunction : new
endclass : sequence_item_base
`endif