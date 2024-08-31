library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.sample_package.all;

---------------------------------------------------------
entity tb_TOP is
	generic(ton : time := 50 ns);
	constant Dwidth : integer := 16;
	constant Awidth : integer := 4;
	constant dept:  integer := 64;
end tb_TOP;
---------------------------------------------------------
architecture rtc of tb_TOP is

	signal clk : std_logic := '1';
	signal 	rst:  std_logic;
	signal	ena:  std_logic;
	signal 	Done: std_logic;
	signal  TB_active:  std_logic;
	signal	TB_ITCM_wren:  std_logic;
	signal	TB_DTCM_wren:  std_logic;
	signal	TB_ITCM_W_Addr:  std_logic_vector(5 downto 0);
	signal	TB_DTCM_W_Addr:  std_logic_vector(5 downto 0);
	signal	TB_DTCM_R_Addr:  std_logic_vector(5 downto 0);
	signal	TB_ITCM_in:  std_logic_vector(15 downto 0);
	signal	TB_DTCM_in:  std_logic_vector(15 downto 0);
	signal	TB_DTCM_out:  std_logic_vector(15 downto 0);
	signal 	PC: std_logic_vector(5 downto 0);
	signal 	IR: std_logic_vector(15 downto 0);
	signal  Message:  string(1 to 4);
	signal 	busIO: std_logic_vector(Dwidth-1 downto 0);
	signal  R1 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R2 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R3 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R4 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R5 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R6 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R7 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R8 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R9 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R10 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R11 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R12 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R13 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R14 :  std_logic_vector(Dwidth-1 downto 0);
	signal	R15 :  std_logic_vector(Dwidth-1 downto 0);
	signal Cflag : std_logic;
	signal Nflag : std_logic;
	signal Zflag : std_logic;

	constant read_file_loc : string(1 to 24) := "C:\lab3mems\ITCMinit.txt";
	constant read_file_loc2 : string(1 to 24) := "C:\lab3mems\DTCMinit.txt";
	constant write_file_loc : string(1 to 27) := "C:\lab3mems\DTCMcontent.txt";
	
begin
		L1: TOP port map(
			rst=>rst,
			ena=>ena,
			clk=>clk,
			done_tb=>done,
			TB_active=>TB_active,
			TB_ITCM_wren=>TB_ITCM_wren,
			TB_ITCM_in=>TB_ITCM_in,
			TB_ITCM_W_Addr=>TB_ITCM_W_Addr,
			TB_DTCM_wren=>TB_DTCM_wren,
			TB_DTCM_in=>TB_DTCM_in,
			TB_DTCM_out=>TB_DTCM_out,
			TB_DTCM_R_Addr=>TB_DTCM_R_Addr,
			TB_DTCM_W_Addr=>TB_DTCM_W_Addr,
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
			R15=>R15,
			Cflag=>Cflag,
			Zflag=>Zflag,
			Nflag=>Nflag,
			Message=>Message
			);


		clk <= not clk after ton; --ton = half clock = 50 ns
		
		import_ITC: process	--ITCMinit.txt
			file infile : text open read_mode is read_file_loc;
			variable L2: line;
			variable in_dataIn : bit_vector(Dwidth-1 downto 0);
			variable good : boolean;
		begin
			while not endfile (infile) loop
				readline(infile,L2);
				hread (L2,in_dataIn,good);
				next when not good;
				wait until (clk'event and clk='0');
				TB_ITCM_in <= to_stdlogicvector(in_dataIn);
			end loop;
		file_close(infile);
		wait;
		end process;
--------------------------------------------------------------------------
		import_DTC: process --DTCMinit.txt
			file infile : text open read_mode is read_file_loc2;
			variable L2: line;
			variable in_dataIn : bit_vector(Dwidth-1 downto 0);
			variable good : boolean;
		begin
			while not endfile (infile) loop
				readline(infile,L2);
				hread (L2,in_dataIn,good);
				next when not good;
				wait until (clk'event and clk='0');
				TB_DTCM_in <= to_stdlogicvector(in_dataIn);
			end loop;
		file_close(infile);
		wait;
		end process;
-------------------------------------------------------------------------
		Print_at_end: process	--DTCMcontent.txt
			file outfile: text open write_mode is write_file_loc;
			variable L2: line;
		begin
		TB_DTCM_R_Addr <= "ZZZZZZ";
		TB_active <= '1','0' after 6400 ns; 	--we have 16 lines in ITCM.txt
		wait until (done = '1');
		TB_DTCM_R_Addr <= "000000";
		TB_active<='1';
		wait for 10 ns;
			for i in 1 to 64 loop				--we have 15 lines in DTCM.txt
				TB_DTCM_R_Addr <= TB_DTCM_R_Addr + 1;
				hwrite(L2,TB_DTCM_out);
				writeline (outfile,L2);
				wait for 10 ns;
			end loop;				
		file_close(outfile);
		wait;
		end process;
--------------------------------------------------------------------------
		start_and_import_txt: process --the lines order and reading timing
		begin
		ena <='0','1' after 6400 ns;			--we have 16 lines in ITCM.txt
		rst <='1','0' after 100 ns;				--reset
		TB_DTCM_wren <='1','0' after 6400 ns; 	--we have 15 lines in DTCM.txt
		TB_ITCM_wren <='1','0' after 6400 ns; 	--we have 16 lines in ITCM.txt
		TB_DTCM_W_Addr<="000000";					--start import from line 0
		TB_ITCM_W_Addr<="000000";					--start import from line 0
		wait for 100 ns;
		for j in 1 to 64 loop					--keep running 15 lines 
			TB_ITCM_W_Addr <= TB_ITCM_W_Addr + 1;
			TB_DTCM_W_Addr <= TB_DTCM_W_Addr + 1;
			wait for 100 ns;
		end loop;
		wait;
		end process;
		

end rtc;