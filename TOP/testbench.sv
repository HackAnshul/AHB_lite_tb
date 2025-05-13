`ifndef AHB_TB_TOP_SV
`define AHB_TB_TOP_SV
`include "AHB_pkg.sv"

module AHB_tb_top;
  import AHB_pkg::*;
// Base test instance
  AHB_gen gen1;
  AHB_base_test test;
  // Clock and reset
  logic hclk;
  logic hresetn;

  // AHB interface instance
  AHB_if AHB_if_inst(hclk, hresetn);



  // Clock generation
  always #5 hclk = ~hclk;

  // Reset generation
  initial begin
    hclk = 0;
    hresetn = 0;
    repeat(2) @(posedge hclk)
    hresetn = 1;
  end

  // Instantiate and connect the testbench
  initial begin
    test = new();

      test.build();

    // Connect driver and monitor modports of interface to base test
    test.connect(AHB_if_inst.MON_MP, AHB_if_inst.DRV_MP);
    // Optionally run if needed
    //$display("Test running...");
    test.run();
    #100 $finish;
  end

endmodule

`endif
