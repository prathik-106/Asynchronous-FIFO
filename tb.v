`timescale 1ns/1ns

module tb;
integer i;
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0,tb);
        $dumpvars(0,tb.dut.memory);
        for (i=0;i<4;i=i+1) begin
            $dumpvars(0,dut.memory.mem[i]);
        end
        $monitor(" rdata -> %d,wfull -> %d,rempty->%d",rdata,dut.wfull,dut.rempty);
        
        #300;
        
        $finish;
    end
    localparam DATA_WIDTH = 8,ADDR_SIZE=2;
    wire [DATA_WIDTH-1:0] rdata;
    wire wfull;
    wire rempty;
    reg [DATA_WIDTH-1:0] wdata;
    reg rclk,rinc,rrst_n;
    reg wclk,winc,wrst_n;
    fifo #(ADDR_SIZE,DATA_WIDTH) dut(.*);
    always #5 wclk=~wclk;
    always #10 rclk=~rclk;
    task write_data (input [DATA_WIDTH-1:0] data);
        begin
            
            @(negedge wclk);
            wdata = data;
            winc=1;
            @(negedge wclk);
            wdata =0;
            winc=0;
        end
        endtask
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
        @(negedge wclk);
        wrst_n =0;
        rrst_n=0;
        @(negedge wclk);
        wrst_n=1;
        rrst_n=1;
        write_data(8'd1);
        write_data(8'd2);
        write_data(8'd3);
        write_data(8'd4);
        winc=0;
        @(negedge rclk);
        rinc=1;
        @(posedge rempty);
        rinc=0;
        write_data(8'd5);
    end

endmodule
