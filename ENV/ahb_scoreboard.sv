////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_scoreboard.sv                               //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    :   //
//                        //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_SB_SV
`define AHB_SB_SV

class ahb_scoreboard;

  ahb_trans exp_trans,act_trans;
  int success;
  int failure;
  event ev_sample;

  mailbox #(ahb_trans) ref2sb;
  mailbox #(ahb_trans) mon2sb;

  function void connect ( mailbox #(ahb_trans) ref2sb,
                          mailbox #(ahb_trans) mon2sb);
    this.mon2sb = mon2sb;
    this.ref2sb = ref2sb;
  endfunction

  task run();

    forever begin
      ref2sb.get(exp_trans);
      //ahb_pkg::raise_objection();
      mon2sb.get(act_trans);
      exp_trans.print("expected");
      act_trans.print("actual");
      //compare act and exp and log the results
      check_data(act_trans,exp_trans);
      //#(`half_clk)
      //ahb_pkg::drop_objection();
    end
  endtask

  task check_data(ahb_trans act_trans, ahb_trans exp_trans);
    if(act_trans.hrdata_que = exp_trans.hrdata_que) begin
      success++;
    end else begin
      failure++;
    end
    //-> ev_sample;

 endtask


  function void print_sb();/*
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
*/
  endfunction

 endclass
`endif
