`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2020 09:24:04 AM
// Design Name: 
// Module Name: main
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


module main(
    output [6:0] seg,
    output dp, RsTx,
    output [3:0] an,
    input clk, RsRx
    );
    
    reg lastR, enb;
    reg [7:0] dIn;
    reg [15:0] a, b; //two operands
    reg [3:0] state;
    
    wire sent, received, baud;
    wire [7:0] dOut;
    wire [3:0] num0, num1, num2, num3;
    
    baudrateGen baudrateGen1(clk, baud);
    receiver receiver1(baud, RsRx, received, dOut);
    transmitter transmitter1(baud, dIn, enb, sent, RsTx);
    quadSevenSeg q7seg(seg, dp, an0, an1, an2, an3, num0, num1, num2, num3, baud); 
    
    assign an = {an3,an2,an1,an0};
    assign num0 = (a%(4'b1010));
    assign num1 = (a/4'b1010)%(4'b1010);
    assign num2 = (a/7'b1100100)%(4'b1010);
    assign num3 = (a/10'b1111101000)%(4'b1010);
    
    initial
    begin
        a = 0;
        state = 0;
    end

    always @(posedge baud)
    begin
        if (enb == 1) enb = 0;
        if (~lastR & received)
        begin
            enb = 1;
            dIn = dOut;
    
            if(dOut == 8'd99) // c = clear/reset
            begin 
                a = 0;
                state = 0;
            end
            
            if(dOut >= 8'd48 && dOut <= 8'd57)// get operand, number 0-9
            begin 
                a = a*10 + dOut - 8'd48;
                if(a > 9999)
                begin
                    a = 0;
                    state = 0;
                end
            end
            
            if(state == 0) // get operator, + - * /
            case(dOut)
                8'd43: begin // + (plus)
                    b = a;
                    a = 0;
                    state = 1;
                end
                8'd45: begin // - (minus)
                     b = a;
                     a = 0;
                     state = 2;
                end
                8'd42: begin// * (multiply)
                    b = a;
                    a = 0;
                    state = 3;
                end
                8'd47: begin // / (divide)
                    b = a;
                    a = 0;
                    state = 4;
                end
            endcase
            
            if(state != 0 && dOut == 8'd121) // y (calculate)
            begin 
                case(state)
                    1: begin //plus
                        a = b + a;
                        if(a > 9999) a = 16'b1010101010101010;
                    end
                    2: begin //minus
                        a = b - a;
                        if(a > 9999) a = 16'b1010101010101010;
                    end
                    3: begin //multiply
                        a = b * a;
                        if(a > 9999) a = 16'b1010101010101010;
                    end
                    4: a = b / a; //divide
                endcase
                state = 0;
            end
        end
        lastR = received;
    end 

endmodule
