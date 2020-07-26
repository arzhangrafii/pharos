`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 06:03:37 PM
// Design Name: 
// Module Name: mux_8
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


module mux_8 # (
  parameter TDATA_WIDTH = 64,
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
               8'h0: bytes_in_flit <= 0;
               8'h1: bytes_in_flit <= 1;
               8'h3: bytes_in_flit <= 2;
               8'h7: bytes_in_flit <= 3;
               8'hF: bytes_in_flit <= 4;
               8'h1F: bytes_in_flit <= 5;
               8'h3F: bytes_in_flit <= 6;
               8'h7F: bytes_in_flit <= 7;
               8'hFF: bytes_in_flit <= 8;
               8'hFE: bytes_in_flit <= 7;
               8'hFC: bytes_in_flit <= 6;
               8'hF8: bytes_in_flit <= 5;
               8'hF0: bytes_in_flit <= 4;
               8'hE0: bytes_in_flit <= 3;
               8'hC0: bytes_in_flit <= 2;
               8'h80: bytes_in_flit <= 1;
           endcase
       end 
   end
endmodule
