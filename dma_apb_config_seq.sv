`ifndef DMA_APB_CONFIG_SEQ_SV
`define DMA_APB_CONFIG_SEQ_SV
class dma_apb_config_seq extends uvm_sequence;
  `uvm_object_utils(dma_apb_config_seq)
  dma_apb_reg_model regmodel;

  function new(string name="");
  	super.new(name);
  endfunction : new

  task body();
  	uvm_status_e status;
  	uvm_reg_data_t incoming;
  	bit [31:0] read_data;

  	if(starting_phase != null)
  	  starting_phase.raise_objection(this);

  	// WRITE  TO REG
    regmodel.c0_joint_mode.write(status,    32'h0000_0001); // Core0 Joint Mode
  	regmodel.st_reg0.write(status, 32'b10000100000000100000000000100000); // Rd max burst size: 32  /
  	regmodel.reg_r_s_addr.write(status,     32'h0003_0000); // Rd start addr [31:0]
  	regmodel.reg_w_s_addr.write(status,     32'h0006_0000); // Wr start addr [31:0]
  	regmodel.reg_set_buf_size.write(status, 32'd256);        // Set buf size [15:0]
    regmodel.cm_reg3.write(status, 32'h0008_0020); // cmd_next_addr/cmd_last/cmd_interrupt
  	regmodel.reg_start_ch.write(status,     32'h0000_0001); // Ch START
  	// READ FROM REG
//  	regmodel.reg_r_s_addr.read(status,     read_data);
//  	regmodel.reg_w_s_addr.read(status,     read_data);
//  	regmodel.reg_set_buf_size.read(status, read_data);
//  	regmodel.reg_start_ch.read(status,     read_data);
//    `uvm_info(get_full_name(), $sformatf("RDATA %b", read_data), UVM_NONE) ///////////
  	if(starting_phase != null)
  	  starting_phase.drop_objection(this);
  endtask : body
endclass : dma_apb_config_seq

/* RESET SEQUENCE
class reset_sequence extends uvm_sequence;
  dma_apb_config_vif intf;
  `uvm_object_utils(reset_sequence)
  function new(string name="reset_sequence");
  	super.new(name);
  endfunction : new

  task body();
  	assert(uvm_config_db#(dma_apb_config_vif)::get(null, "*", "intf_cof", intf))
  	else `uvm_fatal(get_full_name(), "CONFIG FAILS IN RESET SEQUENCE.")

  	`uvm_info("[RESET SEQUENCE]", "RUNNING RESET...", UVM_NONE)
    intf.reset <= 0;
    repeat(10) begin
      @(posedge intf.clk) intf.reset <= 1;
    end
    intf.reset <= 0;
  endtask : body
endclass : reset_sequence
*/
`endif