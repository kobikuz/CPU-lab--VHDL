library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	constant ROWmax : integer := 33554432; 
end tb;
-------------------------------------------------------------------------------
architecture rtb3 of tb is
	type mem is array (0 to ROWmax) of std_logic_vector(4 downto 0);
	SIGNAL Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN :  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL clk, enable, reset :  std_logic;
	SIGNAL ALUout:  STD_LOGIC_VECTOR(n-1 downto 0); -- ALUout[n-1:0]&Cflag
	SIGNAL Nflag,Cflag,Zflag,Vflag: STD_LOGIC; -- Zflag,Cflag,Nflag,Vflag
	SIGNAL pwm_out : std_logic;

begin
    L0 : top generic map (n, k, m) port map (
        Y_i => Y,
        X_i => X,
        ALUFN_i => ALUFN,
        clk => clk,
        enable => enable,
        reset => reset,
        ALUout_o => ALUout,
        Nflag_o => Nflag,
        Cflag_o => Cflag,
        Zflag_o => Zflag,
        Vflag_o => Vflag,
        pwm_o => pwm_out
    );
    
	--------- start of stimulus section ----------------------------------------		
		  x <= "00000010";
		  y <= "00000100";

		
	   gen_clk : process
        begin
		  clk <= '0';
		  enable<= '1';
		  reset<= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		tb_ALUFN : process
        begin
		  ALUFN <= "00001";
		  for i in 0 to ROWmax loop
			wait for 100 ns;
		  end loop;
		  wait;
        end process;
  
end architecture rtb3;
