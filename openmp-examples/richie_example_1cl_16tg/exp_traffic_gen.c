/* =====================================================================
 * Project:      System model
 * Title:        exp_traffic_gen.c
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

#include "exp_traffic_gen.h"
#include "configs.h"

void exp_traffic_gen(
  // Data stimuli and results
  DEVICE_PTR_CONST l2_r_reqs_data, DEVICE_PTR_CONST l2_w_reqs_data, 
  // System parameters
  const int cluster_id, const int n_clusters, const int n_tcdm_banks,
  // Max buffer dimension
  const int max_buffer_dim,   
  // Number of HWPE
  const int n_hwpe_start, const int n_hwpe_stop, const int n_hwpe_step,    
  // Number of total requests
  uint32_t n_total_reqs_start, uint32_t n_total_reqs_stop, uint32_t n_total_reqs_step,
  // Burst length
  uint32_t t_ck_reqs_start, uint32_t t_ck_reqs_stop, uint32_t t_ck_reqs_step, 
  // Idle time
  uint32_t t_ck_idle_start, uint32_t t_ck_idle_stop, uint32_t t_ck_idle_step)
{

#if defined(PRINT_LOG)
  printf("Experiment session - Begin\n");
#endif

  /* Reset and start PULP counter */

  hero_reset_clk_counter();
  hero_start_clk_counter();

  /* Cycle counters. */

  pulp_clk_struct t_experiment;
  pulp_clk_struct t_clean;
  pulp_clk_struct t_alloc;
  pulp_clk_struct t_progr;
  pulp_clk_struct t_compute[n_hwpe_stop];
  
  uint32_t t_acc_compute;

  /* Measure time displacements arising from control of accelerators */

  pulp_clk_struct acc_trigger_displacement;
  pulp_clk_struct acc_synch_displacement;

  /* Measure counter call overhead */

  pulp_clk_struct timer_overhead;

  timer_overhead.cnt_0  = hero_get_clk_counter();
  hero_get_clk_counter();
  timer_overhead.cnt_1  = hero_get_clk_counter();

  /* ===================================================================== */

#ifdef TIME_MEASUREMENT_EXTRA
  t_alloc.cnt_0 = hero_get_clk_counter();
#endif

#if defined(PRINT_LOG)
  printf("Setting wrappers parameters\n");
#endif


  /* Execution */

  int experiment_id = 0;
  int n_cache = 4;

  /* ===================================================================== */

  /* Allocate accelerator-rich overlay */

#if defined(PRINT_LOG)
  printf("Allocate accelerator-rich overlay\n");
#endif

  richie_struct richie;

  /* ===================================================================== */

  /* Traffic generator */

  int offload_id[n_hwpe_stop];

  DEVICE_PTR l1_dev_addr;
  int dim_traffic_gen_buffers = max_buffer_dim + max_buffer_dim; //n_total_reqs_stop/t_ck_reqs_stop;

  int n_reps;

  /* Allocate L1 data buffer. */

#if defined(PRINT_LOG)
  printf("Allocate L1 contiguous data buffer\n");
#endif

  DEVICE_PTR_CONST l1_richie_acc_buffer  = richie_l1_heap(cluster_id);

#ifdef TIME_MEASUREMENT_EXTRA
  t_alloc.cnt_1 = hero_get_clk_counter();
