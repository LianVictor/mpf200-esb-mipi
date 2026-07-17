//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Feb  9 10:35:41 2026
// Version: 2025.2 2025.2.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// HoloLink_SD
module HoloLink_SD(
    // Inputs
    APB_INITIATOR_i_apb_prdata,
    APB_INITIATOR_i_apb_pready,
    APB_INITIATOR_i_apb_pserr,
    DI,
    FLASH,
    HIF_INITIATOR_0_i_hif_axis_tready_0,
    HIF_INITIATOR_1_i_hif_axis_tready_1,
    HIF_TARGET_0_i_hif_axis_tdata_0,
    HIF_TARGET_0_i_hif_axis_tkeep_0,
    HIF_TARGET_0_i_hif_axis_tlast_0,
    HIF_TARGET_0_i_hif_axis_tuser_0,
    HIF_TARGET_0_i_hif_axis_tvalid_0,
    HIF_TARGET_1_i_hif_axis_tdata_1,
    HIF_TARGET_1_i_hif_axis_tkeep_1,
    HIF_TARGET_1_i_hif_axis_tlast_1,
    HIF_TARGET_1_i_hif_axis_tuser_1,
    HIF_TARGET_1_i_hif_axis_tvalid_1,
    IFACE,
    SIF_TARGET_0_i_sif_axis_tdata_0,
    SIF_TARGET_0_i_sif_axis_tkeep_0,
    SIF_TARGET_0_i_sif_axis_tlast_0,
    SIF_TARGET_0_i_sif_axis_tuser_0,
    SIF_TARGET_0_i_sif_axis_tvalid_0,
    SIF_TARGET_1_i_sif_axis_tdata_1,
    SIF_TARGET_1_i_sif_axis_tkeep_1,
    SIF_TARGET_1_i_sif_axis_tlast_1,
    SIF_TARGET_1_i_sif_axis_tuser_1,
    SIF_TARGET_1_i_sif_axis_tvalid_1,
    SIF_TARGET_2_i_sif_axis_tdata_2,
    SIF_TARGET_2_i_sif_axis_tkeep_2,
    SIF_TARGET_2_i_sif_axis_tlast_2,
    SIF_TARGET_2_i_sif_axis_tuser_2,
    SIF_TARGET_2_i_sif_axis_tvalid_2,
    SIF_TARGET_3_i_sif_axis_tdata_3,
    SIF_TARGET_3_i_sif_axis_tkeep_3,
    SIF_TARGET_3_i_sif_axis_tlast_3,
    SIF_TARGET_3_i_sif_axis_tuser_3,
    SIF_TARGET_3_i_sif_axis_tvalid_3,
    i_apb_clk,
    i_hif_clk,
    i_ptp_clk,
    i_sif_clk,
    i_sys_rst,
    // Outputs
    APB_INITIATOR_o_apb_paddr,
    APB_INITIATOR_o_apb_penable,
    APB_INITIATOR_o_apb_psel,
    APB_INITIATOR_o_apb_pwdata,
    APB_INITIATOR_o_apb_pwrite,
    DO,
    HIF_INITIATOR_0_o_hif_axis_tdata_0,
    HIF_INITIATOR_0_o_hif_axis_tkeep_0,
    HIF_INITIATOR_0_o_hif_axis_tlast_0,
    HIF_INITIATOR_0_o_hif_axis_tuser_0,
    HIF_INITIATOR_0_o_hif_axis_tvalid_0,
    HIF_INITIATOR_1_o_hif_axis_tdata_1,
    HIF_INITIATOR_1_o_hif_axis_tkeep_1,
    HIF_INITIATOR_1_o_hif_axis_tlast_1,
    HIF_INITIATOR_1_o_hif_axis_tuser_1,
    HIF_INITIATOR_1_o_hif_axis_tvalid_1,
    HIF_TARGET_0_o_hif_axis_tready_0,
    HIF_TARGET_1_o_hif_axis_tready_1,
    SIF_TARGET_0_o_sif_axis_tready_0,
    SIF_TARGET_1_o_sif_axis_tready_1,
    SIF_TARGET_2_o_sif_axis_tready_2,
    SIF_TARGET_3_o_sif_axis_tready_3,
    o_init_done,
    o_pps,
    o_ptp_rst,
    // Inouts
    CAM1_SCL,
    CAM1_SDA,
    CAM2_SCL,
    CAM2_SDA,
    CAM3_SCL,
    CAM3_SDA,
    CAM4_SCL,
    CAM4_SDA,
    CLK,
    EEPROM_SCL,
    EEPROM_SDA,
    GPIO,
    SS
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] APB_INITIATOR_i_apb_prdata;
input         APB_INITIATOR_i_apb_pready;
input         APB_INITIATOR_i_apb_pserr;
input         DI;
input         FLASH;
input         HIF_INITIATOR_0_i_hif_axis_tready_0;
input         HIF_INITIATOR_1_i_hif_axis_tready_1;
input  [63:0] HIF_TARGET_0_i_hif_axis_tdata_0;
input  [7:0]  HIF_TARGET_0_i_hif_axis_tkeep_0;
input         HIF_TARGET_0_i_hif_axis_tlast_0;
input  [0:0]  HIF_TARGET_0_i_hif_axis_tuser_0;
input         HIF_TARGET_0_i_hif_axis_tvalid_0;
input  [63:0] HIF_TARGET_1_i_hif_axis_tdata_1;
input  [7:0]  HIF_TARGET_1_i_hif_axis_tkeep_1;
input         HIF_TARGET_1_i_hif_axis_tlast_1;
input  [0:0]  HIF_TARGET_1_i_hif_axis_tuser_1;
input         HIF_TARGET_1_i_hif_axis_tvalid_1;
input         IFACE;
input  [63:0] SIF_TARGET_0_i_sif_axis_tdata_0;
input  [7:0]  SIF_TARGET_0_i_sif_axis_tkeep_0;
input         SIF_TARGET_0_i_sif_axis_tlast_0;
input  [1:0]  SIF_TARGET_0_i_sif_axis_tuser_0;
input         SIF_TARGET_0_i_sif_axis_tvalid_0;
input  [63:0] SIF_TARGET_1_i_sif_axis_tdata_1;
input  [7:0]  SIF_TARGET_1_i_sif_axis_tkeep_1;
input         SIF_TARGET_1_i_sif_axis_tlast_1;
input  [1:0]  SIF_TARGET_1_i_sif_axis_tuser_1;
input         SIF_TARGET_1_i_sif_axis_tvalid_1;
input  [63:0] SIF_TARGET_2_i_sif_axis_tdata_2;
input  [7:0]  SIF_TARGET_2_i_sif_axis_tkeep_2;
input         SIF_TARGET_2_i_sif_axis_tlast_2;
input  [1:0]  SIF_TARGET_2_i_sif_axis_tuser_2;
input         SIF_TARGET_2_i_sif_axis_tvalid_2;
input  [63:0] SIF_TARGET_3_i_sif_axis_tdata_3;
input  [7:0]  SIF_TARGET_3_i_sif_axis_tkeep_3;
input         SIF_TARGET_3_i_sif_axis_tlast_3;
input  [1:0]  SIF_TARGET_3_i_sif_axis_tuser_3;
input         SIF_TARGET_3_i_sif_axis_tvalid_3;
input         i_apb_clk;
input         i_hif_clk;
input         i_ptp_clk;
input         i_sif_clk;
input         i_sys_rst;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] APB_INITIATOR_o_apb_paddr;
output        APB_INITIATOR_o_apb_penable;
output        APB_INITIATOR_o_apb_psel;
output [31:0] APB_INITIATOR_o_apb_pwdata;
output        APB_INITIATOR_o_apb_pwrite;
output        DO;
output [63:0] HIF_INITIATOR_0_o_hif_axis_tdata_0;
output [7:0]  HIF_INITIATOR_0_o_hif_axis_tkeep_0;
output        HIF_INITIATOR_0_o_hif_axis_tlast_0;
output [0:0]  HIF_INITIATOR_0_o_hif_axis_tuser_0;
output        HIF_INITIATOR_0_o_hif_axis_tvalid_0;
output [63:0] HIF_INITIATOR_1_o_hif_axis_tdata_1;
output [7:0]  HIF_INITIATOR_1_o_hif_axis_tkeep_1;
output        HIF_INITIATOR_1_o_hif_axis_tlast_1;
output [0:0]  HIF_INITIATOR_1_o_hif_axis_tuser_1;
output        HIF_INITIATOR_1_o_hif_axis_tvalid_1;
output        HIF_TARGET_0_o_hif_axis_tready_0;
output        HIF_TARGET_1_o_hif_axis_tready_1;
output        SIF_TARGET_0_o_sif_axis_tready_0;
output        SIF_TARGET_1_o_sif_axis_tready_1;
output        SIF_TARGET_2_o_sif_axis_tready_2;
output        SIF_TARGET_3_o_sif_axis_tready_3;
output        o_init_done;
output        o_pps;
output        o_ptp_rst;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout         CAM1_SCL;
inout         CAM1_SDA;
inout         CAM2_SCL;
inout         CAM2_SDA;
inout         CAM3_SCL;
inout         CAM3_SDA;
inout         CAM4_SCL;
inout         CAM4_SDA;
inout         CLK;
inout         EEPROM_SCL;
inout         EEPROM_SDA;
inout  [15:0] GPIO;
inout         SS;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [31:0] APB_INITIATOR_PADDR;
wire          APB_INITIATOR_PENABLE;
wire   [31:0] APB_INITIATOR_i_apb_prdata;
wire          APB_INITIATOR_i_apb_pready;
wire          APB_INITIATOR_PSELx;
wire          APB_INITIATOR_i_apb_pserr;
wire   [31:0] APB_INITIATOR_PWDATA;
wire          APB_INITIATOR_PWRITE;
wire          BIBUF_0_Y;
wire          BIBUF_1_Y;
wire          BIBUF_2_Y;
wire          BIBUF_3_Y;
wire          BIBUF_4_Y;
wire          BIBUF_5_Y;
wire          BIBUF_6_Y;
wire          BIBUF_7_Y;
wire          BIBUF_8_Y;
wire          BIBUF_9_Y;
wire          CAM1_SCL;
wire          CAM1_SDA;
wire          CAM2_SCL;
wire          CAM2_SDA;
wire          CAM3_SCL;
wire          CAM3_SDA;
wire          CAM4_SCL;
wire          CAM4_SDA;
wire          CLK;
wire          DI;
wire          DO_net_0;
wire          EEPROM_SCL;
wire          EEPROM_SDA;
wire          FLASH;
wire   [0:0]  glitch_filter_0_sync_out0to0;
wire   [1:1]  glitch_filter_0_sync_out1to1;
wire   [2:2]  glitch_filter_0_sync_out2to2;
wire   [3:3]  glitch_filter_0_sync_out3to3;
wire   [4:4]  glitch_filter_0_sync_out4to4;
wire   [5:5]  glitch_filter_0_sync_out5to5;
wire   [6:6]  glitch_filter_0_sync_out6to6;
wire   [7:7]  glitch_filter_0_sync_out7to7;
wire   [8:8]  glitch_filter_0_sync_out8to8;
wire   [9:9]  glitch_filter_0_sync_out9to9;
wire   [15:0] GPIO;
wire   [63:0] HIF_INITIATOR_0_TDATA;
wire   [7:0]  HIF_INITIATOR_0_TKEEP;
wire          HIF_INITIATOR_0_TLAST;
wire          HIF_INITIATOR_0_i_hif_axis_tready_0;
wire   [0:0]  HIF_INITIATOR_0_TUSER;
wire          HIF_INITIATOR_0_TVALID;
wire   [63:0] HIF_INITIATOR_1_TDATA;
wire   [7:0]  HIF_INITIATOR_1_TKEEP;
wire          HIF_INITIATOR_1_TLAST;
wire          HIF_INITIATOR_1_i_hif_axis_tready_1;
wire   [0:0]  HIF_INITIATOR_1_TUSER;
wire          HIF_INITIATOR_1_TVALID;
wire   [63:0] HIF_TARGET_0_i_hif_axis_tdata_0;
wire   [7:0]  HIF_TARGET_0_i_hif_axis_tkeep_0;
wire          HIF_TARGET_0_i_hif_axis_tlast_0;
wire          HIF_TARGET_0_TREADY;
wire   [0:0]  HIF_TARGET_0_i_hif_axis_tuser_0;
wire          HIF_TARGET_0_i_hif_axis_tvalid_0;
wire   [63:0] HIF_TARGET_1_i_hif_axis_tdata_1;
wire   [7:0]  HIF_TARGET_1_i_hif_axis_tkeep_1;
wire          HIF_TARGET_1_i_hif_axis_tlast_1;
wire          HIF_TARGET_1_TREADY;
wire   [0:0]  HIF_TARGET_1_i_hif_axis_tuser_1;
wire          HIF_TARGET_1_i_hif_axis_tvalid_1;
wire   [0:0]  HOLOLINK_top_0_o_i2c_scl_en0to0;
wire   [1:1]  HOLOLINK_top_0_o_i2c_scl_en1to1;
wire   [2:2]  HOLOLINK_top_0_o_i2c_scl_en2to2;
wire   [3:3]  HOLOLINK_top_0_o_i2c_scl_en3to3;
wire   [4:4]  HOLOLINK_top_0_o_i2c_scl_en4to4;
wire   [0:0]  HOLOLINK_top_0_o_i2c_sda_en0to0;
wire   [1:1]  HOLOLINK_top_0_o_i2c_sda_en1to1;
wire   [2:2]  HOLOLINK_top_0_o_i2c_sda_en2to2;
wire   [3:3]  HOLOLINK_top_0_o_i2c_sda_en3to3;
wire   [4:4]  HOLOLINK_top_0_o_i2c_sda_en4to4;
wire          HOLOLINK_top_0_o_spi_csn;
wire          HOLOLINK_top_0_o_spi_oen;
wire          HOLOLINK_top_0_o_spi_sck;
wire   [0:0]  HOLOLINK_top_0_o_spi_sdio0to0;
wire          i_apb_clk;
wire          i_hif_clk;
wire          i_ptp_clk;
wire          i_sif_clk;
wire          i_sys_rst;
wire          IFACE;
wire          o_init_done_net_0;
wire          o_pps_net_0;
wire          o_ptp_rst_net_0;
wire          PF_SPI_0_D_I;
wire   [63:0] SIF_TARGET_0_i_sif_axis_tdata_0;
wire   [7:0]  SIF_TARGET_0_i_sif_axis_tkeep_0;
wire          SIF_TARGET_0_i_sif_axis_tlast_0;
wire          SIF_TARGET_0_TREADY;
wire   [1:0]  SIF_TARGET_0_i_sif_axis_tuser_0;
wire          SIF_TARGET_0_i_sif_axis_tvalid_0;
wire   [63:0] SIF_TARGET_1_i_sif_axis_tdata_1;
wire   [7:0]  SIF_TARGET_1_i_sif_axis_tkeep_1;
wire          SIF_TARGET_1_i_sif_axis_tlast_1;
wire          SIF_TARGET_1_TREADY;
wire   [1:0]  SIF_TARGET_1_i_sif_axis_tuser_1;
wire          SIF_TARGET_1_i_sif_axis_tvalid_1;
wire   [63:0] SIF_TARGET_2_i_sif_axis_tdata_2;
wire   [7:0]  SIF_TARGET_2_i_sif_axis_tkeep_2;
wire          SIF_TARGET_2_i_sif_axis_tlast_2;
wire          SIF_TARGET_2_TREADY;
wire   [1:0]  SIF_TARGET_2_i_sif_axis_tuser_2;
wire          SIF_TARGET_2_i_sif_axis_tvalid_2;
wire   [63:0] SIF_TARGET_3_i_sif_axis_tdata_3;
wire   [7:0]  SIF_TARGET_3_i_sif_axis_tkeep_3;
wire          SIF_TARGET_3_i_sif_axis_tlast_3;
wire          SIF_TARGET_3_TREADY;
wire   [1:0]  SIF_TARGET_3_i_sif_axis_tuser_3;
wire          SIF_TARGET_3_i_sif_axis_tvalid_3;
wire          SS;
wire          DO_net_1;
wire          o_init_done_net_1;
wire          o_pps_net_1;
wire          o_ptp_rst_net_1;
wire          HIF_INITIATOR_0_TVALID_net_0;
wire          HIF_INITIATOR_0_TLAST_net_0;
wire          HIF_TARGET_0_TREADY_net_0;
wire          SIF_TARGET_0_TREADY_net_0;
wire          HIF_INITIATOR_1_TVALID_net_0;
wire          HIF_INITIATOR_1_TLAST_net_0;
wire          HIF_TARGET_1_TREADY_net_0;
wire          SIF_TARGET_1_TREADY_net_0;
wire          APB_INITIATOR_PENABLE_net_0;
wire          APB_INITIATOR_PWRITE_net_0;
wire          APB_INITIATOR_PSELx_net_0;
wire          SIF_TARGET_2_TREADY_net_0;
wire          SIF_TARGET_3_TREADY_net_0;
wire   [63:0] HIF_INITIATOR_0_TDATA_net_0;
wire   [7:0]  HIF_INITIATOR_0_TKEEP_net_0;
wire   [0:0]  HIF_INITIATOR_0_TUSER_net_0;
wire   [63:0] HIF_INITIATOR_1_TDATA_net_0;
wire   [7:0]  HIF_INITIATOR_1_TKEEP_net_0;
wire   [0:0]  HIF_INITIATOR_1_TUSER_net_0;
wire   [31:0] APB_INITIATOR_PADDR_net_0;
wire   [31:0] APB_INITIATOR_PWDATA_net_0;
wire   [3:1]  o_spi_sdio_slice_0;
wire   [9:0]  sync_in_net_0;
wire   [9:0]  sync_out_net_0;
wire   [3:0]  i_spi_sdio_net_0;
wire   [3:0]  o_spi_sdio_net_0;
wire   [4:0]  i_i2c_scl_net_0;
wire   [4:0]  i_i2c_sda_net_0;
wire   [4:0]  o_i2c_scl_en_net_0;
wire   [4:0]  o_i2c_sda_en_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire   [15:0] i_sif_event_const_net_0;
wire   [3:2]  i_spi_sdio_const_net_0;
wire          VCC_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          E_IN_POST_INV0_0;
wire          E_IN_POST_INV1_0;
wire          E_IN_POST_INV2_0;
wire          E_IN_POST_INV3_0;
wire          E_IN_POST_INV4_0;
wire          E_IN_POST_INV5_0;
wire          E_IN_POST_INV6_0;
wire          E_IN_POST_INV7_0;
wire          E_IN_POST_INV8_0;
wire          E_IN_POST_INV9_0;
wire          rst_n_IN_POST_INV10_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                 = 1'b0;
assign i_sif_event_const_net_0 = 16'h0000;
assign i_spi_sdio_const_net_0  = 2'h0;
assign VCC_net                 = 1'b1;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign E_IN_POST_INV0_0      = ~ glitch_filter_0_sync_out6to6[6];
assign E_IN_POST_INV1_0      = ~ glitch_filter_0_sync_out1to1[1];
assign E_IN_POST_INV2_0      = ~ glitch_filter_0_sync_out0to0[0];
assign E_IN_POST_INV3_0      = ~ glitch_filter_0_sync_out5to5[5];
assign E_IN_POST_INV4_0      = ~ glitch_filter_0_sync_out7to7[7];
assign E_IN_POST_INV5_0      = ~ glitch_filter_0_sync_out2to2[2];
assign E_IN_POST_INV6_0      = ~ glitch_filter_0_sync_out8to8[8];
assign E_IN_POST_INV7_0      = ~ glitch_filter_0_sync_out3to3[3];
assign E_IN_POST_INV8_0      = ~ glitch_filter_0_sync_out4to4[4];
assign E_IN_POST_INV9_0      = ~ glitch_filter_0_sync_out9to9[9];
assign rst_n_IN_POST_INV10_0 = ~ i_sys_rst;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign DO_net_1                                 = DO_net_0;
assign DO                                       = DO_net_1;
assign o_init_done_net_1                        = o_init_done_net_0;
assign o_init_done                              = o_init_done_net_1;
assign o_pps_net_1                              = o_pps_net_0;
assign o_pps                                    = o_pps_net_1;
assign o_ptp_rst_net_1                          = o_ptp_rst_net_0;
assign o_ptp_rst                                = o_ptp_rst_net_1;
assign HIF_INITIATOR_0_TVALID_net_0             = HIF_INITIATOR_0_TVALID;
assign HIF_INITIATOR_0_o_hif_axis_tvalid_0      = HIF_INITIATOR_0_TVALID_net_0;
assign HIF_INITIATOR_0_TLAST_net_0              = HIF_INITIATOR_0_TLAST;
assign HIF_INITIATOR_0_o_hif_axis_tlast_0       = HIF_INITIATOR_0_TLAST_net_0;
assign HIF_TARGET_0_TREADY_net_0                = HIF_TARGET_0_TREADY;
assign HIF_TARGET_0_o_hif_axis_tready_0         = HIF_TARGET_0_TREADY_net_0;
assign SIF_TARGET_0_TREADY_net_0                = SIF_TARGET_0_TREADY;
assign SIF_TARGET_0_o_sif_axis_tready_0         = SIF_TARGET_0_TREADY_net_0;
assign HIF_INITIATOR_1_TVALID_net_0             = HIF_INITIATOR_1_TVALID;
assign HIF_INITIATOR_1_o_hif_axis_tvalid_1      = HIF_INITIATOR_1_TVALID_net_0;
assign HIF_INITIATOR_1_TLAST_net_0              = HIF_INITIATOR_1_TLAST;
assign HIF_INITIATOR_1_o_hif_axis_tlast_1       = HIF_INITIATOR_1_TLAST_net_0;
assign HIF_TARGET_1_TREADY_net_0                = HIF_TARGET_1_TREADY;
assign HIF_TARGET_1_o_hif_axis_tready_1         = HIF_TARGET_1_TREADY_net_0;
assign SIF_TARGET_1_TREADY_net_0                = SIF_TARGET_1_TREADY;
assign SIF_TARGET_1_o_sif_axis_tready_1         = SIF_TARGET_1_TREADY_net_0;
assign APB_INITIATOR_PENABLE_net_0              = APB_INITIATOR_PENABLE;
assign APB_INITIATOR_o_apb_penable              = APB_INITIATOR_PENABLE_net_0;
assign APB_INITIATOR_PWRITE_net_0               = APB_INITIATOR_PWRITE;
assign APB_INITIATOR_o_apb_pwrite               = APB_INITIATOR_PWRITE_net_0;
assign APB_INITIATOR_PSELx_net_0                = APB_INITIATOR_PSELx;
assign APB_INITIATOR_o_apb_psel                 = APB_INITIATOR_PSELx_net_0;
assign SIF_TARGET_2_TREADY_net_0                = SIF_TARGET_2_TREADY;
assign SIF_TARGET_2_o_sif_axis_tready_2         = SIF_TARGET_2_TREADY_net_0;
assign SIF_TARGET_3_TREADY_net_0                = SIF_TARGET_3_TREADY;
assign SIF_TARGET_3_o_sif_axis_tready_3         = SIF_TARGET_3_TREADY_net_0;
assign HIF_INITIATOR_0_TDATA_net_0              = HIF_INITIATOR_0_TDATA;
assign HIF_INITIATOR_0_o_hif_axis_tdata_0[63:0] = HIF_INITIATOR_0_TDATA_net_0;
assign HIF_INITIATOR_0_TKEEP_net_0              = HIF_INITIATOR_0_TKEEP;
assign HIF_INITIATOR_0_o_hif_axis_tkeep_0[7:0]  = HIF_INITIATOR_0_TKEEP_net_0;
assign HIF_INITIATOR_0_TUSER_net_0[0]           = HIF_INITIATOR_0_TUSER[0];
assign HIF_INITIATOR_0_o_hif_axis_tuser_0[0:0]  = HIF_INITIATOR_0_TUSER_net_0[0];
assign HIF_INITIATOR_1_TDATA_net_0              = HIF_INITIATOR_1_TDATA;
assign HIF_INITIATOR_1_o_hif_axis_tdata_1[63:0] = HIF_INITIATOR_1_TDATA_net_0;
assign HIF_INITIATOR_1_TKEEP_net_0              = HIF_INITIATOR_1_TKEEP;
assign HIF_INITIATOR_1_o_hif_axis_tkeep_1[7:0]  = HIF_INITIATOR_1_TKEEP_net_0;
assign HIF_INITIATOR_1_TUSER_net_0[0]           = HIF_INITIATOR_1_TUSER[0];
assign HIF_INITIATOR_1_o_hif_axis_tuser_1[0:0]  = HIF_INITIATOR_1_TUSER_net_0[0];
assign APB_INITIATOR_PADDR_net_0                = APB_INITIATOR_PADDR;
assign APB_INITIATOR_o_apb_paddr[31:0]          = APB_INITIATOR_PADDR_net_0;
assign APB_INITIATOR_PWDATA_net_0               = APB_INITIATOR_PWDATA;
assign APB_INITIATOR_o_apb_pwdata[31:0]         = APB_INITIATOR_PWDATA_net_0;
//--------------------------------------------------------------------
// Slices assignments
//--------------------------------------------------------------------
assign glitch_filter_0_sync_out0to0[0]    = sync_out_net_0[0:0];
assign glitch_filter_0_sync_out1to1[1]    = sync_out_net_0[1:1];
assign glitch_filter_0_sync_out2to2[2]    = sync_out_net_0[2:2];
assign glitch_filter_0_sync_out3to3[3]    = sync_out_net_0[3:3];
assign glitch_filter_0_sync_out4to4[4]    = sync_out_net_0[4:4];
assign glitch_filter_0_sync_out5to5[5]    = sync_out_net_0[5:5];
assign glitch_filter_0_sync_out6to6[6]    = sync_out_net_0[6:6];
assign glitch_filter_0_sync_out7to7[7]    = sync_out_net_0[7:7];
assign glitch_filter_0_sync_out8to8[8]    = sync_out_net_0[8:8];
assign glitch_filter_0_sync_out9to9[9]    = sync_out_net_0[9:9];
assign HOLOLINK_top_0_o_i2c_scl_en0to0[0] = o_i2c_scl_en_net_0[0:0];
assign HOLOLINK_top_0_o_i2c_scl_en1to1[1] = o_i2c_scl_en_net_0[1:1];
assign HOLOLINK_top_0_o_i2c_scl_en2to2[2] = o_i2c_scl_en_net_0[2:2];
assign HOLOLINK_top_0_o_i2c_scl_en3to3[3] = o_i2c_scl_en_net_0[3:3];
assign HOLOLINK_top_0_o_i2c_scl_en4to4[4] = o_i2c_scl_en_net_0[4:4];
assign HOLOLINK_top_0_o_i2c_sda_en0to0[0] = o_i2c_sda_en_net_0[0:0];
assign HOLOLINK_top_0_o_i2c_sda_en1to1[1] = o_i2c_sda_en_net_0[1:1];
assign HOLOLINK_top_0_o_i2c_sda_en2to2[2] = o_i2c_sda_en_net_0[2:2];
assign HOLOLINK_top_0_o_i2c_sda_en3to3[3] = o_i2c_sda_en_net_0[3:3];
assign HOLOLINK_top_0_o_i2c_sda_en4to4[4] = o_i2c_sda_en_net_0[4:4];
assign HOLOLINK_top_0_o_spi_sdio0to0[0]   = o_spi_sdio_net_0[0:0];
assign o_spi_sdio_slice_0                 = o_spi_sdio_net_0[3:1];
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign sync_in_net_0    = { HOLOLINK_top_0_o_i2c_scl_en4to4[4] , HOLOLINK_top_0_o_i2c_scl_en3to3[3] , HOLOLINK_top_0_o_i2c_scl_en2to2[2] , HOLOLINK_top_0_o_i2c_scl_en1to1[1] , HOLOLINK_top_0_o_i2c_scl_en0to0[0] , HOLOLINK_top_0_o_i2c_sda_en4to4[4] , HOLOLINK_top_0_o_i2c_sda_en3to3[3] , HOLOLINK_top_0_o_i2c_sda_en2to2[2] , HOLOLINK_top_0_o_i2c_sda_en1to1[1] , HOLOLINK_top_0_o_i2c_sda_en0to0[0] };
assign i_spi_sdio_net_0 = { 2'h0 , PF_SPI_0_D_I , 1'b0 };
assign i_i2c_scl_net_0  = { BIBUF_9_Y , BIBUF_6_Y , BIBUF_4_Y , BIBUF_0_Y , BIBUF_3_Y };
assign i_i2c_sda_net_0  = { BIBUF_8_Y , BIBUF_7_Y , BIBUF_5_Y , BIBUF_1_Y , BIBUF_2_Y };
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------BIBUF
BIBUF BIBUF_0(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV0_0 ),
        // Outputs
        .Y   ( BIBUF_0_Y ),
        // Inouts
        .PAD ( CAM1_SCL ) 
        );

