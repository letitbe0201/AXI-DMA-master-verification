`ifndef AXI_PAYLOAD_SVH
`define AXI_PAYLOAD_SVH
class axi_payload;
        axi_item     item;
  local axi_data     data[$];
  local axi_strobe   strobe[$];
  local axi_response response[$];

  static function axi_payload create(axi_item item);
  	axi_payload payload_store = new;
  	payload_store.item = item;
  	return payload_store;
  endfunction : create

  function void store_write_data(axi_data data, axi_strobe strobe);
  	if (item.is_write()) begin
  	  this.data.push_back(data);
  	  this.strobe.push_back(strobe);
  	end
  endfunction : store_write_data

  function void store_response(axi_response response, axi_data data);
  	this.response.push_back(response);
  	if (item.is_read()) begin
  	  this.data.push_back(data);
  	end
  endfunction : store_response

  function void pack_write_data();
  	item.put_data(data);
  	item.put_strobe(strobe);
  endfunction : pack_write_data

  function void pack_response();
  	item.put_response(response);
  	if (item.is_read()) begin
  	  item.put_data(data);
  	end
  endfunction : pack_response

  function int get_stored_write_data_count();
  	if (item.is_write())
  	  return data.size();
  	else
  	  return 0;
  endfunction : get_stored_write_data_count

  function int get_stored_response_count();
    return response.size();
  endfunction : get_stored_response_count
endclass : axi_payload
`endif