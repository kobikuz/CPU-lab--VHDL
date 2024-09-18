LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY peripherials IS
port (
data_in :in std_logic_vector(31 downto 0);
adress_all_in : in std_logic_vector (31 downto 0);
data_out :OUT std_logic_vector(31 downto 0);
clk,reset,MemRead,MemWrite,machine_clk : in std_logic;
PWMout : out std_logic;

INTR_o        : out std_logic;
port_key     : in std_logic_vector(2 downto 0);
GIE          : in std_logic;
INTA_in 	 :in  std_logic;
-----------debug-----------------------
IFG_oo       : out std_logic_vector(7 downto 0);
TYPE_oo      : out std_logic_vector(4 downto 0);
irq_clear_o  : out std_logic_vector(7 downto 0);
eint_o		 : out std_logic_vector(7 downto 0);
q_o: out std_logic_vector(31 downto 0)
--r_o: out std_logic_vector(31 downto 0)
);

end peripherials;


architecture peripherials_a of peripherials is

signal dataout_buff  : std_logic_vector(31 downto 0);
signal DATA_IO 		: std_logic_vector(31 downto 0);
signal 	adress_in : std_logic_vector(6 downto 0); --11,5,4,3,2,1,0
signal CS : std_logic_vector (16 downto 0);




--------clk signals------------------------------
signal datafrom_clk		: std_logic_vector(31 downto 0);
signal datato_clk_buff	: std_logic_vector(31 downto 0);
signal datato_clk	: std_logic_vector(31 downto 0);

signal BTCNT            : std_logic_vector(31 downto 0);
signal BTCCR0			: std_logic_vector(31 downto 0);
signal BTCCR1			: std_logic_vector(31 downto 0);
signal BTCTL			: std_logic_vector(7 downto 0);
signal BTCNT_o			: std_logic_vector (31 downto 0);
signal pwm_out,reset_q_b	: std_logic;

-------int signals------------------------------

signal datafrom_int		: std_logic_vector(31 downto 0);
signal datato_int_buff	: std_logic_vector(31 downto 0);
signal datato_int	: std_logic_vector(31 downto 0);

signal   clr_irq:  std_logic_vector(7 downto 0);
signal	 int_source :  std_logic_vector(7 downto 0);
signal	 eint: std_logic_vector(7 downto 0);
signal	 irq_A:  std_logic_vector(7 downto 0);
signal	 IFG:  std_logic_vector(7 downto 0);
signal	 TYPE5bit :  std_logic_vector(4 downto 0);
signal   TYPE_out :  std_logic_vector(32 downto 0);

signal	 INTR :  std_logic := '0';




-------divider signals-------------------------------

signal datafrom_div		: std_logic_vector(31 downto 0);
signal datato_div_buff	: std_logic_vector(31 downto 0);
signal datato_div		: std_logic_vector(31 downto 0);
signal enable_div       : STD_LOGIC;
signal residue  		: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal quotient 		: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal divisor			: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal dividend			: STD_LOGIC_VECTOR(31 DOWNTO 0);



------port keys signals----------------------------------
signal datafrom_key		: std_logic_vector(31 downto 0);



---------------------IFG signals-----------------------------
signal BTIFG			: std_logic;
signal divIFG  			: STD_LOGIC;
signal IFG_key1			:std_logic;
signal IFG_key2			:std_logic;
signal IFG_key3			:std_logic;













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
        quotient : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END component;

component timer is
    generic (
        n : integer := 32
    );
    port (	
		BTCNT : in   std_logic_vector(n-1 downto 0);
        BTCCR1, BTCCR0       : in std_logic_vector (n-1 downto 0);
        clkin ,reset,reset_q_b : in std_logic;
		BTCTL : in std_logic_vector(7 downto 0);
		
		PWMout      : out std_logic;
		
		set_BTIFG:  out std_logic;

		BTCNT_o:  out std_logic_vector (n-1 downto 0)

    );
end component;




component int_req_top is 
   port(
     clk     : in std_logic;
     clr_irq: in std_logic_vector(7 downto 0);
	 int_source : in std_logic_vector(7 downto 0);
	 eint:in std_logic_vector(7 downto 0);
	 GIE : in std_logic ;
	 reset: in std_logic;
	 irq_A: out std_logic_vector(7 downto 0);
	 IFG: out std_logic_vector(7 downto 0);
	 TYPE_out : out std_logic_vector(4 downto 0);
	 INTR : out std_logic
   );
 
end component;

component data_bus_int is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end component;

component add_bus_int is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end component;






begin



---------------BUS PORT MAPS -----------------------------------



