/* =====================================================================
 * Project:      Traffic generator
 * Title:        traffic_gen.c
 * Description:  Application-level accelerator functions.
 *
 * $Date:        21.7.2022
 * ===================================================================== */
/*
 * Copyright (C) 2022 University of Modena and Reggio Emilia.
 *
 * Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
 *
 */

#include "traffic_gen.h"
#include"configs.h"

/* ===================================================================== */

/*
 *
 *     FPGA overlay
 *
 */

/* Parameters mapping */

static inline void traffic_gen_wrapper_map_params(
  traffic_gen_wrapper_struct *wrapper, 
  hwpe_l1_ptr_struct *l1_traffic_gen_buffer,  
  hwpe_traffic_gen_workload_params *params) 
{
  /* Extract parameters */

  unsigned width                                    = params->standard.width;
  unsigned height                                   = params->standard.height;
  unsigned stripe_height                            = params->standard.stripe_height;
  unsigned stim_dim                                 = params->standard.stim_dim;
  unsigned stripe_length                            = params->standard.stripe_length;
  unsigned buffer_dim                               = params->standard.buffer_dim;
  unsigned buffer_stride                            = params->standard.buffer_stride;
  unsigned data_stride                              = params->standard.data_stride;

  unsigned n_total_reqs                             = params->n_total_reqs; 
  unsigned t_ck_reqs                                = params->t_ck_reqs; 
  unsigned t_ck_idle                                = params->t_ck_idle;
  unsigned max_buffer_dim                           = params->max_buffer_dim;
  unsigned n_reps                                   = params->n_reps;
  unsigned n_tcdm_banks                             = params->n_tcdm_banks;

  /* Buffer parameters */

  // int32_t n_reps_r = n_total_reqs/max_buffer_dim; // number of repetitions on read buffer
  int32_t data_stride_r = 1;  // accelerator read data with the following access stride to implement different access behaviors (homogeneous, heterogeneous, worst-case)

  /* Streamer */

  // Read requests
  wrapper->r_reqs.params.width                         = max_buffer_dim;
  wrapper->r_reqs.params.height                        = 1;
  wrapper->r_reqs.params.stripe_height                 = 1;
  wrapper->r_reqs.params.stim_dim                      = n_total_reqs;
  wrapper->r_reqs.params.stripe_length                 = n_total_reqs;
  wrapper->r_reqs.params.buffer_dim                    = max_buffer_dim;

  wrapper->r_reqs.params.buffer_stride                 = 0;
  wrapper->r_reqs.params.data_stride                   = 1;
  
  wrapper->r_reqs.addr_gen.trans_size                  = n_total_reqs;
  wrapper->r_reqs.addr_gen.line_stride                 = 0; 
  wrapper->r_reqs.addr_gen.line_length                 = max_buffer_dim/data_stride_r; 
  wrapper->r_reqs.addr_gen.feat_stride                 = 0; 
  wrapper->r_reqs.addr_gen.feat_length                 = n_reps * data_stride_r;
  wrapper->r_reqs.addr_gen.feat_roll                   = 0; 
  wrapper->r_reqs.addr_gen.loop_outer                  = 0; 
  wrapper->r_reqs.addr_gen.realign_type                = 0; 
  wrapper->r_reqs.addr_gen.step                        = 4 * data_stride_r;

  // Write requests
  wrapper->w_reqs.params.width                         = (t_ck_idle>0) ? (n_total_reqs/t_ck_reqs) : 1;
  wrapper->w_reqs.params.height                        = 1;
  wrapper->w_reqs.params.stripe_height                 = 1;
  wrapper->w_reqs.params.stim_dim                      = (t_ck_idle>0) ? (n_total_reqs/t_ck_reqs) : 1;
  wrapper->w_reqs.params.stripe_length                 = 1;
  wrapper->w_reqs.params.buffer_dim                    = n_total_reqs/t_ck_reqs;

  wrapper->w_reqs.params.buffer_stride                 = 0;
  wrapper->w_reqs.params.data_stride                   = 1;

  wrapper->w_reqs.addr_gen.trans_size                  = (t_ck_idle>0) ? (n_total_reqs/t_ck_reqs + 1) : (1+1); 
  wrapper->w_reqs.addr_gen.line_stride                 = 0; 
  wrapper->w_reqs.addr_gen.line_length                 = (t_ck_idle>0) ? max_buffer_dim : 1; 
  wrapper->w_reqs.addr_gen.feat_stride                 = 0; 
  wrapper->w_reqs.addr_gen.feat_length                 = (t_ck_idle>0) ? (n_total_reqs/(t_ck_reqs*max_buffer_dim)) : 1; 
  wrapper->w_reqs.addr_gen.feat_roll                   = 0; 
  wrapper->w_reqs.addr_gen.loop_outer                  = 0; 
  wrapper->w_reqs.addr_gen.realign_type                = 0; 
  wrapper->w_reqs.addr_gen.step                        = 4;  

  // Assign buffer pointers

  wrapper->r_reqs.tcdm.ptr = (DEVICE_PTR)l1_traffic_gen_buffer->ptr;
  wrapper->w_reqs.tcdm.ptr = (DEVICE_PTR)l1_traffic_gen_buffer->ptr + l1_traffic_gen_buffer->dim_buffer;

  /* Controller */

  // FSM
  wrapper->ctrl.fsm.n_engine_runs                         = 1;

  // Custom registers
  wrapper->ctrl.custom_regs.n_total_reqs                  = n_total_reqs;
  wrapper->ctrl.custom_regs.t_ck_reqs                     = t_ck_reqs;
  wrapper->ctrl.custom_regs.t_ck_idle                     = t_ck_idle; 
}

