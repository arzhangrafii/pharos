#MASTER NODE
#instantiate ptp_master
create_bd_cell -type ip -vlnv xilinx.com:hls:ptp_master:1.0 ptp_master_0
#instantiate master timer
reate_bd_cell -type ip -vlnv xilinx.com:hls:master_timer:1.0 master_timer_0

