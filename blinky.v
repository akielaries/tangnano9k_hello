module top (
	// Clock input
	input clk,
	// Input from a key or button for controlling the blinking rate
	input key,

	// Output to control LEDs
	output [`LEDS_NR-1:0] led
);

// Register to hold the current count value
//reg [25:0] ctr_q;
reg [28:0] ctr_q;

// Wire to calculate the next count value
//wire [25:0] ctr_d;
wire [28:0] ctr_d;

// Sequential code (flip-flop)
always @(posedge clk) begin
	if (key) begin
		// Update the count value on positive edge of the clock if the key is pressed
		ctr_q <= ctr_d;
	end
end

// Combinational code (boolean logic)

// increment count by 1
assign ctr_d = ctr_q + 1'b1;

// Drive LED outputs based on the most significant bit of the count value
// This effectively divides the clock frequency by 2^(`LEDS_NR), causing LEDs to blink at a slower rate
//assign led = ctr_q[25:25-(`LEDS_NR - 1)];
assign led = ctr_q[28:28-(`LEDS_NR - 1)];

endmodule
