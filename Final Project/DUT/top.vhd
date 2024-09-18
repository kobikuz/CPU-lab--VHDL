				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY top IS
generic (
	k : integer := 10 -- 10 for Quartus, 8 for ModelSim 
);
port(
		----------INPUTS----------
		Clkin:   IN STD_LOGIC;
		PORT_SW: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		PORT_KEYS:     in std_logic_vector (2 downto 0);
		reset:   IN std_logic;
		
		----------OUTPUTS----------
		HEX01_OUT,HEX23_OUT,HEX45_OUT: OUT STD_LOGIC_VECTOR(13 downto 0);
		LEDR: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		PWMout: out std_logic;
		
		
		-------debug OutPuts------------
		
		--PC						 : OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		Instruction_out	   		 : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
		adress_from_cpu_o   	 : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		DATA_from_cpu_o	    	 : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		--DATA_from_gpio_top_o	 : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		DATA_from_peripherials_o : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			
		IFG_oo       : out std_logic_vector(7 downto 0);
		--TYPE_oo      : out std_logic_vector(4 downto 0);
		irq_clear_o  : out std_logic_vector(7 downto 0);
		eint_o       : out std_logic_vector(7 downto 0);
		
		jal_address_out : out std_logic_vector(31 downto 0);
		q: out std_logic_vector(31 downto 0);
		--r: out std_logic_vector(31 downto 0);
			
		
		Memwrite_out_o,Memread_out_o 	: OUT 	STD_LOGIC ;
		GIE_o,INTR_o,INTA_o 			: out std_logic;
		
		data_from_buss_enable_o : out std_logic

		
	


		




);
end top;


ARCHITECTURE behavior OF top IS

COMPONENT MIPS
		generic(
			k : integer -- 10 for Quartus, 8 for ModelSim 
		);
	PORT( reset, clock					: IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out, Memwrite_out,Memread_out , 
		Regwrite_out					: OUT 	STD_LOGIC ;
		Binput_oo : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SHF_RES_o		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_ctl_o	: 	OUT	 STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		
			
			
		R8          : out   std_logic_vector(7 downto 0);
		R9          : out   std_logic_vector(7 downto 0);
		R10          : out   std_logic_vector(7 downto 0);
		R11          : out   std_logic_vector(7 downto 0);

		read_data_From_bus 				: in STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		-------------------new------------------------------------
		GIE            :out std_logic;
		INTA_o         :out std_logic;
		INTR           :in  std_logic;
		jal_address_out : out std_logic_vector(31 downto 0);
		data_from_buss_enable_o : out std_logic
		
		);
   END COMPONENT;
   
   
   COMPONENT GPIO IS

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
END 	COMPONENT; 


component peripherials IS
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

end component;
   
 
component To7seg IS
  PORT (    
			BCDin: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      Hex7seg: OUT STD_LOGIC_VECTOR(13 downto 0));
      
END component;
 
component CounterEnvelope is 
  port (
    Clk, En : in std_logic;
    Qout    : out std_logic_vector(7 downto 0)
  ); 
end component;




   COMPONENT Adress_bus is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end COMPONENT;


