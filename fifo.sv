module fifo #(
    parameter ADDR_SIZE= 4,
    parameter DATA_WIDTH = 8
    ) (
    output [DATA_WIDTH-1:0] rdata,
    output wfull,
    output rempty,
    input [DATA_WIDTH-1:0] wdata,
    input rclk,rinc,rrst_n,
    input wclk,winc,wrst_n
);
//w_r source to destination that is wclk to read clk
    wire [ADDR_SIZE-1:0] waddr, raddr;
    wire [ADDR_SIZE:0] wptr, rptr, w_rptr, r_wptr;
    synchroniser #(ADDR_SIZE+1) wptr_to_rclk(
    .din(wptr),
    .clk(rclk),
    .rst_n(rrst_n),
    .dout(w_rptr)   // write ptr in read domain
);

    
    synchroniser #(ADDR_SIZE+1) rptr_to_wclk(
    .din(rptr),
    .clk(wclk),
    .rst_n(wrst_n),
    .dout(r_wptr)   // read ptr in write domain
);


    write_pointer_handler #(ADDR_SIZE) write_handler(
        .wfull(wfull),
        .waddr(waddr),
        .wptr(wptr),
        .w_rptr(r_wptr),// as this is a write handler signal coming to write from read r_w
        .wclk(wclk),
        .winc(winc),
        .wrst_n(wrst_n)
    );

    read_pointer_handle #(ADDR_SIZE) read_handler(
        .rempty(rempty),
        .raddr(raddr),
        .r_ptr(rptr),
        .r_wptr(w_rptr),
        .rclk(rclk),
        .rinc(rinc),
        .rrst_n(rrst_n)
    );

    fifo_memory #(DATA_WIDTH , ADDR_SIZE) memory(
        .rdata(rdata),
        .wdata(wdata),
        .waddr(waddr),
        .raddr(raddr),
        .wclk_en(winc),
        .wclk(wclk),
        .wfull(wfull)
    );
endmodule