`ifndef AHB_TB_TOP_SV
`define AHB_TB_TOP_SV

`include "ahb_pkg.sv"

module ahb_tb_top;
  import ahb_pkg::*;

  // Clock and reset
  logic hclk;
  logic hresetn;

  // AHB interface instance
  ahb_inf inf (hclk, hresetn);

  ahb3liten DUT (
    .HRESETn(hresetn),
    .HCLK(hclk),
    .HSEL(inf.hsel),
    .HADDR(inf.haddr),
    .HWDATA(inf.hwdata),
    .HRDATA(inf.hrdata),
    .HWRITE(inf.hwrite),
    .HSIZE(inf.hsize),
    .HBURST(inf.hburst),
    .HPROT(inf.hprot),
    .HTRANS(inf.htrans),
    .HREADYOUT(inf.hready),
    .HREADY(1),
    .HRESP(inf.hresp)
  );
  //base test
  ahb_base_test test;


  // Clock generation
  initial begin
    forever #5 hclk = ~hclk;
  end

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
    test.connect(inf.DRV_MP, inf.MON_MP);
    // Optionally run if needed
    //$display("Test running...");
    ahb_config::set_pipeline(1);
    test.run();
    #1000 $finish;
  end

endmodule

`endif
