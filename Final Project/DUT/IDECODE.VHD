						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC;
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			
			SHAMT		 : OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			jal			 : in STD_LOGIC;
			PC_plus_4    : in STD_LOGIC_VECTOR(9 downto 0);
	
			clock,reset	: IN 	STD_LOGIC;
			

			R8          : out   std_logic_vector(7 downto 0);
			R9          : out   std_logic_vector(7 downto 0);
			R10          : out   std_logic_vector(7 downto 0);
			R11          : out   std_logic_vector(7 downto 0);
			
			
			------ new----------------------
			INTA        : in std_logic;
			GIE         : out std_logic




			);
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL SHAMT_in						:STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL PC_jump 						:STD_LOGIC_VECTOR(31 downto 0);

BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 );
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 );
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
	SHAMT_in					<= "10000" WHEN Instruction(31 DOWNTO 26) = "001111" ELSE Instruction( 10 DOWNTO 6 );
	SHAMT<= SHAMT_in;
	PC_jump <= x"00000"&"00"&PC_plus_4;
	
					-- Read Register 1 Operation
	read_data_1 <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
					-- Read Register 2 Operation		 
	read_data_2 <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
					-- Mux for Register Write Address
   write_register_address <= write_register_address_1 
			WHEN RegDst = '1' and jal = '0'  ELSE write_register_address_0 when RegDst = '0' and jal = '0' else "11111" when jal = '1' and INTA = '1'
				else "11011" when jal = '1' and INTA = '0';
					-- Mux to bypass data memory for Rformat instructions
	write_data <= ALU_result( 31 DOWNTO 0 ) 
			WHEN ( MemtoReg = '0' and jal = '0') 	ELSE read_data when (MemtoReg = '1' and jal = '0') else PC_jump when jal = '1' ;
					-- Sign Extend 16-bits to 32-bits
    	Sign_extend <= X"0000" & Instruction_immediate_value
		WHEN Instruction_immediate_value(15) = '0'
		ELSE	X"FFFF" & Instruction_immediate_value;

PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '1';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
	END PROCESS;

			R8         <= register_array(8)(7 downto 0);
			R9         <= register_array(9)(7 downto 0);
			R10         <= register_array(10)(7 downto 0);
			R11         <= register_array(11)(7 downto 0);
			GIE      <= register_array(26)(0);


	
	
END behavior;


