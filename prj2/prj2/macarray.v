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
	//Internal registers and wires
	
reg [3:0] m_count,n_count,t_count; //m,n,t current location 
reg [3:0] row,col;
reg [15:0] result_matrix [15:0] //4x4 result storage
reg  [3:0] state;	//FSM state
wire [3:0] m_value,n_value,t_value;

// MNT
assign m_value= MNT[11:8]
assign n_value= MNT[7:4]
assign t_value= MNT[3:0]

//memory control signal

assign EN_I= (state==1);
assign EN_W= (state==1);
assign EN_O= (state==3);
assign RW_O= 1'b1

//Memory address generation
assign ADDR_I=t_count[2:0];reg [3:0] m_count,n_count,t_count; //m,n,t current location 
reg [3:0] row,col;
reg [15:0] result_matrix [15:0] //4x4 result storage
reg  [3:0] state;	//FSM state
wire [3:0] m_value,n_value,t_value;

// MNT
assign m_value= MNT[11:8]
assign n_value= MNT[7:4]
assign t_value= MNT[3:0]

//memory control signal

assign EN_I= (state==1);
assign EN_W= (state==1);
assign EN_O= (state==3);
assign RW_O= 1'b1

// Initial Reset Logic
    always @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            state <= 0;
            t_count <= 0;
            m_count <= 0;
            row <= 0;
            col <= 0;
            EN_I <= 0;
            EN_W <= 0;
            EN_O <= 0;
            ADDR_I <= 0;
            ADDR_W <= 0;
            ADDR_O <= 0;
            RW_O <= 1'b1;  // Output read/write signal, default to 1
        end else begin
            case (state)
                2'b00: begin  // Idle State
                    if (START) begin
                        state <= 2'b01;
                        EN_I <= 1;
                        EN_W <= 1;
                    end
                end

                2'b01: begin  // Load Inputs
                    if (t_count < t_value - 1) begin
                        t_count <= t_count + 1;
                        ADDR_I <= t_count;
                    end else if (m_count < m_value - 1) begin
                        m_count <= m_count + 1;
                        ADDR_W <= m_count;
                    end else begin
                        state <= 2'b10;
                        EN_I <= 0;
                        EN_W <= 0;
                    end
                end
 // Load Input Data 
                    case (t_count)
                        4'd0: begin
                            inp_matrix0 <= RDATA_I[7:0];
                            inp_matrix1 <= RDATA_I[15:8];
                            inp_matrix2 <= RDATA_I[23:16];
                            inp_matrix3 <= RDATA_I[31:24];
                        end
                        4'd1: begin
                            inp_matrix0 <= RDATA_I[63:56];
                            inp_matrix1 <= RDATA_I[55:48];
                            inp_matrix2 <= RDATA_I[47:40];
                            inp_matrix3 <= RDATA_I[39:32];
                        end
                    endcase
                end else if (m_count < m_value - 1) begin
                    m_count <= m_count + 1;
                    ADDR_W <= m_count;
                // Load Weight Data
        case (m_count)
            4'd0: begin
                wgt_matrix0 <= RDATA_W[7:0];
                wgt_matrix1 <= RDATA_W[15:8];
                wgt_matrix2 <= RDATA_W[23:16];
                wgt_matrix3 <= RDATA_W[31:24];
            end
            4'd1: begin
                wgt_matrix0 <= RDATA_W[63:56];
                wgt_matrix1 <= RDATA_W[55:48];
                wgt_matrix2 <= RDATA_W[47:40];
                wgt_matrix3 <= RDATA_W[39:32];
            end
        endcase
		end else begin
                    state <= 2'b10;
                    EN_I <= 0;
                    EN_W <= 0;
                end
            end
                2'b10: begin  // Compute Matrix Multiplication
                    if (row < 4 && col < 4) begin
                        WDATA_O <= WDATA_O + RDATA_W[row * 4 + col] * RDATA_I[col];
                        col <= col + 1;
                        if (col == 3) begin
                            col <= 0;
                            row <= row + 1;
                        end
                    end else begin
                        state <= 2'b11;
                        EN_O <= 1;
                    end
                end

                2'b11: begin  // Output Results
                    ADDR_O <= row * 4 + col;
                    if (row == 3 && col == 3) begin
                        state <= 2'b00;  // Return to Idle
                        EN_O <= 0;
                    end
                end
            endcase
        end
    end

    // Generate Address and Enable Signals
    always @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            ADDR_I <= 0;
            ADDR_W <= 0;
        end else if (state == 2'b01) begin
            ADDR_I <= t_count[2:0];
            ADDR_W <= m_count[2:0];
        end else if (state == 2'b11) begin
            ADDR_O <= row * 4 + col;
        end
    end

endmodule

    // WRITE YOUR CONTROL SYSTEM CODE

	
	
    // WRITE YOUR MAC_ARRAY DATAPATH CODE
always @(posedge CLK or negedge RSTN)begin
	if(!RSTN)begin
	row<=0;
	col<=0;
	count <=0;
	result_matrix[0]<=0;
     end else begin
	row<= count/t_value;
	col<= count%4;

	case(n_value>=4,t_value>=4);
	
// Case classification for M, N, T values
always @(posedge CLK or negedge RSTN) begin
    if (!RSTN) begin
        row <= 0;
        col <= 0;
        count <= 0;
        result_matrix[0] <= 0;
    end else begin
        case ({M >= 5, N >= 5, T >= 5})
            3'b000: begin // M < 5, N < 5, T < 5
                if (row < 4 && col < 4) begin
                    result_matrix[row * 4 + col] <= 
                        (col > 0) ? result_matrix[row * 4 + col - 1] + 
                        wgt_matrix[col] * inp_matrix[row * 4 + col] : 
                        wgt_matrix[col] * inp_matrix[row * 4 + col];
                end
            end
            
            3'b001: begin // M < 5, N < 5, T >= 5
                if (row < 4 && col < 4) begin
                    result_matrix[row * 4 + col] <= 
                        (col > 0) ? result_matrix[row * 4 + col - 1] + 
                        wgt_matrix[col] * inp_matrix[row * 4 + col] : 
                        wgt_matrix[col] * inp_matrix[row * 4 + col];
                end
                if (T >= 5) begin
                    if (count >= 16 && count < 32) begin
                        result_matrix[count] <= 
                            result_matrix[count - 1] + 
                            wgt_matrix[count % 16] * inp_matrix[count];
                    end
                end
            end
            
            3'b010: begin // M < 5, N >= 5, T < 5
                if (row < 4 && col < 4) begin
                    if (col >= 4 - (N - 4)) begin
                        result_matrix[row * 4 + col] <= 
                            wgt_matrix[col] * inp_matrix[row * 4 + col];
                    end
                end
            end
            
            3'b011: begin // M < 5, N >= 5, T >= 5
                if (row < 4 && col < 4) begin
                    if (col >= 4 - (N - 4)) begin
                        result_matrix[row * 4 + col] <= 
                            wgt_matrix[col] * inp_matrix[row * 4 + col];
                    end
                end
                if (T >= 5) begin
                    if (count >= 16 && count < 32) begin
                        result_matrix[count] <= 
                            result_matrix[count - 1] + 
                            wgt_matrix[count % 16] * inp_matrix[count];
                    end
                end
            end
            
            3'b100: begin // M >= 5, N < 5, T < 5
                if (row < 4 && col < 4) begin
                    result_matrix[row * 4 + col] <= 
                        wgt_matrix[col] * inp_matrix[row * 4 + col];
                end
            end
            
            3'b101: begin // M >= 5, N < 5, T >= 5
                if (row < 4 && col < 4) begin
                    result_matrix[row * 4 + col] <= 
                        wgt_matrix[col] * inp_matrix[row * 4 + col];
                end
                if (T >= 5) begin
                    if (count >= 16 && count < 32) begin
                        result_matrix[count] <= 
                            result_matrix[count - 1] + 
                            wgt_matrix[count % 16] * inp_matrix[count];
                    end
                end
            end
            
            3'b110: begin // M >= 5, N >= 5, T < 5
                if (row < 4 && col < 4) begin
                    if (col >= 4 - (N - 4)) begin
                        result_matrix[row * 4 + col] <= 
                            wgt_matrix[col] * inp_matrix[row * 4 + col];
                    end
                end
            end
            
            3'b111: begin // M >= 5, N >= 5, T >= 5
                if (row < 4 && col < 4) begin
                    if (col >= 4 - (N - 4)) begin
                        result_matrix[row * 4 + col] <= 
                            wgt_matrix[col] * inp_matrix[row * 4 + col];
                    end
                end
                if (T >= 5) begin
                    if (count >= 16 && count < 32) begin
                        result_matrix[count] <= 
                            result_matrix[count - 1] + 
                            wgt_matrix[count % 16] * inp_matrix[count];
                    end
                end
            end
        endcase
    end
end

/*
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
	

