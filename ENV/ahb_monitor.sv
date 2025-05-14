////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_monitor.sv                                  //
//   Author         : Anshul Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    :  //
//                                                                    //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_MONITOR_SV
`define AHB_MONITOR_SV

class ahb_monitor;
  //declare mailboxs
  mailbox #(ahb_trans) mon2rf;
  mailbox #(ahb_trans) mon2sb;

  //declare transaction class
  ahb_trans trans_h;

  //declare virtual interface
  virtual ahb_inf.MON_MP vif;

  //take connect method
  function void connect (mailbox #(ahb_trans) mon2rf,
                         mailbox #(ahb_trans) mon2sb,
                         virtual ahb_inf.MON_MP vif);
    this.mon2rf = mon2rf;
    this.mon2sb = mon2sb;
    this.vif = vif;
  endfunction


  task get_from_dut(ahb_trans item_collected);

    @(vif.mon_cb);
//monitor logic
  endtask

  task run();
    wait_reset_release();
    forever begin
      fork
        begin
          trans_h=new();
          get_from_dut(trans_h);
          trans_h.print(trans_h,"Monitor");
          mon2rf.put(trans_h);
          mon2sb.put(trans_h);
        end
        wait_reset_assert();
      join_any
      disable fork;
      wait_reset_release();
    end
  endtask

  task wait_reset_release();
    wait (vif.mon_cb.hresetn == 0);
  endtask
  task wait_reset_assert();
    wait (vif.mon_cb.hresetn == 1);
  endtask


//  description
//  task monitor();
//    sample data from design
//    create item_collected
//    item_collected.wr_addr = vif.wmon_cb.wr_addr;
//    item_collected.kind_e = kind'{vif.wmon_cb.wr_enb,vif.wmon_cb.rd_enb};
//    $cast(item_collected.kind_e,{vif.wmon_cb.wr_enb,vif.wmon_cb.rd_enb});
//  endtask

endclass

`endif
