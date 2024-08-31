library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb is
	constant n : integer := 8;
end tb;

architecture rtb of tb is
  component Shifter is
	GENERIC (n : INTEGER := 8);
	PORT ( Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		vout: OUT STD_LOGIC;
		 cout : OUT STD_LOGIC); 
	end component;
	SIGNAL x,y,s : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALU20 : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL cout,vout : STD_LOGIC;
begin
	L0 : Shifter generic map (n) 
		port map(y,x,ALU20,s,vout,cout);


        tb : process
        begin

			x <= ((n-1)=>'0',others => '1');
			y <= (0=>'1',others => '0');
			wait for 50 ns;
			
			for i in 1 to 3 loop
				x <= x-117;
				y <= y+9;
				wait for 50 ns;
			end loop;
			end process tb;
			
			
		tb2 : process
        begin
			ALU20 <= "000","001" after 200 ns, "010" after 400 ns;
			wait;
			end process tb2;
		
end architecture rtb;
