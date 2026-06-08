module synchroniser #(parameter SIZE = 4 )(
    input [SIZE-1:0] din,
    input clk,rst_n,
    output reg [SIZE-1:0] dout
);

    reg [SIZE-1:0] temp;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n) begin
            temp<=0;
            dout<=0;
        end
        else begin
            dout<=temp;
            temp<=din;
        end
    end

endmodule