`ifndef DMA_AXI_SLAVE_DEFAULT_SEQUENCE_SV
`define DMA_AXI_SLAVE_DEFAULT_SEQUENCE_SV
class dma_axi_slave_default_sequence extends dma_axi_slave_sequence_base;
  protected axi_slave_item context_item[axi_access_type];

  task body();
  	fork
  		process_response_request(AXI_WRITE);
  		process_response_request(AXI_READ);
  	join
  endtask : body

  protected task process_response_request(axi_access_type access_type);
  	forever begin
  	  axi_slave_item item;
  	  get_request(access_type, item);
  	  randomize_response(access_type, item);
      /////////////// test
//     `uvm_info("SEQ", $sformatf("ADDR RD DELAY %d", item.address_ready_delay), UVM_NONE)
      /////////////// test
  	  execute_response(item);
  	end
  endtask : process_response_request

  protected virtual function void randomize_response(
    axi_access_type access_type,
    axi_slave_item item
  );
    bit               read_access;
    int               response_size;
    int               address_ready_delay;
    int               write_data_ready_delay[$];
    int               response_start_delay;
    int               response_delay[$];
    axi_response response[$];
    bit               response_existance[$];
    axi_data     read_data[$];
    bit               read_data_existance[$];

    context_item[access_type] = item;
    read_access               = item.is_read();
    response_size             = (read_access) ? item.burst_length : 1;
    address_ready_delay       = get_address_ready_delay(access_type);
    response_start_delay      = get_response_start_delay(access_type);

    if (item.is_write()) begin
      for (int i=0; i<item.burst_length; i++) begin
        write_data_ready_delay.push_back(get_write_data_ready_delay(access_type, i));
      end
    end
    for (int i=0; i<response_size; i++) begin
      response.push_back(get_response_status(access_type, i));
      response_existance.push_back(get_response_existence(access_type, i));
      response_delay.push_back(get_response_delay(access_type, i));
      if (item.is_read()) begin
      	read_data.push_back(get_read_data(i));
      	read_data_existance.push_back(get_read_data_existence(i));
      end
    end
    // local: bind to the local scope of resolution, logal::address_ready_delay depends on get_address_ready delay()
    if (!item.randomize() with{
      if (local::address_ready_delay >= 0) {
        address_ready_delay == local::address_ready_delay;
      }
      foreach (write_data_ready_delay[i]) {
        if (local::write_data_ready_delay[i] >= 0) {
          write_data_ready_delay[i] == local::write_data_ready_delay[i];
        }
      }
      if (local::response_start_delay >= 0) {
        response_start_delay == local::response_start_delay;
      }
      foreach (response_delay[i]) {
        if (local::response_delay[i] >= 0) {
          response_delay[i] == local::response_delay[i];
        }
      }
      foreach (response[i]) {
        if (local::response_existance[i]) {
          response[i] == local::response[i];
        }
      }
      if (local::read_access) {
        foreach (data[i]) {
          if (local::read_data_existance[i]) {
            data[i] == local::read_data[i];
          }
        }
      }
    }) begin
      `uvm_fatal("RNDFLD", "Randomization failed in Slave Default Sequence.")
    end
  endfunction : randomize_response
  
  protected virtual task execute_response(axi_slave_item item);
  	fork
  		automatic axi_slave_item __item = item;
  		`uvm_send(__item); //`uvm_do without create and randonmization
  	join_none
  endtask : execute_response

  protected virtual function int get_address_ready_delay(axi_access_type access_type);
    return -1;
    //return 8;
  endfunction

  protected virtual function int get_write_data_ready_delay(axi_access_type access_type, int index);
    return -1;
  endfunction

  protected virtual function int get_response_start_delay(axi_access_type access_type);
    return -1;
  endfunction

  protected virtual function int get_response_delay(axi_access_type access_type, int index);
    return -1;
  endfunction

  protected virtual function axi_response get_response_status(axi_access_type access_type, int index);
    return AXI_OKAY;
  endfunction

  protected virtual function bit get_response_existence(axi_access_type access_type, int index);
    return 0;
  endfunction

  protected virtual function axi_data get_read_data(int index);
    axi_slave_item item  = context_item[AXI_READ];
    return status.memory.get(item.burst_size, item.address, index);
  endfunction

  protected virtual function bit get_read_data_existence(int index);
    axi_slave_item item  = context_item[AXI_READ];
    return status.memory.exists(item.burst_size, item.address, index);
  endfunction

  function new(string name="dma_axi_slave_default_sequence");
  	super.new(name);
  endfunction : new

  `uvm_object_utils(dma_axi_slave_default_sequence)
endclass : dma_axi_slave_default_sequence
`endif