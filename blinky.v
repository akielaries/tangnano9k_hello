module led (
  input sys_clk,          // 27 MHz clock input
  input sys_rst_n,        // active-low reset input
  output reg red_led,
  output reg [5:0] led    // 6-bit output driving LED pins
);

reg [23:0] led_counter;       // LED shifting counter
reg [24:0] red_led_counter;   // Red LED blinking counter

// LED and red_led counter logic
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    led_counter <= 24'd0;
    red_led_counter <= 25'd0;
  end else begin
    // increment both independently
    if (led_counter < 24'd674_9999)
      led_counter <= led_counter + 1'd1;
    else
      led_counter <= 24'd0;

    if (red_led_counter < 25'd13_499_999)  // e.g., 1s blink
      red_led_counter <= red_led_counter + 1'd1;
    else
      red_led_counter <= 25'd0;
  end
end

// LED shifting and red_led blinking logic
always @(posedge sys_clk or negedge sys_rst_n) begin
  if (!sys_rst_n) begin
    led <= 6'b111110;
    red_led <= 1'b0;
  end else begin
    // Shift the LED bits when led_counter hits max
    if (led_counter == 24'd674_9999)
      led <= {led[4:0], led[5]};

    // Toggle red_led when red_led_counter hits max
    if (red_led_counter == 25'd13_499_999)
      red_led <= ~red_led;
  end
end

endmodule

