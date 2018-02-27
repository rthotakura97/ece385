module nzp(input logic [15:0] From_Bus,
           input logic LD_CC, Reset, Clk,
           output logic N, Z, P);

logic nlogic, zlogic, plogic;
reg_1 n(.Clk, .Reset, .Load(LD_CC), .D(nlogic), .Data_Out(N));
reg_1 z(.Clk, .Reset, .Load(LD_CC), .D(zlogic), .Data_Out(Z));
reg_1 p(.Clk, .Reset, .Load(LD_CC), .D(plogic), .Data_Out(P));

always_comb begin
    zlogic = 0;
    plogic = 0;
    nlogic = 0;

    if (From_Bus == 16'h0) begin
        zlogic = 1;
    end
    else if (From_Bus[15] == 1'b0) begin
        plogic = 1;
    end
    else if (From_Bus[15] == 1'b1) begin
        nlogic = 1;
    end
    else begin
        zlogic = 0;
        plogic = 0; 
        nlogic = 0;
    end
end

endmodule

module reg_1 (input  logic Clk, Reset, Load, D,
              output logic Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 1'h0;
		 else if (Load)
			  Data_Out <= D;
    end

endmodule
