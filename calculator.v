module calc(hex,reset);
    input [7:0] hex;
    input reset; 
    wire [5:0] binary;
    reg operation; //1 stands for '+' and 0 stands for '0'
    reg error; //0 stands for "everything alright" 1 stands for "NOT everything alright "
    reg [5:0] operand_1 , operand_2 , out;
    
    //those are the regs for the seven segments
    //1 is the most left and 6 the most right
    reg [6:0] ss_1,ss_2,ss_3,ss_4,ss_5,ss_6;

    //states for the big state machine
    parameter [2:0] W_OP_1 = 3'b000 ;
    parameter [2:0] W_OP = 3'b001;
    parameter [2:0] W_OP_2 = 3'b010;
    parameter [2:0] W_EN = 3'b100;

    //states for the small machine
    parameter W_F0 = 1'b0;
    parameter A_F0 = 1'b1;

    reg [2:0] state;
    reg f0_state;

    //decoder for converting hex to binary
    stb_dec dec1(binary,hex);

    //decoders for converting binary to sevensegment display
    seven_seg ss1(ss_1,operand_1);
    seven_seg ss2(ss_2,operand_2);
    seven_seg ss3(ss_3,out);

    always @(hex or reset) begin
        if(reset) begin
            state <= W_OP_1;
            f0_state <= W_F0;
        end

        else
            case(state)
                W_OP_1: 
                    if(f0_state == W_F0)begin
                        if(hex == 8'hf0) f0_state <= A_F0;
                    end
                    else if(f0_state == A_F0)begin
                        //display the input to the first seven segment
                        #5 operand_1 <= binary;


                        state <= W_OP;
                        f0_state = W_F0;
                    end
                W_OP:
                    if(f0_state == W_F0)begin
                        if(hex == 8'hf0) f0_state <= A_F0;
                    end
                    else if(f0_state == A_F0)begin
                        //display to seven segment the + or - symbol
                        if(hex==8'h7c)begin
                            operation <= 1'b1;
                            ss_2 <= 7'b0111_001;
                            
                            //move to the next state
                            state <= W_OP_2;
                            f0_state = W_F0;
                        end
                        else if(hex==8'h84) begin
                            operation <= 1'b0;
                            ss_2 <= 7'b0111_111;

                            //move to the next state
                            state <= W_OP_2;
                            f0_state = W_F0;
                        end

                        else begin
                            ss_2 <= 7'b0000_110;
                            error = 1'b1;
                            //we dont move to the next state since the user types somethign else 
                        end 

                    end
                W_OP_2:
                    if(f0_state == W_F0)begin
                        if(hex == 8'hf0) f0_state <= A_F0;
                    end
                    else if(f0_state == A_F0)begin
                        //display to seven segment the second input
                        #5 operand_2 <= binary;
                        
                        state <= W_EN;
                        f0_state = W_F0;
                    end
                W_EN:
                    if(f0_state == W_F0)begin
                        if(hex == 8'hf0) f0_state <= A_F0;
                    end
                    else if(f0_state == A_F0)begin
                        if(hex==8'h79) begin
                            ss_4 <= 7'b0110_111;

                            //move to the next state
                            state <= W_OP_1;
                            f0_state = W_F0;
                        end
                        else begin
                            ss_2 <= 7'b0000_110;
                            error = 1'b1;
                        end 


                        //display to seven segment the calculation
                        if(operation == 1) out <= operand_1 + operand_2;
                        else if(operation == 0) out <= operand_1 - operand_2;

                        if(out<0) begin
                            ss_5 <= 0111_111;
                        end
                        else if (out>9)begin
                            ss_5 <= 1111_001;
                        end
                        else begin
                            ss_5 <= 1111_111;
                        end
                    end
            endcase         
    end
endmodule