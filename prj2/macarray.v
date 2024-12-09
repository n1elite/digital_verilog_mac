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
	reg [3:0] inp_matrix [15:0]
	wire [3:0] wgt_take [31:0];
	wire [3:0] inp_take [31:0];
	reg [3:0] m_count, n_count, t_count;
	reg [3:0] done, count;
	wire [3:0] m_value, n_value, t_value;
	reg [2:0] current_Iaddr, current_Waddr;
	reg [2:0] cycle;

	assign m_value = MNT[11:8];
	assign n_value = MNT[7:4];
	assign t_value = MNT[3:0];

	always@(posedge CLK or negedge RSTN) begin
		if(~RSTN) beign
			ADDR_I <= 0;
			ADDR_W <= 0;
			t_count <= 0;
			m_count <= 0;
		end
		else begin
			if(t_count < t_value-1) begin
				ADDR_I <= ADDR_I + 1;
				t_count <= t_count + 1; // 다른 조건 필요함
			end else if(m_count < m_value && t_count == t_value-1) begin
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
			assign inp_take[i + t_count*4] = RDATA_I[31-i*8 : 24-i*8];
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
				int_matrix[p+row_count*4] <= RDATA_I[63-p*8, 56-p*8];
			end
			wgt_matrix[q] <= RDATA_W[63-q*8, 56-q*8];
			
			if(q<3) q <= q+1;
			else if(q >= 3) q <= 0;
		end
	end

	always @(posedge CLK or RSTN) begin
		if(~RSTN) begin
		end else begin
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
				wgt_matrix[3] <= wgt_take[7]
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


	
	

	
    // WRITE YOUR CONTROL SYSTEM CODE
		
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
			if(count == 9) begin
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
