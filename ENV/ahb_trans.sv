///// HEADER

//Gaurd Statment to avoid multiple compilation of a file
`ifndef AHB_TRANS_SV
`define AHB_TRANS_SV

`include "ahb_defines.svh"

class ahb_trans extends sv_sequence_item;
  bit HRESETn;
  static int wr_cnt, rd_cnt;


  static int que[$];
  bit Hsel;
  rand bit Hwrite;
  rand bit Hready;
  rand bit [2:0] Hsize;
  rand bit [2:0] Hburst;
  rand bit [1:0] Htrans;
  rand bit [(`ADDR_WIDTH-1):0] Haddr;
  rand bit [(`DATA_WIDTH-1):0] Hwdata;

  rand bit [(`DATA_WIDTH-1):0] Hrdata;
  rand bit Hreadyout;
  rand bit Hresp;


  //write default constraint if needed

  //add static variables to record no. of write and read transaction

  //override print/display method to print transaction attributes

  function void post_randomize();
  endfunction

  function void print(sv_sequence_item rhs, string block);
    ram_trans lhs;
    $cast(lhs,rhs);
    $display("====================== %10s ====================== \@%0t ",block,$time);
    $display("| rst | sel | address | htrans | hwrite | hsize | hburst | hprot | hwdata | hrdata | hreadyout | hresp |");
    $display("| %0d | %0d | %0d     | %0d    | %0d    | %0d   | %0d    | %0d   |  %0d   |   %0d  | %0d       |  $0d  |",hresetn, hsel, haddr, htrans, hwrite, hsize, hburst, hprot, hwdata, hrdata, hreadyout, hresp);
  endfunction

endclass

`endif
