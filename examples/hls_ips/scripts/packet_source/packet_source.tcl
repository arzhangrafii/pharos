set root_dir [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]]]
set module_name "packet_source"
cd $module_name
open_project $module_name
set_top $module_name
add_files $root_dir/src/$module_name.cpp
open_solution "solution1"
set_part {xczu19eg-ffvc1760-2-i} -tool vivado
create_clock -period 10 -name default
config_rtl -reset all
csynth_design
export_design -rtl verilog
