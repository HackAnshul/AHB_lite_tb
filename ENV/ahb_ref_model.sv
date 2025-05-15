`ifndef AHB_REF_MOD_SV
`define AHB_REF_MOD_SV
class ahb_ref_model;

  //take transation handles
  ahb_trans trans_h1,trans_h2;

  //declare variables needed
  bit [`DATA_WIDTH - 1:0] mem [`DEPTH - 1:0];

  //declare mailboxs
  mailbox #(ahb_trans) mon2rf;
  mailbox #(ahb_trans) ref2sb;

  //take connect method
  function void connect (mailbox #(ahb_trans) mon2rf,
                         mailbox #(ahb_trans) ref2sb);
    this.mon2rf = mon2rf;
    this.ref2sb = ref2sb;
  endfunction

  task run();/*
    forever begin
      mon2rf.get(trans_h1);
      trans_h2 = new trans_h1;
      //trans_h1.print(trans_h1,"trans_h1");
      //collect data from mailbox
      predict_exp_rd_data(trans_h2);
      //put transaction for scoboard
      //$display("before putting");
      ref2sb.put(trans_h2);
      //trans_h1.print(trans_h1,"rerf model");

   end*/
  endtask

  //description
  task predict_exp_rd_data(ahb_trans trans_h);
  endtask

 endclass
`endif
