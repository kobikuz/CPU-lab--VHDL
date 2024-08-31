library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
	constant m: integer := 7;
end tb;
---------------------------------------------------------
architecture my_rtb of tb is
	SIGNAL rst,ena,clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;
	--signal counter: STD_LOGIC_VECTOR (m-1 DOWNTO 0);
	--SIGNAL valid: STD_LOGIC; -- the output of stage 2
	--signal x_1,x_2 :  std_logic_vector(n-1 downto 0);
begin
	--L0 : top generic map (8,7,3) port map(rst,ena,clk,x,DetectionCode,detector,counter,x_1,x_2);
	L0 : top generic map (8,7,3) port map(rst,ena,clk,x,DetectionCode,detector);
    
	------------ start of stimulus section --------------	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		gen_x : process
			variable j : integer := 0;
			variable f : integer := 0;
        begin
		  x <= (others => '0');
		if (j=4 and f=0) then 
			j:= 0;
			f:= 1;
		end if;		
		  DetectionCode <= j;
		  for i in 0 to 11 loop
			wait for 100 ns;
			x <= x+j+1;
		  end loop;
		  j := j+1;
        end process;
		  
		gen_rst : process
        begin
		  rst <= '1','0'  after 100 ns;
		wait for 2200000  ps;
		 rst <= '1' ,'0' after 100 ns;
			wait;
        end process; 
		

		gen_ena : process
        begin
		  ena <='0','1' after 200 ns;
		  wait for 3200000 ps;
		ena <= '0', '1' after 200 ns;
		wait;
        end process;
  
end architecture my_rtb;
