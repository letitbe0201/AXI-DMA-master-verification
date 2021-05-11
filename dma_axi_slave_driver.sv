`ifndef DMA_AXI_SLAVE_DRIVER_SV
`define DMA_AXI_SLAVE_DRIVER_SV
/*AXI SLAVE RESPONSE ITEM*/
class axi_slave_response_item;
  axi_item item;
  int      start_delay;
  int      delay;
  int      transfer_size;
  int      index;

  function new(axi_item item);
    this.item        = item;
    this.start_delay = start_delay;
    this.delay       = -1;
  endfunction : new

  function axi_id get_id();
  	return item.id;
  endfunction : get_id
  function axi_response get_response();
   	return item.response[index];
  endfunction : get_response  
  function axi_data get_data();
  	return item.data[index];
  endfunction : get_data
  function bit get_last();
  	return is_last_response(1);
  endfunction : get_last

  function void count_delay();
    if (start_delay > 0) begin
      start_delay = start_delay - 1;
    end
    else begin
      if (delay < 0) begin
        delay = item.response_delay[index];
      end
      if (delay > 0) begin
        delay = delay - 1;
      end
    end
  endfunction : count_delay

  function void next();
    delay         = delay         - 1;
    transfer_size = transfer_size - 1;
    index         = index         + 1;
  endfunction : next

  function bit is_drivable();
    return (start_delay==0) && (delay==0);
  endfunction : is_drivable 

  function bit is_last_response(bit before_next);
  	if (item.access_type == AXI_WRITE) begin
  	  return 1;
  	end
  	else if (before_next) begin
  	  return (index == (item.burst_length-1));
  	end
  	else begin
  	  return (index == item.burst_length);
  	end
  endfunction : is_last_response

  function bit is_end_response(bit before_next);
    if (item.access_type == AXI_WRITE) begin
      return 1;
    end
    else if (before_next) begin
      return (transfer_size == 1);
    end
    else begin
      return (transfer_size == 0);
    end
  endfunction : is_end_response
endclass : axi_slave_response_item
/*AXI SLAVE RESPONSE ITEM*/

/*AXI SLAVE SUB DRIVER*/
typedef axi_sub_driver_base #(
  .ITEM(axi_slave_item)
) dma_axi_slave_sub_driver_base;

