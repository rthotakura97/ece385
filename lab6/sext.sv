module sext5_to_16(input logic [4:0] in,
                   output logic [15:0] out);

always_comb
begin
	out <= { {11{in[4]}}, in[4:0] };
end
endmodule

module sext6_to_16(input logic [5:0] in,
                   output logic [15:0] out);

always_comb
begin
	out <= { {10{in[5]}}, in[5:0] };
end
endmodule

module sext9_to_16(input logic [8:0] in,
                   output logic [15:0] out);


always_comb
begin
	out <= { {7{in[8]}}, in[8:0] };
end
endmodule

module sext11_to_16(input logic [10:0] in,
                   output logic [15:0] out);

always_comb
begin
	out <= { {5{in[10]}}, in[10:0] };
end
endmodule
