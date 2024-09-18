library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counterpll is 
    port (
        clk     : in std_logic;
        enable  : in std_logic;
        reset_q : in std_logic;
        q       : out std_logic_vector (7 downto 0)
    );
end counterpll;

architecture rtl of counterpll is
    signal q_int : std_logic_vector (31 downto 0) := x"00000000";
begin
    process (clk)
    begin
        if (reset_q = '1') then 
            q_int <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                q_int <= q_int + 1;
            end if;
        end if;
    end process;
    
    q <= q_int(24 downto 17); --divide by 18- was 12 to 5
end rtl;
