module carparking(
    input clk, reset,frontsensor,backsensor,
    input [3:0] password,
    output GREENLED, REDLED
);

    parameter IDLE = 3'b000, CHECKSLOT = 3'b001, WAIT_PASSWORD = 3'b010, RIGHT_PASSWORD = 3'b011, STOP = 3'b100;
    reg [3:0] current_state, next_state;
    reg green_tmp, red_tmp;
    reg [31:0] counterwait, space_cnt;

    //changing to next state
    always@(posedge clk or negedge reset)begin
        if(negedge reset)
            current_state = IDLE;
        else
            current_state = next_state; 
    end

    //counter_wait in WAIT_PASSWORD state
    always@(posedge clk , negedge reset)begin
        if(negedge reset)
            counterwait <= 0;
        else if(current_state == WAIT_PASSWORD)
            counterwait <= counterwait + 1;
        else
            counterwait <= 0; 
    end

    //space count in CHECKSLOT state
    always@(posedge clk)begin
        if(current_state == RIGHT_PASSWORD && backsensor==1)
            space_cnt <= space_cnt + 1; 
        else
            space_cnt <= space_cnt;
    end

    //deciding what should be the next_state according to the input data available;
    always @(*) begin
        case(current_state)
        IDLE: begin
            if(frontsensor == 1)
                next_state = CHECKSLOT;
            else
                next_state = IDLE; 
        end
        CHECKSLOT:begin
            if(space_cnt < 10)
                $display("Yes there is space now enter the password within 3 seconds");
                next_state = WAIT_PASSWORD;
            else
                next_state = CHECKSLOT;   
        end
        WAIT_PASSWORD:begin
            if(counterwait<3)
                next_state = WAIT_PASSWORD;
            else begin
                if(password == 4'b0101)
                    next_state = RIGHT_PASSWORD;
                else begin
                    next_state = WAIT_PASSWORD;
                    counterwait = 0;
                end
            end
        end
        RIGHT_PASSWORD:begin
            if(backsensor == 0)
                next_state = RIGHT_PASSWORD;
            else if(backsensor == 1 && frontsensor == 0)
                next_state = IDLE;
            else if(frontsensor == 1 && backsensor == 1)
                next_state = STOP;
        end
        STOP:begin
            if(space_cnt>=10)
                next_state = STOP;
            else begin
                if(password == 4'b0110)
                    next_state = RIGHT_PASSWORD;
                else
                    next_state = STOP;
            end
        end 
        endcase
    end

    //now deciding the output at each state i.e. changing the period of LED OUTPUTS here
    always @(posedge clk) begin
        case(current_state)
        IDLE: begin
            green_tmp = 1'b0;
            red_tmp = 1'b0;
        end
        WAIT_PASSWORD: begin
            green_tmp = 1'b0;
            red_tmp = 1'b1;
        end
        CHECKSLOT: begin
            green_tmp = 1'b0;
            red_tmp = 1'b1;
        end
        RIGHT_PASS: begin
            green_tmp = ~green_tmp;
            red_tmp = 1'b0; 
        end
        STOP: begin
            green_tmp = 1'b0;
            red_tmp = ~red_tmp; 
        end
        endcase
    end

    assign REDLED = red_tmp  ;
    assign GREENLED = green_tmp;

endmodule
