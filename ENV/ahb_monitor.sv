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


  task get_addr_phase();
    @(vif.mon_cb iff vif.mon_cb.hreadyout);
    case (vif.mon_cb.hburst)
      3'b000:trans_h.hburst_e = SINGLE;
      3'b001:trans_h.hburst_e = INCR;
      3'b010:trans_h.hburst_e = WRAP4;
      3'b011:trans_h.hburst_e = INCR4;
      3'b100:trans_h.hburst_e = WRAP8;
      3'b101:trans_h.hburst_e = INCR8;
      3'b110:trans_h.hburst_e = WRAP16;
      3'b111:trans_h.hburst_e = INCR16;
    endcase

    trans_h.hwrite = vif.drv_cb.hwrite;
    trans_h.hsize  = vif.drv_cb.hsize;
    trans_h.htrans = vif.drv_cb.htrans;

  endtask
  task get_from_dut(ahb_trans item_collected);
    fork
      get_addr_phase();
      get_data_phase();
    join_any
//monitor logic
  endtask

  task run();
    forever begin
      trans_h=new();
      get_from_dut(trans_h);
      trans_h.print(trans_h,"Monitor");
      mon2rf.put(trans_h);
      mon2sb.put(trans_h);
    end
  endtask

  task wait_reset_release();
    wait (vif.mon_cb.hresetn == 0);
  endtask
  task wait_reset_assert();
    wait (vif.mon_cb.hresetn == 1);
  endtask


endclass

`endif
