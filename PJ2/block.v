module block(inp_north, inp_matrix, inp_west, clk, rst, outp_south, result, EN_row, EN_self, WEN, OWEN);
   input wire [7:0] inp_north, inp_west, inp_matrix;
   output reg [7:0] outp_south;
   input clk, rst;
   output reg [15:0] result;
   wire [15:0] multi;
    input EN_row, EN_self, WEN;
    output reg OWEN;
   
   always @(negedge rst or posedge clk) begin
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