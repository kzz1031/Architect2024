## RISC-V CPU Lab 2 Report    
### 1、运行结果

![image-20240317152351259](C:\Users\15027\AppData\Roaming\Typora\typora-user-images\image-20240317152351259.png)

### 2、新增两条指令

![img](https://pic4.zhimg.com/v2-2638b7a65f7af39b684f9688900d6783_r.jpg)

### 3、解决方案

由于不能在一个周期内处理完sd和ld，ins会刷新，因此需要寄存器，将目标（rd），ALU计算结果，指令存储下来。

![16c9ecf3ef9bd6f00af266c4239c2af](E:\wechat\WeChat Files\wxid_2i1mv3598qrl22\FileStorage\Temp\16c9ecf3ef9bd6f00af266c4239c2af.png)

```systemverilog
import common::*;

module store (
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
```

core.sv中作出了以下修改

```systemverilog
always_comb begin 
	if(mem_r) begin
		dreq.strobe = 0;
		dreq.size = 3'b011;
	end	
	else if(mem_w) begin
		dreq.strobe = 8'b11111111;
		dreq.size = 3'b011;
	end	
	else begin
		dreq.strobe = 0;
		dreq.size = 3'b011;
	end
end

always_comb begin
    if (ctrl_reg_w) begin
        RF_next[ins[11:7]] = data_w;
    end
	else if (reg_w_store) begin
		RF_next[targ] = dresp.data;
	end 
	else RF_next[ins[11:7]] = RF[ins[11:7]];
end // RF_next

	DifftestInstrCommit DifftestInstrCommit(
		.clock              (clk),
		.coreid             (0),
		.index              (0),
		.valid              (up_date),
		.pc                 (pc),
		.instr              (ins_reg),
		.skip               (0),
		.isRVC              (0),
		.scFailed           (0),
		.wen                (reg_w_store || ctrl_reg_w),
		.wdest              (reg_w_store ? {3'b0,targ} : {3'b0,ins[11:7]}),
		.wdata              (reg_w_store ? dresp.data : data_w)
	);

```

`提交时，若有访存，则等待访存结束再提交，提交内容为寄存器中的值`

### 4、一些针对代码风格的修改

对data_a, data_w, pc的选择器进行了封装

```systemverilog
data_a_select data_a_select(
	.op				(op),
	.pc				(pc),
	.reg_read_data_0(reg_read_data_0),
	.data_a			(data_a)
);

data_w_select data_w_select(
	.op				(op),
	.ctrl_mem_to_reg(ctrl_mem_to_reg),
	.mem_read_data  (mem_read_data),
	.pc_add4        (pc_add4),
	.ALU_data_out	(ALU_data_out),
	.data_w			(data_w)
);

pc_select pc_select(
	.op				(op),
	.pc				(pc),
	.offset			(offset),
	.ALU_zero_flag  (ALU_zero_flag),
	.ALU_data_out   (ALU_data_out),
	.ctrl_branch	(ctrl_branch),
	.pc_next		(pc_next)
);

```

