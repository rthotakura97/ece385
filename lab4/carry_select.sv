module carry_select
(
	input logic[15:0] A, B,
	output logic[15:0] Sum,
	output logic CO
);

logic c4, c8, c12, ctemp00, ctemp01, ctemp10, ctemp11, ctemp20, ctemp21;
logic[3:0] tempSumWith00, tempSumWith01, tempSumWith10, tempSumWith11, tempSumWith20, tempSumWith21;

four_bit_adder_cs fa00(.x(A[3:0]), .y(B[3:0]), .cin(0), .s(Sum[3:0]), .cout(c4));

four_bit_adder_cs fa10(.x(A[7:4]), .y(B[7:4]), .cin(0), .s(tempSumWith00[3:0]), .cout(ctemp00));
four_bit_adder_cs fa11(.x(A[7:4]), .y(B[7:4]), .cin(1), .s(tempSumWith01[3:0]), .cout(ctemp01));
mux_2to1 m0(.Din0(tempSumWith00[0]), .Din1(tempSumWith01[0]), .select(c4), .Dout(Sum[4]));
mux_2to1 m1(.Din0(tempSumWith00[1]), .Din1(tempSumWith01[1]), .select(c4), .Dout(Sum[5]));
mux_2to1 m2(.Din0(tempSumWith00[2]), .Din1(tempSumWith01[2]), .select(c4), .Dout(Sum[6]));
mux_2to1 m3(.Din0(tempSumWith00[3]), .Din1(tempSumWith01[3]), .select(c4), .Dout(Sum[7]));

assign c8 = c4 & ctemp01 | ctemp00;

four_bit_adder_cs fa20(.x(A[11:8]), .y(B[11:8]), .cin(0), .s(tempSumWith10[3:0]), .cout(ctemp10));
four_bit_adder_cs fa21(.x(A[11:8]), .y(B[11:8]), .cin(1), .s(tempSumWith11[3:0]), .cout(ctemp11));
mux_2to1 m4(.Din0(tempSumWith10[0]), .Din1(tempSumWith11[0]), .select(c8), .Dout(Sum[8]));
mux_2to1 m5(.Din0(tempSumWith10[1]), .Din1(tempSumWith11[1]), .select(c8), .Dout(Sum[9]));
mux_2to1 m6(.Din0(tempSumWith10[2]), .Din1(tempSumWith11[2]), .select(c8), .Dout(Sum[10]));
mux_2to1 m7(.Din0(tempSumWith10[3]), .Din1(tempSumWith11[3]), .select(c8), .Dout(Sum[11]));

assign c12 = c8 & ctemp11 | ctemp10;
four_bit_adder_cs fa30(.x(A[15:12]), .y(B[15:12]), .cin(0), .s(tempSumWith20[3:0]), .cout(ctemp20));
four_bit_adder_cs fa31(.x(A[15:12]), .y(B[15:12]), .cin(1), .s(tempSumWith21[3:0]), .cout(ctemp21));
mux_2to1 m8(.Din0(tempSumWith20[0]), .Din1(tempSumWith21[0]), .select(c12), .Dout(Sum[12]));
mux_2to1 m9(.Din0(tempSumWith20[1]), .Din1(tempSumWith21[1]), .select(c12), .Dout(Sum[13]));
mux_2to1 m10(.Din0(tempSumWith20[2]), .Din1(tempSumWith21[2]), .select(c12), .Dout(Sum[14]));
mux_2to1 m11(.Din0(tempSumWith20[3]), .Din1(tempSumWith21[3]), .select(c12), .Dout(Sum[15]));
assign CO = c12 & ctemp21 | ctemp20;
endmodule


module full_adder_cs
(
	input x, y, cin,
	output logic s, cout
);

assign s = x ^ y ^ cin;
assign cout = (x&y) | (y&cin) | (cin&x);

endmodule

module four_bit_adder_cs(
	input [3:0] x,
	input [3:0] y,
	input cin,
	output logic[3:0] s,
	output logic cout
);

logic c0, c1, c2;
full_adder_cs fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
full_adder_cs fa1(.x(x[1]), .y(y[1]), .cin(c0), .s(s[1]), .cout(c1));
full_adder_cs fa2(.x(x[2]), .y(y[2]), .cin(c1), .s(s[2]), .cout(c2));
full_adder_cs fa3(.x(x[3]), .y(y[3]), .cin(c2), .s(s[3]), .cout(cout));

endmodule
