library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity Adress_bus is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end Adress_bus;

architecture Adress_bus_a of Adress_bus is
begin 

	Din  <= IOpin;
	IOpin <= Dout when(en='1') else (others => 'Z');
	
end Adress_bus_a;

