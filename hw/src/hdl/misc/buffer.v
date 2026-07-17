module buffer_lp  
#( 
    parameter G_LATENCY_CYCLES = 10  // Range 1 to n 
 )
 (
    // Inputs
    input  SYS_CLK_I,
    input  RESETN_I,
    input  DATA_A_I,
    input  DATA_B_I,
    input  DATA_C_I,
    input  DATA_D_I,
    input  DATA_E_I,
    input  DATA_F_I,
    input  DATA_G_I,
    input  DATA_H_I,
    
    // Outputs
    output DATA_A_O,
    output DATA_B_O,
    output DATA_C_O,
    output DATA_D_O,
    output DATA_E_O,
    output DATA_F_O,
    output DATA_G_O,
    output DATA_H_O   // output 
 );

 reg [G_LATENCY_CYCLES : 1] data_A;
 reg [G_LATENCY_CYCLES : 1] data_B;
 reg [G_LATENCY_CYCLES : 1] data_C;
 reg [G_LATENCY_CYCLES : 1] data_D;
 reg [G_LATENCY_CYCLES : 1] data_E;
 reg [G_LATENCY_CYCLES : 1] data_F;
 reg [G_LATENCY_CYCLES : 1] data_G;
 reg [G_LATENCY_CYCLES : 1] data_H;

// Output logic
 assign DATA_A_O = data_A[G_LATENCY_CYCLES];
 assign DATA_B_O = data_B[G_LATENCY_CYCLES];
 assign DATA_C_O = data_C[G_LATENCY_CYCLES];
 assign DATA_D_O = data_D[G_LATENCY_CYCLES];
 assign DATA_E_O = data_E[G_LATENCY_CYCLES];
 assign DATA_F_O = data_F[G_LATENCY_CYCLES];
 assign DATA_G_O = data_G[G_LATENCY_CYCLES];
 assign DATA_H_O = data_H[G_LATENCY_CYCLES];

// Pipeline Logic
 always@(posedge SYS_CLK_I or negedge RESETN_I)
 begin
   if(~RESETN_I)
   begin
     data_A <= {G_LATENCY_CYCLES{1'b1}}; 
     data_B <= {G_LATENCY_CYCLES{1'b1}};
     data_C <= {G_LATENCY_CYCLES{1'b1}};
     data_D <= {G_LATENCY_CYCLES{1'b1}};
     data_E <= {G_LATENCY_CYCLES{1'b1}};
     data_F <= {G_LATENCY_CYCLES{1'b1}};
     data_G <= {G_LATENCY_CYCLES{1'b1}};
     data_H <= {G_LATENCY_CYCLES{1'b1}};
   end
   else
   begin
     data_A <= {data_A[G_LATENCY_CYCLES - 1 : 1] , DATA_A_I};
     data_B <= {data_B[G_LATENCY_CYCLES - 1 : 1] , DATA_B_I};
     data_C <= {data_C[G_LATENCY_CYCLES - 1 : 1] , DATA_C_I};
     data_D <= {data_D[G_LATENCY_CYCLES - 1 : 1] , DATA_D_I};
     data_E <= {data_E[G_LATENCY_CYCLES - 1 : 1] , DATA_E_I};
     data_F <= {data_F[G_LATENCY_CYCLES - 1 : 1] , DATA_F_I};
     data_G <= {data_G[G_LATENCY_CYCLES - 1 : 1] , DATA_G_I};
     data_H <= {data_H[G_LATENCY_CYCLES - 1 : 1] , DATA_H_I};
   end
 end

endmodule