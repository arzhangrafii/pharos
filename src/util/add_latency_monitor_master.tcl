#MASTER NODE
#instantiate ptp_master
create_bd_cell -type ip -vlnv xilinx.com:hls:ptp_master:1.0 ptp_master_0
#instantiate master timer
reate_bd_cell -type ip -vlnv xilinx.com:hls:master_timer:1.0 master_timer_0
#instantiate  packet_generator
create_bd_cell -type ip -vlnv xilinx.com:hls:packet_generator:1.0 packet_generator_0
#instatiate packet_parser
create_bd_cell -type ip -vlnv xilinx.com:hls:packet_parser:1.0 packet_parser_0

#connect signals
#time
connect_bd_net [get_bd_pins master_timer_0/time_V] [get_bd_pins packet_generator_0/time_V]
connect_bd_net [get_bd_pins packet_parser_0/time_V] [get_bd_pins master_timer_0/time_V]
connect_bd_net [get_bd_pins ptp_master_0/current_time_V] [get_bd_pins master_timer_0/time_V]
#clk

