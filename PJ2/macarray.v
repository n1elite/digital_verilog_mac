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


    // WRITE YOUR CONTROL SYSTEM CODE

    //Variable Declaration

    wire [3:0] N, M, T;

    wire [3:0] cal_case;

    wire [2:0] N_first, N_second, N_choice;


    reg [7:0] a11, a12, a13, a14;
    reg [7:0] a21, a22, a23, a24;
    reg [7:0] a31, a32, a33, a34;
    reg [7:0] a41, a42, a43, a44;


    reg [7:0]                   wb44;
    reg [7:0]             wb33, wb34;
    reg [7:0]       wb22, wb23, wb24;
    reg [7:0] wb11, wb12, wb13, wb14;


    reg  EN11, EN12, EN13, EN14;
    reg  EN21, EN22, EN23, EN24;
    reg  EN31, EN32, EN33, EN34;
    reg  EN41, EN42, EN43, EN44;



    reg [2:0] read_input_line;

    reg [1:0] set_input_line;


    reg N_flag;
    reg T_flag;
    reg W_flag;
    reg [2:0] cal_count;

    reg stop_flag;

    reg EN_row1, EN_row2, EN_row3, EN_row4;  //1되면 못읽도록 하기

    reg control_start;
    reg EN_I_read;

    //Variable Initialize

    assign M = MNT[11:8];
    assign N = MNT[7:4];
    assign T = MNT[3:0];

    assign N_first  =   (N < 5) ?   N   :   4;
    assign N_second =   (N < 5) ?   0   :   N-4;
    assign N_choice =   (N_flag == 0)   ?   N_first :   N_second;   //안쓸수도?


    assign cal_case =   (N < 5) ? ((T < 5) ? ((M < 5) ? 0 : 1) : ((M < 5) ? 2 : 3)) : ((T < 5) ? ((M < 5) ? 4 : 5) : ((M < 5) ? 6 : 7));
                                             
    assign ADDR_I   =   read_input_line;
    assign EN_I     =   START & ((read_input_line != 0) ? EN_I_read : 1);






    always @(posedge CLK or negedge RSTN) begin
        if(~RSTN) begin
            a11 <= 0;
            a12 <= 0;
            a13 <= 0;
            a14 <= 0;
            a21 <= 0;
            a22 <= 0;
            a23 <= 0;
            a24 <= 0;
            a31 <= 0;
            a32 <= 0;
            a33 <= 0;
            a34 <= 0;
            a41 <= 0;
            a42 <= 0;
            a43 <= 0;
            a44 <= 0;

            EN11 <= 0;
            EN12 <= 0;
            EN13 <= 0;
            EN14 <= 0;
            EN21 <= 0;
            EN22 <= 0;
            EN23 <= 0;
            EN24 <= 0;
            EN31 <= 0;
            EN32 <= 0;
            EN33 <= 0;
            EN34 <= 0;
            EN41 <= 0;
            EN42 <= 0;
            EN43 <= 0;
            EN44 <= 0;
            
            read_input_line <= 0;

            set_input_line <= 0;

            N_flag <= 0;
            T_flag <= 0;
            W_flag <= 0;
            cal_count <= 0;

            stop_flag <= 0;

            control_start <= 0;

            EN_I_read <= 1;
            EN_row1 <= 0;
            EN_row2 <= 0;
            EN_row3 <= 0;
            EN_row4 <= 0;
        end
    end


    always @(posedge CLK or negedge RSTN) begin
        if(START == 1) begin
            control_start <= 1;
        end
    end

        always @(posedge CLK or negedge RSTN) begin
        if(START == 1) begin
            if(stop_flag == 1) begin
                EN_I_read <=0;
            end else begin
                EN_I_read <=1;
            end
            case (cal_case)
                0: begin 
                    if(stop_flag == 0) begin
                        read_input_line <=  read_input_line + 1;
                        if (read_input_line + 1 == T) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end
                end
                1: begin
                    if(stop_flag == 0) begin
                        read_input_line <=  read_input_line + 1;
                        if (read_input_line + 1 == T) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end
                end
                2: begin
                    if(stop_flag == 0) begin
                        read_input_line <=  read_input_line + 1;
                        if (read_input_line + 1 == T) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end
                end
                3: begin
                    cal_count <= cal_count + 1;
                    if(stop_flag == 0) begin
                        read_input_line <=  read_input_line + 1;
                        if (read_input_line + 1 == T) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end
                    if (cal_count == 7 && T_flag == 0) begin
                        read_input_line <= 0;
                        T_flag <= 1;
                        stop_flag <= 0;
                        EN_I_read <= 1;
                    end else begin
                    end
                end
                4: begin
                    if(cal_count == 7 && N_flag == 1) begin
                    end else begin
                        cal_count <= cal_count + 1;
                    end
                    if(stop_flag == 0) begin
                        read_input_line <=  read_input_line + 1;
                        if (read_input_line + 1 == T  && cal_count !=3) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end
                    if (cal_count == 3)begin
                        read_input_line <= 0;
                        stop_flag <= 0;
                        EN_I_read <= 1;
                    end else if (cal_count == 4) begin
                        N_flag <= 1;
                    end
                end
                5: begin
                    if(cal_count == 7 && N_flag == 1 && W_flag == 1) begin
                    end else begin
                        cal_count <= cal_count + 1;
                    end
                    if(stop_flag == 0) begin
                        read_input_line <=  read_input_line + 1;
                        if(read_input_line + 1 == T && (cal_count !=3 || cal_count !=7)) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end
                    if(W_flag == 0) begin
                        if (cal_count == 3)begin
                            read_input_line <= 0;
                            stop_flag <= 0;
                            EN_I_read <= 1;
                        end else if (cal_count == 4) begin
                            N_flag <= 1;
                        end else if (cal_count == 7) begin
                            read_input_line <= 0;
                            stop_flag <= 0;
                            EN_I_read <= 1;
                            W_flag <= 1;
                        end
                    end else begin
                        if (cal_count == 0)begin
                            N_flag <= 0;
                        end else if (cal_count == 3) begin
                            read_input_line <= 0;
                            stop_flag <= 0;
                            EN_I_read <= 1;
                        end else if (cal_count == 4) begin
                            N_flag <= 1;
                        end
                    end
                end
                6: begin
                    if(cal_count == 7 && N_flag == 1 && T_flag == 1) begin
                    end else begin
                        cal_count <= cal_count + 1;
                    end
                    if(stop_flag == 0) begin
                        read_input_line <= read_input_line + 1;
                        if(read_input_line + 1 == T && (cal_count !=3 || cal_count !=7)) begin
                            stop_flag <= 1;
                        end else begin
                        end
                    end


                    if(T_flag == 0) begin
                        if(cal_count == 3) begin
                            read_input_line <= 0;
                        end else if (cal_count == 4) begin
                            N_flag <= 1;
                        end else if (cal_count == 7) begin
                            read_input_line <= 4;
                            T_flag <= 1;
                        end
                    end else begin
                        if (cal_count == 0)begin
                            N_flag <= 0;
                        end else if (cal_count == 3) begin
                            read_input_line <= 4;
                            
                        end else if (cal_count == 4) begin
                            N_flag <= 1;
                            stop_flag <= 0;
                            EN_I_read <= 1;
                        end
                    end

                end
                7: begin
                end
            endcase
        end
    end





