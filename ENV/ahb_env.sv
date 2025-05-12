////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_env.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    :  //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_ENV_EV
`define AHB_ENV_EV

class ahb_env;

  //take handles of all verification sub component i.e. genrator, driver etc
  ahb_gen        gen_h;
  ahb_driver     drv_h;
  ahb_monitor    mon_h;
  ahb_ref_model  ref_h;
  ahb_scoreboard scb_h;

  //declare all mailboxs
  mailbox #(ahb_trans) gen2drv=new();
  mailbox #(ahb_trans) mon2rf=new();
  mailbox #(ahb_trans) mon2sb=new();
  mailbox #(ahb_trans) rf2sb=new();

  //declare all interface
  virtual ahb_inf.DRV_MP  drv_inf;
  virtual ahb_inf.MON_MP  mon_inf;

  //take connect method (only for virtual interface)
  function void connect(virtual ahb_inf.DRV_MP drv_inf,
                   virtual ahb_inf.MON_MP mon_inf);
    this.drv_inf = drv_inf;
    this.mon_inf = mon_inf;
    this.connect_all();
  endfunction

  //create all the component in this method
  function void build();
    //gen_h=new();
    drv_h=new();
    mon_h=new();
    ref_h=new();
    scb_h=new();
  endfunction

  //call all verif sub component connect method here
  function void connect_all();
    gen_h.connect(gen2drv);
    drv_h.connect(gen2drv,drv_inf);
    mon_h.connect(mon2rf,mon2sb,mon_inf);
    ref_h.connect(mon2rf,rf2sb);
    scb_h.connect(rf2sb,mon2sb);
  endfunction

  //call all verif sub component run task in parallel
  task run();
    fork
      gen_h.run();
      drv_h.run();
      mon_h.run();
      ref_h.run();
      scb_h.run();
    join_any
  endtask

  function void print_sb();
    scb_h.print_sb();
  endfunction

endclass
`endif
