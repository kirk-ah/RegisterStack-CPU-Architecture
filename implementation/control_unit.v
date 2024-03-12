module control_unit(
	dStackAction,
	pStackAction,
	rStackAction,
	reset,
	ALUSrcB,
	ALUOp,
	jump,
	jumpOmega,
	PCWrite,
	memRead,
	memWrite,
	IorD
	jump);

	
	output [2:0] dStackAction;
	output [2:0] pStackAction;
	output [2:0] rStackAction;
	output 		 ALUSrcA;
	output		 ALUSrcB;
	output [2:0] ALUOP
	output 		 jump;
	output	    memRead;
	output	    memWrite;
	output		 IorD;
	output 	    IRWrite;
	output	    PCSrc;
	output	    PCWrite;
   output [3:0] current_state;
   output [3:0] next_state;
	output		 jump;

	
   input [5:0]  Opcode;
   input        CLK;
   input        Reset;

   reg [2:0]    ALUOp;
   reg          PCSource;
   reg          ALUSrcB;
   reg          MemRead;
   reg          MemWrite;
   reg          IorD;
   reg          PCWrite;
	reg 		    jump;
	
   //state flip-flops
   reg [3:0]    current_state;
   reg [3:0]    next_state;
	
// ------------------------ End of where I got to ------------------------- //


   //state definitions
   parameter    Fetch = 0;
   parameter    Decode = 1;
	parameter	 Pop1 = 2;
	parameter	 Pop2 = 3;
	parameter	 Push1 = 4;
	parameter	 Push2 = 5;
	parameter	 Pushi = 6;
	parameter	 Jal = 7;
	parameter	 BeginATypeForDataStack = 8;
	parameter	 Add = 9;
	parameter	 Sub = 10;
	parameter	 EndAddAndSub = 11;
	parameter	 Gt = 12;
	parameter	 Lt = 13;
	parameter	 Eq = 14;
	parameter	 Geq = 15;
	parameter	 EndConditional = 16;
	parameter	 Jz = 17;
	parameter	 Jnz = 18;
	parameter 	 EndConditionalJump = 19;
	parameter	 Jmp = 20;
	parameter 	 Ret = 21;
	parameter	 Store = 22;
	parameter	 Popra1 = 23;
	parameter	 Popra2 = 24;
	parameter	 Swapproc = 25;
	parameter	 Dupproc = 26;
	parameter	 Swap = 27;
	parameter	 Dup = 28;
	
   //register calculation
   always @ (posedge CLK, posedge Reset)
     begin
        if (Reset)
          current_state = Fetch;
        else 
          current_state = next_state;
     end


   //OUTPUT signals for each state (depends on current state)
   always @ (current_state)
     begin
        //Reset all signals that cannot be don't cares
		  dStackAction = 0;
		  pStackAction = 0;
		  rStackAction = 0;
        MemRead = 0;
        MemWrite = 0; 
        PCWrite = 0;
		  OPCWrite = 0;
        
        case (current_state)
          
          Fetch:
            begin
              MemRead = 1;
				  IorD = 0;
				  OPCWrite = 1;