class dma_axi_slave_sub_driver extends axi_component_base #(
  .BASE(dma_axi_slave_sub_driver_base)
);
  protected bit                     address_busy;
  protected bit                     default_address_ready;
  protected bit                     default_ready[2];
  protected int                     ready_delay_queue[2][$];
  protected int                     ready_delay[2];
  protected int                     preceding_writes;
  protected axi_item                response_queue[axi_id][$];
  protected axi_slave_response_item response_items[axi_id];
  protected axi_id                  active_ids[axi_id];
  protected axi_slave_response_item current_response;
  protected bit                     response_busy;  

  task run_phase(uvm_phase phase);
    forever @(vif.slave_cb or negedge vif.rst) begin
      if (!vif.rst) begin
        do_reset();
      end
      else begin

        // Clean out Response data
        if ((current_response!=null) && get_response_ack()) begin // Get BACK/RACK
          response_busy = 0;
          finish_response();
        end

        // Count Address delay & Drive READY signal
        if ((!address_busy) && get_address_valid()) begin // Get ARVALID/AWVALID
          address_busy = 1;
          update_ready_delay_queue(); // ARREADY /AWREADY
        end
        if (address_busy && get_address_ready()) begin
          address_busy = 0;
        end
        drive_address_channel();

     
        if (is_write_component()) begin
          drive_write_data_channel(); // Drive WREADY
        end

        manage_response_buffer(); // Get Response from item buffer, put it into response_items[] and active_ids[]
        if ((current_response==null) && (response_items.size()>0)) begin
          get_next_response_item(); // Get current Response
        end
        drive_response_channel(); // Drive actual Response Bx/Rx
      end
    end
  endtask : run_phase

  protected task do_reset();
    foreach (item_buffer[i]) begin
      end_tr(item_buffer[i]);
    end

    foreach (response_queue[i, j]) begin
      if (!response_queue[i][j].ended()) begin 
        end_tr(response_queue[i][j]);
      end
    end

    foreach(response_items[i]) begin
      if (!response_items[i].item.ended()) begin
        end_tr(response_items[i].item);
      end
    end

    address_busy     = 0;
    ready_delay      = '{-1, -1};
    current_response = null;
    response_busy    = 0;
    preceding_writes = 0;
    item_buffer.delete();
    ready_delay_queue[0].delete();
    ready_delay_queue[1].delete();
    response_queue.delete();
    response_items.delete();
    active_ids.delete();

    if (configuration.reset_by_agent) begin
      reset_if();
    end
  endtask : do_reset
  
  protected virtual task reset_if();
  endtask : reset_if

  protected task finish_response(); // Execute after BACK/RACK
    current_response.next();
    if (current_response.is_end_response(0)) begin
      if (current_response.is_last_response(0)) begin
        remove_response_item();
      end
      current_response = null;
    end
  endtask : finish_response

  protected task remove_response_item();
    axi_id id;
    id = current_response.item.id;
    
    response_items.delete(id);
    active_ids.delete(id);
    end_response(current_response.item);
  endtask : remove_response_item

  protected task update_ready_delay_queue(); // Update Address Ready / Write data Ready
    axi_item item;
    int      length;

    uvm_wait_for_nba_region(); // Wait for other process to settle out
    if (item_buffer.size() > 0) begin
      if (item_buffer[$].address_begin_time == $time) begin
        item = item_buffer[$];
      end
    end
      
    if (item != null) begin
      ready_delay_queue[0].push_back(item.address_ready_delay);
    end
    else if (is_write_component()) begin            // AWREADY
      ready_delay_queue[0].push_back(
        randomize_delay(configuration.awready_delay)
      );
    end
    else begin
      ready_delay_queue[0].push_back(               // ARREADY
        randomize_delay(configuration.arready_delay)
      );
    end

    if (is_read_component()) begin
      return;
    end

    length = (item!=null) ? item.burst_length : get_burst_length();
    for (int i=0; i<length; i++) begin
      if (preceding_writes > 0) begin
        preceding_writes = preceding_writes - 1;
      end
      else if (item != null) begin                 // WREADY
        ready_delay_queue[1].push_back(item.write_data_ready_delay[i]);
      end
      else begin
        ready_delay_queue[1].push_back(randomize_delay(configuration.wready_delay));
      end
    end
  endtask : update_ready_delay_queue

  protected function int randomize_delay(delay_configuration delay_configuration);
    int delay;
    if (std::randomize(delay) with{
      `delay_constraint(delay, delay_configuration)
    }) begin
      return delay;
    end
    else begin
      `uvm_fatal("RNDFLD", "Randomization in slave driver failed.")
    end
  endfunction : randomize_delay

  protected task drive_address_channel(); // Count address delay & Drive READY signal
    bit address_ready;

    if (ready_delay[0] < 0) begin
      ready_delay[0] = ready_delay_queue[0].pop_front();
    end

    address_ready = ((default_ready[0]==1)&&(ready_delay[0]<=0)) || // AWREADY/ARREADY
                    ((default_ready[0]==0)&&(ready_delay[0]==0));
    drive_address_ready(address_ready);

    if (ready_delay[0] >= 0) begin
      ready_delay[0] = ready_delay[0] - 1;
    end
  endtask : drive_address_channel

  protected virtual task drive_address_ready(bit address_ready);
  endtask : drive_address_ready

  protected task drive_write_data_channel();
    bit pop_ready_delay;
    bit write_data_ready;

    pop_ready_delay = (ready_delay[1]<0) && (get_write_data_valid()) && (get_write_data_ready()==default_ready[1]);
    if (pop_ready_delay) begin
      if (ready_delay_queue[1].size() > 0) begin
        ready_delay[1] = ready_delay_queue[1].pop_front();
      end
      else begin
        ready_delay[1] = randomize_delay(configuration.wready_delay);
        preceding_writes = preceding_writes + 1;
      end
    end

    write_data_ready = ((default_ready[1]==1) && (ready_delay[1]<=0)) ||
                       ((default_ready[1]==0) && (ready_delay[1]==0));
    drive_write_data_ready(write_data_ready); // Drive WREADY

    if (ready_delay[1] >= 0) begin
      ready_delay[1] = ready_delay[1] - 1;
    end
  endtask : drive_write_data_channel

  protected virtual task drive_write_data_ready(bit write_data_ready);
  endtask : drive_write_data_ready

  protected task manage_response_buffer();
    while (item_buffer.size() > 0) begin
      axi_item item;
      item = item_buffer.pop_front();
      accept_tr(item); // upon return from a get_next_item(), get(), or peek() call on its sequencer port
      response_queue[item.id].push_back(item);
    end

    foreach(response_queue[i]) begin
      if (response_queue[i].size() == 0) begin
        continue;
      end
      else if (!response_queue[i][0].request_ended()) begin
        continue;
      end
      else if (response_items.exists(i)) begin
        continue;
      end
      response_items[i] = new(response_queue[i].pop_front());
      active_ids[i] = i;
    end
  endtask : manage_response_buffer

  protected task get_next_response_item();
    axi_id key;
    axi_slave_response_item item;

    if (!std::randomize(key) with {key inside {active_ids};}) begin
      `uvm_fatal("RNDFLD", "Randomization in slave driver failed.")
    end

    item = response_items[key];
    item.transfer_size = get_transfer_size(item);
    current_response = item;
  endtask : get_next_response_item

  protected function int get_transfer_size(axi_slave_response_item item);
    if (is_write_component()) begin
      return 1;
    end
    else if (configuration.protocol == AXI4LITE) begin
      return 1;
    end
    else begin
      return randomize_transfer_size(item);
    end
  endfunction : get_transfer_size

  protected function int randomize_transfer_size(axi_slave_response_item item);
    int transfer_size;
    int remaining;

    remaining = item.item.burst_length - item.index;
    if (std::randomize(transfer_size) with {
      transfer_size inside {[1:remaining]};
    }) begin
      return transfer_size;
    end
    else begin
      `uvm_fatal("RNDFLD", "Randomization failed in slave driver.")
    end
  endfunction : randomize_transfer_size

  protected task drive_response_channel();
    bit valid;
    int index;

    valid = 0;
    if (current_response != null) begin
      current_response.count_delay();
      valid = current_response.is_drivable();
    end

    if (valid && (!response_busy)) begin
      response_busy = 1;
      begin_response(current_response.item);
      drive_active_response(); // Drive Bx/Rx on interface
    end
    else if (!valid) begin
      drive_idle_response();
    end
  endtask : drive_response_channel

  task begin_response(axi_item item);
    super.begin_response(item);
    void'(begin_tr(item)); // BEGIN UVM_SEQ TRANSACTION
  endtask : begin_response

  protected virtual task drive_active_response();
  endtask : drive_active_response

  protected virtual task drive_idle_response();
  endtask : drive_idle_response

  function new(string name="dma_axi_slave_sub_driver", uvm_component par=null);
    super.new(name, par);
  endfunction : new
endclass : dma_axi_slave_sub_driver
/*AXI SLAVE SUB DRIVER*/

/*AXI SLAVE WRITE DRIVER*/
class dma_axi_slave_write_driver extends dma_axi_slave_sub_driver;
  function new(string name="dma_axi_slave_write_driver", uvm_component par=null);
    super.new(name, par);
    write_component = 1;
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    default_ready[0] = configuration.default_awready;
    default_ready[1] = configuration.default_wready;
  endfunction : build_phase

  protected task reset_if();
    vif.awready = default_ready[0];
    vif.wready  = default_ready[1];
    vif.bvalid  = 0;
    vif.bid     = 0;
    vif.bresp   = AXI_OKAY;
  endtask : reset_if

  protected task drive_address_ready(bit address_ready);
    vif.slave_cb.awready  <= address_ready;
  endtask : drive_address_ready

  protected task drive_write_data_ready(bit write_data_ready);
    vif.slave_cb.wready <= write_data_ready;
  endtask 

  protected task drive_active_response();
    vif.slave_cb.bvalid <= 1;
    vif.slave_cb.bid    <= current_response.get_id();
    vif.slave_cb.bresp  <= current_response.get_response();
  endtask : drive_active_response

  protected task drive_idle_response();
    vif.slave_cb.bvalid <= 0;
    vif.slave_cb.bid    <= 0;
    vif.slave_cb.bresp  <= AXI_OKAY;
  endtask : drive_idle_response

  `uvm_component_utils(dma_axi_slave_write_driver)
endclass : dma_axi_slave_write_driver
/*AXI SLAVE WRITE DRIVER*/

/*AXI SLAVE READ DRIVER*/
class dma_axi_slave_read_driver extends dma_axi_slave_sub_driver;
  function new(string name="dma_axi_slave_sub_driver", uvm_component par=null);
    super.new(name, par);
    write_component = 0;
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    default_ready[0] = configuration.default_arready;
  endfunction : build_phase

  protected task reset_if();
    vif.arready = default_address_ready;
    vif.rvalid  = 0;
    vif.rid     = 0;
    vif.rdata   = 0;
    vif.rresp   = AXI_OKAY;
    vif.rlast   = 0;
  endtask : reset_if

  protected task drive_address_ready(bit address_ready);
    vif.slave_cb.arready <= address_ready;
  endtask : drive_address_ready

  protected task drive_write_data_ready(bit write_data_ready);
  endtask

  protected task drive_active_response();
    vif.slave_cb.rvalid <= 1;
    vif.slave_cb.rid    <= current_response.get_id();
    vif.slave_cb.rdata  <= current_response.get_data();
    vif.slave_cb.rresp  <= current_response.get_response();
    vif.slave_cb.rlast  <= current_response.get_last();
  endtask

  protected task drive_idle_response();
    vif.slave_cb.rvalid <= 0;
    vif.slave_cb.rid    <= 0;
    vif.slave_cb.rdata  <= 0;
    vif.slave_cb.rresp  <= AXI_OKAY;
    vif.slave_cb.rlast  <= 0;
  endtask

  `uvm_component_utils(dma_axi_slave_read_driver)
endclass : dma_axi_slave_read_driver
/*AXI SLAVE READ DRIVER*/

/*AXI SLAVE DRIVER*/
class dma_axi_slave_driver extends axi_driver_base #(
  .ITEM        (axi_slave_item),
  .WRITE_DRIVER(dma_axi_slave_write_driver),
  .READ_DRIVER (dma_axi_slave_read_driver)
);
  function new(string name="dma_axi_slave_driver", uvm_component par=null);
    super.new(name, par);
  endfunction : new

  `uvm_component_utils(dma_axi_slave_driver)
endclass : dma_axi_slave_driver
/*AXI SLAVE DRIVER*/
`endif