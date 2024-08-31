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
		  clk, enable, reset : in std_logic;
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
		 -- pwm_o : OUT std_logic
		--   curr_o  : out std_logic_vector (7 downto 0)
  ); -- Zflag,Cflag,Nflag,Vflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	signal X_buff,Y_buff,ALUout_buff :std_logic_vector(n-1 downto 0);
	signal ALUin_buff :std_logic_vector(4 downto 0);
	signal C_buff,Z_buff,V_buff,N_buff: std_logic ;
	signal x_math_in,y_math_in,math_out :std_logic_vector(n-1 downto 0);
	signal x_log_in,y_log_in,log_out :std_logic_vector(n-1 downto 0);
	signal x_shifter_in,y_shifter_in,shifter_out :std_logic_vector(n-1 downto 0);
	signal x_pmw_in,y_pmw_in:std_logic_vector(n-1 downto 0);
	signal math_cout, log_cout, shifter_cout,pmw_cout : std_logic;
	signal pwm_out,divclk : std_logic;
	signal math_vout, log_vout, shifter_vout,pmw_vout : std_logic;
	signal ans: std_logic_vector(n-1 downto 0);
	signal check_z_flag: std_logic_vector(n-1 downto 0);

BEGIN
	check_z_flag <= (others => '0');
 process (clk)
  begin
    if rising_edge(clk) then
      X_buff <= X_i;
      Y_buff <= Y_i;
      ALUout_buff <= ans;
      ALUin_buff <= ALUFN_i;
      
      if ALUFN_i(4 downto 3) = "01" then
        C_buff <= math_cout;
      elsif ALUFN_i(4 downto 3) = "11" then
        C_buff <= log_cout;
      elsif ALUFN_i(4 downto 3) = "10" then
        C_buff <= shifter_cout;
      else
        C_buff <= '0';
      end if;
      
      if ALUout_buff = check_z_flag then
        Z_buff <= '1';
      else
        Z_buff <= '0';
      end if;
      
      if math_vout = '1' then
        V_buff <= '1';
      else
        V_buff <= '0';
      end if;
      
      if (ALUFN_i(4 downto 3) = "10" or ALUFN_i(4 downto 3) = "01" or ALUFN_i(4 downto 3) = "11") then
        N_buff <= ALUout_buff(n-1);
      else
        N_buff <= '0';
      end if;
    end if;
  end process;
	
	x_math_in <= X_buff when  ALUin_buff(4 downto 3) ="01" else UNAFFECTED;
	y_math_in <= Y_buff when  ALUin_buff(4 downto 3) ="01" else UNAFFECTED;
	
	x_log_in <= X_buff when  ALUin_buff(4 downto 3) ="11" else UNAFFECTED;
	y_log_in <= Y_buff when  ALUin_buff(4 downto 3) ="11" else UNAFFECTED;

	x_shifter_in <= X_buff when  ALUin_buff(4 downto 3) ="10" else UNAFFECTED;
	y_shifter_in <= Y_buff when  ALUin_buff(4 downto 3) ="10" else UNAFFECTED;
	


	----mapping---
	first: MATHS generic map (n) port map(
		X => x_math_in,
		Y=> y_math_in,
		ALUFN => ALUin_buff(2 DOWNTO 0),
		cout => math_cout,
		s => math_out ,
		vout =>math_vout
);
	second: shifter generic map(n) port map(
		X => x_shifter_in,
		Y=> y_shifter_in,
		ALUFN => ALUin_buff(2 DOWNTO 0),
		cout => shifter_cout,
		vout => shifter_vout,
		s => shifter_out
);
	third: LOGIC generic map(n) port map(
		X => x_log_in,
		Y=> y_log_in,
		ALUFN => ALUin_buff(2 DOWNTO 0),
		cout => log_cout,
		vout => log_vout,
		s => log_out
);



	
	---- output mux---
	ans <=  math_out when ALUin_buff(4 downto 3) ="01" else 	
		log_out  when ALUin_buff(4 downto 3) ="11" else 
		shifter_out  when ALUin_buff(4 downto 3) ="10" else 
		unaffected;
	ALUout_o <= ans;



	Zflag_o <= Z_buff;
	Nflag_o <= N_buff;
	Cflag_o <= C_buff;
	Vflag_o <= V_buff;
		 
END struct;

