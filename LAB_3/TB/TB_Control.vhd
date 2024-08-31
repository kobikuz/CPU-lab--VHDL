library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.sample_package.all;

---------------------------------------------------------
entity tb_CTRL is
	generic(ton : time := 50 ns);
end tb_CTRL;
---------------------------------------------------------
architecture rtb of tb_CTRL is
	-------------outputs----------------------------

	SIGNAL rst,ena: std_logic;
	signal clk : std_logic := '1';
----------------------outputs----------------------------
	signal	RFaddr:  std_logic_vector(1 downto 0);
	signal	IRin:  std_logic;
	signal	PCin:  std_logic;
	signal	PCsel:  std_logic_vector(1 downto 0);
	signal	imm1_in:  std_logic;
	signal	imm2_in:  std_logic;
	signal	OPC:  std_logic_vector(3 downto 0);
	signal	Ain:  std_logic;
	signal	Cin:  std_logic;
	signal	RFin:  std_logic;
	signal	RFout:  std_logic;
	signal	Cout:  std_logic;
	signal	Mem_wt: std_logic;
	signal	Mem_out: std_logic;
	signal	Mem_in: std_logic;
----------------------inputs----------------------------
	signal	Cflag :  std_logic;
	signal	Zflag :  std_logic;
	signal	Nflag :  std_logic;
	signal	st:  std_logic;
	signal	ld:  std_logic;
	signal	mov:  std_logic;
	signal	done:  std_logic;
	signal	add:  std_logic;
	signal	sub:  std_logic;
	signal	andf: std_logic;
	signal	orf: std_logic;
	signal	xorf: std_logic;
	signal	jmp:  std_logic;
	signal	jc:  std_logic;
	signal	jnc:  std_logic;
	--signal	nop:  std_logic;	
	signal  Message:  string(1 to 4);
	signal Message2: string(1 to 81):="We see that each state opens spesific controls, in the way we disigned in the FSM"; --<<< NOTE
	
	
	
	

	
begin
		L0: Control port map(rst,ena,clk,Cflag,Zflag,Nflag,st,ld,mov,done,add,sub,andf,orf,xorf,jmp,jc,jnc,RFaddr,IRin,PCin,
		PCsel,imm1_in,imm2_in,OPC,Ain,Cin,RFin,RFout,Cout,Mem_wt,Mem_out,Mem_in,Message);
		clk <= not clk after ton;
		process
			begin 
			wait for 50 ns;
			rst <= '1','0' after 100 ns;
			ena <= '1';
			
			wait for 400 ns;
			
			mov <='0','1' after 100 ns, '0' after 200 ns;
			add <= '0', '1' after 700 ns, '0' after 1400 ns;
			st <= '0','1' after 1400 ns, '0' after 2100 ns;
			ld <= '0','1' after 2100 ns, '0' after 2800 ns;
			sub <= '0','1' after 2800 ns, '0' after 3500 ns;
			andf <= '0','1' after 3500 ns, '0' after 4200 ns;
			orf <= '0','1' after 4200 ns, '0' after 4900 ns;
			xorf<= '0','1' after 4900 ns, '0' after 5600 ns;
			
			
			
			jmp <= '0','1' after 5600 ns, '0' after 6300 ns;
			jc <= '0','1' after 6300 ns, '0' after 7000 ns;
			Cflag <= '0','1' after 6300 ns, '0' after 7000 ns;
			Nflag <='0';
			Zflag <= '0';
			jnc <= '0','1' after 7000 ns, '0' after 7700 ns;
			--nop <= '0','1' after 5600 ns, '0' after 6300 ns;
			done <= '0','1' after 7700 ns, '0' after 8400 ns;
		wait; 
		end process;
	
end rtb;
