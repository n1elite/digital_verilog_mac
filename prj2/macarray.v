/*****************************************
    
    Team XX : 
        2024000000    Kim Mina
        2024000001    Lee Minho
*****************************************/



////////////////////////////////////
//  TOP MODULE
////////////////////////////////////
module macarray (
    input     wire              CLK,
    input     wire              RSTN,
	input	  wire	  [11:0]	MNT,
	input	  wire				START,
	
    output    wire              EN_I,
    output    wire    [2:0]     ADDR_I,
    input     wire    [63:0]    RDATA_I,
	output    wire              EN_W,
    output    wire    [2:0]     ADDR_W,
    input     wire    [63:0]    RDATA_W,
	
    output    wire              EN_O,
    output    wire              RW_O,
    output    wire    [3:0]     ADDR_O,
    output    wire    [63:0]    WDATA_O,
    input     wire    [63:0]    RDATA_O
);
	
	reg [7:0] wgt_matrix0, wgt_matrix1, wgt_matrix2, wgt_matrix3;
	reg [7:0] inp_matrix1, inp_matrix1, inp_matrix2, inp_matrix3;
	reg [3:0] m_count, n_count, t_count;
	reg [3:0] done, Icount, Wcount;
	wire [3:0] M, N, T; 
	wire [63:0] outdata;
	reg [3:0] EN0, EN1, EN2, EN3;
	reg [3:0] Icalc;

	

	assign M = MNT[11:8];
	assign N = MNT[7:4];
	assign T = MNT[3:0];

	always@(posedge CLK or negedge RSTN) begin
		if(~RSTN) beign
			ADDR_I <= 0;
			ADDR_W <= 0;
			t_count <= 0;
			m_count <= 0;
		end
		else begin
			if(Icount == 3 && N >= 5) begin
				ADDR_I <= ADDR_I + 1;
				t_count <= t_count + 1; 
			end else if(N <= 4) begin
				ADDR_I <== ADDR + 1;
				t_count <= t_count + 1;
			end
			end else if(Wcount==3 && N==4) begin
				ADDR_W <= ADDR_W + 1;
				m_count <= m_count + 1;
			end else if(Wcount==4 && N==5) begin
				ADDR_W <= ADDR_W + 1;
				m_count <= m_count + 1;
			end else if(Wcount==5 && N==6) begin
				ADDR_W <= ADDR_W + 1;
				m_count <= m_count + 1;
			end else if(Wcount==6 && N==7) begin
				ADDR_W <= ADDR_W + 1;
				m_count <= m_count + 1;
			end else if(Wcount==7 && N==8) begin
				ADDR_W <= ADDR_W + 1;
				m_count <= m_count + 1;
			end else begin
				ADDR_I <= 0;
				ADDR_W <= 0;
				t_count <= 0;
				m_count <= 0;
			end
		end	
	end
		
	
	
	always@(posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			inp_matrix0 <= 0;
			inp_matrix1 <= 0;
			inp_matrix2 <= 0;
			inp_matrix3 <= 0;
		end 
		else begin 
			if (Icalc == 1) begin
				inp_matrix0 <= RDATA_I[7:0];
				inp_matrix1 <= RDATA_I[15:8];
				inp_matrix2 <= RDATA_I[23:16];
				inp_matrix3 <= RDATA_I[31:24];
			end else begin
				inp_matrix0 <= RDATA_I[63:56];
				inp_matrix1 <= RDATA_I[55:48];
				inp_matrix2 <= RDATA_I[47:40];
				inp_matrix3 <= RDATA_I[39:32];
			end
		end
	end

	always @(posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			wgt_matrix0 <= 0;	
			wgt_matrix0 <= 0;
			wgt_matrix0 <= 0;
			wgt_matrix0 <= 0;
		end
		else begin
			if(Icalc == 1) begin
				wgt_matrix0 <= WDATA_I[7:0];
				wgt_matrix1 <= WDATA_I[15:8];
				wgt_matrix2 <= WDATA_I[23:16];
				wgt_matrix3 <= WDATA_I[31:24];
			end else begin
				wgt_matrix0 <= WDATA_I[63:56];
				wgt_matrix1 <= WDATA_I[55:48];
				wgt_matrix2 <= WDATA_I[47:40];
				wgt_matrix3 <= WDATA_I[39:32];
			end
		end
	end
	

	always @(posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			EN0 <= 0;
			EN1 <= 0;
			EN2 <= 0;
			EN3 <= 0;
		end
		else begin
			if((ADDR_I % 4)==0 && Icalc == 0 && N <= 4) begin
				EN0 <= (2'b0001 << (N-1)) | ((2*(N-1)) + 1);
				EN1 <= 0;
				EN2 <= 0;
				EN3 <= 0;
			end else if((ADDR_I%4)==0 && Icalc == 0 && N>=5) begin
				EN0 <= 2'b1111;
				EN1 <= 0;
				EN2 <= 0;
				EN3 <= 0;
			end else if((ADDR_I%4)==0 && Icalc == 1 && N>=5) begin
				EN0 <= (2'b0001 << (N-5)) | ((2*(N-5))  + 1);
				EN1 <= 0;
				EN2 <= 0;
				EN3 <= 0;
			//첫번째 줄
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= (2'b0001 << (N-1)) | ((2*(N-1))  + 1);
				EN2 <= 0;
				EN3 <= 0;
			end else if((ADDR_I%4)==1 && Icalc == 0 && N>=5) begin
				EN0 <= 0;
				EN1 <= 2'b1111;
				EN2 <= 0;
				EN3 <= 0;
			end else if((ADDR_I%4)==1 && Icalc == 1 && N>=5) begin
				EN0 <= 0;
				EN1 <= (2'b0001 << (N-5)) | ((2*(N-5))  + 1);
				EN2 <= 0;
				EN3 <= 0;
			//두번쨰 줄
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= 0;
				EN2 <= (2'b0001 << (N-1)) | ((2*(N-1))  + 1);
				EN3 <= 0;
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= 0;
				EN2 <= 2'b1111;
				EN3 <= 0;
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= 0;
				EN2 <= (2'b0001 << (N-5)) | ((2*(N-5))  + 1);
				EN3 <= 0;
			//세번째 줄
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= 0;
				EN2 <= 0;
				EN3 <= (2'b0001 << (N-1)) | ((2*(N-1))  + 1);
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= 0;
				EN2 <= 0;
				EN3 <= 2'b1111;
			end else if((ADDR_I%4)==1 && Icalc == 0 && N<=4) begin
				EN0 <= 0;
				EN1 <= 0;
				EN2 <= 0;
				EN3 <= (2'b0001 << (N-5)) | ((2*(N-5))  + 1);
			end
			//네번째 줄
	end

				

	always @(posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			ADDR_O <= 0;
		end else begin
			if(EN_O == 0) begin
				ADDR_O <= ADDR_O+1; //다른 조건 필요함 4개 원소의 연산이 끝나면 1씩 증가해야한다
			end else begin
				ADDR_O <= ADDR_O;
		end
	end
	
		
	
    // WRITE YOUR CONTROL SYSTEM CODE
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			done <= 0;
			Icount <= 0;
			Wcount <= 0;
			n_count <= 0;
			Icalc <= 0;
		end
		else begin
			if(Icount == 3) begin
				done <= 1;
				count <= 0;
			end else if (Icount == 3 && N >=5) begin
				Icalc <= 1;
			end else if (n_count == N -1) begin		
				n_count <= 0;
				Icalc <= 0;
			end else begin
				done <= 0;
				count <= count + 1;
				n_count <= n_count + 1;
			end
			
			if(Wcount == 3 && N==4)
				Wcount <= 0;
			else if (Wcount == 4 && N == 5)
				Wcount <= 0;
			else if (Wcount == 5 && N == 6)
				Wcount <= 0;
			else if (Wcount == 6 && N == 7)
				Wcount <= 0;
			else if (Wcount == 7 && N == 8)
				Wcount <= 0;
			else Wcount <= Wcount + 1;
		end	
	end 


    // WRITE YOUR MAC_ARRAY DATAPATH CODE
	block P0 (wgt_matrix0, inp_matrix0, 0, EN0[0], CLK, RSTN, outp_south0, result0);
	//from north
	block P1 (wgt_matrix1, inp_matrix1, result0, EN0[1], CLK, RSTN, outp_south1, result1);
	block P2 (wgt_matrix2, inp_matrix2, result1, EN0[2], CLK, RSTN, outp_south2, result2);
	block P3 (wgt_matrix3, inp_matrix3, result2, EN0[3], CLK, RSTN, outp_south3, result3);
	
	//from west
	block P4 (outp_south0, inp_matrix0, 0, EN1[0], CLK, RSTN, outp_south4, result4);
	block P8 (outp_south4, inp_matrix0, 0, EN2[0], CLK, RSTN, outp_south8, result8);
	block P12 (outp_south8, inp_matrix0, 0, EN3[2], CLK, RSTN, outp_south12, result12);
	//second row
	block P5 (outp_south1, inp_matrix1, result4, EN1[1], CLK, RSTN, outp_south5, result5);
	block P6 (outp_south2, inp_matrix2, result5, EN1[2], CLK, RSTN, outp_south6, result6);
	block P7 (outp_south3, inp_matrix3, result6, EN1[3], CLK, RSTN, outp_south7, result7);
	//third row
	block P9 (outp_south5, inp_matrix1, result8, EN2[1], CLK, RSTN, outp_south9, result9);
	block P10 (outp_south6, inp_matrix2, result9, EN2[2], CLK, RSTN, outp_south10, result10);
	block P11 (outp_south7, inp_matrix3, result10, EN2[3], CLK, RSTN, outp_south11, result11);
	//fourth row
	block P13 (outp_south9, inp_matrix1, result12, EN3[1], CLK, RSTN, outp_south13, result13);
	block P14 (outp_south10, inp_matrix2, result13, EN3[2], CLK, RSTN, outp_south14, result14);
	block P15 (outp_south11, inp_matrix3, result14, EN3[3], CLK, RSTN, outp_south15, result15);
	
	
endmodule




module block(inp_north, inp_matrix, inp_west, EN, clk, rst, outp_south, result);
	input [7:0] inp_north, inp_west, inp_matrix;
	output reg [7:0] outp_south;
	input EN, clk, rst;
	output reg [15:0] result;
	wire [15:0] multi;
	
	always @(posedge rst or posedge clk) begin
		if(~rst) begin
			result <= 0;
			outp_south <= 0;
		end
		else if (EN == 0) begin
			result <= 0;
		end
		else begin
			outp_south <= inp_north;  //weight
			result <= inp_west + multi;
		end
	end
	
	assign multi = inp_north*input_matrix;

endmodule
