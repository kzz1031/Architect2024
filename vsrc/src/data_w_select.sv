`ifndef __WSELECT_SV
`define __WSELECT_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 
module data_w_select
    import common::*;(
        input OPC op,
        input logic ctrl_mem_to_reg,
        input u64 mem_read_data,
        input u64 ALU_data_out,
        input u64 pc_add4,
        output u64 data_w
);
always_comb begin
	if(op == JAL || op == JALR) data_w = pc_add4;
	else if(ctrl_mem_to_reg) data_w = mem_read_data;
	else data_w = ALU_data_out;
end // data_w select
endmodule
`endif 