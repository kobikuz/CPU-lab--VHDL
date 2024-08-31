LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
		--counter : out std_logic_vector(m-1 downto 0);
		--valid:  out STD_LOGIC -- the output of stage 2
		--x_1,x_2 : out std_logic_vector(n-1 downto 0)
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is

	signal internal_1,internal_2 :std_logic_vector(n-1 downto 0); -- stage 1:internal_1 = x-1, internal_2= x-2
	SIGNAL s: STD_LOGIC_VECTOR (n-1 DOWNTO 0);
  	SIGNAL valid: STD_LOGIC; -- the output of stage 2
  	SIGNAL not_b: STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal counter: STD_LOGIC_VECTOR (m-1 DOWNTO 0);
	SIGNAL cout: STD_LOGIC; 
	signal zeros: STD_LOGIC_VECTOR (n-4 DOWNTO 0);
	signal ones: STD_LOGIC_VECTOR (m-1 DOWNTO 0);


begin
	proc1: process(clk,rst,ena)
		begin
		if (rst ='1') then
			internal_1 <= (others => '0');
			internal_2 <= (others => '0');
		elsif (clk'EVENT and clk='1'and ena='1') then
			internal_2 <= internal_1; 
			internal_1 <= x;
		end if;
	end process;
	--x_1 <= internal_1;
	--x_2 <= internal_2;
	--mapping

	addmap: Adder
	generic map (length => n) port map ( 
	a=> internal_1,
	b=>  not_b,
	cin => '1',
	s =>s,
	cout =>cout
	);
	
	not_b <= not internal_2;
	zeros <= (others=> '0');

	proc2: process(DetectionCode,s,zeros) --change to a+not(b)
	begin
		if (DetectionCode = 0  ) then
			if (s = zeros&"001") then 
				valid <= '1' ;
			else 	
			valid <= '0';
			end if;
		elsif (DetectionCode = 1 )  then
			if ( s=zeros&"010") then
			valid <= '1'  ;
			else 	
			valid <= '0';
			end if ;
		elsif (DetectionCode = 2 )  then
			if  (s=zeros&"011") then
			valid <= '1' ;
			else 	
			valid <= '0';
			end if;
		elsif (DetectionCode = 3 ) then
			if (s=zeros&"100") then
			valid <= '1' ;
			else 	
			valid <= '0';
			end if ;
		else 	
			valid <= '0';
		end if;
	end process;
 
	ones <= (others =>'1');
	proc3: process(clk,rst,ena,valid,counter)
	begin
		if (rst='1') then
			counter <= (others =>'0');
			detector <=  '0';
		elsif (clk'EVENT and clk='1' and ena='1') then
			counter <= counter(m-2 downto 0) & valid;
		elsif (counter = ones) then
				detector <= '1';
		else detector <= '0';		
		end if;
		
	end process;
end arc_sys;







