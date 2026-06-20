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
       // $monitor(" rdata -> %d,wfull -> %d,rempty->%d",rdata,dut.wfull,dut.rempty);
        
        #1000;
        
        $finish;
    end
    localparam DATA_WIDTH = 8,ADDR_SIZE=2;
    reg [DATA_WIDTH-1:0] expected_queue[$];
    wire [DATA_WIDTH-1:0] rdata;
    wire wfull;
    wire rempty;
    integer counter;
    reg [DATA_WIDTH-1:0] wdata;
    reg rclk,rinc,rrst_n;
    reg wclk,winc,wrst_n;
    fifo #(ADDR_SIZE,DATA_WIDTH) dut(.*);
    always #5 wclk=~wclk;
    always #10 rclk=~rclk;
    task write_data (input [DATA_WIDTH-1:0] data);
        begin
            reg [ADDR_SIZE:0] ptr;
            reg write_happened;
            @(negedge wclk);
            wdata = data;
            winc=1;
            if(!wfull) begin
                expected_queue.push_back(wdata);
            end
            ptr =dut.write_handler.wbin_next;
            write_happened = !wfull;
            
            @(negedge wclk);
            if (write_happened) begin
                if(dut.memory.mem[ptr[ADDR_SIZE-1:0]] === wdata)begin
                $display("WRITE PASSED ");
                end
                else begin
                    $display("WRITE FAILED ");
                // $display("mem[%0d] - > %0d",ptr[ADDR_SIZE-1:0],dut.memory.mem[ptr[ADDR_SIZE-1:0]]);
                end
            end
            else begin
                $display("WRITE BLOCKED");
            end
            wdata =0;
            winc=0;
        end
    endtask

    task read_data();
    begin
        reg [DATA_WIDTH-1:0] temp_data;
        reg read_happened;
        temp_data = 0;
        if(expected_queue.size()!=0)begin
            temp_data=expected_queue[0];
        end
       @(negedge rclk);
        rinc =1;
        if(!rempty)begin
            expected_queue.pop_front();
        end
        read_happened = !rempty;
        
       @(posedge rclk);
        if(read_happened) begin
            if (rdata !== temp_data) begin
                $display("READ FAILED");
            end
            else begin
                $display("READ PASSED");
            end
        end
        else begin
            $display("READ BLOCKED");
        end
        rinc =0; 
    end
    endtask

    task asserter(input [DATA_WIDTH-1:0] data1);
        begin
        if(expected_queue[0]== data1) begin
            $display("TEST %d PASSED",counter);
        end
        else begin
            $display("TEST %d FAILED",counter);
        end
        counter = counter +1;
        end
    endtask

    initial begin
        wdata=0;
        rclk=0;
        rinc=0;
        counter =1;
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
        // write_data(8'd1);
        // write_data(8'd2);
        // write_data(8'd3);
        // write_data(8'd4);
        // write_data(8'd5);
        // asserter(8'd1);
        // read_data();
        // asserter(8'd2);
        // read_data();
        // asserter(8'd3);
        // read_data();
        // asserter(8'd4);
        // read_data();
        // read_data();
        // read_data();
        // read_data();
    repeat(1000) begin
        if($urandom_range(0,1)) begin
            write_data($urandom);
        end
        else begin
            read_data();
        end
    end

    end

endmodule