//--------BIBUF
BIBUF BIBUF_1(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV1_0 ),
        // Outputs
        .Y   ( BIBUF_1_Y ),
        // Inouts
        .PAD ( CAM1_SDA ) 
        );

//--------BIBUF
BIBUF BIBUF_2(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV2_0 ),
        // Outputs
        .Y   ( BIBUF_2_Y ),
        // Inouts
        .PAD ( EEPROM_SDA ) 
        );

//--------BIBUF
BIBUF BIBUF_3(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV3_0 ),
        // Outputs
        .Y   ( BIBUF_3_Y ),
        // Inouts
        .PAD ( EEPROM_SCL ) 
        );

//--------BIBUF
BIBUF BIBUF_4(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV4_0 ),
        // Outputs
        .Y   ( BIBUF_4_Y ),
        // Inouts
        .PAD ( CAM2_SCL ) 
        );

//--------BIBUF
BIBUF BIBUF_5(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV5_0 ),
        // Outputs
        .Y   ( BIBUF_5_Y ),
        // Inouts
        .PAD ( CAM2_SDA ) 
        );

//--------BIBUF
BIBUF BIBUF_6(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV6_0 ),
        // Outputs
        .Y   ( BIBUF_6_Y ),
        // Inouts
        .PAD ( CAM3_SCL ) 
        );

