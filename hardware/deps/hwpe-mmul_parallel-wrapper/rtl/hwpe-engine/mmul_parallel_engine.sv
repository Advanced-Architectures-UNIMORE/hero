
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
 * Module: mmul_parallel_engine.sv
 *
 */
import mmul_parallel_package::*;
module mmul_parallel_engine (
  // Global signals
  input  logic          clk_i,
  input  logic          rst_ni,
  input  logic          test_mode_i,
  // Sink ports
  hwpe_stream_intf_stream.sink in1_0,
  hwpe_stream_intf_stream.sink in1_1,
  hwpe_stream_intf_stream.sink in1_2,
  hwpe_stream_intf_stream.sink in1_3,
  hwpe_stream_intf_stream.sink in1_4,
  hwpe_stream_intf_stream.sink in1_5,
  hwpe_stream_intf_stream.sink in1_6,
  hwpe_stream_intf_stream.sink in1_7,
  hwpe_stream_intf_stream.sink in1_8,
  hwpe_stream_intf_stream.sink in1_9,
  hwpe_stream_intf_stream.sink in1_10,
  hwpe_stream_intf_stream.sink in1_11,
  hwpe_stream_intf_stream.sink in1_12,
  hwpe_stream_intf_stream.sink in1_13,
  hwpe_stream_intf_stream.sink in1_14,
  hwpe_stream_intf_stream.sink in1_15,
  hwpe_stream_intf_stream.sink in2_0,
  hwpe_stream_intf_stream.sink in2_1,
  hwpe_stream_intf_stream.sink in2_2,
  hwpe_stream_intf_stream.sink in2_3,
  hwpe_stream_intf_stream.sink in2_4,
  hwpe_stream_intf_stream.sink in2_5,
  hwpe_stream_intf_stream.sink in2_6,
  hwpe_stream_intf_stream.sink in2_7,
  hwpe_stream_intf_stream.sink in2_8,
  hwpe_stream_intf_stream.sink in2_9,
  hwpe_stream_intf_stream.sink in2_10,
  hwpe_stream_intf_stream.sink in2_11,
  hwpe_stream_intf_stream.sink in2_12,
  hwpe_stream_intf_stream.sink in2_13,
  hwpe_stream_intf_stream.sink in2_14,
  hwpe_stream_intf_stream.sink in2_15,
  // Source ports
  hwpe_stream_intf_stream.source out_r,
  // Control channel
  input  ctrl_engine_t            ctrl_i,
  output flags_engine_t           flags_o
);
  /* Control/flag signals */
  logic clear;
  logic done, idle, ready;
  assign clear = ctrl_i.clear;
  assign flags_o.done = done;
  assign flags_o.idle = idle;
  always_ff @(posedge clk_i or negedge rst_ni)
  begin: fsm_ready
    if(~rst_ni)
      flags_o.ready = 1'b0;
    else if(~(ready | idle))
      flags_o.ready = 1'b0;
    else
      flags_o.ready = 1'b1;
  end
  /* Count outputs */
  logic unsigned [($clog2(MMUL_PARALLEL_CNT_LEN)+1):0] cnt_out_r;
  always_ff @(posedge clk_i or negedge rst_ni)
  begin: cnt_out_r_counter
    if((~rst_ni) | clear)
      cnt_out_r = 32'b0;
    else if( (out_r.valid) & (out_r.ready) & (done) )
      cnt_out_r = cnt_out_r + 1;
    else
      cnt_out_r = cnt_out_r;
  end
  assign flags_o.cnt_out_r = cnt_out_r;
  /* Kernel adapter */
  hwpe_kernel_adapter i_mmul_parallel_adapter (
    // Global signals
    .clk_i           ( clk_i            ),
    .rst_ni          ( rst_ni           ),
    .test_mode_i     ( test_mode_i      ),
    // Data streams
    .i_in1_0 ( in1_0  ),
    .i_in1_1 ( in1_1  ),
    .i_in1_2 ( in1_2  ),
    .i_in1_3 ( in1_3  ),
    .i_in1_4 ( in1_4  ),
    .i_in1_5 ( in1_5  ),
    .i_in1_6 ( in1_6  ),
    .i_in1_7 ( in1_7  ),
    .i_in1_8 ( in1_8  ),
    .i_in1_9 ( in1_9  ),
    .i_in1_10 ( in1_10  ),
    .i_in1_11 ( in1_11  ),
    .i_in1_12 ( in1_12  ),
    .i_in1_13 ( in1_13  ),
    .i_in1_14 ( in1_14  ),
    .i_in1_15 ( in1_15  ),
    .i_in2_0 ( in2_0  ),
    .i_in2_1 ( in2_1  ),
    .i_in2_2 ( in2_2  ),
    .i_in2_3 ( in2_3  ),
    .i_in2_4 ( in2_4  ),
    .i_in2_5 ( in2_5  ),
    .i_in2_6 ( in2_6  ),
    .i_in2_7 ( in2_7  ),
    .i_in2_8 ( in2_8  ),
    .i_in2_9 ( in2_9  ),
    .i_in2_10 ( in2_10  ),
    .i_in2_11 ( in2_11  ),
    .i_in2_12 ( in2_12  ),
    .i_in2_13 ( in2_13  ),
    .i_in2_14 ( in2_14  ),
    .i_in2_15 ( in2_15  ),
    .o_out_r ( out_r  ),
    // Control signals
    .start           ( ctrl_i.start     ),
    // Flag signals
    .done            ( engine_done      ),
    .idle            ( engine_idle      ),
    .ready           ( engine_ready     )
  );
endmodule