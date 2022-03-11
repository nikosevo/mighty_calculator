module keyboard_tv;

    reg serial_stream;
    reg reset;
    reg clk , keyb_clk;
    wire [7:0] out;
    wire [5:0] ss;    


    //keyboard interface
    keyboard_reader kb(out,clk,reset,keyb_clk,serial_stream);

    //calculator
    calc c(out,reset);
    


    initial begin
      
        clk = 1'b0;
        keyb_clk = 1'b0;
        reset = 1'b1;
        #1 reset = 1'b0;
        //0 01101100 1 1

        send_stream(11'b0_11001110_11); //73 -> 5
        #10
        send_stream(11'b0_00111110_11); //7c -> +
        //send_stream(11'b0_00100001_11); //84 -> -
        //send_stream(11'b0_00100101_11); //84 -> smt random for testing error
        #10
        send_stream(11'b0_11010110_11); //6b -> 4
        #10
        send_stream(11'b0_10011110_11); //79 -> enter
    end

    always 
        #1 clk = ~clk;
    
    always  
        #20 keyb_clk = ~keyb_clk;
    
    //task that sends the bit stream  to the host 
    task send_stream;
        input [10:0] hex ;
        reg [10:0] f0;
        integer i;
        begin
            f0 = 11'b0_00001111_11;
            //this is the key pressed 
            for(i = 10 ; i >=0 ; i= i - 1) begin
                #40 serial_stream = hex[i];
            end
            #5
            //this is for f0
            for(i = 10 ; i >=0 ; i= i - 1) begin
                #40 serial_stream = f0[i];
            end
            #5
            //this is the key being released
            for(i = 10 ; i >=0 ; i= i - 1) begin
                #40 serial_stream = hex[i];
            end
            
        end
    endtask

endmodule