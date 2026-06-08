`timescale 1ns/1ns

module tb;

    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0,tb);
        $monitor(" rdata -> %d",rdata);
    end
    localparam DATA_WIDTH = 8,ADDR_SIZE=4;
    wire [DATA_WIDTH-1:0] rdata;
    wire wfull;
    wire rempty;
    reg [DATA_WIDTH-1:0] wdata;
    reg rclk,rinc,rrst_n;
    reg wclk,winc,wrst_n;
    fifo #(ADDR_SIZE,DATA_WIDTH) dut(.*);
    always #5 wclk=~wclk;
    always #10 rclk=~rclk;
    initial begin
        wdata=0;
        rclk=0;
        rinc=0;
        rrst_n=0;
        wclk=0;
        winc=0;
        wrst_n=0;
        @(negedge rclk);
        @(negedge rclk);
        rrst_n=1;
        wrst_n=1;
        @(negedge wclk)
        wdata= 15;
        winc=1;
        @(negedge wclk)
 
        wdata=1;
        @(negedge wclk)
        wdata =3;

        @(negedge rclk)
        winc=0;
        rinc=1;
        wait(rempty == 0); // Wait for data to arrive
        repeat(5) @(posedge rclk);
        $finish;

    end

endmodule