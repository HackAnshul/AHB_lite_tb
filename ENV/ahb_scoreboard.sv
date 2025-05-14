////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_scoreboard.sv                               //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    :   //
//                        //
////////////////////////////////////////////////////////////////////////

`ifndef RAM_SB_SV
`define RAM_SB_SV

class ahb_scoreboard;
  
  //take transation handles
  ahb_trans exp_trans,act_trans;
  int success;
  int failure;
  event ev_sample;

  //declare mailboxs
  mailbox #(ahb_trans) ref2sb;
  mailbox #(ahb_trans) mon2sb;

  //take connect method
  function void connect ( mailbox #(ahb_trans) ref2sb,
                          mailbox #(ahb_trans) mon2sb);
    this.mon2sb = mon2sb;
    this.ref2sb = ref2sb;
  endfunction

  task run();

    forever begin
      ref2sb.get(exp_trans);
      ahb_pkg::raise_objection();
      mon2sb.get(act_trans);
      exp_trans.print(exp_trans,"expected");
      act_trans.print(act_trans,"actual");

      //compare act and exp and log the results
      check_data(act_trans,exp_trans);
      #(`half_clk)
      ahb_pkg::drop_objection();
    end
  endtask

  //description
 task check_data(ahb_trans act_trans, ahb_trans exp_trans);
//   `ahb_checker(act_trans.rd_data,exp_trans.rd_data)
   //cvg.sample();
   -> ev_sample;
 endtask


  function void print_sb();
    $display(" ----------------------------------");
    if ((this.success > 0) && (this.failure < 5)) begin
      $display("| .#####....####....####....####.. |");
      $display("| .##..##..##..##..##......##..... |");
      $display("| .#####...######...####....####.. |");
      $display("| .##......##..##......##......##. |");
      $display("| .##......##..##...####....####.. |");

    end else begin
      $display("| .######...####...######..##..... |");
      $display("| .##......##..##....##....##..... |");
      $display("| .####....######....##....##..... |");
      $display("| .##......##..##....##....##..... |");
      $display("| .##......##..##..######..######. |");

    end
    // $display("| -> Total Read: %3d               |",act_trans.rd_cnt);
    //$display("| -> Total Write: %3d              |",act_trans.wr_cnt);
    $display("| -> Total success: %3d            |",this.success);
    $display("| -> Total failure: %3d            |",this.failure);
    $display(" ----------------------------------");

  endfunction

 endclass
`endif
