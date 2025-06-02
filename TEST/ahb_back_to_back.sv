


// guard statement to avoid multiple compilation of a file
`ifndef AHB_BACK2BACK_SV
`define AHB_BACK2BACK_SV

class ahb_back2back extends ahb_gen;
 
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
