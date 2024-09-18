				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS
		generic(
		k : integer := 10 -- 10 for Quartus, 8 for ModelSim 
		);
	PORT( reset, clock					: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out, Memwrite_out,Memread_out , 
		Regwrite_out					: OUT 	STD_LOGIC ;
		Binput_oo : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SHF_RES_o		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_ctl_o	: 	OUT	 STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		
			
			
		R8          : out   std_logic_vector(7 downto 0);
		R9          : out   std_logic_vector(7 downto 0);
		R10          : out   std_logic_vector(7 downto 0);
		R11          : out   std_logic_vector(7 downto 0);

		read_data_From_bus 				: in STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		-------------------new------------------------------------
		GIE            :out std_logic;
		INTA_o         :out std_logic;
		INTR           :in  std_logic;
		jal_address_out : out std_logic_vector(31 downto 0);
		data_from_buss_enable_o : out std_logic
		
		);
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
		generic(
			k : integer -- 10 for Quartus, 8 for ModelSim 
		);
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result,jal_address 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			signal jump,jal				: IN 	STD_LOGIC;
        	SIGNAL clock, reset,INTA 	: IN 	STD_LOGIC);
	END COMPONENT; 

	COMPONENT Idecode IS
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC;
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			--NEW 
			SHAMT		 : OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			jal			 : in STD_LOGIC;
			PC_plus_4    : in STD_LOGIC_VECTOR(9 downto 0);
			--END NEW
			clock,reset	: IN 	STD_LOGIC; 

			R8          : out   std_logic_vector(7 downto 0);
			R9          : out   std_logic_vector(7 downto 0);
			R10          : out   std_logic_vector(7 downto 0);
			R11          : out   std_logic_vector(7 downto 0);
			
			--------new-----------------
			INTA        : in std_logic;
			GIE         : out std_logic

			
			);
	END COMPONENT;

	COMPONENT control
	     PORT( 	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
				Zero 				: IN 	STD_LOGIC;
		Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
             	Branch 				: OUT 	STD_LOGIC;
             	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				jump 		:OUT 	STD_LOGIC;
				jr,jal			:OUT 	STD_LOGIC;
             	clock, reset		: IN 	STD_LOGIC;
				INTA           : IN std_logic
				);
	END COMPONENT;

	COMPONENT  Execute IS
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
			SHAMT		 : IN STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			I_format 		: IN STD_LOGIC;
			OPCODE 			: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			jr			: IN STD_LOGIC;
			Binput_o		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SHF_RES_o		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			clock, reset	: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
		generic(
			k : integer -- 10 for Quartus, 8 for ModelSim 
		);
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( k-1 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal read_data_from_memory : std_logic_vector(31 downto 0);
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC;
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	signal SHAMT			 :  STD_LOGIC_VECTOR(4 DOWNTO 0 );
	SIGNAL I_format          :STD_LOGIC;
	SIGNAL jump ,jr,jal		: STD_LOGIC;
	SIGNAL 	ALU_ctl_ob		 		: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL Binput_o		:  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal data_from_buss_enable : STD_LOGIC;
	
	---------------------new------------------------------------
	signal INTA  			 : std_logic;
	signal GIE_from_hardware : std_logic; 
	signal GIE_from_software : std_logic ; 	
	signal jal_adress        : std_logic_vector(7 downto 0);
	SIGNAL Instruction_fetch		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal INTR_buff               :std_logic;
	type state is (fetch,finish_state,jal_state);
	SIGNAL pr_state, next_state: state;
	signal MemWrite_buff : std_logic;
	signal address_toMemory : std_logic_vector(k-1 downto 0);

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
   Branch_out 		<= Branch;
   Zero_out 		<= Zero;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;
   Memread_out      <= MemRead;
   
   
   MemWrite_buff    <= MemWrite when   ALU_result(11) ='0' else '0';
   
   data_from_buss_enable <= '1' when ALU_result(11) ='1' and MemRead = '1' else '0';
   read_data      <= read_data_From_bus when   data_from_buss_enable ='1'  else  read_data_from_memory;
   --------------------new------------------------------------
   GIE <= GIE_from_hardware and GIE_from_software;
   INTA_o <= INTA;
   jal_address_out <= read_data;
   data_from_buss_enable_o <=data_from_buss_enable;
   
   address_toMemory <=  ALU_result(9 DOWNTO 2)&"00" when k=10 else  ALU_result(9 DOWNTO 2) when k = 8;

   
					-- connect the 5 MIPS components   
  IFE : Ifetch
  	generic map(k=>k)
	PORT MAP (	Instruction 	=> Instruction_fetch,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_result,
				jal_address     => read_data(9 downto 2), -- maybe 9 downto 2
				Branch 			=> Branch,
				PC_out 			=> PC,   
				jump			=> jump,			
				clock 			=> clock,  
				reset 			=> reset,
				INTA  			=>INTA,
				jal  			=>jal
				);
 
   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
        		read_data 		=> read_data,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
				SHAMT		 	=> SHAMT,
				jal				=> jal,
				PC_plus_4  		=> PC_plus_4,
        		clock 			=> clock,  
				reset 			=> reset,

				R8 => R8,
				R9=>R9,
				R10 => R10,
				R11=>R11,
				-------new-----------------
				INTA => INTA,
				GIE => GIE_from_software


				);


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				Zero 			=> Zero,
				Function_opcode=> Instruction( 5 DOWNTO 0 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
				ALUop 			=> ALUop,
				jump 			=> 	jump,
				jr				=> 	jr,
				jal 			=> 	jal,
                clock 			=> clock,
				reset 			=> reset,
				-----new------
				INTA=>INTA
				);

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Function_opcode	=> Instruction( 5 DOWNTO 0 ),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
                ALU_Result		=> ALU_result,
				Add_Result 		=> Add_Result,
				ALU_ctl_o		=>			ALU_ctl_ob	,
				PC_plus_4		=> PC_plus_4,
				SHAMT			=> SHAMT,
				I_format 		=> I_format,
				OPCODE			=> Instruction(31 DOWNTO 26),
				jr				=> jr ,
                Clock			=> clock,
				Binput_o		=> Binput_o	,
				SHF_RES_o		=>SHF_RES_o,
				
				Reset			=> reset );

   MEM:  dmemory
    generic map(k => k)
	PORT MAP (	read_data 		=> read_data_from_memory,
				address 		=> address_toMemory,--jump memory address by 4
				write_data 		=> read_data_2,
				MemRead 		=> MemRead, 
				Memwrite 		=> MemWrite_buff, 
                clock 			=> clock,  
				reset 			=> reset );
				
				ALU_ctl_o<= ALU_ctl_ob;
				Binput_oo<= Binput_o;
				
	---------------new-----------------
				
	process (reset,clock,next_state,INTR)
	begin
		if(reset='1') then
			pr_state <= fetch;
		elsif (rising_edge(clock)) then
				pr_state <= next_state;
				INTR_buff <= INTR;
		

		end if;
	end process;
	
	
	process (pr_state,next_state ,Instruction_fetch,INTR_buff,reset)
	begin
	if(reset = '1') then 
	 INTA <= '1';
	 GIE_from_hardware <= '1';
	 else	
		case pr_state is
			when fetch => 			
				if INTR_buff = '1' then
					INTA <= '0';
					GIE_from_hardware <= '0';
					Instruction <= "10001100000110010000100000111110"; --- $t9 <= LW(0(0x83E))
					next_state <= jal_state;
				elsif (Instruction_fetch = "00000011011000000000000000001000") then  -- if JR $k1
					Instruction <= Instruction_fetch;
					GIE_from_hardware <= '1';
					next_state <= fetch ;
				else 
					Instruction <= Instruction_fetch;
					next_state <= fetch;
				
				end if;
										
			when jal_state =>	
					Instruction <= "00001111001000000000000000000000"; --- jal ,M($k1
					next_state <= finish_state;
					
			when finish_state =>			
				INTA <= '1' ;
				Instruction <= Instruction_fetch;
				next_state <= fetch;
				
		end case;
	end if;
	
	end process;

END structure;

