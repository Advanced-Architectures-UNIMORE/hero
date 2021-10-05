
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
 * Module: mmul_parallel_top.sv
 *
 */
import mmul_parallel_package::*;
import hwpe_ctrl_package::*;
module mmul_parallel_top
#(
  parameter int unsigned N_CORES = 2,
  parameter int unsigned MP  = 3,
  parameter int unsigned ID  = 10
)
(
  // Global signals
  input  logic          clk_i,
  input  logic          rst_ni,
  input  logic                        test_mode_i,
  // Events
  output logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt_o,
  // TCDM master ports
  hwpe_stream_intf_tcdm.master                  tcdm[MP-1:0],
  // Peripheral slave port
  hwpe_ctrl_intf_periph.slave                   periph
);
  // Signals
  logic enable, clear;
  logic [N_CORES-1:0][REGFILE_N_EVT-1:0] evt;
  ctrl_streamer_t  streamer_ctrl;
  flags_streamer_t streamer_flags;
  ctrl_engine_t    engine_ctrl;
  flags_engine_t   engine_flags;
  // Streamer interfaces
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_0 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_1 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_2 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_3 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_4 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_5 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_6 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_7 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_8 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_9 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_10 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_11 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_12 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_13 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_14 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in1_15 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_0 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_1 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_2 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_3 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_4 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_5 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_6 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_7 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_8 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_9 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_10 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_11 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_12 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_13 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_14 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) in2_15 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) out_r ( .clk (clk_i) );
  // HWPE engine wrapper
  mmul_parallel_engine i_engine (
    .clk_i            ( clk_i          ),
    .rst_ni           ( rst_ni         ),
    .test_mode_i      ( test_mode_i    ),
    .in1_0_i              ( in1_0.i       ),
    .in1_1_i              ( in1_1.i       ),
    .in1_2_i              ( in1_2.i       ),
    .in1_3_i              ( in1_3.i       ),
    .in1_4_i              ( in1_4.i       ),
    .in1_5_i              ( in1_5.i       ),
    .in1_6_i              ( in1_6.i       ),
    .in1_7_i              ( in1_7.i       ),
    .in1_8_i              ( in1_8.i       ),
    .in1_9_i              ( in1_9.i       ),
    .in1_10_i              ( in1_10.i       ),
    .in1_11_i              ( in1_11.i       ),
    .in1_12_i              ( in1_12.i       ),
    .in1_13_i              ( in1_13.i       ),
    .in1_14_i              ( in1_14.i       ),
    .in1_15_i              ( in1_15.i       ),
    .in2_0_i              ( in2_0.i       ),
    .in2_1_i              ( in2_1.i       ),
    .in2_2_i              ( in2_2.i       ),
    .in2_3_i              ( in2_3.i       ),
    .in2_4_i              ( in2_4.i       ),
    .in2_5_i              ( in2_5.i       ),
    .in2_6_i              ( in2_6.i       ),
    .in2_7_i              ( in2_7.i       ),
    .in2_8_i              ( in2_8.i       ),
    .in2_9_i              ( in2_9.i       ),
    .in2_10_i              ( in2_10.i       ),
    .in2_11_i              ( in2_11.i       ),
    .in2_12_i              ( in2_12.i       ),
    .in2_13_i              ( in2_13.i       ),
    .in2_14_i              ( in2_14.i       ),
    .in2_15_i              ( in2_15.i       ),
    .out_r_o              ( out_r.o       ),
    .ctrl_i           ( engine_ctrl    ),
    .flags_o          ( engine_flags   )
  );
  // HWPE streamer wrapper
  mmul_parallel_streamer #(
    .MP ( MP )
  ) i_streamer (
    .clk_i            ( clk_i          ),
    .rst_ni           ( rst_ni         ),
    .test_mode_i      ( test_mode_i    ),
    .enable_i         ( enable         ),
    .clear_i          ( clear          ),
    .in1_0              ( in1_0.o       ),
    .in1_1              ( in1_1.o       ),
    .in1_2              ( in1_2.o       ),
    .in1_3              ( in1_3.o       ),
    .in1_4              ( in1_4.o       ),
    .in1_5              ( in1_5.o       ),
    .in1_6              ( in1_6.o       ),
    .in1_7              ( in1_7.o       ),
    .in1_8              ( in1_8.o       ),
    .in1_9              ( in1_9.o       ),
    .in1_10              ( in1_10.o       ),
    .in1_11              ( in1_11.o       ),
    .in1_12              ( in1_12.o       ),
    .in1_13              ( in1_13.o       ),
    .in1_14              ( in1_14.o       ),
    .in1_15              ( in1_15.o       ),
    .in2_0              ( in2_0.o       ),
    .in2_1              ( in2_1.o       ),
    .in2_2              ( in2_2.o       ),
    .in2_3              ( in2_3.o       ),
    .in2_4              ( in2_4.o       ),
    .in2_5              ( in2_5.o       ),
    .in2_6              ( in2_6.o       ),
    .in2_7              ( in2_7.o       ),
    .in2_8              ( in2_8.o       ),
    .in2_9              ( in2_9.o       ),
    .in2_10              ( in2_10.o       ),
    .in2_11              ( in2_11.o       ),
    .in2_12              ( in2_12.o       ),
    .in2_13              ( in2_13.o       ),
    .in2_14              ( in2_14.o       ),
    .in2_15              ( in2_15.o       ),
    .out_r              ( out_r.i       ),
    .tcdm             ( tcdm           ),
    .ctrl_i           ( streamer_ctrl  ),
    .flags_o          ( streamer_flags )
  );
  // HWPE ctrl wrapper
  mmul_parallel_ctrl #(
    .N_CORES   ( 2  ),
    .N_CONTEXT ( 2  ),
    .N_IO_REGS ( 16 ),
    .ID ( ID )
  ) i_ctrl (
    .clk_i            ( clk_i          ),
    .rst_ni           ( rst_ni         ),
    .test_mode_i      ( test_mode_i    ),
    .clear_o          ( clear          ),
    .evt_o            ( evt_o          ),
    .ctrl_streamer_o  ( streamer_ctrl  ),
    .flags_streamer_i ( streamer_flags ),
    .ctrl_engine_o    ( engine_ctrl    ),
    .flags_engine_i   ( engine_flags   ),
    .periph           ( periph         )
  );
  assign enable = 1'b1;
endmodule