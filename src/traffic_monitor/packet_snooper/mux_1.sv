`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2020 10:36:28 PM
// Design Name: 
// Module Name: mux_1
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


module mux_1 # (
   parameter TDATA_WIDTH = 8,
   parameter TKEEP_WIDTH = TDATA_WIDTH/8
) (
        input wire clk,
        input wire aresetn,
        
        input wire [TKEEP_WIDTH-1:0] input_keep,
        output logic [7:0] bytes_in_flit
    );
    
    always_ff @ (posedge clk) begin
        if (!aresetn)
            bytes_in_flit <= 0;
        else begin
            case (input_keep)
                1'b0: bytes_in_flit <= 0;
                1'b1: bytes_in_flit <= 1;
            endcase
        end 
    end
endmodule
