library IEEE;
use ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY LOGIC IS
  GENERIC (n : INTEGER := 16);
PORT (
	Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 cout : OUT STD_LOGIC;
		 zout : out std_logic;
		 nout : out std_logic

		 );
END LOGIC;
--------------------------------------------------------
ARCHITECTURE dataflow OF LOGIC IS
	SIGNAL res : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal zeros : std_logic_vector(n-1 downto 0);
--	signal z_buff : std_logic;
	
BEGIN
zeros <= (others => '0');

res <=
	X or Y when ALUFN = "0011" else
	X and Y when ALUFN = "0010" else
	X xor Y when ALUFN = "0100" else
	unaffected;
	
--z_buff <= '1' when res = zeros else '0';

s <= res;
cout <= '0' ; 
nout <= res(n-1); 
zout <= '1' when res = zeros else '0' ; 

END dataflow;
