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
    wire  [63:0] matrix_I;
    wire  [63:0] matrix_W;

    reg [7:0] a11, a12, a13, a14;
    reg [7:0] a21, a22, a23, a24;
    reg [7:0] a31, a32, a33, a34;
    reg [7:0] a41, a42, a43, a44;

    reg [7:0] b11, b12, b13, b14;
    reg [7:0] b21, b22, b23, b24;
    reg [7:0] b31, b32, b33, b34;
    reg [7:0] b41, b42, b43, b44;


    reg [7:0] wb51 wb52 wb53 wb54;
    reg [7:0] wb41 wb42 wb43 wb44;
    reg [7:0] wb31 wb32 wb33 wb34;
    reg [7:0] wb21 wb22 wb23 wb24;
    reg [7:0] wb11 wb12 wb13 wb14;




    reg [3:0] readcount_I_flag;
    reg [3:0] readcount_W_flag;

    reg weight_delay;
    reg error_flag;


    //Variable Initialize

    assign N = [11:8]   NMT;
    assign M = [7:4]    NMT;
    assign T = [3:0]    MNT;

/*
    always @(posedge CLK or negedge RSTN) begin
        if(START == 1) begin
            if (readcount_I_flag < T) begin
                readcount_I_flag <= readcount_I_flag + 1;
            end
            // if (readcount_W_flag < M) begin
            //     readcount_W_flag <= readcount_I_flag + 1;
            // end
        end
    end
*/
//    assign ADDR_I = readcount_I_flag;



