`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 01:20:20 AM
// Design Name: 
// Module Name: mux_32
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


module mux_32 # (
   parameter TDATA_WIDTH = 256,
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
                32'h0: bytes_in_flit <= 0;
                32'h1: bytes_in_flit <= 1;
                32'h3: bytes_in_flit <= 2;
                32'h7: bytes_in_flit <= 3;
                32'hF: bytes_in_flit <= 4;
                32'h1F: bytes_in_flit <= 5;
                32'h3F: bytes_in_flit <= 6;
                32'h7F: bytes_in_flit <= 7;
                32'hFF: bytes_in_flit <= 8;
                32'h1FF: bytes_in_flit <= 9;
                32'h3FF: bytes_in_flit <= 10;
                32'h7FF: bytes_in_flit <= 11;
                32'hFFF: bytes_in_flit <= 12;
                32'h1FFF: bytes_in_flit <= 13;
                32'h3FFF: bytes_in_flit <= 14;
                32'h7FFF: bytes_in_flit <= 15;
                32'hFFFF: bytes_in_flit <= 16;
                32'h1FFFF: bytes_in_flit <= 17;
                32'h3FFFF: bytes_in_flit <= 18;
                32'h7FFFF: bytes_in_flit <= 19;
                32'hFFFFF: bytes_in_flit <= 20;
                32'h1FFFFF: bytes_in_flit <= 21;
                32'h3FFFFF: bytes_in_flit <= 22;
                32'h7FFFFF: bytes_in_flit <= 23;
                32'hFFFFFF: bytes_in_flit <= 24;
                32'h1FFFFFF: bytes_in_flit <= 25;
                32'h3FFFFFF: bytes_in_flit <= 26;
                32'h7FFFFFF: bytes_in_flit <= 27;
                32'hFFFFFFF: bytes_in_flit <= 28;
                32'h1FFFFFFF: bytes_in_flit <= 29;
                32'h3FFFFFFF: bytes_in_flit <= 30;
                32'h7FFFFFFF: bytes_in_flit <= 31;
                32'hFFFFFFFF: bytes_in_flit <= 32;
                32'hFFFFFFFE: bytes_in_flit <= 31;
                32'hFFFFFFFC: bytes_in_flit <= 30;
                32'hFFFFFFF8: bytes_in_flit <= 29;
                32'hFFFFFFF0: bytes_in_flit <= 28;
                32'hFFFFFFE0: bytes_in_flit <= 27;
                32'hFFFFFFC0: bytes_in_flit <= 26;
                32'hFFFFFF80: bytes_in_flit <= 25;
                32'hFFFFFF00: bytes_in_flit <= 24;
                32'hFFFFFE00: bytes_in_flit <= 23;
                32'hFFFFFC00: bytes_in_flit <= 22;
                32'hFFFFF800: bytes_in_flit <= 21;
                32'hFFFFF000: bytes_in_flit <= 20;
                32'hFFFFE000: bytes_in_flit <= 19;
                32'hFFFFC000: bytes_in_flit <= 18;
                32'hFFFF8000: bytes_in_flit <= 17;
                32'hFFFF0000: bytes_in_flit <= 16;
                32'hFFFE0000: bytes_in_flit <= 15;
                32'hFFFC0000: bytes_in_flit <= 14;
                32'hFFF80000: bytes_in_flit <= 13;
                32'hFFF00000: bytes_in_flit <= 12;
                32'hFFE00000: bytes_in_flit <= 11;
                32'hFFC00000: bytes_in_flit <= 10;
                32'hFF800000: bytes_in_flit <= 9;
                32'hFF000000: bytes_in_flit <= 8;
                32'hFE000000: bytes_in_flit <= 7;
                32'hFC000000: bytes_in_flit <= 6;
                32'hF8000000: bytes_in_flit <= 5;
                32'hF0000000: bytes_in_flit <= 4;
                32'hE0000000: bytes_in_flit <= 3;
                32'hC0000000: bytes_in_flit <= 2;
                32'h80000000: bytes_in_flit <= 1;
            endcase
        end 
    end
endmodule