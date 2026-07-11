# Reconstructed RTL

The RTL in this directory is a documentation-based reconstruction and is not the exact original RTL used to produce the synthesis and physical-design results in the final report.

These files are included only as an educational reference implementation based on the public behavior described in the report.

## Known Facts From The Report

- Confirmed module names: `event_detect`, `event_fsm`, and `top`
- Confirmed signal concepts: `sample_tick`, `sample_done`, `process_done`, `detect_en`, `accel_event`, `gyro_event`, `event_valid`, and `fsm_state`
- Confirmed FSM sequence: `000 -> 001 -> 010 -> 011 -> 000`
- `event_valid` is qualified by sensor event conditions and the FSM detection window
- The original `event_detect` block is much larger than this reference implementation

## Assumptions

- Verilog-2001 is used for portability.
- Sensor inputs are represented as unsigned digital values.
- Event detection is reconstructed as threshold comparison.
- The reset is modelled as active-low asynchronous reset because the report uses `rst_n`; the original reset style is not confirmed.
- Readable state labels are comments only and are reconstruction labels.
- Thresholds, input widths, sampling interval parameters, and counter widths are configurable parameters.

## Modules

### event_detect.v

Accepts accelerometer and gyroscope digital values, compares them against configurable thresholds, and produces deterministic `accel_event` and `gyro_event` outputs.

The exact original sensor preprocessing and Boolean logic are not recoverable from the documents.

### event_fsm.v

Implements a 4-state FSM encoded as:

```text
000 -> 001 -> 010 -> 011 -> 000
```

It responds to `sample_tick`, asserts `sample_done`, asserts `process_done`, opens the detection window with `detect_en`, and returns to state `000`.

### top.v

Integrates `event_detect`, `event_fsm`, and `event_valid` gating. It also exposes debug/status signals including `fsm_state`.

### tb_top.v

Self-checking testbench that demonstrates:

- Reset behavior
- FSM progression
- No-event behavior
- Accelerometer-only activity
- Gyroscope-only activity
- Combined sensor activity
- `event_valid` remaining low outside `detect_en`
- `event_valid` asserting only during the detection window when both sensor event conditions are present

The testbench may generate `tb_top.vcd` for waveform inspection.

## Simulation

If Icarus Verilog is available:

```sh
iverilog -o tb_top.out event_detect.v event_fsm.v top.v tb_top.v
vvp tb_top.out
```

These commands apply only to the reconstructed RTL in this directory. Passing simulation does not reproduce the original report's synthesis, layout, timing, or GDS-II results.

## Differences From The Original Implementation

- This reconstruction does not attempt to match the original 10,915-cell `event_detect` implementation.
- It does not reproduce the original physical design.
- It does not reproduce original timing, area, routing, utilization, DRC, LVS, or GDS-II metrics.
- It does not encode undisclosed sensor preprocessing rules.
- It is intended to make the documented control/dataflow understandable.
