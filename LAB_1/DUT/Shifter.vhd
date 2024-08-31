library IEEE;
use ieee.std_logic_1164.all;
--------------------------------------------------------

ENTITY shifter IS
	  GENERIC (n : INTEGER := 8;
		   k : INTEGER := 3);
PORT (
	Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		vout: OUT STD_LOGIC;
		 cout : OUT STD_LOGIC); 
end shifter;

ARCHITECTURE shifter_arch OF shifter IS
	SUBTYPE vector IS STD_LOGIC_VECTOR( n-1 DOWNTO 0);
	type matrix IS ARRAY (k-1 DOWNTO 0) OF vector;
	signal resmat:matrix;
	signal carryVec : std_logic_vector( k-1 downto 0);
	constant zeros : std_logic_vector (n-1 DOWNTO 0 ) := (others => '0');


BEGIN
	resmat(0) <= Y(n-2 downto 0) & zeros(0) when (ALUFN ="000" and X(0)='1') else
		zeros(0) & Y(n-1 downto 1) when (ALUFN ="001" and X(0)='1') else
		Y;
	carryVec(0) <= Y(n-1) when (ALUFN ="000" and X(0)='1') else
		Y(0) when (ALUFN ="001" and X(0)='1') else
		'0';

	 
	title: for i in 1 to k-1 generate
		resmat(i) <= resmat(i-1)(n-2**i - 1 downto 0) & zeros(2**i - 1 downto 0) when (ALUFN ="000" and X(i)='1') else
		zeros(2**i-1 downto 0) & resmat(i-1)(n-1 downto 2**i) when (ALUFN ="001" and X(i)='1') else
		resmat(i-1);

	carryVec(i) <= resmat(i-1)(n-2**i) when (ALUFN ="000" and X(i)='1') else
		resmat(i-1)(2**i-1) when (ALUFN ="001" and X(i)='1') else
		carryVec(i-1);
	end generate;


	s <= resmat(k-1) when ALUFN = "000" or ALUFN = "001"  else (others => '0');
	cout <= carryVec(k-1) when ALUFN = "000" or ALUFN = "001"  else  '0';
	vout <= '0';
END shifter_arch;



