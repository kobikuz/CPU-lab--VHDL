library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	constant ROWmax : integer := 19; 
end tb;
-------------------------------------------------------------------------------
architecture rtb of tb is
	type mem is array (0 to ROWmax) of std_logic_vector(4 downto 0);
	SIGNAL Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN :  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL ALUout:  STD_LOGIC_VECTOR(n-1 downto 0); -- ALUout[n-1:0]&Cflag
	SIGNAL Nflag,Cflag,Zflag,Vflag:  STD_LOGIC; -- Zflag,Cflag,Nflag
	SIGNAL Icache : mem := (
							"01000","01001","01010","01110","01111","01000","10000","10001","10011","10110",
							"10111","11000","11001","11010","11011","11100","11101","11111","00000","00100");
begin
	L0 : top generic map (n,k,m) port map(Y,X,ALUFN,ALUout,Nflag,Cflag,Zflag,Vflag);
    
	--------- start of stimulus section ----------------------------------------		
        tb_x_y : process
        begin
		  x <= (others => '0');
		  y <= (others => '1');
		  wait for 50 ns;
		  for i in 0 to 39 loop
			x <= x+2;
			y <= y-1;
			wait for 50 ns;
		  end loop;
		  wait;
        end process; --total 50*40=2000ns
		 
		
		tb_ALUFN : process
        begin
		  ALUFN <= (others => '0');
		  for i in 0 to ROWmax loop
			ALUFN <= Icache(i);
			wait for 100 ns;
		  end loop;
		  wait;
        end process; --total 20*100=2000ns
  
end architecture rtb;
