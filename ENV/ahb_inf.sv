////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_inf.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    : Define all the signals of dut and give          //
//                    direction to the signals of dut and testbench   //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_INF_SV
`define AHB_INF_SV

interface AHB_if(input logic hclk, input logic hresetn);

  // AHB-lite master signals
  logic [31:0] haddr;
  logic [1:0]  htrans;
  logic        hwrite;
  logic [2:0]  hsize;
  logic [2:0]  hburst;
  logic [3:0]  hprot;
  logic        hsel;
  logic        hready;
  logic [`ADDR_WIDTH-1:0] hwdata;
  logic [`DATA_WIDTH-1:0] hrdata;
  logic        hreadyout;
  logic [1:0]  hresp;


 clocking drv_cb @(posedge hclk);
    default input #1 output #1;
    input hresetn, hreadyout, hresp, hrdata;
    output hwrite, haddr, hwdata, htrans, hsize, hburst;
  endclocking

  //clocking block for monitor
  clocking mon_cb @(posedge hclk);
    default input #1 output #1;
    input hresetn, hreadyout, hresp, hwrite, haddr, hwdata, hrdata, htrans, hsize, hburst;
  endclocking

  modport DRV_MP (clocking drv_cb, input hclk);
  modport MON_MP (clocking mon_cb, input hclk);

endinterface
`endif
