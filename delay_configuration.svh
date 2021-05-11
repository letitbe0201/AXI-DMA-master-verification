`ifndef DELAY_CONFIGURATION
`define DELAY_CONFIGURATION
/*DELAY CONFIGURATION*/
class delay_configuration extends configuration_base;
  rand int min_delay;
  rand int mid_delay[2];
  rand int max_delay;
  rand int weight_zero_delay;
  rand int weight_short_delay;
  rand int weight_long_delay;
  // min/max delay
  constraint c_valid_min_max_delay {
  	min_delay >= -1;
  	max_delay >= -1;
  	max_delay >= min_delay;
  }
  constraint c_default_min_max_delay {
  	soft min_delay == -1;
  	soft max_delay == -1;
  }
  // mid delay
  constraint c_valid_mid_delay {
  	solve min_delay, max_delay before mid_delay;
  	(mid_delay[0]==-1) || (mid_delay[0] >= get_min_delay(min_delay));
  	(mid_delay[1]==-1) || (mid_delay[1] <= get_max_delay(max_delay, min_delay));
  	mid_delay[0] <= mid_delay[1];
  	if (get_delay(max_delay, min_delay) >= 1) {
  	  if (get_min_delay(min_delay)==0) {
        mid_delay[0] > 0;
  	  }
  	}
  }
  constraint c_default_mid_delay {
  	soft mid_delay[0] == -1;
  	soft mid_delay[1] == -1;
  }

  constraint c_valid_weight {
  	solve min_delay before weight_zero_delay;
  	if (get_min_delay(min_delay) > 0) {
      weight_zero_delay  ==  0;
      weight_short_delay >= -1;
      weight_long_delay  >= -1;
  	}
  	else {
      weight_zero_delay  >= -1;
      weight_short_delay >= -1;
      weight_long_delay  >= -1;
  	}
  }
  constraint c_default_weight {
  	soft weight_zero_delay == -1;
  	soft weight_short_delay == -1;
  	soft weight_long_delay == -1;
  }

  function int get_min_delay(int min_delay);
  	return (min_delay>=0) ? min_delay : 0;
  endfunction : get_min_delay
  function int get_max_delay(int max_delay, int min_delay);
  	return (max_delay>=0) ? max_delay : get_min_delay(min_delay);
  endfunction : get_max_delay
  function int get_delay(int max_delay, int min_delay);
  	return get_max_delay(max_delay, min_delay) - get_min_delay(min_delay);
  endfunction : get_delay

  function void post_randomize ();
  	int delta;
  	weight_zero_delay  = (weight_zero_delay>=0)  ? weight_zero_delay  : 1;
  	weight_short_delay = (weight_short_delay>=0) ? weight_short_delay : 1;
  	weight_long_delay  = (weight_long_delay>=0)  ? weight_long_delay  : 1;  
    
    min_delay = get_min_delay(min_delay);
    max_delay = get_max_delay(max_delay, min_delay);
    delta     = get_delay(max_delay, min_delay);
    foreach (mid_delay[i]) begin
      if (mid_delay[i] == -1) begin
      	mid_delay[i] = min_delay + (delta/2);
      end
    end
  endfunction : post_randomize

  `uvm_object_utils_begin(delay_configuration)
    `uvm_field_int(min_delay, UVM_DEFAULT|UVM_DEC)
    `uvm_field_sarray_int(mid_delay, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(max_delay, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(weight_zero_delay, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(weight_short_delay, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(weight_long_delay, UVM_DEFAULT|UVM_DEC)
  `uvm_object_utils_end
//  `uvm_object_utils(delay_configuration)
  function new(string name="delay_configuration");
    super.new(name);
  endfunction : new
endclass : delay_configuration
/*DELAY CONFIGURATION*/

/*DEFINE DELAY CONSTRAINT*/
`define delay_constraint(DELAY, CONFIG)\
if (CONFIG.max_delay > CONFIG.min_delay) {\
  (DELAY inside {[CONFIG.min_delay : CONFIG.mid_delay[0]]}) ||\
  (DELAY inside {[CONFIG.mid_delay[1] : CONFIG.max_delay]});\
  if (CONFIG.min_delay == 0) {\
    DELAY dist {\
	  0                                         := CONFIG.weight_zero_delay,\
	  [1                  :CONFIG.mid_delay[0]] :/ CONFIG.weight_short_delay,\
	  [CONFIG.mid_delay[1]:CONFIG.max_delay   ] :/ CONFIG.weight_long_delay\
    };\
  }\
  else {\
    DELAY dist {\
	  [CONFIG.min_delay   :CONFIG.mid_delay[0]] :/CONFIG.weight_short_delay,\
	  [CONFIG.mid_delay[1]:CONFIG.max_delay   ] :/CONFIG.weight_long_delay\
    };\
  }\
}\
else {\
  DELAY == CONFIG.min_delay;\
}
/*DEFINE DELAY CONSTRAINT*/
`endif