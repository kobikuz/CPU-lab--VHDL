library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.sample_package.all;

---------------------------------------------------------
entity tb is
	generic(ton : time := 50 ns);
	constant Dwidth : integer := 16;
	constant Awidth : integer := 4;
	constant dept:  integer := 64;
end tb;
---------------------------------------------------------
architecture rtb of tb is
	-------------inputs----------------------------
	signal clk:  std_logic;
	signal PCin:  std_logic;
	signal PCsel:  std_logic_vector(1 downto 0);
	signal IRjmp: std_logic_vector(4 downto 0);
	-------------outputs----------------------------
	signal PCout:	 std_logic_vector(Awidth-1 downto 0);

	
begin
		L0: PCunit port map(clk,PCin,PCsel,IRjmp,PCout);
		gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		process
		begin
		PCin <= '1','0' after 850 ns,'1' after 1450 ns;
		wait;
		end process;
		
		process
		begin
		IRjmp <= "00000", 
		"11101" after 650 ns, --jump by -3
		"00000" after 750 ns;
		
		PCsel <= "00", 
		"01" after 150 ns, --start incr
		"10" after 650 ns, --jump here
		"01" after 750 ns, --keep incr
		"10" after 1050 ns,--jump here (but PCin is off, and we are frozen)
		"01" after 1150 ns;--keep incr
		wait;
		end process;
		
end rtb;
