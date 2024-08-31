library IEEE;
use ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY LOGIC IS
  GENERIC (n : INTEGER := 8);
PORT (
	Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 vout: OUT STD_LOGIC;
		 cout : OUT STD_LOGIC) ;
END LOGIC;
--------------------------------------------------------
ARCHITECTURE dataflow OF LOGIC IS
	SIGNAL res : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
res <= not Y when ALUFN = "000" else
	X or Y when ALUFN = "001" else
	X and Y when ALUFN = "010" else
	X xor Y when ALUFN = "011" else
	X nor Y	when ALUFN = "100" else
	X nand Y when ALUFN = "101" else
	X xnor Y when ALUFN = "111" else
	unaffected;

s <= res when ALUFN /= "110" else (others=>'0');
cout <= '0'; --carry of boolian  functions always zero
vout <= '0';

END dataflow;
