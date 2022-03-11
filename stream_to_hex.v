module keyboard_reader(out,clk,reset,keyb_clk,keyb_data);

    output reg [7:0] out;
    input clk,reset,keyb_data;
    input keyb_clk;


    reg [5:0] sample; 
    reg [10:0] data ;


    

    // register for sampling
    always @(posedge clk or posedge reset) begin
        if(reset)
            sample <= 6'b000000;
        else begin
            sample <= {keyb_clk,sample[5:1]};
        end
    end

    //register for saving the data from the keyboard
    always @(posedge clk or posedge reset) begin
        if(reset) 
            data <= 11'b1111_1111_111;
        else if(!data[0]) begin
            out <= data[8:1];
            data <= 11'b1111_1111_111;
        end
        else if(sample == 6'b000111) 
            data <= {keyb_data,data[10:1]};

    end

endmodule