#endif

  /* ===================================================================== */

  /* Design space exploration */

  printf("TCDM model ~ Homogeneous execution\n");

  for(int n_hwpe_active=n_hwpe_start; n_hwpe_active<=n_hwpe_stop; n_hwpe_active+=n_hwpe_step){

    for(uint32_t n_total_reqs=n_total_reqs_start; n_total_reqs<=n_total_reqs_stop; n_total_reqs+=n_total_reqs){

      for(uint32_t t_ck_reqs=t_ck_reqs_start; t_ck_reqs<=t_ck_reqs_stop; t_ck_reqs+=t_ck_reqs){

        for(uint32_t t_ck_idle=t_ck_idle_start; t_ck_idle<=t_ck_idle_stop; ((t_ck_idle==0) ? (t_ck_idle++) : (t_ck_idle+=t_ck_idle)) ){

          n_reps = n_total_reqs/max_buffer_dim;

          /* Initialize and program traffic generators */

#ifdef TIME_MEASUREMENT_EXTRA
          t_progr.cnt_0 = hero_get_clk_counter();
#endif

          for(int acc_id=0; acc_id<n_hwpe_active; acc_id++){

#ifdef PRINT_LOG
            printf("[EXP-%d] [CL-%d] [LIC-%d] Accelerator initialization\n", experiment_id, cluster_id, acc_id);
#endif

            richie_init(&richie, cluster_id, acc_id);

            richie_map_params_traffic_gen(
              &richie, 
              cluster_id, 
              acc_id,
              l1_richie_acc_buffer,
              dim_traffic_gen_buffers,
              max_buffer_dim, 
              1, 
              1,
              n_total_reqs, 
              t_ck_reqs, 
              t_ck_idle, 
              max_buffer_dim,
              n_reps,
              n_tcdm_banks);

            offload_id[acc_id] = richie_activate(&richie, cluster_id, acc_id);

#ifdef PRINT_LOG
            printf("[EXP-%d] [CL-%d] [LIC-%d] Accelerator programming\n", experiment_id, cluster_id, acc_id);
#endif

            richie_program(&richie, cluster_id, acc_id);
          }

#ifdef TIME_MEASUREMENT_EXTRA
          t_progr.cnt_1 = hero_get_clk_counter();
#endif

          /* Warm cache condition */

          for(int cnt_cache=0; cnt_cache<n_cache; cnt_cache++){

            printf("[EXP-%d] --> Warm cache loop i%d\n", experiment_id, cnt_cache);

            /* Experiment */

#ifdef TIME_MEASUREMENT_MAIN
            if (cnt_cache==(n_cache-1)) t_experiment.cnt_0 = hero_get_clk_counter();
#endif
          /* Launch computation */

          for(int acc_id=0; acc_id<n_hwpe_active; acc_id++){

#ifdef TIME_MEASUREMENT_EXTRA
            if (cnt_cache==(n_cache-2)) t_compute[acc_id].cnt_0 = hero_get_clk_counter();
            if ((cnt_cache==(n_cache-2))&&(acc_id==0)) acc_trigger_displacement.cnt_0 = hero_get_clk_counter();
#endif

            richie_compute(&richie, cluster_id, acc_id);

#ifdef TIME_MEASUREMENT_EXTRA
            if ((cnt_cache==(n_cache-2))&&(acc_id==n_hwpe_active-1)) acc_trigger_displacement.cnt_1 = hero_get_clk_counter();
#endif
          }

          /* Wait for computation to terminate */

          for(int acc_id=0; acc_id<n_hwpe_active; acc_id++){

#ifdef TIME_MEASUREMENT_EXTRA
            if ((cnt_cache==(n_cache-2))&&(acc_id==0)) acc_synch_displacement.cnt_0 = hero_get_clk_counter();
#endif

            while(!richie_is_finished(&richie, cluster_id, acc_id)){
              richie_wait_eu(&richie, cluster_id, acc_id);
            }

#ifdef TIME_MEASUREMENT_EXTRA
            if (cnt_cache==(n_cache-2)) t_compute[acc_id].cnt_1 = hero_get_clk_counter();
            if ((cnt_cache==(n_cache-2))&&(acc_id==n_hwpe_active-1)) acc_synch_displacement.cnt_1 = hero_get_clk_counter();
#endif

          }


#ifdef TIME_MEASUREMENT_MAIN
            if (cnt_cache==(n_cache-1)) t_experiment.cnt_1 = hero_get_clk_counter();
#endif
        
          }

          /* Cleaning */

#ifdef TIME_MEASUREMENT_EXTRA
          t_clean.cnt_0 = hero_get_clk_counter();
#endif
          for(int acc_id=0; acc_id<n_hwpe_active; acc_id++){
            richie_free(&richie, cluster_id, acc_id);
          }
#ifdef TIME_MEASUREMENT_EXTRA
          t_clean.cnt_1 = hero_get_clk_counter();
#endif

          /* Experiment results */

#if defined(TIME_MEASUREMENT_MAIN) || defined(TIME_MEASUREMENT_EXTRA)

          if(!cluster_id) {

            printf("\n");
            printf(" # ============================================================================\n");
            printf(" # Experiment %d\n\n", experiment_id);

            printf(" # Parameters\n\n");

            printf(" # - N_clusters: %d \n", n_clusters);
            printf(" # - N_acc: %d \n", n_hwpe_active);
            printf(" # - N_reps: %d \n", n_reps);
            printf(" # - DIM_buffer: %d \n", max_buffer_dim);
            printf(" # - N_reqs: %d \n", n_total_reqs);
            printf(" # - DIM_burst: %d \n", t_ck_reqs);
            printf(" # - T_idle: %d \n", t_ck_idle);
            printf(" # - N_tcdm_banks: %d \n", n_tcdm_banks);
            printf(" #\n");

            printf(" # Breakdown\n\n");

            printf(" # - T_exp: %d \n", t_experiment.cnt_1 - t_experiment.cnt_0);

#ifdef TIME_MEASUREMENT_EXTRA
            printf(" # - T_alloc: %d \n", t_alloc.cnt_1 - t_alloc.cnt_0);
            printf(" # - T_progr: %d \n", t_progr.cnt_1 - t_progr.cnt_0);
            printf(" # - T_clean: %d \n", t_clean.cnt_1 - t_clean.cnt_0);
            printf(" #\n");

            printf(" # Accelerators\n\n");

            for(int acc_id=0; acc_id<n_hwpe_active; acc_id++){
              t_acc_compute = t_compute[acc_id].cnt_1 - t_compute[acc_id].cnt_0;
              printf(" # - T_compute_ACC [%d]: %d \n", acc_id, t_acc_compute);
            }

            printf(" # Non-idealities\n\n");

            printf(" # - T_timer_overhead: %d \n", timer_overhead.cnt_1 - timer_overhead.cnt_0);
            printf(" # - T_acc_trigger_delta: %d \n", acc_trigger_displacement.cnt_1 - acc_trigger_displacement.cnt_0);
            printf(" # - T_acc_synch_delta: %d \n", acc_synch_displacement.cnt_1 - acc_synch_displacement.cnt_0);
#endif
            printf(" # ============================================================================\n");
            printf("\n");
          }
        
#endif
      
          /* Synchronize clusters */

          __asm__ __volatile__ ("" : : : "memory");

          pulp_write32(0x1c01FFF0, 1);

          printf("Cluster %d has terminated run #%d!\n", hero_rt_cluster_id(), experiment_id);

          experiment_id++;

          while(1){

            // Cluster 0 is assumed to take more time since it prints all the performance measurements.
            // If this assumption does not hold anymore, then a new way of synchronizing clusters is needed.

            // Cluster barrier is allocated in L2 so all clusters can read/write it possibly.

            if(hero_rt_cluster_id()==0) pulp_write32(0x1c01FFF0, 0);

            // Cluster are ready to go when barrier is down

            if(pulp_read32(0x1c01FFF0)==0){
              printf("Cluster %d is ready for a new run!\n", hero_rt_cluster_id());
              break;
            }
          }

          __asm__ __volatile__ ("" : : : "memory");

        }
      }
    }
  }
}