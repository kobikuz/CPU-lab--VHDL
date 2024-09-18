library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity divider_tb is
	constant ROWmax : integer := 1000;

end divider_tb;

architecture divider_tb_a of divider_tb is
    -- Constants for test
    constant N : integer := 32;

    signal    clk      :   STD_LOGIC;
	signal   reset     :   STD_LOGIC;
    signal   enable    :   STD_LOGIC;
    signal    dividend :   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    signal    divisor  :   STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    signal    divIFG   :  STD_LOGIC;
    signal    residue  :  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    signal    quotient :  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	signal    divisor_flag : std_logic;
	
	
	SIGNAL count   : INTEGER RANGE 0 TO N := 0;
    SIGNAL q       : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL r       : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL d       : STD_LOGIC_VECTOR(2*N-1 DOWNTO 0) := (OTHERS => '0');
		
		
component Divider IS
    GENERIC(
        N : INTEGER := 32  
    );
    PORT(
        clk      : IN  STD_LOGIC;
        reset    : IN  STD_LOGIC;
        enable   : IN  STD_LOGIC;
        dividend : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        divisor  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        divIFG   : OUT STD_LOGIC;
        residue  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        quotient : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		count_o   :out INTEGER RANGE 0 TO N := 0;
		 q_o       :out STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
		 r_o       :out STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
		 d_o       :out STD_LOGIC_VECTOR(2*N-1 DOWNTO 0) := (OTHERS => '0')
		
    );
END component;
		
begin
TB_DIVIDER: Divider
	generic map (
	N=> N)
	 port map (
		clk=>clk,
		reset  => reset,
        enable   => enable,
        dividend =>dividend,
        divisor => divisor,
        divIFG  => divIFG,
        residue  =>residue,
        quotient => quotient,
		
		count_o=>count,
		q_o=>q,
		r_o=>r,
		d_o=>d
		);
		
		gen_clk : process
		begin
		clk <= '0';
        reset <= '1';
		--dividend <= (others=>'0');
		--divisor  <= (others=>'0');
		wait for 100 ns;
			reset <= '0';

			
		for i in 0 to ROWmax loop
			clk <= not clk;
			wait for 50 ns;
		end loop;
		
		wait;	
    end process;
	

	
	datain : process
    begin
		divisor_flag <= '0';
		wait for 100 ns;
		
		dividend <= x"00001002";
		divisor <= x"00000005";
		divisor_flag <= '1', '0' after 100 ns;

		
		wait for 6000 ns;
		
		dividend <= x"00001000";
		divisor <= x"00000004";
		divisor_flag <= '1', '0' after 100 ns;

		
		wait for 8000 ns;

		dividend <= x"00001007";
		divisor <= x"00000003";
		divisor_flag <= '1', '0' after 100 ns;
		
		wait for 12000 ns;

		dividend <= x"00009015";
		divisor <= x"00000010";
		divisor_flag <= '1', '0' after 100 ns;
				
		wait for 16000 ns;
		dividend <= x"19999015";
		divisor <= x"00000004";
		divisor_flag <= '1' , '0' after 100 ns;
		
		
	wait;		
    end process;
	
--process(divIFG, reset , clk ,divisor_flag)
--begin
--if (reset = '1')then 
-- enable <= '0';
--elsif(rising_edge(clk)) then
--	if (reset = '0' and divisor_flag = '1') then
	--	enable <= '1';
	--elsif( reset = '0' and divIFG = '1')then
	--	enable <= '0';
	--end if;
--end if;

enable <= '0' when reset = '1' or divIFG= '1' else '1' when divisor_flag = '1';


end divider_tb_a;