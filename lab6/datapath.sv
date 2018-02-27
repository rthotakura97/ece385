module datapath(input logic Clk, Reset, LD_IR, LD_PC, LD_MAR, LD_MDR, LD_REG, LD_BEN, LD_CC, LD_LED,
                            GatePC, GateMDR, GateMARMUX, GateALU, MIO_EN,
                            DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
                input logic [1:0] PCMUX, ADDR2MUX, ALUK,
                input logic [15:0] From_mem,
                output logic [15:0] IR, PC, MAR, MDR, R7, R6, R5, R4, R3, R2, R1, R0,
                output logic BEN, N, Z, P,
                output logic [11:0] LED);

logic [15:0] bus, pc_in, pc_plus, mdr_in, sr1_out, sr2_out, addr1out, addr2out, sext5, sext6, sext9, sext11, alub, alu_out, adder_out;
logic [2:0] drchoose, sr1choose;
//logic N, Z, P;

//registers
reg_16 ir(.Clk(Clk),.Reset(Reset),.Load(LD_IR),.D(bus),.Data_Out(IR));

reg_16 pc(.Clk(Clk),.Reset(Reset),.Load(LD_PC),.D(pc_in),.Data_Out(PC));

reg_16 mar(.Clk(Clk),.Reset(Reset),.Load(LD_MAR),.D(bus),.Data_Out(MAR));

reg_16 mdr(.Clk(Clk),.Reset(Reset),.Load(LD_MDR),.D(mdr_in),.Data_Out(MDR));

//led
reg_12 leds(.Clk, .Reset, .Load(LD_LED), .D(IR[11:0]), .Data_Out(LED));

//reg file
reg_file reggie(.From_Bus(bus), .DRSelect(drchoose), .SR1Select(sr1choose), .SR2Select(IR[2:0]), .LD_REG, .Clk, .Reset, .SR1(sr1_out), .SR2(sr2_out), .R7, .R6, .R5, .R4, .R3, .R2, .R1, .R0);

//ALU
ALU alu_mod(.A(sr1_out), .B(alub), .select(ALUK), .result(alu_out));

//nzp
nzp nza_mod(.From_Bus(bus), .LD_CC, .Reset, .Clk, .N, .Z, .P);
ben benny(.N, .Z, .P, .ir11_9(IR[11:9]), .LD_BEN, .Clk, .Reset, .BEN);

//sexters
sext5_to_16 sexter5(.in(IR[4:0]), .out(sext5));
sext6_to_16 sexter6(.in(IR[5:0]), .out(sext6));
sext9_to_16 sexter9(.in(IR[8:0]), .out(sext9));
sext11_to_16 sexter11(.in(IR[10:0]), .out(sext11));

//adder
adder addy(.A(addr1out), .B(addr2out), .result(adder_out));

//pc mux
//from pc incrementer or bus
assign pc_plus = PC+1;
four_to_one_mux pc_mux(.A(pc_plus), .B(bus), .C(adder_out), .D(0), .select(PCMUX), .out(pc_in));

//mdr mux
//from BUS or memory
two_to_one_mux mdr_mux(.A(bus), .B(From_mem), .select(MIO_EN), .out(mdr_in));

//ADDR muxes
//ADDR1mux
two_to_one_mux addr1_mux(.A(sr1_out), .B(PC), .select(ADDR1MUX), .out(addr1out));
//ADDR2mux
four_to_one_mux addr2_mux(.A(0), .B(sext6), .C(sext9), .D(sext11), .select(ADDR2MUX), .out(addr2out));

//reg muxes
two_to_one_mux3 dr_mux(.A(IR[11:9]), .B(3'b111), .select(DRMUX), .out(drchoose));
two_to_one_mux3 sr1_mux(.A(IR[11:9]), .B(IR[8:6]), .select(SR1MUX), .out(sr1choose));

two_to_one_mux sr2_mux(.A(sr2_out), .B(sext5), .select(SR2MUX), .out(alub));

//bus mux
//from mdr and pc
bus_mux bus_gates(.MARMUX(adder_out),
                 .PC(PC),
                 .MDR(MDR),
                 .ALU(alu_out),
                 .GatePC(GatePC),
                 .GateMDR(GateMDR),
                 .GateMARMUX(GateMARMUX),
                 .GateALU(GateALU),
                 .bus(bus));

endmodule
