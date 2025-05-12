// Code your testbench here
// or browse Examples
// guard statement to avoid multiple compilation of a file
`ifndef RAM_TB_TOP_SV
`define RAM_TB_TOP_SV
`include "ram_pkg.sv"

module ahb_tb_top();
  parameter TIMEOUT = 200000;
  bit clk;

  // import the package
  import ahb_pkg::* ;

  // take instance of actual interface
  ahb_inf r_inf(clk);

  // take instance of test class
  ahb_base_test r_test;

  // intantiate design
  ahb dut(
    .clk(clk),
    .rst(r_inf.rst),
    .wr_enb(r_inf.wr_enb),
    .wr_addr(r_inf.wr_addr),
    .wr_data(r_inf.wr_data),
    .rd_enb(r_inf.rd_enb),
    .rd_addr(r_inf.rd_addr),
    .rd_data(r_inf.rd_data));

  task reset_assertion();
    @(posedge clk);
    r_inf.rst = 1'b1; //apply for reset
   // -> rst_assert;
    $display("reset asserted");
    repeat(2)@(posedge clk);
    r_inf.rst = 1'b0; //reset deassert
   // -> rst_release;
  endtask

  task run_test();
    if ($time != 0) $fatal("error! run_test method must called at 0 simulation time! called at %t",$time);

    // Create test
    r_test = new();
    r_test.build();
    r_test.connect(r_inf.DRV_MP, r_inf.MON_MP);

    fork
      r_test.run();
    join_none
    #0;
    fork
      wait(ram_pkg::objection_count == 0);
      begin
        #TIMEOUT;
        $fatal("Terminated because of global timeout %d",TIMEOUT);
      end
    join_any
    disable fork;
    $finish;
  endtask

  initial begin
    $dumpfile("ram_tb_top.vcd"); $dumpvars;
  end

  initial begin
    reset_assertion();
  end

  //generate clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    forever begin
      @(ram_pkg::rst_drv); // wait for event
      $display($time," reset is applied");
      reset_assertion();
    end
  end

  initial begin
    run_test();
  end
  final
  begin
    r_test.env.print_sb();
  end
endmodule

`endif
