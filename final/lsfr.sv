module lsfr(input Clk, Reset, 
		input [7:0] seed,
		output [7:0] q);

	always @ (posedge Clk) begin
		if (Reset)
			q <= seed;
		else
			q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]};
	end

endmodule
