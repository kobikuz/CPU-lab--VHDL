library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.sample_package.all;

---------------------------------------------------------
entity tb_DataP is
	generic(ton : time := 50 ns);
	constant Dwidth : integer := 16;
	constant Awidth : integer := 6;
	constant dept:  integer := 64;
end tb_DataP;
---------------------------------------------------------
architecture rtc of tb_DataP is

	signal clk : std_logic := '1';
	signal	wren: std_logic;

	
	signal	writeAddr: std_logic_vector(Awidth-1 downto 0);

		-------Control IN-----
	signal	RFaddr:std_logic_vector(1 downto 0);
	signal	IRin:std_logic;
	signal	PCin: std_logic;
	signal	PCsel:std_logic_vector(1 downto 0);
	signal	imm1_in: std_logic;
	signal	imm2_in: std_logic;
	signal	OPC: std_logic_vector(3 downto 0);
	signal	Ain: std_logic;
	signal	Cin: std_logic;
	signal	rst: std_logic;
	signal	RFin: std_logic;
	signal	RFout: std_logic;
	signal	Mem_out: std_logic;
	signal	Mem_in: std_logic;
	signal	Mem_wr: std_logic;
	signal	Cout: std_logic;

	signal	Mem_tb : std_logic;


	signal	readAddr_tb: std_logic_vector(Awidth-1 downto 0);
	signal	writeAddr_tb: std_logic_vector(Awidth-1 downto 0);
	signal	TBactive:  std_logic;

		------------------

	signal	Cflag :std_logic;
	signal	Zflag : std_logic;
	signal	Nflag :std_logic;
	signal	st:  std_logic;
	signal	ld:  std_logic;
	signal	mov: std_logic;
	signal	done: std_logic;
	signal	add: std_logic;
	signal	sub: std_logic;
	signal  andf: std_logic;
	signal  orf: std_logic;
	signal 	xorf: std_logic;
	signal	jmp: std_logic;
	signal	jc:  std_logic;
	signal	jnc: std_logic;
	-------------------------monitors (optional)
	signal PC:  std_logic_vector(5 downto 0);
	signal IR:  std_logic_vector(Dwidth-1 downto 0);
	signal dataIn: std_logic_vector(Dwidth-1 downto 0);
	signal	dataIn2: std_logic_vector(Dwidth-1 downto 0);
	signal message: string(1 to 89):="We see here that when data from ITCM is loading, the PC,IR,and other controls are working"; --<<< NOTE
 
