
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
 * Module: mmul_parallel_package.sv
 *
 */
import hwpe_stream_package::*;
package mmul_parallel_package;
  parameter int unsigned MMUL_PARALLEL_CNT_LEN = 1024; // maximum length of the vectors for a scalar product
  /* Registers */
  // Standard registers
  parameter int unsigned MMUL_PARALLEL_REG_NB_ITER              = 0;
  parameter int unsigned MMUL_PARALLEL_REG_SHIFT_LINESTRIDE     = 1;
  parameter int unsigned MMUL_PARALLEL_REG_SHIFT_TILESTRIDE     = 2;
  parameter int unsigned MMUL_PARALLEL_REG_CNT_LIMIT            = 3;
    // Input stream - in1 (unrolled, programmable)
    parameter int unsigned MMUL_PARALLEL_REG_IN1_TRANS_SIZE       = 4;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_LINE_STRIDE      = 5;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_LINE_LENGTH      = 6;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_FEAT_STRIDE      = 7;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_FEAT_LENGTH      = 8;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_FEAT_ROLL        = 9;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_LOOP_OUTER       = 10;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_REALIGN_TYPE     = 11;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_PORT_OFFSET      = 12;
    parameter int unsigned MMUL_PARALLEL_REG_IN1_STEP             = 13;
    // Input stream - in2 (unrolled, programmable)
    parameter int unsigned MMUL_PARALLEL_REG_IN2_TRANS_SIZE       = 14;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_LINE_STRIDE      = 15;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_LINE_LENGTH      = 16;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_FEAT_STRIDE      = 17;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_FEAT_LENGTH      = 18;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_FEAT_ROLL        = 19;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_LOOP_OUTER       = 20;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_REALIGN_TYPE     = 21;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_PORT_OFFSET      = 22;
    parameter int unsigned MMUL_PARALLEL_REG_IN2_STEP             = 23;
    // Output stream - out_r (programmable)
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_TRANS_SIZE       = 24;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_LINE_STRIDE      = 25;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_LINE_LENGTH      = 26;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_FEAT_STRIDE      = 27;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_FEAT_LENGTH      = 28;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_FEAT_ROLL        = 29;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_LOOP_OUTER       = 30;
    parameter int unsigned MMUL_PARALLEL_REG_OUT_R_REALIGN_TYPE     = 31;
  // TCDM
  // Input ports
  parameter int unsigned MMUL_PARALLEL_REG_IN1_ADDR                = 32;
  parameter int unsigned MMUL_PARALLEL_REG_IN2_ADDR                = 33;
  // Output ports
  parameter int unsigned MMUL_PARALLEL_REG_OUT_R_ADDR                = 34;
  /* Microcode processor */
  // offset indeces -- this should be aligned to the microcode compiler of course!
  parameter int unsigned MMUL_PARALLEL_UCODE_IN1_OFFS               = 0;
  parameter int unsigned MMUL_PARALLEL_UCODE_IN2_OFFS               = 1;
  parameter int unsigned MMUL_PARALLEL_UCODE_OUT_R_OFFS              = 2;
  // mnemonics -- this should be aligned to the microcode compiler of course!
  parameter int unsigned MMUL_PARALLEL_UCODE_MNEM_NBITER      = 0;
  parameter int unsigned MMUL_PARALLEL_UCODE_MNEM_ITERSTRIDE  = 1;
  parameter int unsigned MMUL_PARALLEL_UCODE_MNEM_ONESTRIDE   = 2;
  parameter int unsigned MMUL_PARALLEL_UCODE_MNEM_TILESTRIDE  = 3;
  /* Typedefs */
  typedef struct packed {
    logic clear;
    logic enable;
    logic start;
    logic unsigned [$clog2(MMUL_PARALLEL_CNT_LEN):0] cnt_limit;
  } ctrl_engine_t;
  typedef struct packed {
    logic unsigned [$clog2(MMUL_PARALLEL_OUT_R_CNT_LEN):0] cnt_out_r;
    logic done;
    logic idle;
    logic ready;
  } flags_engine_t;
  typedef struct packed {
    hwpe_stream_package::ctrl_sourcesink_t in1_0_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_1_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_2_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_3_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_4_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_5_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_6_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_7_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_8_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_9_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_10_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_11_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_12_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_13_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_14_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in1_15_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_0_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_1_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_2_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_3_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_4_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_5_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_6_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_7_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_8_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_9_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_10_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_11_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_12_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_13_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_14_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t in2_15_source_ctrl;
    hwpe_stream_package::ctrl_sourcesink_t out_r_sink_ctrl;
  } ctrl_streamer_t;
  typedef struct packed {
    hwpe_stream_package::flags_sourcesink_t in1_0_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_1_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_2_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_3_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_4_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_5_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_6_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_7_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_8_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_9_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_10_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_11_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_12_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_13_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_14_source_flags;
    hwpe_stream_package::flags_sourcesink_t in1_15_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_0_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_1_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_2_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_3_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_4_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_5_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_6_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_7_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_8_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_9_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_10_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_11_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_12_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_13_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_14_source_flags;
    hwpe_stream_package::flags_sourcesink_t in2_15_source_flags;
    hwpe_stream_package::flags_sourcesink_t out_r_sink_flags;
  } flags_streamer_t;
  typedef struct packed {
    // Input stream - in1 (unrolled, programmable)
    logic unsigned [31:0] in1_trans_size;
    logic unsigned [31:0] in1_line_stride;
    logic unsigned [31:0] in1_line_length;
    logic unsigned [31:0] in1_feat_stride;
    logic unsigned [31:0] in1_feat_length;
    logic unsigned [31:0] in1_feat_roll;
    logic unsigned [31:0] in1_loop_outer;
    logic unsigned [31:0] in1_realign_type;
    logic unsigned [31:0] in1_port_offset;
    logic unsigned [31:0] in1_step;
    // Input stream - in2 (unrolled, programmable)
    logic unsigned [31:0] in2_trans_size;
    logic unsigned [31:0] in2_line_stride;
    logic unsigned [31:0] in2_line_length;
    logic unsigned [31:0] in2_feat_stride;
    logic unsigned [31:0] in2_feat_length;
    logic unsigned [31:0] in2_feat_roll;
    logic unsigned [31:0] in2_loop_outer;
    logic unsigned [31:0] in2_realign_type;
    logic unsigned [31:0] in2_port_offset;
    logic unsigned [31:0] in2_step;
    // Output stream - out_r (programmable)
    logic unsigned [31:0] out_r_trans_size;
    logic unsigned [31:0] out_r_line_stride;
    logic unsigned [31:0] out_r_line_length;
    logic unsigned [31:0] out_r_feat_stride;
    logic unsigned [31:0] out_r_feat_length;
    logic unsigned [31:0] out_r_feat_roll;
    logic unsigned [31:0] out_r_loop_outer;
    logic unsigned [31:0] out_r_realign_type;
    // Computation
    logic unsigned [$clog2(MMUL_PARALLEL_CNT_LEN):0] cnt_limit;
  } ctrl_fsm_t;
  typedef enum {
    FSM_IDLE,
    FSM_START,
    FSM_COMPUTE,
    FSM_WAIT,
    FSM_UPDATEIDX,
    FSM_TERMINATE
  } state_fsm_t;
endpackage