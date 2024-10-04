`timescale 1ns / 1ps
module lab4(
  input  clk,            // System clock at 100 MHz
  input  reset_n,        // System reset signal, in negative logic
  input  [3:0] usr_btn,  // Four user pushbuttons
  output [3:0] usr_led   // Four yellow LEDs
);

reg [3:0] usr_led;
wire [3:0] btn, btnIsPressed;
reg [3:0] beforeClk_btn, brightness;
reg signed [3:0] counter = 0;
reg [19:0] pwm = 0;

checkdb button0(clk, usr_btn[0], btn[0]);
checkdb button1(clk, usr_btn[1], btn[1]);
checkdb button2(clk, usr_btn[2], btn[2]);
checkdb button3(clk, usr_btn[3], btn[3]);

integer i;
always @(posedge clk) begin
    for(i = 0; i < 4; i = i + 1)begin
    if (!reset_n)
        beforeClk_btn[i] <= 0;
    else
        beforeClk_btn[i] <= btn[i];
    end
end

assign btnIsPressed[0] = (btn[0] == 1 && beforeClk_btn[0] == 0);
assign btnIsPressed[1] = (btn[1] == 1 && beforeClk_btn[1] == 0);
assign btnIsPressed[2] = (btn[2] == 1 && beforeClk_btn[2] == 0);
assign btnIsPressed[3] = (btn[3] == 1 && beforeClk_btn[3] == 0);

always@(posedge clk)begin
    if(!reset_n)
        counter = 0;
    else begin
        if(btnIsPressed[1] == 1 && counter < 7)
            counter <= counter + 1;
        else if(btnIsPressed[0] == 1 && counter > -8 )
            counter <= counter - 1;
        if(btnIsPressed[2] == 1 && brightness < 4)
            brightness <= brightness + 1;
        else if(btnIsPressed[3] == 1 && brightness > 0)
            brightness <= brightness - 1;
    end
        case(brightness)
        0:
            if(pwm <=  50000)
                usr_led <= counter;
            else
                usr_led <= 0;
        1:
            if(pwm <= 250000)
                usr_led <= counter;
            else
                usr_led <= 0;
        2:
            if(pwm <= 500000)
                usr_led <= counter;
            else
                usr_led <= 0;
        3:
            if(pwm <= 750000)
                usr_led <= counter;
            else
                usr_led <= 0;
        4:
            usr_led <= counter;
        endcase
        
        if(pwm < 1000000)
            pwm <= pwm + 1;
        else
            pwm <= 0;
end

endmodule

module checkdb(input clk, input btn_input, output reg btn_output);
    reg [31:0] timer = 0;
    always@(posedge clk) begin
        if(btn_input == 1) timer <= timer + 1;
        else begin
            timer <= 0;
            btn_output = 0;
        end
        if(timer == 1000000) btn_output = 1;
    end
endmodule