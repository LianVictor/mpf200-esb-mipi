///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: pps_stretch.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFire> <Die::MPF200T> <Package::FCG784>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module pps_stretch( 
  input      hif_clk_i,
  input      rstn_i,
  input      pps_i,
  output     pps_stretch_o
  );

reg [15 :0] cnt;
reg         pps_stretch;

assign pps_stretch_o =  pps_i | pps_stretch ;

always@(posedge hif_clk_i, negedge rstn_i)
begin
  if(!rstn_i) begin
    cnt            <= 0;
    pps_stretch    <= 0;  
  end
  else begin
    if(pps_i) begin
      cnt         <= 1;
      pps_stretch <= 1;
    end  
    else if (cnt != 0) begin
      cnt         <= cnt + 1;
      pps_stretch <= 1;
    end  
    else begin
      cnt         <= 0;
      pps_stretch <= 0;
    end
  end      
end  
  
  
endmodule

