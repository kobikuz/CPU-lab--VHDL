library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--USE work.aux_package.all;

entity timer is
    generic (
        n : integer := 32
    );
    port (	
		BTCNT : in   std_logic_vector(n-1 downto 0);
        BTCCR1, BTCCR0       : in std_logic_vector (n-1 downto 0);
        clkin ,reset,reset_q_b : in std_logic;
		BTCTL : in std_logic_vector(7 downto 0);
		
		BTCL1_o,BTCL0_o : out std_logic_vector(n-1 downto 0);
		
		PWMout      : out std_logic;
		
		set_BTIFG:  out std_logic;

		BTCNT_o:  out std_logic_vector(n-1 downto 0)
		
			-------debug----------------------
		

    );
end timer;

architecture timer_a of timer is


-----------
component counter is 
    port (
        clk     : in std_logic;
		enable  : in std_logic;
        reset_q : in std_logic;
		init_btcnt : in std_logic_vector (31 downto 0);
        q       : out std_logic_vector (31 downto 0)
    );
end component;
------
    signal BTCNT_tmp,q_out,clk_count,pwm_counter    : std_logic_vector (n-1 downto 0) ;
	--thats curr
    signal sout     : std_logic;
    signal reset_q  : std_logic;
	signal actual_clk : std_logic;
	SIGNAL clk0,clk2, clk4,clk8 : std_logic;
	signal clk0_b,clk2_b,clk4_b,clk8_b : std_logic;
	SIGNAL set_BTIFG_TMP: std_logic;
	signal zero :std_logic_vector(31 downto 0) :=(others => '0');
	
	signal BTOUTMD      :  std_logic;
	signal BTOUTEN :  std_logic;
	signal BTSSEL :  std_logic_vector(1 downto 0);
	signal BTHOLD :  std_logic; -- '1' means hold and not count!
	signal BTIP:  std_logic_vector(2 downto 0);
	
	signal BTCL0: std_logic_vector(31 downto 0);
	signal BTCL1: std_logic_vector(31 downto 0);
	

	
	
begin

BTOUTMD<= BTCTL(7);
BTOUTEN<= BTCTL(6);
BTSSEL<= BTCTL(4 DOWNTO 3);
BTHOLD<= BTCTL(5);
BTIP<= BTCTL(2 DOWNTO 0);

BTCL0 <= BTCCR0 when BTOUTEN = '1' else (others => '0');
BTCL1 <= BTCCR1 when BTOUTEN = '1' else (others => '0');



freq_div : counter port  map( 
	clk=>clkin,
	enable => '1',
	reset_q =>reset,
	init_btcnt=>zero,
	q =>clk_count
	);


pwm_logic : counter port  map(
	clk=>actual_clk,
	enable=> BTOUTEN,
	reset_q =>reset_q,
	init_btcnt=>BTCNT,
	q =>pwm_counter
	);
	
IFG:  counter port map(  -- this is what makes the int
	clk=>actual_clk,
	enable=> not BTHOLD,
	reset_q =>reset_q_b,
	init_btcnt=>BTCNT,
	q =>BTCNT_tmp
	);

	
	
clk0_b<=clkin;
clk2_b<=clk_count(1);
clk4_b<=clk_count(2);
clk8_b<=clk_count(3);

	 --ROUTING INT--
	process(BTIP,BTCNT_tmp) is
	begin
	if (BTIP= "000") then
		set_BTIFG_TMP<=BTCNT_tmp(0);
	elsif (BTIP= "001") then
		set_BTIFG_TMP<=BTCNT_tmp(3);
	elsif (BTIP= "010") then
		set_BTIFG_TMP<=BTCNT_tmp(7);
	elsif (BTIP= "011") then
		set_BTIFG_TMP<=BTCNT_tmp(11);
	elsif (BTIP= "100") then
		set_BTIFG_TMP<=BTCNT_tmp(15);
	elsif (BTIP= "101") then
		set_BTIFG_TMP<=BTCNT_tmp(19);
	elsif (BTIP = "110") then
		set_BTIFG_TMP<=BTCNT_tmp(23);
	elsif (BTIP = "111") then
		set_BTIFG_TMP<=BTCNT_tmp(25);
	else set_BTIFG_TMP<= '0';
	end if;
	end process;
	
	--routing clk --
	process(BTSSEL,clk0_b,clk2_b,clk4_b,clk8_b) is
	begin
	if (BTSSEL = "00") then
		actual_clk <= clk0_b;
	elsif (BTSSEL = "01") then
		actual_clk <= clk2_b;
	elsif (BTSSEL = "10") then
		actual_clk <= clk4_b;
	elsif (BTSSEL = "11") then
		actual_clk <= clk8_b;
	else actual_clk <= '0';
	end if;
	end process;


    process (actual_clk, reset,BTOUTMD,BTOUTEN,BTCL1,BTCL0) --pwmout WORKS ON actual_clk
    begin
        if reset = '1' then
            reset_q <= '1';
			if BTOUTMD = '1' then --IM STRAIGHT AWAY OUTPUTING THE INITIAL STATE WITHOUT COUNTING
				sout <= '1';
			elsif BTOUTMD = '0' then
				sout <= '0';
			end if;
        elsif rising_edge(actual_clk) then
            if BTOUTEN = '1' then --enable for counting
                -- PWM logic
                if BTOUTMD = '0' then
                    if pwm_counter < BTCL1 then
                        sout <= '0';
                    elsif pwm_counter < BTCL0 then
                        sout <= '1';					
                    else
							sout <= '0';
							reset_q <= '1';
                    end if;
                elsif BTOUTMD = '1' then
                    if pwm_counter < BTCL1 then
							sout <= '1';
                    elsif pwm_counter < BTCL0 then
							sout <= '0';
                    else
							sout <= '1';
							reset_q <= '1';
                    end if;
                else
                    sout <= '0'; 
                end if;
            end if;  
		end if;			
		if reset_q = '1' then
		reset_q <= '0';
		  end if;
    end process;
	
			

    PWMout <= sout;
	
	set_BTIFG<= set_BTIFG_TMP;

	BTCNT_o<= BTCNT_tmp;

	BTCL1_o <= BTCL1;
	BTCL0_o <= BTCL0;

end timer_a;
