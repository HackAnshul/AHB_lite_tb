////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_gen.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    : generate stimuli and send to mailbox to         //
//                    ahb_driver.                                     //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_GEN_SV
`define AHB_GEN_SV

class ahb_gen;

  mailbox #(ahb_trans) gen2drv;
  ahb_trans trans_h,trans_copy;
  function void connect(mailbox #(ahb_trans) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  pure task run();/*
  repeat(20) begin
    trans_h =new();
    trans_copy = new trans_h;
    void'(trans_h.randomize());
    gen2drv.put(trans_h);
    trans_h.print("Generator");
    // #10;
    end
  endtask*/

endclass
`endif

