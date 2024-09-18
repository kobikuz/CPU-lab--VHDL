library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity GPIO_data_bus is
	generic( width: integer:=8 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end GPIO_data_bus;

architecture GPIO_data_bus_a of GPIO_data_bus is
begin 

	Din  <= IOpin;
	IOpin <= Dout when(en='1') else (others => 'Z');
	
end GPIO_data_bus_a;