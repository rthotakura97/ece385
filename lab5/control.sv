module control (input logic Reset,
                            Clk,
                            Run,
                            ClearA_LoadB,
                            M,
                output logic ClrA_X, // Load A register (with 0s or from adder)
                             LdB, // Load B register (from switches)
                             Shift, // Shift X, A, and B
                             Add, // Add S to A
                             Sub); // Subtract S from A
    enum logic [4:0] {Start, End, Prepare, A_Add, A_Shift, B_Add, B_Shift, C_Add, C_Shift, D_Add, D_Shift, E_Add, E_Shift, F_Add, F_Shift, G_Add, G_Shift, H_Sub, H_Shift} curr_state, next_state;

    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= Start;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 
            Start: begin 
                        if (Run) next_state = Prepare; 
                   end
            Prepare:  next_state = A_Add;
            A_Add: next_state = A_Shift;
            A_Shift: next_state = B_Add;
            B_Add: next_state = B_Shift;
            B_Shift: next_state = C_Add;
            C_Add: next_state = C_Shift;
            C_Shift: next_state = D_Add;
            D_Add: next_state = D_Shift;
            D_Shift: next_state = E_Add;
            E_Add: next_state = E_Shift;
            E_Shift: next_state = F_Add;
            F_Add: next_state = F_Shift;
            F_Shift: next_state = G_Add;
				G_Add: next_state = G_Shift;
            G_Shift: next_state = H_Sub;
            H_Sub: next_state = H_Shift;
            H_Shift: next_state = End; // Wait for Run to be depressed before moving on
				End: if (~Run) next_state = Start;
        endcase

		  // Assign outputs based on ‘state’
        case (curr_state) 
            //TODO; See lab4/Control.sv to see how to base this
            Start:
            begin
                ClrA_X = ClearA_LoadB;
                LdB = ClearA_LoadB;
                Shift = 1'b0;
                Add = 1'b0;
                Sub = 1'b0;
            end
            Prepare:
            begin
                ClrA_X = 1'b1;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = 1'b0;
                Sub = 1'b0;
            end
				End:
				begin
					ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = 1'b0;
                Sub = 1'b0;
				end
            H_Sub:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = 1'b0;
                Sub = M;
            end
            A_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
            B_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
            C_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
				D_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
            E_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
            F_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
            G_Add:
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b0;
                Add = M;
                Sub = 1'b0;
            end
            default://Case to shift
            begin
                ClrA_X = 1'b0;
                LdB = 1'b0;
                Shift = 1'b1;
                Add = 1'b0;
                Sub = 1'b0;
            end

        endcase
    end

endmodule