bus_data_to_IO : data_bus_int port map (   ---  Central bus  - interruptIO bus connection
Dout => data_in,
en   => MemWrite, -- maybe add  (or one of the CS is one)
Din  => dataout_buff, ---- the data that will be send from IO to CPU 
IOpin => DATA_IO
);


bus_data_KEY : data_bus_int port map (

	Dout => datafrom_key,
	en   => CS(0) and MemRead ,

	IOpin => DATA_IO
);

bus_data_CLK : data_bus_int port map (
Dout => datafrom_clk,
en   => CS(7) and MemRead ,
Din  => datato_clk_buff, 
IOpin => DATA_IO
);


bus_data_to_divider : data_bus_int port map (
Dout => datafrom_div,
en   => MemRead and (CS(12) or CS(13)), 
Din  => datato_div_buff, 
IOpin => DATA_IO
);


bus_data_to_int : data_bus_int port map ( ---- data to interrupt controler
Dout => datafrom_int,
en   => MemRead and (CS(15) or CS(16)), 
Din  => datato_int_buff, 
IOpin => DATA_IO
);


--------------- Peripherials IO -----------------



timar : timer port map (
		BTCNT => BTCNT,
        BTCCR1=> BTCCR1,
		BTCCR0 => BTCCR0,
        clkin => machine_clk,
		reset => reset,
		BTCTL => BTCTL,
		PWMout  => pwm_out, 
		set_BTIFG=>BTIFG,
		BTCNT_o=> BTCNT_o,
		reset_q_b=>reset_q_b
);
 
div : Divider port map(

        clk      => machine_clk,
        reset    =>reset,
        enable   => enable_div, 
        dividend =>	dividend,
        divisor  =>	divisor,
        divIFG   => DIVIFG,
        residue  => residue,
        quotient => quotient


); 
int : int_req_top port map(
	 clk => clk,
     clr_irq => clr_irq,
	 int_source => int_source,
	 eint => eint,
	 GIE => GIE,
	 reset => reset,
	 irq_A => irq_A,
	 IFG =>IFG,
	 TYPE_out => Type5bit,
	 INTR => INTR
);

adress_in<= adress_all_in(11)&adress_all_in(5 downto 0);

process (adress_in)
begin
case adress_in is 
	
	when "1010100" =>  CS <=  "00000000000000001"; --key1
	--when "1010101" =>  CS <=  "00000000000000010";--key2
	--when "1010110" =>  CS <=  "00000000000000100";--key3
	when "1011000" =>  CS <=  "00000000000001000";--uctl
	when "1011001" =>  CS <=  "00000000000010000";--rxbf
	when "1011010" =>  CS <=  "00000000000100000";--txbf
	when "1011100" =>  CS <=  "00000000001000000";--btctl
	when "1100000" =>  CS <=  "00000000010000000";--btcnt
	when "1100100" =>  CS <=  "00000000100000000";--btccr0
	when "1101000" =>  CS <=  "00000001000000000";--btccr1
	when "1101100" =>  CS <=  "00000010000000000";--dividend
	when "1110000" =>  CS <=  "00000100000000000";--divisor
	when "1110100" =>  CS <=  "00001000000000000";--quotient
	when "1111000" =>  CS <=  "00010000000000000";--residue
	when "1111100" =>  CS <=  "00100000000000000";--IE
	when "1111101" =>  CS <=  "01000000000000000";--ifg
	when "1111110" =>  CS <=  "10000000000000000";--type
		
	when others => CS <= (others => '0');
	
 	END CASE;

end process;
















