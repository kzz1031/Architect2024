`ifndef __ALU_SV
`define __ALU_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 
module ALU
    import common::*;(
    input u64 data_a,
    input u64 data_b,
    input ALU_CTR ALU_ctrl,
    input BRA take_branch,
    output u64 data_out,
    output logic zero
    );
    
    //assign zero = (data_out == 0);
    always_comb
    begin
        case (ALU_ctrl)
            AND: data_out = data_a & data_b;
            OR:  data_out = data_a | data_b;
            ADD: data_out = data_a + data_b;
            SUB: data_out = data_a - data_b;
            XOR: data_out = data_a ^ data_b;
            SLL: data_out = data_a << data_b[5:0];
            SRL: data_out = data_a >> data_b[5:0];
            SRA: data_out = $signed(data_a) >>> data_b[5:0];
            SLT: data_out = {63'b0 , $signed(data_a) < $signed(data_b)};
            SLTU: data_out = {63'b0, data_a < data_b};     
            default: data_out = 64'('b0);
        endcase
     end

     always_comb
     begin
        case (take_branch)
            BEQ: zero = (data_out == 0);
            BNE: zero = !(data_out == 0);
            BLT: zero = ( $signed(data_a) < $signed(data_b));
            BGE: zero = ( $signed(data_a) >= $signed(data_b));
            BLTU:zero = (data_a < data_b);
            BGEU:zero = (data_a >= data_b);
            default: zero = (data_out == 0);
        endcase
     end

     
endmodule
`endif