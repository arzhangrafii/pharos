`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 06:09:43 PM
// Design Name: 
// Module Name: mux_2
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


module mux_2 # (
   parameter TDATA_WIDTH = 16,
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
                2'b00: bytes_in_flit <= 0;
                2'b01: bytes_in_flit <= 1;
                2'b11: bytes_in_flit <= 2;
                2'b10: bytes_in_flit <= 1;
            endcase
        end 
    end
endmodule
