module adder(
	input logic[15:0] A, B,
	output logic [15:0] result);

always_comb
begin 
	result = A+B;
end

endmodule

