////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_back2back
// Project Name: AHB slave verification 
// Description: Testcase for back to back write and followed by back to back read
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_BACK2BACK_SV
`define AHB_BACK2BACK_SV

class AHB_back2back extends AHB_gen;
 
  task run();
    //back to back write operation
    repeat(10) begin
      trans_h = new();
      void'(trans_h.randomize() with {hwrite == 1;});
      gen2drv.put(trans_h);
      trans_h.print("Generator");
    end

    repeat(10) begin
      trans_h = new();
      void'(trans_h.randomize() with {hwrite == 0;});
      gen2drv.put(trans_h);
      trans_h.print("Generator");
    end
  endtask

endclass

`endif
