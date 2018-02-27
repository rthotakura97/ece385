module ben(input logic N, Z, P,
		   input logic[2:0] ir11_9,
		   input logic LD_BEN, Clk, Reset,
		   output logic BEN);

logic ben_logic;
reg_1 ben(.Clk, .Reset, .Load(LD_BEN), .D(ben_logic), .Data_Out(BEN));

always_comb
begin
	ben_logic = ir11_9[2]&N | ir11_9[1]&Z | ir11_9[0]&P;
end

endmodule