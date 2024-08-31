library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.sample_package.all;
-------------ports of logic----------------------------------------------------------------
ENTITY control IS
	
	PORT (rst_control, ena, clk: in std_logic; 
	------------status----------------------------------
		Cflag : in std_logic;
		Zflag : in std_logic;
		Nflag : in std_logic;
		st: in std_logic;
		ld: in std_logic;
		mov: in std_logic;
		done: in std_logic;
		add: in std_logic;
		sub: in std_logic;
		andf: in std_logic;
		orf: in std_logic;
		xorf:in std_logic;
		--shl: in std_logic;
		jmp: in std_logic;
		jc: in std_logic;
		jnc: in std_logic;
		jn:in std_logic;
		--nop: in std_logic;
	------------control outputs----------------------------
		RFaddr: out std_logic_vector(1 downto 0);
		IRin: out std_logic;
		PCin: out std_logic;
		PCsel: out std_logic_vector(1 downto 0);
		imm1_in: out std_logic; ---8bit
		imm2_in: out std_logic; ---4bit
		OPC: out std_logic_vector(3 downto 0);
		Ain: out std_logic;
		Cin: out std_logic;
		RFin: out std_logic;
		RFout: out std_logic;
		Cout: out std_logic;
		Mem_wr: out std_logic;
		Mem_out: out std_logic;
		Mem_in: out std_logic;
		Message: out string(1 to 4)
		);
		
		
		
END control;
------------------------------------------------------------------------------
ARCHITECTURE FSM OF control IS
	type state is (state0,state1,state2,state3,state4,state5,state6,state7,state8,state9,state10,state11, state_Decode);
	SIGNAL pr_state, next_state: state;
	
