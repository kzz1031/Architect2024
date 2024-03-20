`ifndef __PCSELECT_SV
`define __PCSELECT_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 
module pc_select 
    import common::*;(
    input OPC op,
    input logic ALU_zero_flag,
    input logic ctrl_branch,
    input u64 pc,
    input u64 offset,
    input u64 ALU_data_out,
    output u64 pc_next

);
always_comb begin
	if(op == JAL || op == JALR) pc_next = ALU_data_out;
    else if(ALU_zero_flag && ctrl_branch)   pc_next = pc + offset[63 : 0];
    else pc_next = pc + 64'('b100);
end // pc select
endmodule

`endif 