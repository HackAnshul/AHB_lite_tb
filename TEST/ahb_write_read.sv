////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_write_read
// Project Name: AHB slave verification 
// Description: Targeted testcase read and write on known address and data
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_WRITE_READ_SV
`define AHB_WRITE_READ_SV
  
class AHB_write_read extends AHB_gen;
  //targeted testcase for write and read on known address and known data
  task run();
    //write operation for INCR4
    repeat(1) begin
      trans_h =new();
//      trans_copy = new trans_h;
      trans_h.haddr = {'h38, 'h3a, 'h3c, 'h3e};
      trans_h.hwdata = {'h12345678, 'h87654321, 'haaaaaaaa, 'h55555555};
      void'(trans_h.randomize() with {hburst_e == INCR4; hsize == 2; hwrite == 1;});
      gen2drv.put(trans_h);
      trans_h.print("Generator"); 
    //   #10;
    end 
    repeat(1) begin
      trans_h =new();
//      trans_copy = new trans_h;
      trans_h.haddr = {'h38, 'h3a, 'h3c, 'h3e};
      void'(trans_h.randomize() with {hburst_e == INCR4; hsize == 2; hwrite == 0;});
      gen2drv.put(trans_h);
      trans_h.print("Generator"); 
      // #10;
    end 
  endtask

endclass

`endif
