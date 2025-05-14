`ifndef AHB_TB_TOP_SV
`define AHB_TB_TOP_SV

`include "ahb_pkg.sv"

module ahb_tb_top;
  import ahb_pkg::*;

  // Clock and reset
  logic hclk;
  logic hresetn;

  // AHB interface instance
  ahb_inf vif (hclk, hresetn);

  //base test
  ahb_base_test test;


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
    test.connect(vif.DRV_MP, vif.MON_MP);
    // Optionally run if needed
    //$display("Test running...");
    test.run();
    #100 $finish;
  end

endmodule

`endif
