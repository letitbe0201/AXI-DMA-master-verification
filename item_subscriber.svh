`ifndef ITEM_SUBSCRIBER_SVH
`define ITEM_SUBSCRIBER_SVH
class item_subscriber #(
  type ITEM = uvm_sequence_item,
  type ID   = int
) extends uvm_subscriber #(ITEM);
protected uvm_event bufs[$];
protected uvm_event id_bufs[ID][$];

  function void write(ITEM t);
    ID id;
    foreach(bufs[i]) begin
      bufs[i].trigger(t);
    end
    bufs.delete();
    id = get_id_from_item(t);
    if (!id_bufs.exists(id)) begin
    	return;
    end
    foreach(id_bufs[id][i]) begin
    	id_bufs[id][i].trigger(t);
    end
    id_bufs.delete(id);
  endfunction : write

  virtual task get_item(ref ITEM item);
    uvm_event x;
    x = get_buf();
    wait_for_trigger(x, item);
  endtask : get_item
  virtual task get_item_by_id(ref ITEM item, input ID id);
    uvm_event y = get_id_buf(id);
  	wait_for_trigger(y, item);
  endtask : get_item_by_id

  protected virtual function ID get_id_from_item(ITEM item);
    ID id;
    return id;
  endfunction : get_id_from_item

  protected function uvm_event get_buf();
  	uvm_event z = new();
  	bufs.push_back(z);
  	return z;
  endfunction : get_buf
  protected function uvm_event get_id_buf(ID id);
  	uvm_event u = new();
  	id_bufs[id].push_back(u);
  	return u;
  endfunction : get_id_buf

  protected task wait_for_trigger(input uvm_event ev, ref ITEM item);
  	ev.wait_on();
  	void'($cast(item, ev.get_trigger_data()));
  endtask : wait_for_trigger

  function new(string name="item_subscriber", uvm_component parent=null);
  	super.new(name, parent);
  endfunction : new 
endclass : item_subscriber
`endif