COMPONENT data_bus is
	generic( width: integer:=32 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end COMPONENT;


SIGNAL DATA_from_cpu,data_buff_tocpu,data_buff_toIO,data_buff_to_peripherials,DATA_from_peripherials : std_logic_vector(31 DOWNTO 0);
signal DATA_from_gpio : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL adress_from_cpu,adress_to_cpu : std_logic_vector(31 DOWNTO 0);
signal DATA_IO,ADD_IO : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal CEclk: std_logic_vector(7 downto 0);
signal DATA_from_gpio_top : std_logic_vector(31 downto 0);
signal single_clock : std_logic;
signal read_from_sw :std_logic;

signal clock_to_components : std_logic;

-------------------control signals ----------------------------
signal Memwrite,MemRead : STD_LOGIC;
SIGNAL HEX01_IN,HEX23_IN,HEX45_IN :STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL hex0,hex1,hex2,hex3,hex4,hex5 : std_logic_vector(7 downto 0);
SIGNAL GIE , INTA , INTR : STD_LOGIC;
   
BEGIN

	convert_HEX01 : To7seg PORT map(HEX01_IN,HEX01_OUT);
	convert_HEX23 : To7seg PORT map(HEX23_IN,HEX23_OUT);
	convert_HEX45 : To7seg PORT map(HEX45_IN,HEX45_OUT);

PLLS: CounterEnvelope port map (
clk => Clkin,
en=> '1',
Qout => CEclk
);



MIP: MIPS
  	generic map(k=>k)
	PORT MAP(
		  clock  => clock_to_components,    
		  --clock  => Clkin,  
		  reset  =>not reset,        		  
		  Memwrite_out =>Memwrite,                 
		  read_data_2_out => DATA_from_cpu,
		  Memread_out=>MemRead,
		  ALU_result_out=>adress_from_cpu,
		  read_data_From_bus => data_buff_tocpu,
		 
		  
		  
		  --PC=>PC,
		  --write_data_out=>write_data_out,
		  Instruction_out=>Instruction_out,
		  
				
				
		GIE  =>GIE,         
		INTA_o =>INTA,     
		INTR   => INTR,
		jal_address_out =>jal_address_out,
		data_from_buss_enable_o =>		data_from_buss_enable_o 

		  


	);
	
gpio_port : GPIO
	PORT MAP (		
			reset  => not reset,
			clock => clock_to_components,
			--clock => Clkin,
			datain 	=> data_buff_toIO(7 downto 0),
			address=> adress_from_cpu(11)&adress_from_cpu(5)&adress_from_cpu(4)&adress_from_cpu(3)&adress_from_cpu(2),
			SW       =>PORT_SW,			
			A0      => adress_from_cpu(0),
			MemWrite =>Memwrite,
			MemRead  =>MemRead,			
			dataout	=> DATA_from_gpio,
			hex0    => hex0,
			hex1    => hex1,
			hex2     => hex2,
			hex3     => hex3,
			hex4    => hex4,
			hex5     => hex5,
			LEDR     => LEDR

	);
	
peripherials_port : peripherials
	port map (
		data_in 		=> data_buff_to_peripherials,
		adress_all_in	=> adress_from_cpu,
		data_out	    => DATA_from_peripherials,
		clk				=>  clock_to_components,
		--clk				=>  Clkin,
		machine_clk     => Clkin,
		reset			=> not reset,
		MemRead			=> MemRead,
		MemWrite		=> MemWrite,
		PWMout 			=> PWMout,
		INTR_o  		=>INTR,
		port_key		=> PORT_KEYS,
		GIE       		=>GIE,
		INTA_in 		=>INTA,
		IFG_oo          =>IFG_oo,
		--TYPE_oo 		=>TYPE_oo,
		irq_clear_o		=> irq_clear_o,
		eint_o			=>eint_o,
		q_o=>q
		--r_o=>r
	
	
	);

CPU_DATA_BUS :	data_bus
	PORT MAP(
	
	Dout => DATA_from_cpu,
	en => MemWrite,
	Din=> data_buff_tocpu,
	IOpin=> DATA_IO
	
	);
	
IO_DATA_BUS :	data_bus
	PORT MAP(
	
	Dout=>DATA_from_gpio_top,
	en=> (read_from_sw and MemRead) or (MemRead and adress_from_cpu(11) and (not adress_from_cpu(4)) and (not adress_from_cpu(5))), 
	Din=> data_buff_toIO,
	IOpin=> DATA_IO
	
	);
	
peripherials_DATA_BUS :	data_bus
	PORT MAP(
	
	Dout=>DATA_from_peripherials,
	en=> MemRead and adress_from_cpu(11) and (adress_from_cpu(4) or adress_from_cpu(5)) and (not read_from_sw),
	Din => data_buff_to_peripherials,
	IOpin=> DATA_IO
	
	);
	
	

		
   DATA_from_gpio_top <= x"000000"&DATA_from_gpio;
   
   HEX01_IN<=hex1(3 DOWNTO 0)&hex0(3 DOWNTO 0);
   HEX23_IN<=hex3(3 DOWNTO 0)&hex2(3 DOWNTO 0);
   HEX45_IN<=hex5(3 DOWNTO 0)&hex4(3 DOWNTO 0);
   
   
  DATA_from_cpu_o <= DATA_from_cpu;
  adress_from_cpu_o <= adress_from_cpu;
 -- DATA_from_gpio_top_o <= DATA_from_gpio_top;
  DATA_from_peripherials_o<=DATA_from_peripherials;
  
  GIE_o <= GIE;
  INTR_o <= INTR;
  INTA_o <= INTA;
  
  Memwrite_out_o<=MemWrite;
  Memread_out_o <=MemRead;
  
  
  read_from_sw <= '1' when adress_from_cpu(11 downto 0) = x"810" else '0';
  
  clock_to_components <= CEclk(0) when k = 10 else Clkin when k = 8;
  
  

		
	single_clock <= CEclk(0);
		
				

   
   
end behavior;