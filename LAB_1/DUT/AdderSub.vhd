library IEEE;
use ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY MATHS IS
  GENERIC (n : INTEGER := 8);
PORT (
	Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  cout : OUT STD_LOGIC;
		  vout: OUT STD_LOGIC);
END ENTITY MATHS;
--------------------------------------------------------
ARCHITECTURE dataflow OF MATHS IS
	component FA is
		PORT(
			xi,yi,cin: IN STD_LOGIC;
			s, cout : OUT STD_LOGIC);
	END component;

	signal	 reg :std_logic_vector(n-1 downto 0);
	signal   x2: std_logic_vector(n-1 downto 0);
	signal   y2: std_logic_vector(n-1 downto 0);
	signal   s2: std_logic_vector(n-1 downto 0);
	signal   c2: std_logic;
	signal 	 check_s: STD_LOGIC_VECTOR(n-1 downto 0);
	 
	
BEGIN
	y2 <= (others =>'0') when ALUFN ="010" else y;
	x2 <= not X when  (ALUFN ="010" or ALUFN ="001") else X;
	c2 <= '1'   when (ALUFN = "010" or ALUFN = "001") else '0';
 
	first: FA port map(
		xi => x2(0),
		yi => y2(0),
		cin => c2,
		s => s2(0),
		cout =>reg(0)
	);
	rest:  for i in 1 to n-1 generate
		chain :FA port map(
			xi => x2(i),
			yi => y2(i),
			cin => reg(i-1),
			s => s2(i),
			cout =>reg(i)
	);
	end generate;
	check_s <=  s2 when (ALUFN = "000" or ALUFN = "001" or ALUFN = "010") else (others => '0');
	cout <= reg(n-1) when (ALUFN = "000" or ALUFN = "001" or ALUFN = "010") else '0' ;
	vout <= '1' when (ALUFN = "000" and (X(7) = '0' and Y(7) ='0' and check_s(7)= '1')) else
		'1' when (ALUFN = "000" and (X(7) = '1' and Y(7) ='1' and check_s(7)= '0')) else
		'1' when (ALUFN = "001" and (Y(7) = '0' and X(7) ='1' and check_s(7)= '1')) else
		'1' when (ALUFN = "001" and (Y(7) = '1' and X(7) ='0' and check_s(7)= '0')) else
		'0' ;
 	s <= check_s;
END dataflow;

