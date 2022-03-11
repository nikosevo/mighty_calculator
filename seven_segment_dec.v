module seven_seg(out , in);

    output reg [6:0] out;
    input [5:0] in;

    always @(*) begin
        case(in)
            //all the negatives will show up in the last segment the same as if it was positive
            //but the 5th display will show a minus sign
            -8'd9: out <= 7'b0010_000;
            -8'd8: out <= 7'b0000_000;
            -8'd7: out <= 7'b1111_000;
            -8'd6: out <= 7'b0000_010;
            -8'd5: out <= 7'b0010_010;
            -8'd4: out <= 7'b0011_001;
            -8'd3: out <= 7'b0110_000;
            -8'd2: out <= 7'b0100_100;
            -8'd1: out <= 7'b1111_001;

            8'd0: out <= 7'b1000_000; 
            8'd1: out <= 7'b1111_001;
            8'd2: out <= 7'b0100_100;
            8'd3: out <= 7'b0110_000;
            8'd4: out <= 7'b0011_001;
            8'd5: out <= 7'b0010_010;
            8'd6: out <= 7'b0000_010;
            8'd7: out <= 7'b1111_000;
            8'd8: out <= 7'b0000_000;
            8'd9: out <= 7'b0010_000;

            //same here the last display will display the right side of the nubmer
            //but the 5th will now display a '1'
            8'd10: out <= 7'b1000_000; 
            8'd11: out <= 7'b1111_001;
            8'd12: out <= 7'b0100_100;
            8'd13: out <= 7'b0110_000;
            8'd14: out <= 7'b0011_001;
            8'd15: out <= 7'b0010_010;
            8'd16: out <= 7'b0000_010;
            8'd17: out <= 7'b1111_000;
            8'd18: out <= 7'b0000_000;
            default: out <= 7'b1111111;
        endcase
        
    end
endmodule