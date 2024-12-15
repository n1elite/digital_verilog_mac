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

    reg [3:0] timing;

    reg control_start;
    reg EN_I_read;
    reg EN_W_read;

    reg [3:0] control_count;
    reg toggle;
    //Variable Initialize

    assign M = MNT[11:8];
    assign N = MNT[7:4];
    assign T = MNT[3:0];

    assign N_first  =   (N < 5) ?   N   :   4;
    assign N_second =   (N < 5) ?   0   :   N-4;
    assign N_choice =   (N_flag == 0)   ?   N_first :   N_second;


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
	    control_count <= 0;
	    toggle <= 0;

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


            timing <= 0;

        end
    end

    always @(posedge CLK or negedge RSTN) begin
        if(cal_fin) begin
            if(timing != N_choice +4) begin
                timing <= timing +1;
            end
        end
	
        if (timing < N_choice)begin
            if(EN_I_read == 1) begin
                EN_row12 <= 0;
                EN_row22 <= 0;
                EN_row32 <= 0;
                EN_row42 <= 0;

                EN_row13 <= 0;
                EN_row23 <= 0;
                EN_row33 <= 0;
                EN_row43 <= 0;

                EN_row14 <= 0;
                EN_row24 <= 0;
                EN_row34 <= 0;
                EN_row44 <= 0;
            
            end else if (EN_I_read == 0) begin
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
	
        end else if (timing == N_choice ) begin
            EN_row14 <= 1;
        end else if (timing == N_choice + 1) begin
            EN_row24 <= 1;
        end else if (timing == N_choice + 2) begin
            EN_row34 <= 1;
        end else if (timing == N_choice + 3) begin
            EN_row44 <= 1;
        end 
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
		control_count <= control_count + 1;
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
                                    EN_row12 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a22, a23, a24} <= RDATA_I[63:40];
                                    {EN21, EN22, EN23, EN24} <= 4'b1000;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row22 <= 1;
                                end
                            end 
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a32, a33, a34} <= RDATA_I[63:40];
                                    {EN31, EN32, EN33, EN34} <= 4'b1000;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row32 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a42, a43, a44} <= RDATA_I[63:40];
                                    {EN41, EN42, EN43, EN44} <= 4'b1000;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row42 <= 1;
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
                                    EN_row13 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a23, a24} <= RDATA_I[63:48];
                                    {EN21, EN22, EN23, EN24} <= 4'b1100;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row23 <= 1;
                                end 
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a33, a34} <= RDATA_I[63:48];
                                    {EN31, EN32, EN33, EN34} <= 4'b1100;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row33 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a43, a44} <= RDATA_I[63:48];
                                    {EN41, EN42, EN43, EN44} <= 4'b1100;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row43 <= 1;
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
                                    EN_row14 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a24} <= RDATA_I[63:56];
                                    {EN21, EN22, EN23, EN24} <= 4'b1110;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row24 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a34} <= RDATA_I[63:56];
                                    {EN31, EN32, EN33, EN34} <= 4'b1110;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row34 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a44} <= RDATA_I[63:56];
                                    {EN41, EN42, EN43, EN44} <= 4'b1110;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row44 <= 1;
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
                                    EN_row12 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a22, a23, a24} <= RDATA_I[31:8];
                                    {EN21, EN22, EN23, EN24} <= 4'b1000;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row22 <= 1;
                                end 
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a32, a33, a34} <= RDATA_I[31:8];
                                    {EN31, EN32, EN33, EN34} <= 4'b1000;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row32 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a42, a43, a44} <= RDATA_I[31:8];
                                    {EN41, EN42, EN43, EN44} <= 4'b1000;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row42 <= 1;
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
                                    EN_row13 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a23, a24} <= RDATA_I[31:16];
                                    {EN21, EN22, EN23, EN24} <= 4'b1100;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row23 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a33, a34} <= RDATA_I[31:16];
                                    {EN31, EN32, EN33, EN34} <= 4'b1100;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row33 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a43, a44} <= RDATA_I[31:16];
                                    {EN41, EN42, EN43, EN44} <= 4'b1100;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row43 <= 1;
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
                                    EN_row14 <= 1;
                                end
                            end
                            1   :   begin
                                if (EN_I_read == 1)begin
                                    {a24} <= RDATA_I[31:24];
                                    {EN21, EN22, EN23, EN24} <= 4'b1110;
                                    EN_row24 <= 0;
                                end else begin
                                    EN_row24 <= 1;
                                end
                            end
                            2   :   begin
                                if (EN_I_read == 1)begin
                                    {a34} <= RDATA_I[31:24];
                                    {EN31, EN32, EN33, EN34} <= 4'b1110;
                                    EN_row34 <= 0;
                                end else begin
                                    EN_row34 <= 1;
                                end
                            end
                            3   :   begin
                                if (EN_I_read == 1)begin
                                    {a44} <= RDATA_I[31:24];
                                    {EN41, EN42, EN43, EN44} <= 4'b1110;
                                    EN_row44 <= 0;
                                end else begin
                                    EN_row44 <= 1;
                                end
                            end
                        endcase

                    end
                endcase
            end
        end
    end


   




	wire [7:0] outp_south0, outp_south1, outp_south2, outp_south3, outp_south4, outp_south5, outp_south6, outp_south7 ;
	wire [7:0] outp_south8, outp_south9, outp_south10, outp_south11, outp_south12, outp_south13, outp_south14, outp_south15;
	wire [15:0] result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15;
	wire OWEN11, OWEN12, OWEN13, OWEN14, OWEN21, OWEN22, OWEN23, OWEN24 , OWEN31, OWEN32, OWEN33, OWEN34, OWEN41, OWEN42, OWEN43, OWEN44; 
	
    // // WRITE YOUR MAC_ARRAY DATAPATH CODE

  block P0 (wb11, a11, 0, CLK, RSTN, outp_south0, result0, EN_row14, EN11, WEN11, OWEN11);
    //from north
    block P1 (wb12, a12, result0, CLK, RSTN, outp_south1, result1, EN_row14, EN12, WEN12, OWEN12);
    block P2 (wb13, a13, result1, CLK, RSTN, outp_south2, result2, EN_row14, EN13, WEN13, OWEN13);
    block P3 (wb14, a14, result2, CLK, RSTN, outp_south3, result3, EN_row14, EN14, WEN14, OWEN14);
    
    //from west
    block P4 (outp_south0, a21, 0, CLK, RSTN, outp_south4, result4, EN_row24, EN21, OWEN11, OWEN21);
    block P8 (outp_south4, a31, 0, CLK, RSTN, outp_south8, result8, EN_row34, EN31, OWEN21, OWEN31);
    block P12 (outp_south8, a41, 0, CLK, RSTN, outp_south12, result12, EN_row44, EN41, OWEN31, OWEN41);
    //second row
    block P5 (outp_south1, a22, result4, CLK, RSTN, outp_south5, result5, EN_row24, EN22, OWEN12, OWEN22);
    block P6 (outp_south2, a23, result5, CLK, RSTN, outp_south6, result6, EN_row24, EN23, OWEN13, OWEN23);
    block P7 (outp_south3, a24, result6, CLK, RSTN, outp_south7, result7, EN_row24, EN24, OWEN14, OWEN24);
    //third row
    block P9 (outp_south5, a32, result8, CLK, RSTN, outp_south9, result9, EN_row34, EN32, OWEN22, OWEN32);
    block P10 (outp_south6, a33, result9, CLK, RSTN, outp_south10, result10, EN_row34, EN33, OWEN23, OWEN33);
    block P11 (outp_south7, a34, result10, CLK, RSTN, outp_south11, result11, EN_row34, EN34, OWEN24, OWEN34);
    //fourth row
    block P13 (outp_south9, a42, result12, CLK, RSTN, outp_south13, result13, EN_row44, EN42, OWEN32, OWEN42);
    block P14 (outp_south10, a43, result13, CLK, RSTN, outp_south14, result14, EN_row44, EN43, OWEN33, OWEN43);
    block P15 (outp_south11, a44, result14, CLK, RSTN, outp_south15, result15, EN_row44, EN44, OWEN34, OWEN44);


endmodule


module block(inp_north, inp_matrix, inp_west, clk, rst, outp_south, result, EN_row, EN_self, WEN, OWEN);
   input [7:0] inp_north, inp_west, inp_matrix;
   output reg [7:0] outp_south;
   input clk, rst;
   output reg [15:0] result;
   wire [15:0] multi;
    input EN_row, EN_self, WEN;
    output reg OWEN;
   
   always @(posedge rst or posedge clk) begin
      if(~rst) begin
         result <= 0;
         outp_south <= 0;
            OWEN <= 0;
      end else begin
         outp_south <= inp_north;  //weight
            OWEN <= WEN;
            if (EN_row == 0 && EN_self == 0 && WEN == 0) begin
             result <= inp_west + multi;
            end else begin
                result <= 0;
            end
      end
   end
   
   assign multi = inp_north*inp_matrix;

endmodule
