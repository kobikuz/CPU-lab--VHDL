library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PWM is
    generic (
        n : integer := 8
    );
    port (
        x, y       : in std_logic_vector (n-1 downto 0);
        ALU20      : in std_logic_vector (2 downto 0);
        clk, enable,reset : in std_logic;
		--Cflag_o,Vflag_o : out  std_logic;
        s_out      : out std_logic;
        curr_o     : out std_logic_vector (7 downto 0)
    );
end PWM;

architecture pmw_a of PWM is
    signal xin, yin : std_logic_vector (n-1 downto 0);
    signal curr     : std_logic_vector (7 downto 0) := (others => '0');
    signal sout     : std_logic;
    signal reset_q  : std_logic;
begin
    counter_inst : entity work.counter
        port map (
            clk     => clk,
            enable  => enable,
            reset_q => reset_q,
            q       => curr
        );

    process (clk, reset)
    begin
        if reset = '0' then
           -- xin <= (others => '0');
            --yin <= (others => '0');
            --sout <= '0';
            reset_q <= '1';
			if ALU20 = "001" then
				sout <= '1';
			elsif ALU20 = "000" then
				sout <= '0';
			end if;
        elsif rising_edge(clk) then
            if enable = '1' then
                -- PWM logic
                if ALU20 = "000" then
                    if curr < x then
                        sout <= '0';
                    elsif curr < y then
                        sout <= '1';
                    else
                        sout <= '0';
                        reset_q <= '1';
                    end if;
                elsif ALU20 = "001" then
                    if curr < x then
                        sout <= '1';
                    elsif curr < y then
                        sout <= '0';
                    else
                        sout <= '1';
                        reset_q <= '1';
                    end if;
                else
                    sout <= '0'; -- Default case if ALU20 is not "000" or "001"
                end if;
            end if;  
		end if;			
		if reset_q = '1' then
		reset_q <= '0';
		  end if;
    end process;

    curr_o <= curr;
    s_out <= sout;
	--Cflag_o <= '0';
	--Vflag_o  <= '0';
end pmw_a;
