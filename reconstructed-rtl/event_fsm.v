// Documentation-based reconstruction.
// State labels are reconstruction labels for readability only.

module event_fsm #(
    parameter COUNTER_WIDTH = 8,
    parameter SAMPLING_INTERVAL = 8'd1
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       sample_tick,
    output reg        sample_done,
    output reg        process_done,
    output reg        detect_en,
    output reg  [2:0] fsm_state
);

    localparam [2:0] ST_IDLE    = 3'b000;
    localparam [2:0] ST_SAMPLE  = 3'b001;
    localparam [2:0] ST_PROCESS = 3'b010;
    localparam [2:0] ST_DETECT  = 3'b011;

    reg [COUNTER_WIDTH-1:0] sample_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fsm_state    <= ST_IDLE;
            sample_count <= {COUNTER_WIDTH{1'b0}};
        end else begin
            case (fsm_state)
                ST_IDLE: begin
                    sample_count <= {COUNTER_WIDTH{1'b0}};
                    if (sample_tick) begin
                        fsm_state <= ST_SAMPLE;
                    end
                end

                ST_SAMPLE: begin
                    if (sample_count >= SAMPLING_INTERVAL - 1'b1) begin
                        sample_count <= {COUNTER_WIDTH{1'b0}};
                        fsm_state    <= ST_PROCESS;
                    end else begin
                        sample_count <= sample_count + 1'b1;
                    end
                end

                ST_PROCESS: begin
                    fsm_state <= ST_DETECT;
                end

                ST_DETECT: begin
                    fsm_state <= ST_IDLE;
                end

                default: begin
                    fsm_state <= ST_IDLE;
                end
            endcase
        end
    end

    always @(*) begin
        sample_done  = (fsm_state == ST_SAMPLE);
        process_done = (fsm_state == ST_PROCESS);
        detect_en    = (fsm_state == ST_DETECT);
    end

endmodule
