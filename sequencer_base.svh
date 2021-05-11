`ifndef SEQUENCER_BASE
`define SEQUENCER_BASE
class sequencer_base #(
  type CONFIGURATION = empty_configuration,
  type STATUS        = empty_status,
  type REQ           = uvm_sequence_item,
  type RSP           = REQ,
  type PROXY_CONFIGURATION = CONFIGURATION,
  type PROXY_STATUS        = STATUS
) extends component_base #(
  .BASE(uvm_sequencer #(REQ, RSP)), .CONFIGURATION(CONFIGURATION), .STATUS(STATUS)
);
  typedef sequencer_base #(CONFIGURATION, STATUS, REQ, RSP, PROXY_CONFIGURATION, PROXY_STATUS) this_type;
  typedef component_proxy #(this_type, PROXY_CONFIGURATION, PROXY_STATUS) proxy;
  protected bit enable_default_sequence = 1;

  function new(string name="sequencer_base", uvm_component par=null);
    super.new(name, par);
    void'(proxy::create_component_proxy(this));
  endfunction : new

  function void set_enable_default_sequence(bit value);
	enable_default_sequence = value;
  endfunction : set_enable_default_sequence
  function bit get_enable_default_sequence();
    return enable_default_sequence; 	
  endfunction :  get_enable_default_sequence

  function void start_phase_sequence(uvm_phase phase);
  	if (enable_default_sequence) begin
  	  super.start_phase_sequence(phase);
  	end
  endfunction : start_phase_sequence

  `uvm_component_param_utils(sequencer_base #(CONFIGURATION, STATUS, REQ, RSP, PROXY_CONFIGURATION))
endclass : sequencer_base
`endif