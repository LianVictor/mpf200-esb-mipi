// ********************************************************************/
// Microchip Corporation Proprietary and Confidential
// Copyright 2023 Microchip Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Module: MAC_to_AXIS
// Description: Wrapper module instantiating:
//              1. AXI4-Stream to MAC TX converter (AXI4S input -> MAC TX output)
//              2. MAC RX to AXI4-Stream converter (MAC RX input -> AXI4S output)
// ********************************************************************/

module MAC_to_AXIS (
    // Clock and Reset
    input                           CLK,
    input                           RST,
    
    // AXI4-Stream TX Interface (Input) - to MAC TX
    input                           AXI4S_TX_TVALID,
    input  [63:0]                   AXI4S_TX_TDATA,
    input  [7:0]                    AXI4S_TX_TKEEP,
    input                           AXI4S_TX_TLAST,
    output                          AXI4S_TX_TREADY,
    
    // MAC TX Interface (Output)
    output                          O_MAC_TX_EN,
    output                          O_MAC_TX_SOP,
    output                          O_MAC_TX_EOP,
    output [2:0]                    O_MAC_TX_BC,
    output [63:0]                   O_MAC_TX_DATA,
    input                           I_MAC_TX_RDY,
    
    // MAC RX Interface (Input)
    input                           I_MAC_RX_EN,
    input                           I_MAC_RX_SOP,
    input                           I_MAC_RX_EOP,
    input  [2:0]                    I_MAC_RX_BC,
    input  [63:0]                   I_MAC_RX_DATA,
    input  [7:0]                    I_MAC_RX_ERR_W,
    
    // AXI4-Stream RX Interface (Output) - from MAC RX
    output                          AXI4S_RX_TVALID,
    output [63:0]                   AXI4S_RX_TDATA,
    output [7:0]                    AXI4S_RX_TKEEP,
    output [7:0]                    AXI4S_RX_TUSER,
    input                           AXI4S_RX_TREADY,
    output                          AXI4S_RX_TLAST
);

//-----------------------------------------------------------------------------
// Instance: AXI4-Stream to MAC TX Converter
//-----------------------------------------------------------------------------
cm2a_axi4s2mactx #(
    .SDW(64)
) u_axi4s2mactx (
    // Clock and Reset
    .clk            (CLK),
    .rst            (RST),
    
    // AXI4-Stream Input Interface
    .axi4s_tvalid   (AXI4S_TX_TVALID),
    .axi4s_tdata    (AXI4S_TX_TDATA),
    .axi4s_tkeep    (AXI4S_TX_TKEEP),
    .axi4s_tlast    (AXI4S_TX_TLAST),
    .axi4s_tready   (AXI4S_TX_TREADY),
    
    // MAC TX Output Interface
    .o_mac_tx_en    (O_MAC_TX_EN),
    .o_mac_tx_sop   (O_MAC_TX_SOP),
    .o_mac_tx_eop   (O_MAC_TX_EOP),
    .o_mac_tx_bc    (O_MAC_TX_BC),
    .o_mac_tx_data  (O_MAC_TX_DATA),
    .i_mac_tx_rdy   (I_MAC_TX_RDY)
);

//-----------------------------------------------------------------------------
// Instance: MAC RX to AXI4-Stream Converter
//-----------------------------------------------------------------------------
cm2a_macrx2axi4s #(
    .SDW(64)
) u_macrx2axi4s (
    // MAC RX Input Interface
    .i_mac_rx_en    (I_MAC_RX_EN),
    .i_mac_rx_sop   (I_MAC_RX_SOP),
    .i_mac_rx_eop   (I_MAC_RX_EOP),
    .i_mac_rx_bc    (I_MAC_RX_BC),
    .i_mac_rx_data  (I_MAC_RX_DATA),
    .i_mac_rx_err_w (I_MAC_RX_ERR_W),
    
    // AXI4-Stream Output Interface
    .axi4s_tvalid   (AXI4S_RX_TVALID),
    .axi4s_tdata    (AXI4S_RX_TDATA),
    .axi4s_tkeep    (AXI4S_RX_TKEEP),
    .axi4s_tuser    (AXI4S_RX_TUSER),
    .axi4s_tready   (AXI4S_RX_TREADY),
    .axi4s_tlast    (AXI4S_RX_TLAST)
);

