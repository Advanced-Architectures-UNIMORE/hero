/* =====================================================================
 * Project:      System model
 * Title:        main.c
 * Description:  Multi cluster scaling
 *
 * $Date:        30.6.2022
 * ===================================================================== */
/*
 * Copyright (C) 2022 University of Modena and Reggio Emilia.
 *
 * Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
 *
 */

#include "experiment.h"
#include "configs.h"

void launch_experiment(const int cluster_id){

  /* General */

  int pulp_error;

  /* Experiment variables */

  unsigned n_clusters                   = 1;
  unsigned n_hwpe_total                 = 1;

  // - L2
  unsigned l2_size                      = 32768; // words
  unsigned l2_size_B                    = l2_size*sizeof(uint32_t); // bytes

  // - L1
  unsigned l1_size                      = 32768; // words
  unsigned l1_size_B                    = l1_size*sizeof(uint32_t); // bytes
  unsigned n_tcdm_banks                 = 16;

  // - TCDM circular buffer dimension (=Ntcdm,banks)
  // Decided on top of worst-case scenario (16 acc in 1 cl)
  unsigned max_buffer_dim               = 512;

  // - Number of traffic generators (linear step)
  unsigned n_hwpe_start                 = n_hwpe_total/n_clusters;
  unsigned n_hwpe_stop                  = n_hwpe_total/n_clusters;
  unsigned n_hwpe_step                  = 1;

  // - Overall number of requests (exponential step)
  unsigned n_total_reqs_start           = 128;
  unsigned n_total_reqs_stop            = 128;
  unsigned n_total_reqs_step            = 128;

  // - Request time (burst length) (exponential step)
  unsigned t_ck_reqs_start              = n_tcdm_banks;
  unsigned t_ck_reqs_stop               = n_tcdm_banks;
  unsigned t_ck_reqs_step               = 1;

  // - Idle time (exponential step)
  unsigned t_ck_idle_start              = 0;
  unsigned t_ck_idle_stop               = 2048;
  unsigned t_ck_idle_step               = 1;

  /* L2 */

  // Shared by all clusters!

  // Each cluster holds two L2 buffer for read and write
  // Given one DMA per cluster, HWPEs share the L2 buffer
  unsigned buffer_dim = max_buffer_dim;
  unsigned cluster_buffer_dim = 2 * buffer_dim;

  // Allocation
  DEVICE_PTR_CONST l2_cl_offset   = richie_l2_heap() + cluster_id * cluster_buffer_dim;
  DEVICE_PTR_CONST l2_r_reqs_data = l2_cl_offset;
  DEVICE_PTR_CONST l2_w_reqs_data = l2_cl_offset + buffer_dim;

#ifdef INPUT_INIT
  for(int i=0; i<buffer_dim; i++){
    pulp_write32(l2_r_reqs_data+i*sizeof(int32_t), r_reqs_dut[i]);
    pulp_write32(l2_w_reqs_data+i*sizeof(int32_t), w_reqs_dut[i]);
  }
#endif

  /* Application */  

  exp_traffic_gen( 
    (DEVICE_PTR_CONST)l2_r_reqs_data, 
    (DEVICE_PTR_CONST)l2_w_reqs_data, 
    cluster_id, n_clusters, n_tcdm_banks, max_buffer_dim,  
    n_hwpe_start, n_hwpe_stop, n_hwpe_step, 
    n_total_reqs_start, n_total_reqs_stop, n_total_reqs_step,
    t_ck_reqs_start, t_ck_reqs_stop, t_ck_reqs_step, 
    t_ck_idle_start, t_ck_idle_stop, t_ck_idle_step
  );
}

/* - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / - / */

/*
 *
 *     MAIN
 *
 */

int main(int argc, char *argv[])
{
  const int core_id = 0;

  /* Cluster 0 Core 0 */

  if(hero_rt_core_id()==core_id){

    printf("Multi-cluster experiment!\n");

    launch_experiment(hero_rt_cluster_id());
  }

  else {

    printf("Sleeping...\n");

    eu_evt_wait();
  }

  return 0;
}