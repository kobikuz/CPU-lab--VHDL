library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.sample_package.all;
--------------------------------------------------------------
entity TOP is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6);
		 
port(	
		rst: in std_logic;
		ena: in std_logic;
		clk: in std_logic;
		done_tb: out std_logic :='0';
		
		TB_active: in std_logic;
		
		TB_ITCM_wren: in std_logic;
		TB_ITCM_in: in std_logic_vector(15 downto 0);
		TB_ITCM_W_Addr: in std_logic_vector(Awidth-1 downto 0);
		
		TB_DTCM_wren: in std_logic;
		TB_DTCM_in: in std_logic_vector(15 downto 0);
		TB_DTCM_out: out std_logic_vector(15 downto 0);
		TB_DTCM_R_Addr: in std_logic_vector(Awidth-1 downto 0);
		TB_DTCM_W_Addr: in std_logic_vector(Awidth-1 downto 0);
		
		IR: out std_logic_vector(15 downto 0);
		PC: out std_logic_vector(Awidth-1 downto 0);
		busIO : out std_logic_vector(Dwidth-1 downto 0);
		R1 : out std_logic_vector(Dwidth-1 downto 0);
		R2 : out std_logic_vector(Dwidth-1 downto 0);
		R3 : out std_logic_vector(Dwidth-1 downto 0);
		R4 : out std_logic_vector(Dwidth-1 downto 0);
		R5 : out std_logic_vector(Dwidth-1 downto 0);
		R6 : out std_logic_vector(Dwidth-1 downto 0);
		R7 : out std_logic_vector(Dwidth-1 downto 0);
		R8 : out std_logic_vector(Dwidth-1 downto 0);
		R9 : out std_logic_vector(Dwidth-1 downto 0);
		R10 : out std_logic_vector(Dwidth-1 downto 0);
		R11 : out std_logic_vector(Dwidth-1 downto 0);
		R12 : out std_logic_vector(Dwidth-1 downto 0);
		R13 : out std_logic_vector(Dwidth-1 downto 0);
		R14 : out std_logic_vector(Dwidth-1 downto 0);
		R15 : out std_logic_vector(Dwidth-1 downto 0);
		Cflag : out std_logic;
		Zflag : out std_logic;
		Nflag : out std_logic;
		Message: out string(1 to 4)
		);
end TOP;
--------------------------------------------------------------
architecture behav of TOP is

	------- 	Control --> DataPath 	-------
	signal	RFaddr: std_logic_vector(1 downto 0);
	signal	IRin:  std_logic;
	signal	PCin: std_logic;
	signal	PCsel:  std_logic_vector(1 downto 0);
	signal	imm1_in:  std_logic;
	signal	imm2_in:  std_logic;
	signal	OPC:  std_logic_vector(3 downto 0);
	signal	Ain:  std_logic;
	signal	Cin:  std_logic;
	signal	RFin:  std_logic;
	signal	RFout:  std_logic;
	signal	Mem_out:  std_logic;
	signal	Mem_in:  std_logic;
	signal	Cout:  std_logic;
	signal	Mem_wr : std_logic;
	------- 	DataPath --> Control 	-------
	--signal	Cflag :  std_logic;
	--signal	Zflag :  std_logic;
	--signal	Nflag :  std_logic;
	signal	st:  std_logic;
	signal	ld:  std_logic;
	signal	mov:  std_logic;
	signal	done:  std_logic; --> became output for TB to start print txt
	signal	add:  std_logic;
	signal	sub:  std_logic;
	signal andf : std_logic;
	signal orf : std_logic;
	signal xorf : std_logic;
	--signal shl : std_logic;
	signal	jmp:  std_logic;
	signal	jc:  std_logic;
	signal	jnc:  std_logic;
	signal jn:std_logic;
	--signal	nop: std_logic;
	

begin	
	DataPathMap: DataPath port map(
		wren=>TB_ITCM_wren,
		clk=>clk,
		dataIn=>TB_ITCM_in,				--data from ITCMinit.txt
		dataIn2=>TB_DTCM_in,			--data from DTCMinit.txt
		writeAddr=>TB_ITCM_W_Addr,
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
		Mem_tb=>TB_DTCM_wren,
		readAddr_tb=>TB_DTCM_R_Addr,
		writeAddr_tb=>TB_DTCM_W_Addr,
		TBactive=>TB_active,
		Ddata => TB_DTCM_out, --from data memory
		Cflag=>Cflag,
		Zflag=>Zflag,
		Nflag=>Nflag,
		st=>st,
		ld=>ld,
		mov=>mov,
		done=>done,
		add=>add,
		sub=>sub,
		andf=>andf,
		orf=>orf,
		xorf=>xorf,
		--shl=>shl,
		jmp=>jmp,
		jc=>jc,
		jnc=>jnc,
		jn=>jn,
		--nop=>nop,
		IR=>IR,
		PC=>PC,
		busIO=>busIO,
		R1=>R1,
		R2=>R2,
		R3=>R3,
		R4=>R4,
		R5=>R5,
		R6=>R6,
		R7=>R7,
		R8=>R8,
		R9=>R9,
		R10=>R10,
		R11=>R11,
		R12=>R12,
		R13=>R13,
		R14=>R14,
		R15=>R15
		);

	
	Pmem: control port map(
		rst_control=>rst,
		ena=>ena,
		clk=>clk,
	------------status----------------------------------
		Cflag=>Cflag,
		Zflag=>Zflag,
		Nflag=>Nflag,
		st=>st,
		ld=>ld,
		mov=>mov,
		done=>done,
		add=>add,
		sub=>sub,
		andf=>andf,
		orf=>orf,
		xorf=>xorf,
		--shl=>shl,
		jmp=>jmp,
		jc=>jc,
		jnc=>jnc,
		jn=>jn,
		--nop=>nop,
	------------control outputs----------------------------
		RFaddr=>RFaddr,
		IRin=>IRin,
		PCin=>PCin,
		PCsel=>PCsel,
		imm1_in=>imm1_in,
		imm2_in=>imm2_in,
		OPC=>OPC,
		Ain=>Ain,
		Cin=>Cin,
		RFin=>RFin,
		RFout=>RFout,
		Cout=>Cout,
		Mem_wr=>Mem_wr,
		Mem_out=>Mem_out,
		Mem_in=>Mem_in,
	------------TB output-(OPTIONAL)-----------------
		Message=>Message
		);
		
		done_tb <= '1' when done ='1';

end behav;
