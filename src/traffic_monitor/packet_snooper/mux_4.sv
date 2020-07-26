`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 06:07:15 PM
// Design Name: 
// Module Name: mux_4
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


module mux_4 # (
   parameter TDATA_WIDTH = 32,
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
                4'h0: bytes_in_flit <= 0;
                4'h1: bytes_in_flit <= 1;
                4'h3: bytes_in_flit <= 2;
                4'h7: bytes_in_flit <= 3;
                4'hF: bytes_in_flit <= 4;
                4'hE: bytes_in_flit <= 3;
                4'hC: bytes_in_flit <= 2;
                4'h8: bytes_in_flit <= 1;
            endcase
        end 
    end
endmodule
