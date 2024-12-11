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
	
	reg [3:0] wgt_matrix [3:0];
	reg [3:0] inp_matrix [15:0];
	wire [3:0] wgt_take [31:0];
	wire [3:0] inp_take [31:0];
	reg [3:0] m_count, n_count, t_count;
	reg [3:0] done, count;
	wire [3:0] M, N, T;
	reg [2:0] current_Iaddr, current_Waddr;
	reg [2:0] q, cycle;
	wire [63:0] matrix_I; 
	wire [63:0] outdata;


	 assign matrix_I =   (N == 0)    ?   {64'b0}                     :
                       		   (N == 1)    ?   {RDATA_I[63:56] , 56'b0}    :
                        	   (N == 2)    ?   {RDATA_I[63:48] , 48'b0}    :
                        	   (N == 3)    ?   {RDATA_I[63:40] , 40'b0}    :
                        	   (N == 4)    ?   {RDATA_I[63:32] , 32'b0}    :
                        	   (N == 5)    ?   {RDATA_I[63:24] , 24'b0}    :
                        	   (N == 6)    ?   {RDATA_I[63:16] , 16'b0}    :
                        	   (N == 7)    ?   {RDATA_I[63:8] , 8'b0}      :
                        	   (N == 8)    ?   {RDATA_I[63:0]}             :   {64'b0};
	
	assign WDATA_O = out_connect;

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
			if(t_count < T-1) begin
				ADDR_I <= ADDR_I + 1;
				t_count <= t_count + 1; // 다른 조건 필요함
			end else if(m_count < M && t_count == T-1) begin
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
		
	generate
		for(i=0; i<4; i = i+1) begin
			assign inp_take[i + t_count*4] = matrix_I[31-i*8 : 24-i*8];
		end
		for(j=0; j<4, j=j+1) begin
			assign wgt_take[j + m_count*4] = RDATA_W[31-j*8 : 24-j*8];
		end
	endgenerate
	
	always@(posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			row_count <= 0; // 0~3
			q<=0; //0~3
		end 
		else begin 
			for(p=0; p<4; p=p+1) begin
				int_matrix[p+row_count*4] <= matrix_I[63-p*8, 56-p*8];
			end
			wgt_matrix[q] <= RDATA_W[63-q*8, 56-q*8];
			
			if(q<3) q <= q+1;
			else if(q >= 3) q <= 0;
		end
	end

	always @(posedge CLK or RSTN) begin
		if(~RSTN) begin
		end else if(N > 4)begin
			if(count ==2) begin
				input_matrix[0] <= input_take[4];
				wgt_matrix[0] <= wgt_take[4];
			end else if(count ==3) begin
				input_matrix[1] <= input_take[5];
				input_matrix[4] <= input_take[12];
				wgt_matrix[1] <= wgt_take[5];
			end else if(count ==4) begin
				input_matrix[2] <= input_take[6];
				input_matrix[5] <= input_take[13];
				input_matrix[8] <= input_take[20];
				wgt_matrix[2] <= wgt_take[6];
			end else if(count == 5) begin
				input_matrix[3] <= input_take[7];
				input_matrix[6] <= input_take[14];
				input_matrix[9] <= input_take[21];
				input_matrix[12] <= input_take[28];
				wgt_matrix[3] <= wgt_take[7];
			end else if(count == 5) begin
				input_matrix[7] <= input_take[15];
				input_matrix[10] <= input_take[22];
				input_matrix[13] <= input_take[29];
			end else if(count == 6) begin
				input_matrix[11] <= input_take[23];
				input_matrix[14] <= input_take[30];
			end else if(count == 7) begin
				input_matrix[15] <= input_take[31];
			end 
		end
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
	reg [2:0] P0_count, P4_count, P8_count, P12_count;
	reg [15:0] out1, out2, out3, out4;
	reg [63:0] out_connect;

	always @ (posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			EN_O <= 1;
		end else begin
			if (result0 >= 1)
				P0_count <= P0_count + 1;
			else if (P0_count == 7) begin
				P0_count <= 0;
				out1 <= result3; // result0,4,8,12의 값을 초기화하는 기작이 필요할 거 같음
							//미세한 조정이 불가능하다면 속도는 4번째 줄 연산에 의해서 정해진다
			end else if (result4 >= 1)
				P4_count <= P4_count + 1;
			else if (P4_count == 7) begin
				P4_count <= 0;
				out2 <= result7;
			end else if (result8 >= 1)
				P8_count <= P8_count + 1;
			else if (P8_count == 7) begin
				P8_count <= 0;
				out3 <= result11;
			end else if (result12 >= 1)
				P12_count <= P12_count + 1;
			else if (P12_count == 7) begin
				P12_count <= 0;		
				out4 <= result15;
				out_connect <= {out1, out2, out3, out4};
				EN_O <= 0;
			end
		end
	end
    // WRITE YOUR MAC_ARRAY DATAPATH CODE
	block P0 (wgt_matrix[0], inp_matrix[0], 0, CLK, RSTN, outp_south0, result0);
	//from north
	block P1 (wgt_matrix[1], inp_matrix[1], result0, CLK, RSTN, outp_south1, result1);
	block P2 (wgt_matrix[2], inp_matrix[2], result1, CLK, RSTN, outp_south2, result2);
	block P3 (wgt_matrix[3], inp_matrix[3], result2, CLK, RSTN, outp_south3, result3);
	
	//from west
	block P4 (outp_south0, inp_matrix[4], 0, CLK, RSTN, outp_south4, result4);
	block P8 (outp_south4, inp_matrix[8], 0, CLK, RSTN, outp_south8, result8);
	block P12 (outp_south8, inp_matrix[12], 0, CLK, RSTN, outp_south12, result12);
	//second row
	block P5 (outp_south1, inp_matrix[5], result4, CLK, RSTN, outp_south5, result5);
	block P6 (outp_south2, inp_matrix[6], result5, CLK, RSTN, outp_south6, result6);
	block P7 (outp_south3, inp_matrix[7], result6, CLK, RSTN, outp_south7, result7);
	//third row
	block P9 (outp_south5, inp_matrix[9], result8, CLK, RSTN, outp_south9, result9);
	block P10 (outp_south6, inp_matrix[10], result9, CLK, RSTN, outp_south10, result10);
	block P11 (outp_south7, inp_matrix[11], result10, CLK, RSTN, outp_south11, result11);
	//fourth row
	block P13 (outp_south9, inp_matrix[13], result12, CLK, RSTN, outp_south13, result13);
	block P14 (outp_south10, inp_matrix[14], result13, CLK, RSTN, outp_south14, result14);
	block P15 (outp_south11, inp_matrix[15], result14, CLK, RSTN, outp_south15, result15);
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			done <= 0;
			count <= 0;
		end
		else begin
			if(count == 8) begin
				done <= 1;
				count <= 0;
			end
			else begin
				done <= 0;
				count <= count + 1;
			end
		end	
	end 

endmodule




module block(inp_north, inp_matrix, inp_west, clk, rst, outp_south, result);
	input [7:0] inp_north, inp_west, inp_matrix;
	output reg [7:0] outp_south;
	input clk, rst;
	output reg [15:0] result;
	wire [15:0] multi;
	
	always @(posedge rst or posedge clk) begin
		if(~rst) begin
			result <= 0;
			outp_south <= 0;
		end
		else begin
			outp_south <= inp_north;  //weight
			result <= inp_west + multi;
		end
	end
	
	assign multi = inp_north*input_matrix;

endmodule