//				  PCWrite = 1;
				  jump = 0;
				  // goto Decode

            end 
                         
          Decode:
            begin
               
            end	
			
			 Push1:
				begin
					MemRead = 1;
					IorD = 1;
					// goto Push2
				end
				
			 Push2:
				begin
					dStackAction = 3'b100;
					dIn = 2'b'01;
					// goto Start
				end
			 
			 Pop1:
				begin
					dStackAction = 3'b001;
					// goto Pop2
				end	
				
			 Pop2:
				begin
					MemWrite = 1;
					IorD = 1;
					MemData = 0;
					// goto Start
				end
				
			 Jal:
				begin
					rStackAction = 3'b100;
					// goto Jump (reuse state since unconditional...)
				end
				
			 BeginATypeForDataStack:
				begin
					dStackAction = 3'b010; // This is a drop.
					// either go to start if drop, or go to Add: or Sub:
				end
				
			 Add:
				begin
					ALUSrcB = 0;
					ALUOp = 4'b0000;
					// goto EndAddAndSub
				end
			 
			 Sub:
				begin
					ALUSrcB = 0;
					ALUOp = 4'b0001;
					// goto EndAddAndSub
				end
				
			 EndAddAndSub:
				begin
					dStackAction = 3'b011;
					dIn = 2'b10;
					// goto Start
				end

			 Gt:
				begin
					ALUSrcB = 0;
					ALUOp = 4'b1011;
					// goto EndConditional
				end
			 Lt:
				begin
					ALUSrcB = 0;
					ALUOp = 4'b1001;
					// goto EndConditional
				end
				
			 Eq:
				begin
					ALUSrcB = 0;
					ALUOp = 4'b1010;
					// goto EndConditional
				end
				
			 Geq:
				begin
					ALUSrcB = 0;
					ALUOp = 4'b1110;
					// goto EndConditional
				end
				
			 EndConditional:
				begin
					dIn = 2'b10;
					dStackAction = 3'b100;
					// goto Start
				end
				
			 Jnz:
				begin
					ALUSrcB = 1;
					ALUOp = 4'b0100;
					// got EndConditionalJump
				end
			
		    Jz:
				begin
					ALUSrcB = 1;
					ALUOp = 4'b0111;
					// goto EndConditionalJump
				end
				
			 EndConditionalJump:
				begin
					jumpOmega = 1;
					jump = 1;
					// goto Start
				end
				
			 Jmp:
				begin
					jump = 1;
					jumpOmega = 0;
					// goto Start
				end
				
			 Ret:
				begin
					dIn = 2'b00;
					dStackAction = 3'b100;
					pStackAction = 3'b001;
					// goto Start
				end
				
			 Store:
				begin
					rStackAction = 3'b100;
					dStackAction = 3'b010;
					// goto Start
				end
				
			 Popra1:
				begin
					rStackAction = 3'b100;
					// goto Popra2
				end
				
			 Popra2:
				begin
					MemWrite = 1;
					IorD = 1;
					MemData = 1;
					// goto Start
				end
				
			 Swapproc:
				begin
					pStackAction = 3'b111;
					// goto Start
				end
				
			 Dup:
				begin
					dStackAction = 3'b101;
					// goto Start
				end
				
			 Swap:
				begin
					dStackAction = 3'b111;
					// goto Start
				end
				
			 Dupproc:
				begin
					pStackAction = 3'b101;
					// goto Start
				end
			
          default:
            begin $display ("not implemented"); end
          
        endcase
     end
                
   //NEXT STATE calculation (depends on current state and opcode)       
   always @ (current_state, next_state, Opcode)
     begin         

        $display("The current state is %d", current_state);
        
        case (current_state)
          
          Fetch:
            begin
               next_state = Decode;
               $display("In Fetch, the next_state is %d", next_state);
            end
          
          Decode: 
            begin       
               $display("The opcode is %d", Opcode);
               case (Opcode)
                 2:
						 begin
							next_state = Push1;
							$display("The next state is Push1");
						 end
					  3:
						 begin
							next_state = Pop1;
							$display("The next state is Pop1");
						 end
					  6:
					    begin
							next_state = BeginATypeForDataStack;
							$display("The next state is BeginATypeForDataStack");
						 end
					  7:
					    begin
							next_state = BeginATypeForDataStack;
							$display("The next state is BeginATypeForDataStack");
						 end
					  8:
						 begin
							next_state = Swap;
							$display("The next state is Swap");
						 end
					  9:
					    begin
							next_state = Dup;
							$display("The next state is Dup");
						 end
					  10:
					    begin
							next_state = Eq;
							$display("The next state is Eq");
						 end
					  11:
					    begin
							next_state = Lt;
							$display("The next state is Lt");
						 end
					  12:
					    begin
							next_state = Geq;
							$display("The next state is Geq");
						 end
					  13:
					    begin
							next_state = Jz;
							$display("The next state is Jz");
						 end
					  14:
					    begin
							next_state = Jmp;
							$display("The next state is Jmp");
						 end
					  15:
					    begin
							next_state = Store;
							$display("The next state is Store");
						 end
					  16:
					    begin
							next_state = Ret;
							$display("The next state is Ret");
						 end
					  17:
					    begin
							// DID NOT IMPLEMENT IN CONTROL YET...
							next_state = Lup;
							$display("The next state is Lup");
						 end
					  18:
					    begin
						 // SAME HERE, NOT IMPLEMENTED...
							next_state = Lli;
							$display("The next state is Lli");
						 end
					  19:
					    begin
							next_state = Jnz;
							$display("The next state is Jnz");
						 end
					  45:
						 begin
							next_state = Popra1;
							$display("The next state is Popra1");
						 end
					  35:
						 begin
						   next_state = Pushi; // implement this
							$display("The next state is Pushi");
						 end
					  54:
					    begin
							next_state = Gt;
							$display("The next state is Gt");
						 end
					  57:
					    begin
							next_state = Jal;
							$display("The next state is Jal");
						 end
					  61:
					    begin
							next_state = BeginATypeForDataStack;
							$display("The next state is BeginATypeForDataStack");
						 end
					  62:
					    begin
							next_state = Dupproc;
							$display("The next state is Dupproc");
						 end
					  63:
					    begin
							next_state = Swapproc;
							$display("The next state is Swapproc");
						 end
							
               endcase  
               
               $display("In Decode, the next_state is %d", next_state);
            end
				
				Push1:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Push2;
					end
					
				Push2:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Pushi: // Need to do this one, not in control diagram yet...
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
				
				Pop1:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Pop2;
					end
					
				Pop2:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Jal:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Jmp;
					end
					
				Jmp:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				BeginATypeForDataStack: // do a drop essentially
					begin
						$display("The opcode is %d", Opcode);
						
						case (opcode)
							6:
								begin
									next_state = Sub;
								end
							7:
								begin
									next_state = Add;
								end
							61: // drop
								begin
									next_state = Start;
								end
						endcase
					end
				
				Add:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndAddAndSub;
					end
					
				Sub:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndAddAndSub;
					end
					
				EndAddAndSub:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Swap:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Swapproc:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Dropproc:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Gt:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndConditional;
					end
					
				Lt:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndConditional;
					end
				
				Geq:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndConditional;
					end					
					
				Eq:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndConditional;
					end
					
				EndConditional:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Dup:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Jz:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndConditionalJump;
					end
					
				Jnz:
					begin
						$display("The opcode is %d", Opcode);
						next_state = EndConitionalJump;
					end
					
				EndConditionalJump:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Store:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Ret:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end
					
				Popra1:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Popra2;
					end
					
				Popra2:
					begin
						$display("The opcode is %d", Opcode);
						next_state = Fetch;
					end          
          default:
            begin
               $display(" Not implemented!");
               next_state = Fetch;
            end
          
        endcase
        
        $display("After the tests, the next_state is %d", next_state);
                
     end

endmodule