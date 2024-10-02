`timescale 1ns / 1ps

module alu(
    // DO NOT modify the interface!
    // input signal
    input [7:0] accum,
    input [7:0] data,
    input [2:0] opcode,
    input reset,
    
    // result
    output [7:0] alu_out,
    
    // PSW
    output zero,
    output overflow,
    output parity,
    output sign
    );

reg [7:0] result;
reg [8:0] temp;
reg [15:0] temp_mul;
reg zero;
reg parity;
reg sign;
reg [7:0] accum_extended, data_extended;
reg overflow_flag = 0;

function calcuParity(input [7:0] val);
    integer i;
    reg parity;
    begin
        parity = 0;
        for (i = 0; i < 8; i = i + 1)
            parity = parity ^ val[i];
        calcuParity = parity;
    end
endfunction
    
always@(*) begin
    if(reset) begin
        result = 8'b0;
        zero = 1'b0;
        parity = 1'b0;
        sign = 1'b0;
    end else begin
        overflow_flag = 1'b0;

        case (opcode)
            3'b000: result = accum;
            3'b001: begin
                temp = accum + data;
                result = temp[7:0];
                if ((accum[7] == data[7]) && (result[7] != accum[7]))
                    overflow_flag = 1'b1;
            end
            3'b010: begin
                temp = accum - data;
                result = temp[7:0];
                if ((accum[7] != data[7]) && (result[7] != accum[7]))
                    overflow_flag = 1'b1;
            end
            3'b011: result = accum >>> data[2:0];
            3'b100: result = accum ^ data;
            3'b101: result = (accum[7] == 1) ? -accum : accum;
            3'b110: begin
                accum_extended = { {4{accum[3]}}, accum[3:0] };
                data_extended = { {4{data[3]}}, data[3:0] };
                
                temp_mul = accum_extended * data_extended;
                result = temp_mul[7:0];
                
                overflow_flag = 1'b0;
            end
            3'b111: result = -accum;
            default: result = 8'b0;
        endcase
            
            if (overflow_flag) begin
            if (opcode == 3'b001 && accum[7] == 0)
                result = 8'h7F;
            else if (opcode == 3'b001 && accum[7] == 1)
                result = 8'h80;
            else if (opcode == 3'b010 && accum[7] == 1)
                result = 8'h7F;
            else if (opcode == 3'b010 && accum[7] == 0)
                result = 8'h80;
            end
            
            zero = (result == 8'b0);
            sign = result[7];
            parity = calcuParity(result);
        end
    end


assign alu_out = result;
assign overflow = overflow_flag;
endmodule