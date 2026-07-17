##IMX
## This clock group is from CSI2 block to DDR Write and cdc fifo is present in the data path
set_clock_groups -name {clk_grp_cam_ccc_o0} -asynchronous -group [ get_clocks { IMX477_IF_TOP_0/PF_CCC_C2_0/PF_CCC_C2_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_cam_ccc_o1} -asynchronous -group [ get_clocks { IMX477_IF_TOP_1/PF_CCC_C2_0/PF_CCC_C2_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_cam_ccc_o2} -asynchronous -group [ get_clocks { IMX477_IF_TOP_2/PF_CCC_C2_0/PF_CCC_C2_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_cam_ccc_o3} -asynchronous -group [ get_clocks { IMX477_IF_TOP_3/PF_CCC_C2_0/PF_CCC_C2_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_cam_ccc_ydiv0} -asynchronous -group [ get_clocks { IMX477_IF_TOP_0/PF_IOD_GENERIC_RX_C0_0/PF_IOD_0/PF_CLK_DIV_FIFO/I_CDD/Y_DIV } ]
set_clock_groups -name {clk_grp_cam_ccc_ydiv1} -asynchronous -group [ get_clocks { IMX477_IF_TOP_1/PF_IOD_GENERIC_RX_C0_0/PF_IOD_0/PF_CLK_DIV_FIFO/I_CDD/Y_DIV } ]
set_clock_groups -name {clk_grp_cam_ccc_ydiv2} -asynchronous -group [ get_clocks { IMX477_IF_TOP_2/PF_IOD_GENERIC_RX_C0_0/PF_IOD_0/PF_CLK_DIV_FIFO/I_CDD/Y_DIV } ]
set_clock_groups -name {clk_grp_cam_ccc_ydiv3} -asynchronous -group [ get_clocks { IMX477_IF_TOP_3/PF_IOD_GENERIC_RX_C0_0/PF_IOD_0/PF_CLK_DIV_FIFO/I_CDD/Y_DIV } ]

## This clock group is from PF_CCC_C3 to corereset
#set_clock_groups -name {clk_grp_ccc3} -asynchronous -group [ get_clocks { PF_CCC_C3_0/PF_CCC_C3_0/pll_inst_0/OUT0 } ] 

## This clock group is from xcvr tx/rx clocks
set_clock_groups -name {clk_grp_mac1t} -asynchronous -group [ get_clocks { MAC_Hololink_0/MAC_BaseR_0/PF_XCVR_ERM_C0_0/I_XCVR/LANE0/TX_CLK_R } ]
set_clock_groups -name {clk_grp_mac1r} -asynchronous -group [ get_clocks { MAC_Hololink_0/MAC_BaseR_0/PF_XCVR_ERM_C0_0/I_XCVR/LANE0/RX_CLK_R } ]
set_clock_groups -name {clk_grp_mac2t} -asynchronous -group [ get_clocks { MAC_Hololink_0/MAC_BaseR_1/PF_XCVR_ERM_C0_0/I_XCVR/LANE0/TX_CLK_R } ]
set_clock_groups -name {clk_grp_mac2r} -asynchronous -group [ get_clocks { MAC_Hololink_0/MAC_BaseR_1/PF_XCVR_ERM_C0_0/I_XCVR/LANE0/RX_CLK_R } ]
set_clock_groups -name {clk_grp_mac3} -asynchronous -group [ get_clocks { MAC_Hololink_0/PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_mac_apb} -asynchronous -group [ get_clocks { MAC_Hololink_0/PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT1 } ]
set_clock_groups -name {clk_grp_sif} -asynchronous -group [ get_clocks { MAC_Hololink_0/PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT2 } ]

	



