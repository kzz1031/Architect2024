`ifndef __STORE_SV
`define __STORE_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 
module store 
    import common::*;(
    input u64 ALU_data_out,
    input u5 rs2,
    input logic ctrl_mem_r,
    input logic ctrl_mem_w,
    input logic clk,
    input logic ok,
    output logic reg_w_store,
    output logic mem_r,
    output logic mem_w,
    output u5 targ,
    output u64 data_out_store
);

always_ff @( posedge clk ) 
begin
    if(ctrl_mem_r)
    begin
        mem_r <= 1; 
        targ <= rs2;
        data_out_store <= ALU_data_out;
        reg_w_store <= 1;
    end
    else if(ctrl_mem_w)
    begin
        mem_w <= 1; 
        targ <= rs2;
        data_out_store <= ALU_data_out;
    end
    else if(ok)
    begin
        mem_r <= 0;
        mem_w <= 0;
        reg_w_store <= 0;
    end
end
endmodule
`endif