//--------BIBUF
BIBUF BIBUF_7(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV7_0 ),
        // Outputs
        .Y   ( BIBUF_7_Y ),
        // Inouts
        .PAD ( CAM3_SDA ) 
        );

//--------BIBUF
BIBUF BIBUF_8(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV8_0 ),
        // Outputs
        .Y   ( BIBUF_8_Y ),
        // Inouts
        .PAD ( CAM4_SDA ) 
        );

//--------BIBUF
BIBUF BIBUF_9(
        // Inputs
        .D   ( GND_net ),
        .E   ( E_IN_POST_INV9_0 ),
        // Outputs
        .Y   ( BIBUF_9_Y ),
        // Inouts
        .PAD ( CAM4_SCL ) 
        );

//--------glitch_filter
glitch_filter #( 
        .DATA_WIDTH   ( 10 ),
        .FILTER_DEPTH ( 4 ),
        .RESET_VALUE  ( 0 ) )
glitch_filter_0(
        // Inputs
        .clk      ( i_hif_clk ),
        .rst_n    ( rst_n_IN_POST_INV10_0 ),
        .sync_in  ( sync_in_net_0 ),
        // Outputs
        .sync_out ( sync_out_net_0 ) 
        );

//--------HOLOLINK_top_wrapper
HOLOLINK_top_wrapper HOLOLINK_top_0(
        // Inputs
        .i_sys_rst           ( i_sys_rst ),
        .i_apb_clk           ( i_apb_clk ),
        .i_apb_pready        ( APB_INITIATOR_i_apb_pready ),
        .i_apb_pserr         ( APB_INITIATOR_i_apb_pserr ),
        .i_sif_clk           ( i_sif_clk ),
        .i_sif_axis_tvalid_0 ( SIF_TARGET_0_i_sif_axis_tvalid_0 ),
        .i_sif_axis_tlast_0  ( SIF_TARGET_0_i_sif_axis_tlast_0 ),
        .i_sif_axis_tvalid_1 ( SIF_TARGET_1_i_sif_axis_tvalid_1 ),
        .i_sif_axis_tlast_1  ( SIF_TARGET_1_i_sif_axis_tlast_1 ),
        .i_sif_axis_tvalid_2 ( SIF_TARGET_2_i_sif_axis_tvalid_2 ),
        .i_sif_axis_tlast_2  ( SIF_TARGET_2_i_sif_axis_tlast_2 ),
        .i_sif_axis_tvalid_3 ( SIF_TARGET_3_i_sif_axis_tvalid_3 ),
        .i_sif_axis_tlast_3  ( SIF_TARGET_3_i_sif_axis_tlast_3 ),
        .i_hif_clk           ( i_hif_clk ),
        .i_hif_axis_tvalid_0 ( HIF_TARGET_0_i_hif_axis_tvalid_0 ),
        .i_hif_axis_tlast_0  ( HIF_TARGET_0_i_hif_axis_tlast_0 ),
        .i_hif_axis_tready_0 ( HIF_INITIATOR_0_i_hif_axis_tready_0 ),
        .i_hif_axis_tvalid_1 ( HIF_TARGET_1_i_hif_axis_tvalid_1 ),
        .i_hif_axis_tlast_1  ( HIF_TARGET_1_i_hif_axis_tlast_1 ),
        .i_hif_axis_tready_1 ( HIF_INITIATOR_1_i_hif_axis_tready_1 ),
        .i_ptp_clk           ( i_ptp_clk ),
        .i_apb_prdata        ( APB_INITIATOR_i_apb_prdata ),
        .i_sif_axis_tdata_0  ( SIF_TARGET_0_i_sif_axis_tdata_0 ),
        .i_sif_axis_tkeep_0  ( SIF_TARGET_0_i_sif_axis_tkeep_0 ),
        .i_sif_axis_tuser_0  ( SIF_TARGET_0_i_sif_axis_tuser_0 ),
        .i_sif_axis_tdata_1  ( SIF_TARGET_1_i_sif_axis_tdata_1 ),
        .i_sif_axis_tkeep_1  ( SIF_TARGET_1_i_sif_axis_tkeep_1 ),
        .i_sif_axis_tuser_1  ( SIF_TARGET_1_i_sif_axis_tuser_1 ),
        .i_sif_axis_tdata_2  ( SIF_TARGET_2_i_sif_axis_tdata_2 ),
        .i_sif_axis_tkeep_2  ( SIF_TARGET_2_i_sif_axis_tkeep_2 ),
        .i_sif_axis_tuser_2  ( SIF_TARGET_2_i_sif_axis_tuser_2 ),
        .i_sif_axis_tdata_3  ( SIF_TARGET_3_i_sif_axis_tdata_3 ),
        .i_sif_axis_tkeep_3  ( SIF_TARGET_3_i_sif_axis_tkeep_3 ),
        .i_sif_axis_tuser_3  ( SIF_TARGET_3_i_sif_axis_tuser_3 ),
        .i_sif_event         ( i_sif_event_const_net_0 ),
        .i_hif_axis_tdata_0  ( HIF_TARGET_0_i_hif_axis_tdata_0 ),
        .i_hif_axis_tkeep_0  ( HIF_TARGET_0_i_hif_axis_tkeep_0 ),
        .i_hif_axis_tuser_0  ( HIF_TARGET_0_i_hif_axis_tuser_0 ),
        .i_hif_axis_tdata_1  ( HIF_TARGET_1_i_hif_axis_tdata_1 ),
        .i_hif_axis_tkeep_1  ( HIF_TARGET_1_i_hif_axis_tkeep_1 ),
        .i_hif_axis_tuser_1  ( HIF_TARGET_1_i_hif_axis_tuser_1 ),
        .i_spi_sdio          ( i_spi_sdio_net_0 ),
        .i_i2c_scl           ( i_i2c_scl_net_0 ),
        .i_i2c_sda           ( i_i2c_sda_net_0 ),
        // Outputs
        .o_apb_rst           (  ),
        .o_apb_psel          ( APB_INITIATOR_PSELx ),
        .o_apb_penable       ( APB_INITIATOR_PENABLE ),
        .o_apb_pwrite        ( APB_INITIATOR_PWRITE ),
        .o_init_done         ( o_init_done_net_0 ),
        .o_sif_rst           (  ),
        .o_sif_axis_tready_0 ( SIF_TARGET_0_TREADY ),
        .o_sif_axis_tready_1 ( SIF_TARGET_1_TREADY ),
        .o_sif_axis_tready_2 ( SIF_TARGET_2_TREADY ),
        .o_sif_axis_tready_3 ( SIF_TARGET_3_TREADY ),
        .o_hif_rst           (  ),
        .o_hif_axis_tready_0 ( HIF_TARGET_0_TREADY ),
        .o_hif_axis_tvalid_0 ( HIF_INITIATOR_0_TVALID ),
        .o_hif_axis_tlast_0  ( HIF_INITIATOR_0_TLAST ),
        .o_hif_axis_tready_1 ( HIF_TARGET_1_TREADY ),
        .o_hif_axis_tvalid_1 ( HIF_INITIATOR_1_TVALID ),
        .o_hif_axis_tlast_1  ( HIF_INITIATOR_1_TLAST ),
        .o_spi_csn           ( HOLOLINK_top_0_o_spi_csn ),
        .o_spi_sck           ( HOLOLINK_top_0_o_spi_sck ),
        .o_spi_oen           ( HOLOLINK_top_0_o_spi_oen ),
        .o_sw_sys_rst        (  ),
        .o_ptp_rst           ( o_ptp_rst_net_0 ),
        .o_pps               ( o_pps_net_0 ),
        .o_apb_paddr         ( APB_INITIATOR_PADDR ),
        .o_apb_pwdata        ( APB_INITIATOR_PWDATA ),
        .o_hif_axis_tdata_0  ( HIF_INITIATOR_0_TDATA ),
        .o_hif_axis_tkeep_0  ( HIF_INITIATOR_0_TKEEP ),
        .o_hif_axis_tuser_0  ( HIF_INITIATOR_0_TUSER ),
        .o_hif_axis_tdata_1  ( HIF_INITIATOR_1_TDATA ),
        .o_hif_axis_tkeep_1  ( HIF_INITIATOR_1_TKEEP ),
        .o_hif_axis_tuser_1  ( HIF_INITIATOR_1_TUSER ),
        .o_spi_sdio          ( o_spi_sdio_net_0 ),
        .o_i2c_scl_en        ( o_i2c_scl_en_net_0 ),
        .o_i2c_sda_en        ( o_i2c_sda_en_net_0 ),
        .o_sw_sen_rst        (  ),
        .o_ptp_sec           (  ),
        .o_ptp_nanosec       (  ),
        // Inouts
        .GPIO                ( GPIO ) 
        );

//--------PF_SPI
PF_SPI PF_SPI_0(
        // Inputs
        .CLK_OE        ( VCC_net ),
        .CLK_O         ( HOLOLINK_top_0_o_spi_sck ),
        .D_OE          ( HOLOLINK_top_0_o_spi_oen ),
        .D_O           ( HOLOLINK_top_0_o_spi_sdio0to0 ),
        .SS_OE         ( VCC_net ),
        .SS_O          ( HOLOLINK_top_0_o_spi_csn ),
        .DI            ( DI ),
        .IFACE         ( IFACE ),
        .FLASH         ( FLASH ),
        // Outputs
        .CLK_I         (  ),
        .D_I           ( PF_SPI_0_D_I ),
        .SS_I          (  ),
        .FAB_SPI_OWNER (  ),
        .DO            ( DO_net_0 ),
        // Inouts
        .CLK           ( CLK ),
        .SS            ( SS ) 
        );


endmodule
