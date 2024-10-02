`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/18 20:27:35
// Design Name: 
// Module Name: mmult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mmult(
    input clk,
    input reset_n,
    input enable,
    input [0:9*8-1] A_mat,
    input [0:9*8-1] B_mat,
    output valid,
    output reg [0:9*18-1] C_mat
);

    reg [17:0] C [0:8];
    reg [1:0] cycle;
    reg valid;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            valid <= 0;
            cycle <= 0;
            C_mat <= 0;
        end else if (enable) begin
            case (cycle)
                0: begin
                    C[0] <= (A_mat[0:7] * B_mat[0:7]) + (A_mat[8:15] * B_mat[24:31]) + (A_mat[16:23] * B_mat[48:55]);
                    C[1] <= (A_mat[0:7] * B_mat[8:15]) + (A_mat[8:15] * B_mat[32:39]) + (A_mat[16:23] * B_mat[56:63]);
                    C[2] <= (A_mat[0:7] * B_mat[16:23]) + (A_mat[8:15] * B_mat[40:47]) + (A_mat[16:23] * B_mat[64:71]);
                    cycle <= 1;
                end
                1: begin
                    C[3] <= (A_mat[24:31] * B_mat[0:7]) + (A_mat[32:39] * B_mat[24:31]) + (A_mat[40:47] * B_mat[48:55]);
                    C[4] <= (A_mat[24:31] * B_mat[8:15]) + (A_mat[32:39] * B_mat[32:39]) + (A_mat[40:47] * B_mat[56:63]);
                    C[5] <= (A_mat[24:31] * B_mat[16:23]) + (A_mat[32:39] * B_mat[40:47]) + (A_mat[40:47] * B_mat[64:71]);
                    cycle <= 2;
                end
                2: begin
                    C[6] <= (A_mat[48:55] * B_mat[0:7]) + (A_mat[56:63] * B_mat[24:31]) + (A_mat[64:71] * B_mat[48:55]);
                    C[7] <= (A_mat[48:55] * B_mat[8:15]) + (A_mat[56:63] * B_mat[32:39]) + (A_mat[64:71] * B_mat[56:63]);
                    C[8] <= (A_mat[48:55] * B_mat[16:23]) + (A_mat[56:63] * B_mat[40:47]) + (A_mat[64:71] * B_mat[64:71]);
                    cycle <= 3;
                end
                3: begin
                    C_mat <= {C[0], C[1], C[2], C[3], C[4], C[5], C[6], C[7], C[8]};
                    valid <= 1;
                    cycle <= 0;
                end
            endcase
        end else begin
            valid <= 0;
        end
    end

endmodule
