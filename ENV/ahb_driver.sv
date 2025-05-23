
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
  ahb_trans trans_h,trans_h2,trans_h3;
  ahb_trans addr_phase_que[$];
  ahb_trans data_phase_que[$];

  // Connect method
  function void connect(mailbox #(ahb_trans) gen2drv, virtual ahb_inf.DRV_MP vif);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task drive_control_signals(); 				                    //drives control signals of AHB

    wait(addr_phase_que.size != 0);                         //checking if the addr phase data present or not
    trans_h2=addr_phase_que.pop_front();
    vif.drv_cb.hsel <= 1'b1;
    vif.drv_cb.hwrite <= trans_h2.hwrite;
    vif.drv_cb.hsize <= trans_h2.hsize;
    vif.drv_cb.hburst <= int'(trans_h2.hburst_e);
    vif.drv_cb.htrans <= trans_h2.htrans.pop_front();                       //for single burst type or the first transfer of burst type transaction
    vif.drv_cb.haddr <= trans_h2.haddr_arr.pop_front();

    if(trans_h2.calc_txf > 1) begin                             //for burst type transfers
      for(int i = 1; i < trans_h2.calc_txf -1; i++) begin
        @(vif.drv_cb);
        vif.drv_cb.haddr <= trans_h2.haddr_arr.pop_front();
        vif.drv_cb.htrans <= trans_h2.htrans.pop_front();
      end
    end
  endtask

  task drive_data_signals();                                //drives the data signals

    wait(data_phase_que.size != 0);                         //checking if the data phase data present or not
    trans_h3 = data_phase_que.pop_front();

    if(trans_h3.hwrite)
      vif.drv_cb.hwdata <= trans_h3.hwdata_arr.pop_front(); //for the single burst type or first transfer of the burst type transaction

    if(trans_h3.calc_txf) begin
      for(int i=1; i<trans_h3.calc_txf -1; i++) begin
        @(vif.drv_cb);
        if(trans_h3.hwrite)
          vif.drv_cb.hwdata <= trans_h3.hwdata_arr.pop_front();
      end
    end
  endtask

  task send_to_dut;
    if(ahb_config::pipe_status == 1) begin
      fork
        @(vif.drv_cb) drive_control_signals();
        begin
          repeat(2) @(vif.drv_cb);
          drive_data_signals();
        end
      join_any
    end
    else begin
      @(vif.drv_cb);
      drive_control_signals();
      @(vif.drv_cb);
      drive_data_signals();
    end
  endtask

  task run();
    trans_h = new();
    trans_h2 =new();
    trans_h3 = new();
    repeat(20) begin
      fork
        gen2drv.get(trans_h);
        trans_h.print("Driver");
        addr_phase_que.push_back(trans_h);
        data_phase_que.push_back(trans_h);
        send_to_dut();
        //trans_h.print("Driver");
      join
    end
      //drive_control_io();             //drives the control signals of AHB
      //drive_data_in();                //drives the data signal of AHB
  endtask


endclass
`endif
