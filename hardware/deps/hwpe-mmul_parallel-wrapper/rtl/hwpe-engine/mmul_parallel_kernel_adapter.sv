
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
 * Module: mmul_parallel_kernel_adapter.sv
 *
 */
import mmul_parallel_package::*;
module mmul_parallel_kernel_adapter (
  // Global signals
  input  logic          clk_i,
  input  logic          rst_ni,
  input  logic          test_mode_i,
  // Sink ports
  hwpe_stream_intf_stream.sink i_in1_0,
  hwpe_stream_intf_stream.sink i_in1_1,
  hwpe_stream_intf_stream.sink i_in1_2,
  hwpe_stream_intf_stream.sink i_in1_3,
  hwpe_stream_intf_stream.sink i_in1_4,
  hwpe_stream_intf_stream.sink i_in1_5,
  hwpe_stream_intf_stream.sink i_in1_6,
  hwpe_stream_intf_stream.sink i_in1_7,
  hwpe_stream_intf_stream.sink i_in1_8,
  hwpe_stream_intf_stream.sink i_in1_9,
  hwpe_stream_intf_stream.sink i_in1_10,
  hwpe_stream_intf_stream.sink i_in1_11,
  hwpe_stream_intf_stream.sink i_in1_12,
  hwpe_stream_intf_stream.sink i_in1_13,
  hwpe_stream_intf_stream.sink i_in1_14,
  hwpe_stream_intf_stream.sink i_in1_15,
  hwpe_stream_intf_stream.sink i_in2_0,
  hwpe_stream_intf_stream.sink i_in2_1,
  hwpe_stream_intf_stream.sink i_in2_2,
  hwpe_stream_intf_stream.sink i_in2_3,
  hwpe_stream_intf_stream.sink i_in2_4,
  hwpe_stream_intf_stream.sink i_in2_5,
  hwpe_stream_intf_stream.sink i_in2_6,
  hwpe_stream_intf_stream.sink i_in2_7,
  hwpe_stream_intf_stream.sink i_in2_8,
  hwpe_stream_intf_stream.sink i_in2_9,
  hwpe_stream_intf_stream.sink i_in2_10,
  hwpe_stream_intf_stream.sink i_in2_11,
  hwpe_stream_intf_stream.sink i_in2_12,
  hwpe_stream_intf_stream.sink i_in2_13,
  hwpe_stream_intf_stream.sink i_in2_14,
  hwpe_stream_intf_stream.sink i_in2_15,
  // Source ports
  hwpe_stream_intf_stream.source o_out_r,
  // Control signals
  input  logic          start,
  // Flag signals
  output logic          done,
  output logic          idle,
  output logic          ready
);
  /* mmul_parallel control signals. */
  logic kernel_start;
  // START is not always high. For each READY (~(engine_ready | engine_idle)) that is
  // delivered to the FSM, a new START signal is set high and iaaued to the kernel.
  assign kernel_start = start;
  /* mmul_parallel flag signals. */
  logic kernel_done, kernel_idle, kernel_ready;
  assign done = kernel_done;
  assign idle = kernel_idle;
  always_ff @(posedge clk_i or negedge rst_ni)
  begin: fsm_ready
    if(~rst_ni)
      ready = 1'b0;
    else if(~(kernel_ready | kernel_idle))
      ready = 1'b0;
    else
      ready = 1'b1;
  end
  /* mmul_parallel kernel interface. */
  mmul_parallel i_mmul_parallel (
    // Global signals.
    .ap_clk       ( clk_i            ),
    .ap_rst_n     ( rst_ni           ),
    // Sink ports
    .in1_0_TDATA  ( i_in1_0.data  ),
    .in1_0_TVALID ( i_in1_0.valid ),
    .in1_0_TREADY ( i_in1_0.ready ),
    .in1_1_TDATA  ( i_in1_1.data  ),
    .in1_1_TVALID ( i_in1_1.valid ),
    .in1_1_TREADY ( i_in1_1.ready ),
    .in1_2_TDATA  ( i_in1_2.data  ),
    .in1_2_TVALID ( i_in1_2.valid ),
    .in1_2_TREADY ( i_in1_2.ready ),
    .in1_3_TDATA  ( i_in1_3.data  ),
    .in1_3_TVALID ( i_in1_3.valid ),
    .in1_3_TREADY ( i_in1_3.ready ),
    .in1_4_TDATA  ( i_in1_4.data  ),
    .in1_4_TVALID ( i_in1_4.valid ),
    .in1_4_TREADY ( i_in1_4.ready ),
    .in1_5_TDATA  ( i_in1_5.data  ),
    .in1_5_TVALID ( i_in1_5.valid ),
    .in1_5_TREADY ( i_in1_5.ready ),
    .in1_6_TDATA  ( i_in1_6.data  ),
    .in1_6_TVALID ( i_in1_6.valid ),
    .in1_6_TREADY ( i_in1_6.ready ),
    .in1_7_TDATA  ( i_in1_7.data  ),
    .in1_7_TVALID ( i_in1_7.valid ),
    .in1_7_TREADY ( i_in1_7.ready ),
    .in1_8_TDATA  ( i_in1_8.data  ),
    .in1_8_TVALID ( i_in1_8.valid ),
    .in1_8_TREADY ( i_in1_8.ready ),
    .in1_9_TDATA  ( i_in1_9.data  ),
    .in1_9_TVALID ( i_in1_9.valid ),
    .in1_9_TREADY ( i_in1_9.ready ),
    .in1_10_TDATA  ( i_in1_10.data  ),
    .in1_10_TVALID ( i_in1_10.valid ),
    .in1_10_TREADY ( i_in1_10.ready ),
    .in1_11_TDATA  ( i_in1_11.data  ),
    .in1_11_TVALID ( i_in1_11.valid ),
    .in1_11_TREADY ( i_in1_11.ready ),
    .in1_12_TDATA  ( i_in1_12.data  ),
    .in1_12_TVALID ( i_in1_12.valid ),
    .in1_12_TREADY ( i_in1_12.ready ),
    .in1_13_TDATA  ( i_in1_13.data  ),
    .in1_13_TVALID ( i_in1_13.valid ),
    .in1_13_TREADY ( i_in1_13.ready ),
    .in1_14_TDATA  ( i_in1_14.data  ),
    .in1_14_TVALID ( i_in1_14.valid ),
    .in1_14_TREADY ( i_in1_14.ready ),
    .in1_15_TDATA  ( i_in1_15.data  ),
    .in1_15_TVALID ( i_in1_15.valid ),
    .in1_15_TREADY ( i_in1_15.ready ),
    .in2_0_TDATA  ( i_in2_0.data  ),
    .in2_0_TVALID ( i_in2_0.valid ),
    .in2_0_TREADY ( i_in2_0.ready ),
    .in2_1_TDATA  ( i_in2_1.data  ),
    .in2_1_TVALID ( i_in2_1.valid ),
    .in2_1_TREADY ( i_in2_1.ready ),
    .in2_2_TDATA  ( i_in2_2.data  ),
    .in2_2_TVALID ( i_in2_2.valid ),
    .in2_2_TREADY ( i_in2_2.ready ),
    .in2_3_TDATA  ( i_in2_3.data  ),
    .in2_3_TVALID ( i_in2_3.valid ),
    .in2_3_TREADY ( i_in2_3.ready ),
    .in2_4_TDATA  ( i_in2_4.data  ),
    .in2_4_TVALID ( i_in2_4.valid ),
    .in2_4_TREADY ( i_in2_4.ready ),
    .in2_5_TDATA  ( i_in2_5.data  ),
    .in2_5_TVALID ( i_in2_5.valid ),
    .in2_5_TREADY ( i_in2_5.ready ),
    .in2_6_TDATA  ( i_in2_6.data  ),
    .in2_6_TVALID ( i_in2_6.valid ),
    .in2_6_TREADY ( i_in2_6.ready ),
    .in2_7_TDATA  ( i_in2_7.data  ),
    .in2_7_TVALID ( i_in2_7.valid ),
    .in2_7_TREADY ( i_in2_7.ready ),
    .in2_8_TDATA  ( i_in2_8.data  ),
    .in2_8_TVALID ( i_in2_8.valid ),
    .in2_8_TREADY ( i_in2_8.ready ),
    .in2_9_TDATA  ( i_in2_9.data  ),
    .in2_9_TVALID ( i_in2_9.valid ),
    .in2_9_TREADY ( i_in2_9.ready ),
    .in2_10_TDATA  ( i_in2_10.data  ),
    .in2_10_TVALID ( i_in2_10.valid ),
    .in2_10_TREADY ( i_in2_10.ready ),
    .in2_11_TDATA  ( i_in2_11.data  ),
    .in2_11_TVALID ( i_in2_11.valid ),
    .in2_11_TREADY ( i_in2_11.ready ),
    .in2_12_TDATA  ( i_in2_12.data  ),
    .in2_12_TVALID ( i_in2_12.valid ),
    .in2_12_TREADY ( i_in2_12.ready ),
    .in2_13_TDATA  ( i_in2_13.data  ),
    .in2_13_TVALID ( i_in2_13.valid ),
    .in2_13_TREADY ( i_in2_13.ready ),
    .in2_14_TDATA  ( i_in2_14.data  ),
    .in2_14_TVALID ( i_in2_14.valid ),
    .in2_14_TREADY ( i_in2_14.ready ),
    .in2_15_TDATA  ( i_in2_15.data  ),
    .in2_15_TVALID ( i_in2_15.valid ),
    .in2_15_TREADY ( i_in2_15.ready ),
    // Source ports
    .out_r_TDATA  ( i_out_r.data  ),
    .out_r_TVALID ( i_out_r.valid ),
    .out_r_TREADY ( i_out_r.ready ),
    // Control signals.
    .ap_start      ( kernel_start            ),
    .ap_done       ( kernel_done             ),
    .ap_idle       ( kernel_idle             ),
    .ap_ready      ( kernel_ready            )
  );
  // At the moment output strobe is always '1
  // All bytes of output streams are written
  // to TCDM
  always_comb
  begin
    o_out_r.strb = '1;
  end
endmodule