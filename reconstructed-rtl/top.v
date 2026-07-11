// Documentation-based reconstruction.
// This top-level model demonstrates the report's described signal sequencing.

module top #(
    parameter INPUT_WIDTH = 12,
    parameter ACCEL_THRESHOLD = 12'd1600,
    parameter GYRO_THRESHOLD = 12'd900,
    parameter COUNTER_WIDTH = 8,
    parameter SAMPLING_INTERVAL = 8'd1
) (
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   sample_tick,
    input  wire [INPUT_WIDTH-1:0] accel_value,
    input  wire [INPUT_WIDTH-1:0] gyro_value,
    output wire                   sample_done,
    output wire                   process_done,
    output wire                   detect_en,
    output wire                   accel_event,
    output wire                   gyro_event,
    output wire                   event_valid,
    output wire [2:0]             fsm_state
);

    event_detect #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .ACCEL_THRESHOLD(ACCEL_THRESHOLD),
        .GYRO_THRESHOLD(GYRO_THRESHOLD)
    ) u_event_detect (
        .accel_value(accel_value),
        .gyro_value(gyro_value),
        .accel_event(accel_event),
        .gyro_event(gyro_event)
    );

    event_fsm #(
        .COUNTER_WIDTH(COUNTER_WIDTH),
        .SAMPLING_INTERVAL(SAMPLING_INTERVAL)
    ) u_event_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .sample_tick(sample_tick),
        .sample_done(sample_done),
        .process_done(process_done),
        .detect_en(detect_en),
        .fsm_state(fsm_state)
    );

    assign event_valid = detect_en & accel_event & gyro_event;

endmodule
