`ifndef APB_ITEM_SVH
`define APB_ITEM_SVH
class apb_item extends uvm_sequence_item;
/*
  rand bit        pclken;
  rand bit        psel;
  rand bit        penable;
  rand bit [12:0] paddr;
  rand bit        pwrite;
  rand bit [31:0] pwdata;
  rand bit [31:0] prdata;
  rand bit        pslverr;
  rand bit        pready;
*/
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit        write;

  function new(string name="apb_item");
    super.new(name);
  endfunction : new
  `uvm_object_utils(apb_item)
endclass : apb_item
`endif