////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_env.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    :  //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_ENV_SV
`define AHB_ENV_SV

class ahb_env;

  ahb_gen gen;
  ahb_driver drv;
  ahb_monitor mon;
  ahb_ref_model rf;
  ahb_scoreboard sb;

  mailbox #(ahb_trans) gen2drv;
  mailbox #(ahb_trans) mon2scb;
  mailbox #(ahb_trans) mon2ref;
  mailbox #(ahb_trans) rm2scb;

  virtual ahb_inf.MON_MP mon_vif;
  virtual ahb_inf.DRV_MP drv_vif;

  function void build();
    // Create and connect mailboxes
    gen2drv = new();
    mon2scb = new();
    mon2ref = new();
    rm2scb = new();
    gen = new();
    drv = new();
    mon = new();
    rf = new();
    sb = new();
  endfunction

  function void connect(virtual ahb_inf.MON_MP mon_vif,
                        virtual ahb_inf.DRV_MP drv_vif);
    this.mon_vif = mon_vif;
    this.drv_vif = drv_vif;
    gen.connect(gen2drv);
    drv.connect(gen2drv, drv_vif);
    mon.connect(mon2scb, mon2ref, mon_vif);
    rf.connect(mon2ref, rm2scb);
    sb.connect(mon2scb, rm2scb);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      rf.run();
      sb.run();
    join
  endtask

endclass

`endif
