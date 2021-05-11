`ifndef DMA_AXI_CONFIGURATION_SVH
`define DMA_AXI_CONFIGURATION_SVH
class dma_axi_configuration extends configuration_base;
  dma_axi_vif vif;
  rand axi_protocol protocol;
  rand int id_width;
  rand int address_width;
  rand int max_burst_length;
  rand int data_width;
  rand int strobe_width;
  rand int response_weight_okay;
  rand int response_weight_exokay;
  rand int response_weight_slave_error;
  rand int response_weight_decode_error;
  rand delay_configuration request_start_delay;
  rand delay_configuration write_data_delay;
  rand delay_configuration response_start_delay;
  rand delay_configuration response_delay;
  rand bit                 default_awready;
  rand delay_configuration awready_delay;
  rand bit                 default_wready;
  rand delay_configuration wready_delay;
  rand bit                 default_bready;
  rand delay_configuration bready_delay;
  rand bit                 default_arready;
  rand delay_configuration arready_delay;
  rand bit                 default_rready;
  rand delay_configuration rready_delay;
  rand bit                 reset_by_agent;

  constraint c_default_protocol {
  	soft protocol == AXI4LITE;
  }

  constraint c_valid_id_width {
  	id_width inside {[0 : `AXI_MAX_ID_WIDTH]}; ////
  }

  constraint c_default_id_width {
  	solve protocol before id_width;
  	if (protocol == AXI4LITE)
  	  soft id_width == 0; ////
  }

  constraint c_valid_address_width {
  	address_width inside {[1 : `AXI_MAX_ADDRESS_WIDTH]};
  }

  constraint c_valid_max_burst_length {
    solve protocol before max_burst_length;
  	max_burst_length inside {[1:16]};
  	if (protocol==AXI4LITE) {
  	  max_burst_length == 1;
  	}
  }

  constraint c_valid_data_width {
    solve protocol before data_width;
  	data_width inside {8, 16, 32};
  	if (protocol == AXI4LITE) {
  	  data_width == 32;
  	}
  }

  constraint c_valid_strobe_width {
  	solve data_width before strobe_width;
  	strobe_width == (data_width/8);
  }

  constraint c_valide_response_weight {
  	response_weight_okay         >= -1;
  	response_weight_exokay       >= -1;
  	response_weight_slave_error  >= -1;
  	response_weight_decode_error >= -1;
  }
  constraint c_default_response_weight {
  	soft response_weight_okay         == -1;
  	soft response_weight_exokay       == -1;
  	soft response_weight_slave_error  == -1;
  	soft response_weight_decode_error == -1;
  }

  constraint c_default_reset_by_agent {
  	soft reset_by_agent == 1;
  }

//  `uvm_object_utils(dma_axi_configuration)
  function new(string name="dma_axi_configuration");
    super.new(name);
    request_start_delay  = delay_configuration::type_id::create("request_start_delay");
    write_data_delay     = delay_configuration::type_id::create("write_data_delay");
    response_start_delay = delay_configuration::type_id::create("response_start_delay");
    response_delay       = delay_configuration::type_id::create("response_delay");
    awready_delay        = delay_configuration::type_id::create("awready_delay");
    wready_delay         = delay_configuration::type_id::create("wready_delay");
    bready_delay         = delay_configuration::type_id::create("bready_delay");
    arready_delay        = delay_configuration::type_id::create("arready_delay");
    rready_delay         = delay_configuration::type_id::create("rready_delay");
  endfunction : new

  function void post_randomize();
  	super.post_randomize();
    response_weight_okay         = (response_weight_okay        >=0) ? response_weight_okay         : 1;
    response_weight_exokay       = (response_weight_exokay      >=0) ? response_weight_exokay       : 0;
    response_weight_slave_error  = (response_weight_slave_error >=0) ? response_weight_slave_error  : 0;
    response_weight_decode_error = (response_weight_decode_error>=0) ? response_weight_decode_error : 0;
  endfunction : post_randomize

  `uvm_object_utils_begin(dma_axi_configuration)
    `uvm_field_enum(axi_protocol, protocol, UVM_DEFAULT)
    `uvm_field_int(id_width, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(address_width, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(max_burst_length, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(data_width, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(strobe_width, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(response_weight_okay, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(response_weight_exokay, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(response_weight_slave_error, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(response_weight_decode_error, UVM_DEFAULT | UVM_DEC)
    `uvm_field_object(request_start_delay, UVM_DEFAULT)
    `uvm_field_object(write_data_delay, UVM_DEFAULT)
    `uvm_field_object(response_start_delay, UVM_DEFAULT)
    `uvm_field_object(response_delay, UVM_DEFAULT)
    `uvm_field_int(default_awready, UVM_DEFAULT | UVM_BIN)
    `uvm_field_object(awready_delay, UVM_DEFAULT)
    `uvm_field_int(default_wready, UVM_DEFAULT | UVM_BIN)
    `uvm_field_object(wready_delay, UVM_DEFAULT)
    `uvm_field_int(default_bready, UVM_DEFAULT | UVM_BIN)
    `uvm_field_object(bready_delay, UVM_DEFAULT)
    `uvm_field_int(default_arready, UVM_DEFAULT | UVM_BIN)
    `uvm_field_object(arready_delay, UVM_DEFAULT)
    `uvm_field_int(default_rready, UVM_DEFAULT | UVM_BIN)
    `uvm_field_object(rready_delay, UVM_DEFAULT)
    `uvm_field_int(reset_by_agent, UVM_DEFAULT | UVM_BIN)
  `uvm_object_utils_end
endclass : dma_axi_configuration
`endif