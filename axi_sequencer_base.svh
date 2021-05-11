`ifndef AXI_SEQUENCER_BASE_SVH
`define AXI_SEQUENCER_BASE_SVH
/*AXI ITEM SUBSCRIBER*/
class axi_item_subscriber extends item_subscriber #(
  .ITEM(axi_item),
  .ID  (axi_id)
);
  protected function axi_id get_id_from_item(axi_item item);
  	return item.id;
  endfunction : get_id_from_item
  function new(string name="axi_item_subscriber", uvm_component par=null);
  	super.new(name, par);
  endfunction : new
endclass : axi_item_subscriber
/*AXI ITEM SUBSCRIBER*/

/*AXI SEQUENCER BASE*/
class axi_sequencer_base #(
  type BASE = uvm_sequencer
)extends BASE;
  uvm_analysis_export #(axi_item) address_item_export;
  uvm_analysis_export #(axi_item) request_item_export;
  uvm_analysis_export #(axi_item) response_item_export;
  uvm_analysis_export #(axi_item) item_export;
  protected axi_item_subscriber address_item_subscriber;
  protected axi_item_subscriber request_item_subscriber;
  protected axi_item_subscriber response_item_subscriber;
  protected axi_item_subscriber item_subscriber;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	address_item_export      = new("address_item_export", this);
  	address_item_subscriber  = new("address_item_subscriber", this);
   	request_item_export      = new("request_item_export", this);
  	request_item_subscriber  = new("request_item_subscriber", this);
  	response_item_export     = new("response_item_export", this);
  	response_item_subscriber = new("response_item_subscriber", this);
   	item_export              = new("item_export", this);
  	item_subscriber          = new("item_subscriber", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
  	address_item_export.connect(address_item_subscriber.analysis_export);
  	request_item_export.connect(request_item_subscriber.analysis_export);
  	response_item_export.connect(response_item_subscriber.analysis_export);
  	item_export.connect(item_subscriber.analysis_export);
  endfunction : connect_phase

  virtual task get_address_item(ref axi_item item);
  	address_item_subscriber.get_item(item);
  endtask : get_address_item
  virtual task get_address_item_by_id(ref axi_item item, input axi_id id);
  	address_item_subscriber.get_item_by_id(item, id);
  endtask : get_address_item_by_id
  virtual task get_request_item(ref axi_item item);
  	request_item_subscriber.get_item(item);
  endtask : get_request_item
  virtual task get_request_item_by_id(ref axi_item item, input axi_id id);
  	request_item_subscriber.get_item_by_id(item, id);
  endtask : get_request_item_by_id
  virtual task get_response_item(ref axi_item item);
  	response_item_subscriber.get_item(item);
  endtask : get_response_item
  virtual task get_response_item_by_id(ref axi_item item, input axi_id id);
  	response_item_subscriber.get_item_by_id(item, id);
  endtask : get_response_item_by_id
  virtual task get_item(ref axi_item item);
  	item_subscriber.get_item(item);
  endtask : get_item
  virtual task get_item_by_id(ref axi_item item, input axi_id id);
  	item_subscriber.get_item_by_id(item, id);
  endtask : get_item_by_id

  function new(string name="axi_sequencer_base", uvm_component par=null);
  	super.new(name, par);
  endfunction : new
endclass : axi_sequencer_base
/*AXI SEQUENCER BASE*/
`endif