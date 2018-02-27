module nine_bit_adder(input logic [7:0] A,
                                        B,
                      input logic cin,
                      output logic [8:0] S,
                      output logic cout
);

//need to sign extend both A, B to 9 bits
//then sum together both
//should return 9 bit result

logic c0, c1;
logic extend_a, extend_b; //sign extension
assign extend_a = A[7];
assign extend_b = B[7];

four_bit_adder ra0(.x(A[3:0]), .y(B[3:0]), .cin(cin), .s(S[3:0]), .cout(c0));
four_bit_adder ra1(.x(A[7:4]), .y(B[7:4]), .cin(c0), .s(S[7:4]), .cout(c1));
full_adder ra2(.x(extend_a), .y(extend_b), .cin(c1), .s(S[8]), .cout(cout));							 
							 
endmodule

module incrementer(input logic [7:0] B,                  
                       input logic cin,
                       output logic [7:0] S,
                       output logic cout
);


logic c0;
logic [3:0] ones, zeros;
assign ones[0] = 1'b1;
assign ones[1] = 1'b0;
assign ones[2] = 1'b0;
assign ones[3] = 1'b0;
assign zeros[0] = 1'b0;
assign zeros[1] = 1'b0;
assign zeros[2] = 1'b0;
assign zeros[3] = 1'b0;


four_bit_adder ra0(.x(ones), .y(B[3:0]), .cin(cin), .s(S[3:0]), .cout(c0));
four_bit_adder ra1(.x(zeros), .y(B[7:4]), .cin(c0), .s(S[7:4]), .cout(cout));
							 
endmodule

module full_adder
(
	input x, y, cin,
	output logic s, cout
);

assign s = x ^ y ^ cin;
assign cout = (x&y) | (y&cin) | (cin&x);

endmodule

module four_bit_adder(
	input [3:0] x,
	input [3:0] y,
	input cin,
	output logic[3:0] s,
	output logic cout
);

logic c0, c1, c2;
full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0), .s(s[1]), .cout(c1));
full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1), .s(s[2]), .cout(c2));
full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2), .s(s[3]), .cout(cout));

endmodule


