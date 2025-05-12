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

interface ahb_inf(input Hclk);

  logic HRESETn;
  logic Hsel;
  logic Hready;

  logic [2:0] Hsize;
  logic [2:0] Hburst;
  logic [1:0] Htrans;
  logic [(`ADDR_WIDTH-1):0] Haddr;
  logic [(`DATA_WIDTH-1):0] Hwdata;

  logic [(`DATA_WIDTH-1):0] Hrdata;
  logic Hreadyout;
  logic Hresp;

  //// driver's clocking block ////
  clocking drv_cb @(posedge Hclk);
    default input #1 output #1;
    input HRESETn;
    output Hsel, Hready, Hsize, Hburst, Htrans, Haddr, Hwdata;
    output Hrdata, Hreadyout, Hresp;
  endclocking

  //// monitor's clocking block ////
  clocking mon_cb @(posedge Hclk);
    default input #1 output #1;
    input HRESETn;
    input Hsel, Hready, Hsize, Hburst, Htrans, Haddr, Hwdata;
    input Hrdata, Hreadyout, Hresp;
  endclocking

  modport DRV_MP (clocking drv_cb, input Hclk);
  modport MON_MP (clocking mon_cb, input Hclk);


endinterface

`endif
