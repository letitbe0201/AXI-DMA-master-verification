`ifndef DMA_AXI_SB_SV
`define DMA_AXI_SB_SV
class dma_axi_sb extends uvm_scoreboard;
	`uvm_component_utils(dma_axi_sb)

    uvm_tlm_analysis_fifo #(apb_item) apb_fifo;
    uvm_tlm_analysis_fifo #(axi_item) axi_addr_fifo;
    apb_item apb;
    axi_item axi_addr;
    bit [31:0] read_addr[2], write_addr[2];

	function new(string name="dma_axi_sb", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_fifo = new("apb_fifo", this);
		axi_addr_fifo = new("axi_addr_fifo", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			apb_fifo.get(apb);
//			`uvm_info("SB", $sformatf("apb data %h", apb.data), UVM_NONE)
			axi_addr_fifo.get(axi_addr);
//			`uvm_info("SB", $sformatf("axi addr %h", axi_addr.address), UVM_NONE)
			if (apb.addr == 32'h0)
				read_addr[0]  = apb.data;
			else if (apb.addr == 32'h4)
				write_addr[0] = apb.data;

            if (axi_addr.access_type == AXI_READ)
            	read_addr[1]  = axi_addr.address;
            else
            	write_addr[1] = axi_addr.address;

			if ((read_addr[0]!=null)&&(read_addr[1]!=null)&&(write_addr[0]!=null)&&(write_addr[1]!=null)) begin
				if (read_addr[0]  != read_addr[1]) begin
					`uvm_error("SB", $sformatf("READ ADDRESS MISMATCH"))
				end
//				`uvm_info("SB", $sformatf("READ ADDR %h %h", read_addr[0], read_addr[1]), UVM_NONE)
				if (write_addr[0] != write_addr[1]) begin
					`uvm_error("SB", $sformatf("WRITE ADDRESS MISMATCH"))
				end
//				`uvm_info("SB", $sformatf("WRITE ADDR %h %h", write_addr[0], write_addr[1]), UVM_NONE)
			end
		end
	endtask : run_phase
endclass : dma_axi_sb
`endif