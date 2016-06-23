start_gui
create_project add_one_zed_axi4stream ./add_one_zed_axi4stream -part xc7z020clg484-1
set_property board_part em.avnet.com:zed:part0:1.2 [current_project]
create_bd_design "system"
set_property ip_repo_paths  ../hls/add_one.prj/AXI4-Stream [current_project]
update_ip_catalog
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
startgroup
set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1}] [get_bd_cells processing_system7_0]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "0" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:hls:add_one:1.0 add_one_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
endgroup
startgroup
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {23} CONFIG.c_sg_include_stscntrl_strm {0}] [get_bd_cells axi_dma_0]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/axi_dma_0/M_AXI_MM2S" Clk "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
regenerate_bd_layout
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
endgroup
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
connect_bd_net [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
connect_bd_intf_net [get_bd_intf_pins add_one_0/b] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins add_one_0/a]
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_pins add_one_0/ap_clk] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net -net [get_bd_nets rst_processing_system7_0_102M_peripheral_aresetn] [get_bd_pins add_one_0/ap_rst_n] [get_bd_pins rst_processing_system7_0_102M/peripheral_aresetn]
save_bd_design 
validate_bd_design
make_wrapper -files [get_files /home/krailis/Downloads/zynq-axi-tutorial-master/zedboard_axi4stream/add_one_zed_axi4stream/add_one_zed_axi4stream.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse /home/krailis/Downloads/zynq-axi-tutorial-master/zedboard_axi4stream/add_one_zed_axi4stream/add_one_zed_axi4stream.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files  /home/krailis/Downloads/zynq-axi-tutorial-master/zedboard_axi4stream/add_one_zed_axi4stream/add_one_zed_axi4stream.srcs/sources_1/bd/system/system.bd]
