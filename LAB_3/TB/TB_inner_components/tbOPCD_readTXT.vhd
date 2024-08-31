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
end tb;
---------------------------------------------------------
architecture rtb of tb is
	-------------inputs----------------------------
	signal 	dataOut: std_logic_vector(15 downto 0);	
	signal	IRin:  std_logic;
	signal	RFaddr:  std_logic_vector(1 downto 0);
	-------------outputs----------------------------
	signal	readAddr:  std_logic_vector(3 downto 0);
	signal	writeAddr:  std_logic_vector(3 downto 0);
	signal	IRnow:  std_logic_vector(15 downto 0);
	signal	st:  std_logic;
	signal	ld:  std_logic;
	signal	mov:  std_logic;
	signal	done:  std_logic;
	signal	add:  std_logic;
	signal	sub:  std_logic;
	signal	jmp:  std_logic;
	signal	jc:  std_logic;
	signal	jnc:  std_logic;
	signal	nop:  std_logic;
	-------------gen-ton----------------------------
	signal gen : boolean := true;
	signal don: boolean := false;
	constant read_file_loc : string(1 to 24) := "C:\lab3mems\ITCMinit.txt";
	constant write_file_loc : string(1 to 27) := "C:\lab3mems\OUTPUT TEST.txt";
begin
		L0: opcdecoder port map(dataOut,IRin,RFaddr,readAddr,writeAddr,IRnow,st,ld,mov,done,add,sub,jmp,jc,jnc,nop);
		gen <= not gen after ton;
		process
		
		begin
		dataOut <= x"D104" ,x"D205" after 500 ns,x"C31F" after 1000 ns,x"C401" after 1500 ns,x"C50E" after 2000 ns,x"2113" after 2200 ns,
		x"2223" after 2600 ns,x"8002" after 3000 ns,x"5002" after 3400 ns,x"0640" after 3500 ns ,x"7001" after 3900 ns, x"0600" after 4100 ns;
		IRin <= '1';
		RFaddr <= "00", "01"after 1500 ns, "10" after 3000 ns;
			wait;
		end process;

end rtb;
