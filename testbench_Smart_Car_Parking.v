`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2023 10:10:06
// Design Name: 
// Module Name: testbench_Smart_Car_Parking
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_Smart_Car_Parking();


    reg clk, reset,frontsensor,backsensor;
    reg [3:0] password;
    wire GREENLED, REDLED;

    Smart_Car_Parking_System uut(
        .reset(reset),
        .clk(clk),
        .frontsensor(frontsensor),
        .backsensor(backsensor),
        .password(password),
        .GREENLED(GREENLED),
        .REDLED(REDLED)
    );

    initial begin
        clk = 0;
        forever #1 clk = !clk;
    end

    initial begin
        reset = 0;
        #1 reset = 1;

        #10;
        frontsensor = 1'b1;
        #3 password = 4'b0101;
        // #1 password[2] = 1;
        // #1 password[1] = 0;
        // #1 password[0] = 1;

        #10 backsensor = 1'b1;
        #1 frontsensor = 1'b0;
        #20 $finish;
    end

endmodule
    
