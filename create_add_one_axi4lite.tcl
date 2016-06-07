start_gui
create_project add_one_zed_axi4lite ./add_one_zed_axi4lite -part xc7z020clg484-1
set_property board_part em.avnet.com:zed:part0:1.2 [current_project]
create_bd_design "system"
set_property ip_repo_paths  ../hls/add_one.prj/AXI4-Lite [current_project]
update_ip_catalog
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
startgroup
set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0}] [get_bd_cells processing_system7_0]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "0" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:add_one:1.0 add_one_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins add_one_0/s_axi_add_one_io]
connect_bd_net [get_bd_pins add_one_0/interrupt] [get_bd_pins processing_system7_0/IRQ_F2P]
regenerate_bd_layout
save_bd_design
make_wrapper -files [get_files ./add_one_zed_axi4lite/add_one_zed_axi4lite.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse ./add_one_zed_axi4lite/add_one_zed_axi4lite.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files ./add_one_zed_axi4lite/add_one_zed_axi4lite.srcs/sources_1/bd/system/system.bd]
