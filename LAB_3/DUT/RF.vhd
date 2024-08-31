library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity RF is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	clk: in std_logic;	
		rst: in std_logic;
		RFin: in std_logic;
		
		writeAddr:	in std_logic_vector(Awidth-1 downto 0);
		readAddr:	in std_logic_vector(Awidth-1 downto 0);		
		RFdatain:	in std_logic_vector(Dwidth-1 downto 0);		
		RFdataout: 	out std_logic_vector(Dwidth-1 downto 0);
		------------- registers wathcer ----------------
		---------------OPTIONAL-------------------------
		R1 : out std_logic_vector(Dwidth-1 downto 0);---
		R2 : out std_logic_vector(Dwidth-1 downto 0);---
		R3 : out std_logic_vector(Dwidth-1 downto 0);---
		R4 : out std_logic_vector(Dwidth-1 downto 0);---
		R5 : out std_logic_vector(Dwidth-1 downto 0);---
		R6 : out std_logic_vector(Dwidth-1 downto 0);---
		R7 : out std_logic_vector(Dwidth-1 downto 0);---
		R8 : out std_logic_vector(Dwidth-1 downto 0);---
		R9 : out std_logic_vector(Dwidth-1 downto 0);---
		R10 : out std_logic_vector(Dwidth-1 downto 0);--
		R11 : out std_logic_vector(Dwidth-1 downto 0);--
		R12 : out std_logic_vector(Dwidth-1 downto 0);--
		R13 : out std_logic_vector(Dwidth-1 downto 0);--
		R14 : out std_logic_vector(Dwidth-1 downto 0);--
		R15 : out std_logic_vector(Dwidth-1 downto 0)---
);
end RF;
architecture behav of RF is

type RegFile is array (0 to 2**Awidth-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRF: RegFile;

begin			   
  process(clk)
  begin
	if (rst='1') then
		sysRF(0) <= (others=>'0');   -- R[0] is constant Zero value 
	elsif (clk'event and clk='1') then
	    if (RFin='1') then
		    -- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRF(conv_integer(writeAddr)) <= RFdatain;
	    end if;
	end if;
  end process;
	
  RFdataout <= sysRF(conv_integer(readAddr));
  --------------OPTIONAL-------------------
  R1 <= sysRF(1);
  R2 <= sysRF(2);
  R3 <= sysRF(3);
  R4 <= sysRF(4);
  R5 <= sysRF(5);
  R6 <= sysRF(6);
  R7 <= sysRF(7);
  R8 <= sysRF(8);
  R9 <= sysRF(9);
  R10 <= sysRF(10);
  R11 <= sysRF(11);
  R12 <= sysRF(12);
  R13 <= sysRF(13);
  R14 <= sysRF(14);
  R15 <= sysRF(15);
end behav;
