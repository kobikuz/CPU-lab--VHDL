library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity single_int is 
   port(
     clr_irq: in std_logic;
	 int_source : in std_logic;
	 eint:in std_logic;
	 irq_A: out std_logic;
	 IFG: out std_logic	 
   );
end single_int;

architecture single_int_a of single_int is

signal irq: std_logic:='0';
signal one : std_logic:= '1';

begin

	process(int_source,clr_irq) is
	begin
	if clr_irq= '1' then
		irq<= '0';
	elsif rising_edge(int_source) then 
		irq <= one;
	end if;
	end process;
	
	irq_A<= irq;
	IFG<= irq and eint;
end single_int_a;

