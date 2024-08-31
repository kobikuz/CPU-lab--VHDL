library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------

entity DQFF is 
   port(
      Clk 	:in std_logic;   
      D 	:in std_logic_vector(5 downto 0);   
	  Q 	:out std_logic_vector(5 downto 0) 
   );
end DQFF;
architecture behav of DQFF is  

begin  
 process(clk)
 begin 
    if(rising_edge(clk)) then
   Q <= D; 
    end if;       
 end process;  
end behav; 