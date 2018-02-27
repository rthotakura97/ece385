module reg_file(input logic [15:0] From_Bus,
                input logic [2:0] DRSelect, SR1Select, SR2Select,
                input logic LD_REG, Clk, Reset,
                output logic [15:0] SR1, SR2, R7, R6, R5, R4, R3, R2, R1, R0);

logic ld0, ld1, ld2, ld3, ld4, ld5, ld6, ld7;
logic [15:0] out0, out1, out2, out3, out4, out5, out6, out7;

reg_16 r0(.Clk, .Reset, .Load(ld0), .D(From_Bus), .Data_Out(out0));
reg_16 r1(.Clk, .Reset, .Load(ld1), .D(From_Bus), .Data_Out(out1));
reg_16 r2(.Clk, .Reset, .Load(ld2), .D(From_Bus), .Data_Out(out2));
reg_16 r3(.Clk, .Reset, .Load(ld3), .D(From_Bus), .Data_Out(out3));
reg_16 r4(.Clk, .Reset, .Load(ld4), .D(From_Bus), .Data_Out(out4));
reg_16 r5(.Clk, .Reset, .Load(ld5), .D(From_Bus), .Data_Out(out5));
reg_16 r6(.Clk, .Reset, .Load(ld6), .D(From_Bus), .Data_Out(out6));
reg_16 r7(.Clk, .Reset, .Load(ld7), .D(From_Bus), .Data_Out(out7));
assign R7 = out7;
assign R6 = out6;
assign R5 = out5;
assign R4 = out4;
assign R3 = out3;
assign R2 = out2;
assign R1 = out1;
assign R0 = out0;


always_comb
begin
    ld0 = 1'b0;
    ld1 = 1'b0;
    ld2 = 1'b0;
    ld3 = 1'b0;
    ld4 = 1'b0;
    ld5 = 1'b0;
    ld6 = 1'b0;
    ld7 = 1'b0;

    case(DRSelect)
        3'b000: ld0 = LD_REG;
        3'b001: ld1 = LD_REG;
        3'b010: ld2 = LD_REG;
        3'b011: ld3 = LD_REG;
        3'b100: ld4 = LD_REG;
        3'b101: ld5 = LD_REG;
        3'b110: ld6 = LD_REG;
        3'b111: ld7 = LD_REG;
        default: ld0 = 0; //Not possible
    endcase

    case(SR1Select)
        3'b000: SR1 = out0;
        3'b001: SR1 = out1;
        3'b010: SR1 = out2;
        3'b011: SR1 = out3;
        3'b100: SR1 = out4;
        3'b101: SR1 = out5;
        3'b110: SR1 = out6;
        3'b111: SR1 = out7;
        default: SR1 = 16'b0; //Not possible
    endcase

    case(SR2Select)
        3'b000: SR2 = out0;
        3'b001: SR2 = out1;
        3'b010: SR2 = out2;
        3'b011: SR2 = out3;
        3'b100: SR2 = out4;
        3'b101: SR2 = out5;
        3'b110: SR2 = out6;
        3'b111: SR2 = out7;
        default: SR2 = 16'b0; //Not possible
    endcase
end
endmodule
