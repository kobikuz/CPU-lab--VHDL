LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;



ENTITY GPIO IS

	PORT(
			reset   :in   std_logic;
			clock   :in   std_logic;
			datain 	: in  std_logic_vector(7 downto 0);
			address : in  std_logic_vector(4 downto 0);
			SW       :in std_logic_vector(7 downto 0);
			
			A0      : in   std_logic; 
			MemWrite :in std_logic;
			MemRead  :in std_logic;

	
			
			dataout	: out std_logic_vector(7 downto 0);
			hex0    : out std_logic_vector(7 downto 0);
			hex1    : out std_logic_vector(7 downto 0);
			hex2    : out std_logic_vector(7 downto 0);
			hex3    : out std_logic_vector(7 downto 0);
			hex4    : out std_logic_vector(7 downto 0);
			hex5    : out std_logic_vector(7 downto 0);
			LEDR    : out std_logic_vector(7 downto 0)
	
	);
END 	GPIO;

ARCHITECTURE GPIO_a OF GPIO IS

component GPIO_data_bus is
	generic( width: integer:=8 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end component;


signal DataIO :std_logic_vector(7 downto 0);
signal CS : std_logic_vector(6 downto 0);
signal datain_b,D_LED,HEX0_D,HEX1_D,HEX2_D,HEX3_D,HEX4_D,HEX5_D : std_logic_vector(7 downto 0);

signal D_LED_O,HEX0_D_O,HEX1_D_O,HEX2_D_O,HEX3_D_O,HEX4_D_O,HEX5_D_O, dataout_buff : std_logic_vector(7 downto 0);

--signal A0 : std_logic;

begin

datain_b <= datain;
--------------optimizer address decoder-----------------------------

process (address)
begin

case address is 
	
	when "10000" =>  CS <=  "0000001";
	when "10001" =>  CS <=  "0100000";
	when "10010" =>  CS <=  "0010000";
	when "10011" =>  CS <=  "0001000";
	when "10100" =>  CS <=  "1000000";
	
	
	
	--when "1000" =>  CS <=  "0000001"; ----- interupt CS after
	--when "1000" =>  CS <=  "0000001";
	--when "1000" =>  CS <=  "0000001";
	
	when others => CS <= (others => '0');
	
 	END CASE;

end process;


--------------------SW--------------------
MAINBUS: GPIO_data_bus
	port map (
		Dout  => datain_b,
		Din   => dataout_buff,
		en    => MemWrite,
		IOpin => DataIO	
	
	
	
	);
SWbus : GPIO_data_bus
	port map(
	
		Dout  =>  SW,
		en    => MemRead and CS(6),
		IOpin => DataIO	
	);
	
Ledbus :GPIO_data_bus
	port map(
	
		Dout  => D_LED_O ,
		Din   => D_LED ,
		en    => MemRead and CS(0) ,
		IOpin => DataIO	
	);
	
HEX0bus :GPIO_data_bus
	port map(
	
		Dout  => HEX0_D_O,
		Din   => HEX0_D ,
		en    => MemRead and CS(5) and (not A0),
		IOpin => DataIO	
	);
	
HEX1bus :GPIO_data_bus
	port map(
	
		Dout  => HEX1_D_O,
		Din   => HEX1_D ,
		en    => MemRead and CS(5) and (A0),
		IOpin => DataIO	
	);
	
HEX2bus :GPIO_data_bus
	port map(
	
		Dout  => HEX2_D_O,
		Din   => HEX2_D ,
		en    => MemRead and CS(4) and (not A0),
		IOpin => DataIO	
	);
	
HEX3bus :GPIO_data_bus
	port map(
	
		Dout  => HEX3_D_O,
		Din   => HEX3_D ,
		en    => MemRead and CS(4) and A0,
		IOpin => DataIO	
	);
	
HEX4bus :GPIO_data_bus
	port map(
	
		Dout  =>HEX4_D_O ,
		Din   => HEX4_D ,
		en    => MemRead and CS(3) and (not A0),
		IOpin => DataIO	
	);

HEX5bus :GPIO_data_bus
	port map(
	
		Dout  => HEX5_D_O,
		Din   => HEX5_D ,
		en    => MemRead and CS(3) and A0,
		IOpin => DataIO	
	);	

	
	
process (clock,D_LED_O,HEX0_D_O ,HEX1_D_O,HEX2_D_O,HEX3_D_O,HEX4_D_O,HEX5_D_O)
begin
	if(reset = '1') then 
		D_LED_O  <= (others=>'0');
		HEX0_D_O <= (others=>'0');
		HEX1_D_O <= (others=>'0');
		HEX2_D_O <= (others=>'0');
		HEX3_D_O <= (others=>'0');
		HEX4_D_O <= (others=>'0');
		HEX5_D_O <= (others=>'0');		
	elsif ( clock'EVENT ) AND ( clock = '1' ) then 								
		if (cs(0) = '1'	 and MemWrite = '1')then
				D_LED_O  <= D_LED ; 
		elsif (cs(5) = '1' and A0 = '0' and MemWrite = '1')then	
			HEX0_D_O <= HEX0_D;
		elsif  ( cs(5) = '1' and A0 = '1' and MemWrite = '1')then 
			HEX1_D_O <= HEX1_D;
		elsif  ( cs(4) = '1' and A0 = '0' and MemWrite = '1')then 
			HEX2_D_O <= HEX2_D;	
		elsif  ( cs(4) = '1' and A0 = '1' and MemWrite = '1')then 
			HEX3_D_O <= HEX3_D;	
		elsif  ( cs(3) = '1' and A0 = '0' and MemWrite = '1')then 
			HEX4_D_O <= HEX4_D;		
		elsif  ( cs(3) = '1' and A0 = '1' and MemWrite = '1')then 
			HEX5_D_O <= HEX5_D;				
		end if;
			
	end if;
			
end process;

-------------------------------------------
--D_LED_O  <= D_LED  when cs(0) = '1'			     and MemWrite = '1' else (others=>'0') when reset ='1' else D_LED_O;
--HEX0_D_O <= HEX0_D when cs(5) = '1' and A0 = '0' and MemWrite = '1' else (others=>'0') when reset ='1' else HEX0_D_O;
--HEX1_D_O <= HEX1_D when cs(5) = '1' and A0 = '1' and MemWrite = '1' else (others=>'0') when reset ='1' else HEX1_D_O;
--HEX2_D_O <= HEX2_D when cs(4) = '1' and A0 = '0' and MemWrite = '1' else (others=>'0') when reset ='1' else HEX2_D_O;
--HEX3_D_O <= HEX3_D when cs(4) = '1' and A0 = '1' and MemWrite = '1' else (others=>'0') when reset ='1' else HEX3_D_O;
--HEX4_D_O <= HEX4_D when cs(3) = '1' and A0 = '0' and MemWrite = '1' else (others=>'0') when reset ='1' else HEX4_D_O;
--HEX5_D_O <= HEX5_D when cs(3) = '1' and A0 = '1' and MemWrite = '1' else (others=>'0') when reset ='1' else HEX5_D_O;
--process (clock) 
--	BEGIN
--			if ( clock'EVENT ) AND ( clock = '1' ) then 
				LEDR <= D_LED_O;
				hex0 <= HEX0_D_O;
				hex1 <= HEX1_D_O;
				hex2 <= HEX2_D_O;
				hex3 <= HEX3_D_O;
				hex4 <= HEX4_D_O;
				hex5 <= HEX5_D_O;
	--elsif (MemRead ='1') then
				dataout <= dataout_buff;	
			
--			end if;
--end process;


END GPIO_a;