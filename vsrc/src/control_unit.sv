import common::*;

module control_unit(
    input OPC opcode,
    output logic [1 : 0] ctrl_ALU_op,
    output logic ctrl_ALU_src,ctrl_auipc,
    
    output logic ctrl_reg_w,ctrl_mem_r,ctrl_mem_w,ctrl_mem_to_reg,

    output logic ctrl_branch
    );
    always_comb begin
        case (opcode)
        LOAD:
        begin
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b1;
            ctrl_mem_to_reg = 1'b1;
            ctrl_branch     = 1'b0;
        end
        
        STORE:
        begin
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b0;
            ctrl_mem_w      = 1'b1;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end

        ARITH:
        begin            
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b10;
            ctrl_ALU_src    = 1'b0;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end

        BRANCH:
        begin 
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b01;
            ctrl_ALU_src    = 1'b0;
            ctrl_reg_w      = 1'b0;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b1;
        end
        LUI :
        begin
            ctrl_auipc      = 1'b0; 
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end
        OPI :
        begin
            ctrl_auipc      = 1'b0; 
            ctrl_ALU_op     = 2'b11;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end
        AUIPC :
        begin 
            ctrl_auipc      = 1'b1;
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end
        JAL :
        begin 
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b1;
        end
        JALR :
        begin 
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b1;
            ctrl_reg_w      = 1'b1;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end
        default:
        begin
            ctrl_auipc      = 1'b0;
            ctrl_ALU_op     = 2'b00;
            ctrl_ALU_src    = 1'b0;
            ctrl_reg_w      = 1'b0;
            ctrl_mem_w      = 1'b0;
            ctrl_mem_r      = 1'b0;
            ctrl_mem_to_reg = 1'b0;
            ctrl_branch     = 1'b0;
        end

    endcase
        
    end
    
endmodule
