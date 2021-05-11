`ifndef SEQUENCE_BASE_SVH
`define SEQUENCE_BASE_SVH
class sequence_base #(
  type BASE                = uvm_sequence,
  type CONFIGURATION       = empty_configuration,
  type STATUS              = empty_status,
  type REQ                 = uvm_sequence_item,
  type RSP                 = REQ,
  type PROXY_CONFIGURATION = CONFIGURATION,
  type PROXY_STATUS        = STATUS
) extends sequence_item_base #(
  .BASE(uvm_sequence #(REQ, RSP)), .CONFIGURATION(CONFIGURATION), .STATUS(STATUS), .PROXY_CONFIGURATION(PROXY_CONFIGURATION), .PROXY_STATUS(PROXY_STATUS)
);
  // UVM 1.2
  protected bit enable_automatic_phase_objection = 0;

  function void set_automation_phase_objection(bit value);
    enable_automatic_phase_objection = value; 	
  endfunction : set_automation_phase_objection

  task pre_body();
  	if ((starting_phase != null) && enable_automatic_phase_objection) begin
  	  starting_phase.raise_objection(this);
  	end
  endtask : pre_body

  task post_body();
  	if ((starting_phase != null) && enable_automatic_phase_objection) begin
  	  starting_phase.drop_objection(this);
  	end
  endtask : post_body

  function new(string name="sequence_base");
   	super.new(name);
  endfunction : new
endclass : sequence_base
`endif