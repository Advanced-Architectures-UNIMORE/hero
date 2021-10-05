
//
/*
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
 * Module: mmul_parallel_streamer.sv
 *
 */
import mmul_parallel_package::*;
import hwpe_stream_package::*;
module mmul_parallel_streamer
#(
  parameter int unsigned MP  = 3, // number of master ports
  parameter int unsigned FD  = 2 // FIFO depth
)
(
  // Global signals
  input  logic          clk_i,
  input  logic          rst_ni,
  input  logic          test_mode_i,
  // Local enable & clear
  input  logic          enable_i,
  input  logic          clear_i,
  // TCDM interface
  hwpe_stream_intf_tcdm.master tcdm [MP-1:0],
  // Streaming interfaces
  hwpe_stream_intf_stream.source in1_0,
  hwpe_stream_intf_stream.source in1_1,
  hwpe_stream_intf_stream.source in1_2,
  hwpe_stream_intf_stream.source in1_3,
  hwpe_stream_intf_stream.source in1_4,
  hwpe_stream_intf_stream.source in1_5,
  hwpe_stream_intf_stream.source in1_6,
  hwpe_stream_intf_stream.source in1_7,
  hwpe_stream_intf_stream.source in1_8,
  hwpe_stream_intf_stream.source in1_9,
  hwpe_stream_intf_stream.source in1_10,
  hwpe_stream_intf_stream.source in1_11,
  hwpe_stream_intf_stream.source in1_12,
  hwpe_stream_intf_stream.source in1_13,
  hwpe_stream_intf_stream.source in1_14,
  hwpe_stream_intf_stream.source in1_15,
  hwpe_stream_intf_stream.source in2_0,
  hwpe_stream_intf_stream.source in2_1,
  hwpe_stream_intf_stream.source in2_2,
  hwpe_stream_intf_stream.source in2_3,
  hwpe_stream_intf_stream.source in2_4,
  hwpe_stream_intf_stream.source in2_5,
  hwpe_stream_intf_stream.source in2_6,
  hwpe_stream_intf_stream.source in2_7,
  hwpe_stream_intf_stream.source in2_8,
  hwpe_stream_intf_stream.source in2_9,
  hwpe_stream_intf_stream.source in2_10,
  hwpe_stream_intf_stream.source in2_11,
  hwpe_stream_intf_stream.source in2_12,
  hwpe_stream_intf_stream.source in2_13,
  hwpe_stream_intf_stream.source in2_14,
  hwpe_stream_intf_stream.source in2_15,
  hwpe_stream_intf_stream.sink out_r,
  // control channel
  input  ctrl_streamer_t  ctrl_i,
  output flags_streamer_t flags_o
);
  // TCDM ready signals
  logic tcdm_fifo_ready_in1_0;
  logic tcdm_fifo_ready_in1_1;
  logic tcdm_fifo_ready_in1_2;
  logic tcdm_fifo_ready_in1_3;
  logic tcdm_fifo_ready_in1_4;
  logic tcdm_fifo_ready_in1_5;
  logic tcdm_fifo_ready_in1_6;
  logic tcdm_fifo_ready_in1_7;
  logic tcdm_fifo_ready_in1_8;
  logic tcdm_fifo_ready_in1_9;
  logic tcdm_fifo_ready_in1_10;
  logic tcdm_fifo_ready_in1_11;
  logic tcdm_fifo_ready_in1_12;
  logic tcdm_fifo_ready_in1_13;
  logic tcdm_fifo_ready_in1_14;
  logic tcdm_fifo_ready_in1_15;
  logic tcdm_fifo_ready_in2_0;
  logic tcdm_fifo_ready_in2_1;
  logic tcdm_fifo_ready_in2_2;
  logic tcdm_fifo_ready_in2_3;
  logic tcdm_fifo_ready_in2_4;
  logic tcdm_fifo_ready_in2_5;
  logic tcdm_fifo_ready_in2_6;
  logic tcdm_fifo_ready_in2_7;
  logic tcdm_fifo_ready_in2_8;
  logic tcdm_fifo_ready_in2_9;
  logic tcdm_fifo_ready_in2_10;
  logic tcdm_fifo_ready_in2_11;
  logic tcdm_fifo_ready_in2_12;
  logic tcdm_fifo_ready_in2_13;
  logic tcdm_fifo_ready_in2_14;
  logic tcdm_fifo_ready_in2_15;
  // TCDM interface
  hwpe_stream_intf_tcdm tcdm_fifo_in1_0 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_1 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_2 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_3 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_4 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_5 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_6 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_7 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_8 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_9 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_10 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_11 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_12 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_13 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_14 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in1_15 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_0 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_1 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_2 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_3 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_4 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_5 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_6 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_7 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_8 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_9 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_10 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_11 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_12 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_13 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_14 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_in2_15 ( .clk (clk_i) );
  hwpe_stream_intf_tcdm tcdm_fifo_out_r ( .clk (clk_i) );
  // Streaming interface
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_0 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_1 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_2 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_3 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_4 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_5 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_6 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_7 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_8 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_9 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_10 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_11 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_12 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_13 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_14 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in1_15 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_0 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_1 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_2 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_3 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_4 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_5 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_6 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_7 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_8 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_9 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_10 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_11 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_12 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_13 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_14 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_in2_15 ( .clk (clk_i) );
  hwpe_stream_intf_stream #( .DATA_WIDTH(32) ) stream_fifo_out_r ( .clk (clk_i) );
  // TCDM-side FIFO - Inputs
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_0_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_0     ),
    .tcdm_slave  ( tcdm_fifo_in1_0           ),
    .tcdm_master ( tcdm[0]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_1_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_1     ),
    .tcdm_slave  ( tcdm_fifo_in1_1           ),
    .tcdm_master ( tcdm[1]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_2_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_2     ),
    .tcdm_slave  ( tcdm_fifo_in1_2           ),
    .tcdm_master ( tcdm[2]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_3_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_3     ),
    .tcdm_slave  ( tcdm_fifo_in1_3           ),
    .tcdm_master ( tcdm[3]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_4_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_4     ),
    .tcdm_slave  ( tcdm_fifo_in1_4           ),
    .tcdm_master ( tcdm[4]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_5_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_5     ),
    .tcdm_slave  ( tcdm_fifo_in1_5           ),
    .tcdm_master ( tcdm[5]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_6_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_6     ),
    .tcdm_slave  ( tcdm_fifo_in1_6           ),
    .tcdm_master ( tcdm[6]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_7_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_7     ),
    .tcdm_slave  ( tcdm_fifo_in1_7           ),
    .tcdm_master ( tcdm[7]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_8_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_8     ),
    .tcdm_slave  ( tcdm_fifo_in1_8           ),
    .tcdm_master ( tcdm[8]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_9_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_9     ),
    .tcdm_slave  ( tcdm_fifo_in1_9           ),
    .tcdm_master ( tcdm[9]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_10_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_10     ),
    .tcdm_slave  ( tcdm_fifo_in1_10           ),
    .tcdm_master ( tcdm[10]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_11_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_11     ),
    .tcdm_slave  ( tcdm_fifo_in1_11           ),
    .tcdm_master ( tcdm[11]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_12_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_12     ),
    .tcdm_slave  ( tcdm_fifo_in1_12           ),
    .tcdm_master ( tcdm[12]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_13_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_13     ),
    .tcdm_slave  ( tcdm_fifo_in1_13           ),
    .tcdm_master ( tcdm[13]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_14_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_14     ),
    .tcdm_slave  ( tcdm_fifo_in1_14           ),
    .tcdm_master ( tcdm[14]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in1_15_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in1_15     ),
    .tcdm_slave  ( tcdm_fifo_in1_15           ),
    .tcdm_master ( tcdm[15]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_0_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_0     ),
    .tcdm_slave  ( tcdm_fifo_in2_0           ),
    .tcdm_master ( tcdm[16]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_1_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_1     ),
    .tcdm_slave  ( tcdm_fifo_in2_1           ),
    .tcdm_master ( tcdm[17]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_2_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_2     ),
    .tcdm_slave  ( tcdm_fifo_in2_2           ),
    .tcdm_master ( tcdm[18]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_3_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_3     ),
    .tcdm_slave  ( tcdm_fifo_in2_3           ),
    .tcdm_master ( tcdm[19]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_4_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_4     ),
    .tcdm_slave  ( tcdm_fifo_in2_4           ),
    .tcdm_master ( tcdm[20]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_5_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_5     ),
    .tcdm_slave  ( tcdm_fifo_in2_5           ),
    .tcdm_master ( tcdm[21]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_6_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_6     ),
    .tcdm_slave  ( tcdm_fifo_in2_6           ),
    .tcdm_master ( tcdm[22]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_7_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_7     ),
    .tcdm_slave  ( tcdm_fifo_in2_7           ),
    .tcdm_master ( tcdm[23]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_8_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_8     ),
    .tcdm_slave  ( tcdm_fifo_in2_8           ),
    .tcdm_master ( tcdm[24]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_9_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_9     ),
    .tcdm_slave  ( tcdm_fifo_in2_9           ),
    .tcdm_master ( tcdm[25]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_10_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_10     ),
    .tcdm_slave  ( tcdm_fifo_in2_10           ),
    .tcdm_master ( tcdm[26]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_11_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_11     ),
    .tcdm_slave  ( tcdm_fifo_in2_11           ),
    .tcdm_master ( tcdm[27]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_12_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_12     ),
    .tcdm_slave  ( tcdm_fifo_in2_12           ),
    .tcdm_master ( tcdm[28]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_13_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_13     ),
    .tcdm_slave  ( tcdm_fifo_in2_13           ),
    .tcdm_master ( tcdm[29]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_14_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_14     ),
    .tcdm_slave  ( tcdm_fifo_in2_14           ),
    .tcdm_master ( tcdm[30]                     )
  );
  hwpe_stream_tcdm_fifo_load #(
    .FIFO_DEPTH ( 4 )
  ) i_in2_15_tcdm_fifo_load (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_in2_15     ),
    .tcdm_slave  ( tcdm_fifo_in2_15           ),
    .tcdm_master ( tcdm[31]                     )
  );
  // TCDM-side FIFO - Outputs
  hwpe_stream_tcdm_fifo_store #(
    .FIFO_DEPTH ( 4 )
  ) i_out_r_tcdm_fifo_store (
    .clk_i       ( clk_i                                    ),
    .rst_ni      ( rst_ni                                   ),
    .clear_i     ( clear_i                                  ),
    .flags_o     (                                          ),
    .ready_i     ( tcdm_fifo_ready_out_r          ),
    .tcdm_slave  ( tcdm_fifo_out_r                ),
    .tcdm_master ( tcdm[32]                     )
  );
  // Engine-side FIFO - Inputs
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_0_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_0.sink      ),
    .pop_o   ( in1_0                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_1_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_1.sink      ),
    .pop_o   ( in1_1                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_2_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_2.sink      ),
    .pop_o   ( in1_2                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_3_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_3.sink      ),
    .pop_o   ( in1_3                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_4_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_4.sink      ),
    .pop_o   ( in1_4                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_5_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_5.sink      ),
    .pop_o   ( in1_5                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_6_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_6.sink      ),
    .pop_o   ( in1_6                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_7_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_7.sink      ),
    .pop_o   ( in1_7                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_8_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_8.sink      ),
    .pop_o   ( in1_8                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_9_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_9.sink      ),
    .pop_o   ( in1_9                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_10_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_10.sink      ),
    .pop_o   ( in1_10                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_11_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_11.sink      ),
    .pop_o   ( in1_11                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_12_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_12.sink      ),
    .pop_o   ( in1_12                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_13_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_13.sink      ),
    .pop_o   ( in1_13                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_14_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_14.sink      ),
    .pop_o   ( in1_14                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in1_15_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1_15.sink      ),
    .pop_o   ( in1_15                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_0_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_0.sink      ),
    .pop_o   ( in2_0                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_1_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_1.sink      ),
    .pop_o   ( in2_1                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_2_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_2.sink      ),
    .pop_o   ( in2_2                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_3_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_3.sink      ),
    .pop_o   ( in2_3                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_4_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_4.sink      ),
    .pop_o   ( in2_4                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_5_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_5.sink      ),
    .pop_o   ( in2_5                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_6_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_6.sink      ),
    .pop_o   ( in2_6                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_7_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_7.sink      ),
    .pop_o   ( in2_7                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_8_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_8.sink      ),
    .pop_o   ( in2_8                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_9_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_9.sink      ),
    .pop_o   ( in2_9                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_10_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_10.sink      ),
    .pop_o   ( in2_10                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_11_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_11.sink      ),
    .pop_o   ( in2_11                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_12_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_12.sink      ),
    .pop_o   ( in2_12                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_13_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_13.sink      ),
    .pop_o   ( in2_13                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_14_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_14.sink      ),
    .pop_o   ( in2_14                       ),
    .flags_o (                                            )
  );
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_in2_15_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in2_15.sink      ),
    .pop_o   ( in2_15                       ),
    .flags_o (                                            )
  );
  // Engine-side FIFO - Outputs
  hwpe_stream_fifo #(
    .DATA_WIDTH( 32 ),
    .FIFO_DEPTH( 2  ),
    .LATCH_FIFO( 0  )
  ) i_out_r_stream_fifo (
    .clk_i   ( clk_i                                      ),
    .rst_ni  ( rst_ni                                     ),
    .clear_i ( clear_i                                    ),
    .push_i  ( stream_fifo_in1.source         ),
    .pop_o   ( out_r                           ),
    .flags_o (                                            )
  );
  // Source modules (TCDM -> HWPE)
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_0_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_0              ),
    .stream             ( stream_fifo_in1_0.source     ),
    .ctrl_i             ( ctrl_i.in1_0_source_ctrl     ),
    .flags_o            ( flags_o.in1_0_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_0        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_1_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_1              ),
    .stream             ( stream_fifo_in1_1.source     ),
    .ctrl_i             ( ctrl_i.in1_1_source_ctrl     ),
    .flags_o            ( flags_o.in1_1_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_1        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_2_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_2              ),
    .stream             ( stream_fifo_in1_2.source     ),
    .ctrl_i             ( ctrl_i.in1_2_source_ctrl     ),
    .flags_o            ( flags_o.in1_2_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_2        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_3_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_3              ),
    .stream             ( stream_fifo_in1_3.source     ),
    .ctrl_i             ( ctrl_i.in1_3_source_ctrl     ),
    .flags_o            ( flags_o.in1_3_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_3        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_4_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_4              ),
    .stream             ( stream_fifo_in1_4.source     ),
    .ctrl_i             ( ctrl_i.in1_4_source_ctrl     ),
    .flags_o            ( flags_o.in1_4_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_4        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_5_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_5              ),
    .stream             ( stream_fifo_in1_5.source     ),
    .ctrl_i             ( ctrl_i.in1_5_source_ctrl     ),
    .flags_o            ( flags_o.in1_5_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_5        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_6_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_6              ),
    .stream             ( stream_fifo_in1_6.source     ),
    .ctrl_i             ( ctrl_i.in1_6_source_ctrl     ),
    .flags_o            ( flags_o.in1_6_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_6        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_7_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_7              ),
    .stream             ( stream_fifo_in1_7.source     ),
    .ctrl_i             ( ctrl_i.in1_7_source_ctrl     ),
    .flags_o            ( flags_o.in1_7_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_7        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_8_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_8              ),
    .stream             ( stream_fifo_in1_8.source     ),
    .ctrl_i             ( ctrl_i.in1_8_source_ctrl     ),
    .flags_o            ( flags_o.in1_8_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_8        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_9_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_9              ),
    .stream             ( stream_fifo_in1_9.source     ),
    .ctrl_i             ( ctrl_i.in1_9_source_ctrl     ),
    .flags_o            ( flags_o.in1_9_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_9        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_10_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_10              ),
    .stream             ( stream_fifo_in1_10.source     ),
    .ctrl_i             ( ctrl_i.in1_10_source_ctrl     ),
    .flags_o            ( flags_o.in1_10_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_10        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_11_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_11              ),
    .stream             ( stream_fifo_in1_11.source     ),
    .ctrl_i             ( ctrl_i.in1_11_source_ctrl     ),
    .flags_o            ( flags_o.in1_11_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_11        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_12_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_12              ),
    .stream             ( stream_fifo_in1_12.source     ),
    .ctrl_i             ( ctrl_i.in1_12_source_ctrl     ),
    .flags_o            ( flags_o.in1_12_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_12        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_13_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_13              ),
    .stream             ( stream_fifo_in1_13.source     ),
    .ctrl_i             ( ctrl_i.in1_13_source_ctrl     ),
    .flags_o            ( flags_o.in1_13_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_13        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_14_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_14              ),
    .stream             ( stream_fifo_in1_14.source     ),
    .ctrl_i             ( ctrl_i.in1_14_source_ctrl     ),
    .flags_o            ( flags_o.in1_14_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_14        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in1_15_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in1_15              ),
    .stream             ( stream_fifo_in1_15.source     ),
    .ctrl_i             ( ctrl_i.in1_15_source_ctrl     ),
    .flags_o            ( flags_o.in1_15_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in1_15        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_0_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_0              ),
    .stream             ( stream_fifo_in2_0.source     ),
    .ctrl_i             ( ctrl_i.in2_0_source_ctrl     ),
    .flags_o            ( flags_o.in2_0_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_0        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_1_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_1              ),
    .stream             ( stream_fifo_in2_1.source     ),
    .ctrl_i             ( ctrl_i.in2_1_source_ctrl     ),
    .flags_o            ( flags_o.in2_1_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_1        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_2_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_2              ),
    .stream             ( stream_fifo_in2_2.source     ),
    .ctrl_i             ( ctrl_i.in2_2_source_ctrl     ),
    .flags_o            ( flags_o.in2_2_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_2        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_3_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_3              ),
    .stream             ( stream_fifo_in2_3.source     ),
    .ctrl_i             ( ctrl_i.in2_3_source_ctrl     ),
    .flags_o            ( flags_o.in2_3_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_3        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_4_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_4              ),
    .stream             ( stream_fifo_in2_4.source     ),
    .ctrl_i             ( ctrl_i.in2_4_source_ctrl     ),
    .flags_o            ( flags_o.in2_4_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_4        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_5_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_5              ),
    .stream             ( stream_fifo_in2_5.source     ),
    .ctrl_i             ( ctrl_i.in2_5_source_ctrl     ),
    .flags_o            ( flags_o.in2_5_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_5        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_6_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_6              ),
    .stream             ( stream_fifo_in2_6.source     ),
    .ctrl_i             ( ctrl_i.in2_6_source_ctrl     ),
    .flags_o            ( flags_o.in2_6_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_6        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_7_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_7              ),
    .stream             ( stream_fifo_in2_7.source     ),
    .ctrl_i             ( ctrl_i.in2_7_source_ctrl     ),
    .flags_o            ( flags_o.in2_7_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_7        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_8_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_8              ),
    .stream             ( stream_fifo_in2_8.source     ),
    .ctrl_i             ( ctrl_i.in2_8_source_ctrl     ),
    .flags_o            ( flags_o.in2_8_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_8        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_9_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_9              ),
    .stream             ( stream_fifo_in2_9.source     ),
    .ctrl_i             ( ctrl_i.in2_9_source_ctrl     ),
    .flags_o            ( flags_o.in2_9_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_9        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_10_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_10              ),
    .stream             ( stream_fifo_in2_10.source     ),
    .ctrl_i             ( ctrl_i.in2_10_source_ctrl     ),
    .flags_o            ( flags_o.in2_10_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_10        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_11_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_11              ),
    .stream             ( stream_fifo_in2_11.source     ),
    .ctrl_i             ( ctrl_i.in2_11_source_ctrl     ),
    .flags_o            ( flags_o.in2_11_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_11        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_12_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_12              ),
    .stream             ( stream_fifo_in2_12.source     ),
    .ctrl_i             ( ctrl_i.in2_12_source_ctrl     ),
    .flags_o            ( flags_o.in2_12_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_12        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_13_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_13              ),
    .stream             ( stream_fifo_in2_13.source     ),
    .ctrl_i             ( ctrl_i.in2_13_source_ctrl     ),
    .flags_o            ( flags_o.in2_13_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_13        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_14_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_14              ),
    .stream             ( stream_fifo_in2_14.source     ),
    .ctrl_i             ( ctrl_i.in2_14_source_ctrl     ),
    .flags_o            ( flags_o.in2_14_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_14        )
  );
  hwpe_stream_source #(
    .DATA_WIDTH   ( 32 ),
    .DECOUPLED    ( 1  )
  ) i_in2_15_source (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_in2_15              ),
    .stream             ( stream_fifo_in2_15.source     ),
    .ctrl_i             ( ctrl_i.in2_15_source_ctrl     ),
    .flags_o            ( flags_o.in2_15_source_flags   ),
    .tcdm_fifo_ready_o  ( tcdm_fifo_ready_in2_15        )
  );
  // Sink modules (TCDM <- HWPE)
  hwpe_stream_sink #(
    .DATA_WIDTH ( 32 )
    // .NB_TCDM_PORTS (    )
  ) i_out_r_sink (
    .clk_i              ( clk_i                                       ),
    .rst_ni             ( rst_ni                                      ),
    .test_mode_i        ( test_mode_i                                 ),
    .clear_i            ( clear_i                                     ),
    .tcdm               ( tcdm_fifo_out_r                  ),
    .stream             ( stream_fifo_out_r.sink           ),
    .ctrl_i             ( ctrl_i.out_r_sink_ctrl         ),
    .flags_o            ( flags_o.out_r_sink_flags       )
  );
endmodule