endmodule

//-----------------------------------------------------------------------------
// Module: cm2a_axi4s2mactx
// Description: AXI4-Stream to MAC TX interface converter
//              Converts AXI4-Stream input to MAC TX output
//-----------------------------------------------------------------------------

module cm2a_axi4s2mactx #(
    parameter SDW = 64
)(
    input                            clk,
    input                            rst,
    
    // AXI4-Stream Input Interface
    input                            axi4s_tvalid,
    input  [SDW-1:0]                 axi4s_tdata,
    input  [(SDW/8)-1:0]             axi4s_tkeep,
    input                            axi4s_tlast,
    output logic                     axi4s_tready,
    
    // MAC TX Output Interface
    output logic                     o_mac_tx_en,
    output logic                     o_mac_tx_sop,
    output logic                     o_mac_tx_eop,
    output logic [$clog2(SDW/8)-1:0] o_mac_tx_bc,
    output logic [SDW-1:0]           o_mac_tx_data,
    input                            i_mac_tx_rdy
);

integer i, j;

// Pass through valid and ready
assign o_mac_tx_en   = axi4s_tvalid;
assign axi4s_tready  = i_mac_tx_rdy;
assign o_mac_tx_eop  = axi4s_tvalid && axi4s_tlast;

// SOP generation - first valid after reset or after EOP
reg tvalid_lat;
always @(posedge clk)
    if (rst)
        tvalid_lat <= 1'b0;
    else if (o_mac_tx_eop)
        tvalid_lat <= 1'b0;
    else if (axi4s_tvalid && ~tvalid_lat)
        tvalid_lat <= 1'b1;

assign o_mac_tx_sop = axi4s_tvalid && ~tvalid_lat;

// Byte swap: AXI4-Stream to MAC format
always_comb
    for (i = 0; i < (SDW/8); i = i + 1)
        o_mac_tx_data[i*8 +: 8] = axi4s_tdata[((SDW/8)-i-1)*8 +: 8];

// Convert tkeep to byte count
always_comb begin
    o_mac_tx_bc = {$clog2(SDW/8){1'b1}};
    for (j = 0; j < SDW/8; j = j + 1)
        if (axi4s_tkeep[j] == 1)
            o_mac_tx_bc = j;
end

endmodule

//-----------------------------------------------------------------------------
// Module: cm2a_macrx2axi4s
// Description: MAC RX to AXI4-Stream interface converter
//              Converts MAC RX input to AXI4-Stream output
//-----------------------------------------------------------------------------

module cm2a_macrx2axi4s #(
    parameter SDW = 64
)(
    // MAC RX Input Interface
    input                            i_mac_rx_en,
    input                            i_mac_rx_sop,
    input                            i_mac_rx_eop,
    input  [$clog2(SDW/8)-1:0]       i_mac_rx_bc,
    input  [SDW-1:0]                 i_mac_rx_data,
    input  [7:0]                     i_mac_rx_err_w,
    
    // AXI4-Stream Output Interface
    output logic                     axi4s_tvalid,
    output logic [SDW-1:0]           axi4s_tdata,
    output logic [(SDW/8)-1:0]       axi4s_tkeep,
    output logic [7:0]               axi4s_tuser,
    input                            axi4s_tready,
    output logic                     axi4s_tlast
);

integer i;

// Pass through valid and last
assign axi4s_tvalid = i_mac_rx_en;
assign axi4s_tlast  = i_mac_rx_eop;
assign axi4s_tuser  = i_mac_rx_err_w;

// Byte swap: MAC format to AXI4-Stream
always_comb
    for (i = 0; i < (SDW/8); i = i + 1)
        axi4s_tdata[i*8 +: 8] = i_mac_rx_data[((SDW/8)-i-1)*8 +: 8];

// Convert byte count to tkeep
always_comb begin
    axi4s_tkeep = {(SDW/8){1'b1}};
    if (i_mac_rx_en & i_mac_rx_eop)
        axi4s_tkeep = {(SDW/8){1'b1}} >> ~(i_mac_rx_bc[$clog2(SDW/8)-1:0]);
end

endmodule
