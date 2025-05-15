
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

  task drive_addr_phase();  //drives control signals of AHB

    wait(addr_phase_que.size == 0);   //checking if the addr phase data present or not
    trans_h2=addr_phase_que.pop_front();

    vif.drv_cb.hwrite <= trans_h2.hwrite;
    vif.drv_cb.hsize <= trans_h2.hsize;
    vif.drv_cb.hburst <= int'(trans_h2.hburst_e);
    vif.drv_cb.htrans <= trans_h2.htrans;   //for single burst type or the first transfer of burst type transaction
    vif.drv_cb.haddr <= trans_h2.haddr_que.pop_front();

    if(trans_h2.calc_txf > 1) begin         //for burst type transfers
      for(int i = 0; i < trans_h2.calc_txf -1; i++) begin
        //@(vif.drv_cb /*iff vif.drv_cb.hreadyout*/);
        vif.drv_cb.haddr <= trans_h2.haddr_que.pop_front();
        vif.drv_cb.htrans <= trans_h2.htrans;
      end
    end
  endtask

  task drive_data_phase();        //drives the data signals

    wait(data_phase_que.size != 0);   //checking if the data phase data present or not
    trans_h3 = data_phase_que.pop_front();

    if(trans_h3.hwrite)
      vif.drv_cb.hwdata <= trans_h3.hwdata;  //for the single burst type or first transfer of the burst type transaction

    if(trans_h3.calc_txf) begin
      for(int i=0; i<trans_h3.calc_txf -1;i++) begin
        //@(vif.drv_cb /*iff vif.drv_cb.hreadyout*/);
        if(trans_h3.hwrite)
          vif.drv_cb.hwdata <= trans_h3.hwdata;
      end
    end
  endtask

  task send_to_dut;
    fork
      @(vif.drv_cb) drive_addr_phase();
      begin
        repeat(2) @(vif.drv_cb);
        drive_data_phase();
      end
    join_any
  endtask

  task run();
    trans_h = new();
    trans_h2 =new();
    trans_h3 = new();
    fork
      repeat(20) begin
        gen2drv.get(trans_h);
        trans_h.print(trans_h,"Driver");
        addr_phase_que.push_back(trans_h);
        data_phase_que.push_back(trans_h);
        send_to_dut();
        //trans_h.print("Driver");
      end
      //drive_control_io();                       //drives the control signals of AHB
      //drive_data_in();                          //drives the data signal of AHB
    join
  endtask


endclass

`endif
