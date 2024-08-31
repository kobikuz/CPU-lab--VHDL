library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.sample_package.all;
--------------------------------------------------------------
entity DataPath is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
		 
port(	
		
		wren: in std_logic;
		clk : in std_logic;
		dataIn:	in std_logic_vector(Dwidth-1 downto 0);		--data from ITCMinit.txt
		dataIn2:	in std_logic_vector(Dwidth-1 downto 0);	--data from DTCMinit.txt
		writeAddr:	in std_logic_vector(5 downto 0);
		----------------Control & TB in-----------------
		RFaddr: in std_logic_vector(1 downto 0);
		IRin: in std_logic;
		PCin: in std_logic;
		PCsel: in std_logic_vector(1 downto 0);
		imm1_in: in std_logic;
		imm2_in: in std_logic;
		OPC: in std_logic_vector(3 downto 0);
		Ain: in std_logic;
		Cin: in std_logic;
		rst: in std_logic;
		RFin: in std_logic;
		RFout: in std_logic;
		Mem_out: in std_logic;
		Mem_in: in std_logic;
		Mem_wr:in std_logic;
		Cout: in std_logic;
		Mem_tb : in std_logic;
		readAddr_tb: in std_logic_vector(5 downto 0);
		writeAddr_tb: in std_logic_vector(5 downto 0);
		TBactive: in std_logic;
		Ddata: out std_logic_vector(Dwidth-1 downto 0); --from data memory to txt/bus
		--------------- flags and status -------------
		Cflag : out std_logic := '0';
		Zflag : out std_logic := '0';
		Nflag : out std_logic := '0';
		st: out std_logic;
		ld: out std_logic;
		mov: out std_logic;
		done: out std_logic;
		add: out std_logic;
		sub: out std_logic;
		andf : out std_logic;
		orf : out std_logic;
		xorf : out std_logic;
		--shl:out std_logic;--------
		jmp: out std_logic;
		jc: out std_logic;
		jnc: out std_logic;
		jn: out std_logic;
		--nop: out std_logic;
		---------- monitor & registers wathcer ------------
		-------------------OPTIONAL------------------------
		IR: out std_logic_vector(15 downto 0);-------------
		PC: out std_logic_vector(5 downto 0);--------------
		busIO : out std_logic_vector(Dwidth-1 downto 0);---
		R1 : out std_logic_vector(Dwidth-1 downto 0);------
		R2 : out std_logic_vector(Dwidth-1 downto 0);------
		R3 : out std_logic_vector(Dwidth-1 downto 0);------
		R4 : out std_logic_vector(Dwidth-1 downto 0);------
		R5 : out std_logic_vector(Dwidth-1 downto 0);------
		R6 : out std_logic_vector(Dwidth-1 downto 0);------
		R7 : out std_logic_vector(Dwidth-1 downto 0);------
		R8 : out std_logic_vector(Dwidth-1 downto 0);------
		R9 : out std_logic_vector(Dwidth-1 downto 0);------
		R10 : out std_logic_vector(Dwidth-1 downto 0);-----
		R11 : out std_logic_vector(Dwidth-1 downto 0);-----
		R12 : out std_logic_vector(Dwidth-1 downto 0);-----
		R13 : out std_logic_vector(Dwidth-1 downto 0);-----
		R14 : out std_logic_vector(Dwidth-1 downto 0);-----
		R15 : out std_logic_vector(Dwidth-1 downto 0)------
		);
end DataPath;
--------------------------------------------------------------
architecture behav of DataPath is

	signal Pdata: std_logic_vector(Dwidth-1 downto 0);
	signal IR_RF: std_logic_vector(3 downto 0);
	signal RFdatain: std_logic_vector(Dwidth-1 downto 0);
	signal RFdataout: std_logic_vector(Dwidth-1 downto 0);
	signal AB: std_logic_vector(Dwidth-1 downto 0);
	signal regC: std_logic_vector(Dwidth-1 downto 0);
	signal extended1: std_logic_vector(Dwidth-1 downto 0);
	signal extended2: std_logic_vector(Dwidth-1 downto 0);
	signal Writebus: std_logic_vector(Dwidth-1 downto 0);
	
	------------------datamem---------------------------
	signal Dmem_in: std_logic_vector(Dwidth-1 downto 0);
	signal Dmem_out: std_logic_vector(Dwidth-1 downto 0);
	signal wren_mux: std_logic;
	signal dataIn_mux: std_logic_vector(Dwidth-1 downto 0);
	signal readAddr_mux: std_logic_vector(5 downto 0);
	signal writeAddr_mux: std_logic_vector(5 downto 0);
	signal from_bus_to_DQFF : std_logic_vector(5 downto 0);
	signal from_DQFF_to_writeAddr : std_logic_vector(5 downto 0);
	signal RDdatainfin: std_logic_vector(Dwidth-1 downto 0);
	signal readaddR_datamem: std_logic_vector(Dwidth-1 downto 0);
	--Signal busIO : std_logic_vector(Dwidth-1 downto 0);
	
	signal Nflag_temp : STD_LOGIC; 
	signal Cflag_temp : STD_LOGIC; 
	signal Zflag_temp : STD_LOGIC; 
