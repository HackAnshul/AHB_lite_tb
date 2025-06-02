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

  mailbox #(ahb_trans) mon2rf;
  mailbox #(ahb_trans) mon2sb;

  ahb_trans trans_h;
  virtual ahb_inf.MON_MP vif;

  function void connect (mailbox #(ahb_trans) mon2rf,
                         mailbox #(ahb_trans) mon2sb,
                         virtual ahb_inf.MON_MP vif);
    this.mon2rf = mon2rf;
    this.mon2sb = mon2sb;
    this.vif = vif;
  endfunction

  task run();
//    forever begin
    repeat(20) begin
      fork
        begin
          trans_h=new();
          get_from_dut(trans_h);
          trans_h.print("Monitor");
          mon2ref.put(trans_h);
          mon2scb.put(trans_h);
        end
        wait_reset_assert();
      join_any
//      disable fork;
      wait_reset_release();
    end
  endtask

  task get_from_dut(ahb_trans trans_h);
    fork
      get_addr_phase(trans_h);
      get_data_phase(trans_h);
    join_any
  endtask

  task get_addr_phase(ahb_trans trans_h);
    @(vif.mon_cb iff vif.mon_cb.hready);
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
    trans_h.hwrite = vif.mon_cb.hwrite;
    //trans_h.hsel = vif.mon_cb.hsel;
    //trans_h.hresetn = vif.mon_cb.hresetn;
    trans_h.hsize  = vif.mon_cb.hsize;
    trans_h.htrans.push_back(vif.mon_cb.htrans);
    trans_h.hprot = vif.mon_cb.hprot;
    trans_h.haddr.push_back(vif.mon_cb.haddr);
    if (trans_h.calc_txf > 1) begin
      for(int i=1; i < trans_h.calc_txf; i++) begin
    @(vif.mon_cb iff vif.mon_cb.hready);
        trans_h.haddr.push_back(vif.mon_cb.haddr);
        trans_h.htrans.push_back(vif.mon_cb.htrans);
      end
    end
  endtask

  task get_data_phase(ahb_trans trans_h);
    repeat (2) @(vif.mon_cb iff vif.mon_cb.hready);
    if(vif.mon_cb.hwrite)
      trans_h.hwdata.push_back(vif.mon_cb.hwdata);
    else
      trans_h.hrdata.push_back(vif.mon_cb.hrdata);
    if (trans_h.calc_txf > 1) begin
      for(int i=1; i < trans_h.calc_txf; i++) begin
        @(vif.mon_cb iff vif.mon_cb.hready);
        if(vif.mon_cb.hwrite)
          trans_h.hwdata.push_back(vif.mon_cb.hwdata);
        else
          trans_h.hrdata.push_back(vif.mon_cb.hrdata);
      end
    end
    trans_h.print("Monitor");
  endtask

  task wait_reset_release();
    wait(vif.mon_cb.hresetn == 1);
  endtask

  task wait_reset_assert();
    wait(vif.mon_cb.hresetn == 0);
  endtask

endclass

`endif
