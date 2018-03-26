/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic ld0, ld1, ld2, ld3, ld4, ld5, ld6, ld7, ld8, ld9, ld10, ld11, ld12, ld13, ld14, ld15;
logic [31:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15;

reg_32 aes_key0(.CLK, .RESET, .LOAD(ld0), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out0));
reg_32 aes_key1(.CLK, .RESET, .LOAD(ld1), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out1));
reg_32 aes_key2(.CLK, .RESET, .LOAD(ld2), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out2));
reg_32 aes_key3(.CLK, .RESET, .LOAD(ld3), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out3));

reg_32 aes_msg_en0(.CLK, .RESET, .LOAD(ld4), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out4));
reg_32 aes_msg_en1(.CLK, .RESET, .LOAD(ld5), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out5));
reg_32 aes_msg_en2(.CLK, .RESET, .LOAD(ld6), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out6));
reg_32 aes_msg_en3(.CLK, .RESET, .LOAD(ld7), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out7));

reg_32 aes_msg_de0(.CLK, .RESET, .LOAD(ld8), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out8));
reg_32 aes_msg_de1(.CLK, .RESET, .LOAD(ld9), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out9));
reg_32 aes_msg_de2(.CLK, .RESET, .LOAD(ld10), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out10));
reg_32 aes_msg_de3(.CLK, .RESET, .LOAD(ld11), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out11));

reg_32 blank1(.CLK, .RESET, .LOAD(ld12), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out12));
reg_32 blank2(.CLK, .RESET, .LOAD(ld13), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out13));

reg_32 aes_start(.CLK, .RESET, .LOAD(ld14), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out14));
reg_32 aes_done(.CLK, .RESET, .LOAD(ld15), .BYTE_ENABLE(AVL_BYTE_EN), .AVL_WRITEDATA, .Data_Out(out15));

assign EXPORT_DATA[31:24] = out0[31:24];
assign EXPORT_DATA[23:16] = out0[23:16];
assign EXPORT_DATA[15:8] = out3[15:8];
assign EXPORT_DATA[7:0] = out3[7:0]; 

always_comb
begin

	if(AVL_WRITE == 1'b1)
	begin

		ld0 = 1'b0;
		ld1 = 1'b0;
		ld2 = 1'b0;
		ld3 = 1'b0;
		ld4 = 1'b0;
		ld5 = 1'b0;
		ld6 = 1'b0;
		ld7 = 1'b0;
		ld8 = 1'b0;
		ld9 = 1'b0;
		ld10 = 1'b0;
		ld11 = 1'b0;
		ld12 = 1'b0;
		ld13 = 1'b0;
		ld14 = 1'b0;
		ld15 = 1'b0;
		
		case(AVL_ADDR)
			1'h0: ld0 = 1'b1;
			1'h1: ld1 = 1'b1;
			1'h2: ld2 = 1'b1;
			1'h3: ld3 = 1'b1;
			1'h4: ld4 = 1'b1;
			1'h5: ld5 = 1'b1;
			1'h6: ld6 = 1'b1;
			1'h7: ld7 = 1'b1;
			1'h8: ld8 = 1'b1;
			1'h9: ld9 = 1'b1;
			1'ha: ld10 = 1'b1;
			1'hb: ld11 = 1'b1;
			1'hc: ld12 = 1'b1;
			1'hd: ld13 = 1'b1;
			1'he: ld14 = 1'b1;
			1'hf: ld15 = 1'b1;
			default: ld0 = 0;
		endcase
		
		/*case(AVL_ADDR == 1'h0)
			ld0 = 1'b1;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld0 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h1)
			ld0 = 1'b0;
			ld1 = 1'b1;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld1 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h2)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b1;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld2 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h3)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b1;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld3 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h4)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b1;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld4 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h5)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b1;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld5 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h6)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b1;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld6 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h7)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b1;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld7 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h8)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b1;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld8 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'h9)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b1;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld9 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'ha)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b1;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld10 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'hb)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b1;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld11 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'hc)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b1;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld12 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'hd)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b1;
			ld14 = 1'b0;
			ld15 = 1'b0;
			default: ld13 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'he)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b1;
			ld15 = 1'b0;
			default: ld14 = 1'b0;
		endcase
		
		case(AVL_ADDR == 1'hf)
			ld0 = 1'b0;
			ld1 = 1'b0;
			ld2 = 1'b0;
			ld3 = 1'b0;
			ld4 = 1'b0;
			ld5 = 1'b0;
			ld6 = 1'b0;
			ld7 = 1'b0;
			ld8 = 1'b0;
			ld9 = 1'b0;
			ld10 = 1'b0;
			ld11 = 1'b0;
			ld12 = 1'b0;
			ld13 = 1'b0;
			ld14 = 1'b0;
			ld15 = 1'b1;
			default: ld15 = 1'b0;
		endcase	*/
	end

end

endmodule

module reg_32 (input  logic CLK, RESET, LOAD,
					input logic [3:0] BYTE_ENABLE,
              input  logic [31:0]  AVL_WRITEDATA,
              output logic [31:0]  Data_Out);

    always_ff @ (posedge CLK)
    begin
	 	 if (RESET) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 32'b0;
		 else if (LOAD)
			begin
				if(BYTE_ENABLE[0] == 1'b1)
					Data_Out[7:0] <= AVL_WRITEDATA[7:0];
				if(BYTE_ENABLE[1] == 1'b1)
					Data_Out[15:8] <= AVL_WRITEDATA[15:8];
				if(BYTE_ENABLE[2] == 1'b1)
					Data_Out[23:16] <= AVL_WRITEDATA[23:16];
				if(BYTE_ENABLE[3] == 1'b1)
					Data_Out[31:24] <= AVL_WRITEDATA[31:24];
			end
    end

endmodule

