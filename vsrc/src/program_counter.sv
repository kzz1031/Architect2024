`ifndef __PC_SV
`define __PC_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 
module program_counter
    import common::*;(
    input logic clk,rst,
    input u64 pc_next,
    input logic mem_r,
    input logic mem_w,
    output u64  pc,
    input logic pc_en
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(pc_en) begin
            if(rst) begin
                pc <= PCINIT ;
            end
                else
                 begin
                    pc <= pc_next;
                end 
            end
        end
endmodule
`endif