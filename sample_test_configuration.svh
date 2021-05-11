`ifndef SAMPLE_TEST_CONFIGURATION_SVH
`define SAMPLE_TEST_CONFIGURATION_SVH
class sample_test_configuration extends configuration_base;
  bit enable_request_start_delay;
  bit enable_write_data_delay;
  bit enable_response_start_delay;
  bit enable_response_delay;
  bit enable_ready_delay;
  rand dma_axi_configuration axi_cfg;

  constraint c_axi_basic {
    axi_cfg.protocol         == AXI3; ////
  	axi_cfg.id_width         == 1;
  	axi_cfg.address_width    == 32;
  	axi_cfg.max_burst_length == 16; ////
  	axi_cfg.data_width       == 32;
  	// qos
  }
  constraint c_request_start_delay {
  	if (enable_request_start_delay) {
      axi_cfg.request_start_delay.min_delay          == 0;
      axi_cfg.request_start_delay.max_delay          == 10;
      axi_cfg.request_start_delay.weight_zero_delay  == 6;
      axi_cfg.request_start_delay.weight_short_delay == 3;
      axi_cfg.request_start_delay.weight_long_delay  == 1;
  	}
  }
  constraint c_write_data_delay {
  	if (enable_write_data_delay) {
      axi_cfg.write_data_delay.min_delay          == 0;
      axi_cfg.write_data_delay.max_delay          == 10;
      axi_cfg.write_data_delay.weight_zero_delay  == 6;
      axi_cfg.write_data_delay.weight_short_delay == 3;
      axi_cfg.write_data_delay.weight_long_delay  == 1;
  	}
  }
///////////////////// RESPONSE DELAY
/*
  constraint c_response_weight {
  	axi_cfg.response_weight_okay         == 6;
  	axi_cfg.response_weight_exokay       == 2;
  	axi_cfg.response_weight_slave_error  == 1;
  	axi_cfg.response_weight_decode_error == 1;
  }
  constraint c_response_start_delay {
  	if (enable_response_start_delay) {
      axi_cfg.response_start_delay.min_delay          == 0;
      axi_cfg.response_start_delay.max_delay          == 10;
      axi_cfg.response_start_delay.weight_zero_delay  == 6;
      axi_cfg.response_start_delay.weight_short_delay == 3;
      axi_cfg.response_start_delay.weight_long_delay  == 1;
  	}
  }
  constraint c_response_delay {
  	if (enable_response_delay) {
      axi_cfg.response_delay.min_delay          == 0;
      axi_cfg.response_delay.max_delay          == 10;
      axi_cfg.response_delay.weight_zero_delay  == 6;
      axi_cfg.response_delay.weight_short_delay == 3;
      axi_cfg.response_delay.weight_long_delay  == 1;
  	}
  }
*/
/////////////////////
  constraint c_ready_delay {
    if (enable_ready_delay) {
///////////////////// RESPONSE DELAY
/*
      axi_cfg.awready_delay.min_delay          == 0;
      axi_cfg.awready_delay.max_delay          == 10;
      axi_cfg.awready_delay.weight_zero_delay  == 6;
      axi_cfg.awready_delay.weight_short_delay == 3;
      axi_cfg.awready_delay.weight_long_delay  == 1;

      axi_cfg.wready_delay.min_delay          == 0;
      axi_cfg.wready_delay.max_delay          == 10;
      axi_cfg.wready_delay.weight_zero_delay  == 6;
      axi_cfg.wready_delay.weight_short_delay == 3;
      axi_cfg.wready_delay.weight_long_delay  == 1;

      axi_cfg.arready_delay.min_delay          == 0;
      axi_cfg.arready_delay.max_delay          == 10;
      axi_cfg.arready_delay.weight_zero_delay  == 6;
      axi_cfg.arready_delay.weight_short_delay == 3;
      axi_cfg.arready_delay.weight_long_delay  == 1;
*/
/////////////////////
      axi_cfg.bready_delay.min_delay          == 0;
      axi_cfg.bready_delay.max_delay          == 10;
      axi_cfg.bready_delay.weight_zero_delay  == 6;
      axi_cfg.bready_delay.weight_short_delay == 3;
      axi_cfg.bready_delay.weight_long_delay  == 1;

      axi_cfg.rready_delay.min_delay          == 0;
      axi_cfg.rready_delay.max_delay          == 10;
      axi_cfg.rready_delay.weight_zero_delay  == 6;
      axi_cfg.rready_delay.weight_short_delay == 3;
      axi_cfg.rready_delay.weight_long_delay  == 1;
    }
  }

  function new(string name="sample_test_configuration");
  	super.new(name);
  	axi_cfg = dma_axi_configuration::type_id::create("axi_cfg");
  endfunction : new

  function void pre_randomize();
  	enable_request_start_delay = 1;
  	enable_write_data_delay = 1;
  	enable_response_delay = 1;
  	enable_response_start_delay = 1;
  	enable_ready_delay = 1;
  endfunction : pre_randomize

  `uvm_object_utils_begin(sample_test_configuration)
    `uvm_field_int(enable_write_data_delay, UVM_DEFAULT|UVM_BIN)
    `uvm_field_int(enable_response_start_delay, UVM_DEFAULT|UVM_BIN)
    `uvm_field_int(enable_response_delay, UVM_DEFAULT|UVM_BIN)
    `uvm_field_int(enable_ready_delay, UVM_DEFAULT|UVM_BIN)
    `uvm_field_object(axi_cfg, UVM_DEFAULT)
  `uvm_object_utils_end
endclass : sample_test_configuration
`endif