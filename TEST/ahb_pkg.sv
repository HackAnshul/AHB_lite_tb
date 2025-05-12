// guard statement to avoid multiple compilation of a file
`ifndef RAM_PACKAGE_SV
`define RAM_PACKAGE_SV

`include "ahb_defines.svh"
`include "ahb_inf.sv"

package ahb_pkg;
  event drv_comp;
  event rst_drv;
  event rst_assert;
  event rst_release;

  int objection_count;

  function void raise_objection();
    objection_count++;
  endfunction

  function void drop_objection();
    objection_count--;
  endfunction
//   task wait_reset_release();
//     @(rst_release);
//   endtask
//   task wait_reset_assert();
//     @(rst_assert);
//   endtask

  `include "sv_sequence_item.sv"
  `include "ahb_trans.sv"
  `include "ahb_gen.sv"
  `include "ahb_driver.sv"
  `include "ahb_monitor.sv"
  `include "ahb_ref_model.sv"
  `include "ahb_scoreboard.sv"
  `include "ahb_env.sv"
  //add all file till test, don't miss the order

  //testcases
  `include "ahb_base_test.sv"

endpackage


`endif
