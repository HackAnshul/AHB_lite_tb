
////////////////////////////////////////////////////////////////////////
//   File Name      : ahb_defines.sv                                  //
//   Author         : Anshul_Pandya                                   //
//   Project Name   : AHB_lite                                        //
//   Description    : File contains all the macros that need to be    //
//                    defined for the project.                        //
////////////////////////////////////////////////////////////////////////

//Gaurd Statment to avoid multiple compilation of a file
`ifndef AHB_DEFINES_SV
`define AHB_DEFINES_SV
//typedef RAM_DEFINES_SV

`define ADDR_WIDTH 12
`define DATA_WIDTH 32
`define MEM_WIDTH 8
`define DEPTH 4096


`define half_clk 2.5

`define sv_do(OBJ)\
      ``OBJ`` = new();\
    if (!``OBJ``.randomize())\
        $error("RANDOMIZATION FAILED!");\
    put_trans(``OBJ``);

`define sv_do_with(OBJ,CNSTR)\
      ``OBJ`` = new();\
      if (!``OBJ``.randomize() with ``CNSTR``)\
        $error("RANDOMIZATION FAILED!");\
    put_trans(``OBJ``);

`define sv_do_on(TEST_NAME,TEST_OBJ)\
    if ($test$plusargs(`"TEST_NAME`")) begin \
      ``TEST_OBJ`` = new();\
      void'(``TEST_OBJ``.randomize());\
      env.gen_h = ``TEST_OBJ``;\
    end

`define sv_do_on_with(TEST_NAME,TEST_OBJ,CNSTR)\
    if ($test$plusargs(`"TEST_NAME`")) begin \
      ``TEST_OBJ`` = new();\
      void'(``TEST_OBJ``.randomize() with ``CNSTR``);\
      env.gen_h = ``TEST_OBJ``;\
    end

`define ahb_checker(ACT_DATA,EXP_DATA)\
  if (``ACT_DATA`` == ``EXP_DATA``) begin\
    success++;\
    $info("Pass");\
  end else begin\
    failure++;\
    $error("Failed");\
  end

typedef enum bit [1:0] {IDLE, READ, WRITE, SIM_RW} trans_kind;

`endif
