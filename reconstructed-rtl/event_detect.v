// Documentation-based reconstruction.
// This is not the original RTL used for the reported synthesis/layout results.

module event_detect #(
    parameter INPUT_WIDTH = 12,
    parameter ACCEL_THRESHOLD = 12'd1600,
    parameter GYRO_THRESHOLD = 12'd900
) (
    input  wire [INPUT_WIDTH-1:0] accel_value,
    input  wire [INPUT_WIDTH-1:0] gyro_value,
    output wire                   accel_event,
    output wire                   gyro_event
);

    assign accel_event = (accel_value >= ACCEL_THRESHOLD);
    assign gyro_event  = (gyro_value  >= GYRO_THRESHOLD);

endmodule
