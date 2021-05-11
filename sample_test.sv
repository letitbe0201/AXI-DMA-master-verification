`ifndef SAMPLE_TEST_SV
`define SAMPLE_TEST_SV
`define NEED_DEBUG 1
class sample_test extends component_base #(
  .BASE(uvm_test),
  .CONFIGURATION(sample_test_configuration)
);

  dma_axi_master_agent     master_agent;
  dma_axi_master_sequencer master_sequencer;
  dma_axi_slave_agent      slave_agent;
  dma_axi_slave_sequencer  slave_sequencer;

  apb_config_agent config_agent;

  dma_apb_reg_model  regmodel; /*RAL*/
  dma_ral_adapter    m_adapter; /*RAL*/
  dma_apb_config_seq config_seq; /*RAL*/

  dma_axi_sb sb;

  `uvm_component_utils(sample_test);
  function new(string name="sample_test", uvm_component par=null);
    super.new(name, par);
    `uvm_info("SRANDOM", $sformatf("Initial random seed: %0d", $get_initial_random_seed), UVM_NONE)
  endfunction : new

  function void create_configuration();
    configuration = CONFIGURATION::type_id::create("configuration");
    void'(uvm_config_db #(dma_axi_vif)::get(null, "", "vif", configuration.axi_cfg.vif));
    if (configuration.randomize()) begin
      `uvm_info(get_name(), $sformatf("Configuration...\n%s", configuration.sprint()), UVM_NONE)
    end
    else begin
      `uvm_fatal(get_name(), "Randomization FAILED!")
    end
  endfunction : create_configuration

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    slave_agent = dma_axi_slave_agent::type_id::create("slave_agent", this);
    slave_agent.set_configuration(configuration.axi_cfg);

    config_agent = apb_config_agent::type_id::create("config_agent", this);
    
    regmodel  = dma_apb_reg_model::type_id::create("regmodel", this); /*RAL*/
    regmodel.build(); /*RAL*/
    m_adapter = dma_ral_adapter::type_id::create("m_adapter",, get_full_name()); /*RAL*/
    config_seq = dma_apb_config_seq::type_id::create("config_seq");

    sb = dma_axi_sb::type_id::create("dma_axi_sb", this);
//    sb.set_configuration(configuration.axi_cfg);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    slave_sequencer  = slave_agent.sequencer;

    regmodel.default_map.set_sequencer(.sequencer(config_agent.sqr), .adapter(m_adapter)); /*RAL*/
    regmodel.default_map.set_base_addr('h0); /*RAL*/

    config_agent.apb_port_ag.connect(sb.apb_fifo.analysis_export);
    slave_agent.sb_port_ag.connect(sb.axi_addr_fifo.analysis_export);
  endfunction : connect_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(slave_sequencer, "run_phase", "default_sequence", dma_axi_slave_default_sequence::type_id::get());
    uvm_top.print_topology();
    // slave
  endfunction : end_of_elaboration_phase

  /*RAL*/
  task run_phase(uvm_phase phase);
    # 200;
    phase.raise_objection(this);
    if (!config_seq.randomize()) begin
      `uvm_error("[SAMPLE_TEST]", "CONFIG SEQ RANDOMIZATION FAILED.")
    end
    config_seq.regmodel = regmodel;
    config_seq.starting_phase = phase;
    config_seq.start(config_agent.sqr);
    
    phase.drop_objection(this);
////////test
/*
    # 200;
    phase.raise_objection(this);
    if (!config_seq.randomize()) begin
      `uvm_error("[SAMPLE_TEST]", "CONFIG SEQ RANDOMIZATION FAILED.")
    end
    config_seq.regmodel = regmodel;
    config_seq.starting_phase = phase;
    config_seq.start(config_agent.sqr);
    
    phase.drop_objection(this);
*/
////////test
  endtask : run_phase
  /*RAL*/
endclass : sample_test
`endif