begin
	
	wren_mux <=Mem_tb when TBactive = '1' else Mem_wr;
	dataIn_mux <=dataIn2 when TBactive = '1' else Writebus;
	writeAddr_mux <=writeAddr when TBactive='1' else from_DQFF_to_writeAddr;
	
	
	readAddr_mux <=readAddr_tb when TBactive='1' else readaddR_datamem(5 downto 0);
	readaddR_datamem <= regC when Mem_out ='1' else Writebus;

	FF: DQFF port map(
		clk=>clk,
		D => Writebus(5 downto 0),
		Q => from_DQFF_to_writeAddr
		);
	
	Dmem: DataMem port map(
		clk=>clk,
		wren=>wren_mux,
		dataIn=>dataIn_mux,
		writeAddr=>writeAddr_mux,
		readAddr=>readAddr_mux,
		dataOut=> Ddata
		);
	
	Pmem: ProgMem port map(
		clk=>clk,
		wren=>wren,
		dataIn=>dataIn,
		writeAddr=>writeAddr,
		readAddr=>PC,
		dataOut=>Pdata
		);
	
	Opcd: opcdecoder port map(
		dataOut=>Pdata,
		IRin=>IRin,
		RFaddr=>RFaddr,
		readAddr=>IR_RF,
		writeAddr=>IR_RF,
		IR => IR,
		st=>st,
		ld=>ld,
		mov=>mov,
		done=>done,
		add=>add,
		sub=>sub,
		andf=>andf,
		orf=>orf,
		xorf => xorf,	
		--shl => shl,
		jmp=>jmp,
		jc=>jc,
		jnc=>jnc,
		jn =>jn
		--nop=>nop
		);
	PC_cont: PCunit port map(
		clk => clk,
		PCin=>PCin,
		PCsel=>PCsel,
		IRjmp=>Pdata(4 downto 0),
		PCout=>PC
		);
	
	RF_unit: RF port map(
		clk=>clk,
		rst=>rst,
		RFin=>RFin,
		writeAddr=>IR_RF,
		readAddr=>IR_RF,
		RFdatain=> Writebus,
		RFdataout=> RFdataout,
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
	
	ALU_unit: ALU port map(
		AB=> Writebus,
		clk=>clk,
		Ain=>Ain,
		Cin=>Cin,
		OPC=>OPC,
		regC=> regC,
		Cflag=>Cflag_temp,
		Zflag=>Zflag_temp,
		Nflag=>Nflag_temp
		);

	SigExt: signex8bit port map(
		imm => Pdata(7 downto 0),
		extended1 => extended1,
		extended2 => extended2
		);
		
	RFbus : BidirPin port map(
	Dout=>RFdataout,
	en=>RFout,
	Din=>Writebus,
	IOpin=>busIO
	
	);
	
	Signex11bus : BidirPin port map(
	Dout=>extended1,
	en=>imm1_in,
	IOpin=>busIO
	);
	
	Signex12bus : BidirPin port map(
	Dout=>extended2,
	en=>imm2_in,
	IOpin=>busIO
	);
	
	Datamembus : BidirPin port map(
	Dout=> Ddata,
	en=>Mem_out,
	Din=>Writebus,
	IOpin=>busIO
	);
	
	ALUbus : BidirPin port map(
	Dout=>regC,
	en=>Cout,
	Din=> Writebus,
	IOpin=>busIO
	);
	
	Cflag <= Cflag_temp when (add ='1' or sub ='1'); --else unaffected;
	Nflag <= Nflag_temp when (add ='1' or sub ='1') or (xorf ='1' or orf='1' or andf='1');
	Zflag <= Zflag_temp when (add ='1' or sub ='1') or (xorf ='1' or orf='1' or andf='1') ;
	

end behav;
