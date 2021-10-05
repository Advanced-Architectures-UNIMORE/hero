
//
/*
 * HWPE: Francesco Conti <fconti@iis.ee.ethz.ch>
 *
 * Copyright (C) 2018 ETH Zurich, University of Bologna
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * HWPE author: Francesco Conti <fconti@iis.ee.ethz.ch>
 * HWPE specialization tool: Gianluca Bellocchi <gianluca.bellocchi@unimore.it>
 *
 * Module: mmul_parallel_ctrl.sv
 *
 */
import mmul_parallel_package::*;
import hwpe_ctrl_package::*;
module mmul_parallel_ctrl
#(
  parameter int unsigned N_CORES         = 2,
  parameter int unsigned N_CONTEXT       = 2,
  parameter int unsigned N_IO_REGS       = 16,
  parameter int unsigned ID              = 10,
  parameter int unsigned UCODE_HARDWIRED = 0
)
(  // Global signals
  input  logic                                  clk_i,
  input  logic                                  rst_ni,
  input  logic                                  test_mode_i,
  output logic                                  clear_o,
  // events
  output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,
  // ctrl & flags
  output ctrl_streamer_t                        ctrl_streamer_o,
  input  flags_streamer_t                       flags_streamer_i,
  output ctrl_engine_t                          ctrl_engine_o,
  input  flags_engine_t                         flags_engine_i,
  // periph slave port
  hwpe_ctrl_intf_periph.slave                   periph
);
  /* Ctrl/flag signals */
  // Slave
  ctrl_slave_t   slave_ctrl;
  flags_slave_t  slave_flags;
  // Register file
  ctrl_regfile_t reg_file;
  // Uloop
  logic [223:0]  ucode_flat;
  uloop_code_t   ucode;
  ctrl_uloop_t   ucode_ctrl;
  flags_uloop_t  ucode_flags;
  logic [11:0][31:0] ucode_registers_read;
  /* Standard registers */
  // Uloop
  logic unsigned [31:0] static_reg_nb_iter;
  logic unsigned [31:0] static_reg_vectstride;
  logic unsigned [31:0] static_reg_onestride;
  logic unsigned [15:0] static_reg_shift;
  // FSM
  logic unsigned [31:0] static_reg_cnt_limit;
  // Address generator
  // Controls - in1
  logic unsigned [31:0] static_reg_in1_trans_size;
  logic unsigned [31:0] static_reg_in1_line_stride;
  logic unsigned [31:0] static_reg_in1_line_length;
  logic unsigned [31:0] static_reg_in1_feat_stride;
  logic unsigned [31:0] static_reg_in1_feat_length;
  logic unsigned [31:0] static_reg_in1_feat_roll;
  logic unsigned [31:0] static_reg_in1_loop_outer;
  logic unsigned [31:0] static_reg_in1_realign_type;
  logic unsigned [31:0] static_reg_in1_port_offset;
  logic unsigned [31:0] static_reg_in1_step;
  // Controls - in2
  logic unsigned [31:0] static_reg_in2_trans_size;
  logic unsigned [31:0] static_reg_in2_line_stride;
  logic unsigned [31:0] static_reg_in2_line_length;
  logic unsigned [31:0] static_reg_in2_feat_stride;
  logic unsigned [31:0] static_reg_in2_feat_length;
  logic unsigned [31:0] static_reg_in2_feat_roll;
  logic unsigned [31:0] static_reg_in2_loop_outer;
  logic unsigned [31:0] static_reg_in2_realign_type;
  logic unsigned [31:0] static_reg_in2_port_offset;
  logic unsigned [31:0] static_reg_in2_step;
  // Controls - out_r
  logic unsigned [31:0] static_reg_out_r_trans_size;
  logic unsigned [31:0] static_reg_out_r_line_stride;
  logic unsigned [31:0] static_reg_out_r_line_length;
  logic unsigned [31:0] static_reg_out_r_feat_stride;
  logic unsigned [31:0] static_reg_out_r_feat_length;
  logic unsigned [31:0] static_reg_out_r_feat_roll;
  logic unsigned [31:0] static_reg_out_r_loop_outer;
  logic unsigned [31:0] static_reg_out_r_realign_type;
  /* FSM input signals */
  ctrl_fsm_t fsm_ctrl;
  /* Peripheral slave & register file */
  hwpe_ctrl_slave #(
    .N_CORES        ( N_CORES               ),
    .N_CONTEXT      ( N_CONTEXT             ),
    .N_IO_REGS      ( N_IO_REGS             ),
    .N_GENERIC_REGS ( (1-UCODE_HARDWIRED)*8 ),
    .ID_WIDTH       ( ID                    )
  ) i_slave (
    .clk_i    ( clk_i       ),
    .rst_ni   ( rst_ni      ),
    .clear_o  ( clear_o     ),
    .cfg      ( periph      ),
    .ctrl_i   ( slave_ctrl  ),
    .flags_o  ( slave_flags ),
    .reg_file ( reg_file    )
  );
  /* Events */
  assign evt_o = slave_flags.evt;
  /* Direct register file mappings */
  // Uloop registers
  assign static_reg_nb_iter    = reg_file.hwpe_params[MMUL_PARALLEL_REG_NB_ITER]  + 1;
  assign static_reg_linestride = reg_file.hwpe_params[MMUL_PARALLEL_REG_SHIFT_LINESTRIDE];
  assign static_reg_tilestride = reg_file.hwpe_params[MMUL_PARALLEL_REG_SHIFT_TILESTRIDE];
  assign static_reg_onestride  = 4;
  // FSM signals
  assign static_reg_cnt_limit = reg_file.hwpe_params[MMUL_PARALLEL_REG_CNT_LIMIT] + 1;
  // Address generator
  // Mapping - in1
  assign static_in1_trans_size          = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_TRANS_SIZE];
  assign static_in1_line_stride         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_LINE_STRIDE];
  assign static_in1_line_length         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_LINE_LENGTH];
  assign static_in1_feat_stride         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_FEAT_STRIDE];
  assign static_in1_feat_length         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_FEAT_LENGTH];
  assign static_in1_feat_roll           = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_FEAT_ROLL];
  assign static_in1_loop_outer          = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_LOOP_OUTER];
  assign static_in1_realign_type        = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_REALIGN_TYPE];
  assign static_reg_in1_port_offset     = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_PORT_OFFSET];
  assign static_reg_in1_step            = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN1_STEP];
  // Mapping - in2
  assign static_in2_trans_size          = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_TRANS_SIZE];
  assign static_in2_line_stride         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_LINE_STRIDE];
  assign static_in2_line_length         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_LINE_LENGTH];
  assign static_in2_feat_stride         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_FEAT_STRIDE];
  assign static_in2_feat_length         = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_FEAT_LENGTH];
  assign static_in2_feat_roll           = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_FEAT_ROLL];
  assign static_in2_loop_outer          = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_LOOP_OUTER];
  assign static_in2_realign_type        = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_REALIGN_TYPE];
  assign static_reg_in2_port_offset     = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_PORT_OFFSET];
  assign static_reg_in2_step            = reg_file.hwpe_params[MMUL_PARALLEL_REG_IN2_STEP];
  // Mapping - out_r
  assign static_out_r_trans_size         = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_TRANS_SIZE];
  assign static_out_r_line_stride        = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_LINE_STRIDE];
  assign static_out_r_line_length        = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_LINE_LENGTH];
  assign static_out_r_feat_stride        = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_FEAT_STRIDE];
  assign static_out_r_feat_length        = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_FEAT_LENGTH];
  assign static_out_r_feat_roll          = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_FEAT_ROLL];
  assign static_out_r_loop_outer         = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_LOOP_OUTER];
  assign static_out_r_realign_type       = reg_file.hwpe_params[MMUL_PARALLEL_REG_OUT_R_REALIGN_TYPE];
  /* Microcode processor */
  generate
    if(UCODE_HARDWIRED != 0) begin
      // equivalent to the microcode in ucode/code.yml
      assign ucode_flat = 224'h0000000000040000000000000000000000000000000008cd11a12c05;
    end
    else begin
      // the microcode is stored in registers independent of context (job)
      assign ucode_flat = reg_file.generic_params[6:0];
    end
  endgenerate
  assign ucode = {
    // loops & bytecode
    ucode_flat,
    // ranges
    12'b0,
    12'b0,
    12'b0,
    12'b0,
    12'b0,
    static_reg_nb_iter[11:0]
  };
  assign ucode_registers_read[MMUL_PARALLEL_UCODE_MNEM_NBITER]     = static_reg_nb_iter;
  assign ucode_registers_read[MMUL_PARALLEL_UCODE_MNEM_ITERSTRIDE] = static_reg_linestride;
  assign ucode_registers_read[MMUL_PARALLEL_UCODE_MNEM_ONESTRIDE]  = static_reg_onestride;
  assign ucode_registers_read[MMUL_PARALLEL_UCODE_MNEM_TILESTRIDE] = static_reg_tilestride;
  assign ucode_registers_read[11:4] = '0;
  hwpe_ctrl_uloop #(
    .NB_LOOPS       ( 1  ), // Default: 1
    .NB_REG         ( 4  ),
    .NB_RO_REG      ( 12 ),
    .DEBUG_DISPLAY  ( 0  )  // Default: 0
  ) i_uloop (
    .clk_i            ( clk_i                ),
    .rst_ni           ( rst_ni               ),
    .test_mode_i      ( test_mode_i          ),
    .clear_i          ( clear_o              ),
    .ctrl_i           ( ucode_ctrl           ),
    .flags_o          ( ucode_flags          ),
    .uloop_code_i     ( ucode                ),
    .registers_read_i ( ucode_registers_read )
  );
  /* Main FSM */
  mmul_parallel_fsm i_fsm (
    .clk_i            ( clk_i              ),
    .rst_ni           ( rst_ni             ),
    .test_mode_i      ( test_mode_i        ),
    .clear_i          ( clear_o            ),
    .ctrl_streamer_o  ( ctrl_streamer_o    ),
    .flags_streamer_i ( flags_streamer_i   ),
    .ctrl_engine_o    ( ctrl_engine_o      ),
    .flags_engine_i   ( flags_engine_i     ),
    .ctrl_ucode_o     ( ucode_ctrl         ),
    .flags_ucode_i    ( ucode_flags        ),
    .ctrl_slave_o     ( slave_ctrl         ),
    .flags_slave_i    ( slave_flags        ),
    .reg_file_i       ( reg_file           ),
    .ctrl_i           ( fsm_ctrl           )
  );
  always_comb
  begin
    /* Custom register file mappings to FSM */
    fsm_ctrl.cnt_limit        = static_reg_cnt_limit;
    // Address generator
    // Mapping - in1
    fsm_ctrl.in1_trans_size     = static_in1_trans_size;
    fsm_ctrl.in1_line_stride    = static_in1_line_stride;
    fsm_ctrl.in1_line_length    = static_in1_line_length;
    fsm_ctrl.in1_feat_stride    = static_in1_feat_stride;
    fsm_ctrl.in1_feat_length    = static_in1_feat_length;
    fsm_ctrl.in1_feat_roll      = static_in1_feat_roll;
    fsm_ctrl.in1_loop_outer     = static_in1_loop_outer;
    fsm_ctrl.in1_realign_type   = static_in1_realign_type;
    fsm_ctrl.in1_port_offset    = static_in1_port_offset;
    fsm_ctrl.in1_step           = static_in1_step;
    // Mapping - in2
    fsm_ctrl.in2_trans_size     = static_in2_trans_size;
    fsm_ctrl.in2_line_stride    = static_in2_line_stride;
    fsm_ctrl.in2_line_length    = static_in2_line_length;
    fsm_ctrl.in2_feat_stride    = static_in2_feat_stride;
    fsm_ctrl.in2_feat_length    = static_in2_feat_length;
    fsm_ctrl.in2_feat_roll      = static_in2_feat_roll;
    fsm_ctrl.in2_loop_outer     = static_in2_loop_outer;
    fsm_ctrl.in2_realign_type   = static_in2_realign_type;
    fsm_ctrl.in2_port_offset    = static_in2_port_offset;
    fsm_ctrl.in2_step           = static_in2_step;
    // Mapping - out_r
    fsm_ctrl.out_r_trans_size     = static_out_r_trans_size;
    fsm_ctrl.out_r_line_stride    = static_out_r_line_stride;
    fsm_ctrl.out_r_line_length    = static_out_r_line_length;
    fsm_ctrl.out_r_feat_stride    = static_out_r_feat_stride;
    fsm_ctrl.out_r_feat_length    = static_out_r_feat_length;
    fsm_ctrl.out_r_feat_roll      = static_out_r_feat_roll;
    fsm_ctrl.out_r_loop_outer     = static_out_r_loop_outer;
    fsm_ctrl.out_r_realign_type   = static_out_r_realign_type;
  end
endmodule