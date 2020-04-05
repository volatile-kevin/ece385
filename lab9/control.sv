module control(
					input logic CLK, RESET,
					input logic AES_START,
					output logic AES_DONE,
					output logic [2:0] regSelect,
					output logic [1:0] imcSelect,
					output logic [3:0] arkSelect,
					output logic msgRegLE,
					output logic barrierRegLE
					);

						
	enum logic [6:0] {
								Halt,
								KE0,
								KE1,
								KE2,
								KE3,
								KE4, 
								KE5, 
								KE6, 
								KE7, 
								KE8, 
								KE9, 
								KE10,
								
								ARK_INIT,
								
								ISR0,
								ISB0, 
								ARK0,
								IMC0_0,
								IMC0_1,
								IMC0_2, 
								IMC0_3,
								IMC0_4,
								
								
								ISR1,
								ISB1, 
								ARK1,
								IMC1_0,
								IMC1_1,
								IMC1_2, 
								IMC1_3,
								IMC1_4,
								
								ISR2,
								ISB2, 
								ARK2,
								IMC2_0,
								IMC2_1,
								IMC2_2, 
								IMC2_3,
								IMC2_4,
								
								ISR3,
								ISB3, 
								ARK3,
								IMC3_0,
								IMC3_1,
								IMC3_2, 
								IMC3_3,
								IMC3_4,
								
								ISR4,
								ISB4, 
								ARK4,
								IMC4_0,
								IMC4_1,
								IMC4_2, 
								IMC4_3,
								IMC4_4,
								
								ISR5,
								ISB5, 
								ARK5,
								IMC5_0,
								IMC5_1,
								IMC5_2, 
								IMC5_3,
								IMC5_4,
								
								ISR6,
								ISB6, 
								ARK6,
								IMC6_0,
								IMC6_1,
								IMC6_2, 
								IMC6_3,
								IMC6_4,
								
								ISR7,
								ISB7, 
								ARK7,
								IMC7_0,
								IMC7_1,
								IMC7_2, 
								IMC7_3,
								IMC7_4,
								
								ISR8,
								ISB8, 
								ARK8,
								IMC8_0,
								IMC8_1,
								IMC8_2, 
								IMC8_3,
								IMC8_4,
								
								ISR9,
								ISB9,
								ARK9,
								
								Done,
								Done1,
								DoNothing
		
							} State, Next_state;
	
	always_ff @ (posedge CLK)
		begin
			if(RESET)
				State <= Halt;
			else
				State <= Next_state;
		end
	
	
	always_comb
		begin
			Next_state = State;
			regSelect = 2'b00;
			imcSelect = 2'b00;
			arkSelect = 4'b0000;
			msgRegLE = 1'b0;
			barrierRegLE = 1'b0;
			AES_DONE = 1'b0;
			unique case (State)
			
				Halt : 
					begin
						if(AES_START)
							Next_state = KE0;
					end
					
				KE0 : 
					begin
						Next_state = KE1;
					end
					
				KE1 : 
					begin
						Next_state = KE2;
					end
				
				KE2 : 
					begin
						Next_state = KE3;
					end
					
				KE3 : 
					begin
						Next_state = KE4;
					end
					
				KE4 : 
					begin
						Next_state = KE5;
					end
					
				KE5 : 
					begin
						Next_state = KE6;
					end
				
				KE6 : 
					begin
						Next_state = KE7;
					end
					
				KE7 : 
					begin
						Next_state = KE8;
					end
				
				KE8 : 
					begin
						Next_state = KE9;
					end
					
				KE9 : 
					begin
						Next_state = KE10;
					end
				
				KE10:
					begin
						Next_state = ARK_INIT;
					end
					
				ARK_INIT:
					begin
						Next_state = ISR0;
					end
					
				//Round 0
				ISR0 : 
					begin
						Next_state = ISB0;
					end
					
				ISB0 : 
					begin
						Next_state = ARK0;
					end
				
				ARK0:
					begin
						Next_state = IMC0_0;
					end
				
				IMC0_0:
					begin
						Next_state = IMC0_1;
					end
				
				IMC0_1:
					begin
						Next_state = IMC0_2;
					end
				
				IMC0_2:
					begin
						Next_state = IMC0_3;
					end
				
				IMC0_3:
					begin
						Next_state = IMC0_4;
					end
				
				IMC0_4:
					begin
						Next_state = ISR1;
					end
				//Round 1
				ISR1 : 
					begin
						Next_state = ISB1;
					end
					
				ISB1 : 
					begin
						Next_state = ARK1;
					end
				
				ARK1:
					begin
						Next_state = IMC1_0;
					end
				
				IMC1_0:
					begin
						Next_state = IMC1_1;
					end
				
				IMC1_1:
					begin
						Next_state = IMC1_2;
					end
				
				IMC1_2:
					begin
						Next_state = IMC1_3;
					end
				
				IMC1_3:
					begin
						Next_state = IMC1_4;
					end
					
				IMC1_4:
					begin
						Next_state = ISR2;
					end
				
				//Round 2
				ISR2 : 
					begin
						Next_state = ISB2;
					end
					
				ISB2 : 
					begin
						Next_state = ARK2;
					end
				
				ARK2:
					begin
						Next_state = IMC2_0;
					end
				
				IMC2_0:
					begin
						Next_state = IMC2_1;
					end
				
				IMC2_1:
					begin
						Next_state = IMC2_2;
					end
				
				IMC2_2:
					begin
						Next_state = IMC2_3;
					end
				
				IMC2_3:
					begin
						Next_state = IMC2_4;
					end
					
				IMC2_4:
					begin
						Next_state = ISR3;
					end
				
				//Round 3
				ISR3 : 
					begin
						Next_state = ISB3;
					end
					
				ISB3 : 
					begin
						Next_state = ARK3;
					end
				
				ARK3:
					begin
						Next_state = IMC3_0;
					end
				
				IMC3_0:
					begin
						Next_state = IMC3_1;
					end
				
				IMC3_1:
					begin
						Next_state = IMC3_2;
					end
				
				IMC3_2:
					begin
						Next_state = IMC3_3;
					end
				
				IMC3_3:
					begin
						Next_state = IMC3_4;
					end
					
				IMC3_4:
					begin
						Next_state = ISR4;
					end
				
				//Round 4
				ISR4 : 
					begin
						Next_state = ISB4;
					end
					
				ISB4 : 
					begin
						Next_state = ARK4;
					end
				
				ARK4:
					begin
						Next_state = IMC4_0;
					end
				
				IMC4_0:
					begin
						Next_state = IMC4_1;
					end
				
				IMC4_1:
					begin
						Next_state = IMC4_2;
					end
				
				IMC4_2:
					begin
						Next_state = IMC4_3;
					end
				
				IMC4_3:
					begin
						Next_state = IMC4_4;
					end
					
				IMC4_4:
					begin
						Next_state = ISR5;
					end
				//Round 5
				ISR5 : 
					begin
						Next_state = ISB5;
					end
					
				ISB5 : 
					begin
						Next_state = ARK5;
					end
				
				ARK5:
					begin
						Next_state = IMC5_0;
					end
				
				IMC5_0:
					begin
						Next_state = IMC5_1;
					end
				
				IMC5_1:
					begin
						Next_state = IMC5_2;
					end
				
				IMC5_2:
					begin
						Next_state = IMC5_3;
					end
				
				IMC5_3:
					begin
						Next_state = IMC5_4;
					end
				
				IMC5_4:
					begin
						Next_state = ISR6;
					end
					
				//Round 6
				ISR6 : 
					begin
						Next_state = ISB6;
					end
					
				ISB6 : 
					begin
						Next_state = ARK6;
					end
				
				ARK6:
					begin
						Next_state = IMC6_0;
					end
				
				IMC6_0:
					begin
						Next_state = IMC6_1;
					end
				
				IMC6_1:
					begin
						Next_state = IMC6_2;
					end
				
				IMC6_2:
					begin
						Next_state = IMC6_3;
					end
				
				IMC6_3:
					begin
						Next_state = IMC6_4;
					end
				
				IMC6_4:
					begin
						Next_state = ISR7;
					end
				//Round 7
				ISR7 : 
					begin
						Next_state = ISB7;
					end
					
				ISB7 : 
					begin
						Next_state = ARK7;
					end
				
				ARK7:
					begin
						Next_state = IMC7_0;
					end
				
				IMC7_0:
					begin
						Next_state = IMC7_1;
					end
				
				IMC7_1:
					begin
						Next_state = IMC7_2;
					end
				
				IMC7_2:
					begin
						Next_state = IMC7_3;
					end
				
				IMC7_3:
					begin
						Next_state = IMC7_4;
					end
					
				IMC7_4:
					begin
						Next_state = ISR8;
					end
					
				//Round 8
				ISR8 : 
					begin
						Next_state = ISB8;
					end
					
				ISB8 : 
					begin
						Next_state = ARK8;
					end
				
				ARK8:
					begin
						Next_state = IMC8_0;
					end
				
				IMC8_0:
					begin
						Next_state = IMC8_1;
					end
				
				IMC8_1:
					begin
						Next_state = IMC8_2;
					end
				
				IMC8_2:
					begin
						Next_state = IMC8_3;
					end
				
				IMC8_3:
					begin
						Next_state = IMC8_4;
					end
				
				IMC8_4:
					begin
						Next_state = ISR9;
					end
					
				// final round
				ISR9:
					begin
						Next_state = ISB9;
					end
					
				ISB9:
					begin
						Next_state = ARK9;
					end
				
				ARK9:
					begin
						Next_state = Done;
					end
				Done:
					begin
						if(AES_START)
							Next_state = Done;
						else 
							Next_state = Done1;
					end
					
				Done1:
					begin
						if(~AES_START)
							Next_state = DoNothing;
						else
							Next_state = Done1;
					end
					
				DoNothing:
					begin
						if(AES_START)
							Next_state = KE0;
					end
					
				default: ;
			endcase
			
			
			
			// ACTUAL LOGIC
			case(State)
				Halt : 
					begin
						regSelect = 3'b100;
						msgRegLE = 1'b1;
					end			
				KE0 : ;			
				KE1 : ;			
				KE2 : ;				
				KE3 : ;					
				KE4 : ;					
				KE5 : ;								
				KE6 : ;					
				KE7 : ;			
				KE8 : ;			
				KE9 : ;
				KE10: ;
		
				ARK_INIT:
					begin
						arkSelect = 4'b1010;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
					
				//Round 0
				ISR0 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB0 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK0:
					begin
						arkSelect = 4'b1001;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC0_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC0_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC0_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC0_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
				
				IMC0_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
					
				//Round 1
				ISR1 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB1 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK1:
					begin
						arkSelect = 4'b1000;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC1_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC1_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC1_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC1_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
					
				IMC1_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
				
				//Round 2
				ISR2 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB2 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK2:
					begin
						arkSelect = 4'b0111;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC2_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC2_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC2_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC2_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
				
				IMC2_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
				
				//Round 3
				ISR3 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB3 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK3:
					begin
						arkSelect = 4'b0110;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC3_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC3_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC3_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC3_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
					
				IMC3_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
				
				//Round 4
				ISR4 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB4 :
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK4:
					begin
						arkSelect = 4'b0101;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC4_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC4_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC4_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC4_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
					
				IMC4_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
					
				//Round 5
				ISR5 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB5 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK5:
					begin
						arkSelect = 4'b0100;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC5_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC5_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC5_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC5_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
				
				IMC5_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
					
				//Round 6
				ISR6 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB6 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK6:
					begin
						arkSelect = 4'b0011;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC6_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC6_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC6_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC6_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
				
				IMC6_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
				//Round 7
				ISR7 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB7 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK7:
					begin
						arkSelect = 4'b0010;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC7_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC7_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC7_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC7_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
					
				IMC7_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
					
				//Round 8
				ISR8 : 
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB8 : 
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK8:
					begin
						arkSelect = 4'b0001;
						regSelect = 3'b000;
						msgRegLE = 1'b1;
					end
				
				IMC8_0:
					begin
						imcSelect = 2'b00;
						barrierRegLE = 1'b1;
					end
				
				IMC8_1:
					begin
						imcSelect = 2'b01;
						barrierRegLE = 1'b1;
					end
				
				IMC8_2:
					begin
						imcSelect = 2'b10;
						barrierRegLE = 1'b1;
					end
				
				IMC8_3:
					begin
						imcSelect = 2'b11;
						barrierRegLE = 1'b1;
					end
					
				IMC8_4:
					begin
						regSelect = 3'b010;
						msgRegLE = 1'b1;
					end
				
				// final round
				ISR9:
					begin
						regSelect = 3'b001;
						msgRegLE = 1'b1;
					end
					
				ISB9:
					begin
						regSelect = 3'b011;
						msgRegLE = 1'b1;
					end
				
				ARK9:
					begin
						arkSelect = 4'b0000;	
						regSelect = 3'b000;
						msgRegLE = 1'b1;	
					end	
				
				Done:
					begin
						AES_DONE = 1'b1;
					end
				
				Done1:
					begin
						AES_DONE = 1'b1;
					end
					
				DoNothing: ;
				default: ;
			endcase
		end
endmodule