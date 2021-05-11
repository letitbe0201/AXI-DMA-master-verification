`ifndef DMA_APB_REG_MODEL_SV
`define DMA_APB_REG_MODEL_SV
class dma_apb_reg_model extends uvm_reg_block;
  `uvm_object_utils(dma_apb_reg_model)
  rand rd_start_addr   reg_r_s_addr;
  rand wr_start_addr   reg_w_s_addr;
  rand set_buffer_size reg_set_buf_size;
  rand start_channel   reg_start_ch;
  rand cmd_reg3        cm_reg3;
  rand static_reg0     st_reg0;
  rand core0_joint_mode c0_joint_mode;

  function new(string name="");
    super.new(name, build_coverage(UVM_NO_COVERAGE));
  endfunction : new

  function void build();
  	reg_r_s_addr = rd_start_addr::type_id::create("reg_r_s_addr");
  	reg_r_s_addr.build();
  	reg_r_s_addr.configure(this);
  	reg_w_s_addr = wr_start_addr::type_id::create("reg_w_s_addr");
  	reg_w_s_addr.build();
  	reg_w_s_addr.configure(this);
  	reg_set_buf_size = set_buffer_size::type_id::create("reg_set_buf_size");
  	reg_set_buf_size.build();
  	reg_set_buf_size.configure(this);
  	reg_start_ch = start_channel::type_id::create("reg_start_ch");
  	reg_start_ch.build();
  	reg_start_ch.configure(this);
  	cm_reg3 = cmd_reg3::type_id::create("cm_reg3");
  	cm_reg3.build();
  	cm_reg3.configure(this);
  	st_reg0 = static_reg0::type_id::create("st_reg0");
  	st_reg0.build();
  	st_reg0.configure(this);
    c0_joint_mode = core0_joint_mode::type_id::create("c0_joint_mode");
    c0_joint_mode.build();
    c0_joint_mode.configure(this);

  	default_map = create_map("dma_axi_map", 0, 4, UVM_LITTLE_ENDIAN);
  	default_map.add_reg(reg_r_s_addr,     32'h00, "RW");
  	default_map.add_reg(reg_w_s_addr,     32'h04, "RW");
  	default_map.add_reg(reg_set_buf_size, 32'h08, "RW");
  	default_map.add_reg(cm_reg3,          32'h0C, "RW");
  	default_map.add_reg(st_reg0,          32'h10, "RW");
  	default_map.add_reg(reg_start_ch,     32'h44, "RW");
    default_map.add_reg(c0_joint_mode,    32'h1030, "RW");
  	lock_model();
  endfunction : build 
endclass : dma_apb_reg_model
`endif