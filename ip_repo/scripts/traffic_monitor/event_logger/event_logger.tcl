set root_dir [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]
set parent_ip "traffic_monitor"
set project_name "event_logger"

cd $parent_ip/$project_name

#create project
create_project $project_name ./$project_name -part xczu19eg-ffvc1760-2-i

#add src file
import_files -norecurse $root_dir/../src/traffic_monitor/event_logger/event_logger.sv
update_compile_order -fileset sources_1

#package ip
ipx::package_project -root_dir ./${project_name}.srcs/sources_1 -vendor username -library user -taxonomy /UserIP

#set port properties
set_property interface_mode monitor [ipx::get_bus_interfaces in_stream -of_objects [ipx::current_core]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces in_stream -of_objects [ipx::current_core]]
set_property physical_name in_stream_TREADY [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces in_stream -of_objects [ipx::current_core]]]

#create gui files and save core
set_property core_revision 0 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property ip_repo_paths [list "$root_dir/$parent_ip/$project_name/${project_name}.srcs/sources_1/bd/${project_name}"] [current_project]
update_ip_catalog

close_project
exit
