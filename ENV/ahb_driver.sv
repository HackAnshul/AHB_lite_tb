
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

  virtual ahb_inf.DRV_MP vif;             // AHB Driver Interface
  mailbox #(ahb_trans) gen2drv;
  ahb_trans trans_h,trans_h1,trans_h2,trans_h3;
  ahb_trans addr_phase_que[$];
  ahb_trans data_phase_que[$];

  // Connect method
  function void connect(mailbox #(ahb_trans) gen2drv, virtual ahb_inf.DRV_MP vif);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

task run();
    wait_reset_release();
    forever begin
      fork
        begin
          gen2drv.get(trans_h);
          addr_phase_que.push_back(trans_h);
          send_to_dut();
        end
        //wait_reset_assert();
      join_any
      //disable fork; //FIXME: does not allow mulitple transaction
      //wait_reset_release();
    end
  endtask

  task send_to_dut();
    fork
      drive_control_signals();
      drive_data_signals();
    join
  endtask

  task drive_control_signals(); //drives control signals of AHB
    //if(vif.drv_cb.hresetn == 0) begin
    //  vif.drv_cb.htrans <= 0;
    //end
    //else begin
      wait(addr_phase_que.size != 0); //checking if the addr phase data present or not
      trans_h1 = new addr_phase_que.pop_front();
      for(int i = 0; i < trans_h1.calc_txf;i++) begin
        @(vif.drv_cb iff vif.drv_cb.hready);
        vif.drv_cb.hsel <= 1'b1;
        vif.drv_cb.hwrite <= trans_h1.hwrite;
        vif.drv_cb.hsize <= trans_h1.hsize;
        vif.drv_cb.hburst <= int'(trans_h1.hburst_e);
        vif.drv_cb.htrans <= trans_h1.htrans.pop_front();
        vif.drv_cb.haddr <= trans_h1.haddr.pop_front();
        if (i==0)
          data_phase_que.push_back(trans_h1);
      end
      trans_h1.print("Driver");
  endtask

  task drive_data_signals(); //drives the data signals
    wait(data_phase_que.size != 0); //checking if the data phase data present or not
    trans_h2 = data_phase_que.pop_front();
    for(int i=0; i<trans_h.calc_txf;i++) begin
      @(vif.drv_cb iff vif.drv_cb.hready);
      if(trans_h.hwrite)
        vif.drv_cb.hwdata <= trans_h.hwdata.pop_front();
    end
  endtask

  task wait_reset_release();
    wait(vif.drv_cb.hresetn == 1);
  endtask

  task wait_reset_assert();
    wait(vif.drv_cb.hresetn == 0);
  endtask
endclass
`endif
