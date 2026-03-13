/* =====================================================================
 * Project:      System model
 * Title:        experiment.h
 * Description:  Multi cluster scaling
 *
 * $Date:        17.7.2022
 * ===================================================================== */
/*
 * Copyright (C) 2022 University of Modena and Reggio Emilia.
 *
 * Author: Gianluca Bellocchi, University of Modena and Reggio Emilia.
 *
 */

#ifndef __EXPERIMENT_H__
#define __EXPERIMENT_H__

/* Libraries */

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <errno.h>

/* System. */

#include <common_structs/def_struct_hesoc_perf_eval.h>
#include <hero-target.h>
#include <richie-target.h>

// #include <hal/pulp_io.h>
#include <archi/eu/eu_v3.h>
#include <hal/eu/eu_v3.h>

#include "traffic_gen.h"

#include "pulp_defs.h"

// /* PULP architecture */

// #include <archi/chips/bigpulp/memory_map.h>

// Stimuli
#include "inc/stim/r_reqs_dut.h"
#include "inc/stim/w_reqs_dut.h"
#include "inc/stim/w_reqs_ref.h"

#endif