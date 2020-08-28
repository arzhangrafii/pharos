`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2020 10:32:33 PM
// Module Name: packet_snooper
// Project Name: pharos
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


module packet_snooper # (
   parameter TDATA_WIDTH = 512,
   parameter TKEEP_WIDTH = TDATA_WIDTH/8
) (
   input wire clk,
   input wire aresetn,
   
   //event logger interface
   input wire [TDATA_WIDTH-1:0] in_stream_TDATA,
   input wire [TKEEP_WIDTH-1:0] in_stream_TKEEP,
   input wire in_stream_TREADY,
   input wire in_stream_TVALID,
   input wire in_stream_TLAST,
   
   //number of flits
   output logic [63:0] flit_count_TDATA,
   output logic [7:0] flit_count_TKEEP,
   input  logic flit_count_TREADY,
   output logic flit_count_TVALID,
   output logic flit_count_TLAST,
   
   //number of packets
   output logic [63:0] packet_count_TDATA,
   output logic [7:0] packet_count_TKEEP,
   input  logic packet_count_TREADY,
   output logic packet_count_TVALID,
   output logic packet_count_TLAST,
   
   //number of cycles (measurement duration)
   output logic [63:0] cycle_count_TDATA,
   output logic [7:0] cycle_count_TKEEP,
   input  logic cycle_count_TREADY,
   output logic cycle_count_TVALID,
   output logic cycle_count_TLAST,
   
   //measure input
   input measure,
   
   /************************/
   //THE FOLLOWING OUTPUT SIGNALS GO TO EMA CALCULATOR
   
   //packet size and its valid signal to be connected to the EMA calcualtor
   output logic [63:0] packet_size,
   output logic packet_size_valid,
   
   //purpose of this is to send a measure signal to EMA, which is synchronized to the packet size and its vakid signal
   output logic measure_sync_out
);

   logic read_enable;
   logic fc_write_enable;
   logic pc_write_enable;
   logic cc_write_enable;
   logic [TKEEP_WIDTH-1:0] input_keep;
   logic input_last;
   logic [7:0] bytes_in_flit;
   logic [63:0] byte_sum;
   
   logic [63:0] flit_counter = 0; //counts the number of passing flits
   logic [63:0] packet_counter = 0; //count the number of passing packets
   logic [63:0] cycle_counter = 0; //duration of measurement
       
   assign read_enable = in_stream_TVALID & in_stream_TREADY;
   assign fc_write_enable = flit_count_TREADY;
   assign pc_write_enable = packet_count_TREADY;
   assign cc_write_enable = cycle_count_TREADY;
   assign input_keep = in_stream_TKEEP;
   assign input_last = in_stream_TLAST;
   
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
   
   generate
       if (TKEEP_WIDTH == 1) begin
           mux_1 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
       
       else if (TKEEP_WIDTH == 2) begin
           mux_2 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
       
       else if (TKEEP_WIDTH == 4) begin
           mux_4 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
       
       else if (TKEEP_WIDTH == 8) begin
           mux_8 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
       
       else if (TKEEP_WIDTH == 16) begin
           mux_16 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
       
       else if (TKEEP_WIDTH == 32) begin
           mux_32 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
       
       else if (TKEEP_WIDTH == 64) begin
           mux_64 # (.TDATA_WIDTH (TDATA_WIDTH),.TKEEP_WIDTH (TKEEP_WIDTH)) inst1 
                (.clk(clk),
                 .aresetn(aresetn),
                 .input_keep(input_keep),
                 .bytes_in_flit(bytes_in_flit)
                 );
       end
   endgenerate
   
   always_ff @ (posedge clk) begin
       measure_sync_out <= measure;
       case (state)
           IDLE: begin
               cycle_counter <= 0;
               flit_counter <= 0;
               packet_counter <= 0;
               byte_sum <= 0;
               packet_size_valid <= 0;
           end
           MEASURE: begin
               cycle_counter <= cycle_counter + 1;
               //a transaction is happening
               if (read_enable) begin
                   flit_counter <= flit_counter + 1;                                  
               
                   /*****measure flit size*****/
                   //if this is the last flit of the packet. e.g. end of packet
                   if (input_last) begin
                       packet_counter = packet_counter + 1;
                       byte_sum = byte_sum + bytes_in_flit;
                       packet_size = byte_sum;
                       packet_size_valid = 1;
                       byte_sum = 0;
                   end
                   else begin
                       byte_sum <= byte_sum + bytes_in_flit;
                       packet_size_valid <= 0;
                   end
               end
           end
           DONE: begin
               //write cycle count to the output axi-stream
               if (cc_write_enable) begin
                  cycle_count_TDATA <= cycle_counter;
                  cycle_count_TKEEP <= 8'hFF;
                  cycle_count_TLAST <= 1'b1;
                  cycle_count_TVALID <= 1'b1;
               end
               else begin
                   cycle_count_TVALID <= 1'b0;
               end
               
               //write cycle count to the output axi-stream
               if (pc_write_enable) begin
                  packet_count_TDATA <= packet_counter;
                  packet_count_TKEEP <= 8'hFF;
                  packet_count_TLAST <= 1'b1;
                  packet_count_TVALID <= 1'b1;
               end
               else begin
                   packet_count_TVALID <= 1'b0;
               end
           
               //write flit count to the output axi-stream
               if (fc_write_enable) begin
                  flit_count_TDATA <= flit_counter;
                  flit_count_TKEEP <= 8'hFF;
                  flit_count_TLAST <= 1'b1;
                  flit_count_TVALID <= 1'b1;
               end
               else begin
                   flit_count_TVALID <= 1'b0;
               end
           end
       endcase
  end
  
endmodule

