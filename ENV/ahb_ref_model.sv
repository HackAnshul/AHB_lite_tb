`ifndef AHB_REF_MOD_SV
`define AHB_REF_MOD_SV
class ahb_ref_model;

  ahb_trans trans_h1,trans_h2;

  //reference memory
  bit [`MEM_WIDTH - 1:0] mem [`MEM_DEPTH - 1:0];

  mailbox #(ahb_trans) mon2rf;
  mailbox #(ahb_trans) ref2sb;

  function void connect (mailbox #(ahb_trans) mon2rf,
                         mailbox #(ahb_trans) ref2sb);
    this.mon2rf = mon2rf;
    this.ref2sb = ref2sb;
  endfunction

  task run();
    forever begin
      mon2rf.get(trans_h1);
      trans_h2 = new trans_h1;
      predict_data(trans_h2);
      ref2sb.put(trans_h2);
      //trans_h2.print("ref model");

   end
  endtask

  task predict_data(ahb_trans trans_h);

    int addr_ext = 2**trans_h.hsize;
    bit[`DATA_WIDTH-1:0] temp_data;
    for (int i = 0; i< trans_h.calc_txf; i++) begin
      if (trans_h.hwrite) begin
        temp_data = trans_h.hwdata.pop_front();
        for (int j = 0; j < addr_ext; j++)
          mem [trans_h.haddr[i]+j] = temp_data[(j*8)+:8];
      end
      else begin
        for (int j = 0; j < addr_ext; j++)
          temp_data[(j*8)+:8] = mem [trans_h.haddr[i]+j];
        trans_h.hrdata.push_back(temp_data);
      end
    end
  endtask

 endclass
`endif
