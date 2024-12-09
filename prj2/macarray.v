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
module control_unit (
    input  wire        clk,             // System clock
    input  wire        rst,             // Reset signal
    input  wire        start,           // Start signal
    input  wire [11:0] MNT,             // Matrix dimensions (M, N, T)
    input  wire        busy_datapath,   // Indicates if Datapath is busy
    output reg         compute_signal,  // Signal to trigger computation
    output reg         reset_count,     // Signal to reset internal counters
    output reg         done,            // Overall computation done signal
    output reg  [3:0]  current_M,       // Number of rows (M)
    output reg  [3:0]  current_N,       // Number of columns (N)
    output reg  [3:0]  current_T        // Number of columns for result (T)
);

    // FSM States
    typedef enum logic [2:0] {
        IDLE = 3'b000,       // Idle state
        INIT = 3'b001,       // Initialize computation
        COMPUTE = 3'b010,    // Computing
        WAIT = 3'b011,       // Wait for busy signal to clear
        DONE = 3'b100        // Computation done
    } state_t;

    state_t current_state, next_state;

    // State Transition (Sequential Logic)
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // State Transition Logic (Combinational Logic)
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = INIT;
                else
                    next_state = IDLE;
            end
            INIT: begin
                next_state = COMPUTE;
            end
            COMPUTE: begin
                if (busy_datapath)  // If Datapath is busy, wait for it to complete
                    next_state = WAIT;
                else
                    next_state = COMPUTE;
            end
            WAIT: begin
                if (!busy_datapath) // When Datapath finishes, issue next compute signal
                    next_state = COMPUTE;
                else if (current_M == 0 && current_N == 0 && current_T == 0) // Check completion
                    next_state = DONE;
                else
                    next_state = WAIT;
            end
            DONE: begin
                next_state = IDLE; // Return to idle state
            end
            default: next_state = IDLE;
        endcase
    end

    // Output Logic
    always @(*) begin
        // Default values
        compute_signal = 0;
        reset_count = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                compute_signal = 0;
                reset_count = 1; // Reset Datapath counters
                done = 0;
            end
            INIT: begin
                compute_signal = 1; // Trigger first computation
                reset_count = 0;
                done = 0;
            end
            COMPUTE: begin
                compute_signal = 1; // Continuously send compute signals
                reset_count = 0;
                done = 0;
            end
            WAIT: begin
                compute_signal = 0; // Wait for Datapath to finish
                reset_count = 0;
                done = 0;
            end
            DONE: begin
                compute_signal = 0;
                reset_count = 0;
                done = 1; // Indicate overall completion
            end
        endcase
    end

    // Decode M, N, T from MNT input
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_M <= 0;
            current_N <= 0;
            current_T <= 0;
        end else if (start) begin
            current_M <= MNT[11:8]; // Number of rows
            current_N <= MNT[7:4];  // Shared dimension
            current_T <= MNT[3:0];  // Number of columns in the result
        end
    end

endmodule

	
	
    // WRITE YOUR MAC_ARRAY DATAPATH CODE



endmodule
