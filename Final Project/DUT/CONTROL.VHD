		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Zero 		: IN 	STD_LOGIC;
	Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	RegDst 		: OUT 	STD_LOGIC;
	ALUSrc 		: OUT 	STD_LOGIC;
	MemtoReg 	: OUT 	STD_LOGIC;
	RegWrite 	: OUT 	STD_LOGIC;
	MemRead 	: OUT 	STD_LOGIC;
	MemWrite 	: OUT 	STD_LOGIC;
	Branch 		: OUT 	STD_LOGIC;
	ALUop 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	jump 		:OUT 	STD_LOGIC;
	jr	,jal		:OUT 	STD_LOGIC;
	clock, reset	: IN 	STD_LOGIC;
-----------------------new-------------------
	INTA           : IN std_logic
	);

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Beq,Bne,I_format,jr_in,jal_in , mul 	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          <=  '1'  WHEN  (Opcode = "100011" ) ELSE '0';  --LOAD 
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	Bne 		<=  '1'  when  Opcode = "000101"  Else '0';
	mul         <= '1' 	when Opcode = "011100" else '0'; 
	I_format	<= '1' 	when opcode(5 DOWNTO 3) = "001" or mul = '1' else '0';
	jr_in 		<= 	'1' when (Function_opcode = "001000" and R_format='1') else '0';
  	RegDst    	<=  R_format or mul; --- jal dont care
 	ALUSrc  	<=  Lw OR Sw or (I_format and (not mul)); --- jal = 0 
	MemtoReg 	<=  Lw;
  	RegWrite 	<=  (R_format and (not jr_in)) OR Lw or I_format or mul or jal_in;
  	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw; 
 	Branch      <=  ((Beq and Zero) or (Bne and (not Zero)) or jr_in);
	ALUOp( 1 ) 	<=  R_format;
	ALUOp( 0 ) 	<=  Beq or Bne; 
	jal_in		<=  '1' when opcode = "000011" else '0';
	jump 		<= '1' WHEN opcode ="000010" or (jal_in='1' and INTA = '1')  else '0';
	jal<= jal_in;
	jr<= jr_in;

	

   END behavior;


