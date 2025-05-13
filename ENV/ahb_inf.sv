////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_inf.sv                                      //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    : Define all the signals of dut and give          //
//                    direction to the signals of dut and testbench   //
////////////////////////////////////////////////////////////////////////

`ifndef AHB_INF_SV
`define AHB_INF_SV
//typedef RAM_INF_SV

interface ahb_inf(input hclk);

  logic hresetn;
  logic hsel;
  logic hready;

  logic [2:0] hsize;
  logic [2:0] hburst;
  logic [1:0] htrans;
  logic [(`ADDR_WIDTH-1):0] haddr;
  logic [(`DATA_WIDTH-1):0] hwdata;

  logic [(`DATA_WIDTH-1):0] hrdata;
  logic hreadyout;
  logic hresp;

  //// driver's clocking block ////
  clocking drv_cb @(posedge Hclk);
    default input #1 output #1;
    input hresetn;
    output hsel, hready, hsize, hburst, htrans, haddr, hwdata;
    output hrdata, hreadyout, hresp;
  endclocking

  //// monitor's clocking block ////
  clocking mon_cb @(posedge Hclk);
    default input #1 output #1;
    input hresetn;
    input hsel, hready, hsize, hburst, htrans, haddr, hwdata;
    input hrdata, hreadyout, hresp;
  endclocking

  modport DRV_MP (clocking drv_cb, input hclk);
  modport MON_MP (clocking mon_cb, input hclk);


endinterface

`endif
