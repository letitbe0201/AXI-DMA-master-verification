`ifndef AXI_COMPONENT_BASE_SVH
`define AXI_COMPONENT_BASE_SVH
virtual class axi_component_base #(
  type BASE = uvm_component
) extends BASE;
  protected bit write_component;
  protected dma_axi_vif vif;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
  	vif = configuration.vif; ///////
  endfunction : build_phase

  protected function bit is_write_component();
  	return write_component;
  endfunction : is_write_component
  protected function bit is_read_component();
  	return !write_component;
  endfunction : is_read_component

  virtual task begin_address(axi_item item);
  	if (!item.write_data_began()) begin
  	  void'(begin_tr(item));
  	end
  	item.begin_address();
  endtask : begin_address
  virtual task end_address(axi_item item);
  	item.end_address();
  endtask : end_address

  virtual task begin_write_data(axi_item item);
  	if (item.is_write()) begin
  	  if (!item.address_began()) begin
        void'(begin_tr(item));
  	  end
  	  item.begin_write_data();
  	end
  endtask : begin_write_data
  virtual task end_write_data(axi_item item);
  	if (item.is_write()) begin
  	  item.end_write_data();
  	end
  endtask : end_write_data

  virtual task begin_response(axi_item item);
  	item.begin_response();
  endtask : begin_response
  virtual task end_response(axi_item item);
    item.end_response();
    end_tr(item);
  endtask : end_response

  protected function bit get_address_valid();
  	return (write_component) ? vif.monitor_cb.awvalid : vif.monitor_cb.arvalid;
  endfunction : get_address_valid
  protected function bit get_address_ready();
  	return (write_component) ? vif.monitor_cb.awready : vif.monitor_cb.arready;
  endfunction : get_address_ready
  protected function bit get_address_ack();
  	return (write_component) ? vif.monitor_cb.awack : vif.monitor_cb.arack;
  endfunction : get_address_ack
  protected function bit get_write_data_valid();
  	return (write_component) ? vif.monitor_cb.wvalid : '0;
  endfunction : get_write_data_valid
  protected function bit get_write_data_ready();
  	return (write_component) ? vif.monitor_cb.wready : '0;
  endfunction : get_write_data_ready
  protected function bit get_write_data_ack();
  	return (write_component) ? vif.monitor_cb.wack : '0;
  endfunction : get_write_data_ack
  protected function bit get_response_valid();
  	return (write_component) ? vif.monitor_cb.bvalid : vif.monitor_cb.rvalid;
  endfunction : get_response_valid
  protected function bit get_response_ready();
  	return (write_component) ? vif.monitor_cb.bready : vif.monitor_cb.rready;
  endfunction : get_response_ready
  protected function bit get_response_ack();
  	return (write_component) ? vif.monitor_cb.back : vif.monitor_cb.rack;
  endfunction : get_response_ack
  
  protected function axi_id get_address_id();
    if (configuration.id_width > 0) begin
      return (write_component) ? vif.monitor_cb.awid : vif.monitor_cb.arid;
    end
    else begin
      return 0;
    end
  endfunction : get_address_id

  protected function axi_address get_address();
  	return (write_component) ? vif.monitor_cb.awaddr : vif.monitor_cb.araddr;
  endfunction : get_address

  protected function int get_burst_length();
  	if (configuration.protocol == AXI4LITE)
  	  return 1;
  	else begin
  	  axi_burst_length bl;
  	  bl = (write_component) ? vif.monitor_cb.awlen : vif.monitor_cb.arlen;
  	  return unpack_bl(bl);
  	end
  endfunction : get_burst_length

  protected function int get_burst_size();
  	if (configuration.protocol == AXI4LITE)
  	  return configuration.data_width / 8;
  	else begin
  	  axi_burst_size bs;
  	  bs = (write_component) ? vif.monitor_cb.awsize : vif.monitor_cb.arsize;
  	  return get_bs(bs);
  	end
  endfunction : get_burst_size

  protected function axi_data get_write_data();
  	return (write_component) ? vif.monitor_cb.wdata : '0;
  endfunction : get_write_data

  protected function axi_strobe get_strobe();
  	return (write_component) ? vif.monitor_cb.wstrb : '0;
  endfunction : get_strobe

  protected function bit get_write_data_last();
  	if (configuration.protocol == AXI4LITE)
  	  return (write_component) ? 1 : '0;
  	else
  	  return (write_component) ? vif.monitor_cb.wlast : '0;
  endfunction : get_write_data_last

  protected function axi_id get_response_id();
  	if(configuration.id_width > 0)
  		return (write_component) ? vif.monitor_cb.bid : vif.monitor_cb.rid;
  	else
  		return 0;
  endfunction : get_response_id

  protected function axi_response get_response();
  	return (write_component) ? vif.monitor_cb.bresp : vif.monitor_cb.rresp;
  endfunction : get_response

  protected function axi_data get_read_data();
  	return (write_component) ? '0 : vif.monitor_cb.rdata;
  endfunction : get_read_data

  protected function bit get_response_last();
  	if (configuration.protocol == AXI4LITE)
  	  return '1;
  	else
  	  return (write_component) ? '1 : vif.monitor_cb.rlast;
  endfunction : get_response_last

  function new(string name="axi_component_base", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new
endclass : axi_component_base
`endif