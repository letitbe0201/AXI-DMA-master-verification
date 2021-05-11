`ifndef AXI_ITEM_SVH
`define AXI_ITEM_SVH
/*AXI ITEM*/
class axi_item extends sequence_item_base #(
  .CONFIGURATION(dma_axi_configuration),
  .STATUS(dma_axi_status)
);
//  dma_axi_configuration configuration;

  rand axi_access_type access_type;
  rand axi_id          id;
  rand axi_address     address;
  rand int             burst_length;
  rand int             burst_size;
  rand axi_data        data[];
  rand axi_strobe      strobe[];
  rand axi_response    response[];

  rand int             start_delay;
  rand int             write_data_delay[];
  rand int             response_delay[];
  rand int             address_ready_delay;
  rand int             write_data_ready_delay[];
  rand int             response_ready_delay[];
    
  uvm_event            address_begin_event;
  time                 address_begin_time;
  uvm_event            address_end_event;
  time                 address_end_time;
  uvm_event            write_data_begin_event;
  time                 write_data_begin_time;
  uvm_event            write_data_end_event;
  time                 write_data_end_time;
  uvm_event            response_begin_event;
  time                 response_begin_time;
  uvm_event            response_end_event;
  time                 response_end_time;

  rand bit             need_response;  

  // Event handler
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
  task wait_for_begin(bit x=0);
    uvm_event begin_event = get_event("begin");
    begin_event.wait_on(x);
  endtask : wait_for_begin
  task wait_for_end(bit y=0);
    uvm_event end_event = get_event("end");
    end_event.wait_on(y);
  endtask : wait_for_end

