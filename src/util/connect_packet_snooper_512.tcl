#connect_packet_snooper_512
#This tcl script instantiates a packet snooper hierarchy (containing packet snooper, and packet srize averager)
#To run the script, click on a 512-bit AXI-stream port that you want to snoop on. Then run the tcl script

#instantiate packet_snooper
create_bd_cell -type ip -vlnv xilinx.com:hls:packet_snooper_512:1.0 packet_counter
#instantiate monitorizer
create_bd_cell -type ip -vlnv arzhangrafii:user:monitorizer:1.0 monitorizer_0
#instantiate packet_size_averager
create_bd_cell -type ip -vlnv xilinx.com:hls:packet_size_EMA:1.0 packet_size_EMA_0
#set widths of monitorizer
set_property -dict [list CONFIG.TDATA_WIDTH {512} CONFIG.TKEEP_WIDTH {64}] [get_bd_cells monitorizer_0]
#connect AXI stream of monitorizer to the packet_snooper input
connect_bd_intf_net [get_bd_intf_pins monitorizer_0/hls] [get_bd_intf_pins packet_counter/in_stream_V]
#connect snooper and EMA
connect_bd_net [get_bd_pins packet_counter/packet_size_V] [get_bd_pins packet_size_EMA_0/packet_size_V]
connect_bd_net [get_bd_pins packet_counter/packet_size_valid_V] [get_bd_pins packet_size_EMA_0/packet_size_valid_V]
connect_bd_net [get_bd_pins packet_size_EMA_0/aclk] [get_bd_pins packet_counter/aclk]

#create a higherarchy for this core
set cells [get_bd_cells -filter {NAME =~ "packet_snooper_*"}]
set id 0
foreach c $cells {
	set name [get_property NAME $c]
	set id [string range $name 15 [string length $name]]
	set id [expr $id+1]
}
group_bd_cells packet_snooper_$id [get_bd_cells packet_counter] [get_bd_cells packet_size_EMA_0] [get_bd_cells monitorizer_0]


#make the following pins external to the higherarchy
#measure
make_bd_pins_external  [get_bd_pins packet_snooper_$id/packet_counter/measure_V]
delete_bd_objs [get_bd_nets measure_V_0_1] [get_bd_ports measure_V_0]
set_property name measure [get_bd_pins packet_snooper_$id/measure_V_0]
#read_frequency
make_bd_pins_external  [get_bd_pins packet_snooper_$id/packet_size_EMA_0/read_frequency_V]
delete_bd_objs [get_bd_nets read_frequency_V_0_1] [get_bd_ports read_frequency_V_0]
set_property name read_frequency [get_bd_pins packet_snooper_$id/read_frequency_V_0]
#Beta
make_bd_pins_external  [get_bd_pins packet_snooper_$id/packet_size_EMA_0/Beta_V]
delete_bd_objs [get_bd_nets Beta_V_0_1] [get_bd_ports Beta_V_0]
set_property name Beta [get_bd_pins packet_snooper_$id/Beta_V_0]
#clk
make_bd_pins_external  [get_bd_pins packet_snooper_$id/monitorizer_0/clk]
connect_bd_net [get_bd_pins packet_snooper_$id/clk_0] [get_bd_pins packet_snooper_$id/packet_counter/aclk]
delete_bd_objs [get_bd_nets clk_0_1] [get_bd_ports clk_0]
set_property name clk [get_bd_pins packet_snooper_$id/clk_0]
#resetn
make_bd_pins_external  [get_bd_pins packet_snooper_$id/packet_counter/aresetn]
delete_bd_objs [get_bd_nets aresetn_0_1] [get_bd_ports aresetn_0]
set_property name aresetn [get_bd_pins packet_snooper_$id/aresetn_0]
connect_bd_net [get_bd_pins packet_snooper_$id/aresetn] [get_bd_pins packet_snooper_$id/packet_size_EMA_0/aresetn]

#make axi-s outputs external
make_bd_intf_pins_external  [get_bd_intf_pins packet_snooper_$id/packet_counter/number_of_flits_V] [get_bd_intf_pins packet_snooper_$id/packet_counter/cycle_count_V] [get_bd_intf_pins packet_snooper_$id/packet_size_EMA_0/packet_size_average_V] [get_bd_intf_pins packet_snooper_$id/monitorizer_0/mon]
delete_bd_objs [get_bd_intf_nets packet_snooper_$id\_cycle_count_V_0] [get_bd_intf_nets packet_snooper_$id\_number_of_flits_V_0] [get_bd_intf_nets packet_snooper_$id\_packet_size_average_V_0] [get_bd_intf_ports cycle_count_V_0] [get_bd_intf_ports number_of_flits_V_0] [get_bd_intf_ports packet_size_average_V_0]
delete_bd_objs [get_bd_intf_nets Conn] [get_bd_intf_ports mon_0]
set_property name number_of_flits [get_bd_intf_pins packet_snooper_$id/number_of_flits_V_0]
set_property name cycle_count [get_bd_intf_pins packet_snooper_$id/cycle_count_V_0]
set_property name packet_size_average [get_bd_intf_pins packet_snooper_$id/packet_size_average_V_0]
set_property name snooper_in_stream [get_bd_intf_pins packet_snooper_$id/mon_0]

#connect the selected pin to this core
puts [string compare [get_bd_intf_pins [get_selected_objects]] ""]
if {[string compare [get_bd_intf_pins [get_selected_objects]] ""] != 0} {
	connect_bd_intf_net [get_bd_intf_pins packet_snooper_$id/snooper_in_stream] [get_bd_intf_pins [get_selected_objects ]]
	puts 
}


