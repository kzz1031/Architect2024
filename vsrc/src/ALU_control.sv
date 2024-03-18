`ifndef __ALU_CONTROL_SV
`define __ALU_CONTROL_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 

module ALU_control
    import common::*;(
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [1:0] ctrl_ALU_op,
    output ALU_CTR ALU_ctrl
    );
    always_comb
    begin
        case (ctrl_ALU_op)
            2'b00   : ALU_ctrl = ADD; // ld/sd
            2'b01   : ALU_ctrl = SUB; // beq
            2'b10   : begin
                if (funct7 == 7'b0000000 && funct3 == 3'b000)       ALU_ctrl = ADD; // add
                else if (funct7 == 7'b0100000 && funct3 == 3'b000)  ALU_ctrl = SUB; // sub
                else if (funct7 == 7'b0000000 && funct3 == 3'b111)  ALU_ctrl = AND; // and
                else if (funct7 == 7'b0000000 && funct3 == 3'b110)  ALU_ctrl = OR;  // or
                else if (funct7 == 7'b0000000 && funct3 == 3'b100)  ALU_ctrl = XOR;  // xor
                else                                                ALU_ctrl = AND; // default
            end
            2'b11    : begin //OPI
                if (funct3 == 3'b000)       ALU_ctrl = ADD; // add
                else if (funct3 == 3'b111)  ALU_ctrl = AND; // and
                else if (funct3 == 3'b110)  ALU_ctrl = OR;  // or
                else if (funct3 == 3'b100)  ALU_ctrl = XOR;  // xor
                else                                                ALU_ctrl = AND; // default
            end
            default : ALU_ctrl = AND;
        endcase
    end   
endmodule
`endif