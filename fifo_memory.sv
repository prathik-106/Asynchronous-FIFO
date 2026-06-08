module fifo_memory #(
    parameter DATA_WIDTH=8,
    parameter ADDR_SIZE=4
) (
    output [DATA_WIDTH-1:0] rdata,
    input [DATA_WIDTH-1:0] wdata,
    input [ADDR_SIZE-1:0] waddr,raddr,
    input wclk_en,wfull,wclk
);
    parameter DEPTH= 1<< ADDR_SIZE;
    reg [DATA_WIDTH-1:0] mem[0:DEPTH-1];
    assign rdata= mem[raddr];
    always@(posedge wclk) begin
        if(wclk_en && !wfull) begin
            mem[waddr]<=wdata;
        end
    end
endmodule