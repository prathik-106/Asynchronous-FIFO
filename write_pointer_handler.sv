module write_pointer_handler#(parameter ADDR_SIZE=4)(
    output  reg wfull, // if the fifo is full or not
    output wire [ADDR_SIZE-1:0] waddr,
    output reg [ADDR_SIZE:0]wptr,//the extra bit is to know if the pointer has wrapped around or not // this is a gray pointer
    input [ADDR_SIZE:0] w_rptr,// readpointer synchronised to write clock its in gray code
    input winc,wclk,wrst_n
);
    reg [ADDR_SIZE:0] wbin;
    wire [ADDR_SIZE:0] wbin_next,wgray_next;
    wire full;
    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            wbin<=0;
            wptr<=0;
        end
        else begin
            wbin<=wbin_next;
            wptr<=wgray_next;
        end
    end
    assign waddr=wbin[ADDR_SIZE-1:0];
    assign wbin_next=wbin+(winc & ~wfull);
    assign wgray_next=(wbin_next>>1)^wbin_next;
    // the full part
    // gotta compare the gray pointers
    assign full = (wgray_next=={~w_rptr[ADDR_SIZE:ADDR_SIZE-1],w_rptr[ADDR_SIZE-2:0]});

    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            wfull<=0;
        end
        else begin
            wfull<=full;
        end
    end
endmodule