library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top is
	GENERIC (  n : INTEGER := 8;
		   k : INTEGER := 3;   -- k=log2(n)
		   m : INTEGER := 4); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	end component;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      vout,s, cout: OUT std_logic);
	end component;
---------------------------------------------------------	
	component MATHS is
		GENERIC (n : INTEGER := 8);
		PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 vout, cout : OUT STD_LOGIC);
	end component;	
--------------------------------------------------------
	component LOGIC IS
  		GENERIC (n : INTEGER := 8);
		PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 vout,cout : OUT STD_LOGIC);
	END component;
--------------------------------------------------------	
	component shifter IS
	 	 GENERIC (n : INTEGER := 8;
		    	  k : INTEGER := 3);
		PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  	ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
			vout, cout : OUT STD_LOGIC); 
	end component;
	
end aux_package;

