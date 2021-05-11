`ifndef COMPONENT_BASE
`define COMPONENT_BASE
virtual class component_base #(
  type BASE = uvm_component,
  type CONFIGURATION = empty_configuration,
  type STATUS        = empty_status
)extends BASE;
  protected CONFIGURATION configuration;
  protected STATUS        status;

  function void apply_config_settings(bit verbose = 0);
  	super.apply_config_settings(verbose);
  	m_get_configuration();
    m_get_status();
  endfunction : apply_config_settings

  virtual function void set_configuration(configuration_base config);
  	if (!$cast(this.configuration, config)) begin
  	  `uvm_fatal(get_name(), "ERROR IN CASTING CONFIGURATION OBJECT!")
  	end
  endfunction : set_configuration

  virtual function CONFIGURATION get_configuration();
    return configuration;
  endfunction : get_configuration

  virtual function void set_status(status_base status);
    if (!$cast(this.status, status)) begin
      `uvm_fatal(get_name(), "Error in casting status object.")
    end
  endfunction : set_status

  virtual function STATUS get_status();
    return status;
  endfunction : get_status

  virtual function void set_context(configuration_base config, status_base status);
    set_configuration(config);
    set_status(status);
  endfunction : set_context

  virtual function void m_get_configuration();
    if (configuration != null) return;
    // todo:check_type
    void'(uvm_config_db#(CONFIGURATION)::get(this, "", "configuration", configuration));
    if (configuration == null) begin
      void'(uvm_config_db#(CONFIGURATION)::get(null, "", "configuration", configuration));
    end
    if (configuration == null) begin
      create_configuration();
    end
    if (configuration == null) begin
      `uvm_fatal(get_name(), "CONFIGURATION OBJECT FAILS!")
    end
  endfunction : m_get_configuration

  virtual protected function void create_configuration();
    return;
  endfunction : create_configuration

  virtual protected function void m_get_status();
    if(status != null) begin
      return;
    end
    void'(uvm_config_db#(STATUS)::get(this, "", "status", status));
    if (status == null) begin
      void'(uvm_config_db#(STATUS)::get(null, "", "status", status));
    end
    if (status == null) begin
      create_status();
    end
    if (status == null) begin
      `uvm_fatal(get_name(), "STATUS OBJECT FAILS!")
    end
  endfunction : m_get_status

  virtual protected function void create_status();
    status = STATUS::type_id::create("status");
  endfunction : create_status

  function new(string name="component_base", uvm_component parent=null);
  	super.new(name, parent);
  endfunction : new 
endclass : component_base
`endif