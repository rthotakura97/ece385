module mux_2to1_8(
	input[7:0] Din0,
	input[7:0] Din1,
	input select,
	output logic[7:0] Dout
);

mux_2to1 m1(.Din0(Din0[0]), .Din1(Din1[0]), .select, .Dout(Dout[0]));
mux_2to1 m2(.Din0(Din0[1]), .Din1(Din1[1]), .select, .Dout(Dout[1]));
mux_2to1 m3(.Din0(Din0[2]), .Din1(Din1[2]), .select, .Dout(Dout[2]));
mux_2to1 m4(.Din0(Din0[3]), .Din1(Din1[3]), .select, .Dout(Dout[3]));
mux_2to1 m5(.Din0(Din0[4]), .Din1(Din1[4]), .select, .Dout(Dout[4]));
mux_2to1 m6(.Din0(Din0[5]), .Din1(Din1[5]), .select, .Dout(Dout[5]));
mux_2to1 m7(.Din0(Din0[6]), .Din1(Din1[6]), .select, .Dout(Dout[6]));
mux_2to1 m8(.Din0(Din0[7]), .Din1(Din1[7]), .select, .Dout(Dout[7]));

endmodule

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
