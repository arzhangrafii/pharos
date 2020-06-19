`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2020 11:52:15 PM
// Design Name: 
// Module Name: monitorizer
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


module monitorizer # (
    parameter TDATA_WIDTH = 512,
    parameter TKEEP_WIDTH = TDATA_WIDTH/8,
    parameter TDEST_WIDTH = 16,
    parameter TID_WIDTH = 16
) (
    //Dummy clock to get rid of clock warning
    input wire clk,
    
    //Monitor interface
    input wire [TDATA_WIDTH -1:0] mon_TDATA,
    input wire [TKEEP_WIDTH -1:0] mon_TKEEP,
    input wire [TDEST_WIDTH -1:0] mon_TDEST,
    input wire [TID_WIDTH -1:0] mon_TID,
    input wire mon_TREADY,
    input wire mon_TVALID,
    input wire mon_TLAST,
    
    //HLS interface
    output wire [TDATA_WIDTH -1:0] hls_TDATA,
    output wire [TKEEP_WIDTH -1:0] hls_TKEEP,
    output wire [TDEST_WIDTH -1:0] hls_TDEST,
    output wire [TID_WIDTH -1:0] hls_TID,
    input wire hls_TREADY,
    output wire hls_TVALID,
    output wire hls_TLAST
);

    assign hls_TDATA = mon_TDATA;
    assign hls_TKEEP = mon_TKEEP;
    assign hls_TDEST = mon_TDEST;
    assign hls_TID = mon_TID;
    assign hls_TREADY = mon_TREADY;
    assign hls_TVALID = mon_TVALID & mon_TREADY;
    assign hls_TLAST = mon_TLAST;

endmodule
