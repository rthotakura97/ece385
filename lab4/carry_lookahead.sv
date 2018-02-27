module carry_lookahead
(
	input logic[15:0] A, B,
	output logic[15:0] Sum,
	output logic CO
);
logic pg0, gg0, pg4, gg4, pg8, gg8, pg12, gg12;
logic c4, c8, c12;
carry_four_bit ca0(.A(A[3:0]), .B(B[3:0]), .cin(0), .pg(pg0), .gg(gg0), .sum(Sum[3:0]));
assign c4 = gg0;
carry_four_bit ca1(.A(A[7:4]), .B(B[7:4]), .cin(c4), .pg(pg4), .gg(gg4), .sum(Sum[7:4]));
assign c8 = gg4 | gg0 & pg4;
carry_four_bit ca2(.A(A[11:8]), .B(B[11:8]), .cin(c8), .pg(pg8), .gg(gg8), .sum(Sum[11:8]));
assign c12 = gg8 | gg4 & pg8 | gg0 & pg8 & pg4;
carry_four_bit ca3(.A(A[15:12]), .B(B[15:12]), .cin(c12), .pg(pg12), .gg(gg12), .sum(Sum[15:12]));
assign CO = gg12 | gg8 & pg12 | gg4 & pg12 & pg8 | gg0 & pg12 & pg8 & pg4;

endmodule

module carry_four_bit
(
	input[3:0] A, B,
	input cin,
	output logic pg, gg,
	output logic[3:0] sum
);
logic p0, p1, p2, g0, g1, g2, c1, c2, c3;
fa_lookahead fa0(.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .p(p0), .g(g0));
assign c1 = cin & p0 | g0;
fa_lookahead fa1(.A(A[1]), .B(B[1]), .cin(c1), .sum(sum[1]), .p(p1), .g(g1));
assign c2 = cin & p0 & p1 | g0 & p1 | g1;
fa_lookahead fa2(.A(A[2]), .B(B[2]), .cin(c2), .sum(sum[2]), .p(p2), .g(g2));
assign c3 = cin & p0 & p1 & p2 | g0 & p1 & p2 | g1 & p2 | g2;
fa_lookahead fa3(.A(A[3]), .B(B[3]), .cin(c3), .sum(sum[3]), .p(p3), .g(g3));

assign pg = p0 & p1 & p2 & p3;
assign gg = g3 | g2 & p3 | g1 & p3 & p2 | g0 & p3 & p2 & p1;

endmodule

module fa_lookahead
(
	input A, B,
	input cin,
	output logic sum, p, g
);

assign sum = A ^ B ^ cin;
assign cout = (A&B) | (A&cin) | (cin&B);
assign p = A ^ B;
assign g = A & B;

endmodule
