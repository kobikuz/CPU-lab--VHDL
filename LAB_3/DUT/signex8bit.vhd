library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.sample_package.all;
--------------------------------------------------------------
entity signex8bit is
generic( Dwidth: integer:=16);
port( 
		imm : 	in std_logic_vector(7 downto 0 );
		extended1: out std_logic_vector(15 downto 0);
		extended2: out std_logic_vector(15 downto 0)
);
end signex8bit;
--------------------------------------------------------------
architecture behav of signex8bit is
	signal checksign1: std_logic;
	signal checksign2: std_logic;
begin
	checksign1 <= imm(7);
	checksign2 <= imm(3);
	extended1 <= "00000000"&imm when checksign1 = '0' else "11111111"&imm ;
	extended2 <= "000000000000"&imm(3 downto 0) when checksign2 ='0' else "111111111111"&imm(3 downto 0);
end behav;
