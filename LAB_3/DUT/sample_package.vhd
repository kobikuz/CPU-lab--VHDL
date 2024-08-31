LIBRARY ieee;
USE ieee.std_logic_1164.all;

package sample_package is


component AdderSub IS
GENERIC (Dwidth : INTEGER :=16 );
PORT (    
	x,y: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
	OPC: IN STD_LOGIC_VECTOR (3 downto 0);
    s: OUT STD_LOGIC_VECTOR(Dwidth-1 downto 0);
	Cflag: OUT STD_LOGIC;
	Zflag: OUT STD_LOGIC;
	Nflag: OUT STD_LOGIC
	
	);
END component;

component LOGIC IS
  GENERIC (n : INTEGER := 16);
PORT (
	Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 cout : OUT STD_LOGIC;
		 zout : out std_logic;
		 nout : out std_logic

		 );
END component;
--------------------------------------------------------
--COMPONENT Shifter IS
--  GENERIC (n : INTEGER := 16;
--		   k : INTEGER := 4); --- k must be log2(n)		
--  PORT (    
--			x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
--			OPC: IN STD_LOGIC_VECTOR (k-1 downto 0);
 --           Cflag: OUT STD_LOGIC;
--			Zflag: out std_logic;
--			Nflag: out std_logic;
 --           s : OUT STD_LOGIC_VECTOR(n-1 downto 0));
--END COMPONENT;
----------------------- NEXT COMPONENT ------------------
component ALU is
port(
	AB: in STD_LOGIC_VECTOR(15 downto 0);
	clk : in std_logic;
	Ain :in std_logic;
	Cin :in std_logic;
	OPC : in std_logic_vector(3 downto 0);
	regC   : out STD_LOGIC_VECTOR(15 downto 0);	
	Cflag : out std_logic;
	Zflag : out std_logic;
	Nflag : out std_logic);
end component;
----------------------- NEXT COMPONENT ------------------
component FA IS
	PORT 
	(xi, yi, cin: IN std_logic;
	s, cout: OUT std_logic);
END component;
----------------------- NEXT COMPONENT ------------------
component DQFF is 
   port(
      Clk 	:in std_logic;   
      D 	:in std_logic_vector(5 downto 0);
	  Q 	:out std_logic_vector(5 downto 0)   
   );
end component;
----------------------- NEXT COMPONENT ------------------
component DataPath is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6);	 
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
end component;
----------------------- NEXT COMPONENT ------------------
component opcdecoder is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6);	 
port(	dataOut: in std_logic_vector(15 downto 0);	
		IRin: in std_logic;
		RFaddr: in std_logic_vector(1 downto 0);
		readAddr: out std_logic_vector(3 downto 0);
		writeAddr: out std_logic_vector(3 downto 0);
		IR: out std_logic_vector(15 downto 0);	
		st: out std_logic;
		ld: out std_logic;
		mov: out std_logic;
		done: out std_logic;
		add: out std_logic;
		sub: out std_logic;
		andf: out std_logic;
		orf: out std_logic;
		xorf: out std_logic;
		--shl: out std_logic;
		jmp: out std_logic;
		jc: out std_logic;
		jnc: out std_logic;
		jn: out std_logic
		--nop: out std_logic);
		);
		
end component;
----------------------- NEXT COMPONENT ------------------
component PCunit is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	
		clk: in std_logic;
		PCin: in std_logic;
		PCsel: in std_logic_vector(1 downto 0);
		IRjmp: in std_logic_vector(4 downto 0);
		PCout:	out std_logic_vector(5 downto 0)
);
end component;
-------------------------------------------------------
component TOP is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6);
		 
port(	
		rst: in std_logic;
		ena: in std_logic;
		clk: in std_logic;
		done_tb: out std_logic;
		
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
end component;
----------------------- NEXT COMPONENT ------------------
component ProgMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk: in std_logic;
		wren: in std_logic;
		dataIn:	in std_logic_vector(Dwidth-1 downto 0);
		writeAddr:	in std_logic_vector(Awidth-1 downto 0);
		readAddr:	in std_logic_vector(Awidth-1 downto 0);
		dataOut: 	out std_logic_vector(Dwidth-1 downto 0)
);
end component;
----------------------- NEXT COMPONENT ------------------
component RF is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	clk: in std_logic;	
		rst: in std_logic;
		RFin: in std_logic;
		
		writeAddr:	in std_logic_vector(Awidth-1 downto 0);
		readAddr:	in std_logic_vector(Awidth-1 downto 0);		
		RFdatain:	in std_logic_vector(Dwidth-1 downto 0);		
		RFdataout: 	out std_logic_vector(Dwidth-1 downto 0);
		-----------  registers wathcer -----------
		
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
		R15 : out std_logic_vector(Dwidth-1 downto 0)
		-------------------------------------------
);
end component;
----------------------- NEXT COMPONENT ------------------
component signex8bit is
generic( Dwidth: integer:=16);
port( 
		imm : 	in std_logic_vector(7 downto 0 );
		extended1: out std_logic_vector(15 downto 0);
		extended2: out std_logic_vector(15 downto 0)
);
end component;
----------------------- NEXT COMPONENT ------------------
component BidirPin is
generic( width: integer:=16 );
port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
		en:		in 		std_logic;
		Din:	out		std_logic_vector(width-1 downto 0);
		IOpin: 	inout 	std_logic_vector(width-1 downto 0)
);
end component;
----------------------- NEXT COMPONENT ------------------
component BidirPinBasic is
port(   writePin: in 	std_logic;
		readPin:  out 	std_logic;
		bidirPin: inout std_logic
);
end component;
----------------------- NEXT COMPONENT ------------------

component dataMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	
		clk,wren: in std_logic;	
		datain:	in std_logic_vector(Dwidth-1 downto 0);
		writeAddr,readAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		dataOut: 	out std_logic_vector(Dwidth-1 downto 0)
);
end component;
----------------------- NEXT COMPONENT ------------------
component control IS
	
	PORT (rst_control, ena, clk: in std_logic; 
	------------status----------------------------------
		Cflag : in std_logic;
		Zflag : in std_logic;
		Nflag : in std_logic;
		st: in std_logic;
		ld: in std_logic;
		mov: in std_logic;
		done: in std_logic;
		add: in std_logic;
		sub: in std_logic;
		andf: in std_logic;
		orf: in std_logic;
		xorf:in std_logic;
		--shl: in std_logic;
		jmp: in std_logic;
		jc: in std_logic;
		jnc: in std_logic;
		jn:in std_logic;
		--nop: in std_logic;
	------------control outputs----------------------------
		RFaddr: out std_logic_vector(1 downto 0);
		IRin: out std_logic;
		PCin: out std_logic;
		PCsel: out std_logic_vector(1 downto 0);
		imm1_in: out std_logic; ---8bit
		imm2_in: out std_logic; ---4bit
		OPC: out std_logic_vector(3 downto 0);
		Ain: out std_logic;
		Cin: out std_logic;
		RFin: out std_logic;
		RFout: out std_logic;
		Cout: out std_logic;
		Mem_wr: out std_logic;
		Mem_out: out std_logic;
		Mem_in: out std_logic;
		Message: out string(1 to 4));
		
		
		
END component;




end sample_package;