//  `uvm_object_utils(axi_item)
  function new(string name="axi_item");
    super.new(name);
    address_begin_event =    get_event("address_begin");
    address_end_event =      get_event("address_end");
    write_data_begin_event = get_event("write_data_begin");
    write_data_end_event =   get_event("write_data_end");
    response_begin_event =   get_event("response_begin");
    response_end_event =     get_event("response_end");
  endfunction : new

  function bit is_write();
    return (access_type == AXI_WRITE) ? 1'b1 : 1'b0;
  endfunction : is_write
  function bit is_read();
    return (access_type == AXI_READ) ? 1'b1 : 1'b0;
  endfunction : is_read

  function int get_burst_length();
    if ((configuration!=null) && (configuration.protocol==AXI4LITE))
      return 1;
    else
      return burst_length;
  endfunction : get_burst_length
  function axi_burst_length get_packed_burst_length();
    return pack_bl(get_burst_length());
  endfunction : get_packed_burst_length
  function void set_packed_burst_length(axi_burst_length packed_bl);
    if ((configuration!=null) && (configuration.protocol==AXI4LITE))
      burst_length = 1;
    else
      burst_length = unpack_bl(packed_bl);    
  endfunction : set_packed_burst_length

  function int get_burst_size();
    if ((configuration!=null) && (configuration.protocol==AXI4LITE))
      return configuration.data_width/8;
    else
      return burst_size;
  endfunction : get_burst_size
  function axi_burst_size get_packed_burst_size();
    case (get_burst_size())
      8:       return 2'b00;
      16:      return 2'b01;
      32:      return 2'b10;
      64:      return 2'b11;
      default: return 2'b00;
    endcase
  endfunction : get_packed_burst_size
  function void set_packed_burst_size(axi_burst_size packed_bs);
    if ((configuration!=null) && (configuration.protocol==AXI4LITE))
      burst_size = configuration.data_width/8;
    else
      burst_size = get_bs(packed_bs);
  endfunction : set_packed_burst_size
  // Assign data
  function void put_data(const ref axi_data data[$]);
    this.data = new[data.size()];
    foreach (data[i]) begin
      this.data[i] = data[i];
    end
  endfunction : put_data
  function axi_data get_data(int index);
    if (index < data.size()) begin
      return data[index];
    end
    else
      return '0;
  endfunction : get_data
  // Assign strobe
  function void put_strobe(const ref axi_strobe strobe[$]);
    this.strobe = new[strobe.size()];
    foreach (strobe[i]) begin
      this.strobe[i] = strobe[i];
    end
  endfunction : put_strobe
  function axi_strobe get_strobe (int index);
    if (index < strobe.size())
      return strobe[index];
    else
      return '0;
  endfunction : get_strobe
  // Assign response
  function void put_response(const ref axi_response response[$]);
    this.response = new[response.size()];
    foreach (response[i]) begin
      this.response[i] = response[i];
    end
  endfunction : put_response
  function axi_response get_response(int index);
    if (index < response.size())
      return response[index];
    else
      return AXI_OKAY;
  endfunction : get_response

  /*Event Control*/
  // Address event control
  function void begin_address (time begin_time=0);
    if (address_begin_event.is_off()) begin
      address_begin_time = (begin_time<=0) ? $time : begin_time;
      address_begin_event.trigger();
    end
  endfunction : begin_address
  function void end_address (time end_time=0);
    if (address_end_event.is_off()) begin
      address_end_time = (end_time<=0) ? $time : end_time;
      address_end_event.trigger();
    end
  endfunction : end_address
  function bit address_began();
    return address_begin_event.is_on();
  endfunction : address_began
  function bit address_ended();
    return address_end_event.is_on();
  endfunction : address_ended
  // Write data event control
  function void begin_write_data (time begin_time=0);
    if (write_data_begin_event.is_off()) begin
      write_data_begin_time = (begin_time<=0) ? $time : begin_time;
      write_data_begin_event.trigger();
    end
  endfunction : begin_write_data
  function void end_write_data (time end_time=0);
    if (write_data_end_event.is_off()) begin
      write_data_end_time = (end_time<=0) ? $time : end_time;
      write_data_end_event.trigger();
    end
  endfunction : end_write_data
  function bit write_data_began();
    return write_data_begin_event.is_on();
  endfunction : write_data_began
  function bit write_data_ended();
    return write_data_end_event.is_on();
  endfunction : write_data_ended
  // Response event control
  function void begin_response (time begin_time=0);
    if (response_begin_event.is_off()) begin
      response_begin_time = (begin_time<=0) ? $time : begin_time;
      response_begin_event.trigger();
    end
  endfunction : begin_response
  function void end_response (time end_time=0);
    if (response_end_event.is_off()) begin
      response_end_time = (end_time<=0) ? $time : end_time;
      response_end_event.trigger();
    end
  endfunction : end_response
  function bit response_began();
    return response_begin_event.is_on();
  endfunction : response_began
  function bit response_ended();
    return response_end_event.is_on();
  endfunction : response_ended

  function bit request_began();
    return address_began();
  endfunction : request_began
  function bit request_ended();
    if (is_write()) begin
      return (address_ended() && write_data_ended()) ? 1 : 0;
    end
    else begin
      return address_ended();
    end
  endfunction : request_ended

  task wait_for_done();
    response_end_event.wait_on();
  endtask : wait_for_done
  /*Event Control*/

  `uvm_object_utils_begin(axi_item)
//    `uvm_field_object(configuration, UVM_REFERENCE|UVM_PACK|UVM_NOCOMPARE|UVM_NOPRINT|UVM_NORECORD)
    `uvm_field_int(id, UVM_DEFAULT|UVM_HEX)
    `uvm_field_enum(axi_access_type, access_type, UVM_DEFAULT)
    `uvm_field_int(address, UVM_DEFAULT|UVM_HEX)
    `uvm_field_int(burst_length, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(burst_size, UVM_DEFAULT|UVM_DEC)
    `uvm_field_array_int(data, UVM_DEFAULT|UVM_HEX)
    `uvm_field_array_int(strobe, UVM_DEFAULT|UVM_HEX)
    `uvm_field_array_enum(axi_response, response, UVM_DEFAULT)
    `uvm_field_int(start_delay, UVM_DEFAULT|UVM_DEC|UVM_NOCOMPARE)
    `uvm_field_array_int(write_data_delay, UVM_DEFAULT|UVM_DEC|UVM_NOCOMPARE)
    `uvm_field_array_int(response_delay, UVM_DEFAULT|UVM_DEC|UVM_NOCOMPARE)
    `uvm_field_int(address_ready_delay, UVM_DEFAULT|UVM_DEC|UVM_NOCOMPARE)
    `uvm_field_array_int(write_data_ready_delay, UVM_DEFAULT|UVM_DEC|UVM_NOCOMPARE)
    `uvm_field_array_int(response_ready_delay, UVM_DEFAULT|UVM_DEC|UVM_NOCOMPARE)
    `uvm_field_int(address_begin_time, UVM_DEFAULT|UVM_TIME|UVM_NOCOMPARE)
    `uvm_field_int(address_end_time, UVM_DEFAULT|UVM_TIME|UVM_NOCOMPARE)
    `uvm_field_int(write_data_begin_time, UVM_DEFAULT|UVM_TIME|UVM_NOCOMPARE)
    `uvm_field_int(write_data_end_time, UVM_DEFAULT|UVM_TIME|UVM_NOCOMPARE)
    `uvm_field_int(response_begin_time, UVM_DEFAULT|UVM_TIME|UVM_NOCOMPARE)
    `uvm_field_int(response_end_time, UVM_DEFAULT|UVM_TIME|UVM_NOCOMPARE)
    `uvm_field_int(need_response, UVM_DEFAULT|UVM_NOCOMPARE|UVM_NOPRINT)
  `uvm_object_utils_end
endclass : axi_item
/*AXI ITEM*/

/*AXI MASTER ITEM*/
class axi_master_item extends axi_item;
  constraint c_valid_id {
    (id >> this.configuration.id_width) == 0;
  }

  constraint c_valid_address {
    (address >> this.configuration.address_width) == 0;
  }

  constraint c_valid_burst_length {
    if (this.configuration.protocol == AXI4LITE)
      burst_length == 1;
    else
      burst_length inside {[1 : this.configuration.max_burst_length]};
  }

  constraint c_valid_burst_size {
    if (this.configuration.protocol == AXI4LITE) {
      (8*burst_size) == this.configuration.data_width;
    }
    else {
      burst_size inside {1, 2, 4};
      (8*burst_size) <= this.configuration.data_width;
    }
  }

  // 4kb boundary

  constraint c_valid_data {
    solve access_type  before data;
    solve burst_length before data;
    (access_type==AXI_WRITE) -> data.size()==burst_length;
    (access_type==AXI_READ)  -> data.size()==0;
    foreach(data[i]) {
      (data[i] >> this.configuration.data_width) == 0;
    }
  }

  constraint c_valid_strobe {
    solve access_type  before strobe;
    solve burst_length before strobe;
    (access_type==AXI_WRITE) -> strobe.size()==burst_length;
    (access_type==AXI_READ)  -> strobe.size()==0;
    foreach(strobe[i]) {
      (strobe[i] >> this.configuration.strobe_width) == 0;
    }
  }

  constraint c_start_delay {
    `delay_constraint(start_delay, this.configuration.request_start_delay)
  }

  constraint c_write_data_delay {
    solve access_type, burst_length before write_data_delay;
    if (access_type==AXI_WRITE)
      write_data_delay.size() == burst_length;
    else
      write_data_delay.size() == 0;

    foreach(write_data_delay[i]) {
      `delay_constraint(write_data_delay[i], this.configuration.write_data_delay)
    }
  }

  constraint c_response_ready_delay {
    solve access_type, burst_length before response_ready_delay;
    if (access_type == AXI_WRITE) {
      response_ready_delay.size() == 1;
    }
    else {
      response_ready_delay.size() == burst_length;
    }
    foreach(response_ready_delay[i]) {
      if (access_type == AXI_WRITE) {
        `delay_constraint(response_ready_delay[i], this.configuration.bready_delay)
      }
      else {
        `delay_constraint(response_ready_delay[i], this.configuration.rready_delay)
      }
    }
  }

  constraint c_default_need_response {
    soft need_response == 0;
  }

  function void pre_randomize();
    super.pre_randomize();
    response.rand_mode(0);
    response_delay.rand_mode(0);
    address_ready_delay.rand_mode(0);
    write_data_ready_delay.rand_mode(0);
    //test
/*    access_type.rand_mode(0);
    id.rand_mode(0);
    address.rand_mode(0);
    burst_length.rand_mode(0);
    burst_size.rand_mode(0);
    data.rand_mode(0);
    strobe.rand_mode(0);
    response.rand_mode(0);

    start_delay.rand_mode(0);
    write_data_delay.rand_mode(0);
*/    //test
  endfunction : pre_randomize

  `uvm_object_utils(axi_master_item)
  function new(string name="axi_master_item");
    super.new(name);
  endfunction : new
endclass : axi_master_item
/*AXI MASTER ITEM*/

/*AXI SLAVE ITEM*/
class axi_slave_item extends axi_item;
  constraint c_valid_data {
    data.size() == burst_length;
    foreach(data[i]) {
      (data[i]>>this.configuration.data_width) == 0;
    }
  }

  constraint c_valid_response {
    (access_type == AXI_WRITE) -> response.size()==1;
    (access_type == AXI_READ)  -> response.size()==burst_length;
    foreach(response[i]) {
      response[i] dist{
        AXI_OKAY         := this.configuration.response_weight_okay,
        AXI_EXOKAY       := this.configuration.response_weight_exokay,
        AXI_SLAVE_ERROR  := this.configuration.response_weight_slave_error,
        AXI_DECODE_ERROR := this.configuration.response_weight_decode_error
      };
    }
  }

  constraint c_address_ready_delay {
    if (access_type == AXI_WRITE) {
      `delay_constraint(address_ready_delay, this.configuration.awready_delay)
    }
    else {
      `delay_constraint(address_ready_delay, this.configuration.arready_delay)
    }
  }

  constraint c_write_data_ready_delay {
    if (access_type == AXI_WRITE) {
      write_data_ready_delay.size() == burst_length;
    }
    else {
      write_data_ready_delay.size() == 0;
    }
    foreach(write_data_ready_delay[i]) {
      `delay_constraint(write_data_ready_delay[i], this.configuration.wready_delay)
    }
  }

  constraint c_start_delay {
    `delay_constraint(start_delay, this.configuration.response_start_delay)
  }

  constraint c_response_delay {
    if (access_type == AXI_WRITE)
      response_delay.size() == 1;
    else
      response_delay.size() == burst_length;
    foreach(response_delay[i]) {
      `delay_constraint(response_delay[i], this.configuration.response_delay)
    }
  }

  constraint c_default_need_response {
    soft need_response == 1;
  }

  function void pre_randomize ();
    super.pre_randomize();
    access_type.rand_mode(0);
    id.rand_mode(0);
    address.rand_mode(0);
    burst_length.rand_mode(0);
    burst_size.rand_mode(0);
    //burst_type.rand_mode(0);
    if (access_type == AXI_WRITE) begin
      data.rand_mode(0);
      c_valid_data.constraint_mode(0);
    end
    strobe.rand_mode(0);
    write_data_delay.rand_mode(0);
    response_ready_delay.rand_mode(0);
  endfunction : pre_randomize

  `uvm_object_utils(axi_slave_item)
  function new(string name="axi_slave_item");
    super.new(name);
  endfunction : new
endclass : axi_slave_item
/*AXI SLAVE ITEM*/
`endif
