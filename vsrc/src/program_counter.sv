import common::*;

module program_counter(
    input logic clk,rst,
    input u64 pc_next,
    output u64  pc,
    input logic pc_en
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(pc_en) begin
            if(rst) begin
                pc <= PCINIT;
            end
                else pc <= pc_next;
            end
        end
endmodule
