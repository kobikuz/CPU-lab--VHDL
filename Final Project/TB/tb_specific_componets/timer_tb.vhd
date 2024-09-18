library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer_tb is
    constant ROWmax : integer := 10000000;
end timer_tb;

architecture timer_tb of timer_tb is
    -- Constants for test
		constant n : integer := 32;

-- Signal declarations
		signal BTCNT :    std_logic_vector(n-1 downto 0);
        signal BTCCR1, BTCCR0       :  std_logic_vector (n-1 downto 0);
        signal clkin ,reset :  std_logic;
		signal BTCTL :  std_logic_vector(7 downto 0);
		
		signal PWMout      :  std_logic;
		
		signal set_BTIFG:   std_logic;

		signal BTCNT_o:   std_logic_vector (n-1 downto 0);
		signal enable   : std_logic;
		signal BTCL1,BTCL0 :  std_logic_vector(n-1 downto 0);


component timer is
    generic (
        n : integer := 32
    );
    port (	
		BTCNT : in   std_logic_vector(n-1 downto 0);
        BTCCR1, BTCCR0       : in std_logic_vector (n-1 downto 0);
        clkin ,reset : in std_logic;
		BTCTL : in std_logic_vector(7 downto 0);
		
		BTCL1_o,BTCL0_o : out std_logic_vector(n-1 downto 0);
		
		PWMout      : out std_logic;
		
		set_BTIFG:  out std_logic;

		BTCNT_o:  out std_logic_vector (n-1 downto 0)
		
			-------debug----------------------
		

    );
end component;
		
begin

	bla :timer port map (		
		BTCNT => BTCNT,
         BTCCR1 =>BTCCR1,
		 BTCCR0  =>BTCCR0,
         clkin   => clkin,
		 reset =>reset,
		 BTCTL =>BTCTL,
		 
		 
		 PWMout  => PWMout,
		
		 set_BTIFG => set_BTIFG,

		 BTCNT_o=>BTCNT_o,
		
		 BTCL1_o =>BTCL1,
		 
		 BTCL0_o =>BTCL0
		 
		);
		
		gen_clk : process
		begin
		clkin <= '0';

		wait for 100 ns;
		while enable loop 
			clkin <= not clkin;
			wait for 50 ns;
		end loop;
		wait;	
    end process;
	
	    tb_ALUFN : process
    begin

		BTCNT <= (others=> '0');
        BTCCR1<= (others=> '0'),  x"000000FA" after 300 ns; 
        BTCCR0<= (others=> '0'), x"000003E8" after 200 ns; 
		reset <= '1', '0' after 100 ns;
		BTCTL <= x"00", x"27" after 100 ns,x"47" after 400 ns;
		enable <='1';
		
		wait;
		
    end process;
	
	

end timer_tb;