process (CS ,MemWrite,MemRead,datato_int_buff,datato_clk_buff,quotient,residue,TYPE5bit,clk)
begin
	if (reset = '1') then
		BTCTL 		<= x"20";
		BTCNT 		<= (others => '0');
		BTCCR0		<= (others => '0');
		BTCCR1		<= (others => '0');
		dividend	<= (others => '0');
		divisor		<= (others => '0');
		--int_source <=  (others =>'0');
		enable_div <= '0';

	elsif(clk'event and clk = '1') then 
	

		
		if (divIFG = '1') then
			enable_div <= '0';
			
		--elsif (CS(0) = '1' and MemRead = '1') then
		--	datafrom_key <= x"0000000"&IFG_key3&IFG_key2&IFG_key1&reset;
		
		----------------clk----------------
		elsif (CS(6) = '1' and MemWrite = '1') then
			BTCTL <= datato_clk_buff(7 downto 0);
		
		
		elsif (CS(7) = '1' and MemWrite = '1') then
			BTCNT <= datato_clk_buff;		
	--	elsif (CS(7) = '1' and MemRead = '1') then
	--		datafrom_clk <= BTCNT_o;

		
		elsif (CS(8) = '1' and MemWrite = '1') then
			BTCCR0 <= datato_clk_buff;
			
		elsif (CS(9) = '1' and MemWrite = '1') then
			BTCCR1 <= datato_clk_buff;
			
		---------divider---------------------
		elsif (CS(10) = '1' and MemWrite = '1') then			
			dividend <= datato_div_buff;	
		elsif (CS(11) = '1' and MemWrite = '1') then
			divisor <= datato_div_buff ;
			enable_div<= '1';

		--elsif (CS(12) = '1' and MemRead = '1') then
		--	datafrom_div <= quotient;
		--elsif (CS(13) = '1' and MemRead = '1') then
		--	datafrom_div <= residue;
			
		---------------int-------------------
		elsif (CS(14) = '1' and MemWrite = '1') then --- IE
			eint <= datato_int_buff(7 downto 0);
			
		--elsif (CS(15) = '1' and MemRead ='1' ) then
			--datafrom_int <= x"000000"&IFG(7 downto 0);
		
		--elsif (CS(16) = '1' and MemRead = '1') then
		--	datafrom_int <= x"000000"&"00" & TYPE5bit(4 downto 0)&"0";

	
	
		end if ;
	
	
	
	end if;
	
end process;



datafrom_int <= x"000000"&"00" & TYPE5bit(4 downto 0)&"0" when  CS(16) = '1' and MemRead = '1' else x"000000"&IFG(7 downto 0)
when CS(15) = '1' and MemRead ='1' else (others => '0') ;

datafrom_div <= quotient when CS(12) = '1' and MemRead = '1' else residue when CS(13) = '1' and MemRead = '1' else(others => '0') ;

datafrom_clk <= BTCNT_o when CS(7) = '1' and MemRead = '1'  else (others => '0');

datafrom_key <= x"0000000"&IFG_key3&IFG_key2&IFG_key1&reset when CS(0) = '1' and MemRead = '1' else (others => '0');

process (INTA_in,TYPE5bit,clr_irq,clk)
begin
	if (reset = '1')then 
		clr_irq <= (others => '1');
	elsif(INTA_in = '0' ) then
		 if TYPE5bit = "00100" then
				clr_irq(0)<= '1';
		 elsif TYPE5bit = "00110" then
				clr_irq(1)<= '1';
		 elsif TYPE5bit = "01000" then
				clr_irq(2)<='1';
		 elsif TYPE5bit = "01010" then
				clr_irq(3)<='1';
		 elsif TYPE5bit = "01100" then
				clr_irq(4)<='1';
		 elsif TYPE5bit = "01110" then
				clr_irq(5)<='1';
		 elsif TYPE5bit = "10000" then
				clr_irq(6)<= '1';
		 else clr_irq<= clr_irq;
		end if;

	elsif  (rising_edge(clk))then
		if (clr_irq(0) = '1') then 
			clr_irq(0) <= '0';
		end if; 
		if (clr_irq(1) = '1') then 
			clr_irq(1) <= '0';
		end if; 
		if (clr_irq(2) = '1') then 
			clr_irq(2) <= '0';
		end if; 
		if (clr_irq(3) = '1') then 
			clr_irq(3) <= '0';
		end if; 
		if (clr_irq(4) = '1') then 
			clr_irq(4) <= '0';
		end if; 
		if (clr_irq(5) = '1') then 
			clr_irq(5) <= '0';
		end if; 
		if (clr_irq(6) = '1') then 
			clr_irq(6) <= '0';
		end if; 
		if (clr_irq(7) = '1') then 
			clr_irq(7) <= '0';
		end if; 
	
	end if;

end process;


 IFG_key1 <=not port_key(0);
 IFG_key2 <=not port_key(1);
 IFG_key3 <=not port_key(2);
 

 
 data_out <= dataout_buff when MemRead = '1';
 

 int_source<= (others =>'0') when reset = '1' else '0'& divIFG & IFG_key3 & IFG_key2 & IFG_key1 & BTIFG & "00";
 
 PWMout <= pwm_out;
 
 INTR_o <= INTR;
 -------debug-----------------------
 IFG_oo <= IFG;
 TYPE_oo <= TYPE5bit;
 irq_clear_o <= clr_irq;
 eint_o <= eint;
 reset_q_b <= '1' when clr_irq(2) = '1' else '0';
 q_o <=quotient;
 --r_o<=residue;
 
end peripherials_a;
