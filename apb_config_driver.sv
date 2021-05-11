`ifndef APB_CONFIG_DRIVER_SV
`define APB_CONFIG_DRIVER_SV
class apb_config_driver extends uvm_driver #(apb_item);
  `uvm_component_utils(apb_config_driver)
  dma_apb_config_vif intf;
  apb_item           item;

  uvm_analysis_port #(apb_item) apb_port_dr;

  function new(string name="apb_config_driver", uvm_component par=null);
  	super.new(name, par);
  endfunction : new

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);

  	assert(uvm_config_db#(dma_apb_config_vif)::get(this, "", "intf_cof", intf))
  	else `uvm_fatal(get_full_name(), "CONFIG FAILED AT APB CONFIG DRIVER.")

    apb_port_dr = new("apb_port_dr", this);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    bit [31:0] data;

  	intf.psel    <= 0;
  	intf.penable <= 0;
  	intf.pwrite  <= 0;
  	intf.paddr   <= 0;
  	intf.pwdata  <= 0;
  	forever begin
  	  seq_item_port.get_next_item(item);
  	  if (item.write) begin
  	    write_item(item.addr, item.data);
        if (item.addr == 32'h0 || item.addr == 32'h4) begin
          `uvm_info("APB DT", $sformatf("item.data %h", item.data), UVM_NONE)
          apb_port_dr.write(item);
        end
      end
  	  else begin
  	    read_item(item.addr, data);
  	  end	
  	  seq_item_port.item_done();
  	end
  endtask : run_phase

  task write_item(
  	input bit [31:0] addr,
  	input bit [31:0] data
  );
//    intf.pclken   <= 1;
//    #60;
    intf.paddr   <= addr;
    intf.pwdata  <= data;
    intf.pwrite  <= 1;
    intf.psel    <= 1;
    intf.pclken  <= 1;
    @(posedge intf.clk);
    intf.penable <= 1;
    
    repeat(4) begin
      @(posedge intf.clk);
    end

    intf.psel    <= 0;
    intf.penable <= 0;
    intf.paddr    <= 0;
    intf.pwdata    <= 0;
    //intf.pclken  <= 0;
  endtask : write_item

  task read_item(
    input  bit [31:0] addr,
    output bit [31:0] data
  );
    intf.paddr   <= addr;
    intf.pwrite  <= 0;
    intf.psel    <= 1;
    intf.pclken  <= 1;
    @(posedge intf.clk);
    intf.penable <= 1;
    @(posedge intf.clk);
    intf.psel    <= 0;
    intf.penable <= 0;
    intf.pclken  <= 0;
    data = intf.prdata;
  endtask : read_item
endclass : apb_config_driver
`endif