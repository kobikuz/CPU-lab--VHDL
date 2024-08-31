LIBRARY ieee;
USE ieee.std_logic_1164.all;

package aux_package is
-----------------------------------------------------------------
	component top is
		generic (
			n : positive := 8 ;
			m : positive := 7 ;
			k : positive := 3
		); -- where k=log2(m+1)
		port(
			rst,ena,clk : in std_logic;
			x : in std_logic_vector(n-1 downto 0);
			DetectionCode : in integer range 0 to 3;
			detector : out std_logic
			--counter: out  STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			--valid: out STD_LOGIC -- the output of stage 2
			--x_1,x_2 : out std_logic_vector(n-1 downto 0)

		);
	end component;
-----------------------------------------------------------------
	component Adder IS
		GENERIC (length : INTEGER := 8);
		PORT ( a, b: IN STD_LOGIC_VECTOR (length-1 DOWNTO 0);
			cin: IN STD_LOGIC;
            s: OUT STD_LOGIC_VECTOR (length-1 DOWNTO 0);
			cout: OUT STD_LOGIC);
	END component;
-----------------------------------------------------------------






  
  
  
  
end aux_package;

