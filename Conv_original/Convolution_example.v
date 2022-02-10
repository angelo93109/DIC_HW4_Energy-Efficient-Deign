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
module Convolution_example(
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
    out_valid, 
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
output reg out_valid;
output reg [11:0]Out_OFM;


//---------------------------------
//      Parameter declaration
//---------------------------------
parameter IDLE       = 2'd0;
parameter IN         = 2'd1;
parameter Cal        = 2'd2;
parameter Out        = 2'd3;

//---------------------------------
//      Reg declaration
//---------------------------------
reg [1:0]cstate;
reg [1:0]nstate;
reg [3:0]In_1;
reg [3:0]In_2;
reg [3:0]In_3;
reg [3:0]In_4;
reg [3:0]weigts1;
reg [3:0]weigts2;
reg [3:0]weigts3;
reg [3:0]weigts4;
//reg [18:0]Adder;
wire [11:0]Adder;

//----------------------------------------------------
//          Finite-state machine (FSM)
//----------------------------------------------------
always@(posedge clk or negedge rst_n)
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
end


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
		end
	else if(in_valid == 1)
		begin
			In_1 <= In_IFM_1;
			In_2 <= In_IFM_2;	
			In_3 <= In_IFM_3;	
			In_4 <= In_IFM_4;	
		end	
	else if(cstate == IDLE)
		begin
			In_1 <= 4'd0;
			In_2 <= 4'd0;
			In_3 <= 4'd0;
			In_4 <= 4'd0;
		end
	else
		begin
			In_1 <= In_1;
			In_2 <= In_2;
			In_3 <= In_3;
			In_4 <= In_4;
		end
end

always@(posedge clk or negedge rst_n)  // receive weights
begin
	if(!rst_n)
		begin
			weigts1 <= 4'd0;
			weigts2 <= 4'd0;
			weigts3 <= 4'd0;
			weigts4 <= 4'd0;
		end
	else if(in_valid == 1)
		begin
			weigts1 <= In_Weight_1;
			weigts2 <= In_Weight_2;	
			weigts3 <= In_Weight_3;	
			weigts4 <= In_Weight_4;	
		end
	else if(cstate == IDLE)
		begin
			weigts1 <= 4'd0;
			weigts2 <= 4'd0;
			weigts3 <= 4'd0;
			weigts4 <= 4'd0;
		end	
	else
		begin
			weigts1 <= weigts1;
			weigts2 <= weigts2;
			weigts3 <= weigts3;
			weigts4 <= weigts4;
		end
end

//----------------------------------------------------
//          Convolution circuit (2x2)
//----------------------------------------------------

// Adder

/*always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		Adder <= 19'd0;
	else if(cstate == Cal)
		Adder <= (In_1 * weigts1) +  (In_2 * weigts2)+  (In_3 * weigts3)+  (In_4 * weigts4);
	else 
		Adder <= Adder;
end
*/
assign Adder = (In_1 * weigts1) +  (In_2 * weigts2)+  (In_3 * weigts3)+  (In_4 * weigts4);
//----------------------------------------------------
//          Output the calculated data
//----------------------------------------------------
//output data
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		Out_OFM <= 12'd0;
	else if(cstate == Out)
		Out_OFM <= Adder;
	else 
		Out_OFM <= 12'd0;
end

//output valid
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_valid <= 1'd0;
	else if(cstate == Out)
		out_valid <= 1'd1;
	else 
		out_valid <= 1'd0;

end


endmodule