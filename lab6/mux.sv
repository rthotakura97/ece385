module two_to_one_mux(input logic [15:0] A, B,
                      input logic select,
                      output logic [15:0] out);

always_comb
begin
    case(select)
        'b0 : out = A;
        'b1 : out = B;
        default : out = A;
    endcase
end
endmodule

module two_to_one_mux3(input logic [2:0] A, B,
                      input logic select,
                      output logic [2:0] out);

always_comb
begin
    case(select)
        'b0 : out = A;
        'b1 : out = B;
        default : out = A;
    endcase
end
endmodule

module four_to_one_mux(input logic [15:0] A, B, C, D,
                      input logic [1:0] select,
                      output logic [15:0] out);

always_comb
begin
    case(select)
        'b00 : out = A;
        'b01 : out = B;
        'b10 : out = C;
        'b11 : out = D;
        default : out = A;
    endcase
end
endmodule

module bus_mux(input logic [15:0] MARMUX, PC, MDR, ALU,
               input logic GatePC, GateMDR, GateMARMUX, GateALU,
               output logic [15:0] bus);
always_comb
begin
    if (GatePC == 1'b1)
        bus = PC;
    else if (GateMDR == 1'b1)
        bus = MDR;
    else if (GateMARMUX == 1'b1)
        bus = MARMUX;
    else if (GateALU == 1'b1)
        bus = ALU;
	 else
		  bus = 16'b0;
end
endmodule
