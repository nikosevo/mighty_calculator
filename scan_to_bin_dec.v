module stb_dec(out ,in);
    input [7:0] in ; 
    output reg [5:0] out;

    always @(*) begin
        case (in)
            8'h70: out <= 6'b000_000;
            8'h69: out <= 6'b000_001;
            8'h72: out <= 6'b000_010;
            8'h7A: out <= 6'b000_011;
            8'h6B: out <= 6'b000_100;
            8'h73: out <= 6'b000_101;
            8'h74: out <= 6'b000_110;
            8'h6C: out <= 6'b000_111;
            8'h75: out <= 6'b001_000;
            8'h7D: out <= 6'b001_001;
            8'hf0: out <= 6'b111_111;
            default: out <= 6'b110_000;
        endcase 
    end

endmodule