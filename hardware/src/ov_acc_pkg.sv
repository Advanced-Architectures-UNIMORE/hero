
//
/*
 *
 * overlay_hwpe_pkg.sv
 *
 * HWPE specialization tool: Gianluca Bellocchi <gianluca.bellocchi@unimore.it>
 *
 * Configuration packages for the integration of HWPE accelerators in a
 * HERO-based, accelerator-rich overlay system.
 *
 */
 /*
 *
 * pulp_cluster_hwpe_pkg
 *
 * This package is to configure for PULP cluster OOC stub. Here are collected the
 * HWPE design features that need to be shared with the higher-level (with respect
 * to the HWPE module) hardware modules of the PULP system.
 *
 */
package automatic pulp_cluster_hwpe_pkg;
  localparam bit          HWPE_PRESENT = 1'b1;
  localparam int unsigned N_HWPE_PORTS = 33;
endpackage