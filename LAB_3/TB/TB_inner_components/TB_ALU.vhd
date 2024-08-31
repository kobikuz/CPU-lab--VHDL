library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.sample_package.all;
---------------------------------------------------------
entity tb is
	constant Dwidth : integer := 16;
	constant Awidth : integer := 4;
end tb;
---------------------------------------------------------
architecture rtb of tb is

		
		SIGNAL OPC : STD_LOGIC_VECTOR(3 downto 0);
		SIGNAL AB,regC : STD_LOGIC_VECTOR(15 downto 0);
		signal Cflag : STD_LOGIC :='0';
		signal Zflag : STD_LOGIC :='0';
		signal Nflag : STD_LOGIC :='0';
		SIGNAL clk,Ain,Cin : STD_LOGIC;

begin
		L9: ALU port map(AB,clk,Ain,Cin,OPC,regC,Cflag,Zflag,Nflag);
		
		
		process
        begin
		
		wait for 50 ns;
		AB <= x"FFFF",x"0008" after 100 ns, x"000A" after 400 ns,x"000C" after 500 ns, x"0006" after 600 ns,x"0006" after 700 ns, x"0123" after 800 ns,x"0008" after 900 ns, x"000A" after 1000 ns,x"000C" after 1100 ns,
		x"0006" after 1200 ns,x"0006" after 1300 ns, x"1234" after 1400 ns,x"0006" after 1500 ns, x"0123" after 1600 ns,x"0008" after 1700 ns;
		OPC<="0000", "0001" after 400 ns , "0010" after 800 ns,"0100" after 1200 ns, "0011" after 1600 ns;
		Ain <='1','0' after 100 ns,'1' after 200 ns,'0' after 300 ns,'1' after 400 ns, '0' after 500 ns , '1' after 600 ns,'0' after 700 ns,'1' after 800 ns,'0' after 900 ns, '1' after 1000 ns,
		'0' after 1100 ns,'1' after 1200 ns, '0' after 1300 ns , '1' after 1400 ns,'0' after 1500 ns,'1' after 1600 ns,'0' after 1700 ns;
		Cin <='0';
		wait for 100 ns;
		Cin <='1','0' after 100 ns,'1' after 200 ns,'0' after 300 ns,'1' after 400 ns, '0' after 500 ns , '1' after 600 ns,'0' after 700 ns,'1' after 800 ns,'0' after 900 ns, '1' after 1000 ns,
		'0' after 1100 ns,'1' after 1200 ns, '0' after 1300 ns , '1' after 1400 ns,'0' after 1500 ns,'1' after 1600 ns,'0' after 1700 ns;
		wait;
        end process; 
		
		gen_clk : process
        begin
			clk <= '0';
			wait for 50 ns;
			clk <= not clk;
			wait for 50 ns;
        end process;
		
end architecture rtb;
