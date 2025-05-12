
////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_driver.sv                                   //
//   Author         : Anshul Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    : Drives the stimulus coming from ahb_gen to DUT. //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_DRIVER_SV
`define AHB_DRIVER_SV

class ahb_driver;
  ahb_trans trans_h;

  //mailbox
  mailbox #(ahb_trans) gen2drv;

  //virtual interface
  virtual ahb_inf.DRV_MP vif;


  function void connect (mailbox #(ahb_trans) mbx,
                         virtual ahb_inf.DRV_MP vif);
    this.gen2drv = mbx;
    this.vif = vif;
  endfunction

  task run();
    wait_reset_release();
    forever begin
      trans_h = new();
      fork
        begin
          gen2drv.get(trans_h);
          trans_h.print(trans_h,"Driver");
          send_to_dut();
          -> drv_comp;
        end
        wait_reset_assert();
      join_any
      disable fork;
      wait_reset_release();
    end
  endtask

  //description
  task send_to_dut();
    //drive data to design
    @(vif.drv_cb);
//driver logic
  endtask

  task wait_reset_release();
    wait (vif.drv_cb.HRESETn == 1);
  endtask
  task wait_reset_assert();
    wait (vif.drv_cb.HRESETn == 0);
  endtask
endclass
`endif
