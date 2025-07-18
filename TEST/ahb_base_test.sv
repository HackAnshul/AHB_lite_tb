// guard statement
`ifndef RAM_BASE_TEST_SV
`define RAM_BASE_TEST_SV

class ahb_base_test;

  local int itr;

  //take handle of verification environment class
  ahb_env env;

  //testcases
  //ahb_exp_test exp;
  ahb_write_read wr_h;
  ahb_back2back b2b_h;
  ////////////

  // declare all interface
  virtual ahb_inf.DRV_MP vif;
  virtual ahb_inf.MON_MP mvif;

  // take connect method (only for virtual interface)
  function void connect(virtual ahb_inf.DRV_MP vif,
                        virtual ahb_inf.MON_MP mvif);
    this.vif = vif;
    this.mvif = mvif;
    env.connect(mvif,vif);
  endfunction

  //create environment and call its methods here as needed
  function void build();
    env = new();
    env.build();
    //void'($value$plusargs("iter=%d",itr));
    `sv_do_on(WRITE_READ, wr_h)
    `sv_do_on(BACK2BACK, b2b_h)
  endfunction


  // call environment run task
  task run();
    env.run();
  endtask

 /* function print_sb();
    env.print_sb();
  endfunction*/

endclass

`endif
