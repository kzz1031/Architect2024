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
    output u64 data_out,
    output logic zero
    );
    
    assign zero = (data_out == 0);
    always_comb
    begin
        case (ALU_ctrl)
            AND: data_out = data_a & data_b;
            OR:  data_out = data_a | data_b;
            ADD: data_out = data_a + data_b;
            SUB: data_out = data_a - data_b;
            XOR: data_out = data_a ^ data_b;
            default: data_out = 64'('b0);
        endcase
     end
     
endmodule
`endif