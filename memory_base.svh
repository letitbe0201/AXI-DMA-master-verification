`ifndef MEMORY_BASE_SVH
`define MEMORY_BASE_SVH
class memory_base #(
  int ADDRESS_WIDTH = 32,
  int DATA_WIDTH    = 32
)extends uvm_object;
  typedef bit [ADDRESS_WIDTH-1:0] memory_address;
  typedef bit [DATA_WIDTH-1:0]    memory_data;
  typedef bit [DATA_WIDTH/8-1:0]  memory_strobe;

  logic [DATA_WIDTH-1:0] default_data;
  protected int  byte_width;
  protected byte memory[memory_address];

  function new(string name="memory_base", int data_width=DATA_WIDTH);
  	super.new(name);
  	default_data = '0;
  	byte_width   = data_width/8;
  endfunction : new

  virtual function void put(
    memory_data    data,
    memory_strobe  strobe,
    int            byte_size,
    memory_address base,
    int            word_index
  );
    memory_address start_address;
    memory_address mem_address;
    int            byte_index;

    start_address = get_start_address(byte_size, base, word_index);
    for (int i=0; i<byte_size; i++) begin
      mem_address         = start_address + i;
      byte_index             = mem_address % byte_width;
      memory[mem_address] = data[8*byte_index +: 8];
    end
  endfunction : put

  virtual function memory_data get(
    int            byte_size,
    memory_address base,
    int            word_index
  );
  	memory_data    data;
  	memory_address start_address;
  	memory_address mem_address;
  	int            byte_index;

  	start_address = get_start_address(byte_size, base, word_index);
  	for (int i=0; i<byte_size; i++) begin
  	  mem_address = start_address + i;
  	  byte_index     = mem_address % byte_width;
  	  if (memory.exists(mem_address)) begin
  	  	data[8*byte_index +: 8] = memory[mem_address];
  	  end
  	  else begin
  	  	data[8*byte_index +: 8] = get_default_data(byte_index);
  	  end
  	end

  	return data;
  endfunction : get

  virtual function bit exists(
    int            byte_size,
    memory_address base,
    int            word_index
  );
  	memory_address start_address;
  	memory_address mem_address;

  	start_address = get_start_address(byte_size, base, word_index);
  	for (int i=0; i<byte_size; i++) begin
  	  mem_address = start_address + i;
  	  if (memory.exists(mem_address)) begin
  	  	return 1;
  	  end
  	end

  	return 0;
  endfunction : exists

  protected function memory_address get_start_address(
    int            byte_size,
    memory_address base,
    int            word_index
  );
  	return (base&get_address_mask(byte_size)) + byte_size*word_index;
  endfunction : get_start_address

  protected function memory_address get_address_mask(int byte_size);
  	memory_address mask;
  	mask = byte_size - 1;
  	mask = ~mask;
  	return mask;
  endfunction : get_address_mask

  protected function byte get_default_data(int byte_index);
  	if ($isunknown(default_data[8*byte_index +: 8])) begin
  	  return $urandom_range(255);
  	end
  	else begin
  	  return default_data[8*byte_index +: 8];
  	end
  endfunction : get_default_data
endclass : memory_base
`endif