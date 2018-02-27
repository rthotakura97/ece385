module mux_2to1(
	input Din0,
	input Din1,
	input select,
	output logic Dout
);

always_comb
begin 
	case(select)
		'b0 : Dout = Din0;
		'b1 : Dout = Din1;
		default: Dout = Din0;
	endcase
end
endmodule
