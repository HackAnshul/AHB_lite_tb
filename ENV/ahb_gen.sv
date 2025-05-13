////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_gen.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    : generate stimuli and send to mailbox to         //
//                    ahb_driver.                                     //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_GEN_SV
`define AHB_GEN_SV

virtual class ahb_gen;
  ahb_trans trans_h;

  //mailbox
  mailbox #(ahb_trans) gen2drv;

  rand int no_of_trans;

  constraint TRANS {soft no_of_trans == 5;}

  function void connect (mailbox #(ahb_trans) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  pure virtual task run();

  protected task put_trans(ahb_trans req);
    ahb_trans req_copy;
    req_copy = new req;
    req.print(req,"generator");
    this.gen2drv.put(req_copy);
    //wait(drv_comp.triggered);
    //@(drv_comp);
  endtask
endclass

`endif

