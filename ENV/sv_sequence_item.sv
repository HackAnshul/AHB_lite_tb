
//Header


`ifndef SV_SEQUENCE_ITEM
`define SV_SEQUENCE_ITEM

virtual class sv_sequence_item;

  virtual function void copy(sv_sequence_item rhs);
  endfunction

  pure virtual function void print(sv_sequence_item rhs, string block);


endclass

`endif
