`define AXI_MAX_ID_WIDTH 1
`define AXI_MAX_ADDRESS_WIDTH 32 
`define AXI_MAX_DATA_WIDTH 32 

`ifndef AXI_DATA_TYPES_PKG_SV
`define AXI_DATA_TYPES_PKG_SV
package axi_data_types_pkg;
  typedef bit [`AXI_MAX_ID_WIDTH-1:0] axi_id;

  typedef bit [`AXI_MAX_ADDRESS_WIDTH-1:0] axi_address;
 
  typedef bit [3:0] axi_burst_length; // AXI3
  //typedef bit [7:0] axi_burst_length; // AFTER AXI4
  // Get burst length in bit binary
  function automatic axi_burst_length pack_bl(int bl);
    if (bl inside {[1:16]}) return axi_burst_length'(bl-1); // AXI3
    //if (bl inside {[1:256]}) return axi_burst_length'(bl-1); // AFTER AXI4
    else //$display("ERROR: AXI BURST LEGNTH EXCEEDS LIMITATION.");
      $display("%d @%t",axi_burst_length'(bl-1), $time);
  endfunction
  // Get burst length in integer
  function automatic int unpack_bl(axi_burst_length bl);
    return (int'(bl) + 1);
  endfunction

  typedef bit [1:0] axi_burst_size; // DMA AXI CUSTOMED AXI SIZE
  function automatic int get_bs(axi_burst_size bs);
    case (bs)
      'b00:     return 8;
      'b01:     return 16;
      'b10:     return 32;
      'b11:     return 32;
      default: return 32;
    endcase
  endfunction
/*  typedef enum bit [2:0] { // AFTER AXI4
    AXI_BURST_SIZE_1_BYTES =   3'b000,
    AXI_BURST_SIZE_2_BYTES =   3'b001,
    AXI_BURST_SIZE_4_BYTES =   3'b010,
    AXI_BURST_SIZE_8_BYTES =   3'b011,
    AXI_BURST_SIZE_16_BYTES =  3'b100,
    AXI_BURST_SIZE_32_BYTES =  3'b101,
    AXI_BURST_SIZE_64_BYTES =  3'b110,
    AXI_BURST_SIZE_128_BYTES = 3'b111
  }; axi_burst_size;
  function automatic axi_burst_size pack_bs(int bs);
    case (bs)
      1:   return AXI_BURST_SIZE_1_BYTES;
      2:   return AXI_BURST_SIZE_2_BYTES;
      4:   return AXI_BURST_SIZE_8_BYTES;
      8:   return AXI_BURST_SIZE_8_BYTES;
      16:  return AXI_BURST_SIZE_16_BYTES;
      32:  return AXI_BURST_SIZE_32_BYTES;
      64:  return AXI_BURST_SIZE_64_BYTES;
      128:  return AXI_BURST_SIZE_128_BYTES;
      default: return AXI_BURST_SIZE_8_BYTES;
    endcase
  endfunction
  function automatic int unpack_bs(axi_burst_size bs);
    case (bs)
      AXI_BURST_SIZE_1_BYTES:   return   1; 
      AXI_BURST_SIZE_2_BYTES:   return   2; 
      AXI_BURST_SIZE_4_BYTES:   return   4; 
      AXI_BURST_SIZE_8_BYTES:   return   8; 
      AXI_BURST_SIZE_16_BYTES:  return  16; 
      AXI_BURST_SIZE_32_BYTES:  return  32; 
      AXI_BURST_SIZE_64_BYTES:  return  64; 
      AXI_BURST_SIZE_128_BYTES: return 128; 
      default: return 8;
    endcase
  endfunction
*/  

  typedef bit [`AXI_MAX_DATA_WIDTH-1:0] axi_data;

  typedef bit [`AXI_MAX_DATA_WIDTH/8-1:0] axi_strobe;
  
  typedef enum bit [1:0] {
    AXI_OKAY         = 2'b00,
    AXI_EXOKAY       = 2'b01,
    AXI_SLAVE_ERROR  = 2'b10,
    AXI_DECODE_ERROR = 2'b11
  } axi_response;

  typedef enum {
    AXI_WRITE,
    AXI_READ
  } axi_access_type;

  typedef enum {
    AXI3,
    AXI4LITE
  } axi_protocol;
endpackage : axi_data_types_pkg
`endif
