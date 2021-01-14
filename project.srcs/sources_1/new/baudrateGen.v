`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2020 09:45:03 AM
// Design Name: 
// Module Name: baudrateGen
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


module baudrateGen(
    input clk,
    output baud
    );
    
    reg baud;
    integer counter;
    always @(posedge clk)
    begin
        counter = counter + 1;
        if (counter == 325) 
        begin 
            counter = 0; 
            baud = ~baud; 
        end
    end
endmodule
