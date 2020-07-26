`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2020 10:50:48 PM
// Design Name: 
// Module Name: mux_64
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


module mux_64 # (
   parameter TDATA_WIDTH = 512,
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
                64'h0: bytes_in_flit <= 0;
                64'h1: bytes_in_flit <= 1;
                64'h3: bytes_in_flit <= 2;
                64'h7: bytes_in_flit <= 3;
                64'hF: bytes_in_flit <= 4;
                64'h1F: bytes_in_flit <= 5;
                64'h3F: bytes_in_flit <= 6;
                64'h7F: bytes_in_flit <= 7;
                64'hFF: bytes_in_flit <= 8;
                64'h1FF: bytes_in_flit <= 9;
                64'h3FF: bytes_in_flit <= 10;
                64'h7FF: bytes_in_flit <= 11;
                64'hFFF: bytes_in_flit <= 12;
                64'h1FFF: bytes_in_flit <= 13;
                64'h3FFF: bytes_in_flit <= 14;
                64'h7FFF: bytes_in_flit <= 15;
                64'hFFFF: bytes_in_flit <= 16;
                64'h1FFFF: bytes_in_flit <= 17;
                64'h3FFFF: bytes_in_flit <= 18;
                64'h7FFFF: bytes_in_flit <= 19;
                64'hFFFFF: bytes_in_flit <= 20;
                64'h1FFFFF: bytes_in_flit <= 21;
                64'h3FFFFF: bytes_in_flit <= 22;
                64'h7FFFFF: bytes_in_flit <= 23;
                64'hFFFFFF: bytes_in_flit <= 24;
                64'h1FFFFFF: bytes_in_flit <= 25;
                64'h3FFFFFF: bytes_in_flit <= 26;
                64'h7FFFFFF: bytes_in_flit <= 27;
                64'hFFFFFFF: bytes_in_flit <= 28;
                64'h1FFFFFFF: bytes_in_flit <= 29;
                64'h3FFFFFFF: bytes_in_flit <= 30;
                64'h7FFFFFFF: bytes_in_flit <= 31;
                64'hFFFFFFFF: bytes_in_flit <= 32;
                64'h1FFFFFFFF: bytes_in_flit <= 33;
                64'h3FFFFFFFF: bytes_in_flit <= 34;
                64'h7FFFFFFFF: bytes_in_flit <= 35;
                64'hFFFFFFFFF: bytes_in_flit <= 36;
                64'h1FFFFFFFFF: bytes_in_flit <= 37;
                64'h3FFFFFFFFF: bytes_in_flit <= 38;
                64'h7FFFFFFFFF: bytes_in_flit <= 39;
                64'hFFFFFFFFFF: bytes_in_flit <= 40;
                64'h1FFFFFFFFFF: bytes_in_flit <= 41;
                64'h3FFFFFFFFFF: bytes_in_flit <= 42;
                64'h7FFFFFFFFFF: bytes_in_flit <= 43;
                64'hFFFFFFFFFFF: bytes_in_flit <= 44;
                64'h1FFFFFFFFFFF: bytes_in_flit <= 45;
                64'h3FFFFFFFFFFF: bytes_in_flit <= 46;
                64'h7FFFFFFFFFFF: bytes_in_flit <= 47;
                64'hFFFFFFFFFFFF: bytes_in_flit <= 48;
                64'h1FFFFFFFFFFFF: bytes_in_flit <= 49;
                64'h3FFFFFFFFFFFF: bytes_in_flit <= 50;
                64'h7FFFFFFFFFFFF: bytes_in_flit <= 51;
                64'hFFFFFFFFFFFFF: bytes_in_flit <= 52;
                64'h1FFFFFFFFFFFFF: bytes_in_flit <= 53;
                64'h3FFFFFFFFFFFFF: bytes_in_flit <= 54;
                64'h7FFFFFFFFFFFFF: bytes_in_flit <= 55;
                64'hFFFFFFFFFFFFFF: bytes_in_flit <= 56;
                64'h1FFFFFFFFFFFFFF: bytes_in_flit <= 57;
                64'h3FFFFFFFFFFFFFF: bytes_in_flit <= 58;
                64'h7FFFFFFFFFFFFFF: bytes_in_flit <= 59;
                64'hFFFFFFFFFFFFFFF: bytes_in_flit <= 60;
                64'h1FFFFFFFFFFFFFFF: bytes_in_flit <= 61;
                64'h3FFFFFFFFFFFFFFF: bytes_in_flit <= 62;
                64'h7FFFFFFFFFFFFFFF: bytes_in_flit <= 63;
                64'hFFFFFFFFFFFFFFFF: bytes_in_flit <= 64;
                64'hFFFFFFFFFFFFFFFE: bytes_in_flit <= 63;
                64'hFFFFFFFFFFFFFFFC: bytes_in_flit <= 62;
                64'hFFFFFFFFFFFFFFF8: bytes_in_flit <= 61;
                64'hFFFFFFFFFFFFFFF0: bytes_in_flit <= 60;
                64'hFFFFFFFFFFFFFFE0: bytes_in_flit <= 59;
                64'hFFFFFFFFFFFFFFC0: bytes_in_flit <= 58;
                64'hFFFFFFFFFFFFFF80: bytes_in_flit <= 57;
                64'hFFFFFFFFFFFFFF00: bytes_in_flit <= 56;
                64'hFFFFFFFFFFFFFE00: bytes_in_flit <= 55;
                64'hFFFFFFFFFFFFFC00: bytes_in_flit <= 54;
                64'hFFFFFFFFFFFFF800: bytes_in_flit <= 53;
                64'hFFFFFFFFFFFFF000: bytes_in_flit <= 52;
                64'hFFFFFFFFFFFFE000: bytes_in_flit <= 51;
                64'hFFFFFFFFFFFFC000: bytes_in_flit <= 50;
                64'hFFFFFFFFFFFF8000: bytes_in_flit <= 49;
                64'hFFFFFFFFFFFF0000: bytes_in_flit <= 48;
                64'hFFFFFFFFFFFE0000: bytes_in_flit <= 47;
                64'hFFFFFFFFFFFC0000: bytes_in_flit <= 46;
                64'hFFFFFFFFFFF80000: bytes_in_flit <= 45;
                64'hFFFFFFFFFFF00000: bytes_in_flit <= 44;
                64'hFFFFFFFFFFE00000: bytes_in_flit <= 43;
                64'hFFFFFFFFFFC00000: bytes_in_flit <= 42;
                64'hFFFFFFFFFF800000: bytes_in_flit <= 41;
                64'hFFFFFFFFFF000000: bytes_in_flit <= 40;
                64'hFFFFFFFFFE000000: bytes_in_flit <= 39;
                64'hFFFFFFFFFC000000: bytes_in_flit <= 38;
                64'hFFFFFFFFF8000000: bytes_in_flit <= 37;
                64'hFFFFFFFFF0000000: bytes_in_flit <= 36;
                64'hFFFFFFFFE0000000: bytes_in_flit <= 35;
                64'hFFFFFFFFC0000000: bytes_in_flit <= 34;
                64'hFFFFFFFF80000000: bytes_in_flit <= 33;
                64'hFFFFFFFF00000000: bytes_in_flit <= 32;
                64'hFFFFFFFE00000000: bytes_in_flit <= 31;
                64'hFFFFFFFC00000000: bytes_in_flit <= 30;
                64'hFFFFFFF800000000: bytes_in_flit <= 29;
                64'hFFFFFFF000000000: bytes_in_flit <= 28;
                64'hFFFFFFE000000000: bytes_in_flit <= 27;
                64'hFFFFFFC000000000: bytes_in_flit <= 26;
                64'hFFFFFF8000000000: bytes_in_flit <= 25;
                64'hFFFFFF0000000000: bytes_in_flit <= 24;
                64'hFFFFFE0000000000: bytes_in_flit <= 23;
                64'hFFFFFC0000000000: bytes_in_flit <= 22;
                64'hFFFFF80000000000: bytes_in_flit <= 21;
                64'hFFFFF00000000000: bytes_in_flit <= 20;
                64'hFFFFE00000000000: bytes_in_flit <= 19;
                64'hFFFFC00000000000: bytes_in_flit <= 18;
                64'hFFFF800000000000: bytes_in_flit <= 17;
                64'hFFFF000000000000: bytes_in_flit <= 16;
                64'hFFFE000000000000: bytes_in_flit <= 15;
                64'hFFFC000000000000: bytes_in_flit <= 14;
                64'hFFF8000000000000: bytes_in_flit <= 13;
                64'hFFF0000000000000: bytes_in_flit <= 12;
                64'hFFE0000000000000: bytes_in_flit <= 11;
                64'hFFC0000000000000: bytes_in_flit <= 10;
                64'hFF80000000000000: bytes_in_flit <= 9;
                64'hFF00000000000000: bytes_in_flit <= 8;
                64'hFE00000000000000: bytes_in_flit <= 7;
                64'hFC00000000000000: bytes_in_flit <= 6;
                64'hF800000000000000: bytes_in_flit <= 5;
                64'hF000000000000000: bytes_in_flit <= 4;
                64'hE000000000000000: bytes_in_flit <= 3;
                64'hC000000000000000: bytes_in_flit <= 2;
                64'h8000000000000000: bytes_in_flit <= 1;
            endcase
        end 
    end
endmodule