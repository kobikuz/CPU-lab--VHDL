LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-----
ENTITY top_pwm IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT(   
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  clk, enable, reset : in std_logic;
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC;
		  pwm_o : OUT std_logic;
		   curr_o  : out std_logic_vector (7 downto 0)
  ); -- Zflag,Cflag,Nflag,Vflag
END top_pwm;

ARCHITECTURE struct_pwm OF top_pwm IS 
    signal X_buff, Y_buff : std_logic_vector(n-1 downto 0);
    signal ALUin_buff : std_logic_vector(4 downto 0);
    signal x_pwm_in, y_pwm_in : std_logic_vector(n-1 downto 0);
    signal pwm_out : std_logic;
BEGIN
    process (clk)
    begin
        if rising_edge(clk) then
            X_buff <= X_i;
            Y_buff <= Y_i;
            ALUin_buff <= ALUFN_i;
        end if;
    end process;

    x_pwm_in <= X_buff when ALUin_buff(4 downto 3) = "00" else x_pwm_in;
    y_pwm_in <= Y_buff when ALUin_buff(4 downto 3) = "00" else y_pwm_in;

    forth: PWM generic map (n) port map (
        x => x_pwm_in,
        y => y_pwm_in,
        ALU20 => ALUin_buff(2 downto 0),
        clk => clk,
        enable => enable,
        reset => reset,
        s_out => pwm_out,
        curr_o => curr_o
    );



    -- Assign pwm_o based on ALUin_buff(4 downto 3)
    pwm_o <= pwm_out when ALUin_buff(4 downto 3) = "00" else '0';
	Nflag_o<= '0';
	  Cflag_o<= '0';
	  Zflag_o<= '0';
	  Vflag_o<= '0';

END struct_pwm;
