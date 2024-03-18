`ifndef __RF_SV
`define __RF_SV

`ifdef VERILATOR
`include "include/common.sv"
`else

`endif 
module register_file
    import common::*;(
    input logic clk,
    input logic rst,
    input u5 reg_0,reg_1,reg_w,
    input u64 w_data,
    output u64 r_data_0,r_data_1,
    input logic reg_w_ctrl,
    output logic [63 : 0] RF [32]
    );
    
    assign r_data_0 = RF[reg_0];
    assign r_data_1 = RF[reg_1];
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            integer i;
            for(i = 0; i< REG_NUM ; i++) RF[i] <= 64'('b0);
        end else begin
            if(reg_w_ctrl && reg_w != 0) begin
                RF[reg_w] <= w_data;
            end
        end
    end
endmodule
`endif