begin
		L1: DataPath port map(
		
				-------TB INPUT-------
		wren=>wren,
		clk=>clk,
		
		dataIn=>dataIn,
		dataIn2=>dataIn2,
		writeAddr=>writeAddr,
		-------Control IN-----
		RFaddr=>RFaddr,
		IRin=>IRin,
		PCin=>PCin,
		PCsel=>PCsel,
		imm1_in=>imm1_in,
		imm2_in=>imm2_in,
		OPC=>OPC,
		Ain=>Ain,
		Cin=>Cin,
		rst=>rst,
		RFin=>RFin,
		RFout=>RFout,
		Mem_out=>Mem_out,
		Mem_in=>Mem_in,
		Mem_wr=>Mem_wr,
		Cout=>Cout,
		
		Mem_tb =>Mem_tb,
		readAddr_tb=>readAddr_tb,
		writeAddr_tb=>writeAddr_tb,
		TBactive=>TBactive,
		Ddata=>open,
		
		Cflag=>Cflag,
		Zflag=>Zflag,
		Nflag =>Nflag,
		st=>st,
		ld=>ld,
		mov=>mov,
		done=>done,
		add=>add,
		sub=>sub,
		andf => andf,
		orf => orf,
		xorf =>xorf,
		jmp=>jmp,
		jc=>jc,
		jnc=>jnc,
		
		IR=>IR,
		PC=>PC,
		busIO=>open,
		R1=>open,
		R2=>open,
		R3=>open,
		R4=>open,
		R5=>open,
		R6=>open,
		R7=>open,
		R8=>open,
		R9=>open,
		R10=>open,
		R11=>open,
		R12=>open,
		R13=>open,
		R14=>open,
		R15=>open




		);
			
		
		clk <= not clk after ton;
		
		
		

	assembly: process
		begin
		TBactive <= '0';

		rst <='1','0' after 100 ns;
		wren <= '1' ,'0'after 4200 ns; 
		wait for 100 ns;
		
		dataIn <= x"D104" ,x"D205" after 500 ns,x"C31F" after 1000 ns,x"C401" after 1500 ns,x"C50E" after 2000 ns,x"2113" after 2200 ns,
		x"2223" after 2600 ns,x"1621" after 3000 ns,x"8002" after 3400 ns,x"0640" after 3500 ns ,x"7001" after 3900 ns, x"0600" after 4100 ns;
		
		writeAddr <="000000" ,"000001" after 500 ns,"000010" after 1000 ns,"000011" after 1500 ns,"000100" after 2000 ns,"000101" after 2200 ns,
		"000110" after 2600 ns,"000111" after 3000 ns,"001000" after 3400 ns,"001001" after 3500 ns ,"001010" after 3900 ns, "001011" after 4100 ns;
		
		dataIn2 <= x"D104" ,x"D205" after 500 ns,x"C31F" after 1000 ns,x"C401" after 1500 ns,x"C50E" after 2000 ns,x"2113" after 2200 ns,
		x"2223" after 2600 ns,x"1621" after 3000 ns,x"8002" after 3400 ns,x"0640" after 3500 ns ,x"7001" after 3900 ns, x"0600" after 4100 ns;
		
		readAddr_tb<="000000";
		writeAddr_tb<="000000";
		Mem_wr<='0';
		Mem_tb<='0';
		
		Mem_in	<= '0','1' after 4000 ns;
		OPC 	<= "0000","0001" after 3000 ns,"0000" after 3700 ns;
		PCsel 	<= "00","01"after 100 ns;
		
		IRin 	<= '1','0'  after 100 ns				 ,'1' after 300 ns,		'1' after 500 ns,'0' after 600 ns				  ,'1' after 800 ns,		'1' after 1000 ns,'0' after 1100 ns				  	 ,'1' after 1300 ns,		'1' after 1500 ns,'0' after 1600 ns				  	 ,'1' after 1800 ns,	'1' after 2000 ns,'1' after 2100 ns, 	'1' after 2200 ns,'0' after 2300 ns,'0' after 2400 ns,'1' after 2500 ns, 	'1' after 2600 ns,'0' after 2700 ns,'0' after 2800 ns,'1' after 2900 ns, 	'1' after 3000 ns,'0' after 3100 ns,'0' after 3200 ns,'1' after 3300 ns, 	'1' after 3400 ns,				 	'1' after 3500 ns,'0' after 3600 ns,'0' after 3700 ns,'1' after 3800 ns, 		'1' after 3900 ns,'1' after 4000 ns,			'1' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--IRin
		PCin 	<= '1','0' 	after 100 ns				 ,'0' after 300 ns,		'1' after 500 ns,'0' after 600 ns				  ,'0' after 800 ns,		'1' after 1000 ns,'0' after 1100 ns                  ,'0' after 1300 ns,		'1' after 1500 ns,'0' after 1600 ns                  ,'0' after 1800 ns,	'1' after 2000 ns,'0' after 2100 ns, 	'1' after 2200 ns,'0' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'1' after 2600 ns,'0' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'1' after 3000 ns,'0' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'1' after 3400 ns,				 	'1' after 3500 ns,'0' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'1' after 3900 ns,'1' after 4000 ns,			'1' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--PCin
		RFin 	<= '0','0' 	after 100 ns,'0' after 200 ns,'1' after 300 ns,		'0' after 500 ns,'0' after 600 ns,'0' after 700 ns,'1' after 800 ns,		'0' after 1000 ns,'0' after 1100 ns,'0' after 1200 ns,'1' after 1300 ns,		'0' after 1500 ns,'0' after 1600 ns,'0' after 1700 ns,'1' after 1800 ns,	'1' after 2000 ns,'1' after 2100 ns, 	'0' after 2200 ns,'0' after 2300 ns,'1' after 2400 ns,'1' after 2500 ns, 	'0' after 2600 ns,'0' after 2700 ns,'1' after 2800 ns,'1' after 2900 ns, 	'0' after 3000 ns,'0' after 3100 ns,'1' after 3200 ns,'1' after 3300 ns, 	'0' after 3400 ns, 					'0' after 3500 ns,'0' after 3600 ns,'1' after 3700 ns,'1' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'0' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--RFin
		RFaddr 	<= "01","01"after 100 ns,"01"after 200 ns,"00"after 300 ns,		"01"after 500 ns,"01"after 600 ns,"01"after 700 ns,"00"after 800 ns,		"01"after 1000 ns,"01"after 1100 ns,"01"after 1200 ns,"00"after 1300 ns,		"01"after 1500 ns,"01"after 1600 ns,"01"after 1700 ns,"00"after 1800 ns,	"00"after 2000 ns,"00"after 2100 ns, 	"01"after 2200 ns,"10"after 2300 ns,"00"after 2400 ns,"00"after 2500 ns, 	"01"after 2600 ns,"10"after 2700 ns,"00"after 2800 ns,"00"after 2900 ns, 	"01"after 3000 ns,"10"after 3100 ns,"00"after 3200 ns,"00"after 3300 ns, 	"00"after 3400 ns,					"01"after 3500 ns,"10"after 3600 ns,"00"after 3700 ns,"00"after 3800 ns, 		"00"after 3900 ns,"00"after 4000 ns,			"01"after 4100 ns,"01"after 4200 ns,"00"after 4300 ns,"00"after 4400 ns;--RFaddr
		Ain 	<= '1','0' 	after 100 ns,'0' after 200 ns,'0' after 300 ns,		'1' after 500 ns,'0' after 600 ns,'0' after 700 ns,'0' after 800 ns,		'1' after 1000 ns,'0' after 1100 ns,'0' after 1200 ns,'0' after 1300 ns,		'1' after 1500 ns,'0' after 1600 ns,'0' after 1700 ns,'0' after 1800 ns,	'0' after 2000 ns,'0' after 2100 ns, 	'1' after 2200 ns,'0' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'1' after 2600 ns,'0' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'1' after 3000 ns,'0' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'0' after 3400 ns, 					'1' after 3500 ns,'0' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'1' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--Ain
		Cin 	<= '0','1' 	after 100 ns,'0' after 200 ns,'0' after 300 ns,		'0' after 500 ns,'1' after 600 ns,'0' after 700 ns,'0' after 800 ns,		'0' after 1000 ns,'1' after 1100 ns,'0' after 1200 ns,'0' after 1300 ns,		'0' after 1500 ns,'1' after 1600 ns,'0' after 1700 ns,'0' after 1800 ns,	'0' after 2000 ns,'0' after 2100 ns, 	'0' after 2200 ns,'1' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'0' after 2600 ns,'1' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'0' after 3000 ns,'1' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'0' after 3400 ns, 					'0' after 3500 ns,'1' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'0' after 4100 ns,'1' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--Cin
		imm1_in <= '0','0' 	after 100 ns,'0' after 200 ns,'0' after 300 ns,		'0' after 500 ns,'0' after 600 ns,'0' after 700 ns,'0' after 800 ns,		'0' after 1000 ns,'0' after 1100 ns,'0' after 1200 ns,'0' after 1300 ns,		'0' after 1500 ns,'0' after 1600 ns,'0' after 1700 ns,'0' after 1800 ns,	'1' after 2000 ns,'1' after 2100 ns, 	'0' after 2200 ns,'0' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'0' after 2600 ns,'0' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'0' after 3000 ns,'0' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'0' after 3400 ns, 					'0' after 3500 ns,'0' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'0' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--imm1_in
		imm2_in <= '1','0' 	after 100 ns,'0' after 200 ns,'0' after 300 ns,		'1' after 500 ns,'0' after 600 ns,'0' after 700 ns,'0' after 800 ns,		'1' after 1000 ns,'0' after 1100 ns,'0' after 1200 ns,'0' after 1300 ns,		'1' after 1500 ns,'0' after 1600 ns,'0' after 1700 ns,'0' after 1800 ns,	'0' after 2000 ns,'0' after 2100 ns, 	'0' after 2200 ns,'0' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'0' after 2600 ns,'0' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'0' after 3000 ns,'0' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'0' after 3400 ns, 					'0' after 3500 ns,'0' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'1' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--imm2_in
		RFout 	<= '0','1' 	after 100 ns,'0' after 200 ns,'0' after 300 ns,		'0' after 500 ns,'1' after 600 ns,'0' after 700 ns,'0' after 800 ns,		'0' after 1000 ns,'1' after 1100 ns,'0' after 1200 ns,'0' after 1300 ns,		'0' after 1500 ns,'1' after 1600 ns,'0' after 1700 ns,'0' after 1800 ns,	'0' after 2000 ns,'0' after 2100 ns, 	'1' after 2200 ns,'1' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'1' after 2600 ns,'1' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'1' after 3000 ns,'1' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'0' after 3400 ns, 					'1' after 3500 ns,'1' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'0' after 4100 ns,'1' after 4200 ns,'0' after 4300 ns,'1' after 4400 ns;--RFout
		Mem_out <= '0','0' 	after 100 ns,'0' after 200 ns,'1' after 300 ns,		'0' after 500 ns,'0' after 600 ns,'0' after 700 ns,'1' after 800 ns,		'0' after 1000 ns,'0' after 1100 ns,'0' after 1200 ns,'1' after 1300 ns,		'0' after 1500 ns,'0' after 1600 ns,'0' after 1700 ns,'1' after 1800 ns,	'0' after 2000 ns,'0' after 2100 ns, 	'0' after 2200 ns,'0' after 2300 ns,'0' after 2400 ns,'0' after 2500 ns, 	'0' after 2600 ns,'0' after 2700 ns,'0' after 2800 ns,'0' after 2900 ns, 	'0' after 3000 ns,'0' after 3100 ns,'0' after 3200 ns,'0' after 3300 ns, 	'0' after 3400 ns, 					'0' after 3500 ns,'0' after 3600 ns,'0' after 3700 ns,'0' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'0' after 4100 ns,'0' after 4200 ns,'0' after 4300 ns,'0' after 4400 ns;--Mem_out
		Cout 	<= '0','0' 	after 100 ns,'1' after 200 ns,'0' after 300 ns,		'0' after 500 ns,'0' after 600 ns,'1' after 700 ns,'0' after 800 ns,		'0' after 1000 ns,'0' after 1100 ns,'1' after 1200 ns,'0' after 1300 ns,		'0' after 1500 ns,'0' after 1600 ns,'1' after 1700 ns,'0' after 1800 ns, 	'0' after 2000 ns,'0' after 2100 ns, 	'0' after 2200 ns,'0' after 2300 ns,'1' after 2400 ns,'1' after 2500 ns, 	'0' after 2600 ns,'0' after 2700 ns,'1' after 2800 ns,'1' after 2900 ns, 	'0' after 3000 ns,'0' after 3100 ns,'1' after 3200 ns,'1' after 3300 ns, 	'0' after 3400 ns, 					'0' after 3500 ns,'0' after 3600 ns,'1' after 3700 ns,'1' after 3800 ns, 		'0' after 3900 ns,'0' after 4000 ns,			'0' after 4100 ns,'0' after 4200 ns,'1' after 4300 ns,'0' after 4400 ns;--Cout
		wait;-------------------------------------------------ld r2 2(r0)--------------------------------------------------------------ld r4 4(r0)---------------------------------------------------------------------ld r9 9(r0)--------------------------------------------------------------------ld r13 13(r0)---------------------------------mov r1,1------------------------------------------------------add r3 r2 r13-----------------------------------------------------------------------add r2 r4 r9-----------------------------------------------------------sub r6 r2 r3------------jc 2-(infinished)-------------------------------------------------------------add r6 r0 r0--------------------------------------j 1-(infinished)--------------------------------------------------------st r6 14(r0) (infinished)---------------

		end process;
		

end rtc;