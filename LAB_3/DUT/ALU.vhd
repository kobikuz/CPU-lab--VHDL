library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.sample_package.all;
--------------------------------------------------------------
entity ALU is
		port(

			AB: in STD_LOGIC_VECTOR(15 downto 0);
			--input from control--
			clk : in std_logic;
			Ain :in std_logic;
			Cin :in std_logic;
			OPC : in std_logic_vector(3 downto 0);
			--output to bus--
		    regC   : out STD_LOGIC_VECTOR(15 downto 0);	
			--output to control--
			Cflag : out std_logic;
			Zflag : out std_logic;
			Nflag : out std_logic);
end ALU;

architecture ALU_ARCH of ALU is

	signal regA : STD_LOGIC_VECTOR(15 downto 0);
	signal C : STD_LOGIC_VECTOR(15 downto 0);
	signal B : STD_LOGIC_VECTOR(15 downto 0);
	
	signal Cflag_logic:std_logic;
	signal Nflag_logic: std_logic;
	signal Zflag_logic: std_logic;
	signal res_logic:  STD_LOGIC_VECTOR(15 downto 0);
	signal Cflag_subAdder:std_logic;
	signal Nflag_subAdder: std_logic;
	signal Zflag_subAdder: std_logic;
	signal res_subAdder:  STD_LOGIC_VECTOR(15 downto 0);
	


begin
	
	addsub : AdderSub port map(regA,B,OPC,res_subAdder,Cflag_subAdder,Zflag_subAdder,Nflag_subAdder);
	logicmap : LOGIC port map(regA,B,OPC,res_logic,Cflag_logic,Zflag_logic,Nflag_logic);
	--shifter_nap : Shifter  port map(B,regA,OPC,Cflag_temp,Zflag_temp,Nflag_temp,C);
	
	----- mux flags--------------
	Cflag<= Cflag_subAdder when OPC ="0000" or OPC="0001" else Cflag_logic when OPC = "0010" or OPC = "0011" or OPC ="0100" else unaffected;
	Nflag<= Nflag_subAdder when OPC ="0000" or OPC="0001" else Nflag_logic when OPC = "0010" or OPC = "0011" or OPC ="0100" else unaffected;
	Zflag<= Zflag_subAdder when OPC ="0000" or OPC="0001" else Zflag_logic when OPC = "0010" or OPC = "0011" or OPC ="0100" else unaffected;
	
	C <= res_subAdder when OPC ="0000" or OPC="0001" else res_logic when OPC = "0010" or OPC = "0011" or OPC ="0100" else unaffected;
	
	
	regA <= AB when Ain='1';
	B <= AB when Cin ='1' else (others => '1');
	regC <= C when Cin='1';
	
end ALU_ARCH;


