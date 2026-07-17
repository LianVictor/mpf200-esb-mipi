# Import source files
#
import_files -hdl_source {./src/hdl/MAC_Hololink/HSB_AXIS.v}
import_files -hdl_source {./src/hdl/misc/buffer.v}
import_files -hdl_source {./src/hdl/MAC_Hololink/HOLOLINK_def.svh}
import_files -hdl_source {./src/hdl/MAC_Hololink/Holoscan_IP_2603.v}
import_files -hdl_source {./src/hdl/MAC_Hololink/HOLOLINK_top_wrapper.v}
import_files -hdl_source {./src/hdl/MAC_Hololink/HoloLink_SD.v}
import_files -hdl_source {./src/hdl/MAC_Hololink/MAC_BaseR.v}
import_files -hdl_source {./src/hdl/MAC_Hololink/MAC_Hololink.v}
import_files -hdl_source {./src/hdl/IMX477_IF/IMX477_IF_TOP.v}
import_files -hdl_source {./src/hdl/IMX477_IF/CAM_IOD_TIP_TOP.v}
import_files -hdl_source {./src/hdl/MAC_Hololink/MAC_to_AXIS.v}
import_files -hdl_source {./src/hdl/misc/pps_stretch.v}

build_design_hierarchy 

source ./src/components/CoreAPB3_C1.tcl 
source ./src/components/CORE10GMAC_C0.tcl 
source ./src/components/COREABC_C0.tcl 
source ./src/components/CoreAPB3_C0.tcl 
source ./src/components/PF_TX_PLL_C0.tcl 
source ./src/components/PF_XCVR_ERM_C0.tcl 
source ./src/components/CORERESET_PF_C1.tcl 
source ./src/components/PF_IOD_GENERIC_RX_C1.tcl 
source ./src/components/MIPI_TRAINING_LITE_C0.tcl 
source ./src/components/MIPI_TRAINING_LITE_C1.tcl 
source ./src/components/MIPI_TRAINING_LITE_C2.tcl 
source ./src/components/MIPI_TRAINING_LITE_C3.tcl 
source ./src/components/mipicsi2rxdecoderPF_C0.tcl
source ./src/components/PF_CCC_C2.tcl 
source ./src/components/PF_CCC_C1.tcl 
source ./src/components/PF_XCVR_REF_CLK_C0.tcl 
source ./src/components/PF_INIT_MONITOR_C0.tcl 
source ./src/components/PF_SYSTEM_SERVICES_C0.tcl 

build_design_hierarchy 

#source ./src/components/top.tcl 
import_files -hdl_source {./src/hdl/top/PF_ESB_top.v}

# Set top level module
build_design_hierarchy 
set_root -module {PF_ESB_top::work} 

save_project
puts "Design generated successfully\n"
