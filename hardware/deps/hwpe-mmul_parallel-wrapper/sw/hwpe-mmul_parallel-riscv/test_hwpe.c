
/*
 * Copyright (C) 2019 ETH Zurich and University of Bologna
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*
 *
 * Authors:     Gianluca Bellocchi <gianluca.bellocchi@unimore.it>
 *
 */
/* Libraries inclusion */
#include <omp.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include "inc/hwpe_lib/archi_hwpe.h"
#include "inc/hwpe_lib/hal_hwpe.h"
#include "inc/hero_lib/hero_memory_map.h"
#include "inc/hero_lib/pulp_fc.h"
#include "inc/test_lib/test_hwpe.h"
/* Stimuli */
#include "inc/stim/stim_def.h"
#include "inc/stim/stim_input.h"
#include "inc/stim/reg_values.h"
#include "inc/stim/results.h"
/* Defines */
#include "inc/test_lib/defines.h"
/* HWPE test */
int MMUL_PARALLEL(uint32_t stim_dim, uint32_t stripe_len) {
  /* Init */
  omp_set_num_threads(1);
  volatile int errors = 0;
  int i,j,k,cnt;
  int offload_id_tmp, offload_id;
  const unsigned stim_dim_local   = hero_tryread((unsigned int *)&stim_dim);
  const unsigned stripe_len_local = hero_tryread((unsigned int *)&stripe_len);
  const unsigned num_unfiltered = stim_dim_local;
  const unsigned num_stripe     = num_unfiltered / stripe_len_local;
  /* L2 init - Input stimuli */
  int32_t * in1_l2 = (int32_t *)malloc(sizeof(int32_t)*num_unfiltered);
  int32_t * in2_l2 = (int32_t *)malloc(sizeof(int32_t)*num_unfiltered);
  memset((void *)in1_l2, 0, (size_t)(num_unfiltered));
  memset((void *)in2_l2, 0, (size_t)(num_unfiltered));
  /* L2 init - Output result */
  int32_t * out_r_l2  = (int32_t *)malloc(sizeof(int32_t)*num_unfiltered);
  memset((void *)out_r_l2,  0, (size_t)(num_unfiltered));
  #if DB
  #else
    /* L1 init - Input stimuli */
    int32_t * in1_l1 = hero_l1malloc(sizeof(int32_t)*stripe_len_local);
    int32_t * in2_l1 = hero_l1malloc(sizeof(int32_t)*stripe_len_local);
    memset((void *)in1_l1, 0, (size_t)(stripe_len_local));
    memset((void *)in2_l1, 0, (size_t)(stripe_len_local));
    /* L1 init - Output result */
    int32_t * out_r_l1  = hero_l1malloc(sizeof(int32_t)*stripe_len_local);
    memset((void *)out_r_l1,  0, (size_t)(num_unfiltered));
  #endif
  #if DB
  #else
    hwpe_cg_enable();
    /* Processing loops */
    for (i = 0; i < (num_stripe); i++){
      while((offload_id_tmp = hwpe_acquire_job()) < 0)
      /* Micro-code processor */
      // Set up bytecode
      hwpe_bytecode_set(HWPE_LOOPS1_OFFS,           0x00000000);
      hwpe_bytecode_set(HWPE_BYTECODE5_LOOPS0_OFFS, 0x00040000);
      hwpe_bytecode_set(HWPE_BYTECODE4_OFFS,        0x00000000);
      hwpe_bytecode_set(HWPE_BYTECODE3_OFFS,        0x00000000);
      hwpe_bytecode_set(HWPE_BYTECODE2_OFFS,        0x00000000);
      hwpe_bytecode_set(HWPE_BYTECODE1_OFFS,        0x000008cd);
      hwpe_bytecode_set(HWPE_BYTECODE0_OFFS,        0x11a12c05);
      // Ucode parameters
      hwpe_nb_iter_set(1);
      hwpe_vectstride_set(sizeof(in1_l1)*4);
      /* Job-dependent programming */
      int32_t * curr_in1_l2 = (int32_t *) (in1_l2 + i*stripe_len_local);
      int32_t * curr_in2_l2 = (int32_t *) (in2_l2 + i*stripe_len_local);
      int32_t * curr_out_r_l2 = (int32_t *) (out_r_l2 + i*stripe_len_local);
      // Stripe -> TCDM
      hero_dma_memcpy((void *)in1_l1, curr_in1_l2, sizeof(int32_t)*stripe_len_local);
      hero_dma_memcpy((void *)in2_l1, curr_in2_l2, sizeof(int32_t)*stripe_len_local);
      // Set TCDM address reg values
      hwpe_a_addr_set( in1_l1 );
      hwpe_b_addr_set( in2_l1 );
      hwpe_c_addr_set( out_r_l1 );
      hwpe_len_iter_set(stripe_len_local-1);
      // Set custom reg values
      hwpe_trigger_job();
      printf("Start of processing - STATUS: %x , STRIPE #%d\n", hwpe_get_status(), i);
      // Handle interrupt
      int u=1;
      while(u){
        if (HWPE_READ(HWPE_FINISHED))
          u=0;
      }
      printf("End of processing - STATUS: %x , STRIPE #%d\n", hwpe_get_status(), i);
      // Stripe -> L2
      hero_dma_memcpy(curr_out_r_l2 , (void *)out_r_l1, sizeof(int32_t)*stripe_len_local);
      hwpe_soft_clear();
    }
    hwpe_cg_disable();
    /* Free L1 memory */
    hero_l1free(in1_l1);
    hero_l1free(in2_l1);
    hero_l1free(out_r_l1);
  #endif
  /* Error check */
  //
  /* Free L2 memory */
  free(in1_l2);
  free(in2_l2);
  free(out_r_l2);
  /* Return errors */
  *(int *) 0x80000000 = errors;
  printf("errors: %d\n", errors);
  printf("end\n");
  return errors;
}
int main() {
  /* Dimension of stimuli array */
  uint32_t stim_dim   = STIM_DIM;
  /* Length of single stimuli stripe */
  uint32_t stripe_len = STRIPE_LEN;
  while(!MMUL_PARALLEL(stim_dim, stripe_len))
  return 0;
}