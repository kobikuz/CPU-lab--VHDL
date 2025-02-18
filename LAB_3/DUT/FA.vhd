LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.sample_package.all;
--------------------------------------------------------
ENTITY FA IS
	PORT (xi, yi, cin: IN std_logic;
			  s, cout: OUT std_logic);
END FA;
--------------------------------------------------------
ARCHITECTURE dataflow OF FA IS
BEGIN
	s <= xi XOR yi XOR cin;
	cout <= (xi AND yi) OR (xi AND cin) OR(yi AND cin);
END dataflow;

