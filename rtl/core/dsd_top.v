// Top module of your design, you cannot modify this module!!
module CHIP (	clk,
				rst_n,
//----------for slow_memD------------
				mem_read_D,
				mem_write_D,
				mem_addr_D,
				mem_wdata_D,
				mem_rdata_D,
				mem_ready_D,
//----------for slow_memI------------
				mem_read_I,
				mem_write_I,
				mem_addr_I,
				mem_wdata_I,
				mem_rdata_I,
				mem_ready_I,
//----------for TestBed--------------				
				DCACHE_addr, 
				DCACHE_wdata,
				DCACHE_wen   
			);
input			clk, rst_n;
//--------------------------

output			mem_read_D;
output			mem_write_D;
output	[31:4]	mem_addr_D;
output	[127:0]	mem_wdata_D;
input	[127:0]	mem_rdata_D;
input			mem_ready_D;
//--------------------------
output			mem_read_I;
output			mem_write_I;
output	[31:4]	mem_addr_I;
output	[127:0]	mem_wdata_I;
input	[127:0]	mem_rdata_I;
input			mem_ready_I;
//----------for TestBed--------------
output	[29:0]	DCACHE_addr;
output	[31:0]	DCACHE_wdata;
output			DCACHE_wen;
//--------------------------

// wire declaration
wire        ICACHE_ren;
wire        ICACHE_wen;
wire [29:0] ICACHE_addr;
wire [31:0] ICACHE_wdata;
wire        ICACHE_stall;
wire [31:0] ICACHE_rdata;

wire        DCACHE_ren;
wire        DCACHE_wen;
wire [29:0] DCACHE_addr;
wire [31:0] DCACHE_wdata;
wire        DCACHE_stall;
wire [31:0] DCACHE_rdata;

//=========================================
	// Note that the overall design of your MIPS includes:
	// 1. pipelined MIPS processor
	// 2. data cache
	// 3. instruction cache


	mips_core i_MIPS(
		// control interface
		.clk(clk), 
		.rst_n(rst_n),
//----------I cache interface-------		
		.I_read(ICACHE_ren),
		.I_write(ICACHE_wen),
		.I_addr(ICACHE_addr),
		.I_rdata(ICACHE_rdata),
		.I_wdata(ICACHE_wdata),
		.I_stall(ICACHE_stall),
//----------D cache interface-------
		.D_read(DCACHE_ren),
		.D_write(DCACHE_wen),
		.D_addr(DCACHE_addr),
		.D_rdata(DCACHE_rdata),
		.D_wdata(DCACHE_wdata),
		.D_stall(DCACHE_stall)
	);
	
	cache_d cache_d_inst (
		.clk(clk),
		.proc_reset(~rst_n),
        .proc_stall(DCACHE_stall),
		.proc_read(DCACHE_ren),
		.proc_write(DCACHE_wen),
		.proc_addr(DCACHE_addr),
		.proc_rdata(DCACHE_rdata),
		.proc_wdata(DCACHE_wdata),
		.mem_read(mem_read_D),
		.mem_write(mem_write_D),
		.mem_addr(mem_addr_D),
		.mem_rdata(mem_rdata_D),
		.mem_wdata(mem_wdata_D),
		.mem_ready(mem_ready_D)
	);

	cache_i cache_i_inst (
		.clk(clk),
		.proc_reset(~rst_n),
        .proc_stall(ICACHE_stall),
		.proc_read(ICACHE_ren),
		.proc_write(ICACHE_wen),
		.proc_addr(ICACHE_addr),
		.proc_rdata(ICACHE_rdata),
		.proc_wdata(ICACHE_wdata),
		.mem_read(mem_read_I),
		.mem_write(mem_write_I),
		.mem_addr(mem_addr_I),
		.mem_rdata(mem_rdata_I),
		.mem_wdata(mem_wdata_I),
		.mem_ready(mem_ready_I)
	);
endmodule
