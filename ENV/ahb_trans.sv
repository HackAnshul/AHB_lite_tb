///// HEADER

`ifndef AHB_TRANS_SV
`define AHB_TRANS_SV

typedef enum bit[2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_type;

class ahb_trans extends sv_sequence_item;

  bit [1:0] htrans[$];                   //transaction type
  rand bit hwrite;                   //!read/write
  rand bit[2:0] hsize;             //transfer data width
  //bit[2:0]hburst;                 //burst type
  rand burst_type hburst_e;     //hburst_type enum
  bit [3:0] hprot;

  //slave output signals
  bit hready;                   //transfer status signal
  bit[1:0] hresp;               //response signal


  //array for storing addresses of the burst transaction
  rand bit [`ADDR_WIDTH-1: 0] haddr_arr[$];
  //array for storing write data and read data
  rand bit [`DATA_WIDTH-1 :0]hwdata_arr[$];			//write data
  bit [`DATA_WIDTH-1 :0]hrdata_arr[$];			//read data


  //local variables for generating data
  local rand int limit;
  local rand int length;

  constraint hsize_range {hsize inside {[0:2]};}
  constraint read_exc {
    hwrite == 0 -> foreach(hwdata_arr[i]){ hwdata_arr[i] == 0; }
  }
  constraint priority_c {
    solve hburst_e before hsize; // for 1kb limit
    solve hburst_e before haddr_arr;
    solve hburst_e before hwdata_arr;
    solve hwrite before hwdata_arr;
  }

  constraint arr_sizes {
    if(hburst_e == SINGLE) haddr_arr.size() == 1;
    if (hburst_e == WRAP4) length  == 4;
    if (hburst_e == INCR4) length == 4;
    if (hburst_e == WRAP8) length == 8;
    if (hburst_e == INCR8) length == 8;
    if (hburst_e == WRAP16) length == 16;
    if (hburst_e == INCR16) length == 16;
    if (hburst_e == INCR) length inside {[1:25]}; //temporarily

    hwdata_arr.size() == length;
    haddr_arr.size() == length;
  }
//     hwdata_arr.size() == calc_txf();

  //constraint align_address {haddr % (1 << hsize) == 0;}
  constraint align_addr {
    haddr_arr[0] % (1 << hsize) == 0;
  }
  constraint wdata_values{
    foreach(hwdata_arr[i]) {
      limit  == (2**(8*(hsize+1))) -> hwdata_arr[i] inside {[0:limit-1]};
    }
  }

  constraint size_limit_1kb {{2**hsize * calc_txf()} inside {[0 : 1024]};}
  /*constraint temp{haddr inside {[0:1000]};}
  constraint temp1{hwdata inside {[0:1000]};}*/

//write a constraint for 1kb limit
  function void print(string block);
    $display("===================== %10s ===================== \@%0t ",block,$time);
    $display("haddr  : %p",haddr_arr);
    $display("hwdata : %p",hwdata_arr);
    $display("hrdata : %p",hrdata_arr);
    $display("htrans : %p",htrans);
    $display("| hwrite | hsize |  hburst  | hresp |");
    $display("| %0d    | %0d   |%6s | %0d   |", hwrite, hsize, hburst_e.name, hresp);
  endfunction

  //function for calculating number of transfers in a transaction
  function int calc_txf();
    case(this.hburst_e)
      SINGLE : return 1;
      INCR : return 1;
      WRAP4,INCR4: return 4;
      WRAP8,INCR8: return 8;
      WRAP16, INCR16: return 16;
    endcase
  endfunction


  function void post_randomize();
    for (int i=1; i < haddr_arr.size; i++) begin
      haddr_arr[i] = haddr_arr[i-1] + (2**hsize);
    end

    //htrans = new [length];
    //htrans[0] = 2'b10;
    htrans.push_back(2'b10);
    for (int i = 1; i< length -1; i++)
      htrans.push_back(2'b11);
    if (hburst_e == INCR)
      htrans.push_back(2'b10);
    else
      htrans.push_back(2'b11);

  endfunction
endclass

`endif
