library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is 
    port (
        clk     : in std_logic;
        enable  : in std_logic;
        reset_q : in std_logic;
		init_btcnt : in std_logic_vector (31 downto 0);
        q       : out std_logic_vector (31 downto 0)
    );
end counter;

architecture rtl of counter is

    signal q_int : std_logic_vector (31 downto 0);
begin
    process (clk,reset_q)
    begin
        if (reset_q = '1') then 
            q_int <= init_btcnt;
        elsif rising_edge(clk) then
            if enable = '1' then
                q_int <= q_int + 1;
            end if;
        end if;
    end process;
    
    q <= q_int; 
end rtl;
