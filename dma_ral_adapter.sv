`ifndef DMA_RAL_ADAPTER_SV
`define DMA_RAL_ADAPTER_SV
class dma_ral_adapter extends uvm_reg_adapter;
  `uvm_object_utils(dma_ral_adapter)

  function new(string name="dma_ral_adapter");
  	super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_item item;
    item = apb_item::type_id::create("item");

    item.write = (rw.kind==UVM_WRITE) ? 1 : 0;
    item.addr  = rw.addr;
    item.data  = rw.data;
    //`ifdef NEED_DEBUG
      `uvm_info("ADAPTER", $sformatf("reg2bus addr=0x%0h data=0x%0h kind=%s", item.addr, item.data, rw.kind.name()), UVM_DEBUG)
    //`endif
    return item;
  endfunction : reg2bus


  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  	apb_item item;

  	assert($cast(item, bus_item))
  	else `uvm_fatal("[RAL ADAPTER]", "ERROR OCCURS WHEN CASTING BUS ITEM.")

  	rw.kind   = item.write ? UVM_WRITE : UVM_READ;
    rw.addr   = item.addr;
    rw.data   = item.data;
//    rw.status = get_status(item);
    //`ifdef NEED_DEBUG
      `uvm_info("ADAPTER", $sformatf("bus2reg addr=0x%0h data=0x%0h kind=%s status=%s", rw.addr, rw.data, rw.kind.name(), rw.status.name()), UVM_DEBUG)
    //`endif
  endfunction : bus2reg
endclass : dma_ral_adapter
`endif