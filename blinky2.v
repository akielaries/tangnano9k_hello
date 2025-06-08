module led (
    input sys_clk,          // 27mhz clk input
    input sys_rst_n,        // active-low reset input
    output reg red_led,
    output reg [5:0] led    // 6bit output driving LED's pins
);

reg [23:0] counter; // 24bit counter register

// 1st always block. counter logic
always @(posedge sys_clk or negedge sys_rst_n) begin
  // if reset is active (low)
  if (!sys_rst_n)
    // reset counter to 0
    counter <= 24'd0;
  // if counter has not reached 6749999 (??)
  else if (counter < 24'd674_9999)       // 0.5s delay
    // increment counter
    counter <= counter + 1'd1;
  else
    // reset counter after the max
    counter <= 24'd0;
end


// 2nd always block. LED shifting logic
always @(posedge sys_clk or negedge sys_rst_n) begin
  // if reset is active
  if (!sys_rst_n)
    // initialize the LEDs to 111110 (all leds off except 1)
    led <= 6'b111110;
    red_led <= 1'b0;
  // when counter hits the max
  else if (counter == 24'd674_9999)       // 0.5s delay
    // rotate the LED bits left for a circular shift
    led[5:0] <= {led[4:0],led[5]};
    red_led <= 1'b1;
  else
    // otherwise hold the LED's state
    led <= led;

    red_led <= red_led;
end

endmodule
