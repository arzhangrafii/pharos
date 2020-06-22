set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "bandwidth_monitor_example"
set root_dir [file dirname [file dirname [file dirname [file normalize [info script]]]]]

#create project
create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
create_bd_design $project_name

#set path to the ip repo
set_property  ip_repo_paths  "${$root_dir}/ip_repo" [current_project]
update_ip_catalog

#set path to helper hls ips (such as packet_sink and packet_source"
set_property  ip_repo_paths  "${$project_dir}/hls_ips" [current_project]
update_ip_catalog

#instantiate packet sink and packet source
create_bd_cell -type ip -vlnv xilinx.com:hls:packet_source:1.0 packet_source_0
create_bd_cell -type ip -vlnv xilinx.com:hls:packet_sink:1.0 packet_sink_0

#instantiate packet snooper by running the tcl script
source $root_dir/src/util/connect_packet_snooper_512.tcl

#connect packet snooper to the AXI stream that flows from packet source to packet sink
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins packet_snooper_0/snooper_in_stream] [get_bd_intf_pins packet_sink_0/in_stream_V]

#instantiate the ZYNQ core
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0

#add zynq core

