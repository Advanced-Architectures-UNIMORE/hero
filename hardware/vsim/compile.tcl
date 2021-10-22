set ROOT [file normalize [file dirname [info script]]/..]
# This script was generated automatically by bender.

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/common_verification/src/clk_rst_gen.sv" \
    "$ROOT/deps/common_verification/src/rand_id_queue.sv" \
    "$ROOT/deps/common_verification/src/rand_stream_mst.sv" \
    "$ROOT/deps/common_verification/src/rand_synch_holdable_driver.sv" \
    "$ROOT/deps/common_verification/src/rand_verif_pkg.sv" \
    "$ROOT/deps/common_verification/src/rand_synch_driver.sv" \
    "$ROOT/deps/common_verification/src/rand_stream_slv.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/tech_cells_generic/src/rtl/tc_sram.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/cluster_clk_cells.sv" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/pulp_clk_cells.sv" \
    "$ROOT/deps/tech_cells_generic/src/rtl/tc_clk.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/cluster_pwr_cells.sv" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/generic_memory.sv" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/generic_rom.sv" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/pad_functional.sv" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/pulp_buffer.sv" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/pulp_pwr_cells.sv" \
    "$ROOT/deps/tech_cells_generic/src/tc_pwr.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/tech_cells_generic/test/tb_tc_sram.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/tech_cells_generic/src/deprecated/pulp_clock_gating_async.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/common_cells/src/cdc_2phase.sv" \
    "$ROOT/deps/common_cells/src/cf_math_pkg.sv" \
    "$ROOT/deps/common_cells/src/clk_div.sv" \
    "$ROOT/deps/common_cells/src/delta_counter.sv" \
    "$ROOT/deps/common_cells/src/ecc_pkg.sv" \
    "$ROOT/deps/common_cells/src/edge_propagator_tx.sv" \
    "$ROOT/deps/common_cells/src/exp_backoff.sv" \
    "$ROOT/deps/common_cells/src/fifo_v3.sv" \
    "$ROOT/deps/common_cells/src/graycode.sv" \
    "$ROOT/deps/common_cells/src/isochronous_spill_register.sv" \
    "$ROOT/deps/common_cells/src/lfsr.sv" \
    "$ROOT/deps/common_cells/src/lfsr_16bit.sv" \
    "$ROOT/deps/common_cells/src/lfsr_8bit.sv" \
    "$ROOT/deps/common_cells/src/mv_filter.sv" \
    "$ROOT/deps/common_cells/src/onehot_to_bin.sv" \
    "$ROOT/deps/common_cells/src/plru_tree.sv" \
    "$ROOT/deps/common_cells/src/popcount.sv" \
    "$ROOT/deps/common_cells/src/rr_arb_tree.sv" \
    "$ROOT/deps/common_cells/src/rstgen_bypass.sv" \
    "$ROOT/deps/common_cells/src/serial_deglitch.sv" \
    "$ROOT/deps/common_cells/src/shift_reg.sv" \
    "$ROOT/deps/common_cells/src/spill_register.sv" \
    "$ROOT/deps/common_cells/src/stream_demux.sv" \
    "$ROOT/deps/common_cells/src/stream_filter.sv" \
    "$ROOT/deps/common_cells/src/stream_fork.sv" \
    "$ROOT/deps/common_cells/src/stream_intf.sv" \
    "$ROOT/deps/common_cells/src/stream_join.sv" \
    "$ROOT/deps/common_cells/src/stream_mux.sv" \
    "$ROOT/deps/common_cells/src/sub_per_hash.sv" \
    "$ROOT/deps/common_cells/src/sync.sv" \
    "$ROOT/deps/common_cells/src/sync_wedge.sv" \
    "$ROOT/deps/common_cells/src/unread.sv" \
    "$ROOT/deps/common_cells/src/rr_distributor.sv" \
    "$ROOT/deps/common_cells/src/addr_decode.sv" \
    "$ROOT/deps/common_cells/src/cb_filter.sv" \
    "$ROOT/deps/common_cells/src/cdc_fifo_2phase.sv" \
    "$ROOT/deps/common_cells/src/cdc_fifo_gray.sv" \
    "$ROOT/deps/common_cells/src/counter.sv" \
    "$ROOT/deps/common_cells/src/ecc_decode.sv" \
    "$ROOT/deps/common_cells/src/ecc_encode.sv" \
    "$ROOT/deps/common_cells/src/edge_detect.sv" \
    "$ROOT/deps/common_cells/src/lzc.sv" \
    "$ROOT/deps/common_cells/src/max_counter.sv" \
    "$ROOT/deps/common_cells/src/rstgen.sv" \
    "$ROOT/deps/common_cells/src/stream_delay.sv" \
    "$ROOT/deps/common_cells/src/stream_fifo.sv" \
    "$ROOT/deps/common_cells/src/stream_fork_dynamic.sv" \
    "$ROOT/deps/common_cells/src/stream_xbar.sv" \
    "$ROOT/deps/common_cells/src/fall_through_register.sv" \
    "$ROOT/deps/common_cells/src/id_queue.sv" \
    "$ROOT/deps/common_cells/src/stream_to_mem.sv" \
    "$ROOT/deps/common_cells/src/stream_arbiter_flushable.sv" \
    "$ROOT/deps/common_cells/src/stream_register.sv" \
    "$ROOT/deps/common_cells/src/stream_arbiter.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/common_cells/test/addr_decode_tb.sv" \
    "$ROOT/deps/common_cells/test/cb_filter_tb.sv" \
    "$ROOT/deps/common_cells/test/cdc_2phase_tb.sv" \
    "$ROOT/deps/common_cells/test/cdc_fifo_tb.sv" \
    "$ROOT/deps/common_cells/test/fifo_tb.sv" \
    "$ROOT/deps/common_cells/test/graycode_tb.sv" \
    "$ROOT/deps/common_cells/test/id_queue_tb.sv" \
    "$ROOT/deps/common_cells/test/popcount_tb.sv" \
    "$ROOT/deps/common_cells/test/rr_arb_tree_tb.sv" \
    "$ROOT/deps/common_cells/test/stream_test.sv" \
    "$ROOT/deps/common_cells/test/stream_register_tb.sv" \
    "$ROOT/deps/common_cells/test/stream_to_mem_tb.sv" \
    "$ROOT/deps/common_cells/test/stream_xbar_tb.sv" \
    "$ROOT/deps/common_cells/test/sub_per_hash_tb.sv" \
    "$ROOT/deps/common_cells/test/isochronous_spill_register_tb.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/common_cells/src/deprecated/clock_divider_counter.sv" \
    "$ROOT/deps/common_cells/src/deprecated/find_first_one.sv" \
    "$ROOT/deps/common_cells/src/deprecated/generic_LFSR_8bit.sv" \
    "$ROOT/deps/common_cells/src/deprecated/generic_fifo.sv" \
    "$ROOT/deps/common_cells/src/deprecated/prioarbiter.sv" \
    "$ROOT/deps/common_cells/src/deprecated/pulp_sync.sv" \
    "$ROOT/deps/common_cells/src/deprecated/pulp_sync_wedge.sv" \
    "$ROOT/deps/common_cells/src/deprecated/rrarbiter.sv" \
    "$ROOT/deps/common_cells/src/deprecated/clock_divider.sv" \
    "$ROOT/deps/common_cells/src/deprecated/fifo_v2.sv" \
    "$ROOT/deps/common_cells/src/deprecated/fifo_v1.sv" \
    "$ROOT/deps/common_cells/src/edge_propagator.sv" \
    "$ROOT/deps/common_cells/src/edge_propagator_rx.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/control_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv" \
    "$ROOT/deps/fpu_div_sqrt_mvp/hdl/div_sqrt_mvp_wrapper.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/cluster_interconnect/rtl/interfaces/tcdm_bank_mem_bus.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/interfaces/xbar_demux_bus.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/interfaces/xbar_periph_bus.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/interfaces/xbar_tcdm_bus_64.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/interfaces/xbar_tcdm_bus.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/cluster_interconnect/rtl/low_latency_interco" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/AddressDecoder_Req.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/AddressDecoder_Resp.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/FanInPrimitive_Req.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/FanInPrimitive_Resp.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/MUX2_REQ.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/TCDM_PIPE_REQ.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/TCDM_PIPE_RESP.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/TestAndSet.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/grant_mask.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/priority_Flag_Req.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/ArbitrationTree.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/ResponseTree.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/RequestBlock1CH.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/RequestBlock2CH.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/ResponseBlock.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/XBAR_TCDM.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/low_latency_interco/XBAR_TCDM_WRAPPER.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/cluster_interconnect/rtl/peripheral_interco" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/AddressDecoder_PE_Req.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/AddressDecoder_Resp_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/FanInPrimitive_PE_Resp.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/FanInPrimitive_Req_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/MUX2_REQ_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/RR_Flag_Req_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/ArbitrationTree_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/ResponseTree_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/ResponseBlock_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/RequestBlock1CH_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/RequestBlock2CH_PE.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/peripheral_interco/XBAR_PE.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/tcdm_interconnect_pkg.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/addr_dec_resp_mux.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/amo_shim.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/xbar.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/clos_net.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/bfly_net.sv" \
    "$ROOT/deps/cluster_interconnect/rtl/tcdm_interconnect/tcdm_interconnect.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/fpnew/src/fpnew_pkg.sv" \
    "$ROOT/deps/fpnew/src/fpnew_cast_multi.sv" \
    "$ROOT/deps/fpnew/src/fpnew_classifier.sv" \
    "$ROOT/deps/fpnew/src/fpnew_divsqrt_multi.sv" \
    "$ROOT/deps/fpnew/src/fpnew_fma.sv" \
    "$ROOT/deps/fpnew/src/fpnew_fma_multi.sv" \
    "$ROOT/deps/fpnew/src/fpnew_noncomp.sv" \
    "$ROOT/deps/fpnew/src/fpnew_opgroup_block.sv" \
    "$ROOT/deps/fpnew/src/fpnew_opgroup_fmt_slice.sv" \
    "$ROOT/deps/fpnew/src/fpnew_opgroup_multifmt_slice.sv" \
    "$ROOT/deps/fpnew/src/fpnew_rounding.sv" \
    "$ROOT/deps/fpnew/src/fpnew_top.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi/src/axi_pkg.sv" \
    "$ROOT/deps/axi/src/dma/axi_dma_data_path.sv" \
    "$ROOT/deps/axi/src/axi_intf.sv" \
    "$ROOT/deps/axi/src/dma/axi_dma_data_mover.sv" \
    "$ROOT/deps/axi/src/dma/axi_dma_burst_reshaper.sv" \
    "$ROOT/deps/axi/src/axi_atop_filter.sv" \
    "$ROOT/deps/axi/src/axi_burst_splitter.sv" \
    "$ROOT/deps/axi/src/axi_cdc.sv" \
    "$ROOT/deps/axi/src/axi_cut.sv" \
    "$ROOT/deps/axi/src/axi_delayer.sv" \
    "$ROOT/deps/axi/src/axi_demux.sv" \
    "$ROOT/deps/axi/src/axi_dw_downsizer.sv" \
    "$ROOT/deps/axi/src/axi_dw_upsizer.sv" \
    "$ROOT/deps/axi/src/axi_id_remap.sv" \
    "$ROOT/deps/axi/src/axi_id_prepend.sv" \
    "$ROOT/deps/axi/src/axi_isolate.sv" \
    "$ROOT/deps/axi/src/axi_join.sv" \
    "$ROOT/deps/axi/src/axi_lite_demux.sv" \
    "$ROOT/deps/axi/src/axi_lite_join.sv" \
    "$ROOT/deps/axi/src/axi_lite_mailbox.sv" \
    "$ROOT/deps/axi/src/axi_lite_mux.sv" \
    "$ROOT/deps/axi/src/axi_lite_regs.sv" \
    "$ROOT/deps/axi/src/axi_lite_to_apb.sv" \
    "$ROOT/deps/axi/src/axi_lite_to_axi.sv" \
    "$ROOT/deps/axi/src/axi_modify_address.sv" \
    "$ROOT/deps/axi/src/axi_mux.sv" \
    "$ROOT/deps/axi/src/axi_read_burst_buffer.sv" \
    "$ROOT/deps/axi/src/axi_serializer.sv" \
    "$ROOT/deps/axi/src/dma/axi_dma_backend.sv" \
    "$ROOT/deps/axi/src/axi_err_slv.sv" \
    "$ROOT/deps/axi/src/axi_dw_converter.sv" \
    "$ROOT/deps/axi/src/axi_id_serialize.sv" \
    "$ROOT/deps/axi/src/axi_multicut.sv" \
    "$ROOT/deps/axi/src/axi_tlb_l1.sv" \
    "$ROOT/deps/axi/src/axi_to_axi_lite.sv" \
    "$ROOT/deps/axi/src/axi_iw_converter.sv" \
    "$ROOT/deps/axi/src/axi_lite_xbar.sv" \
    "$ROOT/deps/axi/src/axi_tlb.sv" \
    "$ROOT/deps/axi/src/axi_xbar.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi/src/axi_sim_mem.sv" \
    "$ROOT/deps/axi/src/axi_test.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi/test/tb_axi_atop_filter.sv" \
    "$ROOT/deps/axi/test/tb_axi_addr_test.sv" \
    "$ROOT/deps/axi/test/tb_axi_cdc.sv" \
    "$ROOT/deps/axi/test/tb_axi_delayer.sv" \
    "$ROOT/deps/axi/test/tb_axi_dw_downsizer.sv" \
    "$ROOT/deps/axi/test/tb_axi_dw_upsizer.sv" \
    "$ROOT/deps/axi/test/tb_axi_isolate.sv" \
    "$ROOT/deps/axi/test/tb_axi_lite_regs.sv" \
    "$ROOT/deps/axi/test/tb_axi_lite_to_apb.sv" \
    "$ROOT/deps/axi/test/tb_axi_lite_to_axi.sv" \
    "$ROOT/deps/axi/test/tb_axi_lite_mailbox.sv" \
    "$ROOT/deps/axi/test/tb_axi_lite_xbar.sv" \
    "$ROOT/deps/axi/test/tb_axi_modify_address.sv" \
    "$ROOT/deps/axi/test/tb_axi_serializer.sv" \
    "$ROOT/deps/axi/test/tb_axi_to_axi_lite.sv" \
    "$ROOT/deps/axi/test/tb_axi_xbar_pkg.sv" \
    "$ROOT/deps/axi/test/tb_axi_xbar.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi_slice/src/axi_single_slice.sv" \
    "$ROOT/deps/axi_slice/src/axi_ar_buffer.sv" \
    "$ROOT/deps/axi_slice/src/axi_aw_buffer.sv" \
    "$ROOT/deps/axi_slice/src/axi_b_buffer.sv" \
    "$ROOT/deps/axi_slice/src/axi_r_buffer.sv" \
    "$ROOT/deps/axi_slice/src/axi_slice.sv" \
    "$ROOT/deps/axi_slice/src/axi_w_buffer.sv" \
    "$ROOT/deps/axi_slice/src/axi_slice_wrap.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/cluster_peripherals/cluster_control_unit/cluster_control_unit.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/cluster_peripherals/event_unit/include" \
    "$ROOT/deps/cluster_peripherals/event_unit/HW_barrier_logic.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/event_unit_arbiter.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/event_unit_mux.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/event_unit_sm.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/interrupt_mask.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/interfaces/bbmux_config_bus.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/interfaces/clkgate_config_bus.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/HW_barrier.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/event_unit_input.sv" \
    "$ROOT/deps/cluster_peripherals/event_unit/event_unit.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/interfaces/l0_ctrl_unit_bus.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/interfaces/mp_icache_ctrl_unit_bus.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/interfaces/mp_pf_icache_ctrl_unit_bus.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/interfaces/pri_icache_ctrl_unit_bus.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/interfaces/sp_icache_ctrl_unit_bus.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/icache_ctrl_unit.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/mp_icache_ctrl_unit.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/mp_pf_icache_ctrl_unit.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/new_icache_ctrl_unit.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/pri_icache_ctrl_unit.sv" \
    "$ROOT/deps/cluster_peripherals/icache_ctrl_unit/sp_icache_ctrl_unit.sv" \
    "$ROOT/deps/cluster_peripherals/mmu_config_unit/interfaces/mmu_config_bus.sv" \
    "$ROOT/deps/cluster_peripherals/mmu_config_unit/mmu_config_unit.sv" \
    "$ROOT/deps/cluster_peripherals/perf_counters_unit/perf_counters_unit.sv" \
    "$ROOT/deps/cluster_peripherals/tcdm_pipe_unit/tcdm_pipe_unit.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/icache-intc/Req_Arb_Node_icache_intc.sv" \
    "$ROOT/deps/icache-intc/Resp_Arb_Node_icache_intc.sv" \
    "$ROOT/deps/icache-intc/lint_mux.sv" \
    "$ROOT/deps/icache-intc/DistributedArbitrationNetwork_Req_icache_intc.sv" \
    "$ROOT/deps/icache-intc/DistributedArbitrationNetwork_Resp_icache_intc.sv" \
    "$ROOT/deps/icache-intc/RoutingBlock_Req_icache_intc.sv" \
    "$ROOT/deps/icache-intc/RoutingBlock_2ch_Req_icache_intc.sv" \
    "$ROOT/deps/icache-intc/RoutingBlock_Resp_icache_intc.sv" \
    "$ROOT/deps/icache-intc/icache_intc.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/riscv/rtl/include" \
    "$ROOT/deps/riscv/rtl/include/apu_core_package.sv" \
    "$ROOT/deps/riscv/rtl/include/riscv_defines.sv" \
    "$ROOT/deps/riscv/rtl/include/riscv_tracer_defines.sv" \
    "$ROOT/deps/riscv/rtl/register_file_test_wrap.sv" \
    "$ROOT/deps/riscv/rtl/riscv_alu.sv" \
    "$ROOT/deps/riscv/rtl/riscv_alu_basic.sv" \
    "$ROOT/deps/riscv/rtl/riscv_alu_div.sv" \
    "$ROOT/deps/riscv/rtl/riscv_compressed_decoder.sv" \
    "$ROOT/deps/riscv/rtl/riscv_controller.sv" \
    "$ROOT/deps/riscv/rtl/riscv_cs_registers.sv" \
    "$ROOT/deps/riscv/rtl/riscv_decoder.sv" \
    "$ROOT/deps/riscv/rtl/riscv_int_controller.sv" \
    "$ROOT/deps/riscv/rtl/riscv_ex_stage.sv" \
    "$ROOT/deps/riscv/rtl/riscv_hwloop_controller.sv" \
    "$ROOT/deps/riscv/rtl/riscv_hwloop_regs.sv" \
    "$ROOT/deps/riscv/rtl/riscv_id_stage.sv" \
    "$ROOT/deps/riscv/rtl/riscv_if_stage.sv" \
    "$ROOT/deps/riscv/rtl/riscv_load_store_unit.sv" \
    "$ROOT/deps/riscv/rtl/riscv_mult.sv" \
    "$ROOT/deps/riscv/rtl/riscv_pmp.sv" \
    "$ROOT/deps/riscv/rtl/riscv_prefetch_buffer.sv" \
    "$ROOT/deps/riscv/rtl/riscv_prefetch_L0_buffer.sv" \
    "$ROOT/deps/riscv/rtl/riscv_core.sv" \
    "$ROOT/deps/riscv/rtl/riscv_apu_disp.sv" \
    "$ROOT/deps/riscv/rtl/riscv_fetch_fifo.sv" \
    "$ROOT/deps/riscv/rtl/riscv_L0_buffer.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/riscv/rtl/include" \
    "$ROOT/deps/riscv/rtl/riscv_register_file.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/riscv/rtl/include" \
    "$ROOT/deps/riscv/rtl/riscv_tracer.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/scm/latch_scm/register_file_1r_1w_test_wrap.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_64b_multi_port_read_32b_1row.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_multi_port_read_1row.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1r_1w_all.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1r_1w_all_test_wrap.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1r_1w_be.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1r_1w.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1r_1w_1row.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_128b_multi_port_read_32b.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_64b_multi_port_read_32b.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_64b_1r_32b.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_multi_port_read_be.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_1w_multi_port_read.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_2r_1w_asymm.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_2r_1w_asymm_test_wrap.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_2r_2w.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_3r_2w.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_3r_2w_be.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_multi_way_1w_64b_multi_port_read_32b.sv" \
    "$ROOT/deps/scm/latch_scm/register_file_multi_way_1w_multi_port_read.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/apb/src/apb_intf.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi2mem/axi2mem.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi2per/axi2per_req_channel.sv" \
    "$ROOT/deps/axi2per/axi2per_res_channel.sv" \
    "$ROOT/deps/axi2per/axi2per.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi_slice_dc/src/axi_slice_dc_master.sv" \
    "$ROOT/deps/axi_slice_dc/src/axi_slice_dc_slave.sv" \
    "$ROOT/deps/axi_slice_dc/src/dc_data_buffer.sv" \
    "$ROOT/deps/axi_slice_dc/src/dc_full_detector.v" \
    "$ROOT/deps/axi_slice_dc/src/dc_synchronizer.v" \
    "$ROOT/deps/axi_slice_dc/src/dc_token_ring_fifo_din.v" \
    "$ROOT/deps/axi_slice_dc/src/dc_token_ring_fifo_dout.v" \
    "$ROOT/deps/axi_slice_dc/src/dc_token_ring.v" \
    "$ROOT/deps/axi_slice_dc/src/axi_slice_dc_master_wrap.sv" \
    "$ROOT/deps/axi_slice_dc/src/axi_slice_dc_slave_wrap.sv" \
    "$ROOT/deps/axi_slice_dc/src/axi_cdc.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/event_unit_flex" \
    "$ROOT/deps/event_unit_flex/message_bus.sv" \
    "$ROOT/deps/event_unit_flex/event_unit_core.sv" \
    "$ROOT/deps/event_unit_flex/event_unit_interface_mux.sv" \
    "$ROOT/deps/event_unit_flex/event_unit_top.sv" \
    "$ROOT/deps/event_unit_flex/soc_periph_fifo.sv" \
    "$ROOT/deps/event_unit_flex/interc_sw_evt_trig.sv" \
    "$ROOT/deps/event_unit_flex/hw_barrier_unit.sv" \
    "$ROOT/deps/event_unit_flex/hw_mutex_unit.sv" \
    "$ROOT/deps/event_unit_flex/hw_dispatch.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/icache_mp_128_pf/RTL/icache_bank_mp_128.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/icache_bank_mp_PF.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/merge_refill_cam_128_16.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/pf_miss_mux.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/prefetcher_if.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/central_controller_128.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/cache_controller_to_axi_128_PF.sv" \
    "$ROOT/deps/icache_mp_128_pf/RTL/icache_top_mp_128_PF.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/per2axi/src/per2axi_busy_unit.sv" \
    "$ROOT/deps/per2axi/src/per2axi_req_channel.sv" \
    "$ROOT/deps/per2axi/src/per2axi_res_channel.sv" \
    "$ROOT/deps/per2axi/src/per2axi.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/timer_unit/rtl/timer_unit_counter.sv" \
    "$ROOT/deps/timer_unit/rtl/timer_unit_counter_presc.sv" \
    "$ROOT/deps/timer_unit/rtl/apb_timer_unit.sv" \
    "$ROOT/deps/timer_unit/rtl/timer_unit.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi2apb/src/axi2apb.sv" \
    "$ROOT/deps/axi2apb/src/axi2apb_64_32.sv" \
    "$ROOT/deps/axi2apb/src/axi2apb_wrap.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_res_tbl.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_amos_alu.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_amos.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_lrsc.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_atomics.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_lrsc_wrap.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_amos_wrap.sv" \
    "$ROOT/deps/axi_riscv_atomics/src/axi_riscv_atomics_wrap.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/axi_riscv_atomics/test/generic_memory.sv" \
    "$ROOT/deps/axi_riscv_atomics/test/axi_memory.sv" \
    "$ROOT/deps/axi_riscv_atomics/test/tb_axi_pkg.sv" \
    "$ROOT/deps/axi_riscv_atomics/test/golden_memory.sv" \
    "$ROOT/deps/axi_riscv_atomics/test/tb_top.sv" \
    "$ROOT/deps/axi_riscv_atomics/test/axi_riscv_lrsc_tb.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/hwpe_stream_package.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/hwpe_stream_interfaces.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_assign.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_mux_static.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_demux_static.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_buffer.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_merge.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_fence.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/basic/hwpe_stream_split.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo_earlystall_sidech.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo_earlystall.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo_scm.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo_scm_test_wrap.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo_sidech.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/fifo/hwpe_stream_fifo_ctrl.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_addressgen.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_addressgen_v2.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_strbgen.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_sink.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_sink_realign.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_source.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_source_realign.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/streamer/hwpe_stream_streamer_queue.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_fifo_load.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_fifo_load_sidech.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_fifo_store.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_fifo.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_assign.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_mux.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_mux_static.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_reorder.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-stream/tcdm/hwpe_stream_tcdm_reorder_static.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_package.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_interfaces.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_regfile.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_regfile_latch.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_regfile_latch_test_wrap.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_regfile_ff.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_regfile_ff_test_wrap.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_slave.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-ctrl/hwpe_ctrl_uloop.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/engine_dev/mmult_hw_local_in1_0.v" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/engine_dev/mmult_hw_local_out.v" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/engine_dev/mmult_opt_mdc.v" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_package.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_fsm.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_ctrl.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_streamer.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_kernel_adapter.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_engine.sv" \
    "$ROOT/deps/hwpe-generated-ex/rtl/hwpe-engine/mmult_opt_mdc_top.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "+incdir+$ROOT/deps/hwpe-generated-ex/rtl/wrap" \
    "$ROOT/deps/hwpe-generated-ex/rtl/wrap/mmult_opt_mdc_top_wrapper.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/deps/overlay_cluster/packages/apu_package.sv" \
    "$ROOT/deps/overlay_cluster/packages/pulp_cluster_package.sv" \
    "$ROOT/deps/overlay_cluster/rtl/axi2per_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/axi_slice_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_bus_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_clock_gate.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_event_map.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_interconnect_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_timer_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cpu_marx_if.sv" \
    "$ROOT/deps/overlay_cluster/rtl/dmac_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/per2axi_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/per_demux_wrap.sv" \
    "$ROOT/deps/overlay_cluster/rtl/periph_FIFO.sv" \
    "$ROOT/deps/overlay_cluster/rtl/periph_demux.sv" \
    "$ROOT/deps/overlay_cluster/rtl/tryx_ctrl.sv" \
    "$ROOT/deps/overlay_cluster/rtl/ov_acc_intf.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_dma_transfer_id_gen.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_dma_frontend_regs.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_peripherals.sv" \
    "$ROOT/deps/overlay_cluster/rtl/core_demux.sv" \
    "$ROOT/deps/overlay_cluster/rtl/cluster_dma_frontend.sv" \
    "$ROOT/deps/overlay_cluster/rtl/core_region.sv" \
    "$ROOT/deps/overlay_cluster/rtl/pulp_cluster.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/src/apb/apb_bus.sv" \
    "$ROOT/src/apb/apb_ro_regs.sv" \
    "$ROOT/src/apb/apb_rw_regs.sv" \
    "$ROOT/src/apb/apb_bus_wrap.sv" \
    "$ROOT/src/hero_axi_mailbox.sv" \
    "$ROOT/src/pulp_cluster_cfg_pkg.sv" \
    "$ROOT/src/ov_acc_pkg.sv" \
    "$ROOT/src/soc_bus.sv" \
    "$ROOT/src/soc_ctrl_regs.sv" \
    "$ROOT/src/dmac_wrap_ooc.sv" \
    "$ROOT/src/l2_mem.sv" \
    "$ROOT/src/pulp_cluster_ooc.sv" \
    "$ROOT/src/soc_peripherals.sv" \
    "$ROOT/src/pulp.sv" \
    "$ROOT/src/pulp_ooc.sv"
}]} {return 1}

if {[catch {vlog -incr -sv \
    -suppress vlog-2583 -suppress vlog-13314 -suppress vlog-13233 \
    +define+TARGET_RTL \
    +define+TARGET_SIMULATION \
    +define+TARGET_TEST \
    +define+TARGET_VSIM \
    "+incdir+$ROOT/deps/common_cells/include" \
    "+incdir+$ROOT/deps/axi/include" \
    "+incdir+$ROOT/src/apb/include" \
    "+incdir+$ROOT/src/include" \
    "$ROOT/src/apb/apb_stdout.sv" \
    "$ROOT/test/pulp_tb.sv"
}]} {return 1}
