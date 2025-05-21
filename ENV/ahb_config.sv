
////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_config.sv                                   //
//   Author         : Anshul Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    :  //
//                                                                    //
////////////////////////////////////////////////////////////////////////


`ifndef AHB_CONFIG_SV
`define AHB_CONFIG_SV

class ahb_config;
  static bit pipe_status;

  static function set_pipeline(bit stat);
    pipe_status = stat;
  endfunction

endclass



`endif
