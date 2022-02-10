//==============================================
//==============================================				
//	Author	:	Wei Lu																		
//----------------------------------------------
//												
//	File Name		:	Conv_2x2.v					
//	Module Name		:	Con_2x2						
//	Release version	:	v1.0					
//												
//----------------------------------------------								
//----------------------------------------------											
//	Input	:	clk,
//				rst_n,
//              IFM,
//				Weights,					
//												
//	Output	:	OFM,
//				out_valid					
//==============================================
//==============================================
module Convolution_pipeline(
    //Input Port
    clk,
    rst_n,
	in_valid,
	In_IFM_1,
	In_IFM_2,
	In_IFM_3,
	In_IFM_4,	
	In_Weight_1,
	In_Weight_2,
	In_Weight_3,
	In_Weight_4,	
    //Output Port 
	Out_OFM
    );

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n;
input in_valid;
input[3:0]In_IFM_1;
input[3:0]In_IFM_2;
input[3:0]In_IFM_3;
input[3:0]In_IFM_4;
input[3:0]In_Weight_1;
input[3:0]In_Weight_2;
input[3:0]In_Weight_3;
input[3:0]In_Weight_4;
output reg [11:0]Out_OFM;


//---------------------------------
//      Reg declaration
//---------------------------------
reg [3:0]In_1;
reg [3:0]In_2;
reg [3:0]In_3;
reg [3:0]In_4;
reg [3:0]weight1;
reg [3:0]weight2;
reg [3:0]weight3;
reg [3:0]weight4;
//Pipeline Register Desclaration 
reg [11:0] PPR1_1;
reg [11:0] PPR1_2;
reg [11:0] PPR1_3;
reg [11:0] PPR1_4;
reg [11:0] PPR2_1;
reg [11:0] PPR2_2;
//----------------------------------------------------
//          Finite-state machine (FSM)
//----------------------------------------------------
/*always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cstate <= IDLE;
	else 
		cstate <= nstate;
end

always@(*)
begin
	case(cstate)
		IDLE:  
			if(in_valid==1)   
				nstate = IN;      
			else
				nstate = cstate;
		IN:
			nstate = Cal;
		Cal:  
			nstate = Out;         
		
		Out: 	                           
			nstate = IDLE;
		default
			nstate = cstate;
	endcase
end*/


//----------------------------------------------------
//          Receive Inputs from Pattern
//----------------------------------------------------

always@(posedge clk or negedge rst_n)  // receive IFM
begin
	if(!rst_n)
		begin
			In_1 <= 4'd0;
			In_2 <= 4'd0;
			In_3 <= 4'd0;
			In_4 <= 4'd0;
			weight1 <= 4'd0;
			weight2 <= 4'd0;
			weight3 <= 4'd0;
			weight4 <= 4'd0;
			PPR1_1 <= 12'd0;
			PPR1_2 <= 12'd0;
			PPR1_3 <= 12'd0;
			PPR1_4 <= 12'd0;
			PPR2_1 <= 12'd0;
			PPR2_2 <= 12'd0;
			Out_OFM <= 12'd0;
		end
	else if(in_valid == 1)
		begin
			In_1 <= In_IFM_1;
			In_2 <= In_IFM_2;	
			In_3 <= In_IFM_3;	
			In_4 <= In_IFM_4;	
			weight1 <= In_Weight_1;
			weight2 <= In_Weight_2;
			weight3 <= In_Weight_3;
			weight4 <= In_Weight_4;
			PPR1_1 <= In_1 * weight1;
			PPR1_2 <= In_2 * weight2;
			PPR1_3 <= In_3 * weight3;
			PPR1_4 <= In_4 * weight4;
			PPR2_1 <= PPR1_1 + PPR1_2;
			PPR2_2 <= PPR1_3 + PPR1_4;
			Out_OFM <= PPR2_1 + PPR2_2;
		end	
	else
		begin
			In_1 <= In_1;
			In_2 <= In_2;
			In_3 <= In_3;
			In_4 <= In_4;
			weight1 <= weight1;
			weight2 <= weight2;
			weight3 <= weight3;
			weight4 <= weight4;
			PPR1_1 <= PPR1_1;
			PPR1_2 <= PPR1_2;
			PPR1_3 <= PPR1_3;
			PPR1_4 <= PPR1_4;
			PPR2_1 <= PPR2_1;
			PPR2_2 <= PPR2_2;
			Out_OFM <= Out_OFM;
		end
end

endmodule