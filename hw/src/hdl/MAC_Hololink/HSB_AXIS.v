//=================================================================================================
//-- File Name                           : HSB_AXIS.v

//-- Targeted device                     : PolarFire
//-- Author                              : Solutions Team
//-- Description                         : video native interface to AXIS
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================

module HSB_AXIS#(
    parameter g_DWIDTH_IN       = 10,
    parameter g_AXI_DWIDTH      = 64
  )
  (
  input                             CLK_I,
  input                             RESETN_I,
  input                             DATA_VALID_I,
  input  [g_DWIDTH_IN - 1 : 0]      DATA_I,
  input                             EOF_I,
  
  //AXIS
  input                             ACLK_I,
  input                             TREADY_I,
  // Output Ports
  output [g_AXI_DWIDTH - 1 : 0]     TDATA_O,
  output [g_AXI_DWIDTH/8 - 1 : 0]   TSTRB_O,
  output [g_AXI_DWIDTH/8 - 1 : 0]   TKEEP_O,
  output                            TVALID_O,
  output                            TLAST_O,
  output [3 : 0]                    TUSER_O
  );
  
//-=================================================================================================
// Signal declarations
//--================================================================================================ 
  reg   [6:0]                                shift_len;
  reg   [g_AXI_DWIDTH + g_DWIDTH_IN -1 :0]   data_pack;
  reg                                        eof_dly1;
  reg   [3:0]                                eof_re_sr;
  wire                                       eof_re;
  reg   [3:0]                                eof_pulse_cnt;
  reg                                        eof_pulse;
  
  //wire                                       data_valid_re;
  //reg                                        data_valid_re_dly1;
  //reg                                        data_valid_re_dly2;
  
  wire                                       fifo_ren;
  reg                                        fifo_wen;
  wire  [g_AXI_DWIDTH : 0]                   fifo_dout;
  wire                                       fifo_dvalid_out;
  wire                                       fifo_empty;
 
  wire                                       data_valid_fe;
  reg                                        data_valid_dly1;
  reg                                        data_valid_fe_dly1;
  reg                                        data_valid_fe_dly2;
  reg   [g_AXI_DWIDTH - 1 : 0]               fifo_din;
  reg   [g_AXI_DWIDTH - 1 : 0]               fifo_din_dly1;
  reg                                        fifo_wen_dly1;
  wire                                       fifo_line_end;
  wire                                       fifo_eof_vld;
  wire                                       fifo_eof;
  
  reg                                        dvalid_hold;
  reg   [g_AXI_DWIDTH+1 : 0]                 data_hold;
  
  reg   [2:0]                                data_valid_aclk_sr;
  reg   [2:0]                                eof_aclk_sr;
  wire                                       data_valid_aclk_re;
  wire                                       eof_aclk_re;
  reg   [3:0]                                line_re_cnt;
