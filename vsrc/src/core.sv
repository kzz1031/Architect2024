`ifndef __CORE_SV
`define __CORE_SV

`ifdef VERILATOR
`include "include/common.sv"
`include "src/program_counter.sv"
`include "src/control_unit.sv"
`include "src/ALU_control.sv"
`include "src/ALU.sv"
`include "src/register_file.sv"
`include "src/immediate_generator.sv"
`endif
module core import common::*;(
	input  logic       clk, reset,
	output ibus_req_t  ireq,
	input  ibus_resp_t iresp,
	output dbus_req_t  dreq,
	input  dbus_resp_t dresp,
	input  logic       trint, swint, exint
);
	/* TODO: Add your CPU-Core here. */

//ins
u64 pc ;
u64 pc_add4;
u32 ins;
OPC op;

initial begin
	pc = PCINIT;
end
assign pc_add4 = pc + 4;
assign op = ins[6:0];
assign ins = iresp.data;
assign ireq.addr = pc;
assign ireq.valid = 1;//???
//Immediate
logic signed [63 : 0] offset;
// CTRL
logic [1:0] ctrl_ALU_op;
logic       ctrl_ALU_src;
logic       ctrl_reg_w;
logic       ctrl_mem_w;
logic       ctrl_mem_r;
logic       ctrl_mem_to_reg;
logic       ctrl_branch;  
logic 		ctrl_auipc;

//ALU
ALU_CTR ALU_ctrl;
u64 ALU_data_out;
logic ALU_zero_flag;

// Register file outputs
u64 reg_read_data_0;
u64 reg_read_data_1;
u64 data_a, data_w;
u64 pc_next;


logic [63 : 0] RF [32];
logic [63 : 0] RF_next [32];
    integer i;
    initial begin 
        for(i = 0; i < REG_NUM ; i++) RF[i] = 64'('b0);
		for(i = 0; i < REG_NUM ; i++) RF_next[i] = 64'('b0);
    end

//data_memory
u64 mem_read_data ;
assign mem_read_data = dresp.data;

always_comb begin
    if (ctrl_reg_w) begin
        RF_next[ins[11:7]] = data_w;
    end
	else RF_next[ins[11:7]] = RF[ins[11:7]];
end // RF_next

always_comb begin
	if(op == LUI) data_a = 0;
		else if(op == AUIPC || op == JAL) data_a = pc;
		else data_a = reg_read_data_0;
end // data_a select

always_comb begin
	if(op == JAL || op == JALR) data_w = pc_add4;
		else if(ctrl_mem_to_reg) data_w = mem_read_data;
			else data_w = ALU_data_out;
end // data_w select

always_comb begin
	if(op == JAL || op == JALR) pc_next = ALU_data_out;
        else if(ALU_zero_flag && ctrl_branch)
            pc_next = pc + offset[63 : 0];
            else 
                pc_next = pc + 64'('b100);
end // pc select

program_counter program_counter(
    .clk(clk),
    .rst(reset),

	.pc_next(pc_next),
    .pc(pc),
	.pc_en(iresp.data_ok));

control_unit control_unit(
    .opcode(OPC'(ins[6:0])),
    .ctrl_ALU_op(ctrl_ALU_op),
    .ctrl_ALU_src(ctrl_ALU_src),
    .ctrl_reg_w(ctrl_reg_w),
    .ctrl_mem_w(ctrl_mem_w),
    .ctrl_mem_r(ctrl_mem_r),
    .ctrl_mem_to_reg(ctrl_mem_to_reg),
	.ctrl_auipc(ctrl_auipc),
    .ctrl_branch(ctrl_branch));

ALU_control ALU_control(
    .funct3(ins[14:12]),
    .funct7(ins[31:25]),
    .ALU_ctrl(ALU_ctrl),
    .ctrl_ALU_op(ctrl_ALU_op));

ALU ALU(
    .data_a(data_a),
    .data_b(ctrl_ALU_src ? offset : reg_read_data_1),
    .data_out(ALU_data_out),
    .zero(ALU_zero_flag),
    .ALU_ctrl(ALU_ctrl));

register_file register_file(
    .clk(clk),
    .rst(reset),
    .reg_0(ins[19:15]),
    .reg_1(ins[24:20]),
    .reg_w(ins[11:7]),
    .r_data_0(reg_read_data_0),
    .r_data_1(reg_read_data_1),
    .w_data(data_w),
    .reg_w_ctrl(ctrl_reg_w),
	.RF(RF));

immediate_generator immediate_generator(
    .ins(ins),
    .offset(offset));

`ifdef VERILATOR
	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (0),
		.index              (0),
		.valid              (iresp.data_ok),
		.pc                 (pc),
		.instr              (ins),
		.skip               (0),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (ctrl_reg_w),
		.wdest              ({3'b0,ins[11:7]}),
		.wdata              (data_w)
	);

	DifftestArchIntRegState DifftestArchIntRegState (
		.clock              (clk),
		.coreid             (0),
		.gpr_0              (0),
		.gpr_1              (RF_next[1]),
		.gpr_2              (RF_next[2]),
		.gpr_3              (RF_next[3]),
		.gpr_4              (RF_next[4]),
		.gpr_5              (RF_next[5]),
		.gpr_6              (RF_next[6]),
		.gpr_7              (RF_next[7]),
		.gpr_8              (RF_next[8]),
		.gpr_9              (RF_next[9]),
		.gpr_10             (RF_next[10]),
		.gpr_11             (RF_next[11]),
		.gpr_12             (RF_next[12]),
		.gpr_13             (RF_next[13]),
		.gpr_14             (RF_next[14]),
		.gpr_15             (RF_next[15]),
		.gpr_16             (RF_next[16]),
		.gpr_17             (RF_next[17]),
		.gpr_18             (RF_next[18]),
		.gpr_19             (RF_next[19]),
		.gpr_20             (RF_next[20]),
		.gpr_21             (RF_next[21]),
		.gpr_22             (RF_next[22]),
		.gpr_23             (RF_next[23]),
		.gpr_24             (RF_next[24]),
		.gpr_25             (RF_next[25]),
		.gpr_26             (RF_next[26]),
		.gpr_27             (RF_next[27]),
		.gpr_28             (RF_next[28]),
		.gpr_29             (RF_next[29]),
		.gpr_30             (RF_next[30]),
		.gpr_31             (RF_next[31])
	);

    DifftestTrapEvent DifftestTrapEvent(
		.clock              (clk),
		.coreid             (0),
		.valid              (0),
		.code               (0),
		.pc                 (0),
		.cycleCnt           (0),
		.instrCnt           (0)
	);

	DifftestCSRState DifftestCSRState(
		.clock              (clk),
		.coreid             (0),
		.priviledgeMode     (3),
		.mstatus            (0),
		.sstatus            (0 /* mstatus & 64'h800000030001e000 */),
		.mepc               (0),
		.sepc               (0),
		.mtval              (0),
		.stval              (0),
		.mtvec              (0),
		.stvec              (0),
		.mcause             (0),
		.scause             (0),
		.satp               (0),
		.mip                (0),
		.mie                (0),
		.mscratch           (0),
		.sscratch           (0),
		.mideleg            (0),
		.medeleg            (0)
	);
`endif
endmodule
`endif