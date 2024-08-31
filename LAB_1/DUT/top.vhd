LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT(
    
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	signal x_math_in,y_math_in,math_out :std_logic_vector(n-1 downto 0);
	signal x_log_in,y_log_in,log_out :std_logic_vector(n-1 downto 0);
	signal x_shifter_in,y_shifter_in,shifter_out :std_logic_vector(n-1 downto 0);
	signal math_cout, log_cout, shifter_cout : std_logic;
	signal math_vout, log_vout, shifter_vout : std_logic;
	signal ans: std_logic_vector(n-1 downto 0);
	signal check_z_flag: std_logic_vector(n-1 downto 0);

BEGIN
	x_math_in <= X_i when  ALUFN_i(4 downto 3) ="01" else UNAFFECTED;
	y_math_in <= Y_i when  ALUFN_i(4 downto 3) ="01" else UNAFFECTED;
	
	x_log_in <= X_i when  ALUFN_i(4 downto 3) ="11" else UNAFFECTED;
	y_log_in <= Y_i when  ALUFN_i(4 downto 3) ="11" else UNAFFECTED;

	x_shifter_in <= X_i when  ALUFN_i(4 downto 3) ="10" else UNAFFECTED;
	y_shifter_in <= Y_i when  ALUFN_i(4 downto 3) ="10" else UNAFFECTED;
	
	check_z_flag <= (others => '0');
	----mapping---
	first: MATHS generic map (n) port map(
		X => x_math_in,
		Y=> y_math_in,
		ALUFN => ALUFN_i(2 DOWNTO 0),
		cout => math_cout,
		s => math_out ,
		vout =>math_vout
);
	second: shifter generic map(n,k) port map(
		X => x_shifter_in,
		Y=> y_shifter_in,
		ALUFN => ALUFN_i(2 DOWNTO 0),
		cout => shifter_cout,
		vout => shifter_vout,
		s => shifter_out
);
	third: LOGIC generic map(n) port map(
		X => x_log_in,
		Y=> y_log_in,
		ALUFN => ALUFN_i(2 DOWNTO 0),
		cout => log_cout,
		vout => log_vout,
		s => log_out
);
	
	---- output mux---
	ans <=  math_out when ALUFN_i(4 downto 3) ="01" else 	
		log_out  when ALUFN_i(4 downto 3) ="11" else 
		shifter_out  when ALUFN_i(4 downto 3) ="10" else 
		(others => '0');
	ALUout_o <= ans;

	Zflag_o <= '1' when (ans=check_z_flag) else'0';
	Nflag_o <= ans(n-1);
	Cflag_o <= math_cout when ALUFN_i(4 downto 3) ="01" else 	
		log_cout  when ALUFN_i(4 downto 3) ="11" else 
		shifter_cout  when ALUFN_i(4 downto 3) ="10" else 
		 '0';
	Vflag_o <= '1' when (math_vout = '1') else '0';
		 
END struct;

