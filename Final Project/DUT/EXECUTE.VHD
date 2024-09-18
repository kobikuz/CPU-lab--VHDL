--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC;
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			ALU_ctl_o		: OUT		 STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			SHAMT			: IN STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			I_format 		: IN STD_LOGIC;
			OPCODE 			: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			jr				: IN STD_LOGIC;
			Binput_o		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SHF_RES_o		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			clock, reset	: IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL CHECK_SHL,CHECK_SHR  : STD_LOGIC;
SIGNAL SHF_L_RES, SHF_R_RES :STD_LOGIC_VECTOR( 31 DOWNTO 0 );
signal SHF_RES 				:STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL mult_res        :STD_LOGIC_VECTOR( 63 DOWNTO 0 );

----------------shifter---------------------------------

type MATRIX is array (0 to 4)  of STD_LOGIC_VECTOR (31 downto 0);
constant zeros : std_logic_vector (31 DOWNTO 0 ) := (others => '0');
signal resMat: MATRIX;     -- log(n)Xn matrix
---------------------------------------------------------


BEGIN
--CHECKING--
CHECK_SHL <= '1' WHEN Function_opcode="000000" ELSE '0';
CHECK_SHR <= '1' WHEN Function_opcode="000010" ELSE '0';



--END CHECKING--
	Ainput <= Read_data_1;
						-- ALU input mux
	Binput <= Read_data_2 
		WHEN ( ALUSrc = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	
	--ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1) when I_format = '0' else OPCODE(0);
	
	--ALU_ctl( 1 ) <= (( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) )) AND (NOT CHECK_SHR) when I_format = '0' else OPCODE(1);;
	
	--ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 ) OR CHECK_SHL OR CHECK_SHR when I_format = '0' else OPCODE(2); 
	mult_res <= (Ainput * Binput);	
	
 
	ALU_ctl <= "000" when  ((ALUop(1) = '1' and Function_opcode="100100")  or OPCODE = "001100")  -- AND
		  else "001" when  ((ALUop(1) = '1' and Function_opcode="100101")  or OPCODE = "001101") -- OR
		  else "010" when  ((ALUop(1) = '1' and Function_opcode="100110")  or OPCODE = "001110") -- XOR
		  else "011" when  ((ALUop(1) = '1' and Function_opcode="000000") OR OPCODE = "001111" ) --SHL OR LUI
		  
		  else "100" when  (ALUop(1) = '1' and Function_opcode="000010") --SHR
		  
		  else "101" when  ((ALUop(1) = '1' and Function_opcode="100000")  or OPCODE = "001000" or OPCODE="011100" or OPCODE= "100011" OR OPCODE= "101011"  or (ALUop(1) = '1' and Function_opcode="100001")) -- ADD LW SW
		  
		  else "110" when  ((ALUop(1) = '1' and Function_opcode="100010")  or ALUOp(0) = '1'  ) -- SUB or mov OR JR
		  
		  else "111" when  ((ALUop(1) = '1' and Function_opcode="101010" ) or OPCODE ="001010") ; -- STL
		   
			 			-- Generate Zero Flag
	Zero <= '1' 
		WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
		ELSE '0';    
						-- Select ALU output        
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) 
		WHEN  ALU_ctl = "111" 
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
						-- Adder to compute Branch Address
						
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 )  ;-- when jump
	
	Add_result 	<= Branch_Add( 7 DOWNTO 0 ) when jr='0' else Ainput(9 DOWNTO 2);
	
	
	
	
-------------------------------------------shifter------------------------------------------------------------------------------------------------
resMat(0) <= Binput(30 downto 0) & zeros(0) when (SHAMT(0)= '1' and ALU_ctl ="011") else
                                zeros(0) & Binput(31 downto 1)  when (SHAMT(0)= '1' and ALU_ctl = "100") else
                                Binput;

		--------------------------shift iterations-------------------------------------------------------
		loopi : for i in 1 to 4 generate
		
				resMAT(i) <= resMAT(i-1)(31 - 2**i   downto 0) & zeros( 2**i - 1 downto 0 )  when (SHAMT(i)= '1' and ALU_ctl ="011") else
						zeros(2**i - 1 downto 0) & resMAT(i-1)(31 downto 2**i)  when (SHAMT(i)= '1' and ALU_ctl = "100") else
								resMAT(i-1);
				
				
		end generate;
		-------------------------- output ----------------------------------------------------------
		SHF_RES  <= resMat(4) when ALU_ctl ="011" or ALU_ctl = "100"  else (others => '0');
		
		
--------------------------------------------end shifter-----------------------------------------------------------------------------------------



PROCESS ( ALU_ctl, Ainput, Binput,SHF_RES )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
		
						-- ALU performs ALUresult = A_input OR B_input
						
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
					
						
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput XOR Binput;
						-- ALU performs SHIFT LEFT LOGICAL
						
 	 	WHEN "011" 	=>	ALU_output_mux <= SHF_RES;
						
 	 	WHEN "100" 	=>	ALU_output_mux 	<= SHF_RES;
						
						
 	 	WHEN "101" 	=>	
                IF OPCODE = "011100" THEN
                    ALU_output_mux <= mult_res(31 DOWNTO 0); -- MULTIPLICATION
                ELSE
                    ALU_output_mux <= Ainput + Binput; -- ALU performs ALUresult = A_input + B_input
                END IF;
						
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;											
  	 	WHEN "111" 	=>	ALU_output_mux 	<= Ainput - Binput ;
		
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
  
  ALU_ctl_o<= ALU_ctl;
  Binput_o<= Binput;
  SHF_RES_o<=SHF_RES;
END behavior;

