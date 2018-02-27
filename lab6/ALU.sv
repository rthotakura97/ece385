module ALU(
	input logic[15:0] A, B,
	input logic[1:0] select,
	output logic[15:0] result);

//add = 0
//and = 1
//not = 2
//pass A = 3

always_comb
begin
    case(select)
        2'b00 : result = A+B;
        2'b01 : result = A&B;
        2'b10 : result = ~A;
        2'b11 : result = A;
        default : result = A;
    endcase
end

endmodule
