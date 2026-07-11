`timescale 1ns/1ps

module tb_top;

    localparam INPUT_WIDTH = 12;
    localparam ACCEL_THRESHOLD = 12'd1600;
    localparam GYRO_THRESHOLD = 12'd900;

    reg clk;
    reg rst_n;
    reg sample_tick;
    reg [INPUT_WIDTH-1:0] accel_value;
    reg [INPUT_WIDTH-1:0] gyro_value;

    wire sample_done;
    wire process_done;
    wire detect_en;
    wire accel_event;
    wire gyro_event;
    wire event_valid;
    wire [2:0] fsm_state;

    integer failures;

    top #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .ACCEL_THRESHOLD(ACCEL_THRESHOLD),
        .GYRO_THRESHOLD(GYRO_THRESHOLD),
        .COUNTER_WIDTH(4),
        .SAMPLING_INTERVAL(4'd1)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .sample_tick(sample_tick),
        .accel_value(accel_value),
        .gyro_value(gyro_value),
        .sample_done(sample_done),
        .process_done(process_done),
        .detect_en(detect_en),
        .accel_event(accel_event),
        .gyro_event(gyro_event),
        .event_valid(event_valid),
        .fsm_state(fsm_state)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task expect;
        input condition;
        input [1023:0] message;
        begin
            if (!condition) begin
                failures = failures + 1;
                $display("FAIL: %0s at time %0t", message, $time);
            end else begin
                $display("PASS: %0s", message);
            end
        end
    endtask

    task start_window;
        begin
            sample_tick = 1'b1;
            @(posedge clk);
            #1;
            sample_tick = 1'b0;
        end
    endtask

    task run_detection_window;
        input [INPUT_WIDTH-1:0] accel_stimulus;
        input [INPUT_WIDTH-1:0] gyro_stimulus;
        input expected_event;
        input [1023:0] label_text;
        begin
            accel_value = accel_stimulus;
            gyro_value = gyro_stimulus;

            start_window();
            expect(fsm_state == 3'b001, {label_text, ": state 001 after sample tick"});
            expect(sample_done == 1'b1, {label_text, ": sample_done asserted"});
            expect(event_valid == 1'b0, {label_text, ": event_valid low during sampling"});

            @(posedge clk);
            #1;
            expect(fsm_state == 3'b010, {label_text, ": state 010 during processing"});
            expect(process_done == 1'b1, {label_text, ": process_done asserted"});
            expect(event_valid == 1'b0, {label_text, ": event_valid low during processing"});

            @(posedge clk);
            #1;
            expect(fsm_state == 3'b011, {label_text, ": state 011 during detection"});
            expect(detect_en == 1'b1, {label_text, ": detect_en asserted"});
            expect(event_valid == expected_event, {label_text, ": event_valid matches expected detection"});

            @(posedge clk);
            #1;
            expect(fsm_state == 3'b000, {label_text, ": returned to state 000"});
            expect(event_valid == 1'b0, {label_text, ": event_valid low outside detection window"});
        end
    endtask

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        failures = 0;
        rst_n = 1'b0;
        sample_tick = 1'b0;
        accel_value = 12'd0;
        gyro_value = 12'd0;

        repeat (2) @(posedge clk);
        #1;
        expect(fsm_state == 3'b000, "reset drives FSM to 000");
        expect(event_valid == 1'b0, "event_valid low during reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        expect(fsm_state == 3'b000, "FSM remains idle after reset deassertion");

        run_detection_window(12'd100, 12'd100, 1'b0, "no event");
        run_detection_window(12'd1800, 12'd100, 1'b0, "accelerometer only");
        run_detection_window(12'd100, 12'd1000, 1'b0, "gyroscope only");
        run_detection_window(12'd1800, 12'd1000, 1'b1, "combined sensor event");

        if (failures == 0) begin
            $display("PASS: all reconstructed RTL checks completed");
        end else begin
            $display("FAIL: %0d reconstructed RTL check(s) failed", failures);
        end

        $finish;
    end

endmodule