/*
    always @(posedge CLK or negedge RSTN) begin
        if(START == 1) begin
            if (readcount_W_flag < M) begin
                if(weight_delay == 0) begin
                    readcount_W_flag <= readcount_W_flag + 1;
                end else begin
                end
            end
        end
    end

    assign EN_W     = (readcount_W_flag < M)    ?   ((weight_delay==0)   ?   1   :   0   ):   0;
    assign ADDR_W   = readcount_W_flag;
*/




    // 생각해보니깐 W는 N에 다라서 변경할 필요가 없음
    // 그리고 I는 N이 4미만일 때 변경할 필요가 없을 듯
    assign matrix_I =   (N == 0)    ?   {64'b0}                     :
                        (N == 1)    ?   {RDATA_I[63:56] , 56'b0}    :
                        (N == 2)    ?   {RDATA_I[63:48] , 48'b0}    :
                        (N == 3)    ?   {RDATA_I[63:40] , 40'b0}    :
                        (N == 4)    ?   {RDATA_I[63:32] , 32'b0}    :
                        (N == 5)    ?   {RDATA_I[63:24] , 24'b0}    :
                        (N == 6)    ?   {RDATA_I[63:16] , 16'b0}    :
                        (N == 7)    ?   {RDATA_I[63:8] , 8'b0}      :
                        (N == 8)    ?   {RDATA_I[63:0]}             :   {64'b0};

    assign matrix_W =   (N == 0)    ?   {64'b0}                     :
                        (N == 1)    ?   {RDATA_W[63:56] , 56'b0}    :
                        (N == 2)    ?   {RDATA_W[63:48] , 48'b0}    :
                        (N == 3)    ?   {RDATA_W[63:40] , 40'b0}    :
                        (N == 4)    ?   {RDATA_W[63:32] , 32'b0}    :
                        (N == 5)    ?   {RDATA_W[63:24] , 24'b0}    :
                        (N == 6)    ?   {RDATA_W[63:16] , 16'b0}    :
                        (N == 7)    ?   {RDATA_W[63:8] , 8'b0}      :
                        (N == 8)    ?   {RDATA_W[63:0]}             :   {64'b0};


    always @(posedge CLK or negedge RSTN) begin
        if(START == 1) begin

            if(N < 5) begin

                if(T < 5) begin
                    case (readcount_I_flag)
                        0: begin
                            {a11, a12, a13, a14} <= matrix_I[63:32];
                        end
                        1: begin
                            {a21, a22, a23, a24} <= matrix_I[63:32];
                        end
                        2: begin
                            {a31, a32, a33, a34} <= matrix_I[63:32];
                        end
                        3: begin
                            {a41, a42, a43, a44} <= matrix_I[63:32];
                        end
                        default: begin
                        // 필요한 경우 추가 작업
                        end
                    endcase

                end else if (T >= 5) begin
                    if(M >= 5) begin
                        case (readcount_I_flag)
                            0 , 4: begin
                                {a11, a12, a13, a14} <= matrix_I[63:32];
                            end
                            1 , 5: begin
                                {a21, a22, a23, a24} <= matrix_I[63:32];
                            end
                            2 , 6: begin
                                {a31, a32, a33, a34} <= matrix_I[63:32];
                            end
                            3 , 7: begin
                                {a41, a42, a43, a44} <= matrix_I[63:32];
                            end
                            default: begin
                            // 필요한 경우 추가 작업
                            end
                        endcase 
                    end else begin

                    end

                end



            end else if (N >= 5) begin
                if(T < 5) begin


                end else if (T >= 5) begin


                end
            end
        end
    end


/*
                    case (readcount_I_flag)
                        0: begin
                            {a11, a12, a13, a14} <= matrix_I[63:32];
                            {b11, b12, b13, b14} <= matrix_I[31:0];
                        end
                        1: begin
                            {a21, a22, a23, a24} <= matrix_I[63:32];
                            {b21, b22, b23, b24} <= matrix_I[31:0];
                        end
                        2: begin
                            {a31, a32, a33, a34} <= matrix_I[63:32];
                            {b31, b32, b33, b34} <= matrix_I[31:0];
                        end
                        3: begin
                            {a41, a42, a43, a44} <= matrix_I[63:32];
                            {b41, b42, b43, b44} <= matrix_I[31:0];
                        end
                        default: begin
                        // 필요한 경우 추가 작업
                        end
                    endcase  
*/
/*  
    always @(posedge CLK or negedge RSTN) begin
        if(START == 1) begin
            if(readcount_I_flag == 0) begin
                a11 <= matrix_I[63:56];
                a12 <= matrix_I[55:48];
                a13 <= matrix_I[47:40];
                a14 <= matrix_I[39:32];
                b11 <= matrix_I[31:24];
                b12 <= matrix_I[23:16];
                b13 <= matrix_I[15:8];
                b14 <= matrix_I[7:0];
            end else if (readcount_I_flag == 1) begin
                a21 <= matrix_I[63:56];
                a22 <= matrix_I[55:48];
                a23 <= matrix_I[47:40];
                a24 <= matrix_I[39:32];
                b21 <= matrix_I[31:24];
                b22 <= matrix_I[23:16];
                b23 <= matrix_I[15:8];
                b24 <= matrix_I[7:0];
            end else if (readcount_I_flag == 2) begin
                a31 <= matrix_I[63:56];
                a32 <= matrix_I[55:48];
                a33 <= matrix_I[47:40];
                a34 <= matrix_I[39:32];
                b31 <= matrix_I[31:24];
                b32 <= matrix_I[23:16];
                b33 <= matrix_I[15:8];
                b34 <= matrix_I[7:0];
            end else if (readcount_I_flag == 3) begin
                a41 <= matrix_I[63:56];
                a42 <= matrix_I[55:48];
                a43 <= matrix_I[47:40];
                a44 <= matrix_I[39:32];
                b41 <= matrix_I[31:24];
                b42 <= matrix_I[23:16];
                b43 <= matrix_I[15:8];
                b44 <= matrix_I[7:0];
            end else if (readcount_I_flag == 4) begin

            end else if (readcount_I_flag == 5) begin

            end else if (readcount_I_flag == 6) begin

            end else if (readcount_I_flag == 7) begin

            end
        end
    end
*/




	
    // WRITE YOUR MAC_ARRAY DATAPATH CODE

    //Variable Declaration



    wire i11, i12, i13, i14;
    wire i21, i22, i23, i24;
    wire i31, i32, i33, i34;
    wire i41, i42, i43, i44;

    wire w11, w12, w13, w14;
    wire w21, w22, w23, w24;
    wire w31, w32, w33, w34;
    wire w41, w42, w43, w44;




    reg offset1, offset2, offset3, offset4;
    reg cal_flag, cal_count;

    //Variable Initialize



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

            readcount_I_flag <= 0;

            weight_delay <= 0;
            readcount_W_flag <= 0;

            cal_flag <=0;
        end
        else begin
            if(cal_flag == 0)begin
                a11 <= i11 * w11;
                a12 <= a11 + (i12 * w12);
                a13 <= a12 + (i13 * w13);
                a14 <= a13 + (i14 * w14);
                a21 <= i21 * w21;
                a22 <= a21 + (i22 * w22);
                a23 <= a22 + (i23 * w23);
                a24 <= a23 + (i24 * w24);
                a31 <= i31 * w31;
                a32 <= a31 + (i32 * w32);
                a33 <= a32 + (i33 * w33);
                a34 <= a33 + (i34 * w34);
                a41 <= i41 * w41;
                a42 <= a41 + (i42 * w42);
                a43 <= a42 + (i43 * w43);
                a44 <= a43 + (i44 * w44);

                offset1 <= a14;
                offset2 <= a24;
                offset3 <= a34;
                offset4 <= a44;

                cal_count <= cal_count + 1;
                if (cal_count == 7) begin
                    cal_flag <= 1;
                    cal_count <= 0;
                end
            end else if (cal_flag == 1)begin
                a11 <= offset1 + (i11 * w11);
                a12 <= a11 + (i12 * w12);
                a13 <= a12 + (i13 * w13);
                a14 <= a13 + (i14 * w14);
                a21 <= offset2 + (i21 * w21);
                a22 <= a21 + (i22 * w22);
                a23 <= a22 + (i23 * w23);
                a24 <= a23 + (i24 * w24);
                a31 <= offset3 + (i31 * w31);
                a32 <= a31 + (i32 * w32);
                a33 <= a32 + (i33 * w33);
                a34 <= a33 + (i34 * w34);
                a41 <= offset4 + (i41 * w41);
                a42 <= a41 + (i42 * w42);
                a43 <= a42 + (i43 * w43);
                a44 <= a43 + (i44 * w44);

                cal_count <= cal_count + 1;
                if (cal_count == 7) begin
                    cal_flag <= 0;
                    cal_count <= 0;
                end
            end
        end
    end

    always @(posedge CLK or negedge RSTN) begin
        if(cal_flag == 0)begin



        end else if (cal_flag == 1)begin

        end
    end




endmodule
