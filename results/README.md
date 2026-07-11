# Reported Results Summary

The values in this directory summarize the original project results documented in the final report. They should not be interpreted as results for the reconstructed RTL.

## Synthesis Results

| Module | Reported result |
|---|---:|
| `event_detect` | 10,915 cells |
| `event_fsm` | 26 cells |
| `top` | 185 cells |
| Top-level flip-flops | 35 |

The final report describes `event_detect` as the dominant computational block and `event_fsm` as a compact controller.

## Physical Design Metrics

| Metric | Value |
|---|---:|
| Die area | 0.2471 mm² |
| Core area | 229,900.49 µm² |
| Core utilization target | 40% |
| Achieved utilization | 41.18% |
| Synthesized cell count | 9,369 |
| Total physical cells | 29,936 |
| Wire length | 305,212 |
| Via count | 68,115 |
| Worst negative slack | -2.77 ns |
| Total negative slack | -23.61 ns |
| Critical path | 10.76 ns |
| Suggested clock period | 12.71 ns |
| Suggested frequency | 78.68 MHz |
| DRC violations | 0 |
| LVS errors | 0 |

## Physical Verification

The report states:

- DRC = 0
- LVS = 0

This indicates no reported geometry-rule violations and no reported layout-versus-netlist connectivity mismatch.

## Timing Status

The original OpenLane run was not fully timing-closed.

- Worst negative slack: -2.77 ns
- Total negative slack: -23.61 ns
- Setup violations remain
- Reported flow status: failed due to timing

This is a timing-performance limitation, not a DRC or LVS failure.
