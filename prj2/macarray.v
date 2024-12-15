/*****************************************
    
    Team 24 : 
        2019104024    Lee Junho
        2014104049     Jo Shanghyeon
        2021104315    Lim Sumin
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

    wire [2:0] N_first, N_second;


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
	
    reg WEN11, WEN12, WEN13, WEN14;
    reg WEN22, WEN23, WEN24;
    reg WEN33, WEN34;
    reg WEN44;

    reg [2:0] read_input_line;
    reg [2:0] read_weight_line;

    reg [1:0] set_input_line;


    reg N_flag, N_flag2;
    reg T_flag;
    reg M_flag, M_flag2;

    reg [2:0] cal_count, cal_count2;
    reg cal_fin, cal_fin2;

    reg stop_flag;

    reg EN_row11, EN_row21, EN_row31, EN_row41;  //1되면 못읽도록 하기
    reg EN_row12, EN_row22, EN_row32, EN_row42;
    reg EN_row13, EN_row23, EN_row33, EN_row43;
    reg EN_row14, EN_row24, EN_row34, EN_row44;

    reg control_start;
    reg EN_I_read;
    reg EN_W_read;

    //Variable Initialize

    assign M = MNT[11:8];
    assign N = MNT[7:4];
    assign T = MNT[3:0];

    assign N_first  =   (N < 5) ?   N   :   4;
    assign N_second =   (N < 5) ?   0   :   N-4;


    assign cal_case =   (N < 5) ? ((T < 5) ? ((M < 5) ? 0 : 1) : ((M < 5) ? 2 : 3)) : ((T < 5) ? ((M < 5) ? 4 : 5) : ((M < 5) ? 6 : 7));
                          
                       
    assign ADDR_I   =   read_input_line;
    assign ADDR_W   =   read_weight_line;
    assign EN_I     =   START & (cal_fin == 1)  ?  0  : (((read_input_line != 0)  ? EN_I_read : 1));
    assign EN_W     =   START & (cal_fin2 == 1) ?  0  : (((read_weight_line != 0) ? EN_W_read : 1));






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

	        wb44 <= 0;
    	    wb33 <= 0; wb34 <= 0;
    	    wb22 <= 0; wb23 <= 0; wb24 <= 0;
    	    wb11 <= 0; wb12 <= 0; wb13 <= 0; wb14 <= 0;

	        WEN11<=0; WEN12<=0; WEN13<=0; WEN14<=0;
    	    WEN22<=0; WEN23<=0; WEN24<=0;
    	    WEN33<=0; WEN34<=0;
    	    WEN44<=0;

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
	        read_weight_line <= 0;

            set_input_line <= 0;

            N_flag <= 0;
	        N_flag2 <= 0;
            T_flag <= 0;
            M_flag <= 0;
	        M_flag2 <= 0;

            cal_count <= 0;
	        cal_count2 <= 0;
            cal_fin <= 0;
            cal_fin2 <= 0;

            stop_flag <= 0;

            control_start <= 0;

            EN_I_read <= 1;
	        EN_W_read <= 1;
            EN_row11 <= 0;
            EN_row21 <= 0;
            EN_row31 <= 0;
            EN_row41 <= 0;

            EN_row12 <= 0; EN_row22 <= 0; EN_row32 <= 0; EN_row42 <= 0;
            EN_row13 <= 0; EN_row23 <= 0; EN_row33 <= 0; EN_row43 <= 0;
            EN_row14 <= 0; EN_row24 <= 0; EN_row34 <= 0; EN_row44 <= 0;




        end
    end

    always @(posedge CLK or negedge RSTN) begin
        EN_row12 <= EN_row11;
        EN_row22 <= EN_row21;
        EN_row32 <= EN_row31;
        EN_row42 <= EN_row41;

        EN_row13 <= EN_row12;
        EN_row23 <= EN_row22;
        EN_row33 <= EN_row32;
        EN_row43 <= EN_row42;

        EN_row14 <= EN_row13;
        EN_row24 <= EN_row23;
        EN_row34 <= EN_row33;
        EN_row44 <= EN_row43;
    end


   
    always @(posedge CLK or negedge RSTN) begin
    	if(START) begin
            WEN12 <= WEN22;
            WEN23 <= WEN33;
            WEN13 <= WEN23;
            WEN34 <= WEN44;
            WEN24 <= WEN34;
            WEN14 <= WEN24;
            if (cal_count2 - 1 == M && M<8) begin
                WEN11 <= 1; WEN22 <= 1; WEN33 <= 1; WEN44 <= 1; 
            end else begin
                WEN11 <= 0; WEN22 <= 0; WEN33 <= 0; WEN44 <= 0; 
            end
	    end	
    end

    always @(posedge CLK or negedge RSTN) begin
    	if(control_start) begin
            wb12 <= wb22;
            wb23 <= wb33;
            wb13 <= wb23;
            wb34 <= wb44;
            wb24 <= wb34;
            wb14 <= wb24;
            case(cal_case)
                0 : begin
                    if(N==4) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if (N==3) begin
                        {wb22, wb33, wb44} <= {RDATA_W[63:40]};
                    end else if (N==2) begin
                        {wb33, wb44} <= {RDATA_W[63:48]};
                    end else begin
                        {wb44} <= {RDATA_W[63:56]};
                    end
                end	
                1 : begin
                    if(N==4) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if (N==3) begin
                        {wb22, wb33, wb44} <= {RDATA_W[63:40]};
                    end else if (N==2) begin
                        {wb33, wb44} <= {RDATA_W[63:48]};
                    end else begin
                        {wb44} <= {RDATA_W[63:56]};
                    end
                end	
                2 : begin
                    if(N==4) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if (N==3) begin
                        {wb22, wb33, wb44} <= {RDATA_W[63:40]};
                    end else if (N==2) begin
                        {wb33, wb44} <= {RDATA_W[63:48]};
                    end else begin
                        {wb44} <= {RDATA_W[63:56]};
                    end
                end	
                3 : begin
                    if(N==4) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if (N==3) begin
                        {wb22, wb33, wb44} <= {RDATA_W[63:40]};
                    end else if (N==2) begin
                        {wb33, wb44} <= {RDATA_W[63:48]};
                    end else begin
                        {wb44} <= {RDATA_W[63:56]};
                    end
                end	
                4 : begin
                    if(N==8 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==8 && N_flag == 1) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[31:0]};
                    end else if (N==7 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==7 && N_flag == 1) begin
                        {wb22, wb33, wb44} <= {RDATA_W[31:8]};
                    end else if(N==6 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==6 && N_flag == 1) begin
                        {wb33, wb44} <= {RDATA_W[31:16]};
                    end else if(N==5 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==5 && N_flag == 1) begin
                        {wb44} <= {RDATA_W[31:24]};
                    end
                end	
                5 : begin
                    if(N==8 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==8 && N_flag == 1) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[31:0]};
                    end else if (N==7 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==7 && N_flag == 1) begin
                        {wb22, wb33, wb44} <= {RDATA_W[31:8]};
                    end else if(N==6 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==6 && N_flag == 1) begin
                        {wb33, wb44} <= {RDATA_W[31:16]};
                    end else if(N==5 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==5 && N_flag == 1) begin
                        {wb44} <= {RDATA_W[31:24]};
                    end
                end	
                6 : begin
                    if(N==8 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==8 && N_flag == 1) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[31:0]};
                    end else if (N==7 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==7 && N_flag == 1) begin
                        {wb22, wb33, wb44} <= {RDATA_W[31:8]};
                    end else if(N==6 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==6 && N_flag == 1) begin
                        {wb33, wb44} <= {RDATA_W[31:16]};
                    end else if(N==5 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==5 && N_flag == 1) begin
                        {wb44} <= {RDATA_W[31:24]};
                    end
                end	
                7 : begin
                    if(N==8 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==8 && N_flag == 1) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[31:0]};
                    end else if (N==7 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==7 && N_flag == 1) begin
                        {wb22, wb33, wb44} <= {RDATA_W[31:8]};
                    end else if(N==6 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==6 && N_flag == 1) begin
                        {wb33, wb44} <= {RDATA_W[31:16]};
                    end else if(N==5 & N_flag == 0) begin
                        {wb11, wb22, wb33, wb44} <= {RDATA_W[63:32]};
                    end else if(N==5 && N_flag == 1) begin
                        {wb44} <= {RDATA_W[31:24]};
                    end
                end
            endcase	
    	end
    end



    always @(posedge CLK or negedge RSTN) begin
    	if(START == 1) begin
            case(cal_case)
                0 : begin
                    if (cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <=  read_weight_line + 1;
                        if (cal_count + 1 == M) begin
                            cal_fin2 <= 1;
                        end
                    end
                end
                1 : begin
                    if (cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <=  read_weight_line + 1;
                        if (cal_count2 == 7) begin
                            cal_fin2 <= 1;
                        end
                    end
                end
                2 : begin
                    if (cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <=  read_weight_line + 1;
                        if (cal_count2 == 3 && M_flag == 0) begin
                            cal_count2 <= 0; read_weight_line <= 0; M_flag <= 1;
                        end else if(cal_count2 == 3 && M_flag == 1) begin
                            cal_fin2 <= 1;
                        end
                    end
                end
                3 : begin
                    if(cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <= read_weight_line + 1;
                        if(cal_count2 == 7 && M_flag == 0) begin
                            read_weight_line <= 0; M_flag <= 1; cal_count2 <= 0;
                        end else if(cal_count2 == 7 && M_flag == 1)
                            cal_fin2 <= 0;
                    end
                end
                4 : begin
                    if(cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <= read_weight_line + 1;
                        if(cal_count2 == 3 && N_flag2 == 0) begin
                            read_weight_line <= 0; N_flag2 <= 1; cal_count2 <= 0;
                        end else if(cal_count2 == 3 && N_flag2 == 1) begin
                            cal_fin2 <= 1;
                        end
                    end
                end
                5 : begin
                    if(cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <= read_weight_line + 1;
                        if (cal_count2 == 3 && N_flag2 == 0) begin
                            read_weight_line <= 0; N_flag2 <= 1; cal_count2 <= 0;
                        end else if (cal_count2 == 7 && N_flag2 == 1 && M_flag2 == 0) begin
                            read_weight_line <= 4; N_flag <= 1; cal_count2 <= 4; M_flag2 <= 1; 
                        end else if (cal_count2 == 7 && N_flag2 == 1 && M_flag2 == 1) begin
                            cal_fin2 <= 1;
                        end
                    end
                end
                6 : begin
                    if(cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <= read_weight_line + 1;
                        if(cal_count2 == 3 && N_flag2 == 0) begin
                            read_weight_line <= 0; cal_count2 <= 0; N_flag2 <= 1;
                        end else if (cal_count2 == 3 && N_flag2 == 1 && M_flag2 == 0) begin
                            read_weight_line <= 0; cal_count2 <= 0; N_flag2 <= 0; M_flag2 <= 1;
                        end else if (cal_count2 == 3 && N_flag2 == 1 && M_flag2 == 1)
                            cal_fin2 <= 1; 
                    end
                end
                7 : begin
                    if(cal_fin2 == 0) begin
                        cal_count2 <= cal_count2 + 1;
                        read_weight_line <= read_weight_line + 1;
                        if(cal_count2 == 3 && M_flag2 == 0) begin
                            read_weight_line <= 0; M_flag2 <= 1; cal_count2 <= 0;
                        end else if(cal_count2 == 3 && M_flag2 == 1 && N_flag2 == 0) begin
                            read_weight_line <= 0; M_flag2 <= 0; N_flag2 <= 1; cal_count2 <= 0;
                        end else if (cal_count2 ==3 && M_flag2 == 1 && N_flag2 == 1) begin
                            M_flag2 <= 0; N_flag2 <= 0;
                        end else if(cal_count2 == 7 && M_flag2 == 0) begin
                            read_weight_line <= 4; M_flag2 <= 1; cal_count2 <= 4; 
                        end else if(cal_count2 == 7 && M_flag2 == 1 && N_flag2 == 0) begin
                            read_weight_line <= 4; M_flag2 <= 0; N_flag2 <= 1; cal_count2 <= 4;
                        end else if (cal_count2 == 7 && M_flag2 ==1 && N_flag2 == 1)
                            cal_fin2 <= 1;
                    end
                end	
            endcase	
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
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (cal_count + 1 == T) begin
                            stop_flag <= 1;
                            cal_fin <= 1;
                        end
                        read_input_line <=  read_input_line + 1;
                    end
                end
                1: begin
                    if (cal_fin == 0) begin
                    cal_count <= cal_count + 1;
                    if (cal_count + 1 == T) begin
                        stop_flag <= 1;
                        cal_fin <= 1;
                    end
                    read_input_line <=  read_input_line + 1;
                    end
                end
                2: begin
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (cal_count + 1 == T) begin
                            stop_flag <= 1;
                            cal_fin <= 1;
                        end
                        read_input_line <=  read_input_line + 1;
                    end
                end
                3: begin
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (cal_count + 1 == T) begin
                            stop_flag <= 1;
                        end
                        if(T_flag == 0) begin
                            if(cal_count == 7) begin
                                stop_flag <= 0;
                                T_flag <= 1;
                            end
                        end else if (T_flag == 1) begin
                            if(cal_count == 7) begin
                                cal_fin <= 1;
                            end
                        end
                        read_input_line <=  read_input_line + 1;
                    end
                end
                4: begin
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (cal_count + 1 == T || cal_count + 1 == T + 4) begin
                            stop_flag <= 1;
                        end
                        if(N_flag == 0) begin
                            if(cal_count == 3) begin
                                stop_flag <= 0;
                                read_input_line <= 0;
                            end else if(cal_count == 4) begin
                                N_flag <= 1;
                                read_input_line <= read_input_line + 1;
                            end else begin
                                read_input_line <=  read_input_line + 1;
                            end
                        end else if (N_flag == 1) begin
                            if(cal_count == 4)begin
                                cal_fin <= 1;
                            end
                            read_input_line <= read_input_line + 1;
                        end
                    end
                end
                5: begin
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (cal_count + 1 == T || cal_count + 1 == T + 4) begin
                            stop_flag <= 1;
                        end
                        if(M_flag == 0) begin
                            if(N_flag == 0) begin
                                if(cal_count == 3) begin
                                    stop_flag <= 0;
                                    read_input_line <= 0;
                                end else if(cal_count == 4) begin
                                    N_flag <= 1;
                                    read_input_line <= read_input_line + 1;
                                end else begin
                                    read_input_line <=  read_input_line + 1;
                                end
                            end else if (N_flag == 1) begin
                                if(cal_count == 7)begin
                                    stop_flag <= 0;
                                    read_input_line <= 0;
                                    M_flag <= 1;
                                end else begin
                                    read_input_line <= read_input_line + 1;
                                end
                            end
                        end else if (M_flag == 1) begin
                            if(N_flag == 0) begin
                                if(cal_count == 3) begin
                                    stop_flag <= 0;
                                    read_input_line <= 0;
                                end else if(cal_count == 4) begin
                                    N_flag <= 1;
                                    read_input_line <= read_input_line + 1;
                                end else begin
                                    read_input_line <=  read_input_line + 1;
                                end
                            end else if (N_flag == 1) begin
                                if(cal_count == 0) begin
                                    N_flag <= 0;
                                end else if (cal_count == 7) begin
                                    cal_fin <= 1;
                                end
                                read_input_line <= read_input_line + 1;
                            end
                        end
                    end
                end
                6: begin
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (T_flag == 1) begin
                            if (cal_count + 1 == T || cal_count + 1 == T - 4) begin
                            stop_flag <= 1;
                            end
                        end
                        if(T_flag == 0) begin
                            if(N_flag == 0) begin
                                if(cal_count == 3) begin
                                    //stop_flag <= 0;
                                    read_input_line <= 0;
                                end else if(cal_count == 4) begin
                                    N_flag <= 1;
                                    read_input_line <= read_input_line + 1;
                                end else begin
                                    read_input_line <=  read_input_line + 1;
                                end
                            end else if (N_flag == 1) begin
                                if(cal_count == 7)begin
                                    //stop_flag <= 0;
                                    read_input_line <= 4;
                                    T_flag <= 1;
                                end else begin
                                    read_input_line <= read_input_line + 1;
                                end
                            end
                        end else if (T_flag == 1) begin
                            if(N_flag == 0) begin
                                if(cal_count == 3) begin
                                    stop_flag <= 0;
                                    read_input_line <= 4;
                                end else if(cal_count == 4) begin
                                    N_flag <= 1;
                                    read_input_line <= read_input_line + 1;
                                end  else begin
                                    read_input_line <=  read_input_line + 1;
                                end
                            end else if (N_flag == 1) begin
                                if(cal_count == 0)begin
                                    N_flag <= 0;
                                end else if (cal_count == 7) begin
                                    cal_fin <= 1;
                                end
                                read_input_line <= read_input_line + 1;
                            end
                        end
                    end
                end
                7: begin
                    if (cal_fin == 0) begin
                        cal_count <= cal_count + 1;
                        if (T_flag == 1) begin
                            if (cal_count + 1 == T || cal_count + 1 == T - 4) begin
                            stop_flag <= 1;
                            end
                        end
                        if (M_flag == 0) begin
                            if(T_flag == 0) begin
                                if(N_flag == 0) begin
                                    if(cal_count == 3) begin
                                        //stop_flag <= 0;
                                        read_input_line <= 0;
                                    end else if(cal_count == 4) begin
                                        N_flag <= 1;
                                        read_input_line <= read_input_line + 1;
                                    end else begin
                                        read_input_line <=  read_input_line + 1;
                                    end
                                end else if(N_flag == 1) begin
                                    if(cal_count == 7)begin
                                        //stop_flag <= 0;
                                        read_input_line <= 4;
                                        T_flag <= 1;
                                    end else begin
                                        read_input_line <= read_input_line + 1;
                                    end
                                end
                            end else if (T_flag == 1) begin
                                if(N_flag == 0) begin
                                    if(cal_count == 3) begin
                                        stop_flag <= 0;
                                        read_input_line <= 4;
                                    end else if(cal_count == 4) begin
                                        N_flag <= 1;
                                        read_input_line <= read_input_line + 1;
                                    end  else begin
                                        read_input_line <=  read_input_line + 1;
                                    end
                                end else if(N_flag == 1) begin
                                    if(cal_count == 0)begin
                                        N_flag <= 0;
                                        read_input_line <= read_input_line + 1;
                                    end else if(cal_count == 7)begin
                                        stop_flag <= 0;
                                        read_input_line <= 0;
                                        T_flag <= 0;
                                        M_flag <= 1;
                                    end else begin
                                        read_input_line <= read_input_line + 1;
                                    end
                                end
                            end
                        end else if (M_flag == 1) begin
                            if(T_flag == 0) begin
                                if(N_flag == 0) begin
                                    if(cal_count == 3) begin
                                        //stop_flag <= 0;
                                        read_input_line <= 0;
                                    end else if(cal_count == 4) begin
                                        N_flag <= 1;
                                        read_input_line <= read_input_line + 1;
                                    end  else begin
                                        read_input_line <=  read_input_line + 1;
                                    end
                                end else if(N_flag == 1) begin
                                    if(cal_count == 0)begin
                                        N_flag <= 0;
                                        read_input_line <= read_input_line + 1;
                                    end else if(cal_count == 7)begin
                                        //stop_flag <= 0;
                                        read_input_line <= 4;
                                        T_flag <= 1;
                                    end else begin
                                        read_input_line <= read_input_line + 1;
                                    end
                                end
                            end else if (T_flag == 1) begin
                                if(N_flag == 0) begin
                                    if(cal_count == 3) begin
                                        stop_flag <= 0;
                                        read_input_line <= 4;
                                    end else if(cal_count == 4) begin
                                        N_flag <= 1;
                                        read_input_line <= read_input_line + 1;
                                    end  else begin
                                        read_input_line <=  read_input_line + 1;
                                    end
                                end else if(N_flag == 1) begin
                                    if(cal_count == 0) begin
                                        N_flag <= 0;
                                    end else if (cal_count == 7) begin
                                        cal_fin <= 1;
                                    end
                                    read_input_line <= read_input_line + 1;
                                end
                            end
                        end
                    end
                end
            endcase
        end
    end




    always @(posedge CLK or negedge RSTN) begin
        if(control_start == 1) begin
            set_input_line  <=  set_input_line  + 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a21, a22, a23, a24} <= RDATA_I[63:32];
                                    {EN21, EN22, EN23, EN24} <= 4'b0000;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end
                            end 
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a31, a32, a33, a34} <= RDATA_I[63:32];
                                    {EN31, EN32, EN33, EN34} <= 4'b0000;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end 
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a41, a42, a43, a44} <= RDATA_I[63:32];
                                    {EN41, EN42, EN43, EN44} <= 4'b0000;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a22, a23, a24} <= RDATA_I[63:40];
                                    {EN21, EN22, EN23, EN24} <= 4'b1000;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end
                            end 
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a32, a33, a34} <= RDATA_I[63:40];
                                    {EN31, EN32, EN33, EN34} <= 4'b1000;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a42, a43, a44} <= RDATA_I[63:40];
                                    {EN41, EN42, EN43, EN44} <= 4'b1000;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a23, a24} <= RDATA_I[63:48];
                                    {EN21, EN22, EN23, EN24} <= 4'b1100;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end 
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a33, a34} <= RDATA_I[63:48];
                                    {EN31, EN32, EN33, EN34} <= 4'b1100;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a43, a44} <= RDATA_I[63:48];
                                    {EN41, EN42, EN43, EN44} <= 4'b1100;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a24} <= RDATA_I[63:56];
                                    {EN21, EN22, EN23, EN24} <= 4'b1110;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a34} <= RDATA_I[63:56];
                                    {EN31, EN32, EN33, EN34} <= 4'b1110;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a44} <= RDATA_I[63:56];
                                    {EN41, EN42, EN43, EN44} <= 4'b1110;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a21, a22, a23, a24} <= RDATA_I[31:0];
                                    {EN21, EN22, EN23, EN24} <= 4'b0000;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a31, a32, a33, a34} <= RDATA_I[31:0];
                                    {EN31, EN32, EN33, EN34} <= 4'b0000;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a41, a42, a43, a44} <= RDATA_I[31:0];
                                    {EN41, EN42, EN43, EN44} <= 4'b0000;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a22, a23, a24} <= RDATA_I[31:8];
                                    {EN21, EN22, EN23, EN24} <= 4'b1000;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end 
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a32, a33, a34} <= RDATA_I[31:8];
                                    {EN31, EN32, EN33, EN34} <= 4'b1000;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a42, a43, a44} <= RDATA_I[31:8];
                                    {EN41, EN42, EN43, EN44} <= 4'b1000;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a23, a24} <= RDATA_I[31:16];
                                    {EN21, EN22, EN23, EN24} <= 4'b1100;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a33, a34} <= RDATA_I[31:16];
                                    {EN31, EN32, EN33, EN34} <= 4'b1100;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a43, a44} <= RDATA_I[31:16];
                                    {EN41, EN42, EN43, EN44} <= 4'b1100;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
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
                                    EN_row14 <= 0;
                                end else begin
                                    EN_row11 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a24} <= RDATA_I[31:24];
                                    {EN21, EN22, EN23, EN24} <= 4'b1110;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row21 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a34} <= RDATA_I[31:24];
                                    {EN31, EN32, EN33, EN34} <= 4'b1110;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row31 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a44} <= RDATA_I[31:24];
                                    {EN41, EN42, EN43, EN44} <= 4'b1110;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row41 <= 1;
                                end
                            end
                        endcase

                    end
                endcase
            end
        end
    end






    // WRITE YOUR MAC_ARRAY DATAPATH CODE
	reg [15:0] result1, result2, result3, result4;
    reg [15:0] result5, result6, result7, result8;
    reg [15:0] result9, result10, result11, result12;
    reg [15:0] result13, result14, result15, result16;



	wire [15:0] multi1, multi2, multi3, multi4;
    wire [15:0] multi5, multi6, multi7, multi8;
    wire [15:0] multi9, multi10, multi11, multi12;
    wire [15:0] multi13, multi14, multi15, multi16;


    reg OWEN21, OWEN22, OWEN23, OWEN24;
    reg OWEN31, OWEN32, OWEN33, OWEN34;
    reg OWEN41, OWEN42, OWEN43, OWEN44;



    reg [7:0] w21, w22, w23, w24;
    reg [7:0] w31, w32, w33, w34;
    reg [7:0] w41, w42, w43, w44;



    assign multi1   =   a11 * wb11;
    assign multi2   =   a12 * wb12;
    assign multi3   =   a13 * wb13;
    assign multi4   =   a14 * wb14;
    assign multi5   =   a21 * w21;
    assign multi6   =   a22 * w22;
    assign multi7   =   a23 * w23;
    assign multi8   =   a24 * w24;
    assign multi9   =   a31 * w31;
    assign multi10  =   a32 * w32;
    assign multi11  =   a33 * w33;
    assign multi12  =   a34 * w34;
    assign multi13  =   a41 * w41;
    assign multi14  =   a42 * w42;
    assign multi15  =   a43 * w43;
    assign multi16  =   a44 * w44;

    always @(posedge CLK or negedge RSTN) begin
		if(~RSTN) begin
			result1 <= 0; result2 <= 0; result3 <= 0; result4 <= 0;
            result5 <= 0; result6 <= 0; result7 <= 0; result8 <= 0;
            result9 <= 0; result10 <= 0; result11 <= 0; result12 <= 0;
            result13 <= 0; result14 <= 0; result15 <= 0; result16 <= 0;

            OWEN21 <= 0; OWEN22 <= 0; OWEN23 <= 0; OWEN24 <= 0;
            OWEN31 <= 0; OWEN32 <= 0; OWEN33 <= 0; OWEN34 <= 0;
            OWEN41 <= 0; OWEN42 <= 0; OWEN43 <= 0; OWEN44 <= 0;


            w21 <= 0; w22 <= 0; w23 <= 0; w24 <= 0;
            w31 <= 0; w32 <= 0; w33 <= 0; w34 <= 0;
            w41 <= 0; w42 <= 0; w43 <= 0; w44 <= 0;
        end
    end







    always @(posedge CLK or negedge RSTN) begin
		if (control_start) begin
            w21 <= wb11;
            w22 <= wb12;
            w23 <= wb13;
            w24 <= wb14;
            w31 <= w21;
            w32 <= w22;
            w33 <= w23;
            w34 <= w24;
            w41 <= w31;
            w42 <= w32;
            w43 <= w33;
            w44 <= w34;


            OWEN21 <= WEN11;
            OWEN22 <= WEN12;
            OWEN23 <= WEN13;
            OWEN24 <= WEN14;
            OWEN31 <= OWEN21;
            OWEN32 <= OWEN22;
            OWEN33 <= OWEN23;
            OWEN34 <= OWEN24;
            OWEN41 <= OWEN31;
            OWEN42 <= OWEN32;
            OWEN43 <= OWEN33;
            OWEN44 <= OWEN34;

            


            if (EN_row14 == 0 && EN11 == 0 && WEN11 == 0) begin
			    result1  <=     0      + multi1;
            end else begin
                result1 <= 0;
            end
            if (EN_row14 == 0 && EN12 == 0 && WEN12 == 0) begin
			    result2  <=  result1   + multi2;
            end else begin
                result2 <= 0;
            end
            if (EN_row14 == 0 && EN13 == 0 && WEN13 == 0) begin
			    result3  <=  result2   + multi3;
            end else begin
                result3 <= 0;
            end
            if (EN_row14 == 0 && EN14 == 0 && WEN14 == 0) begin
			    result4  <=  result3   + multi4;
            end else begin
                result4 <= 0;
            end

            

            if (EN_row24 == 0 && EN21 == 0 && OWEN21 == 0) begin
			    result5  <=     0      + multi5;
            end else begin
                result5 <= 0;
            end
            if (EN_row24 == 0 && EN22 == 0 && OWEN22 == 0) begin
			    result6  <=  result5   + multi6;
            end else begin
                result6 <= 0;
            end
            if (EN_row24 == 0 && EN23 == 0 && OWEN23 == 0) begin
			    result7  <=  result6   + multi7;
            end else begin
                result7 <= 0;
            end
            if (EN_row24 == 0 && EN24 == 0 && OWEN24 == 0) begin
			    result8  <=  result7   + multi8;
            end else begin
                result8 <= 0;
            end




            if (EN_row34 == 0 && EN31 == 0 && OWEN31 == 0) begin
			    result9  <=     0      + multi9;
            end else begin
                result9 <= 0;
            end
            if (EN_row34 == 0 && EN32 == 0 && OWEN32 == 0) begin
			    result10 <=  result9   + multi10;
            end else begin
                result10 <= 0;
            end
            if (EN_row34 == 0 && EN33 == 0 && OWEN33 == 0) begin
			    result11 <=  result10  + multi11;
            end else begin
                result11 <= 0;
            end
            if (EN_row34 == 0 && EN34 == 0 && OWEN34 == 0) begin
			    result12 <=  result11  + multi12;
            end else begin
                result12 <= 0;
            end


            
            
            
            if (EN_row44 == 0 && EN41 == 0 && OWEN41 == 0) begin
			    result13 <=     0      + multi13;
            end else begin
                result13 <= 0;
            end
            if (EN_row44 == 0 && EN42 == 0 && OWEN42 == 0) begin
			    result14 <=  result13  + multi14;
            end else begin
                result14 <= 0;
            end
            if (EN_row44 == 0 && EN43 == 0 && OWEN43 == 0) begin
			    result15 <=  result14  + multi15;
            end else begin
                result15 <= 0;
            end
            if (EN_row44 == 0 && EN44 == 0 && OWEN44 == 0) begin
			    result16 <=  result15  + multi16;
            end else begin
                result16 <= 0;
            end
            
           
        end
    end


    reg [1:0] r_count1;
    reg [3:0] r_count2;
    reg r_flag;


    always @(posedge CLK or negedge RSTN) begin
        if(~RSTN) begin
            r_count1 <= 0;
            r_count2 <= 0;
            r_flag <= 0;

        end
    end

    always @(posedge CLK or negedge RSTN) begin
        if(control_start) begin
            case (cal_case)
                0: begin
                    r_count1 <= r_count1 + 1;
                    if(r_flag == 0)begin
                        if(r_count1 == 1)begin
                            r_flag <= 1;
                        end
                    end else if (r_flag == 1) begin
                        if(r_count1 == 1)begin

                        end
                    end

                end
                1: begin
                    r_count1 <= r_count1 + 1;
                end
                2: begin
                    r_count1 <= r_count1 + 1;
                end
                3: begin
                    r_count1 <= r_count1 + 1;
                end
                4: begin
                    r_count2 <= r_count2 + 1;
                end
                5: begin
                    r_count2 <= r_count2 + 1;
                end
                6: begin
                    r_count2 <= r_count2 + 1;
                end
                7: begin
                    r_count2 <= r_count2 + 1;
                end
            endcase
        end
    end



endmodule


