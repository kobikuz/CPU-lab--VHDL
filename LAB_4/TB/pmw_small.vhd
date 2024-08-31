library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use work.aux_package.all; -- Uncomment if you have an auxiliary package

entity PWM_tb is
    constant ROWmax : integer := 6;
end PWM_tb;

architecture pmwtb of PWM_tb is
    -- Constants for test
    constant n : integer := 8;

    -- Signal declarations
    signal x, y       : std_logic_vector(n-1 downto 0);
    signal ALU20      : std_logic_vector(2 downto 0); -- Adjusted width to match PWM entity
    signal clk, enable, reset : std_logic;
    signal pwm_o      : std_logic;
    signal curr_o     : std_logic_vector (7 downto 0);
    signal Nflag_o, Cflag_o, Zflag_o, Vflag_o: std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.PWM
        generic map (
            n => n
        )
        port map (
            x => x,
            y => y,
            ALU20 => ALU20,
            clk => clk,
            enable => enable,
            reset => reset,
            s_out => pwm_o,
            curr_o => curr_o
            -- Nflag_o, Cflag_o, Zflag_o, Vflag_o are not connected here as they are not part of the original PWM entity
        );

    -- Stimulus process
    gen_clk : process
    begin
        clk <= '0';
        enable <= '1';
        reset <= '0';
        wait for 50 ns;
       for i in 0 to ROWmax loop
			clk <= not clk;
			wait for 50 ns;
		end loop;
		reset <= '1';
		        wait for 50 ns;
					reset <= '0';
					wait for 50 ns;
	   for k in 0 to ROWmax loop
			clk <= not clk;
			wait for 50 ns;
		end loop;
		wait;
		
    end process;

    tb_ALUFN : process
    begin
        ALU20 <= "000";
        for l in 0 to ROWmax loop
            wait for 50 ns;
        end loop;
        wait;
    end process;

    -- Initial stimulus
    initial_stimulus : process
    begin
        x <= "00000010";
        y <= "00000100";
        wait;
    end process;

end pmwtb;
