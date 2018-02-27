module lab4_adders 
(
	input logic clk,
	input logic Reset,
	input logic LoadB,
	input logic Run,
	input logic[15:0] SW,
	
	output logic CO,
	output logic[15:0] Sum,
	output logic[6:0] Ahex0, Ahex1, Ahex2, Ahex3, Bhex0, Bhex1, Bhex2, Bhex3 
);

	logic[15:0] A, B;
	
	logic[6:0] Ahex0_comb , Ahex1_comb , Ahex2_comb , Ahex3_comb , Bhex0_comb , Bhex1_comb, Bhex2_comb , Bhex3_comb;
	logic CO_comb;
	logic[15:0] Sum_comb;
	
	always_ff @ (posedge clk) begin
		
		if(!Reset) begin
			A <= 16'h0000;
			B <= 16'h0000;
			Sum <= 16'h0000;
			CO <= 1'b0;	
		end else if (!LoadB) begin	
			B <= SW;	
		end else begin 
			A <= SW;	
		end
		
		if (!Run) begin
			Sum <= Sum_comb;
			CO <= CO_comb;	
		end
		
	end

	always_ff @ (posedge clk) begin
	
		Ahex0 <= Ahex0_comb;
		Ahex1 <= Ahex1_comb;
		Ahex2 <= Ahex2_comb;
		Ahex3 <= Ahex3_comb;
		Bhex0 <= Bhex0_comb;
		Bhex1 <= Bhex1_comb;
		Bhex2 <= Bhex2_comb;
		Bhex3 <= Bhex3_comb;

	end
	
	/*ripple_adder ripple_adder_inst(
		.A,
		.B,
		.Sum(Sum_comb),
		.CO(CO_comb)
	);*/

	
	carry_lookahead carry_lookahead_inst(
		.A,
		.B,
		.Sum(Sum_comb),
		.CO(CO_comb)
	);
	
	
	/*carry_select carry_select_inst(
		.A,
		.B,
		.Sum(Sum_comb),
		.CO(CO_comb)
	);*/
	
	
	
    HexDriver Ahex0_inst
    (
        .In0(A[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(Ahex0_comb)
    );
    
    HexDriver Ahex1_inst
    (
        .In0(A[7:4]),
        .Out0(Ahex1_comb)
    );
    
    HexDriver Ahex2_inst
    (
        .In0(A[11:8]),
        .Out0(Ahex2_comb)
    );
    
    HexDriver Ahex3_inst
    (
        .In0(A[15:12]),
        .Out0(Ahex3_comb)
    );
    
    HexDriver Bhex0_inst
    (
        .In0(B[3:0]),
        .Out0(Bhex0_comb)
    );
    
    HexDriver Bhex1_inst
    (
        .In0(B[7:4]),
        .Out0(Bhex1_comb)
    );
    
    HexDriver Bhex2_inst
    (
        .In0(B[11:8]),
        .Out0(Bhex2_comb)
    );
    
    HexDriver Bhex3_inst
    (
        .In0(B[15:12]),
        .Out0(Bhex3_comb)
    );
	
endmodule
	
	

	