------------------------------------------------------------------------------
BEGIN --impementation of logi by the table in lab1_task

	process (rst_control,clk)
	begin
		if(rst_control='1' and ena = '1') then
			pr_state <= state0;
		elsif ((clk'event and clk ='1') and ena ='1') then
			pr_state <= next_state;
		end if;
	end process;
---------------------------------------------------------------------------------------------------------------------	
	process (Cflag,Zflag,Nflag,st,ld,mov,done,add,sub,andf,orf,xorf,jmp,jnc,jc,pr_state)
	begin

		case pr_state is
			when state0 =>
				RFaddr <= "00";
				IRin <= '0';
				PCin <='1';
				PCsel<="00";
				imm1_in <='0';
				imm2_in <='0';
				OPC<= "1111";
				Ain <='0';
				Cin <='0';
				RFin <='0';
				RFout <='0';
				Cout <='0';
				Mem_wr <='0';
				Mem_out <='0';
				Mem_in  <='0';
				next_state <= state1;
				Message<="st 0";
				
			when state1 =>
				RFaddr <= "00";
				IRin <= '1';
				PCin <='0';
				PCsel<="00";
				imm1_in <='0';
				imm2_in <='0';
				OPC<= "1111";
				Ain <='0';
				Cin <='0';
				RFin <='0';
				RFout <='0';
				Cout <='0';
				Mem_wr <='0';
				Mem_out <='0';
				Mem_in  <='0';
				Message<="st 1";
				next_state <= state_Decode;
				
			when state_Decode =>
				Message<="st D";
				if ((add = '1' or sub='1') or (ld ='1' or st='1') or (xorf = '1' or andf = '1' or orf ='1')) then  --add/sub/ld/st
					next_state <= state2;
				
				elsif (mov = '1')then --mov
					next_state <= state3;
				
				elsif (jmp = '1' or jc='1' or jnc ='1' or jn = '1')then 	--jmp
					next_state <= state4;
				
				elsif (done = '1') then 
					next_state <= state7;
				end if;
			
				
			when state2 => --- RB => A 
				RFaddr <= "01";
				IRin <= '0';
				PCin <='0';
				PCsel<="00";
				imm1_in <='0';
				imm2_in <='0';
				OPC<= "1111";
				Ain <='1';
				Cin <='0';
				RFin <='0';
				RFout <='1';
				Cout <='0';
				Mem_wr <='0';
				Mem_out <='0';
				Mem_in  <='0';
				Message<="st 2";
				if ((add= '1' or sub ='1') or (xorf = '1' or andf = '1' or orf ='1'))then
					next_state <= state5;
				elsif(ld = '1' or st ='1') then
					next_state <= state8;
				end if;
				
				
			when state3 => ---- MOV Function : imm => Ra
				RFaddr <= "00";
				IRin <= '0';
				PCin <='0';
				PCsel<="00";
				imm1_in <='1';
				imm2_in <='0';
				OPC<= "1111";
				Ain <='0';
				Cin <='0';
				RFin <='1';
				RFout <='0';
				Cout <='0';
				Mem_wr <='0';
				Mem_out <='0';
				Mem_in  <='0';
				Message<="st 3";
				next_state <= state7;
				
			when state4 => ------ jmp--------------- PC +1 + imm =>PC
				if((jc= '1' and Cflag = '1') or ( jnc ='1' and Cflag = '0') or jmp ='1' or (jn = '1' and Nflag ='1')) then 
					RFaddr <= "00";
					IRin <= '0';
					PCin <='1';
					PCsel<="10";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "1111";
					Ain <='0';
					Cin <='0';
					RFin <='0';
					RFout <='0';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="st 4";
					next_state <= state1;
				else 
					next_state<= state7;
				end if; 

			when state5 =>--------  Rb +- Rc =>C
				if (add = '1')then 
					RFaddr <= "10";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "0000";
					Ain <='0';
					Cin <='1';
					RFin <='0';
					RFout <='1';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="5add";
					
				elsif(sub = '1')then 
					RFaddr <= "10";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "0001";
					Ain <='0';
					Cin <='1';
					RFin <='0';
					RFout <='1';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="5sub";
					
				elsif(andf = '1')then 
					RFaddr <= "10";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "0010";
					Ain <='0';
					Cin <='1';
					RFin <='0';
					RFout <='1';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="5and";
					
				elsif(orf = '1')then 
					RFaddr <= "10";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "0011";
					Ain <='0';
					Cin <='1';
					RFin <='0';
					RFout <='1';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="55or";
					
				elsif(xorf = '1')then 
					RFaddr <= "10";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "0100";
					Ain <='0';
					Cin <='1';
					RFin <='0';
					RFout <='1';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="5xor";
					
				--elsif(shl = '1')then 
				--	RFaddr <= "10";
				--	IRin <= '0';
				--	PCin <='0';
				--	PCsel<="00";
				--	imm1_in <='0';
				--	imm2_in <='0';
				--	OPC<= "0011";
				--	Ain <='0';
				--	Cin <='1';
				--	RFin <='0';
				--	RFout <='1';
				--	Cout <='0';
				--	Mem_wr <='0';
				--	Mem_out <='0';
				--	Mem_in  <='0';
				--	Message<="5shl";
			end if;
				
				
				next_state <= state6;
				
			when state6 => --------- C => Ra
					RFaddr <= "00";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "1111";
					Ain <='0';
					Cin <='0';
					RFin <='1';
					RFout <='0';
					Cout <='1';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="st 6";
					next_state <= state7;
				
				when state7 => ----- pc +1 =>Pc
					
					RFaddr <= "00";
					IRin <= '0';
					PCin <='1';
					PCsel<="01";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "1111";
					Ain <='0';
					Cin <='0';
					RFin <='0';
					RFout <='0';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="st 7";
					next_state <= state1;
				
				
					when state8 => ----- imm+A => C
					
					RFaddr <= "00";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='1';
					OPC<= "0000";
					Ain <='0';
					Cin <='1';
					RFin <='0';
					RFout <='0';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='0';
					Mem_in  <='0';
					Message<="st 8";
			
					next_state <= state9;


					
					
				when state9 => ----- C = > datamem read Address 
					if (ld ='1') then 
						RFaddr <= "00";
						IRin <= '0';
						PCin <='0';
						PCsel<="00";
						imm1_in <='0';
						imm2_in <='0';
						OPC<= "1111";
						Ain <='0';
						Cin <='0';
						RFin <='0';
						RFout <='0';
						Cout <='1';
						Mem_wr <='0';
						Mem_out <='0';
						Mem_in  <='0';
						Message<="ld 9";
						next_state <= state10;
						
					elsif(st='1')then
						RFaddr <= "00";
						IRin <= '0';
						PCin <='0';
						PCsel<="00";
						imm1_in <='0';
						imm2_in <='0';
						OPC<= "1111";
						Ain <='0';
						Cin <='0';
						RFin <='0';
						RFout <='0';
						Cout <='1';
						Mem_wr <='0';
						Mem_out <='0';
						Mem_in  <='1';
						Message<="st_9";
						next_state <= state11;
					end if;
				
				when state10 => ----- Data memory => reg A
					
					RFaddr <= "00";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "1111";
					Ain <='0';
					Cin <='0';
					RFin <='1';
					RFout <='0';
					Cout <='0';
					Mem_wr <='0';
					Mem_out <='1';
					Mem_in  <='0';
					Message<="st10";
					next_state <= state7;
					
				when state11 => ------- RA => DataMemory 

					RFaddr <= "00";
					IRin <= '0';
					PCin <='0';
					PCsel<="00";
					imm1_in <='0';
					imm2_in <='0';
					OPC<= "1111";
					Ain <='0';
					Cin <='0';
					RFin <='0';
					RFout <='1';
					Cout <='0';
					Mem_wr <='1';
					Mem_out <='0';
					Mem_in  <='1';
					Message<="st11";
					next_state <= state7;
					
			end case ;
		end process; 	
END FSM;

