-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
		generic(
		k : integer := 10 -- 10 for Quartus, 8 for ModelSim 
		);
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result,jal_address 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			signal jump,jal				: IN 	STD_LOGIC;
        	SIGNAL clock, reset,INTA 	: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Mem_Addr : STD_LOGIC_VECTOR(k-1 DOWNTO 0 ); 
	SIGNAL next_PC : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	signal jump_address :STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL INS_B : STD_LOGIC_VECTOR(31 downto 0);
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => k,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		--init_file => "C:\Users\Kobi\OneDrive\Desktop\program_wlui.hex",
		init_file =>  "C:\Users\or\Desktop\Final_Project_CPU\CODE\Interrupt_test\test4\ITCM.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> INS_B );
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		Mem_Addr <= Next_PC & "00" when k = 10 else Next_PC when k = 8;
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1 when INTA = '1' else PC( 9 DOWNTO 2 );
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						-- Mux to select Branch Address or PC + 4        
		Next_PC  <= X"00" WHEN Reset = '1' ELSE
			Add_result  WHEN  Branch = '1' else
			jump_address when jump ='1' else jal_address
			when INTA = '0' and jal = '1'
			ELSE   PC_plus_4( 9 DOWNTO 2 );
			
	instruction<=INS_B;		
	jump_address<= 	"00"&INS_B(5 downto 0);	
			
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
	
	
	
	
END behavior;


