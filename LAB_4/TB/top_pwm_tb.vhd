library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity top_pwm_tb is
end top_pwm_tb;

architecture arc_top_pwm_tb of top_pwm_tb is
    -- Constants for test
    constant n : integer := 8;
    constant ROWmax: integer := 10;

    -- Signal declarations
    signal Y_i, X_i, ALUout_o : std_logic_vector(n-1 downto 0);
    signal ALUFN_i : std_logic_vector(4 downto 0);
    signal clk, enable, reset : std_logic;
    signal pwm_o : std_logic;
    signal curr_o : std_logic_vector(7 downto 0);
    signal Nflag_o, Cflag_o, Zflag_o, Vflag_o : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    toppwm: entity work.top_pwm
        generic map (
            n => n
        )
        port map (
            Y_i => Y_i,
            X_i => X_i,
            ALUout_o => ALUout_o,
            ALUFN_i => ALUFN_i,
            clk => clk,
            enable => enable,
            reset => reset,
            pwm_o => pwm_o,
            curr_o => curr_o,
            Nflag_o => Nflag_o,
            Cflag_o => Cflag_o,
            Zflag_o => Zflag_o,
            Vflag_o => Vflag_o
        );

    -- Clock generation process
    gen_clk : process
    begin
        clk <= '0';
        enable <= '1';
        reset <= '0';
        wait for 50 ns;
        clk <= not clk;
        wait for 50 ns;
    end process;

    -- ALUFN stimulus process
    tb_ALUFN : process
    begin
        ALUFN_i <= "00000";
        for l in 0 to ROWmax loop
            wait for 50 ns;
        end loop;
        ALUFN_i <= "00001";
        for j in 0 to ROWmax loop
            wait for 50 ns;
        end loop;
        wait;
    end process;

    -- Initial stimulus
    initial_stimulus : process
    begin
        X_i <= "00000010";
        Y_i <= "00000100";
        wait;
    end process;

end arc_top_pwm_tb;
