
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
  ahb_trans trans_h, trans_h2, trans_h3;
  ahb_trans addr_phase_que[$];
  ahb_trans data_phase_que[$];

  //mailbox
  mailbox #(ahb_trans) gen2drv;

  //virtual interface
  virtual ahb_inf.DRV_MP vif;

  bit first_trans_flag_addr = 1'b0;
  bit first_trans_flag_data = 1'b0;

  function void connect (mailbox #(ahb_trans) mbx,
                         virtual ahb_inf.DRV_MP vif);
    this.gen2drv = mbx;
    this.vif = vif;
  endfunction

  //description
  task drive_addr_phase(); //drives control signals of AHB
  $display("drive control");
    wait(addr_phase_que.size != 0)
    $display("wait is over addr");
    trans_h2=addr_phase_que.pop_front();
    for(int i =0; i<trans_h2.calc_txf; i++) begin
      if(i==0) begin
        if(!first_trans_flag_addr) @(vif.drv_cb);
        first_trans_flag_addr = 1'b1;
        vif.drv_cb.hwrite <= trans_h2.hwrite;
        vif.drv_cb.hsize <= trans_h2.hsize;
        vif.drv_cb.hburst <= int'(trans_h2.hburst_e);
        vif.drv_cb.htrans <= 2'b10;               //NONSEQ
        data_phase_que.push_back(trans_h2);
      end

      if(i!=0)
        vif.drv_cb.htrans <= 2'b11;               //SEQ

      //always sends address
      vif.drv_cb.haddr <= trans_h2.haddr_que.pop_front();
      @(vif.drv_cb iff vif.drv_cb.hreadyout);
      $display("drive control finish");

    end
  endtask

  task drive_data_phase();        //drives the data signals
    $display("drive data");

    wait(data_phase_que.size != 0);
    $display("wait is over addr");

    trans_h3 = data_phase_que.pop_front();
    if(!first_trans_flag_data)
      @(vif.drv_cb);

    first_trans_flag_data = 1'b1;

    for(int i=0; i<trans_h3.calc_txf;i++) begin
      if(trans_h3.hwrite)
        vif.drv_cb.hwdata <= trans_h3.hwdata_que.pop_front();
      @(vif.drv_cb iff vif.drv_cb.hreadyout);
    end
    $display("drive data finish");
  endtask

  // task wait_reset_release();
  //   wait (vif.drv_cb.hresetn == 1);
  // endtask
  // task wait_reset_assert();
  //   wait (vif.drv_cb.hresetn == 0);
  // endtask

  task send_to_dut;
    fork
      drive_addr_phase();
      drive_data_phase();
    join_any
  endtask

  task run();
    trans_h = new();
    trans_h2 =new();
    trans_h3 = new();
    fork
      forever begin
        gen2drv.get(trans_h);
        //trans_h.print(trans_h,"Driver");
        addr_phase_que.push_back(trans_h);
        send_to_dut();
        trans_h.print(trans_h,"Driver");
      end
    join
  endtask
endclass
`endif
