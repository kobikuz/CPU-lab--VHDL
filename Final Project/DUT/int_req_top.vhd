library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity int_req_top is 
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
   
end int_req_top;

architecture int_req_top_a of int_req_top is
--to enter types--

component single_int is 
   port(
     clr_irq: in std_logic;
	 int_source : in std_logic;
	 eint:in std_logic;
	 irq_A: out std_logic;
	 IFG: out std_logic	 
   );
end component;


signal one : std_logic:= '1';
signal pre_intr : std_logic:= '0';
SIGNAL IFG_b:  std_logic_vector(7 downto 0):=(others =>'0');
signal TYPE_REG :std_logic_vector(7 downto 0):=(others =>'0');

begin
	first: single_int port map(
	 clr_irq=>clr_irq(0),
	 int_source => int_source(0),
	 eint=> eint(0),
	 irq_A=> irq_A(0),
	 IFG=> IFG_b(0)
	 );
	
	rest: for i in 1 to 7 generate 
	ints: single_int port map(
	 clr_irq=>clr_irq(i),
	 int_source => int_source(i),
	 eint=> eint(i),
	 irq_A=> irq_A(i),
	 IFG=> IFG_b(i)
	 );
	 end generate;
	 
 IFG <= IFG_b; 
 pre_intr <= IFG_b(0) or IFG_b(1) or IFG_b(2) or IFG_b(3) or IFG_b(4) or IFG_b(5) or IFG_b(6) or IFG_b(7);
 
 INTR<= pre_intr and GIE; 
 
 process(IFG_b,reset, clk) is
 begin
 if reset = '1' then
	TYPE_REG<= (others=>'0');
	--enter UART status error
 elsif (rising_edge(clk)) then
		 if  IFG_b(0)='1' then
			TYPE_REG<= x"08";
		 elsif IFG_b(1)='1' then
				TYPE_REG<= x"0C";
		 elsif IFG_b(2)='1' then
				TYPE_REG<= x"10";
		 elsif IFG_b(3)='1' then
				TYPE_REG<= x"14";
		 elsif IFG_b(4)='1' then
				TYPE_REG<= x"18";
		 elsif IFG_b(5)='1' then
				TYPE_REG<= x"1C";
		 elsif IFG_b(6)='1' then
				TYPE_REG<= x"20";
		 else TYPE_REG<= TYPE_REG;
		end if;
 end if;
 end process;
 
 TYPE_out<= TYPE_REG(5 downto 1);
	 
end int_req_top_a;