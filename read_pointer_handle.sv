module read_pointer_handle #(
    parameter ADDR_SIZE=4
) (
    output reg rempty,
    output [ADDR_SIZE-1:0] raddr,
    output reg [ADDR_SIZE:0] r_ptr,
    input [ADDR_SIZE:0] r_wptr,// sending it to read clock now
    input rclk,rinc,rrst_n
);  
    reg [ADDR_SIZE:0] curr_rbin;
    wire [ADDR_SIZE:0]rbin_next,rgray_next;
    wire empty;
always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
        curr_rbin<=0;
        r_ptr<=0;
        rempty<=1;
    end
    else begin
        curr_rbin<=rbin_next;
        r_ptr<=rgray_next;
        rempty<=empty;
    end
end

    assign rbin_next=curr_rbin+(rinc & ~rempty);
    assign rgray_next=(rbin_next>>1)^rbin_next;
    assign raddr=curr_rbin[ADDR_SIZE-1:0];
    assign empty = (rgray_next==r_wptr);


    
endmodule