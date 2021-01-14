`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2020 10:13:53 AM
// Design Name: 
// Module Name: transmitter
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


module transmitter(
    input clk,
    input [7:0] dTransmit,
    input enb,
    output sent, bitOut
);
    reg sent, bitOut, lastEnb;
    reg sending = 0;
    reg [7:0] count, tmp;
    
    always@(posedge clk) 
    begin
        if (~sending & ~lastEnb & enb) 
        begin
            tmp <= dTransmit;
            sending <= 1;
            sent <= 0;
            count <= 0;
        end
        
        lastEnb <= enb;
        
        if (sending) count <= count + 1;
        else begin count <= 0; bitOut <= 1; end
        
        case (count)
            8'd8: bitOut <= 0;
            8'd24: bitOut <= tmp[0];  
            8'd40: bitOut <= tmp[1];
            8'd56: bitOut <= tmp[2];
            8'd72: bitOut <= tmp[3];
            8'd88: bitOut <= tmp[4];
            8'd104: bitOut <= tmp[5];
            8'd120: bitOut <= tmp[6];
            8'd136: bitOut <= tmp[7];
            8'd152: begin 
                        sent <= 1; 
                        sending <= 0; 
                    end
        endcase
    end
    
endmodule
