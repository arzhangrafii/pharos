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
create_bd_cell -type ip -vlnv xilinx.com:hls:data_stream_compressor:1.0 data_stream_compress_0
create_bd_cell -type ip -vlnv xilinx.com:hls:data_stream_compressor:1.0 data_stream_compress_1
create_bd_cell -type ip -vlnv xilinx.com:hls:data_stream_compressor:1.0 data_stream_compress_2

#instantiate packet snooper by running the tcl script
source $root_dir/src/util/connect_packet_snooper_512.tcl

#connect packet snooper to the AXI stream that flows from packet source to packet sink
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins packet_snooper_0/snooper_in_stream] [get_bd_intf_pins packet_sink_0/in_stream_V]

#instantiate the ZYNQ core
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0

#add zynq core
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0
source $project_dir/constraints/ps_set_sidewinder.tcl
set_property -dict [apply_preset zynq_ultra_ps_e_0] [get_bd_cells zynq_ultra_ps_e_0]
set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {0}] [get_bd_cells zynq_ultra_ps_e_0]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins packet_source_0/aclk]
connect_bd_net [get_bd_pins packet_sink_0/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins packet_snooper_0/clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins packet_source_0/aresetn]
connect_bd_net [get_bd_pins packet_sink_0/aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_pins packet_snooper_0/aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

#smart connect
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
set_property -dict [list CONFIG.NUM_MI {5} CONFIG.NUM_SI {1}] [get_bd_cells smartconnect_0]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins smartconnect_0/aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]


#gpios
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
set_property -dict [list CONFIG.C_GPIO2_WIDTH {8} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_1]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins packet_source_0/init_V]
connect_bd_net [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins packet_snooper_0/measure]
connect_bd_net [get_bd_pins axi_gpio_1/gpio_io_o] [get_bd_pins packet_snooper_0/read_frequency]
connect_bd_net [get_bd_pins axi_gpio_1/gpio2_io_o] [get_bd_pins packet_snooper_0/Beta]
set_property -dict [apply_preset zynq_ultra_ps_e_0] [get_bd_cells zynq_ultra_ps_e_0]
set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {0}] [get_bd_cells zynq_ultra_ps_e_0]
connect_bd_net [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

connect_bd_net [get_bd_pins data_stream_compress_0/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins data_stream_compress_0/aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_pins data_stream_compress_1/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins data_stream_compress_1/aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_pins data_stream_compress_2/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins data_stream_compress_2/aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

#FIFOs
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_0
set_property -dict [list CONFIG.C_USE_TX_DATA {0} CONFIG.C_USE_TX_CTRL {0}] [get_bd_cells axi_fifo_mm_s_0]
connect_bd_net [get_bd_pins axi_fifo_mm_s_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_fifo_mm_s_0/s_axi_aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_1
set_property -dict [list CONFIG.C_USE_TX_DATA {0} CONFIG.C_USE_TX_CTRL {0}] [get_bd_cells axi_fifo_mm_s_1]
connect_bd_net [get_bd_pins axi_fifo_mm_s_1/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_fifo_mm_s_1/s_axi_aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.1 axi_fifo_mm_s_2
set_property -dict [list CONFIG.C_USE_TX_DATA {0} CONFIG.C_USE_TX_CTRL {0}] [get_bd_cells axi_fifo_mm_s_2]
connect_bd_net [get_bd_pins axi_fifo_mm_s_2/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_fifo_mm_s_2/s_axi_aresetn] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

#assign outputs
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins packet_snooper_0/number_of_flits] [get_bd_intf_pins data_stream_compress_0/in_stream_V]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins packet_snooper_0/cycle_count] [get_bd_intf_pins data_stream_compress_1/in_stream_V]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins packet_snooper_0/packet_size_average] [get_bd_intf_pins data_stream_compress_2/in_stream_V]
connect_bd_intf_net [get_bd_intf_pins data_stream_compress_0/out_stream_V] [get_bd_intf_pins axi_fifo_mm_s_0/AXI_STR_RXD]
connect_bd_intf_net [get_bd_intf_pins data_stream_compress_1/out_stream_V] [get_bd_intf_pins axi_fifo_mm_s_1/AXI_STR_RXD]
connect_bd_intf_net [get_bd_intf_pins data_stream_compress_2/out_stream_V] [get_bd_intf_pins axi_fifo_mm_s_2/AXI_STR_RXD]

connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins axi_fifo_mm_s_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins axi_fifo_mm_s_1/S_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M04_AXI] [get_bd_intf_pins axi_fifo_mm_s_2/S_AXI]

#reset
disconnect_bd_net /zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins packet_source_0/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

assign_bd_address
validate_bd_design
make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
save_bd_design
close_project
exit
