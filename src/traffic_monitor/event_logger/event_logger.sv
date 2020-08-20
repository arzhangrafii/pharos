`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2020 07:45:02 PM
// Design Name: 
// Module Name: event_logger
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


module event_logger # (
    parameter TDATA_WIDTH = 512,
    parameter TKEEP_WIDTH = TDATA_WIDTH/8,
    parameter TDEST_WIDTH = 16,
    parameter TID_WIDTH = 16
) (
    //Dummy clock to get rid of clock warning
    input wire clk,
    input wire aresetn,
    
    //event logger interface
    input wire [TDATA_WIDTH-1:0] in_stream_TDATA,
    input wire [TKEEP_WIDTH-1:0] in_stream_TKEEP,
    input wire [TDEST_WIDTH-1:0] in_stream_TDEST,
    input wire [TID_WIDTH-1:0]   in_stream_TID,
    output wire in_stream_TREADY,
    input wire in_stream_TVALID,
    input wire in_stream_TLAST,
    
    //output interface
    output logic [63:0] timestamp_TDATA,
    output logic [7:0] timestamp_TKEEP,
    output logic [15:0] timestamp_TDEST,
    output logic [15:0] timestamp_TID,
    input  logic timestamp_TREADY,
    output logic timestamp_TVALID,
    output logic timestamp_TLAST,
    
    output logic [63:0] count_TDATA,
    output logic [7:0] count_TKEEP,
    output logic [15:0] count_TDEST,
    output logic [15:0] count_TID,
    input  logic count_TREADY,
    output logic count_TVALID,
    output logic count_TLAST,
    
    //trigger
    input [TDATA_WIDTH-1:0] trigger_value,
    
    //time
    input [63:0] current_time,
    input measure
);

    logic read_enable;
    logic ts_write_enable;
    logic cnt_write_enable;
    
    logic [63:0] trig_counter = 0; //counts how many times trigger happens
    
    logic trigger;
    assign trigger = (read_enable & (trigger_value == in_stream_TDATA)) ? 1 : 0;
        
    assign read_enable = in_stream_TVALID;
    assign ts_write_enable = timestamp_TREADY;
    assign cnt_write_enable = count_TREADY;
    
    /*initial begin
        trig_counter <= 0;
        count_out_w_en <= 0;
    end*/
    
    enum int unsigned {IDLE, MEASURE, DONE} state, next_state;
    
    /*********************/
    /****** CONTROL ******/
    /*********************/

    /***** FSM LOGIC *****/
    always_comb begin
        case (state)
            IDLE: begin
                if (measure)
                    next_state <= MEASURE;
                else
                    next_state <= IDLE;
            end
            MEASURE: begin
                if (!measure)
                    next_state <= DONE;
                else
                    next_state <= MEASURE;
            end
            DONE: begin
                next_state <= IDLE;
            end
            default: next_state <= IDLE;
        endcase
    end
    
    always_ff @ (posedge clk) begin
        if (!aresetn) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
    
    
    /***********************/
    /****** DATA PATH ******/
    /***********************/
    
    always_ff @ (posedge clk) begin
        case (state)
            IDLE: begin
                trig_counter <= 0;
            end
            MEASURE: begin
                if (trigger) begin
                    trig_counter <= trig_counter + 1;
                    if (ts_write_enable) begin
                        timestamp_TDATA <= current_time;
                        timestamp_TKEEP <= 8'hFF;
                        timestamp_TLAST <= 1'b1;
                        timestamp_TVALID <= 1'b1;
                    end
                end
                else begin
                    timestamp_TVALID <= 1'b0;
                end
            end
            DONE: begin
                if (cnt_write_enable) begin
                    count_TDATA <= trig_counter;
                    count_TKEEP <= 8'hFF;
                    count_TLAST <= 1'b1;
                    count_TVALID <= 1'b1;
                end
                else begin
                    count_TVALID <= 1'b0;
                end
            end
        endcase
   end
   
endmodule