//=================================================================================================
// Top level output port assignments
//=================================================================================================  
  assign TDATA_O        =   fifo_dvalid_out ? fifo_dout[g_AXI_DWIDTH-1 : 0] : data_hold[g_AXI_DWIDTH-1 : 0] ;
  assign TSTRB_O        =   {(g_AXI_DWIDTH/8){1'b1}};
  assign TKEEP_O        =   {(g_AXI_DWIDTH/8){1'b1}};
  assign TVALID_O       =   fifo_dvalid_out | dvalid_hold;
  assign TLAST_O        =   fifo_dvalid_out ? fifo_eof : data_hold[g_AXI_DWIDTH+1];//eof
  assign TUSER_O[0]     =   1'b0;//embedded data indication
  assign TUSER_O[1]     =   fifo_dvalid_out ? fifo_dout[g_AXI_DWIDTH] : data_hold[g_AXI_DWIDTH];//line end
  assign TUSER_O[3 : 2] =   2'b0;
  
  assign fifo_ren       = TREADY_I & (~fifo_empty) & (line_re_cnt > 1) & (~TUSER_O[1]);
  assign data_valid_fe  = (data_valid_dly1 & (~DATA_VALID_I));
  //assign data_valid_re  = (DATA_VALID_I & (~data_valid_dly1));
  assign eof_re         = (EOF_I & (~eof_dly1));
  
  assign fifo_line_end  = fifo_dvalid_out ? fifo_dout[g_AXI_DWIDTH] : 0;
  assign fifo_eof_vld   = fifo_dvalid_out ? fifo_eof : 0;
  
  assign data_valid_aclk_re = data_valid_aclk_sr[1] & (~data_valid_aclk_sr[2]); 
  assign eof_aclk_re        = eof_aclk_sr[1] & (~eof_aclk_sr[2]);
//--------------------------------------------------------------------------
// Name       : data hold
// Description: process to hold the data when TREADY is low
//--------------------------------------------------------------------------  
always @(posedge ACLK_I or negedge RESETN_I)
    if(!RESETN_I)
    begin
      dvalid_hold  <= 1'b0;
      data_hold    <= 0;
    end
    else
    begin
      if (TREADY_I)
      begin
        dvalid_hold  <= 1'b0;
        data_hold    <= 0;
      end  
      else if (fifo_dvalid_out) 
      begin
        dvalid_hold  <= fifo_dvalid_out;  
        data_hold    <= {fifo_eof,fifo_dout[g_AXI_DWIDTH : 0]} ;
      end  
    end    
reg [15:0] dbg_cnt;    
//--------------------------------------------------------------------------
// Name       : dbg
// Description: dbg
//--------------------------------------------------------------------------  
always @(posedge CLK_I or negedge RESETN_I)
    if(!RESETN_I)
      dbg_cnt  <= 0;
    else if(EOF_I)
      dbg_cnt  <= 0;  
    else if (data_valid_fe)
      dbg_cnt  <= dbg_cnt + 1;  
//--------------------------------------------------------------------------
// Name       : packer
// Description: process to pack the sensor data
//--------------------------------------------------------------------------  
always @(posedge CLK_I or negedge RESETN_I)
    if(!RESETN_I)
    begin
      data_pack  <= 0;
    end
    else
    begin
      if(DATA_VALID_I == 1) 
        data_pack <= {DATA_I , data_pack[g_AXI_DWIDTH+g_DWIDTH_IN-1 : g_DWIDTH_IN]};
      else if(eof_re == 1 && shift_len[5:0] != 0)
        data_pack <= data_pack >>  (g_AXI_DWIDTH - shift_len[5:0]) ;
    end
//--------------------------------------------------------------------------
// Name       : length
// Description: process to detect packet length
//--------------------------------------------------------------------------  
always @(posedge CLK_I or negedge RESETN_I)
    if(!RESETN_I)
      shift_len    <= 0;
    else if (DATA_VALID_I)
      shift_len    <= shift_len[5:0] + g_DWIDTH_IN; //for 64-bit
    else if (eof_re == 1 && shift_len[5:0] != 0 )
      shift_len    <= g_AXI_DWIDTH;
    else if (eof_re == 1 || eof_re_sr[0] == 1)
      shift_len    <= 0;
//--------------------------------------------------------------------------
// Name       : data to fifo
// Description: process to generate data to fifo
//--------------------------------------------------------------------------  
always @(posedge CLK_I or negedge RESETN_I)
    if(!RESETN_I)
    begin
      fifo_din   <= 0;
      fifo_wen   <= 0;
    end      
    else
    begin  
      fifo_din   <= data_pack[(g_DWIDTH_IN - shift_len[5:0]) +: g_AXI_DWIDTH];
      fifo_wen   <= data_valid_dly1 & shift_len[6]; //for 64-bit
    end  
//--------------------------------------------------------------------------
// Name       : Delay
// Description: process to delay the signals
//--------------------------------------------------------------------------  
always @(posedge CLK_I or negedge RESETN_I)
    if(!RESETN_I)
    begin
      eof_pulse_cnt  <= 0;
      eof_pulse      <= 0;
    end
    else
    begin
      if (eof_re == 1 || eof_pulse_cnt != 0)
      begin
        eof_pulse_cnt <= eof_pulse_cnt + 1;
        eof_pulse     <= 1;
      end
      else
      begin  
        eof_pulse_cnt <= 0;
        eof_pulse     <= 0;
      end  
    end  
//--------------------------------------------------------------------------
// Name       : Delay
// Description: process to delay the signals
//--------------------------------------------------------------------------  
always @(posedge CLK_I or negedge RESETN_I)
    if(!RESETN_I)
      begin
        eof_dly1            <= 0;
        eof_re_sr           <= 0;
        data_valid_dly1     <= 0;
        data_valid_fe_dly1  <= 0;
        data_valid_fe_dly2  <= 0;
        fifo_wen_dly1       <= 0;
        fifo_din_dly1       <= 0;
      end
    else
      begin
        eof_dly1            <= EOF_I;
        eof_re_sr           <= {eof_re_sr[2:0],eof_re};
        data_valid_dly1     <= DATA_VALID_I ;
        data_valid_fe_dly1  <= data_valid_fe;
        data_valid_fe_dly2  <= data_valid_fe_dly1;
        fifo_wen_dly1       <= fifo_wen ;
        fifo_din_dly1       <= fifo_din;
      end 
//--------------------------------------------------------------------------
// Name       : Delay
// Description: process to delay the signals
//--------------------------------------------------------------------------  
always @(posedge ACLK_I or negedge RESETN_I)
    if(!RESETN_I)
    begin
      data_valid_aclk_sr  <= 0;
      eof_aclk_sr         <= 0;
      //data_valid_re_dly1  <= 0;
      //data_valid_re_dly2  <= 0;
    end
    else
    begin
      data_valid_aclk_sr  <= {data_valid_aclk_sr[1:0],DATA_VALID_I};
      eof_aclk_sr         <= {eof_aclk_sr[1:0],eof_pulse};
      //data_valid_re_dly1  <= data_valid_re;
      //data_valid_re_dly2  <= data_valid_re_dly1;
    end  
    
//--------------------------------------------------------------------------
// Name       : line_re_cnt
// Description: process to cnt re
//--------------------------------------------------------------------------  
always @(posedge ACLK_I or negedge RESETN_I)
    if(!RESETN_I)
    begin
      line_re_cnt        <= 0;
    end
    else if (data_valid_aclk_re == 1 || eof_aclk_re == 1)
    begin
      if (fifo_line_end == 0 && fifo_eof_vld == 0)
        line_re_cnt        <= line_re_cnt + 1;
    end  
    else if (fifo_line_end == 1 || fifo_eof_vld == 1)
    begin
        line_re_cnt        <= line_re_cnt - fifo_line_end - fifo_eof_vld;
    end    
//=================================================================================================
// Module Instantiations
//=================================================================================================

//--------------------------------------------------------------------------
// async_fifo_inst
//--------------------------------------------------------------------------
HSB_afifo#(
    .g_VIDEO_FIFO_AWIDTH(12),
    .g_DDR_AXI_DWIDTH   (g_AXI_DWIDTH+1)  //{LINE END,DATA} 
    )
  HSB_afifo_0
    (
    .rstn_i(RESETN_I),
    .wclk_i(CLK_I),
    .wrstn_i(RESETN_I),
    .wen_i(fifo_wen_dly1),
    .wdata_i({data_valid_fe_dly2,fifo_din_dly1}),
    .eof_i(eof_re_sr[3]),
    .rclk_i(ACLK_I),
    .rrstn_i(RESETN_I),
    .ren_i(fifo_ren),
    .wfull_o(),
    .wafull_o(),
    .wdata_count_o(),
    .rdata_o(fifo_dout),
    .eof_o(fifo_eof),
    .rdata_rdy_o(fifo_dvalid_out),
    .rempty_o(fifo_empty),
    .raempty_o(),
    .rhempty_o(),
    .rdata_count_o()
    );
endmodule

//=================================================================================================
//-- File Name                           : async_fifo.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module HSB_afifo#(
    //Video format selection
    parameter   g_VIDEO_FIFO_AWIDTH = 12,
    parameter   g_DDR_AXI_DWIDTH    = 512,
    parameter   g_AFULL_THRESHOLD   = (2**(g_VIDEO_FIFO_AWIDTH))-1,
    parameter   g_AEMPTY_THRESHOLD  = 10 )
    (
	input 								rstn_i,
    input                               wclk_i,
    input                               wrstn_i,
    input                               wen_i,
    input [g_DDR_AXI_DWIDTH-1 : 0]      wdata_i,
    input                               rclk_i,
	input                               rrstn_i,
	input                               ren_i,
	input                               eof_i,
    output                              wfull_o,
	output                              wafull_o,
	output [g_VIDEO_FIFO_AWIDTH-1 : 0]  wdata_count_o,
	output [g_DDR_AXI_DWIDTH-1 : 0]     rdata_o,
	output                              rdata_rdy_o,
	output                              rempty_o,
	output                              raempty_o,
	output                              rhempty_o,
	output [g_VIDEO_FIFO_AWIDTH-1 : 0]  rdata_count_o,
    output                              eof_o
    );
    
    
//-=================================================================================================
// Parameter declarations
//--================================================================================================
//parameter   AFULL_THRESHOLD	            = (2**(g_VIDEO_FIFO_AWIDTH))-1;
//parameter   AEMPTY_THRESHOLD	        = 10;   
parameter   HALF_EMPTY_THRESHOLD        = (2**(g_VIDEO_FIFO_AWIDTH)) >> 1;
//-=================================================================================================
// Signal declarations
//--================================================================================================
reg  [g_VIDEO_FIFO_AWIDTH : 0]      rbin;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      rptr;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      rwptr1;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      rwptr2;

reg                                 rempty;
reg                                 s_ren;
reg                                 raempty;
reg                                 wfull;
reg                                 wafull;
reg                                 fifo_hempty;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      rwbin;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      rdata_count;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      wbin;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      wptr;
wire [g_VIDEO_FIFO_AWIDTH : 0]      s_wrptr2_tmp;

reg  [g_VIDEO_FIFO_AWIDTH : 0]      wrptr1;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      wrptr2;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      wrbin;
reg  [g_VIDEO_FIFO_AWIDTH : 0]      wdata_count;

wire                                wen;
wire [g_VIDEO_FIFO_AWIDTH-1 : 0]    raddr;
wire [g_VIDEO_FIFO_AWIDTH-1 : 0]    waddr;
wire [g_VIDEO_FIFO_AWIDTH : 0]      rbnext;
wire [g_VIDEO_FIFO_AWIDTH : 0]      rgnext;
wire [g_VIDEO_FIFO_AWIDTH : 0]      wbnext;
wire [g_VIDEO_FIFO_AWIDTH : 0]      wgnext;
wire [g_VIDEO_FIFO_AWIDTH : 0]      wdiff_bus;
wire [g_VIDEO_FIFO_AWIDTH : 0]      rdiff_bus;

reg  [g_DDR_AXI_DWIDTH-1 : 0]       wdata_reg;
wire [g_DDR_AXI_DWIDTH-1 : 0]       wdata;

integer i,j;

wire			  dummy1,dummy2,dummy3,dummy4;
reg               dummy5,dummy6;

//=================================================================================================
// Top level output port assignments
//=================================================================================================
assign  rdata_rdy_o		= s_ren;
assign  rdata_count_o	= rdata_count[g_VIDEO_FIFO_AWIDTH-1 : 0];
assign  wfull_o			= wfull;
assign  wafull_o        = wafull;
assign  rhempty_o       = fifo_hempty;
assign  wdata_count_o   = wdata_count[g_VIDEO_FIFO_AWIDTH-1 : 0];
assign  rempty_o	    = rempty;    
assign  raempty_o 		= raempty;
    
//=================================================================================================
// Asynchronous blocks
//=================================================================================================
assign  raddr           	= rbin[g_VIDEO_FIFO_AWIDTH-1 : 0];                          /* Memory read address pointer */
assign  {dummy1,rbnext}     = rbin + (ren_i & (!rempty));                               /* Increment binary counter */
//assign  rgnext          = ({1'b0,rbnext[g_VIDEO_FIFO_AWIDTH:1]}) ^ rbnext;        /* Binary to Gray conversion */
assign  rgnext          	= (rbnext>>1) ^ rbnext;        /* Binary to Gray conversion */
assign  wdata               = eof_i ? wdata_reg : wdata_i ;
assign  wen	            	= ((wen_i == 1 || eof_i == 1) & wfull == 0) ? 1 : 0;        /* Write to memory only when FIFO is not full */
assign  waddr           	= eof_i ? wbin[g_VIDEO_FIFO_AWIDTH-1 : 0] - 1 : wbin[g_VIDEO_FIFO_AWIDTH-1 : 0];  /* Memory write address pointer */
assign  {dummy2,wbnext}     = wbin + (wen_i & (!wfull));                                /* Increment binary counter */
//assign  wgnext          = ({1'b0,wbnext[g_VIDEO_FIFO_AWIDTH:1]}) ^ wbnext;        /* Binary to Gray conversion */
assign  wgnext          	= (wbnext >> 1) ^ wbnext;        /* Binary to Gray conversion */
assign  {dummy3,rdiff_bus} 	= rwbin - rbin;
assign  {dummy4,wdiff_bus}	= wbin - wrbin;
assign  s_wrptr2_tmp		= {~(wrptr2[g_VIDEO_FIFO_AWIDTH : g_VIDEO_FIFO_AWIDTH-1]), wrptr2[g_VIDEO_FIFO_AWIDTH-2 : 0]};    
    
//--------------------------------------------------------------------------
// Name       : GRAY2BIN_CONV
// Description: Process converts gray code to binary
//--------------------------------------------------------------------------
always@(rwbin,rwptr2) begin 
    rwbin[g_VIDEO_FIFO_AWIDTH]	<= rwptr2[g_VIDEO_FIFO_AWIDTH];
    for(i = g_VIDEO_FIFO_AWIDTH[31:0]-1; i>=0; i = i-1) begin 
    //for(i = 0; i<=g_VIDEO_FIFO_AWIDTH-1; i = i+1) begin 
        rwbin[i]    <= rwptr2[i] ^ rwbin[i+1];
    end
end

//--------------------------------------------------------------------------
// Name       : GRAY2BIN_CONV
// Description: Process implements gray to binary conversion
//--------------------------------------------------------------------------
always@(wrbin,wrptr2) begin 
    wrbin[g_VIDEO_FIFO_AWIDTH]	<= wrptr2[g_VIDEO_FIFO_AWIDTH];
    for(j = g_VIDEO_FIFO_AWIDTH[31:0]-1; j>=0; j = j-1) begin 
    //for(i = 0; i<=g_VIDEO_FIFO_AWIDTH-1; i = i+1) begin 
        wrbin[j]    <= wrptr2[j] ^ wrbin[j+1];
    end
end

//=================================================================================================
// Synchronous blocks
//=================================================================================================

//--------------------------------------------------------------------------
// Name       : READ_PTR_ASSIGN_PROC
// Description: Process reads data
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		s_ren       <= 0;
	end else
    if(!rrstn_i) begin 
        s_ren       <= 0;
    end
    else begin 
        s_ren       <= ren_i;
    end
end

//--------------------------------------------------------------------------
// Name       : READ_PTR_ASSIGN_PROC
// Description: Process reads data
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		rbin       <= 0;
        rptr       <= 0;
	end else 
    if(!rrstn_i) begin 
        rbin       <= 0;
        rptr       <= 0;
    end
    else begin 
        rbin       <= rbnext;
        rptr       <= rgnext;
    end
end

//--------------------------------------------------------------------------
// Name       : SYNC_WRPTR_RDCLK_PROC
// Description: Process synchronizes write pointer to read clock domain
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		rwptr1       <= 0;
        rwptr2       <= 0;
	end else
    if(!rrstn_i) begin 
        rwptr1       <= 0;
        rwptr2       <= 0;
    end
    else begin 
        rwptr1       <= wptr;
        rwptr2       <= rwptr1;
    end
end

//--------------------------------------------------------------------------
// Name       : REMPTY_ASSIGN_PROC
// Description: Process assigns read empty when next rptr equals synchronized wptr
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		rempty       <= 1;
	end else
    if(!rrstn_i) begin 
        rempty       <= 1;
    end
    else begin 
        if(rgnext == rwptr2) begin 
            rempty      <= 1;
        end
        else begin 
            rempty      <= 0;
        end
    end
end

//--------------------------------------------------------------------------
// Name       : DATACNT_PROC
// Description: Process counts data in FIFO (diff between write and read ptr)
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		rdata_count       <= 0;
		dummy5			  <= 0;
	end else
    if(!rrstn_i) begin 
        rdata_count       <= 0;
		dummy5			  <= 0;
    end
    else begin 
        {dummy5,rdata_count} <= (rwbin - rbin);
    end
end

//--------------------------------------------------------------------------
// Name       : READ_EMPTY_ASSIGN
// Description: Process detects read buffer empty
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		raempty       <= 1;
	end else
    if(!rrstn_i) begin 
        raempty       <= 1;
    end
    else begin 
        if(g_AEMPTY_THRESHOLD[g_VIDEO_FIFO_AWIDTH : 0] >= rdiff_bus) begin 
            raempty     <= 1;
        end
        else begin 
            raempty     <= 0;
        end
    end
end

//--------------------------------------------------------------------------
// Name       : HALFEMPTY_PROC
// Description: Process assigns fifo half empty signal
//--------------------------------------------------------------------------
always@(posedge rclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		fifo_hempty       <= 1;
	end else
    if(!rrstn_i) begin 
        fifo_hempty       <= 1;
    end
    else begin 
        if(HALF_EMPTY_THRESHOLD[g_VIDEO_FIFO_AWIDTH : 0] >= rdiff_bus) begin 
            fifo_hempty     <= 1;
        end
        else begin 
            fifo_hempty     <= 0;
        end
    end
end

//---------------WRITE SECTION----------------------//
//--------------------------------------------------------------------------
// Name       : wdata reg
// Description: Process to latch wdata
//--------------------------------------------------------------------------
always@(posedge wclk_i) begin 
	if(!rstn_i) begin
      wdata_reg    <= 0; 
    end 
    else if (wen_i) begin
      wdata_reg    <= wdata_i;
    end  
end    
//--------------------------------------------------------------------------
// Name       : BIN_GRAY_CTR_PROC
// Description: Process implements binary and gray counters
//--------------------------------------------------------------------------
always@(posedge wclk_i) begin 
	if(!rstn_i) begin 
		wbin       <= 0;
        wptr       <= 0;
	end else
    if(!wrstn_i) begin 
        wbin       <= 0;
        wptr       <= 0;
    end
    else begin 
        wbin       <= wbnext;
        wptr       <= wgnext;
    end
end

//--------------------------------------------------------------------------
// Name       : SYNC_READ_PTR
// Description: Syncronizes read pointer into write clock domain
//--------------------------------------------------------------------------
always@(posedge wclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		wrptr1       <= 0;
        wrptr2       <= 0;
	end else
    if(!wrstn_i) begin 
        wrptr1       <= 0;
        wrptr2       <= 0;
    end
    else begin 
        wrptr1       <= rptr;
        wrptr2       <= wrptr1;
    end
end

// FIFO is full when following 3 condition are true
// 1. The wptr and the synchronized rptr MSB's are not equal
// 2. The wptr and the synchronized rptr 2nd MSB's are not equal
// 3. All other wptr and synchronized rptr bits must be equal

//--------------------------------------------------------------------------
// Name       : FIFO_FULL_ASSIGN
// Description: Synchronizes read pointer into write clock domain
//--------------------------------------------------------------------------
always@(posedge wclk_i, negedge rstn_i) begin
	if(!rstn_i) begin 
		wfull       <= 0;
	end else
    if(!wrstn_i) begin 
        wfull       <= 0;
    end
    else begin 
        if(wgnext == s_wrptr2_tmp)begin 
            wfull	<= 1;
        end
        else begin 
            wfull	<= 0;
        end
    end
end

//--------------------------------------------------------------------------
// Name       : FIFO_COUNT
// Description: Data available in FIFO is difference between write and read pointer
//--------------------------------------------------------------------------
always@(posedge wclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		wdata_count       <= 0;
		dummy6			  <= 0;
	end else
    if(!wrstn_i) begin 
        wdata_count       <= 0;
		dummy6			  <= 0;
    end
    else begin 
       {dummy6,wdata_count}	<= wbin - wrbin;
    end
end

//--------------------------------------------------------------------------
// Name       : WA_FULL_ASSIGN
// Description: Assigns wafull signal
//--------------------------------------------------------------------------
always@(posedge wclk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		wafull       <= 0;
	end else
    if(!wrstn_i) begin 
        wafull       <= 0;
    end
    else begin 
        if(wdiff_bus >= g_AFULL_THRESHOLD[g_VIDEO_FIFO_AWIDTH : 0])begin 
            wafull	<= 1;
        end
        else begin 
            wafull	<= 0;
        end
    end
end

//=================================================================================================
// Module Instantiations
//=================================================================================================

//--------------------------------------------------------------------------
// ram2port_inst
//--------------------------------------------------------------------------
ram2port_HSB_async_fifo #(
           .g_BUFF_AWIDTH   ( g_VIDEO_FIFO_AWIDTH      ),
           .g_DWIDTH    	( g_DDR_AXI_DWIDTH  + 1    )
          )
    RAM2PORT_ASYNC_FIFO_INST(
        .wr_data_i	   	    ( {eof_i,wdata}     ),
        .rd_addr_i        	( raddr     ),
        .wr_addr_i        	( waddr     ),
        .we_i         		( wen       ),
        .wclk_i        	    ( wclk_i  	),
        .rclk_i        	    ( rclk_i  	),
        .rd_data_o       	( {eof_o,rdata_o}   )
    );
    

endmodule

//=================================================================================================
//-- File Name                           : ram2port_async_fifo.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module ram2port_HSB_async_fifo#(
    // Video format selection
    parameter g_BUFF_AWIDTH     = 10,
    parameter g_DWIDTH       	= 64)
    ( 
    //Read and Write clocks
    input                         wclk_i,
	input                         rclk_i,
	//Write Enable
	input                         we_i,
	//Read and Write Addresses
	input   [g_BUFF_AWIDTH-1 : 0] rd_addr_i,
	input   [g_BUFF_AWIDTH-1 : 0] wr_addr_i,
	//Write data input
    input   [g_DWIDTH-1 : 0]      wr_data_i,
	//Read data outputs
	output [g_DWIDTH-1 : 0]      rd_data_o
    );

//=================================================================================================
// Signal declarations
//=================================================================================================
reg  [g_DWIDTH-1 : 0]            ram [0:2**g_BUFF_AWIDTH-1] /*synthesis syn_ramstyle="lsram" */;
reg  [g_BUFF_AWIDTH-1 : 0]       rd_addr_reg;
    
//=================================================================================================
// Top level output port assignments
//=================================================================================================
assign rd_data_o	= ram[rd_addr_reg];

//-=================================================================================================
// Synchronous blocks
//=================================================================================================
//--------------------------------------------------------------------------
// Name       : WRITE_PROC
// Description: Process writes data into RAM
//--------------------------------------------------------------------------    
always@(posedge wclk_i) begin 
    if(we_i == 1) begin 
        ram[wr_addr_i]  <= wr_data_i;
    end
end

//--------------------------------------------------------------------------
// Name       : READ_PROC
// Description: Process reads data from RAM
//--------------------------------------------------------------------------
always@(posedge rclk_i) begin 
    rd_addr_reg  <= rd_addr_i;
end
    
endmodule


