LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY kitIO IS
  GENERIC (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer :=4); -- m=2^(k-1)
  PORT 
  (  	----------INPUTS----------
		Clkin: IN STD_LOGIC;
		SW_Input: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		Y_ena : IN STD_LOGIC;
		X_ena : IN STD_LOGIC;
		ALU_ena:IN STD_LOGIC;
		enable: IN std_logic;
		reset: IN std_logic;
		----------LED&HEX----------
		Y_hex_out: 	OUT STD_LOGIC_VECTOR(13 downto 0); --HEX
		X_hex_out: 	OUT STD_LOGIC_VECTOR(13 downto 0); -- HEX
		ALU_led_out:OUT STD_LOGIC_VECTOR( 4  downto 0);
		----------OUTPUTS----------
		Result_hex_out:		OUT STD_LOGIC_VECTOR(13 DOWNTO 0); ---HEX 
		--ALU_hex_out : OUT STD_LOGIC_VECTOR(13 DOWNTO 0); ---HEX 
		N_flag: 	OUT STD_LOGIC;
		C_flag: 	OUT STD_LOGIC;
		Z_flag: 	OUT STD_LOGIC;
		V_flag: 	OUT STD_LOGIC;
		
		pmw_output: out std_logic
  );
END kitIO;
-------------------------kitIO Architecture code ------------------------
ARCHITECTURE structs OF kitIO IS 

	------------- TOP's inputs after registers ------------------
	signal Y_in : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal X_in : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal ALU_in : STD_LOGIC_VECTOR (4 DOWNTO 0);
	signal pll2m,divclk : std_logic;
	signal CEclk :  std_logic_vector(7 downto 0);
	--signal clkin_inputCLKENA0 : std_logic := '1'; -- Force clock enable to be always active
	signal V_flag_b1,Z_flag_b1,C_flag_b1,N_flag_b1 : STD_LOGIC;
	signal V_flag_b2,Z_flag_b2,C_flag_b2,N_flag_b2 : STD_LOGIC;
	------------- TOP's inputs after registers ------------------
	signal Result : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	
BEGIN

			Top_map :top generic map (n,k) PORT map(
			Y_i=>Y_in,
			X_i=>X_in,
			ALUFN_i=>ALU_in,
			ALUout_o=>Result,
			clk=>CEclk(0), -- was6
			enable=>enable,
			reset=>reset,
			Nflag_o=>N_flag_b1,
			Cflag_o=>C_flag_b1,
			Zflag_o=>Z_flag_b1,
			Vflag_o=>V_flag_b1
			--pwm_o=>pmw_output
			);
			
		--	pll_map: PLL_4 PORT MAP(
		--	refclk=>Clkin,  
		--	rst=>reset,
		--	outclk_0 =>pll2m
		--	);
			
			pmw_map: top_pwm generic map (n,k,m) port map(  
			Y_i=>Y_in,
			X_i=>X_in,
			ALUFN_i=>ALU_in,
			clk=>CEclk(0),
			enable=>enable,
			reset=>reset,
			pwm_o=>pmw_output,
			Nflag_o=>N_flag_b2,
			Cflag_o=>C_flag_b2,
			Zflag_o=>Z_flag_b2,
			Vflag_o=>V_flag_b2
  ); 
     -- fifth: counterpll port map (
    --    clk => pll2m,
     --   enable => enable,
     --   q => divclk
	--	);
		
		clockin: CounterEnvelope port map(
		Clk=> Clkin,
		En=>enable,
		Qout => CEclk
		);
	
			convert_X : To7seg PORT map(X_in		,X_hex_out		);
			  
			convert_Y : To7seg PORT map(Y_in		,Y_hex_out		);
		 
		 	convert_S : To7seg PORT map(Result	,Result_hex_out);
			ALU_led_out <=ALU_in;
			N_flag<=N_flag_b1 when ALU_in(4 downto 3)= "01" or ALU_in(4 downto 3)= "11" or ALU_in(4 downto 3)= "10" else N_flag_b2 when ALU_in(4 downto 3)= "00";
			C_flag<=C_flag_b1 when ALU_in(4 downto 3)= "01" or ALU_in(4 downto 3)= "11" or ALU_in(4 downto 3)= "10" else N_flag_b2 when ALU_in(4 downto 3)= "00";
			Z_flag<=Z_flag_b1 when ALU_in(4 downto 3)= "01" or ALU_in(4 downto 3)= "11" or ALU_in(4 downto 3)= "10" else N_flag_b2 when ALU_in(4 downto 3)= "00";
			V_flag<=V_flag_b1 when ALU_in(4 downto 3)= "01" or ALU_in(4 downto 3)= "11" or ALU_in(4 downto 3)= "10" else N_flag_b2 when ALU_in(4 downto 3)= "00";
			--process(clk,X_ena,ALU_ena,Y_ena)
			process(X_ena,ALU_ena,Y_ena)
			begin
				--if rising_edge(clk) and X_ena='0' then
				if X_ena='0' then
					X_in <= SW_Input;
					end if;
				--if rising_edge(clk) and ALU_ena='0' then
				if ALU_ena='0' then
					ALU_in <= SW_Input(4 DOWNTO 0);
					end if;
				--if rising_edge(clk) and Y_ena='0' then
				if Y_ena='0' then
					Y_in <= SW_Input;
					end if;
			end process;	
					

			
			
			

			
	

	
END structs;

