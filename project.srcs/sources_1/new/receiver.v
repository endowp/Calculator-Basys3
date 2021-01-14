`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 
// 
// Create Date: 12/10/2020 10:15:11 AM
// Design Name: 
// Module Name: receiver
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


module receiver(
    input clk, bitIn,
    output reg received,
    output reg [7:0] dataOut
    );
    
    reg lastBit;
    reg receiving = 0;
    reg [7:0] count;
    
    always@(posedge clk) begin
        if (~receiving & lastBit & ~bitIn) 
        begin
            receiving <= 1;
            received <= 0;
            count <= 0;
        end

        lastBit <= bitIn;
      
        if (receiving) count <= count + 1;
        else count <= 0;
        
        case (count)
            8'd24: dataOut[0] <= bitIn;
            8'd40: dataOut[1] <= bitIn;
            8'd56: dataOut[2] <= bitIn;
            8'd72: dataOut[3] <= bitIn;
            8'd88: dataOut[4] <= bitIn;
            8'd104: dataOut[5] <= bitIn;
            8'd120: dataOut[6] <= bitIn;
            8'd136: dataOut[7] <= bitIn;
            8'd152: begin received <= 1; receiving <= 0; end
        endcase
    end
    
endmodule
