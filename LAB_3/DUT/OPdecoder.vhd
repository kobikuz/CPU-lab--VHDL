library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.sample_package.all;
--------------------------------------------------------------
entity opcdecoder is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6);
		 
port(	
		dataOut: in std_logic_vector(15 downto 0);	
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
		jn : out std_logic
		);
		--nop: out std_logic);
end opcdecoder;
--------------------------------------------------------------
architecture behav of opcdecoder is
	signal ra: std_logic_vector (3 downto 0);
	signal rb: std_logic_vector (3 downto 0);
	signal rc: std_logic_vector (3 downto 0);
	signal op: std_logic_vector (3 downto 0);
begin
	op <= dataOut(15 downto 12) when IRin='1' else unaffected;
	ra <= dataOut(11 downto 8 ) when IRin='1' else unaffected;
	rb <= dataOut( 7 downto 4 ) when IRin='1' else unaffected;
	rc <= dataOut( 3 downto 0 ) when IRin='1' else unaffected;
	IR <= dataOut when IRin='1' else unaffected;
	readAddr  <= ra when RFaddr="00" else rb when RFaddr="01" else rc when RFaddr="10" else unaffected;
	writeAddr <= ra when RFaddr="00" else rb when RFaddr="01" else rc when RFaddr="10" else unaffected;
	
	
	st	<='1' when op="1110" else '0';
	ld	<='1' when op="1101" else '0';
	mov	<='1' when op="1100" else '0';
	done<='1' when op="1111" else '0';
	add	<='1' when op="0000" else '0';
	sub	<='1' when op="0001" else '0';
	jmp	<='1' when op="0111" else '0';
	jc	<='1' when op="1000" else '0';
	jnc	<='1' when op="1001" else '0';
	andf <='1' when op="0010" else '0';
	orf <= '1' when op="0011" else '0';
	xorf<='1' when op="0100" else '0';
	jn <= '1' when op ="1010" else '0';
	--nop	<='1' when op="0010" else '0';
	--shl <='1' when op ="0011" else '0';

end behav;
