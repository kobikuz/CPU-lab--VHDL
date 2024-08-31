library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 

entity counterpll is 
  port (
    clk, enable : in std_logic;
    q           : out std_logic
  ); 
end counterpll;

architecture rtl of counterpll is
  signal q_int : std_logic_vector(5 downto 0) := "000000"; -- 6-bit counter for counting to 64
  signal clk_div : std_logic := '0'; -- Divided clock signal
begin
  process (clk)
  begin
    if (rising_edge(clk)) then
      if enable = '1' then
        if q_int = "111111" then -- 63 in binary
          q_int <= (others => '0');
          clk_div <= not clk_div; -- Toggle the divided clock signal
        else
          q_int <= q_int + 1;
        end if;
      end if;
    end if;
  end process;
  q <= clk_div; -- Output the divided clock signal
end rtl;