//나중에 case문 지워도 됨

    always @(posedge CLK or negedge RSTN) begin
        if(control_start == 1) begin
            case (cal_case)
                0: begin 
                    set_input_line  <=  set_input_line  + 1;
                end
                1: begin
                    set_input_line  <=  set_input_line  + 1;
                end
                2: begin
                    set_input_line  <=  set_input_line  + 1;
                end
                3: begin
                    set_input_line  <=  set_input_line  + 1;
                end
                4: begin
                    set_input_line  <=  set_input_line  + 1;
                end
                5: begin
                    set_input_line  <=  set_input_line  + 1;
                end
                6: begin
                    set_input_line  <=  set_input_line  + 1;
                end
                7: begin
                    set_input_line  <=  set_input_line  + 1;
                end
            endcase
        end
    end


//들어가는 RDATA_I위치
    always @(posedge CLK or negedge RSTN) begin
        if(control_start == 1) begin
            if(N_flag == 0) begin
                case (N_first)
                    4: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a11, a12, a13, a14} <= RDATA_I[63:32];
                                    {EN11, EN12, EN13, EN14} <= 4'b0000;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a21, a22, a23, a24} <= RDATA_I[63:32];
                                    {EN21, EN22, EN23, EN24} <= 4'b0000;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end
                            end 
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a31, a32, a33, a34} <= RDATA_I[63:32];
                                    {EN31, EN32, EN33, EN34} <= 4'b0000;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end 
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a41, a42, a43, a44} <= RDATA_I[63:32];
                                    {EN41, EN42, EN43, EN44} <= 4'b0000;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                    3: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a12, a13, a14} <= RDATA_I[63:40];
                                    {EN11, EN12, EN13, EN14} <= 4'b1000;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a22, a23, a24} <= RDATA_I[63:40];
                                    {EN21, EN22, EN23, EN24} <= 4'b1000;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end
                            end 
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a32, a33, a34} <= RDATA_I[63:40];
                                    {EN31, EN32, EN33, EN34} <= 4'b1000;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a42, a43, a44} <= RDATA_I[63:40];
                                    {EN41, EN42, EN43, EN44} <= 4'b1000;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                    2: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a13, a14} <= RDATA_I[63:48];
                                    {EN11, EN12, EN13, EN14} <= 4'b1100;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a23, a24} <= RDATA_I[63:48];
                                    {EN21, EN22, EN23, EN24} <= 4'b1100;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end 
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a33, a34} <= RDATA_I[63:48];
                                    {EN31, EN32, EN33, EN34} <= 4'b1100;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a43, a44} <= RDATA_I[63:48];
                                    {EN41, EN42, EN43, EN44} <= 4'b1100;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                    1: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a14} <= RDATA_I[63:56];
                                    {EN11, EN12, EN13, EN14} <= 4'b1110;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a24} <= RDATA_I[63:56];
                                    {EN21, EN22, EN23, EN24} <= 4'b1110;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a34} <= RDATA_I[63:56];
                                    {EN31, EN32, EN33, EN34} <= 4'b1110;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a44} <= RDATA_I[63:56];
                                    {EN41, EN42, EN43, EN44} <= 4'b1110;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                endcase
            end else if (N_flag == 1) begin
                case (N_second)
                    4: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a11, a12, a13, a14} <= RDATA_I[31:0];
                                    {EN11, EN12, EN13, EN14} <= 4'b0000;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a21, a22, a23, a24} <= RDATA_I[31:0];
                                    {EN21, EN22, EN23, EN24} <= 4'b0000;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a31, a32, a33, a34} <= RDATA_I[31:0];
                                    {EN31, EN32, EN33, EN34} <= 4'b0000;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a41, a42, a43, a44} <= RDATA_I[31:0];
                                    {EN41, EN42, EN43, EN44} <= 4'b0000;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                    3: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a12, a13, a14} <= RDATA_I[31:8];
                                    {EN11, EN12, EN13, EN14} <= 4'b1000;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a22, a23, a24} <= RDATA_I[31:8];
                                    {EN21, EN22, EN23, EN24} <= 4'b1000;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end 
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a32, a33, a34} <= RDATA_I[31:8];
                                    {EN31, EN32, EN33, EN34} <= 4'b1000;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a42, a43, a44} <= RDATA_I[31:8];
                                    {EN41, EN42, EN43, EN44} <= 4'b1000;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                    2: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a13, a14} <= RDATA_I[31:16];
                                    {EN11, EN12, EN13, EN14} <= 4'b1100;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a23, a24} <= RDATA_I[31:16];
                                    {EN21, EN22, EN23, EN24} <= 4'b1100;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a33, a34} <= RDATA_I[31:16];
                                    {EN31, EN32, EN33, EN34} <= 4'b1100;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a43, a44} <= RDATA_I[31:16];
                                    {EN41, EN42, EN43, EN44} <= 4'b1100;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                    1: begin
                        case (set_input_line)
                            0   :   begin
                                if (EN_I_read == 1)begin
                                    {a14} <= RDATA_I[31:24];
                                    {EN11, EN12, EN13, EN14} <= 4'b1110;
                                    EN_row1 <= 0;
                                end else begin
                                    EN_row1 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a24} <= RDATA_I[31:24];
                                    {EN21, EN22, EN23, EN24} <= 4'b1110;
                                    EN_row2 <= 0;
                                end else begin
                                    EN_row2 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a34} <= RDATA_I[31:24];
                                    {EN31, EN32, EN33, EN34} <= 4'b1110;
                                    EN_row3 <= 0;
                                end else begin
                                    EN_row3 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a44} <= RDATA_I[31:24];
                                    {EN41, EN42, EN43, EN44} <= 4'b1110;
                                    EN_row4 <= 0;
                                end else begin
                                    EN_row4 <= 1;
                                end
                            end
                        endcase

                    end
                endcase
            end
        end
    end









	
	
    // // WRITE YOUR MAC_ARRAY DATAPATH CODE


    // block P0 (wgt_matrix[0], inp_matrix[0], 0, CLK, RSTN, outp_south0, result0);
	// //from north
	// block P1 (wgt_matrix[1], inp_matrix[1], result0, CLK, RSTN, outp_south1, result1);
	// block P2 (wgt_matrix[2], inp_matrix[2], result1, CLK, RSTN, outp_south2, result2);
	// block P3 (wgt_matrix[3], inp_matrix[3], result2, CLK, RSTN, outp_south3, result3);
	
	// //from west
	// block P4 (outp_south0, inp_matrix[4], 0, CLK, RSTN, outp_south4, result4);
	// block P8 (outp_south4, inp_matrix[8], 0, CLK, RSTN, outp_south8, result8);
	// block P12 (outp_south8, inp_matrix[12], 0, CLK, RSTN, outp_south12, result12);
	// //second row
	// block P5 (outp_south1, inp_matrix[5], result4, CLK, RSTN, outp_south5, result5);
	// block P6 (outp_south2, inp_matrix[6], result5, CLK, RSTN, outp_south6, result6);
	// block P7 (outp_south3, inp_matrix[7], result6, CLK, RSTN, outp_south7, result7);
	// //third row
	// block P9 (outp_south5, inp_matrix[9], result8, CLK, RSTN, outp_south9, result9);
	// block P10 (outp_south6, inp_matrix[10], result9, CLK, RSTN, outp_south10, result10);
	// block P11 (outp_south7, inp_matrix[11], result10, CLK, RSTN, outp_south11, result11);
	// //fourth row
	// block P13 (outp_south9, inp_matrix[13], result12, CLK, RSTN, outp_south13, result13);
	// block P14 (outp_south10, inp_matrix[14], result13, CLK, RSTN, outp_south14, result14);
	// block P15 (outp_south11, inp_matrix[15], result14, CLK, RSTN, outp_south15, result15);


    



endmodule


// //input에 EN 신호 두개 넣어서 col x => x    // col o && row x => x  // col && row o => o
// module block(inp_north, inp_matrix, inp_west, clk, rst, outp_south, result);
// 	input [7:0] inp_north, inp_west, inp_matrix;
// 	output reg [7:0] outp_south;
// 	input clk, rst;
// 	output reg [15:0] result;
// 	wire [15:0] multi;
	
// 	always @(posedge rst or posedge clk) begin
// 		if(~rst) begin
// 			result <= 0;
// 			outp_south <= 0;
// 		end
// 		else begin
// 			outp_south <= inp_north;  //weight
// 			result <= inp_west + multi;
// 		end
// 	end
	
// 	assign multi = inp_north*input_matrix;

// endmodule