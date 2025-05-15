///// HEADER

//Gaurd Statment to avoid multiple compilation of a file
`ifndef AHB_TRANS_SV
`define AHB_TRANS_SV

typedef enum bit[2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_type;

class ahb_trans extends sv_sequence_item;

  bit hresetn;                                //active low signal
  bit hsel;                                   //slave select line
  rand bit [`ADDR_WIDTH-1:0]haddr;            //address bus
  bit [1:0]htrans;                            //transaction type
  bit hwrite;                                 //trasnfer direction
  rand bit[2:0]hsize;                         //transfer size
  //bit[2:0]hburst;                             //burst type
  rand bit [`DATA_WIDTH-1:0]hwdata;           //write data

  //slave output signals
  bit [31:0]hrdata;                           //read data
  bit hreadyout;                              //transfer status signal
  bit[1:0] hresp;                             //response signal

  burst_type hburst_e;                        //enum instantiation of hburst_type enum
  //queue for storing addresses of the burst transaction
  bit [`ADDR_WIDTH-1: 0] haddr_que[$];

  //queue for storing write data and read data
  bit [`DATA_WIDTH-1 :0]hwdata_que[$];			//write data
  bit [`DATA_WIDTH-1 :0]hrdata_que[$];			//read data

//write a constraint for 1kb limit
  function void print(sv_sequence_item rhs, string block);
    ahb_trans lhs;
    $cast(lhs,rhs);
    $display("====================== %10s ====================== \@%0t ",block,$time);
    $display("| rst | sel | address | htrans | hwrite | hsize | hburst | hwdata | hrdata | hreadyout | hresp |");
    $display("| %0d | %0d | %0d     | %0d    | %0d    | %0d   | %0s    |  %0d   |   %0d  | %0d       |  $0d  |",hresetn, hsel, haddr, htrans, hwrite, hsize, hburst_e, hwdata, hrdata, hreadyout, hresp);
  endfunction

  //function for calculating number of transfers in a transaction
  function int calc_txf();
    case(this.hburst_e)
      SINGLE : return 1;
      INCR : return 1;			//temporary value for INCR
      WRAP4: return 4;
      INCR4 : return 4;
      WRAP8: return 8;
      INCR8 : return 8;
      WRAP16: return 16;
      INCR16 : return 16;
    endcase
  endfunction

endclass

`endif

