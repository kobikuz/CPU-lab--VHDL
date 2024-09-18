library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity int_top_tb is
    constant ROWmax : integer := 80;
end int_top_tb;

architecture int_top_tb_a of int_top_tb is
    -- Constants for test
    constant n : integer := 32;

-- Signal declarations
   Signal  clr_irq:  std_logic_vector(7 downto 0);
	Signal int_source :  std_logic_vector(7 downto 0);
	Signal eint: std_logic_vector(7 downto 0);
	Signal GIE :  std_logic ;
	Signal reset:  std_logic;
	Signal irq_A:  std_logic_vector(7 downto 0);
	Signal IFG:  std_logic_vector(7 downto 0);
	Signal	 TYPE_out :  std_logic_vector(4 downto 0);
	Signal INTR :  std_logic;
begin
int_req_top_a: entity work.int_req_top
port map(
   clr_irq=>clr_irq,
	 int_source=> int_source,
	 eint=> eint,
	 GIE=> GIE, 
	 reset=> reset,
	 irq_A=> irq_A,
	 IFG=> IFG,
	 TYPE_out => TYPE_out,
	 INTR => INTR
);

proc1: process
begin
reset<= '1';
clr_irq<=x"FF";
eint<= X"ff";
wait for  50 ns;
clr_irq<= x"00";
reset<= '0';
wait for 50 ns;
GIE<= '1';
wait for 50 ns;
clr_irq<= "11100000";
wait for 50 ns;
clr_irq<= x"00";
wait for 200 ns;
GIE<= '1';
wait;
end process;

gen_clk : process
		begin
		wait for 100 ns;
int_source<= "11100000";
wait for 100 ns;
int_source<= "00001111";
wait for 100 ns;
wait;
    end process;






end int_top_tb_a;