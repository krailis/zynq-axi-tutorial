# Open Project & Set Top-level Function
open_project add_one.prj
set_top add_one

# Add Files
add_files add_one.c

# Add Test Bench Files
add_files -tb add_one_tb.c

# Solutions : AXI4-Lite
open_solution AXI4-Lite
set_part {xc7z020clg484-1}
create_clock -period 10 -name default

# Set Directives
set_directive_interface -mode s_axilite -bundle add_one_io "add_one"
set_directive_interface -mode s_axilite -bundle add_one_io "add_one" a
set_directive_interface -mode s_axilite -bundle add_one_io "add_one" b

csim_design
csynth_design
export_design -format ip_catalog
close_solution

# Solutions : AXI4-Stream
open_solution AXI4-Stream
set_part {xc7z020clg484-1}
create_clock -period 10 -name default

# Set Directives
set_directive_interface -mode ap_ctrl_none "add_one"
set_directive_interface -mode axis "add_one" a
set_directive_interface -mode axis "add_one" b

csim_design
csynth_design
export_design -format ip_catalog
close_solution

exit
