`ifndef MONITOR_BASE_SVH
`define MONITOR_BASE_SVH
class monitor_base #(
  type CONFIGURATION = empty_configuration,
  type STATUS        = empty_status,
  type ITEM          = uvm_sequence_item,
  type ITEM_HANDLE   = ITEM  
) extends component_base #(
  uvm_monitor, CONFIGURATION, STATUS
);
  uvm_analysis_port #(ITEM_HANDLE) item_port;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	item_port = new("item_port", this);
  endfunction : build_phase

  virtual function ITEM_HANDLE create_item(
    string item_name     = "item",
    string stream_name   = "main",
    string label         = "",
    string desc          = "",
    time   begin_time    = 0,
    int    parent_handel = 0
  );
  	ITEM item;
  	item = ITEM::type_id::create(item_name);
  	item.set_context(configuration, status);
  	void'(begin_tr(item, stream_name, label, desc, begin_time, parent_handel));
  	return item;
  endfunction : create_item

  virtual function void write_item(
    ITEM_HANDLE item,
    time        end_time=0,
    bit         free_handle=1
  );
    uvm_event_pool event_pool = item.get_event_pool();
    uvm_event      end_event  = event_pool.get("end");
    if (!end_event.is_on()) begin
      end_tr(item, end_time, free_handle);
    end
    item_port.write(item);
  endfunction : write_item

  function new(string name="monitor_base", uvm_component par=null);
    super.new(name, par);
  endfunction : new
endclass : monitor_base
`endif