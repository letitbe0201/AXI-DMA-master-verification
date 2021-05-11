`ifndef RAL_REG_SV
`define RAL_REG_SV
class rd_start_addr extends uvm_reg;
  `uvm_object_utils(rd_start_addr)
  rand uvm_reg_field r_s_addr;

  function new(string name="rd_start_addr");
  	super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
  	r_s_addr = uvm_reg_field::type_id::create("r_s_addr");
  	r_s_addr.configure(
  	  .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  endfunction : build
endclass : rd_start_addr


class wr_start_addr extends uvm_reg;
  `uvm_object_utils(wr_start_addr)
  rand uvm_reg_field w_s_addr;

  function new(string name="wr_start_addr");
  	super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
  	w_s_addr = uvm_reg_field::type_id::create("w_s_addr");
  	w_s_addr.configure(
  	  .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  endfunction : build
endclass : wr_start_addr


class set_buffer_size extends uvm_reg;
  `uvm_object_utils(set_buffer_size)
  rand uvm_reg_field buffer_size;

  function new(string name="set_buffer_size");
  	super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
  	buffer_size = uvm_reg_field::type_id::create("buffer_size");
  	buffer_size.configure(
  	  .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  endfunction : build
endclass : set_buffer_size


class cmd_reg3 extends uvm_reg;
  `uvm_object_utils(cmd_reg3)
  rand uvm_reg_field cmd_set_int;
  rand uvm_reg_field cmd_last;
  rand uvm_reg_field cmd_next_addr;

  function new(string name="cmd_reg3");
  	super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
  	cmd_set_int   = uvm_reg_field::type_id::create("cmd_set_int");
  	cmd_last      = uvm_reg_field::type_id::create("cmd_last");
  	cmd_next_addr = uvm_reg_field::type_id::create("cmd_next_addr");
  	cmd_set_int.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	cmd_last.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	cmd_next_addr.configure(
  	  .parent(this),
      .size(28),
      .lsb_pos(4),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  endfunction : build
endclass : cmd_reg3


class static_reg0 extends uvm_reg;
  `uvm_object_utils(static_reg0)
  rand uvm_reg_field rd_burst_max_size;
  rand uvm_reg_field rd_allow_full_burst;
  rand uvm_reg_field rd_allow_full_fifo;
  rand uvm_reg_field rd_tokens;
  rand uvm_reg_field rd_outs_max;
  rand uvm_reg_field rd_outstanding;
  rand uvm_reg_field rd_incr;

  function new(string name="static_reg0");
  	super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
  	rd_burst_max_size   = uvm_reg_field::type_id::create("rd_burst_max_size");
  	rd_allow_full_burst = uvm_reg_field::type_id::create("rd_allow_full_burst");
  	rd_allow_full_fifo  = uvm_reg_field::type_id::create("rd_allow_full_fifo");
  	rd_tokens           = uvm_reg_field::type_id::create("rd_tokens");
  	rd_outs_max         = uvm_reg_field::type_id::create("rd_outs_max");
  	rd_outstanding      = uvm_reg_field::type_id::create("rd_outstanding");
  	rd_incr             = uvm_reg_field::type_id::create("rd_incr");
  	rd_burst_max_size.configure(
  	  .parent(this),
      .size(10),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	rd_allow_full_burst.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(12),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	rd_allow_full_fifo.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(13),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	rd_tokens.configure(
  	  .parent(this),
      .size(6),
      .lsb_pos(16),
      .access("RW"),
      .volatile(0),
      .reset('h1),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	rd_outs_max.configure(
  	  .parent(this),
      .size(4),
      .lsb_pos(24),
      .access("RW"),
      .volatile(0),
      .reset('h4),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	rd_outstanding.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(30),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  	rd_incr.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(31),
      .access("RW"),
      .volatile(0),
      .reset('h1),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  endfunction : build
endclass : static_reg0


class start_channel extends uvm_reg;
  `uvm_object_utils(start_channel)
  rand uvm_reg_field ch_start;

  function new(string name="start_channel");
  	super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
  	ch_start = uvm_reg_field::type_id::create("ch_start");
  	ch_start.configure(
  	  .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
  	);
  endfunction : build
endclass : start_channel


class core0_joint_mode extends uvm_reg;
  `uvm_object_utils(core0_joint_mode)
  rand uvm_reg_field joint_mode;

  function new(string name="core0_joint_mode");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  function void build();
    joint_mode = uvm_reg_field::type_id::create("joint_mode");
    joint_mode.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(0)
    );
  endfunction : build
endclass : core0_joint_mode
`endif