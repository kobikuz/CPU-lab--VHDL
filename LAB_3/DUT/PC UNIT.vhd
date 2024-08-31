library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity PCunit is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	
		clk: in std_logic;
		PCin: in std_logic;
		PCsel: in std_logic_vector(1 downto 0);
		IRjmp: in std_logic_vector(4 downto 0);
		PCout:	out std_logic_vector(Awidth-1 downto 0)
);
end PCunit;
--------------------------------------------------------------
architecture behav of PCunit is


signal NPC: std_logic_vector(Awidth - 1 downto 0);


begin   
	process(clk,PCsel,PCin)  
	begin
		if (PCin = '1') then
			--if (PCsel = "00" and clk'event and clk='1') then
			if (PCsel = "00") then
				NPC <= (others => '0');
			elsif (PCsel = "01" and clk'event and clk='1') then
				NPC <= NPC+1;
			elsif (PCsel = "10" and clk'event and clk='1') then
				NPC <= NPC+IRjmp+1;
			elsif (PCsel = "11" and clk'event and clk='1') then
				NPC <= NPC+0;
			end if;
		elsif (PCin = '0' and clk'event and clk='1') then
			NPC <= NPC+0;
		end if;
	end process;
	
PCout <= NPC(Awidth -1  downto 0);


end behav;
