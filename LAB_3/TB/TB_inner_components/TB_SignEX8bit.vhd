library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.sample_package.all;
---------------------------------------------------------
entity tb is
	constant Dwidth : integer := 16;
end tb;




---------------------------------------------------------
architecture rtb of tb is

		signal imm :std_logic_vector(7 downto 0 );
		signal extend1 : STD_LOGIC_VECTOR(15 downto 0);
		signal extend2 : STD_LOGIC_VECTOR(15 downto 0);
begin
		L9: signex8bit port map(imm,extend1,extend2);
		process
        begin
		
		imm <= x"12", x"AB" after 500 ns;

		wait;
        end process; 
		
		
end architecture rtb;
