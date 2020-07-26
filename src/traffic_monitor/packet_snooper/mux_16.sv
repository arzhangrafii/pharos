`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 06:01:02 PM
// Design Name: 
// Module Name: mux_16
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


module mux_16 # (
   parameter TDATA_WIDTH = 128,
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
                16'h0: bytes_in_flit <= 0;
                16'h1: bytes_in_flit <= 1;
                16'h3: bytes_in_flit <= 2;
                16'h7: bytes_in_flit <= 3;
                16'hF: bytes_in_flit <= 4;
                16'h1F: bytes_in_flit <= 5;
                16'h3F: bytes_in_flit <= 6;
                16'h7F: bytes_in_flit <= 7;
                16'hFF: bytes_in_flit <= 8;
                16'h1FF: bytes_in_flit <= 9;
                16'h3FF: bytes_in_flit <= 10;
                16'h7FF: bytes_in_flit <= 11;
                16'hFFF: bytes_in_flit <= 12;
                16'h1FFF: bytes_in_flit <= 13;
                16'h3FFF: bytes_in_flit <= 14;
                16'h7FFF: bytes_in_flit <= 15;
                16'hFFFF: bytes_in_flit <= 16;
                16'hFFFE: bytes_in_flit <= 15;
                16'hFFFC: bytes_in_flit <= 14;
                16'hFFF8: bytes_in_flit <= 13;
                16'hFFF0: bytes_in_flit <= 12;
                16'hFFE0: bytes_in_flit <= 11;
                16'hFFC0: bytes_in_flit <= 10;
                16'hFF80: bytes_in_flit <= 9;
                16'hFF00: bytes_in_flit <= 8;
                16'hFE00: bytes_in_flit <= 7;
                16'hFC00: bytes_in_flit <= 6;
                16'hF800: bytes_in_flit <= 5;
                16'hF000: bytes_in_flit <= 4;
                16'hE000: bytes_in_flit <= 3;
                16'hC000: bytes_in_flit <= 2;
                16'h8000: bytes_in_flit <= 1;
            endcase
        end 
    end
endmodule
