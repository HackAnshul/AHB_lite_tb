`ifndef AHB_EXP_TEST
`define AHB_EXP_TEST

class ahb_exp_test extends ahb_gen;
   task run();
    ahb_pkg::raise_objection();
    repeat(no_of_trans) begin
      `sv_do(trans_h)
    end
    #2.5;
    ahb_pkg::drop_objection();
  endtask

endclass

`endif
