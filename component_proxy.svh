`ifndef COMPONENT_PROXY_SVH
`define COMPONENT_PROXY_SVH
const string NAME_OF_COMPONENT_PROXY = "proxy";

/*COMPONENT PROXY BASE*/
virtual class component_proxy_base #(
  type CONFIGURATION = empty_configuration,
  type STATUS        = empty_status
) extends uvm_component;
  typedef component_proxy_base #(CONFIGURATION, STATUS) this_type;

  static function this_type get(uvm_component component);
  	this_type component_proxy;
  	if (component == null) begin
  	  return null;
  	end
  	if (!component.has_child(NAME_OF_COMPONENT_PROXY)) begin
  	  return null;
  	end
  	if (!$cast(component_proxy, component.get_child(NAME_OF_COMPONENT_PROXY))) begin
  	  return null;
  	end
  	return component_proxy;
  endfunction : get

  pure virtual function void set_configuration(configuration_base config);
  pure virtual function CONFIGURATION get_configuration();
  pure virtual function void set_status(status_base status);
  pure virtual function STATUS get_status();
  pure virtual function void set_context(configuration_base configuration, status_base status);

  function new(string name="component_proxy_base", uvm_component par=null);
  	super.new(name, par);
  endfunction : new
endclass : component_proxy_base
/*COMPONENT PROXY BASE*/

/*COMPONENT PROXY*/
class component_proxy #(
  type COMPONENT = uvm_component,
  type CONFIGURATION = empty_configuration,
  type STATUS        = empty_status
) extends component_proxy_base #(CONFIGURATION, STATUS);
  typedef component_proxy #(COMPONENT, CONFIGURATION, STATUS) this_type;
  local COMPONENT component;

  static function this_type create_component_proxy(COMPONENT component);
  	this_type comp_proxy;
  	comp_proxy = new(NAME_OF_COMPONENT_PROXY, component);
  	return comp_proxy;
  endfunction : create_component_proxy

  function new(string name="component_proxy", uvm_component par=null);
  	super.new(name, par);
  	$cast(component, par);
  endfunction : new

  function void set_configuration(configuration_base config);
  	component.set_configuration(config);
  endfunction : set_configuration

  function CONFIGURATION get_configuration();
  	return component.get_configuration();
  endfunction : get_configuration

  function void set_status(status_base status);
    component.set_status(status);
  endfunction : set_status

  function STATUS get_status();
    return component.get_status();
  endfunction : get_status
  
  function void set_context(configuration_base configuration, status_base status);
  	component.set_context(configuration, status);
  endfunction : set_context
endclass : component_proxy
/*COMPONENT PROXY*/
`endif