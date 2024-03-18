import common::*;
module select_valid (
    input logic ctrl_mem_r,
    input logic i_ok,
    input logic d_ok,
    output logic up_date
);
    assign up_date = ((!ctrl_mem_r)&i_ok) || (ctrl_mem_r&d_ok)
endmodule