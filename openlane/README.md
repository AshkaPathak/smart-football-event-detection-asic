# OpenLane Flow Notes

The final report states that the original design was taken through an open-source digital ASIC flow using Yosys, OpenLane, OpenROAD, and the SkyWater SKY130 PDK.

The reported flow included:

1. RTL design
2. Testbench simulation
3. Functional waveform verification
4. Yosys synthesis
5. Floorplanning
6. Placement
7. Clock-tree preparation
8. Routing
9. DRC
10. LVS
11. Post-layout metric extraction
12. GDS-II generation

## Important Note

This directory does not contain the original OpenLane configuration, constraints, scripts, run directory, DEF files, GDS files, or timing reports.

No file in this directory should be interpreted as the original physical-design setup unless a genuine original artifact is added later and clearly identified.

If an example OpenLane setup is added for the reconstructed RTL in the future, it should be labelled:

> Reference configuration for the reconstructed RTL; not the original project configuration.

## Reported Status

The report shows clean physical verification:

- DRC violations: 0
- LVS errors: 0

The report also states that timing closure was not achieved:

- WNS: -2.77 ns
- TNS: -23.61 ns
- Flow status: failed because of timing

This means the layout is reported as geometrically and logically clean, but not fully timing-closed.
