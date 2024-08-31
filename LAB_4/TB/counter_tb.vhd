library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is
	
end counter_tb;

architecture counter_tb1 of counter_tb is
   signal  clk, enable,reset_q :  std_logic;
   signal q :  std_logic_vector (7 downto 0);
   
     component counter
    port (
      clk, enable,reset_q : in std_logic;
      q : out std_logic_vector (7 downto 0)
    );
  end component;
  
   begin
       L0 : counter port map (
    clk => clk,
	enable=>enable,
	reset_q=>reset_q,
    q =>q
  );
		  q <= "00000000";
		  reset_q<= '1';
		  gen_clk : process
        begin
		  clk <= '0';
		  reset_q<= '0';
		  enable<= '1';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
end architecture counter_tb1;