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
assign ADDR_I=t_count[2:0];
assign ADDR_W=m_count[2:0];
assign ADDR_0=_row*4+col;
assign WDATA_O={result_matrix[row*4+col],16b'0,16b'0,16b'0}

always @(posedge CLK or negedge RSTN) begin
	if(!RSTN)begin
	state<=0;
	m_count<=0;
	t_count<=0;
	row <=0;
	col <=0;
	end else begin
	  case(state)
	0:begin //idle state
	  if(START)state <=1;
	end 
	1:begin //Load inputs
	if(t_count< t_value-1) begin
	t_count <= t_count+1;
	
	end else if(m_count<m_value-1) begin
	m_count <= m_count+1;
	
	end else begin
	state <=2;
	end 

end		

	2: begin //Compute( execute multiply)
	if(row <4 && col<4) begin
	result_matrix [row*4+col] <= wgt_matrix[row*4+col]*inp_matrix[col];
	

	3:begin //Output results
	  if(done==1) state <0;
	end
      endcase 
   end
end 

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
	
2'b00:begin //N<4,T<4    
	if(row<n_value &&col<4) begin
	result_matrix[row*4+col] <= result_matrix[row*4+col]+wgt_matrix[row*4+col]*inp_matrix[col];
	
2'b01// N<4,T>=4
	if (row < n_value && col < 4) begin
                    result_matrix[row * 4 + col] <= 
                        result_matrix[row * 4 + col] + 
                        wgt_matrix[row * 4 + col] * inp_matrix[col];
                end
            end
            2'b10: begin // N >= 4, T < 4
                if (row < 4 && col < t_value) begin
                    result_matrix[row * t_value + col] <= 
                        result_matrix[row * t_value + col] + 
                        wgt_matrix[row * t_value + col] * inp_matrix[col];
                end
            end
            2'b11: begin // N >= 4, T >= 4
                if (row < 4 && col < 4) begin
                    result_matrix[row * 4 + col] <= 
                        result_matrix[row * 4 + col] + 
                        wgt_matrix[row * 4 + col] * inp_matrix[col];
                end
            end
        endcase
	

endmodule
