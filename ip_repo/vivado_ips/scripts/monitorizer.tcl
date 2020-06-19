set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "monitorizer"

#create project
create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i

#add src file
add_files -norecurse $project_dir/../../src/monitorizer/monitorizer.v
update_compile_order -fileset sources_1

#package ip
ipx::package_project -root_dir $project_dir/$project_name/${project_name}.srcs/sources_1 -vendor arzhangrafii -library user -taxonomy /UserIP

#set port properties
ipx::remove_port_map TREADY [ipx::get_bus_interfaces mon -of_objects [ipx::current_core]]
set_property interface_mode monitor [ipx::get_bus_interfaces mon -of_objects [ipx::current_core]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces mon -of_objects [ipx::current_core]]
set_property physical_name mon_TREADY [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces mon -of_objects [ipx::current_core]]]

#create gui files and save core
set_property core_revision 0 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  /home/arzhang/perf_monitor_test_project/Perf_Monitor_model/src/monitorizer [current_project]
update_ip_catalog

close_project
exit
