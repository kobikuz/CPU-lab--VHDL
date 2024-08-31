library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top is
	GENERIC (  n : INTEGER := 8;
		   k : INTEGER := 3;   -- k=log2(n)
		   m : INTEGER := 4); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		clk, enable, reset : in std_logic;
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
		--pwm_o :out std_logic
	); -- Zflag,Cflag,Nflag,Vflag
	end component;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      vout,s, cout: OUT std_logic);
	end component;
---------------------------------------------------------	
	component MATHS is
		GENERIC (n : INTEGER := 8);
		PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 vout, cout : OUT STD_LOGIC);
	end component;	
--------------------------------------------------------
	component LOGIC IS
  		GENERIC (n : INTEGER := 8);
		PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		 vout,cout : OUT STD_LOGIC);
	END component;
--------------------------------------------------------	
	component shifter IS
	 	 GENERIC (n : INTEGER := 8;
		    	  k : INTEGER := 3);
		PORT (Y,X: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  	ALUFN : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			  s: OUT STD_LOGIC_VECTOR(n-1 downto 0);
			vout, cout : OUT STD_LOGIC); 
	end component;
	--------------------------------------------------------
	
component top_pwm IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT(   
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  clk, enable, reset : in std_logic;
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC;
		  pwm_o : OUT std_logic;
		   curr_o  : out std_logic_vector (7 downto 0)
  ); -- Zflag,Cflag,Nflag,Vflag
END component;
--------------------------------------------------------
component counter is port (
  clk,enable,reset_q : in std_logic;
  q : out std_logic_vector (7 downto 0));
end component;

--------------------------------------------------------
component To7seg IS
  PORT (    
			BCDin: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      Hex7seg: OUT STD_LOGIC_VECTOR(13 downto 0));
      
END component;
--------------------------------------------------------
component kitIO IS
  GENERIC (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer :=4); -- m=2^(k-1)
  PORT 
  (  	----------INPUTS----------
		PLL: IN STD_LOGIC;
		SW_Input: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		Y_ena : IN STD_LOGIC;
		X_ena : IN STD_LOGIC;
		ALU_ena:IN STD_LOGIC;
		enable: IN std_logic;
		reset: IN std_logic;
		----------LED&HEX----------
		Y_hex_out: 	OUT STD_LOGIC_VECTOR(n-1 downto 0); --HEX
		X_hex_out: 	OUT STD_LOGIC_VECTOR(n-1 downto 0); -- HEX
		ALU_led_out:OUT STD_LOGIC_VECTOR( 4  downto 0);
		----------OUTPUTS----------
		Result_hex_out:		OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); ---HEX 
		ALU_hex_out : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); ---HEX 
		N_flag: 	OUT STD_LOGIC;
		C_flag: 	OUT STD_LOGIC;
		Z_flag: 	OUT STD_LOGIC;
		V_flag: 	OUT STD_LOGIC;
		pmw_output: out std_logic
  );
END component;

--------------------------------------------------------
component CounterEnvelope is 
  port (
    Clk, En : in std_logic;
    Qout    : out std_logic_vector(7 downto 0)
  ); 
end component;
--------------------------------------------------------
component counterpll is 
  port (
    clk, enable : in std_logic;
    q           : out std_logic
  ); 
end component;
--------------------------------------------------------
component PLL_4 is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic         -- outclk0.clk
	);
end component;

component PWM is
    generic (
        n : integer := 8
    );
    port (
        x, y       : in std_logic_vector (n-1 downto 0);
        ALU20      : in std_logic_vector (2 downto 0);
        clk, enable,reset : in std_logic;
		--Cflag_o,Vflag_o : out  std_logic;
        s_out      : out std_logic;
        curr_o     : out std_logic_vector (7 downto 0)
    );
end component;	

	
end aux_package;

