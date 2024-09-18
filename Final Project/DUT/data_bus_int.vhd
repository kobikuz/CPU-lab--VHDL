library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity data_bus_int is
	generic( width: integer:=31 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end data_bus_int;

architecture data_bus_int_a of data_bus_int is
begin 

	Din  <= IOpin;
	IOpin <= Dout when(en='1') else (others => 'Z');
	
end data_bus_int_a;