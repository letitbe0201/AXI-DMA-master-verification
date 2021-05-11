`ifndef OBJECT_BASE_SVH
`define OBJECT_BASE_SVH
virtual class object_base #(
  type BASE          = uvm_object,
  type CONFIGURATION = empty_configuration,
  type STATUS        = empty_status
) extends BASE;

  protected CONFIGURATION configuration;
  protected STATUS        status;

  virtual function void set_configuration(configuration_base configuration);
    if (!$cast(this.configuration, configuration)) begin
      `uvm_fatal(get_name(), "ERROR IN CASTING CONFIGURATION OBJECT!")
    end
  endfunction : set_configuration
  virtual function CONFIGURATION get_configuration();
    return configuration;
  endfunction : get_configuration

  virtual function void set_status(status_base status);
    if (!$cast(this.status, status)) begin
      `uvm_fatal(get_name(), "ERROR IN CASTING STATUS OBJECT.")
    end
  endfunction : set_status

  virtual function STATUS get_status();
    return status;
  endfunction : get_status

  virtual function void set_context(configuration_base configuration, status_base status);
    set_configuration(configuration);
    set_status(status);
  endfunction : set_context

  function new(string name="object_base");
    super.new(name);
  endfunction : new
  `uvm_field_utils_begin(object_base #(BASE, CONFIGURATION, STATUS))
    `uvm_field_object(configuration, UVM_REFERENCE|UVM_PACK|UVM_NOCOMPARE|UVM_NOPRINT|UVM_NORECORD)
    `uvm_field_object(status, UVM_REFERENCE|UVM_PACK|UVM_NOCOMPARE|UVM_NOPRINT|UVM_NORECORD)
  `uvm_field_utils_end
  endclass : object_base
`endif