void richie_map_params_traffic_gen(
  // Accelerator-rich overlay
  RICHIE_DEVICE_PTR richie, 
  // System parameters
  const int cluster_id, 
  const int accelerator_id,
  // L1 accelerator buffer
  DEVICE_PTR_CONST l1_richie_acc_buffer,
  uint32_t dim_traffic_gen_buffers,
  // Workload paramaters
  uint32_t width, 
  uint32_t height, 
  uint32_t stripe_height,
  uint32_t n_total_reqs, 
  uint32_t t_ck_reqs, 
  uint32_t t_ck_idle, 
  uint32_t max_buffer_dim,
  uint32_t n_reps,
  uint32_t n_tcdm_banks) { 

  /* Define parameters */

  hwpe_traffic_gen_workload_params params;

  params.standard.width            = width;
  params.standard.height           = height;
  params.standard.stripe_height    = stripe_height;
  params.standard.stim_dim         = width * height;
  params.standard.stripe_length    = width * stripe_height;
  params.standard.buffer_dim       = width * height;

  params.standard.buffer_stride    = 0;    
  params.standard.data_stride      = 1;  

  params.n_total_reqs     = n_total_reqs; 
  params.t_ck_reqs        = t_ck_reqs; 
  params.t_ck_idle        = t_ck_idle;
  params.max_buffer_dim   = max_buffer_dim;
  params.n_reps           = n_reps;
  params.n_tcdm_banks     = n_tcdm_banks;

  /* L1 buffer pointer */

  hwpe_l1_ptr_struct l1_traffic_gen_buffer;

  l1_traffic_gen_buffer.ptr = (DEVICE_PTR_CONST)l1_richie_acc_buffer + dim_traffic_gen_buffers * accelerator_id; // base address for traffic generator read/write buffers
  l1_traffic_gen_buffer.dim_buffer = max_buffer_dim; // used for dimension of read buffer (r_reqs)

  /* Decide which hardware accelerator to program */

  if(cluster_id == 0){
    switch (accelerator_id){

      case 0: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_0), &l1_traffic_gen_buffer, &params); break;
      case 1: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_1), &l1_traffic_gen_buffer, &params); break;
      case 2: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_2), &l1_traffic_gen_buffer, &params); break;
      case 3: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_3), &l1_traffic_gen_buffer, &params); break;
      case 4: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_4), &l1_traffic_gen_buffer, &params); break;
      case 5: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_5), &l1_traffic_gen_buffer, &params); break;
      case 6: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_6), &l1_traffic_gen_buffer, &params); break;
      case 7: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_7), &l1_traffic_gen_buffer, &params); break;
      case 8: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_8), &l1_traffic_gen_buffer, &params); break;
      case 9: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_9), &l1_traffic_gen_buffer, &params); break;
      case 10: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_10), &l1_traffic_gen_buffer, &params); break;
      case 11: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_11), &l1_traffic_gen_buffer, &params); break;
      case 12: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_12), &l1_traffic_gen_buffer, &params); break;
      case 13: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_13), &l1_traffic_gen_buffer, &params); break;
      case 14: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_14), &l1_traffic_gen_buffer, &params); break;
      case 15: traffic_gen_wrapper_map_params(&(richie->traffic_gen_0_15), &l1_traffic_gen_buffer, &params); break;
      default: printf("Error: No matching case for <richie_map_params_traffic_gen>\n"); break;
    }
  }

};