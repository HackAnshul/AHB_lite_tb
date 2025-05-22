///// HEADER

`ifndef AHB_TRANS_SV
`define AHB_TRANS_SV

typedef enum bit[2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_type;

class ahb_trans extends sv_sequence_item;

 rand bit [`ADDR_WIDTH-1:0]haddr;    //address lines
  bit [1:0]htrans;                   //transaction type
  rand bit hwrite;                   //!read/write
  rand bit[2:0]hsize;             //transfer data width
  //bit[2:0]hburst;                 //burst type
  rand bit [`DATA_WIDTH-1:0]hwdata; //write data
  //slave output signals
  bit [31:0]hrdata;             //read data
  bit hready;                   //transfer status signal
  bit[1:0] hresp;               //response signal
  rand burst_type hburst_e;     //hburst_type enum

  //array for storing addresses of the burst transaction
  rand bit [`ADDR_WIDTH-1: 0] haddr_arr[];
  //array for storing write data and read data
  rand bit [`DATA_WIDTH-1 :0]hwdata_arr[];			//write data
  bit [`DATA_WIDTH-1 :0]hrdata_arr[];			//read data

  local rand int limit;

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
    haddr_arr.size() == calc_txf();
    hwdata_arr.size() == calc_txf();
  }

  //constraint align_address {haddr % (1 << hsize) == 0;}
  constraint align_addr {
    haddr_arr[0] % (1 << hsize) == 0;
  }
  constraint wdata_values{
    foreach(hwdata[i]) {
      limit  == (2**(8*(hsize+1))) -> hwdata[i] inside {[0:limit-1]};
    }
  }

  constraint size_limit_1kb {{2**hsize * calc_txf()} inside {[0 : 1024]};}
  /*constraint temp{haddr inside {[0:1000]};}
  constraint temp1{hwdata inside {[0:1000]};}*/

//write a constraint for 1kb limit
  function void print(string block);
    $display("====================== %10s ====================== \@%0t ",block,$time);
    $display("| address | htrans | hwrite | hsize | hburst | hwdata | hrdata | hresp |");
    $display("| %p     | %0d    | %0d    | %0d   | %s    |  %p   |   %p  |  %0d  |", haddr_que, htrans, hwrite, hsize, hburst_e.name, hwdata_que, hrdata_que, hresp);
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

  endfunction
endclass

`endif
